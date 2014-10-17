//
//  uc_led.h
//
//	Proj03
//  Lab Partners: Sean Slamka, Aydin Balci
//  Email: sslamka@asu.edu, abalci@asu.edu
//  CSE325 Embedded Microprocessor Systems
//  Fall 2014
//
#ifndef ____uc_led__
#define ____uc_led__

#include "gpio.h"
#include "support_common.h"

typedef enum {
 uc_led_1 = 1, // Represents LED1
 uc_led_2 = 2, // Represents LED2
 uc_led_3 = 3, // Represents LED3
 uc_led_4 = 4 // Represents LED4
} uc_led_t;

void uc_led_all_off();
void uc_led_all_on();
void uc_led_init();
void uc_led_off(gpio_pin_t p_led);
void uc_led_on(gpio_pin_t p_led);
void uc_led_toggle(gpio_pin_t p_led);

#endif /* defined (__uc_led__) */
