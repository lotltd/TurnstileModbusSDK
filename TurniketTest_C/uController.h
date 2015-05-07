#ifndef UCONTROLLER_H
#define UCONTROLLER_H

#include "uTypes.h"
#include "uModbus.h"
#include "uCommonDevice.h"


class TController : public TCommonModbusDevice
{
    TModbusError ReadData(byte Addr, Word RegAddr, Word & Ans);
    TModbusError ReadData(byte Addr, Word RegAddr, bytesArray * Ans, byte Count);
    TModbusError WriteState(byte Addr, Word RegAddr, wordsArray * Value);

    public:

    //Input scanner data
    TModbusError GetEnterCard(byte Addr, bool & IsNew, TAr * CardNum, Word & Count);

    //Output scanner data
    TModbusError GetExitCard(byte Addr, bool & IsNew, TAr * CardNum, Word & Count);

    //Input status
    //0	- pass closed;
    //(1-$FFFE) - number of valid passes
    //$FFFF - free pass
    TModbusError GetEnter(byte Addr, Word & Value);

    //Output status
    //0	- pass closed;
    //(1-$FFFE) - number of valid passes
    //$FFFF - free pass
   TModbusError GetExit(byte Addr, Word & Value);

    //0 - normal mode
    //1 - blocked mode
    //2 - antipanic mode
   TModbusError GetPassState(byte Addr, Word & Value);

    //Errors:
    //0 - There is not any error
    //!=0 - There are several errors in the system
   TModbusError GetErrorState(byte Addr, Word & Value);

    //Number of input passes
   TModbusError GetEnterCount(byte Addr, LongWord & Value);

    //Number of output passes
   TModbusError GetExitCount(byte Addr, LongWord & Value);

    //Input status
    //0 - Input pass is free
    //!=0 - there is an object in the input pass
    TModbusError GetEnterState(byte Addr, Word & Value);

    //Output status
    //0 - Output pass is free
    //!=0 - there is an object in the output pass
    TModbusError GetExitState(byte Addr, Word & Value);

    //Permission for accumulation passes
    //0 - accumulation of passes is disabled
    //1 - accumulation of passes is enabled
    TModbusError SetAccumulPas(byte Addr, byte State);

    //0 - Set normal mode
    //1 - Set blocked mode
    //2 - Set antipanic mode
    TModbusError SetPassState(byte Addr, byte State);

    //set turnicet controller speed (divided by 100)
    TModbusError SetControllerSpeed(byte Addr, LongWord Value);

    //set scaner speed (divided by 100)
    TModbusError SetScannerSpeed(byte Addr, Word Value);

    //0	- pass is closed
    //(1-$FFFE) - number of valid passes
    //$FFFF - free pass enabled
    TModbusError SetEnter(byte Addr, Word State);

    //0	- pass is closed
    //(1-$FFFE) - number of valid passes
    //$FFFF - free pass enabled
    TModbusError SetExit(byte Addr, Word State);

    //Time needed to pass after permission in seconds
    TModbusError SetAfterPermissionPassTime(byte Addr, byte State);

    //Time needed after the pass start in seconds
    TModbusError SetAfterStartPassTime(byte Addr, byte State);

    //Engine timeout in seconds
    TModbusError SetEngineTime(byte Addr, byte State);

    //Green input:
    //signal on time in 100 ms intervals (OnTime)
    //signal off time in 100 ms intervals (OffTime)
    //Common indication cycle time in 100 ms intervals (LengthTime)
    //Value 0xFFFF - unlimited time
    TModbusError SetEnterGreen(byte Addr, Word OnTime, Word OffTime, Word LengthTime);

    //Red input:
    //signal on time in 100 ms intervals (OnTime)
    //signal off time in 100 ms intervals (OffTime)
    //Common indication cycle time in 100 ms intervals (LengthTime)
    //Value 0xFFFF - unlimited time
    TModbusError SetEnterRed(byte Addr, Word OnTime, Word OffTime, Word LengthTime);

    //Green output:
    //signal on time in 100 ms intervals (OnTime)
    //signal off time in 100 ms intervals (OffTime)
    //Common indication cycle time in 100 ms interval (LengthTime)
    //Value 0xFFFF - unlimited time
    TModbusError SetExitGreen(byte Addr, Word OnTime, Word OffTime, Word LengthTime);

    //Red output:
    //signal on time in 100 ms intervals (OnTime)
    //signal off time in 100 ms intervals (OffTime)
    //Common indication cycle time in 100 ms interval (LengthTime)
    //Value 0xFFFF - unlimited time
    TModbusError SetExitRed(byte Addr, Word OnTime, Word OffTime, Word LengthTime);

    TModbusError GetDemo(byte Addr, Word & State);

    TModbusError SetDemo(byte Addr, byte State);
};

extern TRoundingMode GRoundingMode;

double Dround(double number);

#endif // UCONTROLLER_H
