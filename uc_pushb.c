//
//  uc_pushb.c
//
//	Proj03
//  Lab Partners: Sean Slamka, Aydin Balci
//  Email: sslamka@asu.edu, abalci@asu.edu
//  CSE325 Embedded Microprocessor Systems
//  Fall 2014
//

#include "uc_pushb.h"



void uc_pushb_init(uc_pushb_t const p_button, int_isr_t const p_callback)
{
	g_callbacks[p_button] = p_callback;
	gpio_port_init(gpio_port_ta, (gpio_pin_t)p_button, gpio_funct_primary, gpio_data_dir_x, gpio_pin_state_x);
	//void gpio_port_init(gpio_port_t p_port, gpio_pin_t p_pin, gpio_funct_t p_funct, gpio_data_dir_t p_data_dir, gpio_pin_state_t p_state)
	gpt_disable();
	gpt_incap_config((gpt_pin_t)p_button, gpt_incap_edge_falling);
	if( p_button == uc_pushb_1)
	{
		int_config(GPT_INT_SRC(p_button), GPT_INT_LVL(0), GPT_INT_PRI(0), uc_pushb_1_isr);
	}
	else
	{
		int_config(GPT_INT_SRC(1), GPT_INT_LVL(1), GPT_INT_PRI(1), uc_pushb_2_isr);
	}
	gpt_enable();
}
__declspec(interrupt) void uc_pushb_1_isr()
{
	uc_pushb_debounce(uc_pushb_1);
	gpt_clr_flag(gpt_pin_0);
	if(g_callbacks[0] != 0)
	{
		g_callbacks[0]();
	}
}

__declspec(interrupt) void uc_pushb_2_isr()
{
	uc_pushb_debounce(uc_pushb_2);
	
	gpt_clr_flag(gpt_pin_1);
	if(g_callbacks[1] != 0)
	{
		g_callbacks[1]();
	}
}

void uc_pushb_debounce(uc_pushb_t const p_button)
{
	uint8 signal = 0x01;
	uint16 state = 0x0000;
	do
	{
		state = (state << 1) | (uint16)signal | 0xE000;
		signal = (~MCF_GPT_GPTPORT >> p_button) & 0x01;
	}while(state != 0xF000);
}

