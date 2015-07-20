#include "uController.h"


TRoundingMode GRoundingMode = rmUp;

TRoundingMode GetRoundMode()
{
    return GRoundingMode;
}

void SetRoundMode(TRoundingMode roundMode)
{
    GRoundingMode = roundMode;
}

double Dround(double number)
{	
    int32_t Lround;
    
    TRoundingMode rmd;
    double mnumber = number*(-1);

    rmd = GetRoundMode();
    if(rmd==rmNearest)
    {
        Lround = (number >= 0) ? (int32_t)(number + 0.5) : (int32_t)(number - 0.5);
        return (double)Lround;
    }
    else if(rmd==rmDown)
    {
        Lround = (number >= 0) ? (int32_t)(number) : (int32_t)(number - 1);
        return (double)Lround;
    }
    else if(rmd==rmTruncate)
    {
        return (double)((int32_t)(number));
    }
    else // rmd==rmUp or default (undefined)
    {
        if(number > 0)
        {
        Lround = (number - (double)((int32_t)(number)) > 0) ? (int32_t)(number + 1) : (int32_t)(number);
        return (double)Lround;
        }
        else if(number==0)
        {
            return 0;
        }
        else // number < 0
        {
            Lround = (mnumber - (double)((int32_t)(mnumber)) > 0) ? (int32_t)(mnumber + 1) : (int32_t)(mnumber);
            return (double)(Lround*(-1));
        }
    }
}


TModbusError TController :: GetErrorState(byte Addr, Word & Value)
{
    return ReadData(Addr,0x48,Value);
}


TModbusError TController :: GetDemo(byte Addr, Word & State)
{
    return ReadData(Addr,0x666,State);
}


TModbusError TController :: GetEnter(byte Addr, Word & Value)
{
    return ReadData(Addr,0x40,Value);
}


TModbusError TController :: GetEnterCard(byte Addr, bool & IsNew, TAr * CardNum, Word & Count)
{
    bytesArray s;
    TRoundingMode OldRM;
    TModbusError err;

    OldRM = GetRoundMode();
    memset(CardNum->data,0,TARSIZE);
    err = ReadData(Addr, 0x100, Count);
    if(err == merNone)
        {
            IsNew = (bool)((Count & 0xff00)>>8);
            Count = Count & 0x00ff;
            if(Count && IsNew)
            {
                SetRoundMode(rmUp);
                err = ReadData(Addr,0x101,&s,(byte)(Dround(((double)(Count))/2.)));
                if(Count == 15 && s.data[13] == 0x0D && s.data[14] == 0x0A)
                {
                    Count -= 2;  // delete 0x0d 0x0a
                }
                memmove((void *)(CardNum->data),(const void *)(s.data),Count);
            }
        }
    SetRoundMode(OldRM);
    return err;
}


TModbusError TController :: GetEnterCount(byte Addr, LongWord & Value)
{
    Word n;
    TModbusError err;

    ReadData(Addr,0x45,n);
    Value = n;
    err = ReadData(Addr,0x44,n);
    Value = ((Value & 0x0000ffff) << 16) + (LongWord)n;
    return err;
}


TModbusError TController :: GetEnterState(byte Addr, Word & Value)
{
    return ReadData(Addr,0x42,Value);
}


TModbusError TController :: GetExit(byte Addr, Word & Value)
{
    return ReadData(Addr,0x41,Value);
}


TModbusError TController :: GetExitCard(byte Addr, bool & IsNew, TAr * CardNum, Word & Count)
{
    TModbusError err;
    bytesArray s;
    TRoundingMode OldRM;

    OldRM = GetRoundMode();
    memset((void *)CardNum->data,0,TARSIZE);
    err = ReadData(Addr,0x200,Count);
    if(err == merNone)
    {
        IsNew = (bool)((Count & 0xff00) >> 8);
        Count = Count & 0x00ff;
        if(Count && IsNew)
        {
            SetRoundMode(rmUp);
            err = ReadData(Addr,0x201,&s,(byte)(Dround(((double)(Count))/2.)));
            if(Count == 15 && s.data[13] == 0x0D && s.data[14] == 0x0A)
            {
                Count -= 2;  // delete 0x0d 0x0a
            }
            memmove((void *)(CardNum->data),(const void *)(s.data),Count);
        }
    }
    SetRoundMode(OldRM);
    return err;
}


TModbusError TController :: GetExitCount(byte Addr, LongWord & Value)
{
    TModbusError err;
    Word n;

    ReadData(Addr,0x47,n);
    Value = (LongWord)n;
    err = ReadData(Addr,0x46,n);
    Value = ((Value &0x0000ffff)<<16) + (LongWord)n;
    return err;
}


TModbusError TController :: GetExitState(byte Addr, Word & Value)
{
    return ReadData(Addr,0x43,Value);
}


TModbusError TController :: GetPassState(byte Addr, Word & Value)
{
    return ReadData(Addr,0x3000,Value);
}


TModbusError TController :: ReadData(byte Addr, Word RegAddr, bytesArray * Ans, byte Count = 1)
{
	TAddrQtyRec param;
	TResultRec output;
	TModbusError err;

	Ans->length = 0;
	param.Addr = RegAddr;
	param.Qty = Count;

	err = FModbus->ReadHoldingRegisters(Addr,&param,&output);
	if(err == merNone)
	{
		if(output.Qty != 0)
		{
			Ans->length = output.Qty;
			memmove((void *)(Ans->data),(const void *)(output.data),output.Qty);
		}
		else
		{
			Ans->length = 0;
			memset((void *)(Ans->data),0,BYTESARRAY_MAXLENGTH+10);
		}
	}
	return err;
}


TModbusError TController :: ReadData(byte Addr, Word RegAddr, Word & Ans)
{
	TAddrQtyRec param;
	TResultRec output;
	TModbusError err;

	Ans = 0;
	param.Addr = RegAddr;
	param.Qty = 1;
	memset((void *)(output.data),0,BYTESARRAY_MAXLENGTH);
	err = FModbus->ReadHoldingRegisters(Addr,&param,&output);
	if(err == merNone)
	{
		if(output.Qty != 0)
		{
			Ans = (((Word)(output.data[0])) << 8) + output.data[1];
		}
	}
	return err;
}

TModbusError TController :: SetControllerSpeed(byte Addr, LongWord Value)
{
    LongWord speed, speed2;
    wordsArray wa;
    speed = Value / 100;
    speed2 = ~speed;
    wa.length = 2;
    wa.data[0] = speed;
    wa.data[1] = speed2;
    return WriteState(Addr,0x4310,&wa);
}


TModbusError TController :: SetDemo(byte Addr, byte State)
{
    wordsArray wa;
    wa.length = 1;
    wa.data[0] = (Word)State;
    return WriteState(Addr,0x666,&wa);
}


TModbusError TController :: SetEngineTime(byte Addr, byte State)
{
    wordsArray wa;
    wa.length = 1;
    wa.data[0] = (Word)State;
    return WriteState(Addr,0x48,&wa);
}


TModbusError TController :: SetEnter(byte Addr, Word State)
{
    wordsArray wa;
    wa.length = 1;
    wa.data[0] = (Word)State;
    return WriteState(Addr,0x40,&wa);
}


TModbusError TController :: SetEnterGreen(byte Addr, Word OnTime, Word OffTime, Word LengthTime)
{
    wordsArray wa;
    wa.length = 3;
    wa.data[0] = OnTime;
    wa.data[1] = OffTime;
    wa.data[2] = LengthTime;
    return WriteState(Addr,0x1000,&wa);
}


TModbusError TController :: SetEnterRed(byte Addr, Word OnTime, Word OffTime, Word LengthTime)
{
    wordsArray wa;
    wa.length = 3;
    wa.data[0] = OnTime;
    wa.data[1] = OffTime;
    wa.data[2] = LengthTime;
    return WriteState(Addr,0x1003,&wa);
}


TModbusError TController :: SetExit(byte Addr, Word State)
{
    wordsArray wa;
    wa.length = 1;
    wa.data[0] = (Word)State;
    return WriteState(Addr,0x41,&wa);
}


TModbusError TController :: SetExitGreen(byte Addr, Word OnTime, Word OffTime, Word LengthTime)
{
    wordsArray wa;
    wa.length = 3;
    wa.data[0] = OnTime;
    wa.data[1] = OffTime;
    wa.data[2] = LengthTime;
    return WriteState(Addr,0x1008,&wa);
}


TModbusError TController :: SetExitRed(byte Addr, Word OnTime, Word OffTime, Word LengthTime)
{
    wordsArray wa;
    wa.length = 3;
    wa.data[0] = OnTime;
    wa.data[1] = OffTime;
    wa.data[2] = LengthTime;
    return WriteState(Addr,0x1009,&wa);
}


TModbusError TController :: SetAccumulPas(byte Addr, byte State)
{
    wordsArray wa;
    wa.length = 1;
    wa.data[0] = (Word)State;
    return WriteState(Addr,0x3010,&wa);
}


TModbusError TController :: SetAfterPermissionPassTime(byte Addr, byte State)
{
    wordsArray wa;
    wa.length = 1;
    wa.data[0] = (Word)State;
    return WriteState(Addr,0x3011,&wa);
}


TModbusError TController :: SetAfterStartPassTime(byte Addr, byte State)
{
    wordsArray wa;
    wa.length = 1;
    wa.data[0] = (Word)State;
    return WriteState(Addr,0x3012,&wa);
}


TModbusError TController :: SetPassState(byte Addr, byte State)
{
    wordsArray wa;
    wa.length = 1;
    wa.data[0] = (Word)State;
    return WriteState(Addr,0x3000,&wa);
}


TModbusError TController :: SetScannerSpeed(byte Addr, Word Value)
{
    Word speed;
    wordsArray wa;

    speed = Value / 100;
    wa.length = 1;
    wa.data[0] = (Word)speed;
    return WriteState(Addr,0x4350,&wa);
}

TModbusError TController :: WriteState(byte Addr, Word RegAddr, wordsArray * Value)
{
 	TRegDataRec arec;
 	byte i, j;
 	arec.Addr = RegAddr;
 	arec.Qty = (Value->length);    //*2;  // !!!!!
 	j = 0;
 	for(i=0; i<(Value->length); i++)
 	{
 		arec.data[j] = (byte)(((Value->data[i]) & 0xff00) >> 8);
 		arec.data[j+1] = (byte)((Value->data[i])&0x00ff);
 		j+=2;
 	}
	return FModbus->WriteMultipleRegisters(Addr, &arec);
}

