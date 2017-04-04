#include <stdio.h>
#include <errno.h>

#include <wiringPi.h>
#include <gertboard.h>

#define SPICHAN 0

int myFd;

//SPI init, must be used once
int loadSpiDriver()
{
  if (system("startSPI") == -1)
  //if (system("gpio load spi") == -1)
  {
    printf ("Can't load the SPI driver: %s\n", strerror (errno)) ;
    return -1;
  }
  return 0;
}

//BUS init, always required
int spiSetup ()
{
  if ((myFd = wiringPiSPISetup (SPICHAN, 1000000)) < 0)
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
  wiringPiSPIDataRW(SPICHAN, buffer, 3);
  return ( (buffer[1] & 3 ) << 8 ) + buffer[2]; // get last 10 bits
}

// TEMP init
int loadTemperature (int TMP)
{
  int measure;

  printf("Loading temperature sensor in PIN %d\n", TMP);

  // Initialise SPI
  if( loadSpiDriver () != 0 ) return -2;

  // Initialise wiringPi
  if (wiringPiSetup () == -1)
  {
    printf("Error loading wiringPi: %s\n", strerror (errno) );
    return -1;
  }
  
  //Initialise BUS
  if( spiSetup() != 0 ) return -3;

  measure = myAnalogRead(TMP);
  if (measure < 0 || measure > 1023) return -4;

  close (myFd) ;
  return 0;
}

int readTemp(int PIN)
{
  float voltaje, temp;

  //Initialise BUS
  if( spiSetup() != 0 ) return -3;

  voltaje = myAnalogRead(PIN)/1024.0;
  temp = voltaje*500-273.15;

  return temp;
}

