#include "uTypes.h"
#include "uModbus.h"
#include "uSerial.h"
#include "uTtcp.h"
#include "uCrc16.h"

const char * StrModbusError[merLast+1] =
{
    "OK",
    "Can't open channel",
    "Device connection timeout",
    "Sent and received addresses are not equal",
    "Sent and received func codes are not equal",
    "Device packet CRC error",
    "Too long packet for device",
    "Packet length error",
    "Modbus error",
    "Wrong data length from device",
    "Wrong data length for device",
    "Modbus error (1) Illegal function",
    "Modbus error (2) Illegal data address",
    "Modbus error (3) Illegal data value",
    "Modbus error (4) Function execution",
    "MiFARE module error",
    "NONE"
};

TModbusError TModbus :: CallFunction(byte Address, byte code, byte subcode, bytesArray * data, bytesArray * dataout)
{
    bytesArray bdata;

    bdata.length = data->length +1;
    bdata.data[0] = subcode;
    for(int i=0; i< data->length; i++) bdata.data[i+1] = data->data[i];
    TModbusError err = Send(100, Address, code, &bdata, dataout);
    return err;
}


TModbus :: TModbus(int Port, int Speed)
{
    if(Port < 0 || Port > MAX_VALID_PORT)
    {
        FPort=NULL;
        ModbusError = merCantOpenPort;
    }
    else
    {
        FPort = new TComPort();
        if(FPort==NULL)
        {
            ModbusError = merCantOpenPort;
        }
        else
        {
            FModbusTCP = 0;
            ModbusError = merNone;
#ifdef QNX_X86
            sprintf(FPort->Port,DEVSERPATH"%d",Port);
#else
			sprintf(FPort->Port,DEVSERPATH"%d",Port);  // should be corrected for real system: Port-1 or Port
#endif            
            FTimeout = DEFAULT_TIMEOUT;
            switch(Speed)
            {
            case 115200:
                FPort->setBaudRate(B115200);
                break;
            case 9600:
                FPort->setBaudRate(B9600);
                break;
            case 2400:
                FPort->setBaudRate(B2400);
                break;
            case 1200:
                FPort->setBaudRate(B1200);
                break;
            default:
                FPort->setBaudRate(B115200);
                break;
            }
            if(FPort->Open()<0)
            {
                delete FPort;
                FPort = NULL;
                ModbusError = merCantOpenPort;
            }
        }
    }
}

bool TModbus :: Connect()
{
    if(!FModbusTCP) return RTUConnect();
    else return TCPConnect();
    return 0;
}


TModbus :: TModbus(char * Host, int Port, bool blockMode)
{
    if(Port < 1 || Port > MAX_TCP_PORT)
    {
        ModbusError = merCantOpenPort;
        FSocket = NULL;
    }
    else
    {
        FSocket = new TTcpClient(blockMode);
        if(FSocket==NULL)
        {
            ModbusError = merCantOpenPort;
        }
        else
        {
            ModbusError = merNone;
            FModbusTCP = 1;
            FTimeout = DEFAULT_TIMEOUT;
            strcpy(FSocket->RemoteHost,Host);
            sprintf(FSocket->RemotePort,"%d",Port);
            FSocket->setSockIP();
            FSocket->setSockPort();
            if(!(FSocket->getSockIP()) || !(FSocket->getSockPort()))
            {
                ModbusError = merCantOpenPort;
                delete FSocket;
                FSocket = NULL;
            }
            FSocket->setBlockMode(1);  // default mode for tcp communication
        }
    }
}


TModbus :: ~TModbus()
{
    if(FModbusTCP)
    {
        if(FSocket != NULL)
        {
            FSocket->Close();
            delete FSocket;
            FSocket=NULL;
        }
    }
    else
    {
        if(FPort!= NULL)
        {
            FPort->Close();
            delete FPort;
            FPort=NULL;
        }
    }
}


byte TModbus :: FindFirst()
{
    byte i;
    TAddrQtyRec param;
    TResultRec output;

    param.Addr = 0;
    param.Qty = 0;
    for(i=1;i<=250;i++)  // Valid modbus device addresses are from 1 to 247 !!!
    {
        ModbusError = ReadHoldingRegisters(i, &param, &output);
        if(ModbusError != merCantOpenPort &&
           ModbusError != merTimeout &&
           ModbusError != merWrongDataLenTo)
        {
            return i;
        }
        usleep(GetTimeOut()*1000);
    }
    return 0;
}

byte TModbus :: FindNext(byte FromID)
{
    byte i;
    TAddrQtyRec param;
    TResultRec output;
    param.Addr = 0;
    param.Qty = 1;
    for(i=FromID+1; i<=250; i++)  // Valid addresses are from 1 to 247 !!!
    {
        ModbusError = ReadHoldingRegisters(i, &param, &output);
        if(ModbusError!=merCantOpenPort &&
           ModbusError!= merTimeout &&
           ModbusError != merWrongDataLenTo)
        {
            return i;
        }
    }
    return 0;
}


/*

TModbusError TModbus :: ForceSingleCoil(byte Address, Word OutputAddr, boolean state)
{
    // TODO: should be implemented
    // Is not used in this application
    ModbusError = merNone;
    return merNone;
}

*/

/*

TModbusError TModbus :: PresetSingleRegister(byte Address, TAddrDataRec * param)
{
    // TODO: should be implemented
    // Is not used in this application
    ModbusError = merNone;
    return merNone;
}
*/

TModbusError TModbus :: ReadCoilStatus(byte Address, TAddrQtyRec * param, TResultRec * output)
{
    // Implemented but not used in this application

    bytesArray vin;
    bytesArray vout;

    output->Qty = 0;
    vin.length = 4;
    vin.data[0] = (byte)(((param->Addr) & 0xff00) >> 8);
    vin.data[1] = (byte)((param->Addr) & 0x00ff);
    vin.data[2] = (byte)(((param->Qty) & 0xff00) >> 8);
    vin.data[3] = (byte)((param->Qty) & 0x00ff);
    ModbusError = Send(20 + (param->Qty)/12, Address, 1, &vin, &vout);
    if(ModbusError==merNone)
    {
        if((vout.length < 6) || ((vout.data[2] + 5) != vout.length))
        {
            ModbusError = merWrongDataLenFrom;
            return merWrongDataLenFrom;
        }
        output->Qty = vout.data[3];  // Response's count
        for(byte i = 1; i <= output->Qty; i++) output->data[i-1] = vout.data[i+2]; // Response's data
    }
    return ModbusError;
}


/*
TModbusError TModbus :: ReadDiscreteInputs(byte Address, TAddrQtyRec * param, TResultRec * output)
{
    // TODO: should be implemented
    // Is not used in this application
    ModbusError = merNone;
    return merNone;
}
*/


TModbusError TModbus :: ReadHoldingRegisters(byte Address, TAddrQtyRec * param,  TResultRec * output)
{
    bytesArray vin;
    bytesArray vout;

    ModbusError = merWrongDataLenTo;
    if(param->Qty >= 128) return ModbusError;

    output->Qty = 0;
    vin.length = 4;
    vin.data[0] = (byte)(((param->Addr) & 0xff00) >> 8);
    vin.data[1] = (byte)((param->Addr) & 0x00ff);
    vin.data[2] = (byte)(((param->Qty) & 0xff00) >> 8);
    vin.data[3] = (byte)((param->Qty) & 0x00ff);

    ModbusError = Send(40 + (param->Qty)/2, Address, 3, &vin, &vout);
    if(ModbusError != merNone) return ModbusError;
    if(vout.length != (vout.data[2] + 5))
        {
            ModbusError = merWrongDataLenFrom;
            return ModbusError;
        }
    output->Qty = vout.data[2];
    for(byte i = 1; i <= output->Qty; i++) output->data[i-1] = vout.data[i+2]; // Response's data
    return ModbusError;
}




TModbusError TModbus :: Send(cardinal ATxSleep, byte Address, byte Func, bytesArray * data, bytesArray * dataout)
{
    bytesArray s;

    ModbusError = merNone;  // Clear initial error status
    dataout->length = 0;

    if(data->length >= 253)
    {
        ModbusError = merWrongToLength;
        return ModbusError;
    }

    s.data[0] = Address;
    s.data[1] = Func;
    for(int i=0; i<data->length; i++) s.data[i+2] = data->data[i];
	s.length = data->length+2;
    // Send
    if(FModbusTCP)
    {
    	LongWord tcp_atxsleep = (ATxSleep > MIN_TCP_ATXSLEEP) ? ATxSleep : MIN_TCP_ATXSLEEP;
        ModbusError = SendTCP(tcp_atxsleep,&s,dataout);
    }
    else
    {
        ModbusError = SendRTU(ATxSleep,&s,dataout);
    }
    if(ModbusError != merNone) return ModbusError;

      // Process
  if(!dataout->length)
  {
      ModbusError = merTimeout;
      return ModbusError;
  }
  if(dataout->length < 4 || dataout->length > 250)
  {
      dataout->length = 0;
      ModbusError = merWrongFromLength;
      return ModbusError;
  }
  if(dataout->data[0] != Address)
  {
      ModbusError = merAddressError;
      return ModbusError;
  }

  if(dataout->data[1] != Func)
  {
      if(((dataout->data[1]) ^ 0x80) == Func)
      {
          switch(dataout->data[2])
          {
              case 1:
                ModbusError = merMBFunctionCode;    // ILLEGAL FUNCTION
                break;
              case 2:
                ModbusError = merMBDataAddress;     // ILLEGAL DATA ADDRESS
                break;
              case 3:
                ModbusError = merMBDataValue;       // ILLEGAL DATA VALUE
                break;
              case 4:
                ModbusError = merMBFuncExecute;     // Error while function execution
                break;
              default:
                ModbusError = merTimeout;
                break;
          }
      }
      else ModbusError = merFuncError; // Invalid function code in response packet
  }
  else ModbusError = merNone;

  return ModbusError;
}

TModbusError TModbus :: SendRTU(cardinal TxSleep, bytesArray * datain, bytesArray * dataout)
{
  bytesArray s;
  bytesArray * request = &s;
  bytesArray * response = dataout;
  int i;

  md_crc wCRC16, tCRC16;

  if(FPort==NULL)
  {
     return (ModbusError =  merCantOpenPort);
  }
  if(!FPort->getConnected())
  {
     return (ModbusError =  merCantOpenPort);
  }

  ModbusError = merNone;
  s.length = datain->length + 2;
  wCRC16.d = tCRC16.d = 0;
  wCRC16 = modbus_crc16(&tCRC16, datain);
  for(i=0; i<datain->length; i++) 
  {
  	s.data[i] = datain->data[i]; 
  }
  for(i=0; i<2; i++) 
  {
  	s.data[datain->length+i] = wCRC16.b[i]; 
  }

 //flush
  FPort->Flush();
 //send request
  FPort->writeToSerPort(request);
 //wait for response
  FPort->waitForAnswer(TxSleep);
 //get response
  if(FPort->getInputCount() > 0)
  {
    FPort->readFromSerPort(response);
  }
  else
  {
    return (ModbusError = merTimeout);
  }
  //check crc
  wCRC16.d = tCRC16.d = 0;
  wCRC16 = modbus_crc16(&tCRC16, response);
  if(wCRC16.d != 0)
  {
      return (ModbusError = merCRCError);
  }
  else
  {
      return (ModbusError = merNone);
  }

  return ModbusError;
}

TModbusError TModbus :: SendTCP(cardinal TxSleep, bytesArray * datain, bytesArray * dataout)
{
    int cnt;
    bytesArray s;
    md_crc wCRC16, tCRC16;
    bytes2word len;
	
	dataout->length = 0;
    ModbusError = merNone;
    len.d = datain->length;
    s.length = datain->length + 6;
    s.data[0] = 0;  // Transaction ID (Hi)
    s.data[1] = 1;  // Transaction ID (Lo)
    s.data[2] = s.data[3] = 0;  // Modbus TCP protocol ID == 0
#if  defined(QNX_X86) || (defined(__BYTE_ORDER) && __BYTE_ORDER == __LITTLE_ENDIAN) || !defined(__BYTE_ORDER)
    s.data[4] = len.b[1];  // Hi
    s.data[5] = len.b[0];  // Lo
#else  // big-endian otherwise
    s.data[4] = len.b[0];  // Hi
    s.data[5] = len.b[1];  // Lo
#endif
    for(int i = 0; i < datain->length; i++) 
    {
    	s.data[i+6] = datain->data[i];
    }
    if(!FSocket->getConnected())
    {
        FSocket->Close();
        if(!TCPConnect())
        {
           return (ModbusError = merCantOpenPort);
        }
    }
    FSocket->Flush();
    // send request  
    cnt = FSocket->writeToTcpSocket(&s);
    // try to resend if socket closed
     if(cnt<=0)
     {
      FSocket->Close();
      if(TCPConnect())
      {
          cnt = FSocket->writeToTcpSocket(&s);
      }
     }
    
    if(cnt != (int)(s.length))
    {
      FSocket->Close();
      return (ModbusError = merCantOpenPort);
    }

    // wait and read answer
    if( FSocket->waitAndReadAnswer(TxSleep) <= 0)
    {
        //  0   incompleet packet
        //  -1  read Socket error
        //  -2  ModbusTCP header error (may be dust)
        return (ModbusError = merTimeout);
    }
    FSocket->readFromBuff(dataout);
  	if(dataout->length < 9)
  	{
      dataout->length = 0;
      return (ModbusError = merWrongFromLength);
  	}
    if(((Word)(dataout->data[4]))*256 + (Word)(dataout->data[5]) != (dataout->length - 6))
	  {
	      dataout->length = 0;
	      return (ModbusError = merWrongFromLength);
	  }
    for(int i = 6; i < dataout->length; i++)
	  {
	    dataout->data[i-6] = dataout->data[i];
	  }
	dataout->length = dataout->length - 6;
	  // Add crc16
	wCRC16.d = tCRC16.d = 0;
	wCRC16 = modbus_crc16(&tCRC16, dataout);
	dataout->data[dataout->length] = wCRC16.b[0];
	dataout->data[dataout->length+1] = wCRC16.b[1];
	dataout->length = dataout->length + 2;

	return (ModbusError = merNone);
}


bool TModbus :: TCPConnect()
{
    bool rc = 0;
    if(!FModbusTCP)
    {
        return rc;
    }
    rc = FSocket->Connect();
    return rc;
}

bool TModbus :: RTUConnect()
{
    bool rc = 0;
    if(FModbusTCP)
    {
        return rc;
    }
    FPort->Open();
    return FPort->getConnected();
}


TModbusError TModbus :: WriteMultipleRegisters(byte Address, TRegDataRec * input)
{
    bytesArray vin;
    bytesArray output;

    ModbusError = merWrongDataLenTo;

    if(input->Qty >= 128) return ModbusError;

    vin.length = 5 + input->Qty * 2;
    vin.data[0] = (byte)(((input->Addr) & 0xff00) >> 8);
    vin.data[1] = (byte)((input->Addr) & 0x00ff);
    vin.data[2] = (byte)(((input->Qty) & 0xff00) >> 8);
    vin.data[3] = (byte)((input->Qty) & 0x00ff);
    vin.data[4] = (byte)((input->Qty)*2);
    for(int i = 0; i < (input->Qty)*2; i++) vin.data[i+5] = input->data[i];  // like ArrByteToString

    ModbusError = Send(10 + FTimeout + input->Qty, Address, 16, &vin, &output);

    if(ModbusError != merNone) return ModbusError;
    if((((Word)(output.data[4]))*256 + (Word)(output.data[5])) != input->Qty)
        {
            ModbusError = merWrongDataLenFrom;
        }
    return ModbusError;
}

