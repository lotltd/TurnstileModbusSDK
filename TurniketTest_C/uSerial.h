#ifndef USERIAL_H
#define USERIAL_H

#include <unistd.h>  // UNIX standard function definitions
#include <string.h>  // String function definitions

#include <fcntl.h>   // File control definitions
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <termios.h> // POSIX terminal control definitions
#include <errno.h>   // Error number definitions

#include <sys/dir.h>
#include <sys/param.h>

#include <stdio.h>
#include <stdlib.h>

#include <time.h>

#include <sys/types.h>

#include "uTypes.h"

#ifdef QNX_X86
#define DEVSERPATH "/dev/ser"
#else
#define DEVSERPATH "/dev/ttyS"
#endif
#define DEVSERPATH_LENGTH 255
#define MAX_VALID_PORT 4


class TComPort
{
    int Fd;
    bool Connected;
    unsigned int InputCount;
    byte SlaveAddress;
    byte lastCommand;
    byte readBuffer[2048];
    speed_t BaudRate;
    int pack_delay;
    public:

    char Port[DEVSERPATH_LENGTH];

    TComPort()
    {
        Fd = -1;
        BaudRate = B115200;
        pack_delay = RECOMMENDED;  // msec
        Port[0]=0;
        InputCount = 0;
        Connected=0;
        SlaveAddress=0xff;
        lastCommand=0;
    };
    int Open();
    void Close();
    int getFd(){return Fd;};
    void setFd(int fd){Fd = fd;};
    bool getConnected(){return Connected;};
    void setConnected(bool connected){Connected = connected;};
    int readFromSerPort(bytesArray * datain);
    int writeToSerPort(bytesArray * dataout);
    int waitForAnswer(cardinal TXSleep);
    unsigned int getInputCount();
    speed_t setBaudRate(speed_t baudRate);
    void Flush();
};
#endif // USERIAL_H
