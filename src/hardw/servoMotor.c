#include <stdio.h>
#include <errno.h>

#include <netdb.h>
#include <netinet/in.h>

#include <string.h>

#include <wiringPi.h>
#include <gertboard.h>
#include <softPwm.h>

#define PWMMIN      5
#define PWMMAX      22
#define PWMERROR    4
#define INITPOS     13
#define PWMOFF      0

//Usage 1 to 18
int getPWMPot(int voltaje)
{
  int pot = voltaje + PWMERROR;
  if (pot == PWMMIN-1) return 0;
  if (pot >= PWMMAX) return PWMMAX;
  if (pot <= PWMMIN) return PWMMIN;
  return pot;
}

void unlockServo(int SERV)
{
  pwmWrite(SERV, PWMOFF);
}

int loadServoMotor (int SERV)
{
  int degrees;

  printf("Loading servo motor in PIN %d\n", SERV);

  // Initialise wiringPi
  if (wiringPiSetup () == -1)
  {
    printf("Error loading wiringPi: %s\n", strerror (errno) );
    return -1;
  }

  pinMode(SERV, PWM_OUTPUT);
  pwmSetMode(PWM_MODE_MS);
  pwmSetClock (1920); //clock at 50Hz
  pwmSetRange (200) ;

  pwmWrite(SERV, INITPOS);
  delay(1000);
  unlockServo(SERV);

  return 0 ;
}

void writeHardwareServo(int PIN, int str)
{
  printf("Moving serv%d %d\n", PIN, str);
  pinMode(PIN, PWM_OUTPUT);
  pwmSetMode(PWM_MODE_MS);
  pwmSetClock (1920); //clock at 50Hz
  pwmSetRange (200) ;

  pwmWrite(PIN, getPWMPot(str));

}
void writeServo(int PIN, int str)
{
   softPwmCreate(PIN, 0, 215); //setup software pwm pin
   softPwmWrite (PIN, str);
   printf("Moving serv%d %d\n", PIN, str);
}

void writeaServo(int serv0, int serv1, int serv2, int serv3)
{
  /*  printf("a\n");
  int sockfd, portno, n;
  struct sockaddr_in server;
  char buffer[5];

  portno = 30001;

  /* Create a socket point */
  /*sockfd = socket(AF_INET, SOCK_STREAM, 0);

  if (sockfd < 0) {
    printf("ERROR opening socket\n");
  }

  server.sin_addr.s_addr = inet_addr("127.0.0.1");
  server.sin_family = AF_INET;
  server.sin_port = htons( portno );

  /* Now connect to the server */
  /*if (connect(sockfd, (struct sockaddr*)&server, sizeof(server)) < 0) {
    printf("ERROR connecting\n");
  }

  bzero(buffer,4);
  buffer[0] = serv0;
  buffer[1] = serv1;
  buffer[2] = serv2;
  buffer[3] = serv3;

  /* Send message to the server */
  /*n = write(sockfd, buffer, strlen(buffer));
  if (n < 0) {
    printf("ERROR writing to socket\n");
  }
  else
    printf("Sended %d %d %d %d\n", serv0, serv1, serv2, serv3);

    close(sockfd);
    printf("a\n");
  return;*/
}

