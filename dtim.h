//
//  dtim.h
//
//	Proj02
//  Lab Partners: Sean Slamka, Aydin Balci
//  Email: sslamka@asu.edu, abalci@asu.edu
//  CSE325 Embedded Microprocessor Systems
//  Fall 2014
//
#ifndef ____dtim__
#define ____dtim__

#include "gpio.h"
#include "support_common.h"

//Header file for dtim function
typedef enum {
 dtim_0 = 0, // DMA timer 0
 dtim_1 = 1, // DMA timer 1
 dtim_2 = 2, // DMA timer 2
 dtim_3 = 3 // DMA timer 3
} dtim_t;

void dtim_busy_delay_ms(dtim_t const p_timer, uint32 const p_msecs);
void dtim_busy_delay_us(dtim_t const p_timer, uint32 const p_usecs);
void dtim_init(dtim_t const p_timer);
//static uint32 const DTIM_BASE = 0x40000400;

#endif /*  defined (__dtim__) */
