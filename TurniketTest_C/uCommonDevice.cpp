#include "uCommonDevice.h"

TModbusError TCommonModbusDevice :: ReadDeviceIdentification(byte Addr)
{
	if(FIdent == NULL) return merCantOpenPort;
	return ReadDeviceIdentification(Addr, FIdent);
}

TModbusError TCommonModbusDevice :: ReadDeviceIdentification(byte Addr, TModbusIdentification * Ident)
{
    bytesArray s, dataout;
    bytesArray ttt;
    byte k;
    TModbusError err;
    int i;

    ttt.data[0] = 1;
    ttt.length = 2;

    for(k=0; k <=3; k++)
    {
        ttt.data[1] = k;
        err = FModbus->CallFunction(Addr, 43, 14, &ttt, &dataout);
        if(err != merNone )
        {
        	return err;
        }
        if(dataout.length >= 12)
        {
	        for(i=0; i<dataout.data[9] && i<dataout.length-12; i++)
	        {
	        	s.data[i] = dataout.data[i+10];
	        	if(!(s.data[i])) s.data[i] = 0x20; // replace zero with blank
	        }
	        s.data[i] = 0; 
	        s.length = i;
	        switch(k)
	        {
	            case 0:
	                strcpy(Ident->Company,(const char *)(s.data));
	                break;
	            case 1:
	                strcpy(Ident->Product,(const char *)(s.data));
	                break;
	            case 2:
	                strcpy(Ident->Version,(const char *)(s.data));
	                break;
	            case 3:
	                strcpy(Ident->VendorURL,(const char *)(s.data));
	                break;
	            default:
	                strcpy(Ident->Company,(const char *)s.data);
	                break;
	        }	        
        } 
        else
        {
        	s.data[0] = 0;
        	s.length = 0;
        	err = merWrongFromLength;
        	break;
        }         
        if(dataout.data[5]!= 0xFF)   break;  // No More Follows
    }
	return err;
}


void TCommonModbusDevice :: SetTimeOut(byte Value)
{
    FModbus->SetTimeOut(Value);
}


bool TCommonModbusDevice :: Close()
{
    if(FModbus != NULL)
    {
        delete FModbus;
        FModbus = NULL;
        return 1;
    }
    return 0;
}


bool TCommonModbusDevice :: Connect()
{
    if(FModbus == NULL)
    {
        return 0;
    }
    return FModbus->Connect();
}


TCommonModbusDevice :: TCommonModbusDevice()
{
    FModbus = NULL;
    FIdent = NULL;
    BlockMode = 1;  // Default mode for TCP Sockets is blocked mode
}


TCommonModbusDevice :: ~TCommonModbusDevice()
{
    if(FModbus!=NULL) delete FModbus;
    if(FIdent!=NULL) delete FIdent;
    FModbus = NULL;
    FIdent = NULL;
}


byte TCommonModbusDevice :: FindFirst()
{
    if(FModbus!=NULL) return FModbus->FindFirst();
    return 0;
}


byte TCommonModbusDevice :: FindNext(byte FromID)
{
    if(FModbus!=NULL) return FModbus->FindNext(FromID);
    return 0;
}


bool TCommonModbusDevice :: Open(int Port, int Speed)
{
    FIdent = new TModbusIdentification();
    FModbus = new TModbus(Port, Speed);
    if(FModbus != NULL && FIdent != NULL)
    {
        strcpy(FIdent->Company,"");
        strcpy(FIdent->Product,"");
        strcpy(FIdent->VendorURL,"");
        strcpy(FIdent->Version,"");
        return FModbus->Connect();
    }
    return 0;
}

bool TCommonModbusDevice :: Open(int Port, int Speed, int Adr)
{
    FModbus = NULL;
    FIdent = NULL;
    TModbusError err = merNone;
	
    FIdent = new TModbusIdentification();
    if(FIdent != NULL)
    {
        strcpy(FIdent->Company,"");
        strcpy(FIdent->Product,"");
        strcpy(FIdent->VendorURL,"");
        strcpy(FIdent->Version,"");
        FModbus = new TModbus(Port,Speed);

        if(FModbus != NULL)
        {
            err=ReadDeviceIdentification(Adr);
            if(err!=merNone && err != merTimeout)
            {
                if(FModbus!=NULL)
                {
                	delete FModbus;
                	FModbus = NULL;
                }
                if(FIdent!=NULL)
                {
                	delete FIdent;
                	FIdent = NULL;
                }
                return 0;
            }
            return 1; // OK
        }
        else
        {
        	if(FIdent!=NULL)
        	{
				delete FIdent;
				FIdent = NULL;
        	}
            return 0;
        }
    }
    return 0;
}


bool TCommonModbusDevice :: Open(char * Host, int Port)
{
	FIdent = new TModbusIdentification();
	FModbus = new TModbus(Host,Port,BlockMode);
    if(FModbus != NULL && FIdent != NULL)
    {
        strcpy(FIdent->Company,"");
        strcpy(FIdent->Product,"");
        strcpy(FIdent->VendorURL,"");
        strcpy(FIdent->Version,"");
        return FModbus->Connect();
    }
    return 0;
}

bool TCommonModbusDevice :: Open(char * Host, int Port, byte Adr)
{
    TModbusError err = merNone;
    FModbus = NULL;
    FIdent = NULL;
    FIdent = new TModbusIdentification();
    if(FIdent != NULL)
    {
        strcpy(FIdent->Company,"");
        strcpy(FIdent->Product,"");
        strcpy(FIdent->VendorURL,"");
        strcpy(FIdent->Version,"");
        FModbus = new TModbus(Host,Port);
        if(FModbus != NULL)
        {
            err = ReadDeviceIdentification(Adr);
            if(err!=merNone && err!=merTimeout)
            {
                if(FModbus != NULL)
                {
                	delete FModbus; 
                	FModbus = NULL;
                }
                if(FIdent != NULL)
                {
                	delete FIdent; 
                	FIdent = NULL;
                }                                
                return 0;
            }
            return 1;
        }
        else
        {
            if(FIdent != NULL)
            {
            	delete FIdent;
            	FIdent = NULL;
            }
            return 0;
        }
    }
    return 0;
}
