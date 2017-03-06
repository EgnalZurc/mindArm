#include <iostream>
#include "device.h"

class servoMotor : public device
{

  protected:

    int initialize (char* name);

  public:

    int initServoMotor(char* name);

}
