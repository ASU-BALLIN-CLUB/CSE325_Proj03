//
//  main.c
//
//	Proj03
//  Lab Partners: Sean Slamka, Aydin Balci
//  Email: sslamka@asu.edu, abalci@asu.edu
//  CSE325 Embedded Microprocessor Systems
//  Fall 2014
//

#include "support_common.h"
#include "gpio.h"
#include "uc_led.h"
#include "dtim.h"
#include "int.h"
#include "uc_pushb.h"
#include "global.h"
#include "gpt.h"
static void hw_init();
__declspec(noreturn) int main();
static void run();
static void pushb_1_callback();
static void dtim0_callback();

typedef enum {
    dir_left_to_right = 0,  // The pin connected to GPT channel 0
    dir_right_to_left = 1   // The pin connected to GPT channel 1
} dir_t;

typedef enum {
    fsm_state_led_off = 0,  // The pin connected to GPT channel 0
    fsm_state_led_on = 1    // The pin connected to GPT channel 1
} fsm_state_t;

static bool_t g_dtim0_irq = false;
static dir_t g_dir = dir_right_to_left;

static void dtim0_callback()
{
	g_dtim0_irq = true;
}

static void hw_init()
{
	int_inhibit_all();
	dtim_init_irq(dtim_0, 250000, dtim0_callback);
	uc_led_init();
	uc_pushb_init(uc_pushb_1, pushb_1_callback);
	int_uninhibit_all();
}

static void pushb_1_callback()
{
	if(g_dir == dir_right_to_left)
	{
		g_dir = dir_left_to_right;
	}
	else
	{
		g_dir = dir_right_to_left;
	}
}

static void run()
{
	int curr_led = 1;
	fsm_state_t state = fsm_state_led_off;
	uc_led_on((gpio_pin_t)uc_led_1);
	while(1)
	{
		while(g_dtim0_irq == false)
		{
		}
		if(state == fsm_state_led_off)
		{
			uc_led_off((gpio_pin_t)curr_led);
			if(g_dir == dir_right_to_left)
			{
				if(curr_led == 8)
				{
					curr_led = 1;
				}
				else
				{
					if(curr_led == 1)
					{
						curr_led++;
					}
					else if(curr_led == 2)
					{
						curr_led += 2;
					}
					else
					{
						curr_led += 4;
					}
				}
			}
			else
			{
				if(curr_led == 1)
				{
					curr_led = 8;
				}
				else
				{
					if(curr_led == 8)
					{
						curr_led -= 4;
					}
					else if(curr_led == 4)
					{
						curr_led -= 2;
					}
					else
					{
						curr_led--;
					}
				}
			}
			state = fsm_state_led_on;
		}
		else
		{
			uc_led_on((gpio_pin_t)curr_led);
			state = fsm_state_led_off;
		}
		g_dtim0_irq = false;
	}
}

__declspec(noreturn) int main()
{
	hw_init();
	run();
}
