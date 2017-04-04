#include <stdio.h>
#include <errno.h>
#include <sys/time.h>
#include <time.h>
#include <unistd.h>

#include <wiringPi.h>

void printTime ()
{
  struct timeval tv;
  struct tm* ptm;
  char time_string[40];
  long milliseconds;

  /* Obtain the time of day, and convert it to a tm struct.  */
  gettimeofday (&tv, NULL);
  ptm = localtime (&tv.tv_sec);
  /* Format the date and time, down to a single second.  */
  strftime (time_string, sizeof (time_string), "%H:%M:%S", ptm);
  /* Compute milliseconds from microseconds.  */
  milliseconds = tv.tv_usec;
  /* Print the formatted time, in seconds, followed by a decimal point
   *      and the milliseconds.  */
  printf ("%s.%03ld  ", time_string, milliseconds);
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
