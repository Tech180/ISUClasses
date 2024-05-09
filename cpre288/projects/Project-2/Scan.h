/*
 * Scan.h
 *
 *  Created on: Apr 14, 2021
 *      Author: dwdodson
 */

#ifndef SCAN_H_
#define SCAN_H_

#include "Servo.h"
#include "adc.h"
#include "ping.h"
#include "uart.h"
#include <math.h>

typedef enum {RedPeg, WhitePeg, Incomplete}Peg_dat;

typedef struct{
    float sound_dist;  // Distance from Ping Sensor
    int IR_raw_val;    // Raw ADC value from IR sensor
} Scan_data;

typedef struct{
    int angle; //degrees
    float distance; //cm
    float width; //cm
    Peg_dat type;
} Object_data;

void scan_init();

void scan(int angle, Scan_data* data);

int findObjects(Object_data objects[], int sizeOfObject);



#endif /* SCAN_H_ */
