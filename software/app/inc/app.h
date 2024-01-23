#ifndef APP_H
#define APP_H

#define AUDIO_CODEC_ADDR 0b0011010

#define ANALOG_AUDIO_PATH_CONTROL_ADDR 0b0000100
#define LEFT_LINE_IN_ADDR 0b0000000
#define RIGHT_LINE_IN_ADDR 0b0000001
#define DIGITAL_AUDIO_PATH_CONTROL_ADDR 0b0000101
#define DIGITAL_AUDIO_INTERFACE_FORMAT_ADDR 0b0000111
#define SAMPLING_CONTROL_ADDR 0b0001000
#define POWER_DOWN_CONTROL_ADDR 0b0000110
#define ACTIVE_CONTROL_ADDR 0b0001001

#include <stdint.h>
#include <stdlib.h>

uint8_t* bufferToSend(uint8_t controlAddrBits, uint16_t controlDataBits)	{
	static uint8_t dataBytes[2];
	dataBytes[0] = (controlAddrBits << 1) | ((controlDataBits & (1<<8)) >> 8);
	dataBytes[1] = 0xFF & controlDataBits;

	return dataBytes;
}

#endif // APP_H
