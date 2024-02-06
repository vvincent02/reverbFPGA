#include "app.h"
#include "reverbFPGA_Qsys.h"

#include "hps.h"
#include "alt_printf.h"
#include "alt_generalpurpose_io.h"
#include "alt_i2c.h"
#include "socal.h"

float currentParamValue[NBR_PARAM] = {paramValueMIN[MIX], paramValueMIN[PREDELAY], paramValueMIN[DECAY], paramValueMIN[DAMPING], 0};

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

		initParamValue();
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
										 bufferToSend(LEFT_LINE_IN_ADDR, 0b000010011),
										 2,
										 0,
										 1));
	CHECK_ERROR(alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(RIGHT_LINE_IN_ADDR, 0b000010011),
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


void initParamValue()	{
	alt_write_word(ALT_LWFPGASLVS_ADDR + HPS_0_MIXVALUE_PIO_BASE, currentParamValue[MIX]*(float)((1<<HPS_0_MIXVALUE_PIO_DATA_WIDTH) - 1));
	alt_write_word(ALT_LWFPGASLVS_ADDR + HPS_0_DECAYVALUE_PIO_BASE, currentParamValue[DECAY]*(float)((1<<HPS_0_DECAYVALUE_PIO_DATA_WIDTH) - 1));
	alt_write_word(ALT_LWFPGASLVS_ADDR + HPS_0_DAMPINGVALUE_PIO_BASE, currentParamValue[DAMPING]*(float)((1<<HPS_0_DAMPINGVALUE_PIO_DATA_WIDTH) - 1));
}

void updateParamValue(PARAM_TYPE paramType, UPDATE_TYPE updateType)	{
	uint32_t maxVal;

	// parameter value update
	currentParamValue[paramType] += updateType*paramValueIncr[paramType];
	currentParamValue[paramType] = CLAMP(currentParamValue[paramType], paramValueMIN[paramType], paramValueMAX[paramType]);

	switch(paramType)	{
	case MIX :
		maxVal = (1<<HPS_0_MIXVALUE_PIO_DATA_WIDTH) - 1;
		alt_write_word(ALT_LWFPGASLVS_ADDR + HPS_0_MIXVALUE_PIO_BASE, currentParamValue[MIX]*maxVal);
		break;
	case PREDELAY :
		maxVal = (1<<HPS_0_PREDELAYVALUE_PIO_DATA_WIDTH) - 1;
		alt_write_word(ALT_LWFPGASLVS_ADDR + HPS_0_PREDELAYVALUE_PIO_BASE, currentParamValue[PREDELAY]*maxVal);
		break;
	case DECAY :
		maxVal = (1<<HPS_0_DECAYVALUE_PIO_DATA_WIDTH) - 1;
		alt_write_word(ALT_LWFPGASLVS_ADDR + HPS_0_DECAYVALUE_PIO_BASE, currentParamValue[DECAY]*maxVal);
		break;
	case DAMPING :
		maxVal = (1<<HPS_0_DAMPINGVALUE_PIO_DATA_WIDTH) - 1;
		alt_write_word(ALT_LWFPGASLVS_ADDR + HPS_0_DAMPINGVALUE_PIO_BASE, currentParamValue[DAMPING]*maxVal);
		break;
	default :
		currentParamValue[NONE_PARAM] = 0;
		break;
	}

	/* --- display current parameter value on 7seg --- */
	uint8_t valueToDisplay;
	if(paramType == PREDELAY) valueToDisplay = 1000*NBR_DELAYLINE_INSTANCES_INITECHO*(currentParamValue[paramType]*1024)/SAMPLING_FREQ;
	else valueToDisplay = 100*currentParamValue[paramType];

	uint8_t hundred = valueToDisplay/100;
	uint8_t ten = (valueToDisplay - 100*hundred)/10;
	uint8_t unit = (valueToDisplay - 100*hundred - 10*ten);
	if(paramType != NONE_PARAM)	{
		alt_write_byte(ALT_LWFPGASLVS_ADDR + HPS_0_HEX5_BASE, (stringToDisplay[paramType][0] - 'A') + 10);
		alt_write_byte(ALT_LWFPGASLVS_ADDR + HPS_0_HEX4_BASE, (stringToDisplay[paramType][1] - 'A') + 10);
		alt_write_byte(ALT_LWFPGASLVS_ADDR + HPS_0_HEX3_BASE, 0b111110); // display off
		alt_write_byte(ALT_LWFPGASLVS_ADDR + HPS_0_HEX2_BASE, hundred);
		alt_write_byte(ALT_LWFPGASLVS_ADDR + HPS_0_HEX1_BASE, ten);
		alt_write_byte(ALT_LWFPGASLVS_ADDR + HPS_0_HEX0_BASE, unit);
	}
	else	{
		// dashes on each display
		alt_write_byte(ALT_LWFPGASLVS_ADDR + HPS_0_HEX5_BASE, 0b111111);
		alt_write_byte(ALT_LWFPGASLVS_ADDR + HPS_0_HEX4_BASE, 0b111111);
		alt_write_byte(ALT_LWFPGASLVS_ADDR + HPS_0_HEX3_BASE, 0b111111);
		alt_write_byte(ALT_LWFPGASLVS_ADDR + HPS_0_HEX2_BASE, 0b111111);
		alt_write_byte(ALT_LWFPGASLVS_ADDR + HPS_0_HEX1_BASE, 0b111111);
		alt_write_byte(ALT_LWFPGASLVS_ADDR + HPS_0_HEX0_BASE, 0b111111);
	}
	/* ----------------------------------------------------- */
}
