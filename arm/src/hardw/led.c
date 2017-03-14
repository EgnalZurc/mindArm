#include <stdio.h>
#include <errno.h>

#include <wiringPi.h>

void writeLed (int PIN, int STR)
{
  pinMode(PIN, OUTPUT);
  if(STR == 1)
  {
    printf("Turning on LED %d\n", &PIN);
    digitalWrite(PIN, HIGH);
  }
  else
  {
    printf("Turning off LED %d\n", &PIN);
    digitalWrite(PIN, LOW);
  }
}
