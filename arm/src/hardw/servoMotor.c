#include <stdio.h>
#include <errno.h>

#include <wiringPi.h>
#include <gertboard.h>
#include <softPwm.h>

#define PWMMIN      5
#define PWMMAX      22
#define PWMERROR    4
#define INITPOS     13

//Usage 1 to 18
int getPWMPot(int voltaje)
{
  int pot = voltaje + PWMERROR;
  if (pot == PWMMIN-1) return 0;
  if (pot >= PWMMAX) return PWMMAX;
  if (pot <= PWMMIN) return PWMMIN;
  return pot;
}

int loadServoMotor (int SERV)
{
  int degrees;

  if (wiringPiSetup () == -1) //using wPi pin numbering
     return (1) ;

  pinMode(SERV, PWM_OUTPUT);
  pwmSetMode(PWM_MODE_MS);
  pwmSetClock (1920); //clock at 50Hz
  pwmSetRange (200) ;

  pwmWrite(SERV, INITPOS);

  return 0 ;
}
