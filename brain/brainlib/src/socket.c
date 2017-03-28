#include "socket.h"

int initSocket() 
{
  int sockfd, newsockfd, clilen;
  char buffer[256];
  struct sockaddr_in serv_addr, cli_addr;
  int  n;

  currentMovement = 0;
  if(initMovements(movements, movementsList) != 0)
    return -1;

  /* First call to socket() function */
  sockfd = socket(AF_INET, SOCK_STREAM, 0);

  if (sockfd < 0) {
    printf("ERROR opening socket\n");
    return 1;
  }

  /* Initialize socket structure */
  bzero((char *) &serv_addr, sizeof(serv_addr));

  serv_addr.sin_family = AF_INET;
  serv_addr.sin_addr.s_addr = INADDR_ANY;
  serv_addr.sin_port = htons(portno);

  /* Now bind the host address using bind() call.*/
  if (bind(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0) {
    printf("ERROR on binding\n");
    exit(1);
  }

  /* Now start listening for the clients, here process will
   * go in sleep mode and will wait for the incoming connection
   */

  for(;;)
  {

    listen(sockfd,5);
    clilen = sizeof(cli_addr);

    /* Accept actual connection from the client */
    newsockfd = accept(sockfd, (struct sockaddr *)&cli_addr, &clilen);

    if (newsockfd < 0) {
      printf("ERROR on accept\n");
    }

    /* If connection is established then start communicating */
    bzero(buffer,256);
    n = read( newsockfd,buffer,255 );

    if (n < 0) {
      printf("\nERROR reading from socket");
    }
    else 
    {
      if (strcmp(buffer,"brain") == 0)
      {
        printf("New request!!\n");

        switch(recogniseMovement(movements, movementsList, currentMovement))
        {
          case 0:
            n = write(newsockfd,"0000",4);
          break;
          case 3:
            n = write(newsockfd,"0010",4);
          break;
          case 27:
            n = write(newsockfd,"1000",4);
          break;
          case 67:
            n = write(newsockfd,"2111",4);
          break;
          default:
            n = write(newsockfd,"1111",4);
          break;
        }
        currentMovement++;

        if (n < 0) 
        {
          perror("ERROR writing to socket");
        }
      }
    }
  }
  return 0;
}
