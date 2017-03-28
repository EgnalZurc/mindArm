#include <stdio.h>
#include <stdlib.h>

struct movement
{
  float serva;
  float servb;
  float servc;
  float servd;
};

int initMovements(struct movement movements[], struct movement movementsList[]);
int recogniseMovement(struct movement movements[], struct movement movementsList[], int currentMovement);

int compareMovements(struct movement mov1, struct movement mov2);
