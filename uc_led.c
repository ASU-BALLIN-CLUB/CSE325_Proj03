//
//  uc_led.c
//
//	Proj03
//  Lab Partners: Sean Slamka, Aydin Balci
//  Email: sslamka@asu.edu, abalci@asu.edu
//  CSE325 Embedded Microprocessor Systems
//  Fall 2014
//

#include "uc_led.h"

// Turns all leds off.
void uc_led_all_off()
{
	 uc_led_off((gpio_pin_t)uc_led_1);
	 uc_led_off((gpio_pin_t)uc_led_2);
	 uc_led_off((gpio_pin_t)uc_led_3);
	 uc_led_off((gpio_pin_t)uc_led_4);
}

// Turns all leds on.
void uc_led_all_on()
{
	uc_led_on((gpio_pin_t)uc_led_1);
	uc_led_on((gpio_pin_t)uc_led_2);
	uc_led_on((gpio_pin_t)uc_led_3);
	uc_led_on((gpio_pin_t)uc_led_4);
}

// Initializes the leds.
void uc_led_init()
{
	 gpio_port_init(gpio_port_tc , gpio_pin_0, gpio_funct_gpio, gpio_data_dir_out, gpio_pin_state_low);
	 gpio_port_init(gpio_port_tc , gpio_pin_1, gpio_funct_gpio, gpio_data_dir_out, gpio_pin_state_low);
	 gpio_port_init(gpio_port_tc , gpio_pin_2, gpio_funct_gpio, gpio_data_dir_out, gpio_pin_state_low);
	 gpio_port_init(gpio_port_tc , gpio_pin_3, gpio_funct_gpio, gpio_data_dir_out, gpio_pin_state_low);
}

// Turns a certain led off.
void uc_led_off(gpio_pin_t p_led)
{
	gpio_port_set_pin_state(gpio_port_tc, p_led, gpio_pin_state_low);
}

// Turns a cerain led on.
void uc_led_on(gpio_pin_t p_led)
{
	gpio_port_set_pin_state(gpio_port_tc, (gpio_pin_t)p_led, gpio_pin_state_high);

}

// Toggles the leds and gets the pin state.
void uc_led_toggle(gpio_pin_t p_led)
{
	 gpio_port_get_pin_state(gpio_port_tc, p_led);
}
