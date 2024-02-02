#include "app.h"
#include "reverbFPGA_Qsys.h"

#include "hps.h"
#include "alt_printf.h"
#include "alt_generalpurpose_io.h"
#include "alt_i2c.h"
#include "socal.h"

void CHECK_ERROR(ALT_STATUS_CODE retVal)	{
	// turn on USER LED on error
	if(retVal != ALT_E_SUCCESS)	{
		alt_gpio_port_datadir_set(ALT_GPIO_PORTB, 1<<24, 1<<24);
		alt_gpio_port_data_write(ALT_GPIO_PORTB, 1<<24, 1<<24);
	}
}

int main(void) {
	/* --- Set HPS_I2C_CONTROL to 1 for audio CODEC access from HPS --- */
	alt_gpio_init();
	CHECK_ERROR(alt_gpio_port_datadir_set(ALT_GPIO_PORTB, 1<<19, 1<<19));
	CHECK_ERROR(alt_gpio_port_data_write(ALT_GPIO_PORTB, 1<<19, 1<<19));
	/* --- */

	initAudioCODEC_I2C();

	uint8_t paramType_PIO_value;
	uint8_t paramValueUpdate_PIO_value;
	PARAM_TYPE paramType = NONE_PARAM;
	UPDATE_TYPE updateType = NONE;
	while(1)	{
		// get parameter type
		paramType_PIO_value = alt_read_byte(ALT_LWFPGASLVS_ADDR + HPS_0_PARAMTYPE_PIO_BASE);
		switch(paramType_PIO_value)	{
		case 0b0001 :
			paramType = DAMPING;
			break;
		case 0b0010 :
			paramType = DECAY;
			break;
		case 0b0100 :
			paramType = PREDELAY;
			break;
		case 0b1000 :
			paramType = MIX;
			break;
		default :
			paramType = NONE_PARAM;
		}

		// get value to modify or not the current parameter
		paramValueUpdate_PIO_value = alt_read_byte(ALT_LWFPGASLVS_ADDR + HPS_0_PARAMVALUEUPDATE_PIO_BASE);
		switch(paramValueUpdate_PIO_value)	{
		case 0b10 :
			updateType = INCR;
			break;
		case 0b01 :
			updateType = DECR;
			break;
		default :
			updateType = NONE;
			break;
		}

		updateParamValue(paramType, updateType);
	}
	return EXIT_SUCCESS;
}

void initAudioCODEC_I2C()	{
	/* --- Set audio CODEC registers through I2C communication --- */
	ALT_I2C_DEV_t I2C_Device;

	CHECK_ERROR(alt_i2c_init(ALT_I2C_I2C0, &I2C_Device));
	CHECK_ERROR(alt_i2c_enable(&I2C_Device));

	CHECK_ERROR(alt_i2c_master_target_set(&I2C_Device, AUDIO_CODEC_ADDR));

	// power up required modules except line output
	CHECK_ERROR(alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(POWER_DOWN_CONTROL_ADDR, 0b01110010),
										 2,
										 0,
										 1));

	// Reset ACTIVE_CONTROL register
	CHECK_ERROR(alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(ACTIVE_CONTROL_ADDR, 0b0),
										 2,
										 0,
										 1));

	/* --- set required values in registers except ACTIVE_CONTROL register --- */
	CHECK_ERROR(alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(ANALOG_AUDIO_PATH_CONTROL_ADDR, 0b00010010),
										 2,
										 0,
										 1));
	CHECK_ERROR(alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(LEFT_LINE_IN_ADDR, 0b000010111),
										 2,
										 0,
										 1));
	CHECK_ERROR(alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(RIGHT_LINE_IN_ADDR, 0b000010111),
										 2,
										 0,
										 1));
	CHECK_ERROR(alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(DIGITAL_AUDIO_INTERFACE_FORMAT_ADDR, 0b01001001),
										 2,
										 0,
										 1));
	CHECK_ERROR(alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(DIGITAL_AUDIO_PATH_CONTROL_ADDR, 0b00001),
										 2,
										 0,
										 1));
	CHECK_ERROR(alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(SAMPLING_CONTROL_ADDR, 0b00000010),
										 2,
										 0,
										 1));
	/* ----------------------------------------------------------------------------------- */

	// Set ACTIVE_CONTROL register
	CHECK_ERROR(alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(ACTIVE_CONTROL_ADDR, 0b1),
										 2,
										 0,
										 1));

	// Power up line output
	CHECK_ERROR(alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(POWER_DOWN_CONTROL_ADDR, 0b01100010),
										 2,
										 0,
										 1));
	/* ------------------------------------------------------------------------------------ */
}

void updateParamValue(PARAM_TYPE paramType, UPDATE_TYPE updateType)	{
	uint32_t readVal;
	uint32_t maxVal;

// macro to update the selected parameter according to updateType value
#define UPDATE_PARAM_VALUE(pioName) maxVal = (1<<HPS_0_##pioName##_PIO_DATA_WIDTH) - 1; \
									alt_write_word(ALT_LWFPGASLVS_ADDR + HPS_0_##pioName##_PIO_BASE, \
										CLAMP(alt_read_word(ALT_LWFPGASLVS_ADDR + HPS_0_##pioName##_PIO_BASE) + updateType*INCR_VALUE*maxVal, 0, maxVal))

	switch(paramType)	{
	case MIX :
		maxVal = (1<<HPS_0_MIXVALUE_PIO_DATA_WIDTH) - 1;
		readVal = alt_read_word(ALT_LWFPGASLVS_ADDR + HPS_0_MIXVALUE_PIO_BASE);
		alt_write_word(ALT_LWFPGASLVS_ADDR + HPS_0_MIXVALUE_PIO_BASE, CLAMP(GET_GAIN_FROM_DB(updateType*INCR_VALUE_DB)*readVal, 0, maxVal));


		//UPDATE_PARAM_VALUE(MIXVALUE);

		break;
	case PREDELAY :

		break;
	case DECAY :
		maxVal = (1<<HPS_0_DECAYVALUE_PIO_DATA_WIDTH) - 1;
		readVal = alt_read_word(ALT_LWFPGASLVS_ADDR + HPS_0_DECAYVALUE_PIO_BASE);
		alt_write_word(ALT_LWFPGASLVS_ADDR + HPS_0_DECAYVALUE_PIO_BASE, CLAMP(GET_GAIN_FROM_DB(updateType*INCR_VALUE_DB)*readVal, 0, maxVal));

		//UPDATE_PARAM_VALUE(DECAYVALUE);
		break;
	case DAMPING :
		maxVal = (1<<HPS_0_DAMPINGVALUE_PIO_DATA_WIDTH) - 1;
		readVal = alt_read_word(ALT_LWFPGASLVS_ADDR + HPS_0_DAMPINGVALUE_PIO_BASE);
		alt_write_word(ALT_LWFPGASLVS_ADDR + HPS_0_DAMPINGVALUE_PIO_BASE, CLAMP(GET_GAIN_FROM_DB(updateType*INCR_VALUE_DB)*readVal, 0, maxVal));

		//UPDATE_PARAM_VALUE(DAMPINGVALUE);
		break;
	default :
		break;
	}

	/* --- display current parameter value in dB on 7seg --- */
	uint8_t mag_dB = GET_GAIN_DB((float)maxVal/readVal);
	uint8_t ten = mag_dB/10;
	uint8_t unit = (mag_dB - ten)/10;
	alt_write_byte(ALT_LWFPGASLVS_ADDR + HPS_0_SEG3_BASE, 0b1111);
	alt_write_byte(ALT_LWFPGASLVS_ADDR + HPS_0_SEG2_BASE, 0b1010);
	alt_write_byte(ALT_LWFPGASLVS_ADDR + HPS_0_SEG1_BASE, ten);
	alt_write_byte(ALT_LWFPGASLVS_ADDR + HPS_0_SEG0_BASE, unit);
	/* ----------------------------------------------------- */
}
