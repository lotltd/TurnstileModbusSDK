#ifndef UMAIN_H
#define UMAIN_H

#include "uController.h"

#define CONTROLLERSPEED 115200
#define SCANNERSPEED 2400
#define SERIAL_PORT 1
#define HOST_IP "18.0.0.254"
#define TCP_PORT 502

#define DEFAULT_CONFIG "./CardStorageRef.cfg"  // Card Storage Reference file name
#define CARDDATALENGTH 30						// Card data max length in hex symbols
#define CARDSTORAGEREF_LENGTH 500				// Max number of card in cards storage
#define CFGBUFF_MAX_SIZE 16000					// Max length of Card Storage Reference file
#define CFGARRAY_MAX_SIZE CARDSTORAGEREF_LENGTH		// The same as before (alias)





typedef enum ChannelType_t
{
	rtuType,
	tcpType
} ChannelType;

class CardStorageRef
{
	unsigned int CardsCount;
	TAr Card[CARDSTORAGEREF_LENGTH];
	byte CardLength[CARDSTORAGEREF_LENGTH];

	public:
	CardStorageRef()
	{
		CardsCount = 0;
		for(unsigned int i=0; i<CARDSTORAGEREF_LENGTH; i++)
		{
			CardLength[i] = 0;
			memset((void *)(this->Card[i].data),0,TARSIZE);
		}
	};
	unsigned int getCardsCount(){return CardsCount;};
	void setCardsCount(unsigned int cardsCount)
	{
		CardsCount = cardsCount;
	};
	void getCard(unsigned int cardIdx, TAr & card, byte & cardLength)
	{
		cardLength = 0;
		memset((void *)(card.data),0,TARSIZE);

		if(cardIdx > CARDSTORAGEREF_LENGTH || cardIdx > CardsCount) return;
		cardLength = CardLength[cardIdx];
		if(cardLength)
			for(byte i = 0; i < cardLength; i++)
			{
				card.data[i] = Card[cardIdx].data[i];
			}
	};
	void setCard(unsigned int cardIdx, TAr & card, byte cardLength)
	{
		if(cardIdx > CARDSTORAGEREF_LENGTH || cardIdx > CardsCount) return;
		memset((void *)(this->Card[cardIdx].data),0,TARSIZE);
		CardLength[cardIdx] = cardLength;
		if(cardLength)
			for(byte i = 0; i < cardLength; i++)
			{
				Card[cardIdx].data[i] = card.data[i];
			}
	};
};

class TfmMain
{

    byte Addr;
    int Port;
    int Speed;
    char HostIP[256];
    TController * FController;
    ChannelType ChnlType;



public:

    CardStorageRef * pCardStorageRef;
    TModbusError ModbusError;
    LongWord EnterCount;
    LongWord ExitCount;
    bool EngineBlockState;
    byte AfterPermissionPassTime;
    byte AfterStartPassTime;
    byte EngineTime;
    EnterExit rgEnter;  // eeClosed, eeFree
    EnterExit rgExit;  // eeClosed, eeFree
    EnExStates rgExitState;  // eClosed, eCounted, eFree
    EnExStates rgEnterState;  // eClosed, eCounted, eFree
    EnExPassStates rgExitPassState;  // eePassFree, eePassStarted
    EnExPassStates rgEnterPassState;  // eePassFree, eePassStarted
    PassStates rgPassState;  // passNormal, passBlocked, passAntiPanic

    Word EnterGreen_OnTime;
    Word EnterGreen_OffTime;
    Word EnterGreen_LengthTime;
    Word EnterRed_OnTime;
    Word EnterRed_OffTime;
    Word EnterRed_LengthTime;
    Word ExitGreen_OnTime;
    Word ExitGreen_OffTime;
    Word ExitGreen_LengthTime;
    Word ExitRed_OnTime;
    Word ExitRed_OffTime;
    Word ExitRed_LengthTime;

    TAr Card;
    TAr Card2;
    TAr CardASCII;
    TAr Card2ASCII;

    Word ScannerSpeed;

    char Company[DEVICE_INFO_LENGTH];
    char Product[DEVICE_INFO_LENGTH];
    char Version[DEVICE_INFO_LENGTH];
    char VendorURL[DEVICE_INFO_LENGTH];
    char Caption[DEVICE_INFO_LENGTH];

    bool cbDemo;

    bool StartRTU();
    byte StartFirstRTU();
    bool StartTCP();
    byte StartFirstTCP();

    void SetEnter();
    void SetExit();

    void SetControllerSpeed();
    void SetAfterPermissionPassTime();
    void SetAfterStartPassTime();
    void SetEngineTime();
    void SetPassState();
    void SetEnterGreen();
    void SetEnterRed();
    void SetExitGreen();
    void SetExitRed();
    void SetEnterPass();
    void SetExitPass();
    void SetScannerSpeed();
    void SetScannerSpeed(Word scanSpeed);
    void SetDemo();
    bool IsFControllerCreated()
    {
    	return (FController != NULL);
    };
    void setPort(int port);
    void setAddr(byte addr);
    void setSpeed(int speed);
    void setHostIP(const char * hostIP);
    int  getPort(){return Port;};
    byte getAddr(){return Addr;};
    int	 getSpeed(){return Speed;};
    char * getHostIP(char * hostIP)
    {
    	strcpy(hostIP,HostIP);
    	return HostIP;
    };
    TController * getController(){return FController;};
    void setChnlType(ChannelType chnlType){ChnlType = chnlType;};
    ChannelType getChnlType(){return ChnlType;};

    TfmMain();
    ~TfmMain(){};
};

void GetEnterStatus(TfmMain * fmMain, Word & n, TModbusError & Error, char * chAnswer); // eClosed, eCounted, eFree
void GetExitStatus(TfmMain * fmMain, Word & n, TModbusError & Error, char * chAnswer);  // eClosed, eCounted, eFree
void GetEnterState(TfmMain * fmMain, Word & n, TModbusError & Error, char * chAnswer);  // eePassFree, eePassStarted
void GetExitState(TfmMain * fmMain, Word & n, TModbusError & Error, char * chAnswer);   // eePassFree, eePassStarted
void GetEnterCount(TfmMain * fmMain, LongWord & ln, TModbusError & Error);
void GetExitCount(TfmMain * fmMain, LongWord & ln, TModbusError & Error);
void GetErrorState(TfmMain * fmMain, Word & n, TModbusError & Error);

void GetEnterCard(TfmMain * fmMain, bool & IsNew, TAr * pCard, Word & Count, TModbusError & Error);
void GetExitCard(TfmMain * fmMain, bool & IsNew, TAr * pCard, Word & Count, TModbusError & Error);
void GetDemo(TfmMain * fmMain, Word & n, TModbusError & Error);

void LeftTrim(char * input);
void RightTrim(char * input);
void Trim(char * input);
void IntToHex(byte input, char * output);

void getConfigInfo();
LongInt loadConfigFile(char * configFileName);
unsigned int FindCard(TAr * Card,Word Count, CardStorageRef * pCardStorageRef);
bool checkCard(TAr * Card, Word & Count, TfmMain * pMain);

extern TfmMain rtuMain, tcpMain;

#endif // UMAIN_H
