/*
 * movement.h
 *
 *  Created on: Feb 11, 2021
 *      Author: dwdodson
 */

#ifndef MOVEMENT_H_
#define MOVEMENT_H_

#include "open_interface.h"
#include "Scan.h"

double move_forward(oi_t *sensor_data, double distance_mm);
//double move_forwardB(oi_t *sensor_data, double distance_mm, bool &bump);
double turn_left(oi_t *sensor_data, double degrees);
double turn_left_dist(oi_t *sensor_data, double degrees);
double turn_right(oi_t *sensor_data, double degrees);
double turn_right_dist(oi_t *sensor_data, double degrees);
double move_backwards(oi_t *sensor_data, double distance_mm);
//double maneuver(double distance_mm, oi_t *sensor_data);
void maneuver(double distance_mm, oi_t *sensor_data);
void movet_peg(oi_t *sensor_data);
void movea_peg(oi_t *sensor_data);
void outputPegData(Object_data object[], int numObjects);

void peg_check(Object_data *objectArr, int objectSize);
bool colorCheck(float distance, float width, int angle);
int updateRedPegArray(Object_data *redpegs, Object_data *scandata, int sizeofObjects);
int updateWhitePegArray(Object_data *whitepegs, Object_data *scandata, int sizeofObjects);

#endif /* MOVEMENT_H_ */
