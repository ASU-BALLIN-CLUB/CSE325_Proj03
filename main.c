//
//  main.c
//
//	Proj02
//  Lab Partners: Sean Slamka, Aydin Balci
//  Email: sslamka@asu.edu, abalci@asu.edu
//  CSE325 Embedded Microprocessor Systems
//  Fall 2014
//

#include "support_common.h"
#include "gpio.h"
#include "uc_dipsw.h"
#include "uc_led.h"
#include "dtim.h"
static void count_up(uint32 p_delay);
static uint32 dipsw_delay_poll();
static void dipsw_onoff_poll();
static void hw_init();
static void leds_on(int const p_value);
__declspec(noreturn) int main();
static void run();

