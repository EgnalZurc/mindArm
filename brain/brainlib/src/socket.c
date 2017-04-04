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

      recogniseMovement(movements, movementsList, currentMovement);

        switch(movementsList[currentMovement].movementID)
        {
          case 1:
            n = write(newsockfd,"0000",4);
          break;
          case 2:
            n = write(newsockfd,"0001",4);
          break;
          case 3:
            n = write(newsockfd,"0002",4);
          break;
          case 4:
            n = write(newsockfd,"0010",4);
          break;
          case 5:
            n = write(newsockfd,"0011",4);
          break;
          case 6:
            n = write(newsockfd,"0012",4);
          break;
          case 7:
            n = write(newsockfd,"0020",4);
          break;
          case 8:
            n = write(newsockfd,"0021",4);
          break;
          case 9:
            n = write(newsockfd,"0022",4);
          break;
          case 10:
            n = write(newsockfd,"0100",4);
          break;
          case 11:
            n = write(newsockfd,"0101",4);
          break;
          case 12:
            n = write(newsockfd,"0102",4);
          break;
          case 13:
            n = write(newsockfd,"0110",4);
          break;
          case 14:
            n = write(newsockfd,"0111",4);
          break;
          case 15:
            n = write(newsockfd,"0112",4);
          break;
          case 16:
            n = write(newsockfd,"0120",4);
          break;
          case 17:
            n = write(newsockfd,"0121",4);
          break;
          case 18:
            n = write(newsockfd,"0122",4);
          break;
          case 19:
            n = write(newsockfd,"0200",4);
          break;
          case 20:
            n = write(newsockfd,"0201",4);
          break;
          case 21:
            n = write(newsockfd,"0202",4);
          break;
          case 22:
            n = write(newsockfd,"0210",4);
          break;
          case 23:
            n = write(newsockfd,"0211",4);
          break;
          case 24:
            n = write(newsockfd,"0212",4);
          break;
          case 25:
            n = write(newsockfd,"0220",4);
          break;
          case 26:
            n = write(newsockfd,"0221",4);
          break;
          case 27:
            n = write(newsockfd,"0222",4);
          break;
          case 28:
            n = write(newsockfd,"1000",4);
          break;
          case 29:
            n = write(newsockfd,"1001",4);
          break;
          case 30:
            n = write(newsockfd,"1002",4);
          break;
          case 31:
            n = write(newsockfd,"1010",4);
          break;
          case 32:
            n = write(newsockfd,"1011",4);
          break;
          case 33:
            n = write(newsockfd,"1012",4);
          break;
          case 34:
            n = write(newsockfd,"1020",4);
          break;
          case 35:
            n = write(newsockfd,"1021",4);
          break;
          case 36:
            n = write(newsockfd,"1022",4);
          break;
          case 37:
            n = write(newsockfd,"1100",4);
          break;
          case 38:
            n = write(newsockfd,"1101",4);
          break;
          case 39:
            n = write(newsockfd,"1102",4);
          break;
          case 40:
            n = write(newsockfd,"1110",4);
          break;
          case 41:
            n = write(newsockfd,"1111",4);
          break;
          case 42:
            n = write(newsockfd,"1112",4);
          break;
          case 43:
            n = write(newsockfd,"1120",4);
          break;
          case 44:
            n = write(newsockfd,"1121",4);
          break;
          case 45:
            n = write(newsockfd,"1122",4);
          break;
          case 46:
            n = write(newsockfd,"1200",4);
          break;
          case 47:
            n = write(newsockfd,"1201",4);
          break;
          case 48:
            n = write(newsockfd,"1202",4);
          break;
          case 49:
            n = write(newsockfd,"1210",4);
          break;
          case 50:
            n = write(newsockfd,"1211",4);
          break;
          case 51:
            n = write(newsockfd,"1212",4);
          break;
          case 52:
            n = write(newsockfd,"1220",4);
          break;
          case 53:
            n = write(newsockfd,"1221",4);
          break;
          case 54:
            n = write(newsockfd,"1222",4);
          break;
          case 55:
            n = write(newsockfd,"2000",4);
          break;
          case 56:
            n = write(newsockfd,"2001",4);
          break;
          case 57:
            n = write(newsockfd,"2002",4);
          break;
          case 58:
            n = write(newsockfd,"2010",4);
          break;
          case 59:
            n = write(newsockfd,"2011",4);
          break;
          case 60:
            n = write(newsockfd,"2012",4);
          break;
          case 61:
            n = write(newsockfd,"2020",4);
          break;
          case 62:
            n = write(newsockfd,"2021",4);
          break;
          case 63:
            n = write(newsockfd,"2022",4);
          break;
          case 64:
            n = write(newsockfd,"2100",4);
          break;
          case 65:
            n = write(newsockfd,"2101",4);
          break;
          case 66:
            n = write(newsockfd,"2102",4);
          break;
          case 67:
            n = write(newsockfd,"2110",4);
          break;
          case 68:
            n = write(newsockfd,"2111",4);
          break;
          case 69:
            n = write(newsockfd,"2112",4);
          break;
          case 70:
            n = write(newsockfd,"2120",4);
          break;
          case 71:
            n = write(newsockfd,"2121",4);
          break;
          case 72:
            n = write(newsockfd,"2122",4);
          break;
          case 73:
            n = write(newsockfd,"2200",4);
          break;
          case 74:
            n = write(newsockfd,"2201",4);
          break;
          case 75:
            n = write(newsockfd,"2202",4);
          break;
          case 76:
            n = write(newsockfd,"2210",4);
          break;
          case 77:
            n = write(newsockfd,"2211",4);
          break;
          case 78:
            n = write(newsockfd,"2212",4);
          break;
          case 79:
            n = write(newsockfd,"2220",4);
          break;
          case 80:
            n = write(newsockfd,"2221",4);
          break;
          case 81:
            n = write(newsockfd,"2222",4);
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
