#include <stdio.h>
#include <stdlib.h>

struct movement
{
  float trace[14];
  int movementID;
};

int initMovements(struct movement movements[], struct movement movementsList[]);
void recogniseMovement(struct movement movements[], struct movement movementsList[], int currentMovement);

int compareMovements(struct movement mov1, struct movement mov2);
