//
//  dtim.h
//
//
//  Created by Sean Slamka on 9/17/14.
//
//  Lab Partners: Sean Slamka, Aydin Balci

#ifndef ____dtim__
#define ____dtim__

#include "gpio.h"


//Header file for gpio function
class dtim
{
	typedef enum {
	 dtim_0 = 0, // DMA timer 0
	 dtim_1 = 1, // DMA timer 1
	 dtim_2 = 2, // DMA timer 2
	 dtim_3 = 3 // DMA timer 3
	} dtim_t ;

};

#endif /* defined(__gpio__) */
