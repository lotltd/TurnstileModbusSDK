#ifndef UMODBUS_H
#define UMODBUS_H


#include <stdio.h>
#include <string.h>

#include "uTypes.h"
#include "uCrc16.h"
#include "uSerial.h"
#include "uTtcp.h"

#define DEVICE_INFO_LENGTH 256
#define DEFAULT_TIMEOUT 50
#define SCANNER_TIMEOUT 60

typedef enum TModbusError_t
{
    merNone = 0,
    merCantOpenPort,     // invalid port
    merTimeout,
    merAddressError,     // sent and received addresses were not equal
    merFuncError,        // sent and received function codes were not equal
    merCRCError,		 // crc16 error
    merWrongToLength,    // <253
    merWrongFromLength,  // from controller
    merModbusRecError,   // controller's error answered through MODBUS
    merWrongDataLenFrom, // wrong data length received from controller
    merWrongDataLenTo,   // wrong data length sent to controller
    merMBFunctionCode,   // modbus error
    merMBDataAddress,    // modbus error
    merMBDataValue,      // modbus error
    merMBFuncExecute,    // modbus error
    merMFLenError,       // MiFARE module errors
    merLast,
    merUndef = 255
}TModbusError;

extern const char * StrModbusError[merLast+1];

typedef struct TAddrQtyRec_t
{
   Word Addr;
   Word Qty;
}TAddrQtyRec;

typedef struct TAddrDataRec_t
{
   Word Addr;
   Word Qty;
}TAddrDataRec;

typedef struct TRegDataRec_t
{
   Word Addr;
   Word Qty;   //  data length in words !!! (bytes * 2)
   byte data[BYTESARRAY_MAXLENGTH];
}TRegDataRec;

typedef struct TResultRec_t
{
    byte Qty;
    byte data[BYTESARRAY_MAXLENGTH];
}TResultRec;

class TModbus
{
  private:

    bool FModbusTCP;
    TComPort * FPort;
    TTcpClient * FSocket;
    byte FTimeout;

    TModbusError SendTCP(cardinal TxSleep, bytesArray * datain, bytesArray * dataout);
    TModbusError SendRTU(cardinal TxSleep, bytesArray * datain, bytesArray * dataout);

    bool TCPConnect();
    bool RTUConnect();

  public:

    TModbus(int Port, int Speed);
    TModbus(char * Host, int Port, bool blockMode=1);
    ~TModbus();

    TModbusError Send(cardinal ATxSleep, byte Address, byte Func, bytesArray * data, bytesArray * dataout);

    TModbusError ReadCoilStatus(byte Address, TAddrQtyRec * param, TResultRec * output);            // 1
//    TModbusError ReadDiscreteInputs(byte Address, TAddrQtyRec * param, TResultRec * output);        // 2
    TModbusError ReadHoldingRegisters(byte Address, TAddrQtyRec * param,  TResultRec * output);     // 3
//    TModbusError ForceSingleCoil(byte Address, Word OutputAddr, boolean state);                     // 5
//    TModbusError PresetSingleRegister(byte Address, TAddrDataRec * param);                          // 6
    TModbusError WriteMultipleRegisters(byte Address, TRegDataRec * input);                         //16

    //  Call modbus function
    TModbusError CallFunction(byte Address, byte code, byte subcode, bytesArray * data, bytesArray * dataout);

    //  search device
    byte FindFirst();
    byte FindNext(byte FromID);


    bool Connect();

    byte GetTimeOut(){return FTimeout;};
    void SetTimeOut(byte fTimeOut){FTimeout = fTimeOut;};

    bool GetModbusType(){return FModbusTCP;};
    TComPort * GetSerialChannel(){return FPort;};
    TTcpClient * GetSocketChannel(){return FSocket;};

    TModbusError ModbusError;

};


#endif  // UMODBUS_H
