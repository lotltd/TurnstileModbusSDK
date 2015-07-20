#ifndef UCRC16_H
#define UCRC16_H

#include "uTypes.h"

typedef bytes2word md_crc;

// One step function to calculate the CRC16 for modbus RTU
void modbus_calc_crc(md_crc * modbus_serial_crcs, byte data);
// Cycle of crc16 calculation
md_crc modbus_crc16(md_crc * modbus_serial_crcs, bytesArray * sendbuffer);

#endif // UCRC16_H
