#ifndef APP_H
#define APP_H

#include <stdint.h>
#include <stdlib.h>
#include <math.h>

#define AUDIO_CODEC_ADDR 0b0011010

#define ANALOG_AUDIO_PATH_CONTROL_ADDR 0b0000100
#define LEFT_LINE_IN_ADDR 0b0000000
#define RIGHT_LINE_IN_ADDR 0b0000001
#define DIGITAL_AUDIO_PATH_CONTROL_ADDR 0b0000101
#define DIGITAL_AUDIO_INTERFACE_FORMAT_ADDR 0b0000111
#define SAMPLING_CONTROL_ADDR 0b0001000
#define POWER_DOWN_CONTROL_ADDR 0b0000110
#define ACTIVE_CONTROL_ADDR 0b0001001

#define CLAMP(val, a, b) fmax(a, fmin(val, b))

#define NBR_PARAM 5 // number of parameters + 1 (parameter NONE_PARAM)

#define GET_DB_FROM_GAIN(gain) 20*log(gain)
#define GET_GAIN_FROM_DB(gain_dB) pow(10, (gain_dB)/20.0)

typedef enum	{
	MIX=0,
	PREDELAY,
	DECAY,
	DAMPING,
	NONE_PARAM
} PARAM_TYPE;

const float paramValueIncr[NBR_PARAM] = {3e-6, 3e-6, 3e-6, 3e-6, 0};
const float paramValueMIN[NBR_PARAM] = {1e-9, 0, 0.25, 1e-9, 0};
const float paramValueMAX[NBR_PARAM] = {1, 0, 0.95, 1, 0};
const char stringToDisplay[NBR_PARAM][4] = {"MI", "PR", "DE", "DA", ""};

typedef enum	{
	DECR=-1,
	INCR=1,
	NONE=0
} UPDATE_TYPE;

void initAudioCODEC_I2C();

uint8_t* bufferToSend(uint8_t controlAddrBits, uint16_t controlDataBits)	{
	static uint8_t dataBytes[2];
	dataBytes[0] = (controlAddrBits << 1) | ((controlDataBits & (1<<8)) >> 8);
	dataBytes[1] = 0xFF & controlDataBits;

	return dataBytes;
}

void initParamValue(); // reverb settings initialization
void updateParamValue(PARAM_TYPE paramType, UPDATE_TYPE updateType);




#endif // APP_H
