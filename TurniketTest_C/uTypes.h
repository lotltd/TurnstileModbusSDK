#ifndef UTIPES_H
#define UTIPES_H

#include <unistd.h>
#include <sys/types.h>
#include <pthread.h>
#include <stddef.h>

#define RECOMMENDED 5   // The milliseconds pause between modbus requests which was recommended

#define BILLION  1000000000L


#if defined(QNX_X86) || defined(CORE9G25)
typedef unsigned char byte;
#endif 

#define BYTESARRAY_MAXLENGTH 256
#define WORDSARRAY_MAXLENGTH 128
#define TARSIZE 80

// Delphi like types
typedef bool boolean;
#if defined(QNX_X86) || defined(CORE9G25)
typedef unsigned short Word;
typedef unsigned int LongWord;
typedef unsigned int cardinal;
typedef int LongInt;
#else
typedef uint16_t Word;
typedef uint32_t LongWord;
typedef uint32_t cardinal;
typedef int32_t LongInt;
#endif

typedef enum TRoundingMode_t
{
    rmNearest,
    rmDown,
    rmUp,
    rmTruncate
}TRoundingMode;


// Application structures

typedef struct bytesArray_t
{
    Word length;
    byte data[BYTESARRAY_MAXLENGTH + 10];
} bytesArray;


typedef struct wordsArray_t
{
    Word length;
    Word data[WORDSARRAY_MAXLENGTH];
} wordsArray;

typedef struct TAr_t
{
    byte data[TARSIZE];
}TAr;

typedef union bytes2word_t
{
   byte b[2];
   Word d;
} bytes2word;

// Application enumerations

typedef enum EnterExit_t
{
    eeClosed, eeFree
}EnterExit;

typedef enum PassStates_t
{
    passNormal, passBlocked, passAntiPanic
}PassStates;

typedef enum EnExStates_t
{
    eClosed, eCounted, eFree
}EnExStates;

typedef enum EnExPassStates_t
{
    eePassFree, eePassStarted
}EnExPassStates;

// Service
void sleepMsecsD(double msecs);
void sleepMsecsW(Word msecs);

#endif // UTIPES_H
