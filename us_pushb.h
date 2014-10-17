//
//  uc_pushb.h
//
//	Proj03
//  Lab Partners: Sean Slamka, Aydin Balci
//  Email: sslamka@asu.edu, abalci@asu.edu
//  CSE325 Embedded Microprocessor Systems
//  Fall 2014
//
#ifndef ____uc_pushb__
#define ____uc_pushb__
#include "support_common.h"
#include "int.h"
#include "gpio.h"
#include "dtim.h"
#include "gpt.h"
#include "global.h"

typedef enum {
 uc_pushb_1 = 0, // Represents push button 1
 uc_pushb_2 = 1  // Represents push button 2
} uc_pushb_t;

void uc_pushb_init(uc_pushb_t const p_button, int_isr_t const p_callback);
__declspec(interrupt) void uc_pushb_1_isr();
__declspec(interrupt) void uc_pushb_2_isr();
void uc_pushb_debounce(uc_pushb_t const p_button);
static int_isr_t g_callbacks[2] = {0};

#endif
