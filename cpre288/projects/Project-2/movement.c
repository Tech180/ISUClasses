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
//#include "Servo.h"
//#include "ping.c"
//#include "cyBot_FindObjects.h"

double move_forward(oi_t *sensor_data, double distance_mm)
{

    oi_setWheels(500, 500); //move forward at full speed
    double sum = 0;

    while (sum <= distance_mm) {

        if(sensor_data-> bumpLeft || sensor_data-> bumpRight){
            break;
        }
        else if(sensor_data -> cliffLeft || sensor_data -> cliffRight){
            break;
        }
        else if(sensor_data->cliffRightSignal > 2600 || sensor_data->cliffLeftSignal > 2600 || sensor_data->cliffFrontLeftSignal > 2600 || sensor_data->cliffFrontRightSignal > 2600) {
           break;
       }
        else
        {
            oi_update(sensor_data);
            sum += sensor_data->distance;
            // use -> notation since pointer
        }

    }

    oi_setWheels(0,0); //stop

    return sum;
}

double move_backwards(oi_t *sensor_data, double distance_mm)
{
    oi_setWheels(-500, -500); //move forward at full speed
    double sum = 0;


    while ((-1 * sum <= distance_mm))
    {

        oi_update(sensor_data);
        sum += sensor_data->distance; // use -> notation since pointer

    }

    oi_setWheels(0,0); //stop

    return (sum);
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

void homebase_check(oi_t *sensor_data, Object_data objectArr[], int objectArrSize)
{
    int numObjects = 0;
    int i = 0;
    int j = 0;
    float moveForwardRightAngle = 0;
    //float travelDist = 0;
    float widthRange = 8;
    float c = 0.0;
    int angleC = 0;
    int angleB = 0;
    //bool pizzaDelivered = false;
    Object_data closestPeg1;
    Object_data closestPeg2;
    Object_data homebaseCheck[objectArrSize];

    // Before anything is detected make sure your are lined up
    // Then Scan
    // Then do calculation of distance



//    while (!pizzaDelivered)
//    {
        numObjects = findObjects(objectArr, objectArrSize);

        // Check for two closest small pegs
        for (i = 0; i < numObjects; i++)
        {
            if (objectArr[i].width <= widthRange)
            {
                if (objectArr[i].distance < 130 && objectArr[i].distance > 70 && objectArr[i].width <= 7)
                {
                    homebaseCheck[j] = objectArr[i];
                    j++;
                    //uart_sendChar('1');
                }
                else if (objectArr[i].distance <= 70 && objectArr[i].width < 8)
                {
                    homebaseCheck[j] = objectArr[i];
                    j++;
                    //uart_sendChar('1');
                }

            }
        }

        // If there are at least 2 small pegs detected move into the area of homebase
        if (j >= 2)
        {
            if (homebaseCheck[1].distance > homebaseCheck[0].distance)
            {
                closestPeg1 = homebaseCheck[0];
                closestPeg2 = homebaseCheck[1];
            }
            else
            {
                closestPeg1 = homebaseCheck[1];
                closestPeg2 = homebaseCheck[0];
            }

            // Check for two closest pegs
            for (i = 2; i < j; i++)
            {
                if (homebaseCheck[i].distance < closestPeg2.distance
                        || homebaseCheck[i].distance < closestPeg1.distance)
                {
                    if (closestPeg1.distance > homebaseCheck[i].distance)
                    {
                        closestPeg2 = closestPeg1;
                        closestPeg1 = homebaseCheck[i];
                    }

                    else if ((closestPeg1.distance != homebaseCheck[i].distance)
                            && (homebaseCheck[i].distance < closestPeg1.distance))
                    {
                        closestPeg2 = homebaseCheck[i];
                    }
                }
            }

            // ClosestPeg1 is always the a distance
            // ClosestPeg2 is always the b distance

            // Subtract angle one of the peg from angle 2
            if (closestPeg2.angle > closestPeg1.angle)
            {
                angleC = closestPeg2.angle - closestPeg1.angle;

            }
            else
            {
                angleC = closestPeg1.angle - closestPeg2.angle;
                Object_data temp = closestPeg1;
                closestPeg1 = closestPeg2;
                closestPeg2 = temp;
            }


            c = sqrtf(powf(closestPeg1.distance, 2) + powf(closestPeg2.distance, 2) - (2 * closestPeg2.distance * closestPeg1.distance * cosf((angleC * M_PI)/180)));
            angleB = (acos((pow(c, 2) + pow(closestPeg1.distance, 2) - pow(closestPeg2.distance, 2)) /
                           (2 * c * closestPeg1.distance))) * 180 / M_PI;



            // Point to farthest away peg
            turn_right(sensor_data, closestPeg1.angle - 90);



            // Adjust perpendicular
            turn_left(sensor_data, angleB);
            int part1 = (sin(90 / 180 * M_PI));
            int part2 = sin((angleB + angleC) / 180.0 * M_PI);
            moveForwardRightAngle = (closestPeg2.distance  / (sin(90 / 180 * M_PI) * sin((angleB + angleC) / 180.0 * M_PI)));
            //move_forward(sensor_data, (moveForwardRightAngle * 100.0));
            //move_forward(sensor_data, (c / 2) * 100);

        }
        // One small peg is detected
        else if (j == 1)
        {
            closestPeg1 = homebaseCheck[0];
            if (closestPeg1.angle > 90)
            {
                turn_right(sensor_data, (closestPeg1.angle - 90));
                move_forward(sensor_data, (closestPeg1.distance / 2) * 100);
            }
        }


    char str1[300];

    outputPegData(objectArr, numObjects);
    outputPegData(homebaseCheck, j);
    sprintf(str1, "Peg1 %f\n\rPeg2 %f\n\rDistance C %f\n\rAngle B %d\n\rAngle C %d\n\r"
            "MoveForwardValue %f\n\r", closestPeg1.distance, closestPeg2.distance, c, angleB, angleC, moveForwardRightAngle);


    uart_sendStr(str1);

}


    // Check to see if anything is in direct range
    // If not move the distance of the shortest peg
    // Direct path within 70 to 110 is no no



//void movearound
//{
//
//    if(homebass == found)
//}

double turn_right_dist(oi_t *sensor_data, double degrees)
{
    double sum = 0;
    oi_setWheels(100, -100); //move forward at full speed

    while (sum <= (degrees - 8))
    {
        oi_update(sensor_data);
        sum += sensor_data->angle; // use -> notation since pointer
    }

    oi_setWheels(0, 0); //stop

    return sum;
}

double turn_left_dist(oi_t *sensor_data, double degrees)
{
    double sum = 0;
    oi_setWheels(-100, 100); //move forward at full speed

    while ((sum * -1) <= (degrees - 8))
    {
        oi_update(sensor_data);
        sum += sensor_data->angle; // use -> notation since pointer
    }

    oi_setWheels(0, 0); //stop

    return sum;
}


int updateWhitePegArray(Object_data whitepegs[], Object_data scandata[], int sizeOfObjects) {

    int i = 0;
    int j = 0;


    for(i = 0; i < sizeOfObjects; i++) {
        if(scandata[i].type == WhitePeg){
            whitepegs[i] = scandata[i];
            j++;
        }
    }
    return j++;
}

int updateRedPegArray(Object_data redpegs[],  Object_data scandata[], int sizeOfObjects) {

    int i = 0;
    int j = 0;

    for(i = 0; i < sizeOfObjects; i++) {
        if(scandata[i].type == RedPeg){
            redpegs[i] = scandata[i];
        }
    }
    return j;
}

bool colorCheck(float distance, float width, int angle) {

    //white
    if(angle > 30 && angle < 130) {
        if(width < 6.5 && width > 3.2 && distance <= 40)
        {
            return true;
        }
        else if(width < 7 && distance > 40 && distance <= 60)
        {
            return true;
        }
        else if(width < 7.5 && distance > 60 && distance <= 86)
        {
            return true;
        }
        else if(width < 10.2 && distance > 86)
        {
            return true;
        }
    }

    //red
    else {
        if(width < 6.5 && width > 3.2 && distance <= 40)
        {
            return true;
        }
        else if(width < 7 && distance > 40 && distance <= 60)
        {
            return true;
        }
        else if(width < 7.5 && distance > 60 && distance <= 86)
        {
            return true;
        }
        else if(width < 9.2 && distance > 86)
        {
            return true;
        }
    }

    return false;
}

/*
void avoidCollision(oi_t *sensor_data, int size){

    Object_data object[20];
    Object_data redPegData[20];
    Object_data whitePegData[20];
    Object_data avoiding[size];

    int numObjects = findObjects(object, 20);
    peg_check(object, numObjects);
    int numRedPegs = updateRedPegArray(redPegData, object, numObjects);
    int numWhitePegs = updateWhitePegArray(whitePegData, object, numObjects);

    Object_data avoidPeg;

        //numObjects = findObjects(object, 20);

    //lcd_printf("%d" , cyBot_FindObjects(object, 20));

    double wid = object[0].width;
    int ang = object[0].angle;
    double distance = object[0].distance;

    double offset = 10.0;

    int i;
    int j = 0;

    for (i = 1; i < numObjects; i++) {

        if (object[i].width < wid) {
            wid = object[i].width;

            distance = object[i].distance;

            ang = object[i].angle;

        }
    }


    bool colors = colorCheck(distance, wid, ang);

    if(colors == false) {
        avoidPeg = whitePegData[i];

        //while(j != 1) {
            for (i = 1; i < numWhitePegs; i++) {
                if(numWhitePegs == 1) {
                    if(avoidPeg.angle > 90) {
                        if(avoidPeg.distance < 15) {
                           //move_backwards(sensor_data, (avoidPeg.distance / 2) * 10);
                           //turn_right(sensor_data, avoidPeg.angle - 90);

                            //break;
                        }
                        if(avoidPeg.distance >= 15 && avoidPeg.distance <= 60) {

                        }
                    }

                    else if(avoidPeg.angle > 90) {
                        if(avoidPeg.distance < 10) {
                           //move_backwards(sensor_data, (avoidPeg.distance / 2) * 10);
                           //turn_left(sensor_data, avoidPeg.angle - 90);


                           // break;
                        }
                    }

                }
                else if(numWhitePegs > 1) {

                }
            }
            //break;
       // }



        //search to check if peg is close
        for (i = 1; i < numWhitePegs; i++) {
            avoidPeg = whitePegData[i];
        }

        /*
        //check for two closest pegs
        for (i = 0; i < numObjects; i++) {
            if (objectArr[i].width <= widthRange) {
               if (objectArr[i].distance < 130 && objectArr[i].distance > 70 && objectArr[i].width <= 7) {
                   homebaseCheck[j] = objectArr[i];
                   j++;
                   //uart_sendChar('1');
               }
               else if (objectArr[i].distance <= 70 && objectArr[i].width < 8)
               {
                   homebaseCheck[j] = objectArr[i];
                   j++;
                   //uart_sendChar('1');
               }

            }
       }
       */
    /*
    }

    else if(colors == true) {
        //manuever();
        movet_peg(sensor_data);
    }

    while (distance - offset > 0) {

       if (ang <= 90) {
           turn_left(sensor_data, (90 - ang));
       }
       else if (ang > 90) {
           turn_right(sensor_data, (ang - 90));
       }

       //distance = move_forward(sensor_data, ((distance - offset) * 10));

       /*
       if(sensor_data -> bumpRight){
           move_backwards(sensor_data, 150);
           turn_left(sensor_data, 90);
           move_forward(sensor_data, 250);
           turn_right(sensor_data, 90);
       }
       if(sensor_data -> bumpLeft){
           move_backwards(sensor_data, 150);
           turn_right(sensor_data, 90);
           move_forward(sensor_data, 250);
           turn_left(sensor_data, 90);
       }
       */
/*
       findObjects(object, 20);

       for (i = 1; i < numObjects; i++) {

           if (object[i].width < wid) {

               wid = object[i].width;

               distance = object[i].distance;

               ang = object[i].angle;

           }
       }

   }



}
*/
void movet_peg(oi_t *sensor_data) {

    int numObjects;
    Object_data object[20];

    numObjects = findObjects(object, 20);

    //lcd_printf("%d" , cyBot_FindObjects(object, 20));

    double smallWid = object[0].width;

    int smallAng = object[0].angle;

    double distance = object[0].distance;

    double offset = 10.0;

    int i;

    for (i = 1; i < numObjects; i++) {

        if (object[i].width < smallWid)
        {

            smallWid = object[i].width;

            distance = object[i].distance;

            smallAng = object[i].angle;

        }
    }

    while (distance - offset > 0) {

        if (smallAng <= 90) {
            turn_left(sensor_data, (90 - smallAng));
        }
        else if (smallAng > 90) {
            turn_right(sensor_data, (smallAng - 90));
        }

        distance = move_forward(sensor_data, ((distance - offset) * 10));

        if(sensor_data -> bumpRight){
            move_backwards(sensor_data, 150);
            turn_left(sensor_data, 90);
            move_forward(sensor_data, 250);
            turn_right(sensor_data, 90);
        }
        if(sensor_data -> bumpLeft){
            move_backwards(sensor_data, 150);
            turn_right(sensor_data, 90);
            move_forward(sensor_data, 250);
            turn_left(sensor_data, 90);
        }

        findObjects(object, 20);

        for (i = 1; i < numObjects; i++) {

            if (object[i].width < smallWid) {

                smallWid = object[i].width;

                distance = object[i].distance;

                smallAng = object[i].angle;

            }
        }

    }

}



/*
void movet_peg(oi_t *sensor_data)
{
    int i;
    Object_data object[20];
    //int numObjects = cyBot_FindObjects(object, 20);
    int numObjects = findObjects(object, 20);


    outputPegData(object, numObjects);

    double smallWid = object[0].width;
    int smallAng = object[0].angle;
    double distance = object[0].distance * 10;
    double offset = 12.0 * 10;

    for (i = 0; i < numObjects; i++)
    {
        if (object[i].width < smallWid)
        {
            smallWid = object[i].width;
            distance = object[i].distance * 10;
            smallAng = object[i].angle;
        }
    }

    while (((distance - offset) ) > 0)
    {
        double mDistance = 500;
        if (smallAng <= 90)
        {
            if(distance > 500)
            {
                turn_left_dist(sensor_data, (90 - smallAng));
            }
            else
            {
                turn_left(sensor_data, (90 - smallAng));
            }
        }
        else if (smallAng > 90)
        {
            if(distance > 500)
            {
                turn_right_dist(sensor_data, (smallAng - 90));
            }
            else
            {
                turn_right(sensor_data, (smallAng - 90));
            }
        }

        if(distance - offset < 500)
        {
            mDistance = (distance - offset);
        }

        move_forward(sensor_data, mDistance);

        if (sensor_data->bumpRight)
        {
            move_backwards(sensor_data, 150);
            turn_left(sensor_data, 90);
            move_forward(sensor_data, 270);
            turn_right(sensor_data, 90);
        }
        if (sensor_data->bumpLeft)
        {
            move_backwards(sensor_data, 150);
            turn_right(sensor_data, 90);
            move_forward(sensor_data, 270);
            turn_left(sensor_data, 90);
        }
        //numObjects = cyBot_FindObjects(object, 20);

        numObjects = findObjects(object, 20);
        outputPegData(object, numObjects);

        smallWid = object[0].width;
        smallAng = object[0].angle;
        distance = object[0].distance * 10;

        for (i = 0; i < numObjects; i++)
        {
            if (object[i].width < smallWid)
            {
                smallWid = object[i].width;
                distance = object[i].distance * 10;
                smallAng = object[i].angle;
            }
        }
    }
}
*/

void peg_check(Object_data objectArr[], int objectSize)
{
    int i = 0;
    for(i = 0; i < objectSize; i++)

    if(objectArr[i].width < 3.1)
    {
        objectArr[i].type = Incomplete;
    }
    else if(colorCheck(objectArr[i].distance, objectArr[i].width, objectArr[i].angle))
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
    char string[30] = "";
    int i = 0;
    uart_sendStr("Object#\t\tAngle\t\tDistance\tWidth\n\r");
    for (i = 0; i < numObjects; i++)
    {
        sprintf(string, "%d\t\t%d\t\t%f\t%f\n\r", i + 1, object[i].angle, object[i].distance, object[i].width);
        uart_sendStr(string);
    }
}

