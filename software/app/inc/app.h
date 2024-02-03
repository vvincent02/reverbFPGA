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

// increment values
#define MIX_INCR_VALUE 4e-6
#define DECAY_INCR_VALUE 4e-6
#define DAMPING_INCR_VALUE 1e-6

#define MIX_MAX 1.
#define MIX_MIN 1e-9
#define DECAY_MAX 0.95
#define DECAY_MIN 0.25
#define DAMPING_MAX 1.
#define DAMPING_MIN 1e-9

#define GET_DB_FROM_GAIN(gain) 20*log(gain)
#define GET_GAIN_FROM_DB(gain_dB) pow(10, (gain_dB)/20.0)

typedef enum	{
	MIX=0,
	PREDELAY,
	DECAY,
	DAMPING,
	NONE_PARAM
} PARAM_TYPE;

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
