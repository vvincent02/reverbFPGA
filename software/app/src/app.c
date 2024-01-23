#include "app.h"

#include "hps.h"
#include "alt_printf.h"
#include "alt_generalpurpose_io.h"
#include "alt_i2c.h"

void errorHandler(void)	{
	// turn on USER LED on error
	alt_gpio_port_datadir_set(ALT_GPIO_PORTB, 1<<24, 1<<24);
	alt_gpio_port_data_write(ALT_GPIO_PORTB, 1<<24, 1<<24);
}

int main(void) {
	alt_printf("!!!Hello World!!!"); /* prints !!!Hello World!!! */


	/* --- Set HPS_I2C_CONTROL to 1 for audio CODEC access from HPS --- */
	alt_gpio_init();
	if(alt_gpio_port_datadir_set(ALT_GPIO_PORTB, 1<<19, 1<<19) != ALT_E_SUCCESS)	{
		errorHandler();
		return EXIT_FAILURE;
	}
	if(alt_gpio_port_data_write(ALT_GPIO_PORTB, 1<<19, 1<<19) != ALT_E_SUCCESS)	{
		errorHandler();
		return EXIT_FAILURE;
	}
	/* --- */

	/* --- Set audio CODEC registers through I2C communication --- */
	ALT_I2C_DEV_t I2C_Device;
	ALT_STATUS_CODE retVal;

	retVal = alt_i2c_init(ALT_I2C_I2C0, &I2C_Device);
	if(retVal == ALT_E_SUCCESS)	{
		retVal = alt_i2c_enable(&I2C_Device);
	}
	if(retVal == ALT_E_SUCCESS)	{
		retVal = alt_i2c_master_target_set(&I2C_Device, AUDIO_CODEC_ADDR);
	}

	// power up everything except line output
	if(retVal == ALT_E_SUCCESS)	{
		retVal = alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(POWER_DOWN_CONTROL_ADDR, 0b00010000),
										 2,
										 0,
										 1);
	}

	/* --- set required values in registers except ACTIVE_CONTROL register --- */
	if(retVal == ALT_E_SUCCESS)	{
		retVal = alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(ANALOG_AUDIO_PATH_CONTROL_ADDR, 0b00010010),
										 2,
										 0,
										 1);
	}
	alt_i2c_tx_fifo_level_get(&I2C_Device, &val);
	if(retVal == ALT_E_SUCCESS)	{
		retVal = alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(LEFT_LINE_IN_ADDR, 0b000011111),
										 2,
										 0,
										 1);
	}
	if(retVal == ALT_E_SUCCESS)	{
		retVal = alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(RIGHT_LINE_IN_ADDR, 0b000011111),
										 2,
										 0,
										 1);
	}
	if(retVal == ALT_E_SUCCESS)	{
		retVal = alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(DIGITAL_AUDIO_INTERFACE_FORMAT_ADDR, 0b01001001),
										 2,
										 0,
										 1);
	}
	if(retVal == ALT_E_SUCCESS)	{
		retVal = alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(DIGITAL_AUDIO_PATH_CONTROL_ADDR, 0b00000),
										 2,
										 0,
										 1);
	}
	if(retVal == ALT_E_SUCCESS)	{
		retVal = alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(SAMPLING_CONTROL_ADDR, 0b00000010),
										 2,
										 0,
										 1);
	}
	/* --- */

	// Set ACTIVE_CONTROL register
	if(retVal == ALT_E_SUCCESS)	{
		retVal = alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(ACTIVE_CONTROL_ADDR, 0b1),
										 2,
										 0,
										 1);
	}

	// Power up line output
	if(retVal == ALT_E_SUCCESS)	{
		retVal = alt_i2c_master_transmit(&I2C_Device,
										 bufferToSend(POWER_DOWN_CONTROL_ADDR, 0b00000000),
										 2,
										 0,
										 1);
	}

	if(retVal != ALT_E_SUCCESS)	{
		errorHandler();
		return EXIT_FAILURE;
	}

	/* --- */

	while(1)	{
		/*val = !val;
		alt_gpio_port_data_write(ALT_GPIO_PORTB, 1<<24, val<<24);
		for(int i = 0; i < 100000; i++){}*/
	}
	return EXIT_SUCCESS;
}
