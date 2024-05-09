/**
 * lab3_template.c
 * 
 * Template file for CprE 288 lab 3
 *
 * @author Zhao Zhang, Chad Nelson, Zachary Glanz
 * @date 08/14/2016
 */

#include "button.h"
#include "Timer.h"
#include "lcd.h"
#include "movement.h"
#include "resetSimulation.h"
#include "uart.h"  // Functions for communicating between CyBot and Putty (via UART)
//#include "cyBot_FindObjects.h"
#include "open_interface.h"
#include "Scan.h"
#include "Servo.h"

int main(void) {

    button_init();
    timer_init(); // Must be called before lcd_init(), which uses timer functions
    lcd_init();
    uart_init();
    scan_init();

    Object_data objectInfo[20];
    Object_data redPegData[20];
    Object_data whitePegData[20];

    int numObjects = findObjects(objectInfo, 20);
    peg_check(objectInfo, 20);

    int numRedPegs = updateRedPegArray(redPegData, objectInfo, numObjects);
    int numWhitePegs = updateWhitePegArray(whitePegData, objectInfo, numObjects);

    outputPegData(objectInfo, numObjects);
    outputPegData(redPegData, numRedPegs);
    outputPegData(whitePegData, numWhitePegs);


    // Don't forget to initialize the cyBot UART before trying to use it
    //resetSimulationBoard();
    oi_t *sensor_data = oi_alloc(); // do this only once at start of main()
    oi_init(sensor_data); // do this only once at start of main()

        //cyBot_Object_t object[20];
        Object_data object[20];

        //numObjects = cyBot_FindObjects(object, 20);
        numObjects = findObjects(object, 20);

        //lcd_printf("%d" , cyBot_FindObjects(object, 20));

        int i;
        uart_sendStr("Object#\tAngle\t\tDistance\tWidth\n");

        double smallWid = object[0].width;

        int smallAng = object[0].angle;

        double smallDist = object[0].distance;

        char string[30];


            //cyBot_sendByte(i + 1);
            //lcd_printf("%d", object[i].angle);
            //cyBot_sendByte(object[i].angle);
            //cyBot_sendByte(object[i].distance);
            //cyBot_sendByte(object[i].width);

        for(i = 0; i < numObjects; i++) {

            sprintf(string, "%d\t%d\t%f\t%f\n", i + 1, object[i].angle, object[i].distance, object[i].width);

                if(object[i].width < smallWid) {

                    smallWid = object[i].width;

                    smallDist = object[i].distance;

                    smallAng = object[i].angle;

                 }
        }

        uart_sendStr(string);

        //turn_right(sensor_data, 90);
        //turn_left(sensor_data, 90);
        //turn_right(sensor_data, 90);
        //turn_right(sensor_data, 90);


        //move_forward(sensor_data, 100);


        movet_peg(sensor_data);


}
