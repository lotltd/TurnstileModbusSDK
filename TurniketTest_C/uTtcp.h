#ifndef UTTCP_H
#define UTTCP_H

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

#include <arpa/inet.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>

#include "uTypes.h"

#define MAX_TCP_PORT 9999
#define TCPHOST_LENGTH  256
#define TCPPORT_LENGTH  10
#define MIN_TCP_ATXSLEEP 350   // msec

class TTcpClient
{
    int Fd;
    bool Connected;
    unsigned int InputCount;
    byte SlaveAddress;
    byte lastCommand;
    byte readBuffer[2048];
    uint16_t sockPort;
    uint32_t sockIP;
    bool BlockMode;
    int pack_delay;

    // Service
    int16_t parseDigitValRemotePort();
    uint16_t chars2ushortSockPort();
    uint32_t chars2uintServerIP();

    public:
    char RemoteHost[TCPHOST_LENGTH];
    char RemotePort[TCPPORT_LENGTH];

    TTcpClient()
    {
        Fd=-1;
        Connected = 0;
        InputCount = 0;
        SlaveAddress=0xff;
        lastCommand=0;
        sockPort=0;
        sockIP=0;
        pack_delay = RECOMMENDED;  // msec
        BlockMode = 1;  // default mode for tcp communication
    };

    TTcpClient(bool blockMode)
    {
        Fd=-1;
        Connected = 0;
        InputCount = 0;
        SlaveAddress=0xff;
        lastCommand=0;
        sockPort=0;
        sockIP=0;
        pack_delay = RECOMMENDED;  // msec
        BlockMode = blockMode;  // default mode for tcp communication is blocked
    };

    int Open();
    void Close();
    int getFd(){return Fd;};
    void setFd(int fd){Fd = fd;};
    bool getConnected(){return Connected;};
    void setConnected(bool connected){Connected = connected;};
    void setSockIP();
    uint16_t getSockPort();
    uint32_t getSockIP();
    void setSockPort();
    bool Connect();
    int readFromBuff(bytesArray * datain);
    int writeToTcpSocket(bytesArray * dataout);
    int waitAndReadAnswer(cardinal TXSleep);
    unsigned int getInputCount();
    void getModbusHeader(bytes2word * pTransIDField, bytes2word * pProtIDField, bytes2word * pLengthField);
    void Flush();
    void setBlockMode(bool blockMode);
    bool getBlockMode();
};


#endif // UTTCP_H
