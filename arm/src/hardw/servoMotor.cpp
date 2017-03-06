#include "servoMotor.h"


int
servoMotor::initialize (char* name)
{
  std::string aux(name);
  _deviceName = aux;
  return 1;
}

int
servoMotor::initServoMotor(name)
{
  return initialize(name);
}
