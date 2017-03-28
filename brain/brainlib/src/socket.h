#include <stdio.h>
#include <stdlib.h>

#include <netdb.h>
#include <netinet/in.h>

#include <string.h>

#include "traceRecogniser.h"

#define portno 30000

struct movement movements[81];
struct movement movementsList[1000];
int currentMovement;

int initSocket();
