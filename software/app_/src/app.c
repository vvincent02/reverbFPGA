#include <stdio.h>
#include <stdlib.h>
#include "hps_0_arm_a9_0.h"

int main(void) {
	printf("!!!Hello World!!!"); /* prints !!!Hello World!!! */
	volatile int *gpio0 = (int*)0xff708000;
	volatile int *gpio1 = (int*)0xff709000;
	volatile int *gpio2 = (int*)0xff70A000;
	*gpio0 = 0x00;
	*gpio1 = 0x00;
	*gpio2 = 0x00;
	return EXIT_SUCCESS;
}
