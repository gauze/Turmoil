; vim: ts=4
; vim: syntax=asm6809
; Sound Registers 
PSG_Ch1_Freq_Lo     =        0 
PSG_Ch1_Freq_Hi     =        1 
PSG_Ch2_Freq_Lo     =        2 
PSG_Ch2_Freq_Hi     =        3 
PSG_Ch3_Freq_Lo     =        4 
PSG_Ch3_Freq_Hi     =        5 
PSG_Noise           =        6 
PSG_OnOff           =        7 			    ; see below for bit masks to turn channels on or off.
PSG_Ch1_Vol         =        8 
PSG_Ch2_Vol         =        9 
PSG_Ch3_Vol         =        10 
PSG_Env_Period      =        11             ; used for D reg transfer
PSG_Env_Period_Fine  =       11 
PSG_Env_Period_Coarse  =     12 
PSG_Env_Shape       =        13 			; only used when register 8-10 == %1xxxx 
PSG_Data_A          =        14				
; flag to use simpler ADSR method
Use_Env             =        %10000         ; set bit 5 of Vol regs to use env 
; bits start on LEFT -> 01234567 
;        0 - Voice 1 use Tone Generator 1 On/Off
;        1 - Voice 2 use Tone Generator 2 On/Off
;        2 - Voice 3 use Tone Generator 3 On/Off
;        3 - Voice 1 use Noise Generator On/Off
;        4 - Voice 2 use Noise Generator On/Off
;        5 - Voice 3 use Noise Generator On/Off
;        6-7 - unused
; MASK aliases for PSG_OnOff register only uses bits 0-5
; use IMMEDIATE or with OR | operators,opcodes
Ch1_Tone_On         =        %10000000 
Ch2_Tone_On         =        %01000000 
Ch3_Tone_On         =        %00100000 
Ch1_Noise_On        =        %00010000 
Ch2_Noise_On        =        %00001000 
Ch3_Noise_On        =        %00000100 
; use IMMEDIATE or with AND & operators,opcodes
Ch1_Tone_Off        =        %01111100 
Ch2_Tone_Off        =        %10111100 
Ch3_Tone_Off        =        %11011000 
Ch1_Noise_Off       =        %11101100 
Ch2_Noise_Off       =        %11110100 
Ch3_Noise_Off       =        %11111000 
; use IMMEDIATE or with OR | operators,opcodes
Ch_All_Tone_On      =        %11100000 
Ch_All_Noise_On     =        %00011100 
; use IMMEDIATE with AND & operators,opcodes 
Ch_All_Tone_Off     =        %00011100 
Ch_All_Noise_Off    =        %11100000 
; use IMMEDIATE  
Ch_All_Off          =        %00000000 
; use IMMEDIATE
Ch_All_On           =        %11111100 
