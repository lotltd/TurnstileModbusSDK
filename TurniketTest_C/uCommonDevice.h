#ifndef UCOMMONDEVICE_H
#define UCOMMONDEVICE_H

#include "uModbus.h"

typedef struct TModbusIdentification_t
{
  char Company[DEVICE_INFO_LENGTH];
  char Product[DEVICE_INFO_LENGTH];
  char Version[DEVICE_INFO_LENGTH];
  char VendorURL[DEVICE_INFO_LENGTH];
}TModbusIdentification;


class TCommonModbusDevice
{
protected:
    TModbus * FModbus;
    TModbusIdentification * FIdent;
    bool BlockMode;
    TModbusError ReadDeviceIdentification(byte Addr, TModbusIdentification * Ident);


public:
    TCommonModbusDevice();
    ~TCommonModbusDevice();

    bool Open(int Port, int Speed, int Adr);
    bool Open(int Port, int Speed);
    bool Open(char * Host, int Port, byte Adr);
    bool Open(char * Host, int Port);
    TModbusError ReadDeviceIdentification(byte Addr);
    bool Close();


    byte FindFirst();
    byte FindNext(byte FromID);
    bool Connect();
    void SetTimeOut(byte Value);
    TModbusIdentification * getDeviceInfo(){return FIdent;};
    TModbus * getFModbus(){return FModbus;};

    void SetBlockMode(bool blockMode){BlockMode = blockMode;};
    bool GetBlockMode(){return BlockMode;};
};

#endif // UCOMMONDEVICE_H
