#include <stdio.h>

#include <wiringPi.h>
#include <gertboard.h>

#define TEMPA 0
#define TEMPB 1
#define TEMPC 2
#define TEMPD 3

int     initTempSensor  (int sensor);
double  getTemperature  (int sensor);

int     loadDevices     ();
