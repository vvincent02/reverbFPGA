#include "app.h"

#include <stdio.h>
#include <stdlib.h>
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
	if(alt_gpio_port_datadir_set(ALT_GPIO_PORTA, 1, 1) != ALT_E_SUCCESS)	{
		errorHandler();
		return EXIT_FAILURE;
	}
	if(alt_gpio_port_data_write(ALT_GPIO_PORTA, 1, 0) != ALT_E_SUCCESS)	{
		errorHandler();
		return EXIT_FAILURE;
	}
	/* --- */

	/* --- Set audio CODEC registers through I2C communication --- */
	/*ALT_I2C_DEV_t I2C_Device;
	ALT_STATUS_CODE retVal;

	retVal = alt_i2c_init(ALT_I2C_I2C0, &I2C_Device);
	if(retVal == ALT_E_SUCCESS)	{
		retVal = alt_i2c_enable(&I2C_Device);
	}
	if(retVal == ALT_E_SUCCESS)	{
		retVal = alt_i2c_write(&I2C_Device, AUDIO_CODEC_ADDR); // access
	}

	if(retVal != ALT_E_SUCCESS)	{
		errorHandler();
		return EXIT_FAILURE;
	}*/

	/* --- */

	uint8_t val = 1;
	while(1)	{
		/*val = !val;
		alt_gpio_port_data_write(ALT_GPIO_PORTB, 1<<24, val<<24);
		for(int i = 0; i < 100000; i++){}*/
	}
	return EXIT_SUCCESS;
}
