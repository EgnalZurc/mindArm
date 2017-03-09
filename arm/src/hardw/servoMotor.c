#include <stdio.h>
#include <errno.h>

#include <wiringPi.h>
#include <gertboard.h>

int blink (void)
{
  wiringPiSetup () ;
  pinMode (21, OUTPUT) ;
  for (;;)
  {
    digitalWrite (21, HIGH) ; delay (500) ;
    digitalWrite (21,  LOW) ; delay (500) ;
  }
  return 0 ;
}

int loadServoMotor (int SERV)
{
  int bright;
  printf("Loading servo motor in pin: %d\n", SERV);

  // Initialise wiringPi
  if (wiringPiSetup () == -1)
  {
    printf("Error loading wiringPi: %s\n", strerror (errno) );
    return -1;
  }

  //Turn on the power on led
  //pinMode (15, OUTPUT) ;
  //digitalWrite (15, LOW) ;

  // Initialise servo motor
  pinMode   (SERV, PWM_OUTPUT);
  for (bright = 0 ; bright < 1024 ; bright ++)
  {
    pwmWrite  (SERV, bright);
    delay (100);
  }

  return 0;
}
