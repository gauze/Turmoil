;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; vim: ts=4
; vim: syntax=asm6809
; MACROS
DRAW_ENEMYS         macro      
; *_D -> index 0|1 (0=Left, 1=Right)
                    RESET0REF
                    lda      alley0e
                    beq      skip0a
                    ldx      #enemy_t 
                    lda      alley0e 
                    lsla     
                    ldx      a,x                          ; sets *_D 
                    lda      alley0d 
                    lsla     
                    ldx      a,x                          ; gets *_t 
                    pshs     x                            ; store it 
                    ldx      #bulletYpos_t 
                    lda      #0 
                    lda      a,x                          ; Y 
                    ldb      alley0x                      ; X 
                    MOVETO_D
; *_f  frame count -> index list of frames, see definition in data.i 
                    lda      alley0e 
                    lsla     
                    ldx      #enemyframe_t 
                    ldx      a,x 
                    lda      ,x                           ; A = *_f var 
                    lsla     
                    puls     x                            ; pull X back 
                    ldx      a,x 
                    jsr      Draw_VL_mode
skip0a 
;################################################################################################
                    RESET0REF
                    lda      alley1e
                    beq      skip1a
                    ldx      #enemy_t 
                    lda      alley1e 
                    lsla     
                    ldx      a,x                          ; sets *_D 
                    lda      alley1d 
                    lsla     
                    ldx      a,x                          ; gets *_t 
                    pshs     x                            ; store it 
                    ldx      #bulletYpos_t 
                    lda      #1 
                    lda      a,x                          ; Y 
                    ldb      alley1x                      ; X 
                    MOVETO_D
; *_f  frame count -> index list of frames, see definition in data.i 
                    lda      alley1e 
                    lsla     
                    ldx      #enemyframe_t 
                    ldx      a,x 
                    lda      ,x                           ; A = *_f var 
                    lsla     
                    puls     x                            ; pull X back 
                    ldx      a,x 
                    jsr      Draw_VL_mode
skip1a
;###########################################################################
                    RESET0REF
                    lda      alley2e
                    beq      skip2a
                    ldx      #enemy_t 
                    lda      alley2e 
                    lsla     
                    ldx      a,x                          ; sets *_D 
                    lda      alley2d 
                    lsla     
                    ldx      a,x                          ; gets *_t 
                    pshs     x                            ; store it 
                    ldx      #bulletYpos_t 
                    lda      #2 
                    lda      a,x                          ; Y 
                    ldb      alley2x                      ; X 
                    MOVETO_D
; *_f  frame count -> index list of frames, see definition in data.i 
                    lda      alley2e 
                    lsla     
                    ldx      #enemyframe_t 
                    ldx      a,x 
                    lda      ,x                           ; A = *_f var 
                    lsla     
                    puls     x                            ; pull X back 
                    ldx      a,x 
                    jsr      Draw_VL_mode
skip2a
;###########################################################################
                    RESET0REF
                    lda      alley3e
                    beq      skip3a
                    ldx      #enemy_t 
                    lda      alley3e 
                    lsla     
                    ldx      a,x                          ; sets *_D 
                    lda      alley3d 
                    lsla     
                    ldx      a,x                          ; gets *_t 
                    pshs     x                            ; store it 
                    ldx      #bulletYpos_t 
                    lda      #3 
                    lda      a,x                          ; Y 
                    ldb      alley3x                      ; X 
                    MOVETO_D
; *_f  frame count -> index list of frames, see definition in data.i 
                    lda      alley3e 
                    lsla     
                    ldx      #enemyframe_t 
                    ldx      a,x 
                    lda      ,x                           ; A = *_f var 
                    lsla     
                    puls     x                            ; pull X back 
                    ldx      a,x 
                    jsr      Draw_VL_mode
skip3a
;###########################################################################
                    RESET0REF
                    lda      alley4e
                    beq      skip4a
                    ldx      #enemy_t 
                    lda      alley4e 
                    lsla     
                    ldx      a,x                          ; sets *_D 
                    lda      alley4d 
                    lsla     
                    ldx      a,x                          ; gets *_t 
                    pshs     x                            ; store it 
                    ldx      #bulletYpos_t 
                    lda      #4 
                    lda      a,x                          ; Y 
                    ldb      alley4x                      ; X 
                    MOVETO_D
; *_f  frame count -> index list of frames, see definition in data.i 
                    lda      alley4e 
                    lsla     
                    ldx      #enemyframe_t 
                    ldx      a,x 
                    lda      ,x                           ; A = *_f var 
                    lsla     
                    puls     x                            ; pull X back 
                    ldx      a,x 
                    jsr      Draw_VL_mode
skip4a
;###########################################################################
                    RESET0REF
                    lda      alley5e
                    beq      skip5a
                    ldx      #enemy_t 
                    lda      alley5e 
                    lsla     
                    ldx      a,x                          ; sets *_D 
                    lda      alley5d 
                    lsla     
                    ldx      a,x                          ; gets *_t 
                    pshs     x                            ; store it 
                    ldx      #bulletYpos_t 
                    lda      #5 
                    lda      a,x                          ; Y 
                    ldb      alley5x                      ; X 
                    MOVETO_D
; *_f  frame count -> index list of frames, see definition in data.i 
                    lda      alley5e 
                    lsla     
                    ldx      #enemyframe_t 
                    ldx      a,x 
                    lda      ,x                           ; A = *_f var 
                    lsla     
                    puls     x                            ; pull X back 
                    ldx      a,x 
                    jsr      Draw_VL_mode
skip5a
;###########################################################################
                    RESET0REF
                    lda      alley6e
                    beq      skip6a
                    ldx      #enemy_t 
                    lda      alley6e 
                    lsla     
                    ldx      a,x                          ; sets *_D 
                    lda      alley6d 
                    lsla     
                    ldx      a,x                          ; gets *_t 
                    pshs     x                            ; store it 
                    ldx      #bulletYpos_t 
                    lda      #6 
                    lda      a,x                          ; Y 
                    ldb      alley6x                      ; X 
                    MOVETO_D
; *_f  frame count -> index list of frames, see definition in data.i 
                    lda      alley6e 
                    lsla     
                    ldx      #enemyframe_t 
                    ldx      a,x 
                    lda      ,x                           ; A = *_f var 
                    lsla     
                    puls     x                            ; pull X back 
                    ldx      a,x 
                    jsr      Draw_VL_mode
skip6a
;###########################################################################
                    endm     
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
MOVE_ENEMYS         macro    
; move enemies0
                    lda      alley0x 
                    ldb      alley0d 
                    bne      add0 
                    suba     alley0s 
                    bra      subdone0 

add0 
                    adda     alley0s 
subdone0 
                    sta      alley0x 
; move enemies1
                    lda      alley1x 
                    ldb      alley1d 
                    bne      add1 
                    suba     alley1s 
                    bra      subdone1 

add1 
                    adda     alley1s 
subdone1 
                    sta      alley1x 
; move enemies2
                    lda      alley2x 
                    ldb      alley2d 
                    bne      add2 
                    suba     alley2s 
                    bra      subdone2 

add2 
                    adda     alley2s 
subdone2 
                    sta      alley2x 
; move enemies3
                    lda      alley3x 
                    ldb      alley3d 
                    bne      add3 
                    suba     alley3s 
                    bra      subdone3 

add3 
                    adda     alley3s 
subdone3 
                    sta      alley3x 
; move enemies4
                    lda      alley4x 
                    ldb      alley4d 
                    bne      add4 
                    suba     alley4s 
                    bra      subdone4 

add4 
                    adda     alley4s 
subdone4 
                    sta      alley4x 
; move enemies5
                    lda      alley5x 
                    ldb      alley5d 
                    bne      add5 
                    suba     alley5s 
                    bra      subdone5 

add5 
                    adda     alley5s 
subdone5 
                    sta      alley5x 
; move enemies6
                    lda      alley6x 
                    ldb      alley6d 
                    bne      add6 
                    suba     alley6s 
                    bra      subdone6 

add6 
                    adda     alley6s 
subdone6 
                    sta      alley6x 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
SHIP_COLLISION_DETECT  macro  
                                                          ; bra skipme 
                    lda      shippos 
                    lsla     
                    ldx      #alleye_t 
                    ldx      a,x 
                    lda      ,x 
                    beq      no_hit 
                    lda      shippos 
                    lsla     
                    ldx      #alleyx_t 
                    ldx      a,x 
                    ldb      ,x 
                    jsr      Abs_b 
                    cmpb     #10 
                    bgt      no_hit 
                    dec      shipcnt                      ; lose one ship 
                    lda      shippos                      ; clear e exist flag for this alley, ie destroy it 
                    lsla     
                    ldx      #alleye_t 
                    ldx      a,x 
                    clra     
                    sta      ,x 
;skipme
no_hit 
                    endm     
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  
SHOT_COLLISION_DETECT  macro  
; save next 32 lines for now JUST IN CASE
;                    lda      bullet0e 
;                    beq      bullet0_done 
;                    lda      bullet0d 
;                    beq      bullet0d_l 
;                    ldb      bullet0x                     ; test bullet going right 0-127 possible hit range 
;                    bmi      bullet0_miss                 ; bullet going wrong direction can't hit. 
;                    lda      alley0x 
;                    cmpa     bullet0x 
;                    ble      bullet0_miss 
;                    bra      bullhit0                     ; hit
;bullet0d_l 
;                    ldb      bullet0x                     ; test bullet going left (-127)-0 possible hit range 
;                    bpl      bullet0_miss                 ; bullet on wrong side can't hit 
;                    lda      alley0x 
;                    cmpa     bullet0x 
;                    bge      bullet0_miss 
; add to score then destroy bullet and enemy
;bullhit0
;                    ldx      #score 
;                    lda      alley0s 
;                    ldb      #SCORE 
;                    mul      
;                    jsr      Add_Score_d
;                    clra 
;                    sta      alley0e 
;                    sta      alley0x 
;                    sta      alley0d 
;                    sta      alley0s 
;                    sta      bullet0e 
;                   sta      bullet0x 
;                    sta      bullet0d 
;bullet0_done 
;bullet0_miss 
                    lda      bullet0e 
                    beq      bullet0_done 
                    lda      bullet0d 
                    beq      bullet0d_l 
                    ldb      bullet0x                     ; test bullet going right 0-127 possible hit range 
                    bmi      bullet0_miss                 ; bullet going wrong direction can't hit. 
                    lda      alley0x 
                    cmpa     bullet0x 
                    ble      bullet0_miss 
                    bra      bullhit0                     ; hit 

bullet0d_l 
                    ldb      bullet0x                     ; test bullet going left (-127)-0 possible hit range 
                    bpl      bullet0_miss                 ; bullet on wrong side can't hit 
                    lda      alley0x 
                    cmpa     bullet0x 
                    bge      bullet0_miss 
; add to score then destroy bullet and enemy
bullhit0 
                    ldx      #score 
                    lda      alley0s 
                    ldb      #SCORE 
                    mul      
                    jsr      Add_Score_d 
                    clra     
                    sta      alley0e 
                    sta      alley0x 
                    sta      alley0d 
                    sta      alley0s 
                    sta      bullet0e 
                    sta      bullet0x 
                    sta      bullet0d 
                    dec      enemycnt 
bullet0_done 
bullet0_miss 
                    lda      bullet1e 
                    beq      bullet1_done 
                    lda      bullet1d 
                    beq      bullet1d_l 
                    ldb      bullet1x                     ; test bullet going right 0-127 possible hit range 
                    bmi      bullet1_miss                 ; bullet going wrong direction can't hit. 
                    lda      alley1x 
                    cmpa     bullet1x 
                    ble      bullet1_miss 
                    bra      bullhit1                     ; hit 

bullet1d_l 
                    ldb      bullet1x                     ; test bullet going left (-127)-0 possible hit range 
                    bpl      bullet1_miss                 ; bullet on wrong side can't hit 
                    lda      alley1x 
                    cmpa     bullet1x 
                    bge      bullet1_miss 
; add to score then destroy bullet and enemy
bullhit1 
                    ldx      #score 
                    lda      alley1s 
                    ldb      #SCORE 
                    mul      
                    jsr      Add_Score_d 
                    clra     
                    sta      alley1e 
                    sta      alley1x 
                    sta      alley1d 
                    sta      alley1s 
                    sta      bullet1e 
                    sta      bullet1x 
                    sta      bullet1d 
                    dec      enemycnt 
bullet1_done 
bullet1_miss 
                    lda      bullet2e 
                    beq      bullet2_done 
                    lda      bullet2d 
                    beq      bullet2d_l 
                    ldb      bullet2x                     ; test bullet going right 0-127 possible hit range 
                    bmi      bullet2_miss                 ; bullet going wrong direction can't hit. 
                    lda      alley2x 
                    cmpa     bullet2x 
                    ble      bullet2_miss 
                    bra      bullhit2                     ; hit 

bullet2d_l 
                    ldb      bullet2x                     ; test bullet going left (-127)-0 possible hit range 
                    bpl      bullet2_miss                 ; bullet on wrong side can't hit 
                    lda      alley2x 
                    cmpa     bullet2x 
                    bge      bullet2_miss 
; add to score then destroy bullet and enemy
bullhit2 
                    ldx      #score 
                    lda      alley2s 
                    ldb      #SCORE 
                    mul      
                    jsr      Add_Score_d 
                    clra     
                    sta      alley2e 
                    sta      alley2x 
                    sta      alley2d 
                    sta      alley2s 
                    sta      bullet2e 
                    sta      bullet2x 
                    sta      bullet2d 
                    dec      enemycnt 
bullet2_done 
bullet2_miss 
                    lda      bullet3e 
                    beq      bullet3_done 
                    lda      bullet3d 
                    beq      bullet3d_l 
                    ldb      bullet3x                     ; test bullet going right 0-127 possible hit range 
                    bmi      bullet3_miss                 ; bullet going wrong direction can't hit. 
                    lda      alley3x 
                    cmpa     bullet3x 
                    ble      bullet3_miss 
                    bra      bullhit3                     ; hit 

bullet3d_l 
                    ldb      bullet3x                     ; test bullet going left (-127)-0 possible hit range 
                    bpl      bullet3_miss                 ; bullet on wrong side can't hit 
                    lda      alley3x 
                    cmpa     bullet3x 
                    bge      bullet3_miss 
; add to score then destroy bullet and enemy
bullhit3 
                    ldx      #score 
                    lda      alley3s 
                    ldb      #SCORE 
                    mul      
                    jsr      Add_Score_d 
                    clra     
                    sta      alley3e 
                    sta      alley3x 
                    sta      alley3d 
                    sta      alley3s 
                    sta      bullet3e 
                    sta      bullet3x 
                    sta      bullet3d 
                    dec      enemycnt 
bullet3_done 
bullet3_miss 
                    lda      bullet4e 
                    beq      bullet4_done 
                    lda      bullet4d 
                    beq      bullet4d_l 
                    ldb      bullet4x                     ; test bullet going right 0-127 possible hit range 
                    bmi      bullet4_miss                 ; bullet going wrong direction can't hit. 
                    lda      alley4x 
                    cmpa     bullet4x 
                    ble      bullet4_miss 
                    bra      bullhit4                     ; hit 

bullet4d_l 
                    ldb      bullet4x                     ; test bullet going left (-127)-0 possible hit range 
                    bpl      bullet4_miss                 ; bullet on wrong side can't hit 
                    lda      alley4x 
                    cmpa     bullet4x 
                    bge      bullet4_miss 
; add to score then destroy bullet and enemy
bullhit4 
                    ldx      #score 
                    lda      alley4s 
                    ldb      #SCORE 
                    mul      
                    jsr      Add_Score_d 
                    clra     
                    sta      alley4e 
                    sta      alley4x 
                    sta      alley4d 
                    sta      alley4s 
                    sta      bullet4e 
                    sta      bullet4x 
                    sta      bullet4d 
                    dec      enemycnt 
bullet4_done 
bullet4_miss 
                    lda      bullet5e 
                    beq      bullet5_done 
                    lda      bullet5d 
                    beq      bullet5d_l 
                    ldb      bullet5x                     ; test bullet going right 0-127 possible hit range 
                    bmi      bullet5_miss                 ; bullet going wrong direction can't hit. 
                    lda      alley5x 
                    cmpa     bullet5x 
                    ble      bullet5_miss 
                    bra      bullhit5                     ; hit 

bullet5d_l 
                    ldb      bullet5x                     ; test bullet going left (-127)-0 possible hit range 
                    bpl      bullet5_miss                 ; bullet on wrong side can't hit 
                    lda      alley5x 
                    cmpa     bullet5x 
                    bge      bullet5_miss 
; add to score then destroy bullet and enemy
bullhit5 
                    ldx      #score 
                    lda      alley5s 
                    ldb      #SCORE 
                    mul      
                    jsr      Add_Score_d 
                    clra     
                    sta      alley5e 
                    sta      alley5x 
                    sta      alley5d 
                    sta      alley5s 
                    sta      bullet5e 
                    sta      bullet5x 
                    sta      bullet5d 
                    dec      enemycnt 
bullet5_done 
bullet5_miss 
                    lda      bullet6e 
                    beq      bullet6_done 
                    lda      bullet6d 
                    beq      bullet6d_l 
                    ldb      bullet6x                     ; test bullet going right 0-127 possible hit range 
                    bmi      bullet6_miss                 ; bullet going wrong direction can't hit. 
                    lda      alley6x 
                    cmpa     bullet6x 
                    ble      bullet6_miss 
                    bra      bullhit6                     ; hit 

bullet6d_l 
                    ldb      bullet6x                     ; test bullet going left (-127)-0 possible hit range 
                    bpl      bullet6_miss                 ; bullet on wrong side can't hit 
                    lda      alley6x 
                    cmpa     bullet6x 
                    bge      bullet6_miss 
; add to score then destroy bullet and enemy
bullhit6 
                    ldx      #score 
                    lda      alley6s 
                    ldb      #SCORE 
                    mul      
                    jsr      Add_Score_d 
                    clra     
                    sta      alley6e 
                    sta      alley6x 
                    sta      alley6d 
                    sta      alley6s 
                    sta      bullet6e 
                    sta      bullet6x 
                    sta      bullet6d 
                    dec      enemycnt 
bullet6_done 
bullet6_miss 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
READ_BUTTONS        macro    
                    jsr      Read_Btns 
                    lda      Vec_Button_1_2 
                    beq      toad 
                    lda      #1 
                    sta      Ship_Dead 
toad 
                    lda      Vec_Btn_State 
                    beq      no_press 
                                                          ; adding bullet to alley if no other bullet is already there 
                    lda      shippos 
                    asla     
                    ldx      #bullete_t 
                    ldx      a,x 
                    lda      ,x 
                    bne      already_exists 
                    ldb      #1 
                    stb      ,x                           ; set EXIST (int) 
; left(0) or right(1)?
                    lda      shippos 
                    asla     
                    ldx      #bulletd_t 
                    ldx      a,x 
                    ldb      shipdir 
                    stb      ,x                           ; set DIRECTION (bool) 
; starting x coordinates
                    lda      shippos 
                    asla     
                    ldx      #bulletx_t 
                    ldx      a,x 
                    ldb      shipdir 
                    beq      negstart 
                    ldb      #6 
                    stb      ,x                           ; set start X 
                    bra      newshotdone 

negstart 
                    ldb      #-9 
                    stb      ,x                           ; set start -X 
newshotdone 
no_press 
already_exists 
                    endm                                  ; rts 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NEW_ENEMY           macro    
; need code to generate new random enemy OR prize in random alley
; type, and direction, direction decides initial X placement
; store answer in alleyNe (value from enemy_t offset), (bool)alleyNd (0 left, 1 right), (signed int)alleyNx (-127 or 127 )
;
; don't even do spawn logic if maximum enemies are out 
                    lda      level 
                    ldx      #max_enemys_t 
                    lda      a,x 
                    cmpa     enemycnt 
                    lble      no_new_enemy 
; check spawn throttle count logic
; TODO
; spawn new enemy
randloop 
                    jsr      Random                       ; choose random alley, loop until found 
                    anda     #%00000111                   ; 0-7 if occupied or 7 try again 
                    cmpa     #7 
                    beq      randloop 
                    sta      spawntemp 
                    ldx      #alleye_t 
                    lsla     
                    ldx      a,x 
                    ldb      ,x 
                    bne      randloop 
; else fall through ACCA (a) holds valid alley index
                    lda      spawntemp 
                    lsla     
                    ldx      #alleye_t 
                    ldx      a,x                          ; ldx alleyNe 
                    jsr      Random 
                    sta      temp                         ; keep for later 
                    anda     #%00000011                   ; mask off top 5 bits to limit answer 0-3 
                    adda     #1                           ; and add 1, use with enemyspawn_t table 
                    lsla                                  ; and shift over for 2-byte table index 
                    sta      ,x                           ; set alleyNe enemy type 
                                                          ; figure out speed stuff here 
                    ldx      #max_speed_mask_t
                    lda      level
                    ldb      a,x
                    stb      masktemp
                    lda      temp 
                    anda     masktemp 
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    lsra                                  ; mask top 3 bits, shift til 3 bits 0-7 
                                                          ; clra ; TESTING setting speed to 1 for all 
                    adda     #1                           ; in case of zero result 
                    ldx      #alleys_t 
                    ldb      spawntemp 
                    lslb     
                    ldx      b,x                          ; ldx alleyNs 
                    sta      ,x 
                                                          ; initial direction which sets initial X pos 
                    lda      temp 
                    anda     #%00010000                   ; mask some other random bit to derive start direction 
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    ldx      #alleyd_t 
                    ldb      spawntemp 
                    lslb     
                    ldx      b,x                          ; ldx alleyNd 
                    sta      ,x 
                    beq      set_enemy_going_left 
                    lda      #-127 
                    ldx      #alleyx_t 
                    ldb      spawntemp 
                    lslb     
                    ldx      b,x 
                    sta      ,x 
                    bra      enemy_done 

set_enemy_going_left 
                    lda      #127 
                    ldx      #alleyx_t 
                    ldb      spawntemp 
                    lslb     
                    ldx      b,x 
                    sta      ,x 
enemy_done 
                    inc      enemycnt 
no_new_enemy 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RESET0REF           macro    
                    ldd      #$00CC 
                    stb      <VIA_cntl                    ;/BLANK low and /ZERO low 
                    sta      <VIA_shift_reg               ;clear shift register 
                    ldd      #$0302 
                    clr      <VIA_port_a                  ;clear D/A register 
                    sta      <VIA_port_b                  ;mux=1, disable mux 
                    stb      <VIA_port_b                  ;mux=1, enable mux 
                    stb      <VIA_port_b                  ;do it again 
                    ldb      #$01 
                    stb      <VIA_port_b                  ;disable mu 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOVETO_D            macro    
                    local    MLF318, MLF33B,MLF33D,MLF341,MLF345,moveto_d_done 
                    sta      <VIA_port_a                  ;Store Y in D/A register 
                    clr      <VIA_port_b                  ;Enable mux 
                    pshs     b,a                          ;Save D-register on stack 
MLF318:             lda      #$CE                         ;Blank low, zero high? 
                    sta      <VIA_cntl 
                    clr      <VIA_shift_reg               ;Clear shift regigster 
                    inc      <VIA_port_b                  ;Disable mux 
                    stb      <VIA_port_a                  ;Store X in D/A register 
                    clr      <VIA_t1_cnt_hi               ;timer 1 count high 
                    puls     a,b                          ;Get back D-reg 
                    jsr      Abs_a_b 
                    stb      -1,s 
                    ora      -1,s 
                    ldb      #$40 
                    cmpa     #$40 
                    bls      MLF345 
                    cmpa     #$64 
                    bls      MLF33B 
                    lda      #$08 
                    bra      MLF33D 

MLF33B:             lda      #$04                         ;Wait for timer 1 
MLF33D:             bitb     <VIA_int_flags 
                    beq      MLF33D 
MLF341:             deca                                  ;Delay a moment 
                    bne      MLF341 
                    bra      moveto_d_done 

MLF345:             bitb     <VIA_int_flags               ;Wait for timer 1 
                    beq      MLF345 
moveto_d_done 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INTENSITY_A         macro    
                    sta      <VIA_port_a                  ;Store intensity in D/A 
                    sta      Vec_Brightness               ;Save intensity in $C827 
                    ldd      #$0504                       ;mux disabled channel 2 
                    sta      <VIA_port_b 
                    stb      <VIA_port_b                  ;mux enabled channel 2 
                    stb      <VIA_port_b                  ;do it again just because 
                    ldb      #$01 
                    stb      <VIA_port_b                  ;turn off mux 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
JOYSTICK_TEST       macro    
                    jsr      Joy_Digital 
                    lda      in_alley                     ; inside an alley 
                    bne      jsdoneY                      ; disable Y position poll 
                    lda      Vec_Joy_1_Y 
                    beq      jsdoneY                      ; no Y motion 
                    bmi      going_down 
                    lda      shippos 
                    cmpa     #6                           ; slot 6 as far up as u can go 
                    beq      jsdoneY 
                    inc      shippos 
                    clr      stallcnt 
                    bra      jsdoneY 

going_down 
                    lda      shippos 
                    beq      jsdoneY 
                    dec      shippos 
                    clr      stallcnt 
jsdoneY 
; now test X first test should be if there is a prize in this alley.
                    ldb      shipXpos                     ; is X basically in the middle alley? unset in_alley flag 
                    jsr      Abs_b 
                    cmpb     #3 
                    bpl      leave_flag                   ; if b-3 > 0 then clr in_alley 
                    clr      in_alley                     ; clear in alley flag when in middle 
leave_flag 
                    lda      Vec_Joy_1_X 
                    beq      jsdoneX 
                    bmi      going_left 
going_right 
                    lda      #1 
                    sta      in_alley 
                    lda      #RIGHT 
                    sta      shipdir 
                    lda      #4 
                                                          ; adda shipXpos 
                    bvs      setMaxRight 
                    bra      setRightDone 

setMaxRight 
                    lda      #110 
setRightDone 
                                                          ; sta shipXpos 
                    bra      jsdoneX 

going_left 
                    lda      #1 
                    sta      in_alley 
                    lda      #LEFT 
                    sta      shipdir 
                    lda      shipXpos 
                    suba     #4 
                    bvs      setMaxLeft 
                    bra      setLeftDone 

setMaxLeft 
                    lda      #-110 
setLeftDone 
                                                          ; sta shipXpos 
jsdoneX 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DRAW_VLC            macro    
                    local    LF3F4,Draw_VLa 
                    lda      ,x+ 
Draw_VLa 
                    sta      $C823 
                    ldd      ,x 
                    sta      <VIA_port_a                  ;Send Y to A/D 
                    clr      <VIA_port_b                  ;Enable mux 
                    leax     2,x                          ;Point to next coordinate pair 
                    nop                                   ;Wait a moment 
                    inc      <VIA_port_b                  ;Disable mux 
                    stb      <VIA_port_a                  ;Send X to A/D 
                    ldd      #$FF00                       ;Shift reg=$FF (solid line), T1H=0 
                    sta      <VIA_shift_reg               ;Put pattern in shift register 
                    stb      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    ldd      #$0040                       ;B-reg = T1 interrupt bit 
LF3F4:              bitb     <VIA_int_flags               ;Wait for T1 to time out 
                    beq      LF3F4 
                    nop                                   ;Wait a moment more 
                    sta      <VIA_shift_reg               ;Clear shift register (blank output) 
                    lda      $C823                        ;Decrement line count 
                    deca     
                    bpl      Draw_VLa                     ;Go back for more points 
                                                          ; jmp Check0Ref ;Reset zero reference if necessary 
                    endm     
