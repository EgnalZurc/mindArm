#include <wiringPi.h>
#include <softPwm.h>
#include <gertboard.h>
#include <wiringPiSPI.h>

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdlib.h>
#include <errno.h>
#include <cstring>

#define PWMMIN    5
#define PWMMAX    22
#define PWMERROR  4

#define SERVO       1
#define SERVOSOFT   2
#define PRESSURE    3
#define TEMPERATURE 4

int myFd;
int channel;

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

//SPI init, must be used once
int loadSpiDriver()
{
  if (system("startSPI") == -1)
    //if (system("gpio load spi") == -1)
  {
    printf ("Can't load the SPI driver\n") ;
    return -1;
  }
  return 0;
}

//BUS init, always required
int spiSetup ()
{
  printf("Select SPI channel: ");
  scanf("%d", &channel);
  printf("\n");

  if ((myFd = wiringPiSPISetup (channel, 1000000)) < 0)
  {
    printf ("Can't open the SPI bus: %s\n", strerror (errno)) ;
    return -1;
  }
  return 0;
}

//Analog read
int myAnalogRead(int analogChannel)
{
  if(analogChannel<0 || analogChannel>7)
    return -1;
  unsigned char buffer[3] = {1}; // start bit
  buffer[1] = (analogChannel+8) << 4;
  wiringPiSPIDataRW(channel, buffer, 3);
  return ( (buffer[1] & 3 ) << 8 ) + buffer[2]; // get last 10 bits
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

  pinMode(pin, INPUT);

  for(;;)
  {
    if(digitalRead(pin)) printf("Pressure HIGH\n");
    else printf("Pressure LOW\n");
    delay (1000);
  }
}

void testTemperature()
{
  int pin, temp;

  printf("Select temperature pin: ");
  scanf("%d", &pin);
  printf("\n");

  // Initialise SPI
  if( loadSpiDriver () != 0 )
  {
    printf("Error loading Spi Driver\n");
    return;
  }

  // Initialise wiringPi
  if (wiringPiSetup () == -1)
  {
    printf("Error loading wiringPi\n");
    return;
  }

  //Initialise BUS
  if( spiSetup() != 0 )
  {
    printf("Error loading Spi BUS\n");
    return;
  }

  for(;;)
  {
    temp = myAnalogRead(pin);
    printf("Temperature: %d\n", temp);
    delay (1000);
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

  if (wiringPiSetup () == -1)
  {
    printf("Error loading wiringPi: %s\n", strerror (errno) );
    return -1;
  }

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

