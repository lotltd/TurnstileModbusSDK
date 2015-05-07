#include "uMain.h"

  typedef enum screen_tags_
  {
	scrConnected,
	scrInFreeClosed,
	scrOutFreeClosed,
	scrInCount,
	scrOutCount,
	scrInFreeStart,
	scrOutFreeStart,
	scrInIsNew,
	scrInCard,
	scrOutIsNew,
	scrOutCard
  }screen_tags;
  TfmMain rtuMain, tcpMain;

  char fileBuffer[CFGBUFF_MAX_SIZE];
  char * configLinesArray[CFGARRAY_MAX_SIZE];
  short cfgArraySize;

  char strArr_RTU[scrOutCard+1][80];
  char strArr_TCP[scrOutCard+1][80];

  CardStorageRef cardStorageRef;

  pthread_t rtu_tid, tcp_tid;
  pthread_mutex_t mutex_points = PTHREAD_MUTEX_INITIALIZER;

  unsigned int FindCard(TAr * Card,Word Count, CardStorageRef * pCardStorageRef)
  {
	  unsigned int i, j, refCount;
	  TAr tmpCard;
	  TAr * pTmpCard = NULL;
	  byte tmpCardLength;

	  if(!Count) return 0;  // Empty image

	  refCount = pCardStorageRef->getCardsCount();

	  if(!refCount) return 0; // Empty Card Storage Reference

	  for(i=0; i<refCount; i++)
	  {
		  pCardStorageRef->getCard(i,tmpCard,tmpCardLength);
		  if(!tmpCardLength) continue;
		  if(tmpCardLength != Count) continue;
		  for(j=0; j<Count; j++)
		  {
			  if(Card->data[j] != tmpCard.data[j]) break;
		  }
		  if(j==Count)
		  {
			  pTmpCard = Card;
			  break;
		  }
	  }
	  if(pTmpCard != NULL) return i+1;
	  return 0;
  }

  bool checkCard(TAr * Card, Word & Count, TfmMain * pMain)
  {
  	unsigned int CardsCount = pMain->pCardStorageRef->getCardsCount();
  	if(!CardsCount) // CardStorageRef is empty: don't check the card
  		return 1;
  	else
  	{
  		// Check the card if it has valid data
  		if(FindCard(Card,Count,pMain->pCardStorageRef))
  			return 1; // This card is known for the CardStorageRef
  		else
  			return 0; // The card is unknown for the CardStorageRef
  	}
  	return 0;
  }

  void * rtu_thread(void * )
  {
	Word n, n1, n2, n3;

	bool IsNew, IsNew1;
	TAr Card;
	Word Count;
	TModbusError Error = merNone;
	char chAnswer[256], chAnswer1[256], chAnswer2[256], chAnswer3[256];

	pthread_mutex_lock( &mutex_points );
	strcpy(strArr_RTU[scrConnected],"NO ");
	pthread_mutex_unlock( &mutex_points );

    if(!(rtuMain.IsFControllerCreated()))
    {
          // Can't create FController
          return 0;
    }

    // Auto detection of the first available device in the RTU channel
    while(!rtuMain.getAddr())
    {
    	if(!rtuMain.StartFirstRTU())  // 1 - 250 ??? 247
    	{
    		// Can't create Modbus RTU channel
    		return 0;
    	}
    	if(rtuMain.getAddr()) break;
    	// Nobody answered : try again
    	sleep(2);
    }
    Error = rtuMain.ModbusError = rtuMain.getController()->ReadDeviceIdentification(rtuMain.getAddr());
    if(Error != merNone)
    {
	  return 0;
    }

    rtuMain.SetScannerSpeed();
	GetEnterStatus(&rtuMain, n, Error, chAnswer);
	GetExitStatus(&rtuMain, n1, Error, chAnswer1);
	GetEnterState(&rtuMain, n2, Error, chAnswer2);
	GetExitState(&rtuMain, n3, Error, chAnswer3);

	pthread_mutex_lock( &mutex_points );
	strcpy(strArr_RTU[scrConnected],"YES");
	strcpy(strArr_RTU[scrInFreeClosed], chAnswer);
	strcpy(strArr_RTU[scrOutFreeClosed], chAnswer1);
	sprintf(strArr_RTU[scrInCount],"  %u",n);
	sprintf(strArr_RTU[scrOutCount],"  %u",n1);
	strcpy(strArr_RTU[scrInFreeStart], chAnswer2);
	strcpy(strArr_RTU[scrOutFreeStart], chAnswer3);
	pthread_mutex_unlock( &mutex_points );


    while(1)
    {

        GetEnterCard(&rtuMain, IsNew, &Card, Count, Error);
        if(IsNew)
        {
        	if(Error != merNone || rtuMain.pCardStorageRef == NULL)
        	{
        		continue;   // CardStorageRef should be defined for card checking
        	}
        	if(checkCard(&Card, Count, &rtuMain))
        		rtuMain.SetEnterPass();
        	else
        		continue;
        	n=n2=1;
        	while(n>0 || n2>0)
        	{
    	        // Get Enter Status : eClosed, eCounted, eFree
    	        GetEnterStatus(&rtuMain, n, Error, chAnswer);
    	        // Get Enter State : eePassFree, eePassStarted
    	    	GetEnterState(&rtuMain, n2, Error, chAnswer2);

    	    	pthread_mutex_lock( &mutex_points );
    	    	strcpy(strArr_RTU[scrInFreeClosed], chAnswer);
    	    	strcpy(strArr_RTU[scrInFreeStart], chAnswer2);
    	    	sprintf(strArr_RTU[scrInCount],"  %u",n);
    	    	if(IsNew)
    	    	{
    	    		strcpy(strArr_RTU[scrInIsNew]," New");
    	    		strcpy(strArr_RTU[scrInCard],(char*)(rtuMain.Card.data));
    	    	}
    	    	else
    	    	{
    	    		strArr_RTU[scrInIsNew][0]=0;
    	    		strArr_RTU[scrInCard][0]=0;
    	    	}
    	    	pthread_mutex_unlock( &mutex_points );

    	        if(!n && !n2)break;
    	        usleep(100000);
        	}
        }

        pthread_mutex_lock( &mutex_points );
    	if(IsNew)
    	{
    		strcpy(strArr_RTU[scrInIsNew]," New");
    		strcpy(strArr_RTU[scrInCard],(char*)(rtuMain.Card.data));
    	}
    	else
    	{
    		strArr_RTU[scrInIsNew][0]=0;
    		strArr_RTU[scrInCard][0]=0;
    	}
    	pthread_mutex_unlock( &mutex_points );

        usleep(100000);
        GetExitCard(&rtuMain, IsNew1, &Card, Count, Error);
        if(IsNew1)
        {
        	if(Error != merNone || rtuMain.pCardStorageRef == NULL)
        	{
        		continue;   // CardStorageRef should be defined for card checking
        	}
        	if(checkCard(&Card, Count, &rtuMain))
        		rtuMain.SetExitPass();
        	else
        		continue;
        	n1=n3=1;
        	while(n1>0 || n3>0)
        	{
    	        // Get Exit Status : eClosed, eCounted, eFree
    	        GetExitStatus(&rtuMain, n1, Error, chAnswer1);
    	        // Get Exit State : eePassFree, eePassStarted
    	        GetExitState(&rtuMain, n3, Error, chAnswer3);

    	        pthread_mutex_lock( &mutex_points );
    	    	strcpy(strArr_RTU[scrOutFreeClosed], chAnswer1);
    	    	strcpy(strArr_RTU[scrOutFreeStart], chAnswer3);
    	    	sprintf(strArr_RTU[scrOutCount],"  %u",n1);
    	    	if(IsNew1)
    	    	{
    	    		strcpy(strArr_RTU[scrOutIsNew]," New");
    	    		strcpy(strArr_RTU[scrOutCard],(char*)(rtuMain.Card2.data));
    	    	}
    	    	else
    	    	{
    	    		strArr_RTU[scrOutIsNew][0]=0;
    	    		strArr_RTU[scrOutCard][0] = 0;
    	    	}
    	    	pthread_mutex_unlock( &mutex_points );

    	    	if(!n1 && !n3)break;
    	        usleep(100000);
        	}
        }

        pthread_mutex_lock( &mutex_points );
    	if(IsNew1)
    	{
    		strcpy(strArr_RTU[scrOutIsNew]," New");
    		strcpy(strArr_RTU[scrOutCard],(char*)(rtuMain.Card2.data));
    	}
    	else
    	{
    		strArr_RTU[scrOutIsNew][0]=0;
    		strArr_RTU[scrOutCard][0]=0;
    	}
    	pthread_mutex_unlock( &mutex_points );

        usleep(100000);
    }

    return 0;
  }

  void * tcp_thread(void * )
  {
		Word n, n1, n2, n3;

		bool IsNew, IsNew1;
		TAr Card;
		Word Count;
		TModbusError Error = merNone;
		char chAnswer[256], chAnswer1[256], chAnswer2[256], chAnswer3[256];

		pthread_mutex_lock( &mutex_points );
		strcpy(strArr_TCP[scrConnected],"NO ");
		pthread_mutex_unlock( &mutex_points );

	    if(!(tcpMain.IsFControllerCreated()))
	    {
	          // Can't create FController
	          return 0;
	    }

	  	// Auto detection of the first available device in the TCP channel
	    while(!tcpMain.getAddr())
	    {
	    	if(!tcpMain.StartFirstTCP())
	    	{
	    		// Can't create Modbus TCP channel
	    		return 0;
	    	}
	    	if(tcpMain.getAddr()) break;
	    	// Nobody answered : try again
	    	sleep(1);
	    }
	    Error = tcpMain.ModbusError = tcpMain.getController()->ReadDeviceIdentification(tcpMain.getAddr());
	    if(Error != merNone)
	    {
		  return 0;
	    }

	    tcpMain.SetScannerSpeed();
		GetEnterStatus(&tcpMain, n, Error, chAnswer);
		GetExitStatus(&tcpMain, n1, Error, chAnswer1);
		GetEnterState(&tcpMain, n2, Error, chAnswer2);
		GetExitState(&tcpMain, n3, Error, chAnswer3);

		pthread_mutex_lock( &mutex_points );
		strcpy(strArr_TCP[scrConnected],"YES");
		strcpy(strArr_TCP[scrInFreeClosed], chAnswer);
		strcpy(strArr_TCP[scrOutFreeClosed], chAnswer1);
		sprintf(strArr_TCP[scrInCount],"  %u",n);
		sprintf(strArr_TCP[scrOutCount],"  %u",n1);
		strcpy(strArr_TCP[scrInFreeStart], chAnswer2);
		strcpy(strArr_TCP[scrOutFreeStart], chAnswer3);
		pthread_mutex_unlock( &mutex_points );

	    while(1)
	    {
	        GetEnterCard(&tcpMain, IsNew, &Card, Count, Error);
	        if(IsNew)
	        {
	        	if(Error != merNone || tcpMain.pCardStorageRef == NULL)
	        	{
	        		continue;   // CardStorageRef should be defined for card checking
	        	}
	        	if(checkCard(&Card, Count, &tcpMain))
	        		tcpMain.SetEnterPass();
	        	else
	        		continue;

	        	n=n2=1;
	        	while(n>0 || n2>0)
	        	{
	    	        // Get Enter Status : eClosed, eCounted, eFree
	    	        GetEnterStatus(&tcpMain, n, Error, chAnswer);
	    	        // Get Enter State : eePassFree, eePassStarted
	    	        GetEnterState(&tcpMain, n2, Error, chAnswer2);
	    			pthread_mutex_lock( &mutex_points );
	    			strcpy(strArr_TCP[scrInFreeClosed], chAnswer);
	    	    	sprintf(strArr_TCP[scrInCount],"  %u",n);
	    	    	strcpy(strArr_TCP[scrInFreeStart], chAnswer2);
	    	    	if(IsNew)
	    	    	{
	    	    		strcpy(strArr_TCP[scrInIsNew]," New");
	    	    		strcpy(strArr_TCP[scrInCard],(char*)(tcpMain.Card.data));
	    	    	}
	    	    	else
	    	    	{
	    	    		strArr_TCP[scrInIsNew][0]=0;
	    	    		strArr_TCP[scrInCard][0]=0;
	    	    	}
	    			pthread_mutex_unlock( &mutex_points );
	    	        if(!n && !n2)break;
	    	        usleep(100000);
	        	}
	        }
			pthread_mutex_lock( &mutex_points );
	    	if(IsNew)
	    	{
	    		strcpy(strArr_TCP[scrInIsNew]," New");
	    		strcpy(strArr_TCP[scrInCard],(char*)(tcpMain.Card.data));
	    	}
	    	else
	    	{
	    		strArr_TCP[scrInIsNew][0]=0;
	    		strArr_TCP[scrInCard][0]=0;
	    	}
			pthread_mutex_unlock( &mutex_points );

	        usleep(100000);
	        GetExitCard(&tcpMain, IsNew1, &Card, Count, Error);
	        if(IsNew1)
	        {
	        	if(Error != merNone || tcpMain.pCardStorageRef == NULL)
	        	{
	        		continue;   // CardStorageRef should be defined for card checking
	        	}
	        	if(checkCard(&Card, Count, &tcpMain))
	        		tcpMain.SetExitPass();
	        	else
	        		continue;

	        	n1=n3=1;
	        	while(n1>0 || n3>0)
	        	{
	    	        // Get Exit Status : eClosed, eCounted, eFree
	    	        GetExitStatus(&tcpMain, n1, Error, chAnswer1);
	    	        // Get Exit State : eePassFree, eePassStarted
	    	        GetExitState(&tcpMain, n3, Error, chAnswer3);
	    			pthread_mutex_lock( &mutex_points );
	    			strcpy(strArr_TCP[scrOutFreeClosed], chAnswer1);
	    	    	sprintf(strArr_TCP[scrOutCount],"  %u",n1);
	    	    	strcpy(strArr_TCP[scrOutFreeStart], chAnswer3);
	    	    	if(IsNew1)
	    	    	{
	    	    		strcpy(strArr_TCP[scrOutIsNew]," New");
	    	    		strcpy(strArr_TCP[scrOutCard],(char*)(tcpMain.Card2.data));
	    	    	}
	    	    	else
	    	    	{
	    	    		strArr_TCP[scrOutIsNew][0]=0;
	    	    		strArr_TCP[scrOutCard][0]=0;
	    	    	}
	    			pthread_mutex_unlock( &mutex_points );
	    	        if(!n1 && !n3)break;
	    	        usleep(100000);
	        	}
	        }
			pthread_mutex_lock( &mutex_points );
	    	if(IsNew1)
	    	{
	    		strcpy(strArr_TCP[scrOutIsNew]," New");
	    		strcpy(strArr_TCP[scrOutCard],(char*)(tcpMain.Card2.data));
	    	}
	    	else
	    	{
	    		strArr_TCP[scrOutIsNew][0]=0;
	    		strArr_TCP[scrOutCard][0]=0;
	    	}
			pthread_mutex_unlock( &mutex_points );

	        usleep(100000);
	    }

	return 0;
  }

  LongInt loadConfigFile(char * configFileName)
  {
	  int fd;
	  LongInt fileLength, accFileLength;

	  fileBuffer[0] = 0;

	  fd = open(configFileName,O_RDONLY,0666);
	  if(fd<=0) return 0;

	  fileLength = (LongInt)(lseek(fd,0,SEEK_END));
	  if(fileLength<=0 || fileLength > CFGBUFF_MAX_SIZE)
	  {
		  close(fd);
		  return 0;
	  }

	  lseek(fd,0,SEEK_SET);

	  accFileLength = read(fd,fileBuffer,fileLength);
	  close(fd);

	  if(accFileLength != fileLength)
	  {
		  fileBuffer[0] = 0;
		  return 0;
	  }

	    fileBuffer[fileLength] = 0;
	    return fileLength;
  }

  short doSplitConfig(char * fileBuff, LongInt fileBufferLength)
  {
  // Do split configuration file's buffer into the array of lines
  // Returns the final number of lines

  long l;
  short m;

  for(l = 0; l<fileBufferLength; l++)
     {
       if(fileBuff[l] == 0x0A || fileBuff[l] == 0x0D || fileBuff[l] == ';')
       {
          fileBuff[l] = 0;
       }
     }
  m = -1;
  l = 0;
  while(l<fileBufferLength && m < CFGARRAY_MAX_SIZE-1)
     {
	   if(fileBuff[l]!=0)
       {
         m++;
  		 configLinesArray[m] = fileBuff+l;
  		 l += strlen(configLinesArray[m]);
       }
       else
        {
           l++;
        }
     }
  m++;

  if(m<=0)
  {
     // There is no one line in the configuration file buffer
     return 0;
  }
  else if(l<fileBufferLength)
  {
     // There are more than CFGARRAY_MAX_SIZE lines in the configuration file buffer
     return 0;
  }
  else
  {
     // The are valid number of lines in the configuration file
     return m;
     }
  return 0;
  }


  void getConfigInfo()
  {
	LongInt fileLength;
	char configFileName[255];
	strcpy(configFileName,DEFAULT_CONFIG);

	 rtuMain.setAddr(0);
	 tcpMain.setAddr(0);
	 rtuMain.setPort(SERIAL_PORT);
	 tcpMain.setPort(TCP_PORT);

	 rtuMain.setSpeed(CONTROLLERSPEED);
	 rtuMain.ScannerSpeed = SCANNERSPEED;
	 tcpMain.ScannerSpeed = SCANNERSPEED;
	 tcpMain.setHostIP(HOST_IP);

	 rtuMain.pCardStorageRef = &cardStorageRef;
	 tcpMain.pCardStorageRef = &cardStorageRef;
	 cardStorageRef.setCardsCount(0);

	fileLength = loadConfigFile(configFileName);
    if(fileLength <=0 || fileLength > CFGBUFF_MAX_SIZE)
	{
		 // The problem was occurred with the configuration file
		 return;
	}
	else
	{
		TAr tar;
		memset((void *)tar.data,0,TARSIZE);

		cfgArraySize = doSplitConfig(fileBuffer, fileLength);
		if(cfgArraySize <= 0 || cfgArraySize > CFGARRAY_MAX_SIZE) return;
		cardStorageRef.setCardsCount(cfgArraySize);
		for(int i = 0; i < cfgArraySize; i++)
		{
			int lineSize = strlen(configLinesArray[i]); // lineSize should be odd
			if(lineSize > 0 && lineSize <= CARDDATALENGTH*2)
			{
				byte cardLength = lineSize/2;
				byte data;
				unsigned int idata;
				int rc;
				char TTT[3];
				for(int j=0; j<cardLength; j++)
				{
					TTT[0] = configLinesArray[i][j*2];
					TTT[1] = configLinesArray[i][j*2 + 1];
					TTT[2] = 0;
					rc = sscanf(TTT,"%2X",&idata);
					if(rc!=1) idata = 0;
					data = (byte)(0x000000ff & idata);
					tar.data[j] = data;
				}
				cardStorageRef.setCard((unsigned int)i,tar,cardLength);
			}
			else
			{
				cardStorageRef.setCard((unsigned int)i,tar,0);
			}
		}
	}
  }

  int main ()
{

	char strHead[255];
	char strLine[255];
	char str_RTU[255];
	char I_CRD_R[255];
	char O_CRD_R[255];
	char I_CRD_T[255];
	char O_CRD_T[255];
	char str_TCP[255];
	char strTmp[255];

	rtuMain.setChnlType(rtuType); // RTU channel
	tcpMain.setChnlType(tcpType); // TCP channel

	getConfigInfo();

	pthread_create(&rtu_tid, NULL, &rtu_thread, NULL);
	pthread_create(&tcp_tid, NULL, &tcp_thread, NULL);


	strcpy(strHead,"|CHL|Connected|InFreeClosed|OutFreeClosed|InCount|OutCount|InFreeStart|OutFreeStart  |");
	strcpy(str_RTU,"|RTU|         |            |             |       |        |           |              |");
	strcpy(I_CRD_R,"|InCard |     |                                                                      |");
	strcpy(O_CRD_R,"|OutCard|     |                                                                      |");
	strcpy(str_TCP,"|TCP|         |            |             |       |        |           |              |");
	strcpy(I_CRD_T,"|InCard |     |                                                                      |");
	strcpy(O_CRD_T,"|OutCard|     |                                                                      |");
	strcpy(strLine,"--------------------------------------------------------------------------------------");
	strcpy(strTmp,"");
	system("clear");

	for(int i=0;i<=scrOutCard;i++)
	{
		strArr_RTU[i][0] = strArr_TCP[i][0] = 0;
	}


    while(1)
    {
    	// RTU and TCP channels' monitoring

    	printf("%s","\033[0;0H");
    	printf("%s\n",strHead);
    	printf("%s\n",strLine);
		pthread_mutex_lock( &mutex_points );
		sprintf(str_RTU,
		"|RTU|   %-3s   |   %-9s|   %-10s|%-7s|%-8s|  %-9s|  %-12s|",
				strArr_RTU[scrConnected],
				strArr_RTU[scrInFreeClosed],
				strArr_RTU[scrOutFreeClosed],
				strArr_RTU[scrInCount],
				strArr_RTU[scrOutCount],
				strArr_RTU[scrInFreeStart],
				strArr_RTU[scrOutFreeStart]
				);
		sprintf(I_CRD_R,
		"|InCard |%-5s|%-70s|",
			strArr_RTU[scrInIsNew],strArr_RTU[scrInCard]
				);
		sprintf(O_CRD_R,
		"|OutCard|%-5s|%-70s|",
			strArr_RTU[scrOutIsNew],strArr_RTU[scrOutCard]
				);
		pthread_mutex_unlock( &mutex_points );
    	printf("%s\n",str_RTU);
    	printf("%s\n",strLine);
    	printf("%s\n",I_CRD_R);
    	printf("%s\n",strLine);
    	printf("%s\n",O_CRD_R);
    	printf("%s\n",strLine);
    	printf("%s\n",strLine);
		pthread_mutex_lock( &mutex_points );
		sprintf(str_TCP,
		"|TCP|   %-3s   |   %-9s|   %-10s|%-7s|%-8s|  %-9s|  %-12s|",
				strArr_TCP[scrConnected],
				strArr_TCP[scrInFreeClosed],
				strArr_TCP[scrOutFreeClosed],
				strArr_TCP[scrInCount],
				strArr_TCP[scrOutCount],
				strArr_TCP[scrInFreeStart],
				strArr_TCP[scrOutFreeStart]
				);
		sprintf(I_CRD_T,
		"|InCard |%-5s|%-70s|",
			strArr_TCP[scrInIsNew],strArr_TCP[scrInCard]
				);
		sprintf(O_CRD_T,
		"|OutCard|%-5s|%-70s|",
			strArr_TCP[scrOutIsNew],strArr_TCP[scrOutCard]
				);
		pthread_mutex_unlock( &mutex_points );
    	printf("%s\n",str_TCP);
    	printf("%s\n",strLine);
    	printf("%s\n",I_CRD_T);
    	printf("%s\n",strLine);
    	printf("%s\n",O_CRD_T);
    	printf("%s\n",strLine);
    	printf("%s\n",strLine);
        usleep(100000);
    }
    return 0;

}


bool TfmMain :: StartRTU()
{
    TModbusError Error;
    if(FController != NULL)
    {
       FController->Close();
       FController = NULL;
    }

  	FController = new TController();
  	if(FController == NULL)
  	{
  		// Can't create TController
  		return 0;
  	}
  	ModbusError = Error = merNone;
  	if(!FController->Open(Port,Speed,Addr))	ModbusError = Error =  merCantOpenPort;
  	if(Error != merNone)
  	{
  		delete FController;
  		FController = NULL;
  		// Can't open FController
  		return 0;
  	}
    return 1;
}

byte TfmMain :: StartFirstRTU()
{

    bool rc;
    byte addr;
    if(FController != NULL)
    {
       FController->Close();
       FController = NULL;
    }

  	FController = new TController();
  	if(FController == NULL)
  	{
  		// Can't create TController
  		return 0;
  	}
  	rc = FController->Open(Port,Speed);
  	if(!rc)
  	{
  		delete FController;
  		FController = NULL;
  		// Can't open FController
  		return 0;
  	}
  	if(!(this->getAddr())) addr=FController->FindFirst();
  	else addr=FController->FindNext(this->getAddr() - 1);
  	if(!addr)
  	{
  		// Nobody answered
  		Addr = 0;
  		return 255; // Channel is ready, but nobody answered
  	}
    Addr = addr;
    return addr;
}


bool TfmMain :: StartTCP()
{
    TModbusError Error;
    if(FController != NULL)
    {
       FController->Close();
       FController = NULL;
    }

  	FController = new TController();
  	if(FController == NULL)
  	{
  		// Can't create TController
  		return 0;
  	}
  	Error = merNone;
  	if(!(FController->Open(HostIP,Port,Addr)))	ModbusError = Error = merCantOpenPort;
  	if(Error != merNone)
  	{
  		delete FController;
  		FController = NULL;
  		// Can't open FController
  		ModbusError = Error;
  		return 0;
  	}
    return 1;
}

byte TfmMain :: StartFirstTCP()
{
    bool rc;
    byte addr;

    if(FController != NULL)
    {
       FController->Close();
       FController = NULL;
    }

  	FController = new TController();
  	if(FController == NULL)
  	{
  		// Can't create TController
  		return 0;
  	}
  	FController->SetBlockMode(1);  //For unblocked mode: FController->SetBlockMode(0);
  	rc = FController->Open(HostIP,Port);
  	if(!rc)
  	{
  		delete FController;
  		FController = NULL;
  		// Can't open FController
  		return 0;
  	}
  	if(!(this->getAddr())) 	addr=FController->FindFirst();
  	else addr=FController->FindNext(this->getAddr() - 1);
  	ModbusError = FController->getFModbus()->ModbusError;
  	if(!addr ||
  		(ModbusError != merNone &&
  		 ModbusError != merMBDataAddress &&
  		 ModbusError != merMBDataValue ))
  	{
  		// Nobody answered
  		Addr = 0;
  		if(ModbusError == merTimeout)
  			return 255; // Channel is ready, but nobody answered
  		else
  		{
  	  		delete FController;
  	  		FController = NULL;
  	  		// Can't open FController
  	  		return 0;
  		}
  	}
    Addr = addr;
    return addr;
}

void TfmMain :: SetAfterPermissionPassTime()
{
    if(FController== NULL)
    {
        ModbusError = merCantOpenPort;
        return;
    }
    ModbusError = FController->SetAfterPermissionPassTime(Addr,AfterPermissionPassTime);
}


void TfmMain :: SetAfterStartPassTime()
{
    if(FController== NULL)
    {
        ModbusError = merCantOpenPort;
        return;
    }
    ModbusError = FController->SetAfterStartPassTime(Addr,AfterStartPassTime);
}


void TfmMain :: SetEngineTime()
{
    if(FController== NULL)
    {
        ModbusError = merCantOpenPort;
        return;
    }
    ModbusError = FController->SetEngineTime(Addr,EngineTime);
}

void TfmMain :: SetEnterGreen()
{
    if(FController== NULL)
    {
        ModbusError = merCantOpenPort;
        return;
    }
    ModbusError = FController->SetEnterGreen(Addr,EnterGreen_OnTime,EnterGreen_OffTime,EnterGreen_LengthTime);
}


void TfmMain :: SetEnterPass()
{
    if(FController== NULL)
    {
        ModbusError = merCantOpenPort;
        return;
    }
    ModbusError = FController->SetEnter(Addr,1);
}


void TfmMain :: SetEnterRed()
{
    if(FController== NULL)
    {
        ModbusError = merCantOpenPort;
        return;
    }
    ModbusError = FController->SetEnterRed(Addr,EnterRed_OnTime,EnterRed_OffTime,EnterRed_LengthTime);
}


void TfmMain :: SetExitGreen()
{
    if(FController== NULL)
    {
        ModbusError = merCantOpenPort;
        return;
    }
    ModbusError = FController->SetExitGreen(Addr,ExitGreen_OnTime,ExitGreen_OffTime,ExitGreen_LengthTime);
}


void TfmMain :: SetExitPass()
{
    if(FController== NULL)
    {
        ModbusError = merCantOpenPort;
        return;
    }
    ModbusError = FController->SetExit(Addr,1);
}


void TfmMain :: SetExitRed()
{
    if(FController== NULL)
    {
        ModbusError = merCantOpenPort;
        return;
    }
    ModbusError = FController->SetExitRed(Addr,ExitRed_OnTime,ExitRed_OffTime,ExitRed_LengthTime);
}

void TfmMain :: SetScannerSpeed(Word scanSpeed)
{
	ScannerSpeed = scanSpeed;
	this->SetScannerSpeed();
}

void TfmMain :: SetScannerSpeed()
{
    if(FController== NULL)
    {
        ModbusError = merCantOpenPort;
        return;
    }
    FController->SetTimeOut(SCANNER_TIMEOUT);
    ModbusError = FController->SetScannerSpeed(Addr,ScannerSpeed);
    FController->SetTimeOut(DEFAULT_TIMEOUT);
}


void TfmMain :: SetControllerSpeed()
{
    if(FController == NULL)
    {
        ModbusError = merCantOpenPort;
        return;
    }
    ModbusError = FController->SetControllerSpeed(Addr,(LongWord)Speed);
}


void TfmMain :: SetDemo()
{
    byte State;     
    
	if(cbDemo)
	{
		State = 1;
	}
	else
	{
		State = 0;
	}
    
    if(FController != NULL)
    {
    	ModbusError = FController->SetDemo(Addr, State);
    }
    else
    {
        ModbusError = merCantOpenPort;
    }
}


void TfmMain :: SetEnter()
{
    Word n;

    if(FController == NULL)
    {
        ModbusError = merCantOpenPort;
        return;
    }
    if(rgEnter == eeClosed)
    {
    	ModbusError = FController->SetEnter(Addr,0);
    }
    else
    {
    	ModbusError = FController->SetEnter(Addr,0xffff);
    }
    ModbusError = FController->GetEnterState(Addr,n);
    if(!n) rgEnterState = eClosed;
    else rgEnterState = eFree;
}


void TfmMain :: SetExit()
{
    Word n;

    if(FController == NULL)
    {
        ModbusError = merCantOpenPort;
        return;
    }
    if(rgExit == eeClosed)
    {
    	ModbusError = FController->SetExit(Addr,0);
    }
    else
    {
    	ModbusError = FController->SetExit(Addr,0xffff);
    }
    if(ModbusError != merNone)
    {
    	return;
    }
    ModbusError = FController->GetExit(Addr,n);
    if(!n)
    {
        rgExitState = eClosed;
    }
    else
    {
        rgExitState = eFree;
    }
}


void TfmMain :: SetPassState()
{
    byte PassStat;
    if(FController == NULL)
    {
        ModbusError = merCantOpenPort;
        return;
    }
    if(rgPassState == passNormal) PassStat = 0;
    else if(rgPassState == passBlocked) PassStat = 1;
    else if(rgPassState == passAntiPanic) PassStat = 2;
    else PassStat = 0;  // default value
    ModbusError = FController->SetPassState(Addr,PassStat);
}

TfmMain :: TfmMain()
{
    FController = new TController();
    ModbusError = merNone;
    EnterCount = 0;
    ExitCount = 0;

    EngineBlockState = 0;
    Addr = 1;
    Port = 1;
    Speed = 115200;
    ScannerSpeed = 9600;

    AfterPermissionPassTime = 1;
    AfterStartPassTime = 1;
    EngineTime = 1;

    rgEnter = eeClosed;  // eeClosed, eeFree
    rgEnterState = eClosed;  // eClosed, eCounted, eFree
    rgEnterPassState = eePassFree;  // eePassFree, eePassStarted

    rgExit = eeClosed;  // eeClosed, eeFree
    rgExitState = eClosed;  // eClosed, eCounted, eFree
    rgExitPassState = eePassFree;  // eePassFree, eePassStarted

    rgPassState = passNormal;  // passNormal, passBlocked, passAntiPanic

    EnterGreen_OnTime = 1;
    EnterGreen_OffTime = 1;
    EnterGreen_LengthTime = 1;
    EnterRed_OnTime = 1;
    EnterRed_OffTime = 1;
    EnterRed_LengthTime = 1;
    ExitGreen_OnTime = 1;
    ExitGreen_OffTime = 1;
    ExitGreen_LengthTime = 1;
    ExitRed_OnTime = 1;
    ExitRed_OffTime = 1;
    ExitRed_LengthTime = 1;

    memset((void *)(Card.data),0,TARSIZE);
    memset((void *)(Card2.data),0,TARSIZE);
    memset((void *)(CardASCII.data),0,TARSIZE);
    memset((void *)(Card2ASCII.data),0,TARSIZE);

    strcpy(Company,"");
    strcpy(Product,"");
    strcpy(Version,"");
    strcpy(VendorURL,"");
    strcpy(Caption,"Modbus demo off");

    cbDemo = 0;
    pCardStorageRef = NULL;
    ChnlType = rtuType;  // RTU type is default
}

void TfmMain :: setPort(int port)
{
	Port = port;
}

void TfmMain :: setAddr(byte addr)
{
	Addr = addr;
}

void TfmMain :: setSpeed(int speed)
{
	Speed = speed;
}

void TfmMain :: setHostIP(const char * hostIP)
{
	strcpy(HostIP,hostIP);
}

void GetEnterStatus(TfmMain * fmMain, Word & n, TModbusError & Error, char * chAnswer)
{
		strcpy(chAnswer,"");
        Error = fmMain->getController()->GetEnter(fmMain->getAddr(),n);
        if(Error != merNone)
        {
            return;
        }
        switch(n)
        {
            case 0:
                fmMain->rgEnterState = eClosed;
                strcpy(chAnswer,"Closed");
                break;
            case 1:
                fmMain->rgEnterState = eCounted;
                strcpy(chAnswer,"Counted");
                break;
            case 2:
                fmMain->rgEnterState = eFree;
                strcpy(chAnswer,"Free");
                break;
            default:
                fmMain->rgEnterState = eClosed;
                strcpy(chAnswer,"Closed");
                break;
        }
}

void GetExitStatus(TfmMain * fmMain, Word & n, TModbusError & Error, char * chAnswer)
{
    Error = fmMain->getController()->GetExit(fmMain->getAddr(),n);
    if(Error != merNone)
    {
        return;
    }
    switch(n)
    {
        case 0:
            fmMain->rgExitState = eClosed;
            strcpy(chAnswer,"Closed");
            break;
        case 1:
            fmMain->rgExitState = eCounted;
            strcpy(chAnswer,"Counted");
            break;
        case 2:
            fmMain->rgExitState = eFree;
            strcpy(chAnswer,"Free");
            break;
        default:
            fmMain->rgExitState = eClosed;
            strcpy(chAnswer,"Closed");
            break;
    }
}

void GetEnterState(TfmMain * fmMain, Word & n, TModbusError & Error, char * chAnswer)
{
    Error = fmMain->getController()->GetEnterState(fmMain->getAddr(),n);
    if(Error != merNone)
    {
        return;
    }
    // eePassFree, eePassStarted
    switch(n)
    {
        case 0:
            fmMain->rgEnterPassState = eePassFree;
            strcpy(chAnswer,"Free");
            break;
        case 1:
            fmMain->rgEnterPassState = eePassStarted;
            strcpy(chAnswer,"Started");
            break;
        default:
            fmMain->rgEnterPassState = eePassFree;
            strcpy(chAnswer,"Free");
            break;
    }
}

void GetExitState(TfmMain * fmMain, Word & n, TModbusError & Error, char * chAnswer)
{
    Error = fmMain->getController()->GetExitState(fmMain->getAddr(),n);
    if(Error != merNone)
    {
        return;
    }
    // eePassFree, eePassStarted
    switch(n)
    {
        case 0:
            fmMain->rgExitPassState = eePassFree;
            strcpy(chAnswer,"Free");
            break;
        case 1:
            fmMain->rgExitPassState = eePassStarted;
            strcpy(chAnswer,"Started");
            break;
        default:
            fmMain->rgExitPassState = eePassFree;
            strcpy(chAnswer,"Free");
            break;
    }
}

void GetEnterCount(TfmMain * fmMain, LongWord & ln, TModbusError & Error)
{
    Error = fmMain->getController()->GetEnterCount(fmMain->getAddr(),ln);
    if(Error != merNone)
    {
        return;
    }
    fmMain->EnterCount = ln;
}


void GetExitCount(TfmMain * fmMain, LongWord & ln, TModbusError & Error)
{
    Error = fmMain->getController()->GetExitCount(fmMain->getAddr(),ln);
    if(Error != merNone)
    {
        return;
    }
    fmMain->EnterCount = ln;
}

void GetErrorState(TfmMain * fmMain, Word & n, TModbusError & Error)
{
	fmMain->ModbusError = Error = fmMain->getController()->GetErrorState(fmMain->getAddr(),n);
    if(Error != merNone)
    {
        return;
    }
    fmMain->EngineBlockState = (n!=0);
}


void GetEnterCard(TfmMain * fmMain, bool & IsNew, TAr * pCard, Word & Count, TModbusError & Error)
{
    int i,j,l;
    char Hex[3];
    Error = fmMain->getController()->GetEnterCard(fmMain->getAddr(), IsNew, pCard, Count);
    if(Error != merNone)
    {
        return;
    }
    if(IsNew)
    {
        memset((void *)(fmMain->Card.data),0,TARSIZE);
        memset((void *)(fmMain->CardASCII.data),0,TARSIZE);
        j = l = 0;
        for(i=0; i<Count; i++)
        {
            fmMain->CardASCII.data[j] = pCard->data[i];
            fmMain->CardASCII.data[j+1] = ' ';
            j += 2;
            IntToHex(pCard->data[i],Hex);
            fmMain->Card.data[l] = '$';
            fmMain->Card.data[l+1] = Hex[0];
            fmMain->Card.data[l+2] = Hex[1];
            fmMain->Card.data[l+3] = ' ';
            l += 4;
        }
        fmMain->CardASCII.data[j] = 0;
        fmMain->Card.data[l] = 0;
        Trim((char *)(fmMain->Card.data));
    }
}

void GetExitCard(TfmMain * fmMain, bool & IsNew, TAr * pCard, Word & Count, TModbusError & Error)
{
    int i,j,l;
    char Hex[3];
    Error = fmMain->getController()->GetExitCard(fmMain->getAddr(), IsNew, pCard, Count);
    if(Error != merNone)
    {
        return;
    }
    if(IsNew)
    {
        memset((void *)(fmMain->Card2.data),0,TARSIZE);
        memset((void *)(fmMain->Card2ASCII.data),0,TARSIZE);
        j = l = 0;
        for(i=0; i<Count; i++)
        {
            fmMain->Card2ASCII.data[j] = pCard->data[i];
            fmMain->Card2ASCII.data[j+1] = ' ';
            j += 2;
            IntToHex(pCard->data[i],Hex);
            fmMain->Card2.data[l] = '$';
            fmMain->Card2.data[l+1] = Hex[0];
            fmMain->Card2.data[l+2] = Hex[1];
            fmMain->Card2.data[l+3] = ' ';
            l += 4;
        }
        fmMain->Card2ASCII.data[j] = 0;
        fmMain->Card2.data[l] = 0;
        Trim((char *)(fmMain->Card2.data));
    }
}


void GetDemo(TfmMain * fmMain, Word & n, TModbusError & Error)
{
    Error = fmMain->getController()->GetDemo(fmMain->getAddr(),n);
    if(Error != merNone)
    {
        return;
    }
    switch(n)
    {
        case 1:  fmMain->cbDemo = 1;
                 strcpy(fmMain->Caption,"Modbus demo on");
                 break;
        case 0:
        default: fmMain->cbDemo = 0;
                 strcpy(fmMain->Caption,"Modbus demo off");
                 break;
    }
}



// Service

void IntToHex(byte input, char * output)
{
    sprintf(output,"%02X",input);
}

void LeftTrim(char * input)
{
    int length = strlen(input);
    int i,j,l;

    if(length<=0) return;

    for(i=0;i<length;i++)
    {
        if(input[i] > ' ') break;
    }
    for(l=i,j=0;l<length;l++,j++)
    {
        input[j] = input[l];
    }
    input[j] = 0;
}
void RightTrim(char * input)
{
    int length = strlen(input);
    int i;

    if(length<=0) return;

    for(i=length-1; i>=0; i--)
    {
        if(input[i] > ' ') break;
    }
    input[i+1] = 0;
}
void Trim(char * input)
{
    if(strlen(input)<=0) return;
    LeftTrim(input);
    RightTrim(input);
}

void sleepMsecsD(double msecs)
{
// The millisecond-wised pause
int i;
struct timespec start, stop;
double accum;

if (msecs <=0) return;

clock_gettime( CLOCK_REALTIME, &start);

for(i=0;i<(int)msecs*10;i++)
    {
     usleep(100);
     clock_gettime( CLOCK_REALTIME, &stop);
     accum = ( stop.tv_sec - start.tv_sec )
             + (double)( stop.tv_nsec - start.tv_nsec )
               / (double)BILLION;
     if(accum*1000 >= msecs) return;
    }
}

void sleepMsecsW(Word msecs)
{
    // The millisecond-wised pause
    // msecs should be less than 1000
    usleep(msecs * 1000);
}
