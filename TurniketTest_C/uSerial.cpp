#include "uSerial.h"

static struct termios options_port;

int TComPort :: Open()
{
    if(Fd > 0) Close();
    Fd = open(Port,O_RDWR | O_NOCTTY | O_NDELAY);
    if(Fd <= 0)
    {
        Fd = -1;
        Connected = 0;
        InputCount = 0;
        SlaveAddress=0xff;
        lastCommand=0;
        return Fd;
    }
    // Get the current options for the port
    tcgetattr(Fd, &options_port);
    // No parity (8N1)
    options_port.c_cflag &= ~PARENB;
    options_port.c_cflag &= ~CSTOPB;
    options_port.c_cflag &= ~CSIZE;
    options_port.c_cflag |= CS8;
    // Enable the receiver and set local mode
    options_port.c_cflag |= (CLOCAL | CREAD);
    // To disable the hardware flow control
#ifdef QNX_X86
    options_port.c_cflag &= ~IHFLOW;
    options_port.c_cflag &=~OHFLOW;
#else
    options_port.c_cflag &= ~CRTSCTS;
#endif
    // To disable the software flow control
#ifdef QNX_X86
	options_port.c_iflag &= ~(IXON | IXOFF | IXANY);
#else
    options_port.c_iflag &= ~(IXON | IXOFF | IXANY | ICRNL | INLCR);
#endif
    // Choosing Raw Input
    options_port.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);
    // Choosing Raw Output
#ifdef QNX_X86
	options_port.c_oflag &= ~OPOST;
#else
    options_port.c_oflag &= ~(OPOST | OCRNL | ONLCR);
#endif
#ifndef QNX_X86
    // Speed settings
    options_port.c_ispeed = BaudRate;
    options_port.c_ospeed = BaudRate;
#endif
    // Set the new options for the port
    tcsetattr(Fd, TCSANOW | TCSAFLUSH , &options_port);
    // Get the current options for the port
    tcgetattr(Fd, &(options_port));
    // Set the baud rate
    cfsetispeed(&options_port, BaudRate);
    cfsetospeed(&options_port, BaudRate);
    tcsetattr( Fd, TCSADRAIN, &options_port);
    // Throw away all input and output data
    tcflush( Fd, TCIOFLUSH );
    Connected = 1;
    InputCount = 0;
    SlaveAddress=0xff;
    lastCommand=0;
    return Fd;
}


void TComPort :: Close()
{
    if(Fd > 0) close(Fd);
    Fd = -1;
    Connected = 0;
    InputCount = 0;
}

void TComPort :: Flush()
{
    // Throw away all input and output data
  unsigned int bytes;

  if(Fd<=0 || !Port[0] || !Connected) return;

  sleepMsecsW(pack_delay);

  ioctl(Fd, FIONREAD, &bytes);
  if(bytes > 0)
  {
      if(bytes > 2048)
      {
        while(bytes > 2048)
        {
           read(Fd, readBuffer, 2048);
           bytes -= 2048;
        }
        if(bytes > 0)
        {
          read(Fd, readBuffer, bytes);
        }
      }
      else
      {
          read(Fd, readBuffer, bytes);
      }
  }
  tcflush( Fd, TCOFLUSH );
}

int TComPort :: readFromSerPort(bytesArray * datain)
{
    int rc;

    datain->length = 0;
    if(Fd<=0 || !Port[0] || !Connected) return 0;
    if(getInputCount()<3) return 0;
    rc = read(Fd,(void *)(datain->data),BYTESARRAY_MAXLENGTH);
    if(rc < 3) return 0;
    datain->length = rc;
    return rc;
}

int TComPort :: writeToSerPort(bytesArray * dataout)
{
    if(Fd<=0 || !Port[0] || !Connected)
    {
        SlaveAddress=0xff;
        lastCommand=0;
        return 0;
    }
    else if(!dataout->length) return 0;

    SlaveAddress = dataout->data[0];
    lastCommand = dataout->data[1];
    sleepMsecsW(pack_delay);  // pause between requests
    int rc = write(Fd, (const void *)(dataout->data),(size_t)(dataout->length));
    return rc;
}

int TComPort :: waitForAnswer(cardinal TXSleep)
{
	unsigned int incount = 0;
    struct timespec start, stop;
    double accum, dTXSleep;

    dTXSleep = (double)TXSleep;

    clock_gettime( CLOCK_REALTIME, &start);
    accum = 0;  // msecs
    while((incount < 3 || getInputCount() != incount) && accum < dTXSleep)
    {
        incount = getInputCount();
        sleepMsecsW(2);
        clock_gettime( CLOCK_REALTIME, &stop);
        accum = (( stop.tv_sec - start.tv_sec ) + (double)( stop.tv_nsec - start.tv_nsec ) / (double)BILLION) *1000;  // msecs
    }

    return getInputCount();
}

unsigned int TComPort :: getInputCount()
{
    if(Fd<=0 || !Port[0] || !Connected)
    {
        InputCount = 0;
    }
    else
    {
        ioctl(Fd, FIONREAD, &InputCount);
    }
    return InputCount;
}

speed_t TComPort :: setBaudRate(speed_t baudRate)
{
	BaudRate = baudRate;
  	return baudRate;
}
