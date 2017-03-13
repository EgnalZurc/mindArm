#include <wiringPi.h>
#include <softPwm.h>

#include<stdio.h>
#include<stdlib.h>
#include <time.h>
#include <stdlib.h>

#define PWMMIN    5
#define PWMMAX    22
#define PWMERROR  4

#define SERVO       1
#define SERVOSOFT   2
#define PRESSURE    3
#define TEMPERATURE 4

//Usage 1 to 18
int getPWMPot(int voltaje)
{
  int pot = voltaje + PWMERROR;
  if (pot == PWMMIN-1) return 0;
  if (pot >= PWMMAX) return PWMMAX;
  if (pot <= PWMMIN) return PWMMIN;
  return pot;
}

void test()
{
  int aux;
  for (aux = 0 ; aux < 27 ; aux++)
  {
    pwmWrite(1, getPWMPot(aux));
    delay(50);
  }
  for (aux = 27; aux >= 0 ; aux-- )
  {
    pwmWrite(1, getPWMPot(aux));
    delay(50);
  }

  srand(time(NULL));
  for (aux = 0; aux < 50 ; aux++)
  {
    aux = rand() % (PWMMAX-PWMERROR);
    pwmWrite(1, getPWMPot(aux));
    delay(100);
  }
}

void testServo()
{
  int pin, degrees;

  printf("Select pwm pin: ");
  scanf("%d", &pin);
  printf("\n");

  pinMode(pin, PWM_OUTPUT);
  pwmSetMode(PWM_MODE_MS); 
  pwmSetClock (1920); //clock at 50Hz
  pwmSetRange (200) ;

  for (;;)
  {
    printf("Insert degrees: ");
    scanf("%d", &degrees);
    if    (degrees == 666) test();
    else if (degrees == -1) return;
    else  pwmWrite(1, getPWMPot(degrees));
    printf("\n");
  }

}

void testServoSoft()
{
  int pin, degrees;

  printf("Select software pwm pin: ");
  scanf("%d", &pin);
  printf("\n");

  softPwmCreate(pin, 0, 100); //setup software pwm pin

  for (;;)
  {
    printf("Insert degrees: ");
    scanf("%d", &degrees);
    if (degrees == -1) return;
    else softPwmWrite (pin, degrees);
    printf("\n");
  }
}

void testPressure()
{
  int pin;

  printf("Select pressure pin: ");
  scanf("%d", &pin);
  printf("\n");

  for(;;)
  {
    printf("Pressure: ");
    delay (500);
  }
}

void testTemperature()
{
  int pin;
  float temp = 0.0;

  printf("Select temperature pin: ");
  scanf("%d", &pin);
  printf("\n");

  for(;;)
  {
    printf("Temperature: %f", temp);
    delay (500);
  }
}

int main(int argc, char *argv[])
{

  int device;

  if (argc < 2)
  {
    printf("Usage: program + device to test\nSERVO = 1\nSERVOSOFT = 2\nPRESSURE = 3\nTEMPERATURE = 4\n");
    return (1) ;
  }
  device = atoi(argv[1]);

  if (wiringPiSetup () == -1) //using wPi pin numbering
     return (1) ;

  switch (device)
  {
    case SERVO:
      testServo();
    break;
    case SERVOSOFT:
      testServoSoft();
    break;
    case PRESSURE:
      testPressure();
    break;
    case TEMPERATURE:
      testTemperature();
    break;
    default:
    break;

  }

  return 0 ;

}

