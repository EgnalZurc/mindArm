#include <stdio.h>
#include <errno.h>

#include <wiringPi.h>
#include <gertboard.h>
#include <softPwm.h>

#define PWMMIN      5
#define PWMMAX      22
#define PWMERROR    4
#define INITPOS     13
#define PWMOFF      0

//Usage 1 to 18
int getPWMPot(int voltaje)
{
  int pot = voltaje + PWMERROR;
  if (pot == PWMMIN-1) return 0;
  if (pot >= PWMMAX) return PWMMAX;
  if (pot <= PWMMIN) return PWMMIN;
  return pot;
}

void unlockServo(int SERV)
{
  pwmWrite(SERV, PWMOFF);
}

int loadServoMotor (int SERV)
{
  int degrees;

  printf("Loading servo motor in PIN %d\n", SERV);

  // Initialise wiringPi
  if (wiringPiSetup () == -1)
  {
    printf("Error loading wiringPi: %s\n", strerror (errno) );
    return -1;
  }

  pinMode(SERV, PWM_OUTPUT);
  pwmSetMode(PWM_MODE_MS);
  pwmSetClock (1920); //clock at 50Hz
  pwmSetRange (200) ;

  pwmWrite(SERV, INITPOS);
  delay(1000);
  unlockServo(SERV);

  return 0 ;
}
