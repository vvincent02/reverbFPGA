#include "app.h"

#include <stdio.h>
#include <stdlib.h>
#include "hps_0_arm_a9_0.h"
#include "alt_printf.h"
#include "alt_generalpurpose_io.h"

int main(void) {
	alt_printf("!!!Hello World!!!"); /* prints !!!Hello World!!! */

	alt_gpio_init();

	alt_gpio_port_datadir_set(ALT_GPIO_PORTB, 1<<24, 1<<24);

	uint8_t val = 1;
	while(1)	{
		val = !val;
		alt_gpio_port_data_write(ALT_GPIO_PORTB, 1<<24, val<<24);
		//for(int i = 0; i < 10000000; i++){}
	}
	return EXIT_SUCCESS;
}
