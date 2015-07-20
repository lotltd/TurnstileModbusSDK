#include "uTtcp.h"

static struct sockaddr_in addr;

int TTcpClient :: Open()
 {

    Close();
    Fd = socket(AF_INET, SOCK_STREAM, 0);
    fd_set write_fds, err_fds;

    if(Fd <=0)
    {
        Fd = -1;
        Connected = 0;
        InputCount = 0;
        SlaveAddress=0xff;
        lastCommand=0;
        return Fd;
    }
    if(!BlockMode)
    {
    	// Non blocked mode
        int flags = fcntl(Fd, F_GETFL, 0);
        fcntl(Fd, F_SETFL, flags | O_NONBLOCK);
    }

    addr.sin_family = AF_INET;
    addr.sin_port = sockPort;
    addr.sin_addr.s_addr = sockIP;

	if(connect(Fd, (struct sockaddr *)&addr, sizeof(addr)) < 0)
	{
	    if(BlockMode || errno != EINPROGRESS) // || errno != EAGAIN)
	    {
	    	Close();
			return -1;
	    }
	    else
	    {
	    	// Non blocked mode
	    	connect(Fd, (struct sockaddr *)&addr, sizeof(addr));
	        FD_ZERO(&write_fds);        //Zero out the file descriptor write set
	        FD_SET(Fd, &write_fds);     //Set the current socket file descriptor into the write set
	        FD_ZERO(&err_fds);        //Zero out the file descriptor error set
	        FD_SET(Fd, &err_fds);     //Set the current socket file descriptor into the error set

	        struct timeval tv;
	        tv.tv_sec = 5;   // 0;
	        tv.tv_usec = 0;  // 500000;
	        if(select(Fd + 1, NULL, &write_fds, &err_fds, &tv)<=0)
	        {
	        	Close();
				return -1;
	        }
	        if(FD_ISSET(Fd,&err_fds) || !FD_ISSET(Fd,&write_fds))
	        {
	        	Close();
	        	return -1;
	        }
	        if(connect(Fd, (struct sockaddr *)&addr, sizeof(addr))<0)
	        {
	        	Close();
	        	return -1;
	        }
	    }
    }
    Connected = 1;
    InputCount = 0;
    SlaveAddress=0xff;
    lastCommand=0;

    return Fd;
 }

void TTcpClient :: Close()
 {
    if(Fd > 0) close(Fd);
    Fd = -1;
    Connected = 0;
    InputCount = 0;
    SlaveAddress=0xff;
    lastCommand=0;
 }

bool TTcpClient :: Connect()
{
    if(Open()>0) return 1;
    return 0;
}

void TTcpClient :: getModbusHeader(bytes2word * pTransIDField, bytes2word * pProtIDField, bytes2word * pLengthField)
{
#if  defined(QNX_X86) || (defined(__BYTE_ORDER) && __BYTE_ORDER == __LITTLE_ENDIAN) || !defined(__BYTE_ORDER)
		int i=1,j=0;
#else
		int i=0,j=1;
#endif
        pTransIDField->b[i] = readBuffer[0];
        pTransIDField->b[j] = readBuffer[1];
        pProtIDField->b[i] = readBuffer[2];
        pProtIDField->b[j] = readBuffer[3];
        pLengthField->b[i] = readBuffer[4];
        pLengthField->b[j] = readBuffer[5];
}

int TTcpClient :: readFromBuff(bytesArray * datain)
{
	bytes2word TransIDField, ProtIDField, LengthField;
    getModbusHeader(&TransIDField, &ProtIDField, &LengthField);
    datain->length = LengthField.d + 6;
    for(int i=0; i<datain->length; i++) datain->data[i] = readBuffer[i];
    return (int)(datain->length);
}

int TTcpClient :: writeToTcpSocket(bytesArray * dataout)
{
    if(Fd<=0 || !Connected)
    {
        SlaveAddress=0xff;
        lastCommand=0;
        return 0;
    }
    else if(!dataout->length) return 0;
    SlaveAddress = dataout->data[6];
    lastCommand = dataout->data[7];
    sleepMsecsW(pack_delay);  // pause between requests
    int rc = write(Fd, (const void *)(dataout->data),(size_t)(dataout->length));
    return rc;       
}

int TTcpClient :: waitAndReadAnswer(cardinal TXSleep)
{
	bytes2word TransIDField, ProtIDField, LengthField;
    struct timespec start, stop;
    double accum, dTXSleep;
    int addlength = 0; //, bufindex = 0;

    dTXSleep = (double)TXSleep;

    clock_gettime( CLOCK_REALTIME, &start);
    accum = 0;  // msecs
    while(getInputCount() < 6 && (accum < dTXSleep))  // wait for modbus tcp header
    {
        sleepMsecsW(2);
        clock_gettime( CLOCK_REALTIME, &stop);
        accum = (( stop.tv_sec - start.tv_sec ) + (double)( stop.tv_nsec - start.tv_nsec ) / (double)BILLION) *1000;  // msecs
    }
    if(InputCount >= 6)  // Modbus tcp header was recieved
    {
        addlength = read(Fd,(void *)readBuffer,6);
        
        if(addlength!=6)
        {
            // Socket Read error
            return -1;
        }
        getModbusHeader(&TransIDField, &ProtIDField, &LengthField);
#if  defined(QNX_X86) || (defined(__BYTE_ORDER) && __BYTE_ORDER == __LITTLE_ENDIAN) || !defined(__BYTE_ORDER)
        if(ProtIDField.d != 0 || LengthField.b[1] != 0)
#else
        if(ProtIDField.d != 0 || LengthField.b[0] != 0)
#endif
        {
            // ModbusTCP header error
            return -2;
        }
        while(getInputCount() < LengthField.d && (accum < dTXSleep))  // wait for the rest part of response
        {
            sleepMsecsW(2);
            clock_gettime( CLOCK_REALTIME, &stop);
            accum = (( stop.tv_sec - start.tv_sec ) + (double)( stop.tv_nsec - start.tv_nsec ) / (double)BILLION) *1000;  // msecs
        }
        if(LengthField.d <= InputCount)
        {
            addlength = read(Fd,(void *)(readBuffer+6),LengthField.d);
            if((LongWord)addlength == InputCount) return (int)(LengthField.d) + 6;  // OK: slave's response is in the readBuffer
            else return -1; // Socket read error
        }
    }
    // flush invalid packet
    if(InputCount > 0) 
    {
    	Flush();
    }
    return 0;
}

unsigned int TTcpClient :: getInputCount()
{
    if(Fd<=0 || !Connected)
    {
        InputCount = 0;
    }
    else
    {
        ioctl(Fd, FIONREAD, &InputCount);
    }
    return InputCount;
}

void TTcpClient :: Flush()
{
    // Throw away all input and output data
  unsigned int bytes;

  if(Fd<=0 || !Connected) return;

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

void TTcpClient :: setBlockMode(bool blockMode)
{
    BlockMode = blockMode;
}
bool TTcpClient :: getBlockMode()
{
    return BlockMode;
}



void  TTcpClient :: setSockIP()
{
    sockIP = chars2uintServerIP();
}

void  TTcpClient :: setSockPort()
{
    sockPort = chars2ushortSockPort();
}

uint16_t TTcpClient :: getSockPort()
{
	return sockIP;
}
uint32_t TTcpClient :: getSockIP()
{
	return sockPort;
}

int16_t TTcpClient :: parseDigitValRemotePort()
{
    // To parse the digital value

    int16_t i,j,l;
    char chNumber[TCPHOST_LENGTH];
    char * chNumber1 = RemotePort;

    l = strlen(chNumber1);
    j = 0;
    for(i=0;i<l&&i<10;i++)
        {
        // To parse the digital value
           if(chNumber1[i]>=0x30 && chNumber1[i]<=0x39)
                {
                  // Only 0 - 9 digits are valid
                  chNumber[j] = chNumber1[i];
                  j++;
                }
            else
               {
               // Skip white symbols (spaces and tabs)
                  if(chNumber1[i]!=0x20 && chNumber1[i]!=0x09)
                      {
                      // error was found
                      return -1;
                      }
               }
        }
    chNumber[j]=0;  // to place the terminal symbol
    strcpy(RemotePort,chNumber);

    return 0;
}


uint16_t TTcpClient :: chars2ushortSockPort()
{
	// To convert the socket server port number from string to unsigned short for the net order
	int inumber, rc;

	if(parseDigitValRemotePort()!=0)
		 {
		  // Error was occurred while parsing
		   return 0; // error occurred
		 }
	rc = sscanf(RemotePort,"%d",&inumber);
	if(rc!=1) return 0; // error occurred
	if(inumber<1 || inumber>MAX_TCP_PORT) return 0; // error occurred

	return (uint16_t) htons(inumber);
}

uint32_t TTcpClient :: chars2uintServerIP()
{
	// To convert the server IP-address from char string (dot-delimited) to unsigned int for the net order

	int IP1,IP2,IP3,IP4;
	int rc;
	uint32_t IPaddr;

	rc = sscanf(RemoteHost,"%d.%d.%d.%d",&IP1,&IP2,&IP3,&IP4);
	if(rc!=4) return 0;  // error occurred
	IPaddr = ((unsigned int)(IP1)<<24) +
					  ((unsigned int)(IP2)<<16) +
					  ((unsigned int)(IP3)<<8) +
					  (unsigned int)(IP4);
	return (unsigned int) htonl(IPaddr);
}
