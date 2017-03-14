#include <stdio.h>
#include <errno.h>

#include <wiringPi.h>

void readTrace (int *SERVA, int *SERVB, int *SERVC, int *SERVD)
{
  *SERVA = 13;
  *SERVB = 13;
  *SERVC = 13;
  *SERVD = 13;
}
