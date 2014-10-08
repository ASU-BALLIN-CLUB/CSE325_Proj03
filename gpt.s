;***********************************************************************************************************************************
; FILE: gpt.s
;
; DESCRIPTION
; GPT module related functions.
;***********************************************************************************************************************************
.include "global.inc"  ; Included for IPSBAR
.include "gpt.inc"     ; Included for enumerated values

;===================================================================================================================================
; GPT registers
;
; Look at Table 25-3 on pp. 25-3 to 25-4 in the IMRM. The base address of the GPT register space is IPSBAR + 0x1A_0000. Table 25-3
; lists all of the GPT registers and their offsets from IPSBAR. Note that all of the GPT registers are 8-bits.
;===================================================================================================================================
GPT_BASE:      .equ IPSBAR + 0x1A_0000
GPT_GPTCNT:    .equ GPT_BASE + $0004  ; 8-bit reg
GPT_GPTCTL2:   .equ GPT_BASE + $000B  ; 8-bit reg
GPT_GPTDDR:    .equ GPT_BASE + $001E  ; 8-bit reg
GPT_GPTFLG1:   .equ GPT_BASE + $000E  ; 8-bit reg
GPT_GPTIE:     .equ GPT_BASE + $000C  ; 8-bit reg
GPT_GPTIOS:    .equ GPT_BASE + $0000  ; 8-bit reg
GPT_GPTPORT:   .equ GPT_BASE + $001D  ; 8-bit reg
GPT_GPTSCR1:   .equ GPT_BASE + $0006  ; 8-bit reg
GPT_GPTSCR2:   .equ GPT_BASE + $000D  ; 8-bit reg

;===================================================================================================================================
; Public Functions
;
; Public functions are specified using the .global directive (these names are exported to the linker so other object code files can
; reference these functions).
;
; Write assembly language code to declare each of the functions in this source file as global.
;===================================================================================================================================

.global _gpt_clr_flag
.global _gpt_disable
.global _gpt_enable
.global _gpt_incap_config

;===================================================================================================================================
; Text Section
;===================================================================================================================================

.text

;-----------------------------------------------------------------------------------------------------------------------------------
; FUNCTION: __declspec(register_abi) void gpt_clr_flag(gpt_pin_t const p_pin)
;
; INPUT PARAMS
; p_pin  d0
;
; DESCRIPTION
; Clears the interrupt request flag for pin p_pin.
;
; RETURNS
; Nothing
;
; REGISTER USAGE
; d0-d2, a0
;
; NOTE
; This function is intended to be called from an ISR, in particular for Lab Project 3, from uc_pushb1_isr(). An ISR is not permitted
; permitted to modify ANY registers (data, address, SR[CCR]) without saving and restoring the registers. Consequently we save and
; restore d0-d2 and a0.
;
; VERY IMPORTANT NOTE
; To load the value of the GPTFLG1 register into d0, we first move the address of GPTFLG1 into a0 using the LEA (load effective
; address) instruction. Then we use a MOVE.B instruction to move the value from (a0) to d2. Why MOVE.B rather than MOVE.L? Because
; GPTFLG1 is an 8-bit register. I got burned by this, so remember: for an 8-bit register use MOVE.B; for a 16-bit register use
; MOVE.W; and for a 32-bit register use MOVE.L.
;
; EQUIVALENT C CODE
; __declspec(register_abi) void gpt_clr_flag(gpt_pin_t const p_pin)
; {
;     GPT_GPTFLG1 |= 1 << p_pin;
; }
;
; REMARKS
; Because this function is called from an ISR it is important to save d0-d2, a0 on the stack at the beginning of this function and
; to restore them at the end.
;-----------------------------------------------------------------------------------------------------------------------------------
_gpt_clr_flag:
    link       a6, #-16                ; Create stack frame and allocate room for d0-d2 and a0
    movem.l    d0-d2/a0, (a7)          ; Save d0-d2 and a0 (pushed in this order: d2, d1, d0, a0)

; GPT_GPTFLG1 |= 1 << p_pin
    moveq.l    #1, d1                  ; 1 -> d1 (hint: MOVEQ.L)
    lsl.l      d0, d1                  ; 1 << p_pin -> d1 (hint: LSL.L)
    lea	       GPT_GPTFLG1, a0         ; &GPT_GPTFLG1 -> a0 (hint: LEA)
    move.b     a0, d2                  ; GPT_GPTFLG1 -> d2 (hint: MOVE.B)
    or.l       d2, d0                  ; GPT_GPTFLG1 | (1 << p_pin) -> d2  (hint: OR.L)
    move.b     d2, GPT_GPTFLG1         ; GPT_GPTFLG1 = GPT_GPTFLG1 | (1 << p_pin) (hint: MOVE.B)

    movem.l    (a7), d0-d2/a0          ; Restore d0-d2 and a0
    unlk       a6                      ; Destroy stack frame
    rts                                ; Return (hint: RTS)

;-----------------------------------------------------------------------------------------------------------------------------------
; FUNCTION: __declspec(register_abi) void gpt_disable()
;
; INPUT PARAMS
; None
;
; DESCRIPTION
; Disables the GPT module.
;
; RETURNS
; Nothing
;
; REGISTER USAGE
; a0
;
; EQUIVALENT C CODE
; __declspec(register_abi) void gpt_disable()
; {
;     GPT_GPTSCR1 = 0x00;
; }
;
; REMARKS
; This is a leaf procedure so there is no need to create and destroy a stack frame.
;-----------------------------------------------------------------------------------------------------------------------------------
_gpt_disable:
; GPT_GPTSCR1 = 0x00
    lea        GPT_GPTSCR1, a0         ; &GPT_GPTSCR1 -> a0 (hint: LEA)
    move.b     #$00, a0                ; 0x00 -> GPT_GPTSCR1 (hint: MOVE.B)
    rts                                ; return

;-----------------------------------------------------------------------------------------------------------------------------------
; FUNCTION: __declspec(register_abi) void gpt_enable()
;
; INPUT PARAMS
; None
;
; DESCRIPTION
; Enables the GPT module.
;
; RETURNS
; Nothing
;
; REGISTER USAGE
; d0, a0
;
; EQUIVALENT C CODE
; __declspec(register_abi) void gpt_enable()
; {
;     GPT_GPTSCR1 = 0x80;
; }
;
; REMARKS
; This is a leaf procedure so there is no need to create and destroy a stack frame.
;-----------------------------------------------------------------------------------------------------------------------------------
_gpt_enable:
; GPT_GPTSCR1 = 0x80
    lea        GPT_GPTSCR1, a0         ; &GPT_GPTSCR1 -> a0 (hint: LEA)
    move.b     #$80, a0                ; 0x80 -> GPT_GPTSCR1 (hint: MOVE.B)
    rts                                ; return


;-----------------------------------------------------------------------------------------------------------------------------------
; FUNCTION: __declspec(register_abi) void gpt_incap_config(gpt_pin_t const p_pin, gpt_incap_edge_t const p_incap_edge)
;
; INPUT PARAMS
; p_pin         d0
; p_incap_edge  d1
;
; DESCRIPTION
; Initializes pin p_pin of the GPT module for the input capture mode. The input capture edge is specified by p_incap_edge. See the
; enumerated type for gpt_incap_edge in gpt.h and gpt.inc.
;
; RETURNS
; Nothing
;
; REGISTER USAGE
; d0-d4, a0
;
; SAVES AND RESTORES
; d3-d4
;
; EQUIVALENT C CODE
; __declspec(register_abi) void gpt_incap_config(gpt_pin_t const p_pin, gpt_incap_edge_t const p_incap_edge)
; {
;     gpt_disable();
;     GPTIOS &= ~(1 << p_pin);
;     GPTCTL2 &= ~(0x03 << (2 * p_pin);
;     GPTCTL2 |= p_incap_edge << (2 * p_pin);
;     GPTIE |= 1 << p_pin;
;     GPTFLG1 |= 1 << p_pin;
;     GPTDDR &= ~(1 << p_pin);
; }
;
; REMARKS
; In register_abi, the first three integer parameters as passed in d0, d1, and 2; consequently, d0 contains parameter p_pin and d1
; contains parameter p_incap_edge. In ColdFire, data registers d0-d2 and address registers a0-a1 are "scratch" registers, i.e.,
; they may be modified by the callee function without saving them; if those registers contain values that the caller function does
; not want to be modified by the callee, then it is the responsibility of the caller to save those registers before calling the
; callee.
;
; On the other hand, data registers d3-d7 and address registers a2-a5 cannot be changed by the callee unless the callee first
; saves the current contents of registers to be used on the stack and restores them before returning. To summarize:
;
; Data Registers     Caller                             Callee
; d0-d2              Must save before calling callee    May modify without saving and restoring
; d3-d7              Does not have to save              Must be saved and restored
;
; Address Registers  Caller                             Callee
; a0-a1              Must save before calling callee    May modify without saving and restoring
; a2-a5              Does not have to save              Must be saved and restored
;-----------------------------------------------------------------------------------------------------------------------------------
_gpt_incap_config:
    link       a6, #-8                 ; Create stack frame and allocate 2 longwords on stack for d3 and d4 (hint: LINK)
    movem.l    d3-d4, (a7)             ; Push d3 and d4 (actually pushes d4 first) (hint: see MOVEM.L in _gpt_clr_flag)

; gpt_disable()
    adda.l     #-8, a7                 ; Allocate 2 longwords on stack so we can save d0-d1 (hint ADDA.L or SUBA.L)
    movem.l    d0-d1, (a7)             ; Push d0-d1 (hint: MOVEM.L)
    _gpt_disable                       ; Disable the GPT while configuring the pin by calling _gpt_disable
    movem.l    (a7), d0-d1             ; Pop d0-d1 (Hint: MOVEM.L) Note: allocated room on stack for d0-d1 is deallocated by UNLK

; GPTIOS &= ~(1 << p_pin)
    moveq.l    #1, d3                  ; 1 -> d3 (hint: MOVEQ.L)
    lsl.l      d0, d3                  ; 1 << p_pin -> d3 (hint: LSL.L)
    not.l      d3                      ; ~(1 << p_pin) -> d3 (hint: NOT.L)
    lea        GPT_GPTIOS, a0          ; &GPT_GPTIOS -> a0 (hint: LEA)
    move.b     a0, d4                  ; GPT_GPTIOS -> d4 (hint: MOVE.B)
    and.l      d4, a0, d3              ; GPT_GPTIOS & ~(1 << p_pin) -> d4 (hint: AND.L)
    move.b     d4, a0                  ; GPTIOS &= ~(1 << p_pin) (hint: MOVE.B)

; GPTCTL2 &= ~(0x03 << (2 * p_pin)
    move.l     d0, d4                  ; p_pin -> d4 (hint: MOVE.L)
    lsl.l      #1, d4                  ; 2 * p_pin -> d4 (hint: use LSL.L to quickly multiply by 2)
    moveq.l    #$03, d3                ; 0x03 -> d3 (hint: MOVEQ.L)
    lsl.l      d4, d3                  ; 0x03 << (2 * p_pin) -> d3 (hint: LSL.L)
    not.l      d3                      ; ~(0x03 << (2 * p_pin)) -> d3 (hint: NOT.L)
    lea        GPT_GPTCTL2, a0         ; &GPT_GPTCTL2 -> a0 (hint: LEA)
    move.b     a0, d4                  ; GPT_GPTCTL2 -> d4 (hint: MOVE.B)
    and.l      d3, a0, d4              ; GPT_GPTCTL2 & ~(0x03 << (2 * p_pin)) -> d3 (hint: AND.L)
    move.b     d3, a0                  ; GPTCTL2 &= ~(0x03 << (2 * p_pin)) (hint: MOVE.B)

; GPTCTL2 |= p_incap_edge << (2 * p_pin)
    move.l     d0, d4                  ; p_pin -> d4 (hint: MOVE.L)
    lsl.l      #1, d4                  ; 2 * p_pin -> d4 (hint: LSL.L)
    move.l     d1, d3                  ; p_incap_edge -> d3 (hint MOVE.L)
    lsl.l      d4, d3                  ; p_incap_edge << (2 * p_pin) -> d3 (hint: LSL.L)
    move.b     a0, d4                  ; GPT_GPTCTL2  -> d4 (hint: MOVE.B)
    or.l       d3, a0, d4              ; GPT_GPTCTL2 | p_incap_edge << (2 * p_pin) -> d3 (hint: OR.L)
    move.b     d3, a0                  ; GPTCTL2 |= p_incap_edge << (2 * p_pin) (hint: MOVE.B)

; GPTIE |= 1 << p_pin
    moveq.l    #1, d3                  ; 1 -> d3 (hint: MOVEQ.L)
    lsl.l      d0, d3                  ; 1 << p_pin -> d3 (hint: LSL.L)
    lea        GPT_GPTIE, a0           ; &GPT_GPTIE -> a0 (hint: LEA)
    move.b     a0, d4                  ; GPT_GPTIE -> d4 (hint: MOVE.B)
    or.l       d4, a0, d3              ; GPT_GPTIE | 1 << p_pin -> d4 (hint: OR.L)
    move.b     d4, a0                  ; GPTIE |= 1 << p_pin (hint: MOVE.B)

; GPTFLG1 |= 1 << p_pin
    lea        GPT_GPTFLG1, a0         ; &GPT_GPTFLG1 -> a0 (hint: LEA)
    move.b     a0, d4                  ; GPT_GPTFLG1 -> d4 (hint: MOVE.B)
    or.l       d4, a0, d3              ; GPT_GPTFLG1 | 1 << p_pin -> d4 (hint: OR.L)
    move.b     d4, a0                  ; GPTFLG1 |= 1 << p_pin (hint: MOVE.B)

; GPTDDR &= ~(1 << p_pin)
    not.l      d3                      ; ~(1 << p_pin) -> d3 (hint: NOT.L)
    lea        GPT_GPTDDR, a0          ; &GPT_GPTDDR -> a0 (hint: LEA)
    move.b     a0, d4                  ; GPT_GPTDDR -> d4 (hint: MOVE.B)
    and.l      d4, a0, d3              ; GPT_GPTDDR & ~(1 << p_pin) -> d4 (hint: AND.L)
    move.b     d3, a0                  ; GPTDDR &= ~(1 << p_pin) (hint: MOVE.B)

; Restore d3-d4, destroy stack frame and return.
    movem.l    (a7), d3-d4             ; (Hint: MOVEM.L)
    unlk       a6                      ; (Hint: UNLK)
    rts                                ; Return
