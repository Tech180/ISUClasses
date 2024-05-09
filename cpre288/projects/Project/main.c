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
#include "cyBot_FindObjects.h"
#include "open_interface.h"
void putty(const char *string);

int main(void) {
    button_init();
    timer_init(); // Must be called before lcd_init(), which uses timer functions
    lcd_init();
    uart_init();
    // Don't forget to initialize the cyBot UART before trying to use it
    //resetSimulationBoard();
    oi_t *sensor_data = oi_alloc(); // do this only once at start of main()
    oi_init(sensor_data); // do this only once at start of main()


    int numObjects;

    cyBot_Object_t object[20];

    numObjects = cyBot_FindObjects(object, 20);

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

    movet_peg(sensor_data);



}

/*
void putty(const char *string){

    int i;

    for(i = 0; i < strlen(string); i++){
        cyBot_sendByte(string[i]);
    }
}
*/
