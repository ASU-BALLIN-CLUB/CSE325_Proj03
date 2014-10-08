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
#include "dtim.h"


typedef enum {
 uc_pushb_1 = 0, // Represents
 uc_pushb_2 = 1, // Represents
} uc_pushb_t;

void uc_pushb_init(uc_pushb_t const p_button, int_isr_t const p_callback);
__declspec(interrupt) void uc_pushb_1_isr();
__declspec(interrupt) void uc_pushb_2_isr();

#endif
