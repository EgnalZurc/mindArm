#include "tempSensor.h"

void loadSpiDriver()
{
  if (system("gpio load spi") == -1)
  {
    fprintf (stderr, "Can't load the SPI driver: %s\n", strerror (errno)) ;
  }
}

void spiSetup (int spiChannel)
{
  if ((myFd = wiringPiSPISetup (spiChannel, 1000000)) < 0)
  {
    fprintf (stderr, "Can't open the SPI bus: %s\n", strerror (errno)) ;
    exit (EXIT_FAILURE) ;
  }
}

int myAnalogRead(int spiChannel, int analogChannel)
{
  if(analogChannel<0 || analogChannel>7)
    return -1;
  unsigned char buffer[3] = {1}; // start bit
  buffer[1] = (analogChannel) << 4;  // analogChannel+8?
  wiringPiSPIDataRW(spiChannel, buffer, 3);
  return ( (buffer[1] & 3 ) << 8 ) + buffer[2]; // get last 10 bits
}

int main (int argc, char *argv [])
{

  int spiChannel = 0; // There are two (0,1)

  loadSpiDriver (); // I think that we only need do this one time
  wiringPiSetup ();
  spiSetup(0); // Loading the bus is always required

  printf("Temperature analog input: %d\n", myAnalogRead(spiChannel,TMPA));

  close (myFd) ;
  return 0;
}
