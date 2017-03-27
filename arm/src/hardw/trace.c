#include <stdio.h>
#include <errno.h>

#include <wiringPi.h>

int SERVA = 1;
int SERVB = 0;
int SERVC = -1;
int SERVD = 0;

void readTrace (int *SA, int *SB, int *SC, int *SD)
{
  *SA = SERVA;
  *SB = SERVB;
  *SC = SERVC;
  *SD = SERVD;
}
