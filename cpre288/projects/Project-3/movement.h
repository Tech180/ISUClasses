/*
 * movement.h
 *
 *  Created on: Feb 11, 2021
 *      Author: dwdodson
 */

#ifndef MOVEMENT_H_
#define MOVEMENT_H_

#include "movement.h"
#include "lcd.h"
#include "open_interface.h"
#include "Scan.h"
#include "uart.h"


double move_forward(oi_t *sensor_data, double distance_mm);
//double move_forwardB(oi_t *sensor_data, double distance_mm, bool &bump);
double turn_left(oi_t *sensor_data, double degrees);
double turn_right(oi_t *sensor_data, double degrees);
double move_backwards(oi_t *sensor_data, double distance_mm);

bool cliff_detected(oi_t *sensor_data);
bool park(oi_t *sensor_data, float distance);
void find_HomeBase(oi_t *sensor_data);
bool homebase_check(oi_t *sensor_data);

void maneuver(oi_t *sensor_data, float distance_mm);

void PIZZATIME();

void peg_check(Object_data *objectArr, int objectSize);
bool whiteOrRed(float distance, float width, int angle);
int updateRedPegArray(Object_data *redpegs, Object_data *scandata, int sizeofObjects);
int updateWhitePegArray(Object_data *whitepegs, Object_data *scandata, int sizeofObjects);

void outputPegData(Object_data object[], int numObjects);

#endif /* MOVEMENT_H_ */
