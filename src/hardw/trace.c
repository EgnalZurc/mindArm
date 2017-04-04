#include <stdio.h>
#include <errno.h>

#include <netdb.h>
#include <netinet/in.h>

#include <string.h>

#include <wiringPi.h>

void readTraceSocket (int *SA, int *SB, int *SC, int *SD)
{

  int sockfd, portno, n;
  struct sockaddr_in server;
  char buffer[256];

  portno = 30000;

  /* Create a socket point */
  sockfd = socket(AF_INET, SOCK_STREAM, 0);

  if (sockfd < 0) {
    perror("ERROR opening socket");
  }

  server.sin_addr.s_addr = inet_addr("127.0.0.1");
  server.sin_family = AF_INET;
  server.sin_port = htons( portno );

  /* Now connect to the server */
  if (connect(sockfd, (struct sockaddr*)&server, sizeof(server)) < 0) {
    perror("ERROR connecting");
  }

  /* Now ask for a message from the user, this message
   *       * will be read by server
   *          */

  bzero(buffer,256);
  strcpy(buffer, "brain");

  /* Send message to the server */
  n = write(sockfd, buffer, strlen(buffer));
  if (n < 0) {
    perror("ERROR writing to socket");
  }

  /* Now read server response */
  bzero(buffer,256);
  n = read(sockfd, buffer, 255);
  if (n < 0) {
    perror("ERROR reading from socket");
  }

  if(buffer[0] == '0') *SA = -1;
  else if(buffer[0] == '1') *SA = 0;
  else *SA = 1;

  if(buffer[1] == '0') *SB = -1;
  else if(buffer[1] == '1') *SB = 0;
  else *SB = 1;

  if(buffer[2] == '0') *SC = -1;
  else if(buffer[2] == '1') *SC = 0;
  else *SC = 1;

  if(buffer[3] == '0') *SD = -1;
  else if(buffer[3] == '1') *SD = 0;
  else *SD = 1;
}

void readTrace (float trace[14])
{
  int i;

  for(i = 0 ; i < 14 ; i++)
    trace[i] = 0;
}

void readLibTrace (int line, float *v1, float *v2, float *v3, float *v4, float *v5, float *v6, float *v7, float *v8, float *v9, float *v10, float *v11, float *v12, float *v13, float *v14)
{
  int i, j;
  FILE *fp;

  printf("Searching for movement %d\n", line);

  fp = fopen("./etc/Movements.tr", "r");
  if (fp == NULL)
  { 
    printf("Can't open file ./etc/Movements.tr\nEXITTING\n");
    return;
  }

  for(i = 0 ; i < 9999999 ; i ++)
  { 
    //printf("%d\n", i);
    if(i == line)
    {
      printf("Encontrado!\n");
      fscanf(fp,"%f",v1);
      fscanf(fp,"%f",v2);
      fscanf(fp,"%f",v3);
      fscanf(fp,"%f",v4);
      fscanf(fp,"%f",v5);
      fscanf(fp,"%f",v6);
      fscanf(fp,"%f",v7);
      fscanf(fp,"%f",v8);
      fscanf(fp,"%f",v9);
      fscanf(fp,"%f",v10);
      fscanf(fp,"%f",v11);
      fscanf(fp,"%f",v12);
      fscanf(fp,"%f",v13);
      fscanf(fp,"%f",v14);
      break;
    }
    else
    {
      for(j = 0 ; j < 14 ; j ++)
      { 
        //printf("%d\n", j);
        fscanf(fp,"%f",v1);
      }
    }
  }

  fclose(fp);
}
