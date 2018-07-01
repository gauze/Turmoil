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
PSG_OnOff           =        7 
PSG_Ch1_Vol         =        8 
PSG_Ch2_Vol         =        9 
PSG_Ch3_Vol         =        10 
;        0 - Voice 1 use Tone Generator 1 On/Off
;        1 - Voice 2 use Tone Generator 2 On/Off
;        2 - Voice 3 use Tone Generator 3 On/Off
;        3 - Voice 1 use Noise Generator On/Off
;        4 - Voice 2 use Noise Generator On/Off
;        5 - Voice 3 use Noise Generator On/Off
; MASK aliases for PSG_OnOff register
Ch1_Tone_On         =        %00000001 
Ch2_Tone_On         =        %00000010 
Ch3_Tone_On         =        %00000100 
Ch1_Noise_On        =        %00001000 
Ch2_Noise_On        =        %00010000 
Ch3_Noise_On        =        %00100000 
Ch_All_Tone_On      =        %00000111 
Ch_All_Noise_On     =        %00111000 
Ch_All_Tone_Off     =        %00000000 
Ch_All_Noise_Off    =        %00000000 
; for 2 channels OR | together
; ex: lda   #Ch1_Tone_On | Ch3_Tone_On 
; Sound effects 
; ALL
MUTE                =        0 
; ch 1
UFO                 =        1 
UFOFAST             =        2 
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
;                                                        
;===========
SfxInit: 
                    ldd      #0 
 
                    sta      tempB5 
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
                    cmpa     #3 
                    lbeq     Do_Sound_FX_C1Missile 
                    cmpa     #2 
                    lbeq     Do_Sound_FX_C1UFO 
                    cmpa     #1 
                    lbeq     Do_Sound_FX_C1UFO 
                    cmpa     #0 
                    blt      Do_Sound_FX_C1Mute 
; ??? does this drop through on
; something other than 0-3 ??? nope mask %011 in another section
Do_Sound_FX_C1_0: 
                                                          ;low rumble 
                    ldd      #4095 
                    std      tempW1 
                                                          ;set pitch ch1 
                    lda      #PSG_Ch1_Freq_Lo             ; fine pitch register ch1 #40 
                    ldb      tempW1+1 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch1_Freq_Hi             ; coarse pitch register ch1 #95 
                    ldb      tempW1 
                    jsr      Sound_Byte_raw 
                                                          ;set vol ch1 
                    lda      #PSG_Ch1_Vol 
                    ldb      #12 
                    jsr      Sound_Byte_raw 
                    rts      

;========
Do_Sound_FX_C1Mute: 
                                                          ;set vol ch1 
                    lda      #PSG_Ch1_Vol                 ; ch1 
                    ldb      #0 
                    jsr      Sound_Byte_raw 
                    rts      

;====================
Do_Sound_FX_C1Missile: 
                                                          ;missile 
                    ldd      #1600 
                    std      tempW1 
                                                          ;set pitch ch1 
                    lda      #PSG_Ch1_Freq_Lo             ; ch1 fine #16 
                    ldb      tempW1+1 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch1_Freq_Hi             ;ch1 rough #0 
                    ldb      tempW1 
                    jsr      Sound_Byte_raw 
                                                          ;set vol ch1 
                    lda      #PSG_Ch1_Vol                 ;ch1 
                    ldb      #12 
                    jsr      Sound_Byte_raw 
                    rts      

;===================
Do_Sound_FX_C1UFO: 
                                                          ;get lfo val 
                    ldx      #tblLFO                      ; low freq oscillation 
                    lda      sfx_FC 
                    anda     #%00000111                   ; mask so values is 0-7 
                    ldb      #2                           ; times 2 
                    mul                                   ; double A stored in D 
                    abx                                   ; X=X+B | B == 0-14 
                    ldd      ,x                           ; value in x stored to D 
                    std      sfxC1W1                      ; ch1 w? 
                    lda      sfxC1ID 
                    cmpa     #2 
                    beq      Do_Sound_FX_C1UFOFast 
Do_Sound_FX_C1UFOSlow: 
                                                          ;pitch 
                    ldd      #250 
                    subd     sfxC1W1 
                    std      tempW1 
                    bra      Do_Sound_FX_C1UFO0 

Do_Sound_FX_C1UFOFast: 
                                                          ;pitch 
                    ldd      #125 
                    subd     sfxC1W1 
                    std      tempW1 
                                                          ;fast 
                    inc      sfx_FC 
Do_Sound_FX_C1UFO0: 
                                                          ;set pitch ch1 
                    lda      #PSG_Ch1_Freq_Lo 
                    ldb      tempW1+1 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch1_Freq_Hi 
                    ldb      tempW1 
                    jsr      Sound_Byte_raw 
                                                          ;set vol ch1 
                    lda      #PSG_Ch1_Vol 
                    ldb      #10 
                    jsr      Sound_Byte_raw 
                                                          ;inc fc 
                    inc      sfx_FC 
                    rts      

;=Channel 2 effects check =======
Do_Sound_FX_C2: 
                                                          ;ch2 sfx? 
                    lda      sfxC2ID 
                    cmpa     #1 
                    beq      Do_Sound_FX_C2Blip 
                    lbgt     Do_Sound_FX_C2Enemy 
                                                          ;ch1 sfx? 
                    lda      sfxC1ID 
                    cmpa     #MISSILE 
                    lbeq     Do_Sound_FX_C2Missile 
                    cmpa     #UFOFAST 
                    lbeq     Do_Sound_FX_C2UFO 
                    cmpa     #UFO 
                    lbeq     Do_Sound_FX_C2UFO 
                    cmpa     #MUTE 
                    blt      Do_Sound_FX_C2Mute 
                    ldd      #0 
                    std      tempW2 
                                                          ;joystick val above 0? 
                    lda      Vec_Joy_1_Y 
                    cmpa     #0 
                    ble      Do_Sound_FX_C2_0 
                                                          ;get joystick val 
                    lda      Vec_Joy_1_Y 
                    ldb      #8 
                    mul      
                    std      tempW2 
Do_Sound_FX_C2_0: 
                                                          ;detune ch2 
                    ldd      #3583 
                    subd     tempW2 
                    std      tempW1 
                                                          ;set pitch ch2 
                    lda      #PSG_Ch2_Freq_Lo 
                    ldb      tempW1+1 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch2_Freq_Hi 
                    ldb      tempW1 
                    jsr      Sound_Byte_raw 
                                                          ;set vol ch2 
                    lda      #PSG_Ch2_Vol 
                    ldb      #12 
                    jsr      Sound_Byte_raw 
                    rts      

;=========================
Do_Sound_FX_C2Mute: 
                                                          ;set vol ch2 
                    lda      #PSG_Ch2_Vol 
                    ldb      #0 
                    jsr      Sound_Byte_raw 
                    rts      

;========================
Do_Sound_FX_C2Blip: 
                    lda      sfxC2W1 
                    cmpa     #0 
                    bne      Do_Sound_FX_C2Blip0 
                                                          ;reset 
                    lda      #MUTE 
                    sta      sfxC2ID 
                    rts      

Do_Sound_FX_C2Blip0: 
                                                          ;pitch 
                    ldd      #126 
                    std      tempW1 
                                                          ;set pitch ch2 
                    lda      #PSG_Ch2_Freq_Lo 
                    ldb      tempW1+1 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch2_Freq_Hi 
                    ldb      tempW1 
                    jsr      Sound_Byte_raw 
                                                          ;set vol ch2 
                    lda      #PSG_Ch2_Vol 
                    ldb      #11 
                    jsr      Sound_Byte_raw 
                                                          ;dec counter 
                    dec      sfxC2W1 
                    rts      

;=======================
Do_Sound_FX_C2Enemy: 
                                                          ;get pitch mod from counter 
                    lda      #0 
                    ldb      sfxC2W1+1 
                    andb     #%00111111                   ; 0-63 
                    std      tempW2 
                    cmpb     #56 
                    bne      Do_Sound_FX_C2Enemy0 
                    dec      sfxC2ID 
                    lda      sfxC2ID 
                    cmpa     #ENEMY 
                    bne      Do_Sound_FX_C2Enemy0 
                                                          ;off 
                    lda      #0 
                    sta      sfxC2ID 
                    rts      

Do_Sound_FX_C2Enemy0: 
                                                          ;inc mod 
                    lda      sfxC2W1+1 
                    adda     #8 
                    sta      sfxC2W1+1 
                    lda      sfxC2ID 
                    cmpa     #ENEMY 
                    bgt      Do_Sound_FX_C2EnemyHS 
                                                          ;pitch 
                    ldd      #200 
                    bra      Do_Sound_FX_C2Enemy1 

Do_Sound_FX_C2EnemyHS: 
                                                          ;pitch 
                    ldb      #20 
                    mul      
Do_Sound_FX_C2Enemy1: 
                    subd     tempW2 
                    std      tempW1 
                                                          ;set pitch ch2 
                    lda      #PSG_Ch2_Freq_Lo 
                    ldb      tempW1+1 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch2_Freq_Hi 
                    ldb      tempW1 
                    jsr      Sound_Byte_raw 
                                                          ;set vol ch2 
                    lda      #PSG_Ch2_Vol 
                    ldb      #14 
                    jsr      Sound_Byte_raw 
                    rts      

;======================
Do_Sound_FX_C2Missile: 
                                                          ;missile 
                    ldd      #1592 
                    std      tempW1 
                                                          ;set pitch ch2 
                    lda      #PSG_Ch2_Freq_Lo 
                    ldb      tempW1+1 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch2_Freq_Hi 
                    ldb      tempW1 
                    jsr      Sound_Byte_raw 
                                                          ;set vol ch2 
                    lda      #PSG_Ch2_Vol 
                    ldb      #12 
                    jsr      Sound_Byte_raw 
                    rts      

;=====================
Do_Sound_FX_C2UFO: 
                    lda      sfxC1ID 
                    cmpa     #UFOFAST 
                    beq      Do_Sound_FX_C2UFOFast 
Do_Sound_FX_C2UFOSlow: 
                                                          ;pitch 
                    ldd      #242 
                    subd     sfxC1W1 
                    std      tempW1 
                    bra      Do_Sound_FX_C2UFO0 

Do_Sound_FX_C2UFOFast: 
                                                          ;pitch 
                    ldd      #117 
                    subd     sfxC1W1 
                    std      tempW1 
Do_Sound_FX_C2UFO0: 
                                                          ;set pitch ch2 
                    lda      #PSG_Ch2_Freq_Lo 
                    ldb      tempW1+1 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch2_Freq_Hi 
                    ldb      tempW1 
                    jsr      Sound_Byte_raw 
                                                          ;set vol ch2 
                    lda      #PSG_Ch2_Vol 
                    ldb      #10 
                    jsr      Sound_Byte_raw 
                    rts      

;=Channel 3 FX ======
Do_Sound_FX_C3: 
                                                          ;channel 3 sfx 
                    lda      sfxC3ID 
                    cmpa     #2 
                    lbeq     Do_Sound_FX_C3Explosion 
                    cmpa     #10 
                    beq      Do_Sound_FX_C3Shot 
                                                          ;cmpa #1 
                                                          ;beq Do_Sound_FX_C3Blip 
                    cmpa     #3 
                    beq      Do_Sound_FX_C3Boing 
Do_Sound_FX_C3Mute: 
                                                          ;set vol ch3 
                    lda      #PSG_Ch3_Vol 
                    ldb      #0 
                    jsr      Sound_Byte_raw 
                    rts      

;===================
Do_Sound_FX_C3Boing: 
                    lda      sfxC3W1 
                    cmpa     #0 
                    beq      Do_Sound_FX_C3SoundOff 
                                                          ;set mixer 
                    lda      #PSG_OnOff 
;          ldb      #%00111000 
                    ldb      #Ch_All_Noise_On 
                    jsr      Sound_Byte_raw 
                    ldd      #2000 
                    std      tempW1 
                                                          ;set pitch ch3 
                    lda      #PSG_Ch3_Freq_Lo 
                    ldb      tempW1+1 
                    jsr      Sound_Byte_raw 
                    lda      #PSG_Ch3_Freq_Hi 
                    ldb      tempW1 
                    jsr      Sound_Byte_raw 
                                                          ;set vol ch3 
                    lda      #PSG_Ch3_Vol 
                    ldb      sfxC3W1 
                    jsr      Sound_Byte_raw 
                    dec      sfxC3W1 
                    rts      

;==================
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
                    ldb      #Ch3_Tone_On | Ch1_Noise_On | Ch2_Noise_On 
                    jsr      Sound_Byte_raw 
                                                          ;set noise pitch 
                    lda      #PSG_Noise 
                    ldb      #31 
                    jsr      Sound_Byte_raw 
                                                          ;set vol ch3 
                    lda      #PSG_Ch3_Vol 
                    ldb      sfxC3W1 
                    jsr      Sound_Byte_raw 
                                                          ;decay 
                    dec      sfxC3W1 
                    rts      

;================
Do_Sound_FX_C3Explosion: 
                    lda      sfxC3W1 
                    cmpa     #MUTE 
                    beq      Do_Sound_FX_C3SoundOff 
                                                          ;set mixer byte 
                    lda      #PSG_OnOff 
                                                          ;ldb #%00011100 
                    ldb      #Ch3_Tone_On | Ch1_Noise_On | Ch2_Noise_On 
                    jsr      Sound_Byte_raw 
                                                          ;set noise pitch 
                    lda      #PSG_Noise 
                    ldb      #31 
                    subb     sfxC3W1 
                    jsr      Sound_Byte_raw 
                                                          ;set vol ch3 
                    lda      #PSG_Ch3_Vol 
                    ldb      sfxC3W1 
                    jsr      Sound_Byte_raw 
                                                          ;decay 
                    ldd      sfxC3W1 
                    subd     #50 
                    std      sfxC3W1 
                    rts      

; SFX FUNCTIONS - CALL THESE TO START SFX
bzSFX_EngineOn: 
                    lda      #MUTE 
                    sta      sfxC1ID 
                    rts      

bzSFX_EngineOff: 
                    lda      #-1 
                    sta      sfxC1ID 
                    rts      

bzSFX_UFO: 
                                                          ;reset lfo counter 
                    lda      #0 
                    sta      sfx_FC 
                    lda      #UFO 
                    sta      sfxC1ID 
                    rts      

bzSFX_UFODead: 
                                                          ;reset lfo counter 
                    lda      #0 
                    sta      sfx_FC 
                    lda      #UFOFAST 
                    sta      sfxC1ID 
                    rts      

bzSFX_Missile: 
                    lda      #MISSILE 
                    sta      sfxC1ID 
                    rts      

bzSFX_Boing: 
                                                          ;boing 
                    lda      #BOING 
                    sta      sfxC3ID 
                                                          ;set vol 
                    lda      #15 
                    sta      sfxC3W1 
                    rts      

bzSFX_Blip: 
                                                          ;start blip 
                    lda      #BLIP 
                    sta      sfxC2ID 
                                                          ;set counter 
                    lda      #2 
                    sta      sfxC2W1 
                    rts      

bzSFX_Enemy: 
                                                          ;enemy appeared! 
                    lda      #ENEMY 
                    sta      sfxC2ID 
                                                          ;reset counter 
                    lda      #0 
                    sta      sfxC2W1+1 
                    rts      

bzSFX_HighScore: 
                                                          ;high score 
                    lda      #HIGHSCORE 
                    sta      sfxC2ID 
                                                          ;reset counter 
                    lda      #0 
                    sta      sfxC2W1+1 
                    rts      

bzSFX_Explosion: 
                                                          ;explosion 
                    lda      #EXPLOSION 
                    sta      sfxC3ID 
                                                          ;set vol 
                    lda      #15 
                    ldb      #0 
                    std      sfxC3W1 
                    rts      

bzSFX_Shot: 
                                                          ;shot 
                    lda      #SHOT 
                    sta      sfxC3ID 
                                                          ;set vol 
                    lda      #15 
                    sta      sfxC3W1 
                    rts      

main_end: 
;*******************************
;* DATA SECTION ***************
;*****************************
; table of UFO sound frequency, cyclical
; "low frequency oscillation"
tblLFO: 
                    dw       64 
                    dw       45 
                    dw       0 
                    dw       -45 
                    dw       -64 
                    dw       -45 
                    dw       0 
                    dw       45 
