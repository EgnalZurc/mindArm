#include <stdio.h>
#include <errno.h>

#include <wiringPi.h>
#include <gertboard.h>

int myFd;

//BUS init, always required
int configSPI (int SPICHAN)
{
  if ((myFd = wiringPiSPISetup (SPICHAN, 1000000)) < 0)
  {
    printf ("Can't open the SPI bus: %s\n", strerror (errno)) ;
    return -1;
  }
  return 0;
}

//Analog Read
int customAnalogRead(int analogChannel, int SPICHAN)
{
  if(analogChannel<0 || analogChannel>7)
    return -1;
  unsigned char buffer[3] = {1}; // start bit
  buffer[1] = (analogChannel+8) << 4;
  wiringPiSPIDataRW(SPICHAN, buffer, 3);
  return ( (buffer[1] & 3 ) << 8 ) + buffer[2]; // get last 10 bits
}



void readTrace (int line, float *v1, float *v2, float *v3, float *v4, float *v5, float *v6, float *v7, float *v8, float *v9, float *v10, float *v11, float *v12, float *v13, float *v14)
{
  float voltaje, temp;

  //Initialise BUS
  if( configSPI(0) != 0 ) return ;

  *v1 = customAnalogRead(2, 0)/1024.0;
  *v2 = customAnalogRead(3, 0)/1024.0;
  *v3 = customAnalogRead(4, 0)/1024.0;
  *v4 = customAnalogRead(5, 0)/1024.0;
  *v5 = customAnalogRead(6, 0)/1024.0;
  *v6 = customAnalogRead(7, 0)/1024.0;

  //Initialise BUS
  if( configSPI(1) != 0 ) return ;

  *v7 = customAnalogRead(0, 1)/1024.0;
  *v8 = customAnalogRead(1, 1)/1024.0;
  *v9 = customAnalogRead(2, 1)/1024.0;
  *v10 = customAnalogRead(3, 1)/1024.0;
  *v11 = customAnalogRead(4, 1)/1024.0;
  *v12 = customAnalogRead(5, 1)/1024.0;
  *v13 = customAnalogRead(6, 1)/1024.0;
  *v14 = customAnalogRead(7, 1)/1024.0;
}
