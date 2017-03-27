#include <stdio.h>
#include <errno.h>

#include <netdb.h>
#include <netinet/in.h>

#include <string.h>

#include <wiringPi.h>

void readTrace (int *SA, int *SB, int *SC, int *SD)
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
