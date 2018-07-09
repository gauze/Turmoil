; vim: ts=4
; vim: syntax=asm6809
                    include  "sound-shot.i"
                    include  "sound-ghost-spawn.i"
; Sound Registers 
PSG_Ch1_Freq_Lo     =        0 
PSG_Ch1_Freq_Hi     =        1 
PSG_Ch2_Freq_Lo     =        2 
PSG_Ch2_Freq_Hi     =        3 
PSG_Ch3_Freq_Lo     =        4 
PSG_Ch3_Freq_Hi     =        5 
PSG_Noise           =        6 
PSG_OnOff           =        7 
PSG_Ch1_Vol         =        8 
PSG_Ch2_Vol         =        9 
PSG_Ch3_Vol         =        10 
PSG_Env_Period      =        11             ; used for D reg transfer
PSG_Env_Period_Fine  =       11 
PSG_Env_Period_Coarse  =     12 
PSG_Env_Shape       =        13 			; only used when register 8-10 == %1xxxx 
PSG_Data_A          =        14				

Use_Env             =        %10000                       ; set bit 5 of Vol regs to use env 
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
; ex: lda   #Ch1_Tone_On | Ch3_Tone_On 
; Sound effects 
; ALL
MUTE                =        0 
; ch 1
GHOST_SPAWN         =        1 
CB_BOUNCE           =        2 
MISSILE             =        3 
;ch 2
BLIP                =        1 
ENEMY               =        4 
HIGHSCORE           =        7 
;ch 3
EXPLOSION           =        2 
BOING               =        3 
SHOT                =        10 
; add to main 
;                    jsr      Do_Sound_FX_C1 
;                    jsr      Do_Sound_FX_C2 
;                    jsr      Do_Sound_FX_C3 
;  Sound_Byte_raw
;   A-reg = which of the 15 sound chip registers to modify
;   B-reg = the byte of sound data     
;   X-reg = 15 byte shadow area (Sound_Byte_x only)
; Registers:  
; 0 = freq ch1 (lower 8 bits)
; 1 = freq ch1 (top 4 bits)
; 2-3 = freq ch2
; 4-5 = freq ch3
; 6 = noise generator freq (shared)
; 7 = on/off per channel (bits)
;        0 - Voice 1 use Tone Generator 1 On/Off
;        1 - Voice 2 use Tone Generator 2 On/Off
;        2 - Voice 3 use Tone Generator 3 On/Off
;        3 - Voice 1 use Noise Generator On/Off
;        4 - Voice 2 use Noise Generator On/Off
;        5 - Voice 3 use Noise Generator On/Off
;       6-7 Unused
; 8 = volume ch1 (LOWER 4 bits, 0-15)
; 9 = volume ch2 "
; 10 = volume ch3    
; 11 = envelope coarse ??
; 12 = envelope rough ?
; 13 = Envelope shape (lower 4 bits)
;          0 - continue
;          1 - attack
;          2  - Alternate
;          3  - hold 
; 14,15 latches ??
;                                                        
;===========
SfxInit: 
                    ldd      #0 
;                    sta      tempB5 
                    sta      sfxC1ID 
                    sta      sfxC2ID 
                    sta      sfxC3ID 
                    std      tempW1 
                    std      tempW2 
                    std      sfx_FC 
                    std      sfxC1W1 
                    std      sfxC2W1 
                    std      sfxC3W1 
                                                          ;set mixer 
                    lda      #PSG_OnOff 
                                                          ; ldb #Ch3_Tone_On | Ch1_Noise_On | Ch2_Noise_On 
                    ldb      #Ch_All_Noise_Off 
                    jsr      Sound_Byte_raw 
                                                          ;set vol 
                    lda      #PSG_Ch1_Vol 
                    ldb      #0 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch2_Vol 
                    ldb      #0 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch3_Vol 
                    ldb      #0 
                    jsr      Sound_Byte_raw 
                    rts      

;=========
Do_Sound_FX_C1: 
;sound effect? checks "ID" value to decide sound effect 
                    lda      sfxC1ID 
                                                          ; cmpa #3 
                                                          ; lbeq Do_Sound_FX_C1Missile 
                    cmpa     #2 
                    lbeq     Do_Sound_FX_C1CB_Bounce 
                    cmpa     #1 
                    lbeq     Do_Sound_FX_C1Ghost_Spawn 
                    cmpa     #0 
                    blt      Do_Sound_FX_C1SoundOff 
; ??? does this drop through on
; something other than 0-3 ??? nope mask %011 in another section
                    rts      

;========
Do_Sound_FX_C1Mute: 
Do_Sound_FX_C1SoundOff: 
                                                          ;set vol ch1 
                    lda      #PSG_Ch1_Vol                 ; ch1 
                    ldb      #0 
                    jsr      Sound_Byte_raw 
                    clr      sfxC1ID 
                    rts      

;===================
Do_Sound_FX_C1Ghost_Spawn: 
                    lda      sfxC1W1 
                    cmpa     #0 
                    beq      Do_Sound_FX_C1SoundOff 
                                                          ;set mixer byte 
                    lda      #PSG_OnOff 
                    ldb      #Ch1_Tone_On 
                    jsr      Sound_Byte_raw 
                    ldx      #Ghost_Spawn_Freq 
                    lda      sfxC1W1 
                    lsla                                  ; 2 bytes 
                    ldd      a,x 
                    std      tempW1 
                                                          ;set pitch ch1 
                    lda      #PSG_Ch1_Freq_Lo 
                    ldb      tempW1+1 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch1_Freq_Hi 
                    ldb      tempW1 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch1_Vol 
                    ldb      #13 
                    jsr      Sound_Byte_raw 
                    dec      sfxC1W1 
                    rts      

Do_Sound_FX_C1CB_Bounce: 
                    lda      sfxC1W1 
                    cmpa     #0 
                    beq      Do_Sound_FX_C1SoundOff 
                                                          ;set mixer byte 
                    lda      #PSG_OnOff 
                    ldb      #Ch1_Tone_On | #Ch1_Noise_On ; #$90 
                    jsr      Sound_Byte_raw 
                    ldx      #CB_Bounce_Freq 
                    lda      sfxC1W1 
                    lsla                                  ; 2 bytes 
                    ldd      a,x 
                    std      tempW1 
                    lda      #PSG_Ch1_Freq_Lo 
                    ldb      tempW1+1 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch1_Freq_Hi 
                    ldb      tempW1 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch1_Vol 
                    ldb      #Use_Env 
                    jsr      Sound_Byte_raw 
                    lda      #13                          ;; env ?? 
                    ldb      #%1010 
                    jsr      Sound_Byte_raw 
                                                          ; lda #13 
                                                          ; ldb #%1010 
                                                          ; jsr Sound_Byte_raw 
                                                          ; dec sfxC1W1 
                    rts      

;=Channel 2 effects check =======
Do_Sound_FX_C2: 
                                                          ;ch2 sfx? 
                    lda      sfxC2ID 
                    cmpa     #1 
                                                          ; beq Do_Sound_FX_C2Blip 
                                                          ; lbgt Do_Sound_FX_C2Enemy 
                                                          ;ch1 sfx? 
                    lda      sfxC2ID 
                                                          ; cmpa #MISSILE 
                                                          ; lbeq Do_Sound_FX_C2Missile 
                                                          ; cmpa #UFOFAST 
                                                          ; lbeq Do_Sound_FX_C2UFO 
                                                          ; cmpa #UFO 
                                                          ; lbeq Do_Sound_FX_C2UFO 
                    cmpa     #MUTE 
                    blt      Do_Sound_FX_C2Mute 
                    ldd      #0 
                    std      tempW2 
;=========================
Do_Sound_FX_C2Mute: 
                                                          ;set vol ch2 
                    lda      #PSG_Ch2_Vol 
                    ldb      #0 
                    jsr      Sound_Byte_raw 
                    rts      

;=Channel 3 FX ======
Do_Sound_FX_C3: 
                                                          ;channel 3 sfx 
                    lda      sfxC3ID 
                    cmpa     #2 
                                                          ; lbeq Do_Sound_FX_C3Explosion 
                    cmpa     #10 
                    beq      Do_Sound_FX_C3Shot 
; silence functions                                        
Do_Sound_FX_C3Mute: 
                                                          ;set vol ch3 
                    lda      #PSG_Ch3_Vol 
                    ldb      #0 
                    jsr      Sound_Byte_raw 
                    rts      

Do_Sound_FX_C1SoundOff: 
                                                          ;nothing playing 
                    lda      #PSG_Ch1_Vol 
                    ldb      #0 
                    jsr      Sound_Byte_raw 
                    lda      #0 
                    sta      sfxC1ID 
                    jsr      Clear_Sound 
                    rts      

Do_Sound_FX_C2SoundOff: 
                                                          ;nothing playing 
                    lda      #PSG_Ch2_Vol 
                    ldb      #0 
                    jsr      Sound_Byte_raw 
                    lda      #0 
                    sta      sfxC2ID 
                    jsr      Clear_Sound 
                    rts      

Do_Sound_FX_C3SoundOff: 
                                                          ;nothing playing 
                    lda      #0 
                    sta      sfxC3ID 
                    rts      

;=================
Do_Sound_FX_C3Shot: 
                    lda      sfxC3W1 
                    cmpa     #0 
                    beq      Do_Sound_FX_C3SoundOff 
                                                          ;set mixer byte 
                    lda      #PSG_OnOff 
                    ldb      #Ch3_Tone_On                 ;| Ch1_Noise_On | Ch2_Noise_On 
                                                          ; ldb #Ch_All_On 
                    jsr      Sound_Byte_raw 
                    ldx      #Shot_Freq 
                    lda      sfxC3W1 
                    lsla                                  ; 2 bytes 
                    ldd      a,x 
                    std      tempW1 
                                                          ;set pitch ch3 
                    lda      #PSG_Ch3_Freq_Lo 
                    ldb      tempW1+1 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch3_Freq_Hi 
                    ldb      tempW1 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch3_Vol 
                    ldb      #13 
                    jsr      Sound_Byte_raw 
                    dec      sfxC3W1 
                    rts      

; SFX FUNCTIONS - CALL THESE TO START SFX        
SFX_Shot: 
                    lda      #SHOT 
                    sta      sfxC3ID 
                    ldx      #Shot_Freq                   ; table with Freq sweep data 
                    lda      0,x                          ; length 
                    sta      sfxC3W1 
                    rts      

SFX_Ghost_Spawn: 
                    lda      #GHOST_SPAWN 
                    sta      sfxC1ID 
                    lda      #33 
                    sta      sfxC1W1 
                    rts      

SFX_CB_Bounce: 
                    lda      #CB_BOUNCE 
                    sta      sfxC1ID 
                    lda      #4 
                    sta      sfxC1W1 
                    rts      
