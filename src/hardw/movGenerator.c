#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <signal.h>

#include <wiringPi.h>
#include <gertboard.h>
#include <softPwm.h>

#include <netdb.h>
#include <netinet/in.h>

#define PWMMIN      1
#define PWMMAX      18
#define PWMSMIN     5
#define PWMSMAX     22
#define PWMSERROR    4
#define portno 30001

int running = 1;


void intHandler(int dummy) 
{
  running = 0;
  pwmWrite(1, 0);
  printf("Exiting movement generator!!!\n");
  abort();
}

//Hardware Usage : 1 to 18
int getPWMPot(int voltaje)
{
  int pot = voltaje;
  if (pot >= PWMMAX) return PWMMAX;
  if (pot <= PWMMIN) return PWMMIN;
  return pot;
}
//Software Usage : 5 to 22
int getSPWMPot(int voltaje)
{
  int pot = voltaje + PWMSERROR;
  if (pot >= PWMSMAX) return PWMSMAX;
  if (pot <= PWMSMIN) return PWMSMIN;
  return pot;
}

void movementHandler()
{
  int sockfd, newsockfd, clilen;
  char buffer[256];
  struct sockaddr_in serv_addr, cli_addr;
  int  n, acc, serva, servb, servc, servd;

  /* First call to socket() function */
  sockfd = socket(AF_INET, SOCK_STREAM, 0);

  if (sockfd < 0) {
    printf("ERROR opening socket\n");
    return;
  }

  /* Initialize socket structure */
  bzero((char *) &serv_addr, sizeof(serv_addr));

  serv_addr.sin_family = AF_INET;
  serv_addr.sin_addr.s_addr = INADDR_ANY;
  serv_addr.sin_port = htons(portno);

  /* Now bind the host address using bind() call.*/
  if (bind(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0) {
    printf("ERROR on binding\n");
    return;
  }

  /* Initiation of WiringPi */

  if (wiringPiSetup () == -1)
  {
    printf("Error loading wiringPi: %s\n", strerror (errno) );
    return;
  }
  softPwmCreate(4, 0, 215); //setup software pwm pin
  softPwmCreate(5, 0, 215); //setup software pwm pin
  softPwmCreate(6, 0, 215); //setup software pwm pin

  pinMode(1, PWM_OUTPUT);
  pwmSetMode(PWM_MODE_MS);
  pwmSetClock (1920); //clock at 50Hz
  pwmSetRange (200) ;

  /* Now start listening for the clients, here process will
    go in sleep mode and will wait for the incoming connection */
  printf("Listening port %d\n", portno);
  while(running)
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
    buffer[n] = '\0';

    if (n < 0) {
      printf("\nERROR reading from socket");
    }
    else 
    {
      acc = buffer[0];
      serva = getSPWMPot( ((buffer[1] - 48) * 10) + (buffer[2] - 48) );
      servb = getPWMPot( ((buffer[3] - 48) * 10) + (buffer[4] - 48) );
      servc = getSPWMPot( ((buffer[5] - 48) * 10) + (buffer[6] - 48) );
      servd = getSPWMPot( ((buffer[7] - 48) * 10) + (buffer[8] - 48) );

      softPwmWrite (4, serva-4);
      pwmWrite(     1, servb-4);
      softPwmWrite (5, servc-4);
      softPwmWrite (6, servd-4);

      printf("%d %d %d %d\n", serva-4, servb, servc-4, servd-4);
    }
  }
}

int main()
{
  signal(SIGINT, intHandler);
  signal(SIGKILL, intHandler);
  signal(SIGPIPE, intHandler);
  signal(SIGALRM, intHandler);
  signal(SIGTERM, intHandler);

  movementHandler();
  return 1;
}
