#include "traceRecogniser.h"

int initMovements(struct movement movements[], struct movement movementsList[])
{
  int i, j;
  FILE *fp;

  printf("Loading movements...\n");

  fp = fopen("./etc/USR01Param.tr", "r");
  if (fp == NULL)
  {
    printf("Can't open file ./etc/USR01Param.tr\nEXITTING\n");
    return -1;
  }

  for(i = 0 ; i < 81 ; i ++)
  {
    for(j = 0 ; j < 14 ; j ++)
    {
      fscanf(fp,"%f",&movements[i].trace[j]);
    }
    //printf("Movement %d: %.3f %.3f %.3f %.3f\n", (i+1), movements[i].serva, movements[i].servb, movements[i].servc, movements[i].servd);
  }

  fclose(fp);

  printf("Loading movements list...\n");

  fp = fopen("./etc/Movements.tr", "r");
  if (fp == NULL)
  {
    printf("Can't open file ./etc/Movements.tr\nEXITTING\n");
    return -1;
  }

  for(i = 0 ; i < 200 ; i ++)
  {
    //printf("Loading line %d\n", i);
    for(j = 0 ; j < 14 ; j ++)
    {
      fscanf(fp,"%f",&movementsList[i].trace[j]);
    }
    //printf("Movement %d: %.3f %.3f %.3f %.3f\n", (i+1), movementsList[i].serva, movementsList[i].servb, movementsList[i].servc, movementsList[i].servd);
  }

  printf("%d movements loaded\n", i);

  fclose(fp);

  return 0;
}

void recogniseMovement(struct movement movements[], struct movement movementsList[],  int currentMovement)
{
  int i;
  printf("Recognising movement...\n");

  printf("Movement %d: ", currentMovement);
  for(i = 0 ; i < 14 ; i ++)
  {
    printf(" %f", movementsList[currentMovement].trace[i]);
  }
  printf("\n");

  for(i = 0 ; i < 81 ; i++)
  {
    if((compareMovements(movements[i], movementsList[currentMovement]))==1) 
    {
      printf("Recognised movement %d\n", i);
      movementsList[currentMovement].movementID = (i+1);
      break;
    }
  }
}

int compareMovements(struct movement mov1, struct movement mov2)
{
  int i;

  for(i = 0 ; i < 14 ; i ++)
  {
    if ((mov1.trace[i] - mov2.trace[i]) != 0) return -1;
  }

  return 1; 
}
