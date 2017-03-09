#include <wiringPi.h>
#include <softPwm.h>

#include<stdio.h>
#include<stdlib.h>
#include <time.h>
#include <stdlib.h>

#define PWMMIN    5
#define PWMMAX    22
#define PWMERROR  4

//Usage 1 to 18
int getPWMPot(int voltaje)
{
  int pot = voltaje + PWMERROR;
  if (pot == PWMMIN-1) return 0;
  if (pot >= PWMMAX) return PWMMAX;
  if (pot <= PWMMIN) return PWMMIN;
  return pot;
}
void test();

int main(int argc, char *argv[])
{

  int degrees;

  if (wiringPiSetup () == -1) //using wPi pin numbering
     return (1) ;

  pinMode(1, PWM_OUTPUT);
  pwmSetMode(PWM_MODE_MS); 
  pwmSetClock (1920); //clock at 50Hz
  pwmSetRange (200) ;

  for (;;)
  {
    printf("Insert degrees: ");
    scanf("%d", &degrees);
    if    (degrees == 666) test();
    else  pwmWrite(1, getPWMPot(degrees));
    printf("\n");
  }

  return 0 ;

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
