#include<stdio.h>
#include <time.h>
#include <stdlib.h>

main()
{
      int  i, j;
      float r;

      for(i = 0 ; i < 81 ; i ++)
      {
        for(j = 0 ; j < 14 ; j ++)
        {
          r = rand() % 1000;
          printf("%.3f ", (r / 1000.0));
        }
        printf("\n");
      }

}
