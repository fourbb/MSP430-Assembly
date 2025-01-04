;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
	bic.b #10111110b, &P1SEL   ; Set P1 pins as GPIO
    bic.b #10111110b, &P1SEL2
    bic.b #00000000b, &P2SEL   ; Set all P2 pins as GPIO
    bic.b #00000000b, &P2SEL2

    ; Configure LED pins as outputs
    bis.b #10110110b, &P1DIR   ; Set P1 pins (specific) as output for LEDs
    bis.b #00010010b, &P2DIR   ; Set P2.4 and P2.1 as outputs for LEDs

    ; Turn off all LEDs initially
    bic.b #10110110b, &P1OUT
    bic.b #00010010b, &P2OUT
	bic.b #10111110b, &P1SEL
	bic.b #10111110b, &P1SEL2
	bic.b #00000101b, &P2SEL
	bic.b #00000101b, &P2SEL2
	bis.b #10110110b, &P1DIR ;OUTPUT
	bis.b #00000101b, &P2DIR ;OUTPUT
	bic.b #00001000b, &P1DIR ;INPUT BUTTON
	bis.b #00001000b, &P1REN ; enable pull-up resistor for P1.3
	bis.b #00001000b, &P1OUT
	bic.b #10110110b,&P1OUT
	bic.b #00000101b,&P2OUT

    ; Configure Button 1 (P2.5) as input with pull-up resistor
    bic.b #00100000b, &P2DIR   ; Set P2.5 as input for Button 1
    bis.b #00100000b, &P2REN   ; Enable pull-up resistor for P2.5
    bis.b #00100000b, &P2OUT

    ; Configure Button 2 (P2.3) as input with pull-up resistor
    bic.b #00001000b, &P2DIR   ; Set P2.3 as input for Button 2
    bis.b #00001000b, &P2REN   ; Enable pull-up resistor for P2.3
    bis.b #00001000b, &P2OUT

    ; Enable interrupts for Button 1 and Button 2
    bis.b #00101000b, &P2IE    ; Enable interrupt for P2.5 (Button 1) and P2.3 (Button 2)
    bic.b #00101000b, &P2IFG   ; Clear interrupt flags for P2.5 and P2.3

    ; Configure edge select (falling edge for interrupts)
    bis.b #00101000b, &P2IES

    ; Configure Timer A
    mov.w #TASSEL_1 + MC_1 + ID_3, &TA0CTL   ; ACLK, Up mode, Input Divider: 8
    mov.w #5000, &TA0CCR0                    ; Timer counts for ~1 second (adjust as needed)
    bic.b #BIT0, &TA0CCTL0                   ; Disable timer interrupt initially

    ; Enable global interrupts
    eint

    ; Turn off all LEDs initially
    bic.b #00010010b, &P2OUT   ; Turn off both LEDs (P2.4 and P2.1)

Mainloop:
	mov.w #0, r5
	mov.w #1, r4
	call+ #turnofall
	call #three
	call #Delay_3s
	call #Delay_3s
    call #Delay_3s
    call #Delay_3s
	add.w r4, r5
	call #turnofall
	call #two
	call #Delay_3s
	call #Delay_3s
    call #Delay_3s
    call #Delay_3s
	add.w r4, r5
	call #turnofall
	call #one
	call #Delay_3s
	call #Delay_3s
    call #Delay_3s
    call #Delay_3s
    call #Delay_3s
	add.w r4, r5
	call #turnofall
	call #zero
	call #Delay_3s
	call #Delay_3s
    call #Delay_3s
    call #Delay_3s
	add.w r4, r5
	call #turnofall
	call #minue
	call #Delay_3s
	call #Delay_3s
    call #Delay_3s
    call #Delay_3s
    jmp Mainloop                             ; Main loop does nothing, relies on interrupts

; Interrupt Service Routine for Port 2
PORT2_ISR:
    push.w SR                                ; Save status register
    push.w R15                               ; Save R15

    bit.b #BIT5, &P2IFG                      ; Check if interrupt caused by Button 1 (P2.5)
    jne Button1_ISR
    bit.b #BIT3, &P2IFG                      ; Check if interrupt caused by Button 2 (P2.3)
    jne Button2_ISR

    ; Clear interrupt flags and return
    bic.b #00101000b, &P2IFG                 ; Clear interrupt flags for P2.5 and P2.3
    pop.w R15                                ; Restore R15
    pop.w SR                                 ; Restore status register
    reti

Button1_ISR:
    bit.b #BIT5, &P2IN                       ; Check if Button 1 (P2.5) is pressed
    cmp.w #0, r5                             ; Compare R5 with 0
    jeq led_2
    cmp.w #1, r5                             ; Compare R5 with 0
    jeq led_2
    cmp.w #2, r5                             ; Compare R5 with 0
    jeq led_2
    cmp.w #3, r5                             ; Compare R5 with 0
    jeq led_2                     ; If R5 == 0, jump to desired function
    cmp.w #4, r5                             ; Compare R5 with 0
    jeq led_1
    jmp ISR_End


Button2_ISR:
    bit.b #BIT3, &P2IN                       ; Check if Button 2 (P2.3) is pressed
    cmp.w #0, r5                             ; Compare R5 with 0
    jeq led_1
    cmp.w #1, r5                             ; Compare R5 with 0
    jeq led_1
    cmp.w #2, r5                             ; Compare R5 with 0
    jeq led_1
    cmp.w #3, r5                             ; Compare R5 with 0
    jeq led_1                     ; If R5 == 0, jump to desired function
    cmp.w #4, r5                             ; Compare R5 with 0
    jeq led_2
    jmp ISR_End


ISR_End:
    bic.b #00101000b, &P2IFG                 ; Clear interrupt flags for P2.5 and P2.3
    pop.w R15                                ; Restore R15
    pop.w SR                                 ; Restore status register
    mov.w #0, r5
    reti
led_1:
	bis.b #BIT4, &P2OUT                      ; Turn on LED 1 (P2.4) if pressed
    call #Delay_3s
    call #Delay_3s
    call #Delay_3s
    call #Delay_3s
    call #Delay_3s
    bic.b #BIT4, &P2OUT                      ; Turn on LED 1 (P2.4) if pressed
    ret
led_2:
	bis.b #BIT1, &P2OUT                      ; Turn on LED 2 (P2.1) if pressed
    call #Delay_3s
    call #Delay_3s
    call #Delay_3s
    call #Delay_3s
    call #Delay_3s
    bic.b #BIT1, &P2OUT                      ; Turn on LED 2 (P2.1) if pressed
    ret
Delay_3s:
    mov.w #0xFFFF, R15                    ; Load R15 with a loop count (~15 seconds approximation)
Delay_Loop:
    dec.w R15                               ; Decrement R15
    jnz Delay_Loop                          ; Repeat until R15 is 0
    ret

zero:
	bic.b #BIT1|BIT2|BIT4|BIT5|BIT7, &P1OUT ;
	bic.b #BIT0, &P2OUT
	call #Delay_3s
	ret
one:
	bic.b #BIT2|BIT4,&P1OUT
	call #Delay_3s
	ret
two:
	bic.b #BIT1|BIT2|BIT5|BIT7,&P1OUT
	bic.b #BIT2,&P2OUT
	call #Delay_3s
	ret
three:
	bic.b #BIT1|BIT2|BIT4|BIT5,&P1OUT
	bic.b #BIT2,&P2OUT
	call #Delay_3s
	ret

turnofall:
	bis.b #10110110b,&P1OUT;turn off all lights.
	bis.b #00000101b,&P2OUT
	ret

minue:
	bic.b #BIT2,&P2OUT
	ret

                                            

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
			.sect ".int03"
            .short PORT2_ISR
