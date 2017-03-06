#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <string.h>
#include <errno.h>

#include <wiringPi.h>
#include <wiringPiSPI.h>

#define TRUE                (1==1)
#define FALSE               (!TRUE)
#define TMPA                0

static int myFd ;

void loadSpiDriver();
void spiSetup (int spiChannel);
int myAnalogRead(int spiChannel, int analogChannel);

