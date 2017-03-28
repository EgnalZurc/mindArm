#include "traceRecogniser.h"

int initMovements(struct movement movements[], struct movement movementsList[])
{
  int i;
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
    fscanf(fp,"%f",&movements[i].serva);
    fscanf(fp,"%f",&movements[i].servb);
    fscanf(fp,"%f",&movements[i].servc);
    fscanf(fp,"%f",&movements[i].servd);
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

  for(i = 0 ; fscanf(fp,"%f",&movementsList[i].serva) != EOF ; i ++)
  {
    fscanf(fp,"%f",&movementsList[i].servb);
    fscanf(fp,"%f",&movementsList[i].servc);
    fscanf(fp,"%f",&movementsList[i].servd);
    //printf("Movement %d: %.3f %.3f %.3f %.3f\n", (i+1), movementsList[i].serva, movementsList[i].servb, movementsList[i].servc, movementsList[i].servd);
  }

  printf("%d movements loaded\n", i);

  fclose(fp);

  return 0;
}

int recogniseMovement(struct movement movements[], struct movement movementsList[],  int currentMovement)
{
  int i;
  printf("Recognising movement...\n");

  printf("Movement %d: %0.3f %0.3f %0.3f %0.3f\n", currentMovement, movementsList[currentMovement].serva, movementsList[currentMovement].servb, movementsList[currentMovement].servc, movementsList[currentMovement].servd);

  for(i = 0 ; i < 81 ; i++)
  {
    if((compareMovements(movements[i], movementsList[currentMovement]))==1) 
    {
      printf("Recognised movement %d\n", i);
      break;
    }
  }

  return i;
}

int compareMovements(struct movement mov1, struct movement mov2)
{
  if ((mov1.serva - mov2.serva) != 0) return -1;
  if ((mov1.servb - mov2.servb) != 0) return -1;
  if ((mov1.servc - mov2.servc) != 0) return -1;
  if ((mov1.servd - mov2.servd) != 0) return -1;
  return 1; 
}
