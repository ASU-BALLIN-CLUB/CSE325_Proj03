//
//  uc_pushb.c
//
//	Proj02
//  Lab Partners: Sean Slamka, Aydin Balci
//  Email: sslamka@asu.edu, abalci@asu.edu
//  CSE325 Embedded Microprocessor Systems
//  Fall 2014
//

#include "uc_pushb.h"

static int_isr_t g_callbacks[2] = {0};

void uc_pushb_init(uc_pushb_t const p_button, int_isr_t const p_callback)
{
	g_dtim_callbacks[p_button] = p_callback;
	gpio_port_init(gpio_port_ta, gpio_pin_0, gpio_funct_primary, gpio_data_dir_x, gpio_state_x);
	gpt_disable();
	gpt_incap_config(gpio_pin_1, gpt_incap_edge_t const p_incap_edge)
	if( p_button == uc_pushb_1)
	{
		int_config(gpt0_int_src, gpt0_int_level, gpt0_int_priority, uc_pushb_1_isr)
	}
	else
	{
		int_config(gpt1_int_src, gpt1_int_level, gpt1_int_priority, uc_pushb_2_isr)
	}
	gpt_enable();
}
__declspec(interrupt) void uc_pushb_1_isr()
{
	gpt_clr_flag(gpt_pin_0);
	if(g_dtim_callbacks[0] != NULL)
	{
		g_dtim_callbacks[0];
	}
}

__declspec(interrupt) void uc_pushb_2_isr()
{
	gpt_clr_flag(gpt_pin_1);
	if(g_dtim_callbacks[1] != NULL)
	{
		g_dtim_callbacks[1];
	}
}
