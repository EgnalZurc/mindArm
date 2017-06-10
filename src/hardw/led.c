#include <stdio.h>
#include <errno.h>
#include <sys/time.h>
#include <time.h>
#include <unistd.h>

#include <wiringPi.h>

int printTime ()
{
  struct timeval tv;
  float secs, usec, formatedSec;

  gettimeofday(&tv, NULL);

  return tv.tv_usec;
}

void writeLed (int PIN, int STR)
{
  pinMode(PIN, OUTPUT);
  if(STR == 1)
  {
    digitalWrite(PIN, HIGH);
  }
  else
  {
    digitalWrite(PIN, LOW);
  }
}
