#include "temperature.h"

int    initTempSensor  (int sensor)
{
  int value;

  pinMode(sensor, INPUT);

  if(analogRead (sensor) > 0) return 0 ;
  return sensor;
}

double  getTemperature  (int sensor)
{
  double voltaje;

  // Convert to a voltage:
  voltaje = (double)analogRead (sensor) / 1023.0 * 3.3 ;

  // Convert Temperature of the LM35 reading to a temperature: 0.01 volts per C.
  return (voltaje * 100.0) ;
}
