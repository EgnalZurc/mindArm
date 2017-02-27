#include "deviceStarter.h"

int loadDevices ()
{
  printf("Loading devices...\n");

  // Initialise wiringPi
  if (wiringPiSetup () == -1)
    return -1 ;

  // Initialise temperature sensors
  if (initTempSensor (TEMPA) == TEMPA)
    return TEMPA;

  return 0;
}
