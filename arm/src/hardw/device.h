#include <cstring>

class device
{

  protected:

    int           _port;
    std::string   _deviceName;

  public:

    virtual int initialize ();

};
