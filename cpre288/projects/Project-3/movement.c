/*
 * movement.c
 *
 *  Created on: Feb 11, 2021
 *      Author: dwdodson
 */


#include "movement.h"
#include "lcd.h"
#include "open_interface.h"
#include "Scan.h"
#include "uart.h"

double move_forward(oi_t *sensor_data, double distance_mm)
{

    oi_setWheels(500, 500); //move forward at full speed
    double sum = 0;

    while (sum <= distance_mm)
    {
        oi_update(sensor_data);
        if (sensor_data->cliffRightSignal > 2600
                || sensor_data->cliffLeftSignal > 2600
                || sensor_data->cliffFrontLeftSignal > 2600
                || sensor_data->cliffFrontRightSignal > 2600
                ){
            break;
        }
        else if(sensor_data->bumpLeft && sensor_data->bumpRight) {
            break;
        }
        else if(sensor_data->bumpRight){
            break;
        }
        else if(sensor_data->bumpLeft){
            break;
        }
        else if(sensor_data->cliffRight || sensor_data->cliffLeft) {
            break;
        }
        else if (sensor_data->cliffFrontLeft || sensor_data->cliffFrontRight){
            break;
        }
        else
        {
            sum += sensor_data->distance;
            oi_update(sensor_data);
        }
    }

    oi_setWheels(0, 0); //stop

    return sum;
}

double move_backwards(oi_t *sensor_data, double distance_mm)
{
    oi_setWheels(-500, -500); //move forward at full speed
    double dist = 0;


    while ((-1 * dist <= distance_mm))
    {

        oi_update(sensor_data);
        dist += sensor_data->distance; // use -> notation since pointer
    }

    oi_setWheels(0,0); //stop

    return (dist);
}

double turn_right(oi_t *sensor_data, double degrees)
{
    double angle = 0;
    oi_setWheels(250, -250); //move forward at full speed

    while (angle < (degrees - 7))
    {
        oi_update(sensor_data);
        angle += sensor_data->angle; // use -> notation since pointer
    }

    oi_setWheels(0,0); //stop

    return angle;
}

double turn_left(oi_t *sensor_data, double degrees)
{
    double angle = 0;
    oi_setWheels(-250, 250); //move forward at full speed

    while (angle < (degrees - 7))
    {
        oi_update(sensor_data);
        angle -= sensor_data -> angle; // use -> notation since pointer
    }


    oi_setWheels(0,0); //stop

    return angle;
}

void maneuver(oi_t *sensor_data, float distance_mm)
{

    float distance = 0;
    while (distance < distance_mm)
    {
        distance += move_forward(sensor_data, distance);

        if (sensor_data->bumpLeft && sensor_data->bumpRight)
        {
            move_backwards(sensor_data, 100);
            turn_right(sensor_data, 90);
            distance += move_forward(sensor_data, 250);
//        turn_left(sensor_data, 90);
        }
        //left
        else if (sensor_data->bumpLeft)
        {
            move_backwards(sensor_data, 100);
            turn_right(sensor_data, 90);
            distance += move_forward(sensor_data, 250);
            turn_left(sensor_data, 90);
//        move_forward(sensor_data, 500);
//        turn_left(sensor_data, 90);
//        move_forward(sensor_data, 250);
//        turn_right(sensor_data, 90);

        }
        //right
        else if (sensor_data->bumpRight)
        {
            move_backwards(sensor_data, 100);
            turn_left(sensor_data, 90);
            distance += move_forward(sensor_data, 250);
            turn_right(sensor_data, 90);
//        move_forward(sensor_data, 500);
//        turn_right(sensor_data, 90);
//        move_forward(sensor_data, 250);
//        turn_left(sensor_data, 90);
        }

        //cliff left
        else if (sensor_data->cliffLeft)
        {
            move_backwards(sensor_data, 50);
            turn_right(sensor_data, 90);
            distance += move_forward(sensor_data, 300);
            turn_left(sensor_data, 90);
            //move_forward(sensor_data, 200);
        }

        //cliff right
        else if (sensor_data->cliffRight)
        {
            move_backwards(sensor_data, 50);
            turn_left(sensor_data, 90);
            distance += move_forward(sensor_data, 300);
            //turn_right(sensor_data, 90);
            //move_forward(sensor_data, 200);
        }
        //cliff Front left
        else if (sensor_data->cliffFrontLeft)
        {
            move_backwards(sensor_data, 50);
            turn_right(sensor_data, 90);
            distance += move_forward(sensor_data, 300);
            //turn_left(sensor_data, 90);
            //move_forward(sensor_data, 200);
        }

        //cliff Front right
        else if (sensor_data->cliffFrontRight)
        {
            move_backwards(sensor_data, 50);
            turn_left(sensor_data, 90);
            distance += move_forward(sensor_data, 300);
            //turn_right(sensor_data, 90);
            //move_forward(sensor_data, 200);
        }
        else if (sensor_data->cliffFrontRightSignal > 2600)
        {
            move_backwards(sensor_data, 50);
            turn_left(sensor_data, 113);
        }
        else if (sensor_data->cliffFrontLeftSignal > 2600)
        {
            move_backwards(sensor_data, 50);
            turn_left(sensor_data, 113);
        }
        else if (sensor_data->cliffRightSignal > 2600)
        {
            move_backwards(sensor_data, 50);
            turn_left(sensor_data, 115);
        }
        else if (sensor_data->cliffLeftSignal > 2600)
        {
            move_backwards(sensor_data, 50);
            turn_left(sensor_data, 111);
        }
    }

    oi_update(sensor_data);

}

void find_HomeBase(oi_t *sensor_data)
{
    int i;
    bool pizzaDelivered = false;
    bool goHome = false;
    Object_data objectInfo[20];
    Object_data redPegData[20];
    Object_data whitePegData[20];
    Object_data closestPeg;

    while(!pizzaDelivered)
    {

        int numObjects = findObjects(objectInfo, 20);
        peg_check(objectInfo, numObjects);
        int numRedPegs = updateRedPegArray(redPegData, objectInfo, numObjects);
        int numWhitePegs = updateWhitePegArray(whitePegData, objectInfo, numObjects);
        uart_sendStr("\n\rAll\n\r\n\r");
        outputPegData(objectInfo, numObjects);
        uart_sendStr("Red\n\r\n\r");
        outputPegData(redPegData, numRedPegs);
        uart_sendStr("White\n\r\n\r");
        outputPegData(whitePegData, numRedPegs);

        if(numRedPegs >= 1)
        {
             closestPeg = redPegData[0];
             for(i = 0; i < numRedPegs; i++)
             {
                 if(redPegData[i].distance < closestPeg.distance)
                 {
                     closestPeg = redPegData[i];
                 }
             }
        }

        int angle = closestPeg.angle;

        if(numRedPegs >= 1)
        {

            for(i = 0; i < numRedPegs; i++)
            {
                if(redPegData[i].distance < 32)
                {
                    goHome = true;
                }
            }



            if(goHome)
            {
                pizzaDelivered = homebase_check(sensor_data);
                closestPeg = redPegData[0];

                if(!pizzaDelivered)
                {
                    // If we return from homebase scan again
                    move_backwards(sensor_data, 100);
                    turn_left(sensor_data, 90);
                    uart_sendStr("\n\r*** Navigation Failed, Scanning Values again ***\n\r");
                    numObjects = findObjects(objectInfo, 20);
                    peg_check(objectInfo, numObjects);
                    numRedPegs = updateRedPegArray(redPegData, objectInfo,
                                                   numObjects);
                    numWhitePegs = updateWhitePegArray(whitePegData, objectInfo,
                                                       numObjects);
                    uart_sendStr("\n\rAll\n\r\n\r");
                    outputPegData(objectInfo, numObjects);
                    uart_sendStr("Red\n\r\n\r");
                    outputPegData(redPegData, numRedPegs);
                    uart_sendStr("White\n\r\n\r");
                    outputPegData(whitePegData, numWhitePegs);

                    for (i = 0; i < numRedPegs; i++)
                    {
                        if (redPegData[i].distance < closestPeg.distance)
                        {
                            closestPeg = redPegData[i];
                        }
                    }
                }
            }

            if (closestPeg.angle <= 90 && !pizzaDelivered)
            {
                turn_left(sensor_data, (90 - angle - 5));
            }
            else if (closestPeg.angle > 90)
            {
                turn_right(sensor_data, (closestPeg.angle - 90 + 5));
            }

            if(closestPeg.distance > 60 && !pizzaDelivered)
            {
                maneuver(sensor_data, 300);
            }
            else if((closestPeg.distance < 60) && (closestPeg.distance > 30) && !pizzaDelivered)
            {
                maneuver(sensor_data, (closestPeg.distance * 10) - 300);
                //move_forward(sensor_data, (closestPeg.distance * 10) - 300);
            }
        }
        else
        {
            maneuver(sensor_data, 300);
        }
        if (pizzaDelivered)
        {
            uart_sendStr("\n\rPizza Time!!!\n\r");

        }
    }
    if(pizzaDelivered)
    {
        PIZZATIME();
        lcd_printf("Pizza Time!");
    }

}

bool park(oi_t *sensor_data, float distance)
{
    int i = 0;
    int j = 0;
    Object_data object[20];
    Object_data redPegData[20];
    Object_data whitePegData[20];

//    Object_data leftObject;
//    bool leftObjectFound = false;
//    int leftTest = 0.0;

//    Object_data rightObject;
//    bool rightObjectFound = false;
//    int rightTest = 0.0;
//
//    bool fault = false;

    int numObjects = findObjects(object, 20);
    peg_check(object, numObjects);
    int numRedPegs = updateRedPegArray(redPegData, object, numObjects);
    int numWhitePegs = updateWhitePegArray(whitePegData, object, numObjects);

//    uart_sendStr("All Objects\n\r");
//    outputPegData(object, numObjects);
//    uart_sendStr("Red Pegs\n\r");
//    outputPegData(redPegData, numRedPegs);
//    uart_sendStr("White Pegs\n\r");
//    outputPegData(whitePegData, numWhitePegs);

    for(i = 0; i < numObjects; i++)
    {
        if((object[i].distance <= (distance + 5)) && (object[i].distance >= (distance - 5.0)))
        {
            j++;
        }
    }

    if(j >= 3)
    {
        uart_sendStr("\n\r *** Obstacle in way of Navigation *** \n\r");
        move_backwards(sensor_data, 50);
        turn_right(sensor_data, 90);
        //move_forward(sensor_data, 300);
        //maneuver(sensor_data, 300);
        maneuver(sensor_data, 400);
        turn_left(sensor_data, 90);
        move_forward(sensor_data, 80);
        return false;
    }

    move_forward(sensor_data, (distance * 10) + 320);

    if (sensor_data->cliffRightSignal > 2600
            || sensor_data->cliffLeftSignal > 2600
            || sensor_data->cliffFrontLeftSignal > 2600
            || sensor_data->cliffFrontRightSignal > 2600
            || sensor_data->bumpLeft
            || sensor_data->bumpRight
            || sensor_data->cliffRight
            || sensor_data->cliffLeft
            || sensor_data->cliffFrontLeft
            || sensor_data->cliffFrontRight)
    {
        uart_sendStr("\n\r *** Obstacle in way of Navigation *** \n\r");
        move_backwards(sensor_data, 50);
        turn_right(sensor_data, 90);
        maneuver(sensor_data, 00);
        turn_left(sensor_data, 90);
        move_forward(sensor_data, 80);
        return false;
    }

    return true;
}

bool cliff_detected(oi_t *sensor_data){
    if(sensor_data->cliffRight || sensor_data->cliffLeft  || sensor_data->bumpLeft ||
            sensor_data->bumpRight || sensor_data->cliffFrontLeft || sensor_data->cliffFrontRight)
    {
        turn_right(sensor_data, 180);
        maneuver(sensor_data, 400);
        return true;
    }
    return false;
}

bool homebase_check(oi_t *sensor_data)
{
    int i = 0;
    int j = 0;
    float pathB = 0;
    float pathA = 0.0;
    float c = 0.0;
    bool pizzaDelivered = false;
    bool reset = false;
    int angleC = 0;
    int angleB = 0;
    int angleA = 0;
    Object_data closestPeg1;
    Object_data closestPeg2;

    Object_data objectInfo[20];
    Object_data redPegData[20];
    Object_data whitePegData[20];

    while (!pizzaDelivered && !reset)
    {
        int numObjects = findObjects(objectInfo, 20);
        peg_check(objectInfo, numObjects);
        int numRedPegs = updateRedPegArray(redPegData, objectInfo, numObjects);
        int numWhitePegs = updateWhitePegArray(whitePegData, objectInfo, numObjects);

        outputPegData(objectInfo, numObjects);
        outputPegData(redPegData, numRedPegs);

        if (numRedPegs >= 2)
        {
            if (redPegData[1].distance > redPegData[0].distance)
            {
                closestPeg1 = redPegData[0];
                closestPeg2 = redPegData[1];
            }
            else
            {
                closestPeg1 = redPegData[1];
                closestPeg2 = redPegData[0];
            }

            // Check for two closest pegs
            for (i = 2; i < numRedPegs; i++)
            {
                if (redPegData[i].distance < closestPeg2.distance
                        || redPegData[i].distance < closestPeg1.distance)
                {
                    if (closestPeg1.distance > redPegData[i].distance)
                    {
                        closestPeg2 = closestPeg1;
                        closestPeg1 = redPegData[i];
                    }
                    else if (redPegData[i].distance < closestPeg2.distance)
                    {
                        closestPeg2 = redPegData[i];
                    }
                }
            }


            angleC = abs(closestPeg2.angle - closestPeg1.angle);

            c = sqrtf(powf(closestPeg1.distance, 2) + powf(closestPeg2.distance, 2) - (2 * closestPeg2.distance * closestPeg1.distance
                     * cosf((angleC * M_PI) / 180)));

            char str1[20];
            sprintf(str1, "\n\r***   Distance between: %f  ***\n\r", c);


            if(c > 69 && c < 50)
            {
                reset = true;
            }

            if (!reset)
            {
                // On Left side, away from pegs
                uart_sendStr(str1);
                 uart_sendStr("\n\r***           2 Red Pegs detected          ***\n\r");
                 uart_sendStr("\n\r*** Path found attempting to deliver pizza ***\n\r");
                if ((closestPeg1.angle < closestPeg2.angle) && (angleC < 50))
                {
                    angleB = (acos((pow(c, 2) + pow(closestPeg2.distance, 2)- pow(closestPeg1.distance, 2))
                                                / (2 * c * closestPeg2.distance))) * 180/ M_PI;

                    // Point to farthest away peg
                    if (closestPeg2.angle < 90)
                        turn_left(sensor_data, 90 - closestPeg2.angle);
                    else
                        turn_right(sensor_data, closestPeg2.angle - 90);

                    // Adjust perpendicular
                    turn_right(sensor_data, angleB);
                    //float part1 = 1;
                    //float part2 = sinf((angleB + angleC) / 180.0 * M_PI);
                    pathB = (closestPeg1.distance / 1
                            * sinf((angleB + angleC) / 180.0 * M_PI));

                    pathA = sqrt(
                            (powf(closestPeg1.distance, 2) - powf(pathB, 2)));

                    //move_forward(sensor_data,(c / 2 * 10) + (pathA * 10) + 100);
                    maneuver(sensor_data,(c / 2 * 10) + (pathA * 10) + 100);

                    if(!cliff_detected(sensor_data))
                    {
                        turn_left(sensor_data, 90);
                        pizzaDelivered = park(sensor_data, pathB);
                    }
                    else
                    {
                        pizzaDelivered = false;
                        reset = true;
                    }
                }
                // On right side away from both pegs
                else if ((closestPeg1.angle > closestPeg2.angle) && (angleC < 50))
                {
                    angleB = (acos((pow(c, 2) + pow(closestPeg2.distance, 2)- pow(closestPeg1.distance, 2))
                            / (2 * c * closestPeg2.distance))) * 180/ M_PI;

                    // Point to farthest away peg
                    if(closestPeg2.angle < 90)
                       turn_left(sensor_data, 90 - closestPeg2.angle);
                    else
                       turn_right(sensor_data, closestPeg2.angle - 90);


                    // Adjust perpendicular
                    turn_left(sensor_data, angleB);
                    //float part1 = 1;
                    //float part2 = sinf((angleB + angleC) / 180.0 * M_PI);
                    pathB = (closestPeg1.distance / 1
                            * sinf((angleB + angleC) / 180.0 * M_PI));

                    pathA = sqrt((powf(closestPeg1.distance, 2) - powf(pathB, 2)));

                    //move_forward(sensor_data, (c / 2 * 10) + (pathA * 10) + 80);
                    maneuver(sensor_data, (c / 2 * 10) + (pathA * 10) + 80);

                    if(!cliff_detected(sensor_data))
                    {
                        turn_right(sensor_data, 90);
                        pizzaDelivered = park(sensor_data, pathB);
                    }
                    else
                    {
                        pizzaDelivered = false;
                        reset = true;
                    }
                }
                // On Left Side of cybot, in between pegs
                else if ((closestPeg1.angle > closestPeg2.angle) && (angleC >= 50))
                {
                    angleA = (acos((pow(c, 2) + pow(closestPeg2.distance, 2) - pow(closestPeg1.distance, 2))
                             / (2 * c * closestPeg2.distance))) * 180/ M_PI;

                    // Adjust perpendicularly
                    if(closestPeg2.angle < 90)
                        turn_left(sensor_data, 90 - closestPeg2.angle);
                    else
                        turn_right(sensor_data, closestPeg2.angle - 90);
                    turn_left(sensor_data, angleA);
                    //float part1 = 1;
                    //float part2 = sinf((angleB + angleC) / 180.0 * M_PI);
                    pathB = (closestPeg1.distance * sinf((angleB + angleC) / 180.0 * M_PI));

                    pathA = sqrt((powf(closestPeg1.distance, 2) - powf(pathB, 2)));


                    //move_forward(sensor_data, (c/2 * 10) - (pathA * 10) - 80);
                    maneuver(sensor_data, (c/2 * 10) - (pathA * 10) - 80);
                    if(!cliff_detected(sensor_data))
                    {
                        turn_right(sensor_data, 90);
                        pizzaDelivered = park(sensor_data, pathB);
                    }
                    else
                    {
                        pizzaDelivered = false;
                        reset = true;
                    }

                }
                // On Right Side of cybot, in between pegs
                else if ((closestPeg1.angle < closestPeg2.angle) && (angleC >= 50))
                {
                    angleA = (acos((pow(c, 2) + pow(closestPeg2.distance, 2) - pow(closestPeg1.distance, 2))
                             / (2 * c * closestPeg2.distance))) * 180/ M_PI;

                    // Adjust perpendicularly
                    if(closestPeg2.angle < 90)
                        turn_left(sensor_data, 90 - closestPeg2.angle);
                    else
                        turn_right(sensor_data, closestPeg2.angle - 90);
                    turn_right(sensor_data, angleA);
                    //float part1 = 1;
                    //float part2 = sinf((angleB + angleC) / 180.0 * M_PI);
                    pathB = (closestPeg1.distance * sinf((angleB + angleC) / 180.0 * M_PI));

                    pathA = sqrt((powf(closestPeg1.distance, 2) - powf(pathB, 2)));


                    //move_forward(sensor_data, (c/2 * 10) - (pathA * 10));
                    maneuver(sensor_data, (c/2 * 10) - (pathA * 10));

                    if(!cliff_detected(sensor_data))
                    {
                        turn_right(sensor_data, 90);
                        pizzaDelivered = park(sensor_data, pathB);
                    }
                    else
                    {
                        pizzaDelivered = false;
                        reset = true;
                    }
                }
            }
        }
        else if(numRedPegs == 1 && j <= 4 && !reset)
        {
            closestPeg1 = redPegData[0];
            if(j <= 4 && closestPeg1.distance < 45)
            {
                j++;
                move_backwards(sensor_data, 5);
            }
            else
            {
                reset = true;
            }
        }
        else if(!reset)
        {
            uart_sendStr("*** Re-Calibrating ***\n\r\n\r");
            move_backwards(sensor_data, 50);
            turn_left(sensor_data, 30);
            pizzaDelivered = false;
            reset = true;
        }
    } // while loop

    return pizzaDelivered;
}


int updateWhitePegArray(Object_data whitepegs[], Object_data scandata[], int sizeofObjects)
{
    int i = 0;
    int j = 0;

    for(i = 0; i < sizeofObjects; i++)
    {
        if(scandata[i].type == WhitePeg)
        {
            whitepegs[j] = scandata[i];
            j++;
        }
    }
    return j;
}

int updateRedPegArray(Object_data redpegs[], Object_data scandata[], int sizeofObjects)
{
    int i = 0;
    int j = 0;

    for(i = 0; i < sizeofObjects; i++)
    {
        if(scandata[i].type == RedPeg)
        {
            redpegs[j] = scandata[i];
            j++;
        }
    }
    return j;
}

// Returns true if the peg is a red peg, false otherwise
bool whiteOrRed(float distance, float width, int angle)
{
    if(angle > 30 && angle < 130)
    {
        if(width < 7.8 && width > 1.5 && distance <= 40)
        {
            return true;
        }
        else if(width < 7.8 && distance > 40 && distance <= 53)
        {
            return true;
        }
        else if(width < 7.8 && distance > 52 && distance <= 75)
        {
            return true;
        }
        else if(width < 7.8 && distance > 75 && distance <= 87.9)
        {
            return true;
        }
        else if(width < 7.8 && distance && width > 3.23 > 87.9)
        {
            return true;
        }
    }
    else
    {
        if(width < 7.8 && width > 1.9 && distance <= 40)
        {
            return true;
        }
        else if(width < 7.8 && distance > 40 && distance <= 60)
        {
            return true;
        }
        else if(width < 7.8 && distance > 60 && distance <= 86)
        {
            return true;
        }
        else if(width < 5 && width > 3.23 && distance > 86)
        {
            return true;
        }
    }

    return false;
}

void peg_check(Object_data objectArr[], int objectSize)
{
    int i = 0;
    for(i = 0; i < objectSize; i++)

    if(objectArr[i].width < 3.1)
    {
        objectArr[i].type = Incomplete;
    }
    else if(whiteOrRed(objectArr[i].distance, objectArr[i].width, objectArr[i].angle))
    {
        objectArr[i].type = RedPeg;
    }
    else
    {
        objectArr[i].type = WhitePeg;
    }
}

void outputPegData(Object_data object[], int numObjects)
{
    char string[300] = "";
    int i = 0;
    uart_sendStr("Object#\t\tAngle\t\tDistance\tWidth\n\r");
    for (i = 0; i < numObjects; i++)
    {
        sprintf(string, "%d\t\t%d\t\t%f\t%f\n\r", i + 1, object[i].angle, object[i].distance, object[i].width);
        uart_sendStr(string);
    }
}

void PIZZATIME()
{
    uart_sendStr(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,....                 ....,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,,,,,,,,,,,,,,,.       ..,,,*****,.,*****,,,.        .,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,,,,,,,,,,.      .,**************,.,**************,.     ..,,,,,,,,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,,,,,,..    .,*******************,.,*******************,.    .,,,,,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,,,,.   .,,**********************,.,**********************,.    .,,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,.    ,**************************,.,*************************,.   .,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,.    .,***************************,.,***************************,    .,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,.   ,*,,***************************,.,***************************,.*.   .,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,.   .***..***************************. .***************************..***.   ,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,.   ,****,.,***********************,..,.,.,************************,.,****,   .,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,.  .,*****,.,*********************,.,,*,.,*,..,*********************,.******,   .,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,.  .,*******.,*******************,.,****,.,****,.,*******************,,*******,   .,,,,,,,,\n\r");
     uart_sendStr(",,,,,.  .,********,.,**************,..,*******,.,*******,.,,**************,.*********,   ,,,,,,,,\n\r");
     uart_sendStr(",,,,,.  ,**********..********,  .,************,.************,,.  .,,*****,.,**********,  .,,,,,,,\n\r");
     uart_sendStr(",,,,.  .***********. ,************************,.************************,. ,***********.  ,,,,,,,\n\r");
     uart_sendStr(",,,,. .,***********...,***********************,.************************,...***********,. .,,,,,,\n\r");
     uart_sendStr(",,,,  .***********,.*,.***********************,.,**********************,.,,.,***********. .,,,,,,\n\r");
     uart_sendStr(",,,,  .**********,.,**,.**********************,.,*********************,.,**,.,**********. .,,,,,,\n\r");
     uart_sendStr(",,,,  .*********..*****,.*********************,.,********************,.,****,.,*********.  ,,,,,,\n\r");
     uart_sendStr(",,,,  .***..,,..,*******,.,*******************,.********************,.,*******,.,*,..***. .,,,,,,\n\r");
     uart_sendStr(",,,,  .**.    ,**********,.,*****************,. .,*****************,.,**********,    .,*. .,,,,,,\n\r");
     uart_sendStr(",,,,  .,,       ,*********,.,*************,..,,.,,..,*************.,**********.      .,,. .,,,,,,\n\r");
     uart_sendStr(",,,,  .*,          .,*******,.********,..,,***,.****,,.,,********.,*******,.          ,*. .,,,,,,\n\r");
     uart_sendStr(",,,,  .*.             .,*****,.,....,,********,.*********,,......,*****,.             ,*. .,,,,,,\n\r");
     uart_sendStr(",,,,  .,.      ##*.      .,*,...,*************,.**************,.,.,*,.      ,/%/      .*. .,,,,,,\n\r");
     uart_sendStr(",,,,. .,.     .&&@&@&#,     .***.,,***********,.************,.,**,.    .*#@@&&@%.     .,. .,,,,,,\n\r");
     uart_sendStr(",,,,.  ,.     *@@&@@@&&@&(.   .,**.,**********,.***********,.,*,    .#&@@@&&@@&&.     ,,  .,,,,,,\n\r");
     uart_sendStr(",,,,,  ,,.    *@@&@@@@&@@&@&(.   ,,.,*********,.,*********,.,.   ,#&@&&&&&@&&&@&.    .*.  ,,,,,,,\n\r");
     uart_sendStr(",,,,,  .*.    .&&@&&@@@&&@&&@&#.   ,..********,.,*******,...   ,%@&@@&@&&&@&&&@%.    ,*. .,,,,,,,\n\r");
     uart_sendStr(",,,,,. .,*.    #@&@@&&&&@@&&@@&@#.  ...,******,.,******,..   ,%@&@&&&@&@@&@&&&@*    .*,  .,,,,,,,\n\r");
     uart_sendStr(",,,,,.  ...    .%@&@&&@@@@@@@&@@&&(   ..,*****,.,*****..   .(&&@&&@@@@@&&@&@@@#.   ....  .,,,,,,,\n\r");
     uart_sendStr(",,,,,,. .**,.   .%@@@@@@@@@@&@@&@&&#,   ..,***,.,**,,..   ,%@&&&&@@@@@@&&&&&&#.   .**,. .,,,,,,,,\n\r");
     uart_sendStr(",,,,,,.  ,***.   .#&@@@@@@@@@&&@&@&@%,    .,**,.,**..    *&@&@&@@@@@@@@&&@&&(    ,***.  .,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,. .****,.   *%@&@@&&@@&&&&@&&@#,     .,...,.     ,&@&&@&&@&&@@@@&@@%*   .****,. .,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,.  ,*****,    *#&@&@@&@&@@&&@&(.  .,*, **,.,*,   .#&@@&&&@&&&&&&&#,   .,*****.  .,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,. .,******,.    ,/#%&&&&&%(*.   ,***, ... ,***.   .*#%&&&&&%#/,    .,******,  .,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,.  .*********,.              .,****,.,***,.*****,.              .,*********. .,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,.  ,**********,.....    ..,*******.,*****.,*******,..    ....,,**********.  ,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,.  ,******,..********,..,,*****,,,*******.,*******..,********,..,******,  .,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,.  ,**,.,***************,.,***,.,********.,***..,***************..,**.  .,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,.   ,********************,.,,.,**,,,,***,.,,.*********************.   ,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,.  ,*********************. ..,,*****,,.  .********************,.  .,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,,,   ,*******************.,*************,.*******************,   ,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,,,,,   ,****************..***************,,****************,   ,,,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,,,,,,.   ,*************..****************,.,*************.   ,,,,,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,,,,,,,,,.  .**********,.******************,.,**********.  .,,,,,,,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,,,,,,,,,,,.  .,******,.,*******************,.,******,.  .,,,,,,,,,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,,,,,,,,,,,,,.  .,****.,,,,,,...........,,,,,,.****,   .,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,.  .*..,,*******************,,.,,.  .,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.   .,*********************,.   ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,..    ....,,,,,,....     ..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.............,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\n\r");
     uart_sendStr("\n\r");
}

