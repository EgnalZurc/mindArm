#include <stdio.h>
#include <errno.h>

#include <wiringPi.h>
#include <gertboard.h>
#include <softPwm.h>

#define MAXTIME 360 //Maximum time to press button: 1 min

int loadPressure (int PRES)
{
  int elapTime;
  
  printf("Loading pressure sensor in PIN %d\n", PRES);

  // Initialise wiringPi
  if (wiringPiSetup () == -1)
  {
    printf("Error loading wiringPi: %s\n", strerror (errno) );
    return -1;
  }

  pinMode(PRES, INPUT);

  for (elapTime = 0 ; elapTime < MAXTIME ; elapTime ++)
  {
    if (digitalRead(PRES)) return 0;
    delay (10);
  }

  return -2 ;
}
