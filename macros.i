;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; vim: ts=4
; vim: syntax=asm6809
; MACROS
DRAW_SHIP           macro

; draw ship 
                    RESET0REF  
                    lda      #127 
                    sta      VIA_t1_cnt_lo                ; controls "scale" 
                    lda      shippos 
                                                          ; ldx #shippos_t 
                    ldx      #bulletYpos_t 
                    lda      a,x                          ; get pos from shippos_t table 
                    adda     #2+6                         ; small offset 
                    ldb      shipXpos 
                    MOVETO_D  
                    ldx      #ShipL_nomode 
                    ldb      shipdir                      ; testing for 0|LEFT 1|RIGHT 
                    beq      donuthin1 
                    ldx      #ShipR_nomode 
donuthin1 
                    DRAW_VLC                              ; jsr Draw_VLc ;_mode 
                    endm
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
DRAW_WALLS          macro
                                                          ; jmp no_walls ; skip printing walls to save cycles 
; bottom wall     
                                                          ; lda #5 
                                                          ; sta $C823 ; vector count 
                    lda      #-60 
                    ldb      #-127 
                    MOVETO_D  
                    ldx      #Full_Wall_nomode 
                    DRAW_VLC                              ;jsr Draw_VLc 
;                    jmp      no_walls 
;no_walls: 
; top wall
                    RESET0REF  
                    lda      #60 
                    ldb      #-127 
                    MOVETO_D  
                    ldx      #Full_Wall_nomode 
                    DRAW_VLC                              ; jsr Draw_VLc 
                    endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
                    sta      temp 
                    ldb      alley0d 
                    bne      add0 
                    suba     alley0s 
                    bvs      alley0of 
                    sta      alley0x 
                    bra      subdone0 

add0 
                    adda     alley0s 
                    bvs      alley0of 
                    sta      alley0x 
                    bra      subdone0 

alley0of                                                  ;        object hit the wall, destroy or bounce? 
                                                          ; bra bounce0 ; TEST always bounce 
                    lda      alley0e 
                    cmpa     #6                           ; Tank 
                    beq      bounce0 
                    cmpa     #7                           ; Cannonball 
                    beq      bounce0 
                    cmpa     #1                           ; Arrow 
                    beq      dotank0 
                    clra
                    sta      alley0e                      ; else destroy 
                    sta      alley0x
                    sta      alley0d
                    sta      alley0s
                    bra      subdone0 

dotank0                                                   ;        change type from arrow to tank 
                    lda      #6 
                    sta      alley0e 
bounce0 
                    lda      temp                         ; pull pre-overflow coords 
                    sta      alley0x                      ; and restore 
                    lda      alley0d 
                    beq      setDtoR_0 
                    clr      alley0d 
                    bra      subdone0 

setDtoR_0 
                    inc      alley0d 
subdone0 
; move enemies1
                    lda      alley1x 
                    sta      temp 
                    ldb      alley1d 
                    bne      add1 
                    suba     alley1s 
                    bvs      alley1of 
                    sta      alley1x 
                    bra      subdone1 

add1 
                    adda     alley1s 
                    bvs      alley1of 
                    sta      alley1x 
                    bra      subdone1 

alley1of                                                  ;        object hit the wall, destroy or bounce? 
                                                          ; bra bounce1 ; TEST always bounce 
                    lda      alley1e 
                    cmpa     #6                           ; Tank 
                    beq      bounce1 
                    cmpa     #7                           ; Cannonball 
                    beq      bounce1 
                    cmpa     #1                           ; Arrow 
                    beq      dotank1 
                    clra
                    sta      alley1e                      ; else destroy 
                    sta      alley1x
                    sta      alley1d
                    sta      alley1s
                    bra      subdone1 

dotank1                                                   ;        change type from arrow to tank 
                    lda      #6 
                    sta      alley1e 
bounce1 
                    lda      temp                         ; pull pre-overflow coords 
                    sta      alley1x                      ; and restore 
                    lda      alley1d 
                    beq      setDtoR_1 
                    clr      alley1d 
                    bra      subdone1 

setDtoR_1 
                    inc      alley1d 
subdone1 
; move enemies2
                    lda      alley2x 
                    sta      temp 
                    ldb      alley2d 
                    bne      add2 
                    suba     alley2s 
                    bvs      alley2of 
                    sta      alley2x 
                    bra      subdone2 

add2 
                    adda     alley2s 
                    bvs      alley2of 
                    sta      alley2x 
                    bra      subdone2 

alley2of                                                  ;        object hit the wall, destroy or bounce? 
                                                          ; bra bounce2 ; TEST always bounce 
                    lda      alley2e 
                    cmpa     #6                           ; Tank 
                    beq      bounce2 
                    cmpa     #7                           ; Cannonball 
                    beq      bounce2 
                    cmpa     #1                           ; Arrow 
                    beq      dotank2 
                    clra
                    sta      alley2e                      ; else destroy 
                    sta      alley2x
                    sta      alley2d
                    sta      alley2s
                    bra      subdone2 

dotank2                                                   ;        change type from arrow to tank 
                    lda      #6 
                    sta      alley2e 
bounce2 
                    lda      temp                         ; pull pre-overflow coords 
                    sta      alley2x                      ; and restore 
                    lda      alley2d 
                    beq      setDtoR_2 
                    clr      alley2d 
                    bra      subdone2 

setDtoR_2 
                    inc      alley2d 
subdone2 
; move enemies3
                    lda      alley3x 
                    sta      temp 
                    ldb      alley3d 
                    bne      add3 
                    suba     alley3s 
                    bvs      alley3of 
                    sta      alley3x 
                    bra      subdone3 

add3 
                    adda     alley3s 
                    bvs      alley3of 
                    sta      alley3x 
                    bra      subdone3 

alley3of                                                  ;        object hit the wall, destroy or bounce? 
                                                          ; bra bounce3 ; TEST always bounce 
                    lda      alley3e 
                    cmpa     #6                           ; Tank 
                    beq      bounce3 
                    cmpa     #7                           ; Cannonball 
                    beq      bounce3 
                    cmpa     #1                           ; Arrow 
                    beq      dotank3 
                    clra
                    sta      alley3e                      ; else destroy 
                    sta      alley3x
                    sta      alley3d
                    sta      alley3s
                    bra      subdone3 

dotank3                                                   ;        change type from arrow to tank 
                    lda      #6 
                    sta      alley3e 
bounce3 
                    lda      temp                         ; pull pre-overflow coords 
                    sta      alley3x                      ; and restore 
                    lda      alley3d 
                    beq      setDtoR_3 
                    clr      alley3d 
                    bra      subdone3 

setDtoR_3 
                    inc      alley3d 
subdone3 
; move enemies4
                    lda      alley4x 
                    sta      temp 
                    ldb      alley4d 
                    bne      add4 
                    suba     alley4s 
                    bvs      alley4of 
                    sta      alley4x 
                    bra      subdone4 

add4 
                    adda     alley4s 
                    bvs      alley4of 
                    sta      alley4x 
                    bra      subdone4 

alley4of                                                  ;        object hit the wall, destroy or bounce? 
                                                          ; bra bounce4 ; TEST always bounce 
                    lda      alley4e 
                    cmpa     #6                           ; Tank 
                    beq      bounce4 
                    cmpa     #7                           ; Cannonball 
                    beq      bounce4 
                    cmpa     #1                           ; Arrow 
                    beq      dotank4 
                    clra
                    sta      alley4e                      ; else destroy 
                    sta      alley4x
                    sta      alley4d
                    sta      alley4s
                    bra      subdone4 

dotank4                                                   ;        change type from arrow to tank 
                    lda      #6 
                    sta      alley4e 
bounce4 
                    lda      temp                         ; pull pre-overflow coords 
                    sta      alley4x                      ; and restore 
                    lda      alley4d 
                    beq      setDtoR_4 
                    clr      alley4d 
                    bra      subdone4 

setDtoR_4 
                    inc      alley4d 
subdone4 
; move enemies5
                    lda      alley5x 
                    sta      temp 
                    ldb      alley5d 
                    bne      add5 
                    suba     alley5s 
                    bvs      alley5of 
                    sta      alley5x 
                    bra      subdone5 

add5 
                    adda     alley5s 
                    bvs      alley5of 
                    sta      alley5x 
                    bra      subdone5 

alley5of                                                  ;        object hit the wall, destroy or bounce? 
                                                          ; bra bounce5 ; TEST always bounce 
                    lda      alley5e 
                    cmpa     #6                           ; Tank 
                    beq      bounce5 
                    cmpa     #7                           ; Cannonball 
                    beq      bounce5 
                    cmpa     #1                           ; Arrow 
                    beq      dotank5 
                    clra
                    sta      alley5e                      ; else destroy 
                    sta      alley5x
                    sta      alley5d
                    sta      alley5s 
                    bra      subdone5 

dotank5                                                   ;        change type from arrow to tank 
                    lda      #6 
                    sta      alley5e 
bounce5 
                    lda      temp                         ; pull pre-overflow coords 
                    sta      alley5x                      ; and restore 
                    lda      alley5d 
                    beq      setDtoR_5 
                    clr      alley5d 
                    bra      subdone5 

setDtoR_5 
                    inc      alley5d 
subdone5 
; move enemies6
                    lda      alley6x 
                    sta      temp 
                    ldb      alley6d 
                    bne      add6 
                    suba     alley6s 
                    bvs      alley6of 
                    sta      alley6x 
                    bra      subdone6 

add6 
                    adda     alley6s 
                    bvs      alley6of 
                    sta      alley6x 
                    bra      subdone6 

alley6of                                                  ;        object hit the wall, destroy or bounce? 
                                                          ; bra bounce6 ; TEST always bounce 
                    lda      alley6e 
                    cmpa     #6                           ; Tank 
                    beq      bounce6 
                    cmpa     #7                           ; Cannonball 
                    beq      bounce6 
                    cmpa     #1                           ; Arrow 
                    beq      dotank6 
                    clra
                    sta      alley6e                      ; else destroy 
                    sta      alley6x
                    sta      alley6d
                    sta      alley6s
                    bra      subdone6 

dotank6                                                   ;        change type from arrow to tank 
                    lda      #6 
                    sta      alley6e 
bounce6 
                    lda      temp                         ; pull pre-overflow coords 
                    sta      alley6x                      ; and restore 
                    lda      alley6d 
                    beq      setDtoR_6 
                    clr      alley6d 
                    bra      subdone6 

setDtoR_6 
                    inc      alley6d 
subdone6 
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
                    dec      enemycnt 
                    jsr      levelsplash
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
                    lda      bullet0e                     ; no bullet to test
                    beq      bullet0_done 
                    lda      alley0e                      ; can't destroy Ghost 
                    cmpa     #8 
                    beq      bullet0_done 
;                    cmpa     #6                           ; Tank can only destroy hitting BACK SIDE so bulletNd == alleyNd
;                    bne      nottank_0
;                    lda      bullet0d
;                    cmpa     alley0d
;                    beq      nottank_0                    ; MOVE this bit farther into bullet vs  array X testing otherwise bullet doesn't move
;                    clr      bullet0e                     ; hit tank keep tank where it is
;                    lda      alley0x  
;                    suba     alley0s
;                    sta      alley0x 
;                    bra      bullet0_miss
;nottank_0
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
                    lda      alley0d
                    cmpa     bullet0d 
                    beq      eventankdies0
                    lda      alley0e
                    cmpa     #6
                    beq      tank0
eventankdies0
                    ldx      #score 
                    lda      alley0s 
                    ldb      #SCORE 
                    mul      
                    jsr      Add_Score_d 
                    lda      #9                  ; change monster into explosion graphic
                    sta      alley0e  
                    lda      bullet0d            ; take bullets dir, str to explosions dir
                    sta      alley0d 
                    lda      #2
                    sta      alley0s 
                    clra     
                    sta      bullet0e 
                    sta      bullet0x 
                    sta      bullet0d 
                    dec      enemycnt
                    bra      bullet0_done
tank0               
                    clr      bullet0e          ; destroy bullet on nondestructive hit
                    lda      alley0x 
                    ldb      alley0d
                    beq      tankleft0  
                    suba     alley0s
                    bra      tankright0
tankleft0
                    adda     alley0s    
tankright0
                    sta      alley0x 
bullet0_done 
bullet0_miss 
                    lda      bullet1e 
                    beq      bullet1_done 
                    lda      alley1e                      ; can't destroy Ghost 
                    cmpa     #8 
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
                    lda      alley2e                      ; can't destroy Ghost 
                    cmpa     #8 
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
                    lda      alley3e                      ; can't destroy Ghost 
                    cmpa     #8 
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
                    lda      alley4e                      ; can't destroy Ghost 
                    cmpa     #8 
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
                    lda      alley5e                      ; can't destroy Ghost 
                    cmpa     #8 
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
                    lda      alley6e                      ; can't destroy Ghost 
                    cmpa     #8 
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
; don't shoot at Prize or explosion
                    lda      shippos
                    asla     
                    ldx      #alleye_t 
                    ldx      a,x
                    lda      ,x
                    cmpa     #9
                    beq      noshootexplode
                    cmpa     #5
                    beq      noshootprize
;
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
noshootexplode
noshootprize
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
                    lble     no_new_enemy 
; check spawn throttle count logic 
                    lda      frm100cnt 
                    cmpa     #20 
                    lbeq     no_new_enemy 
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
; else fall through ACCA (a) holds valid (empty) alley index
                    lda      spawntemp 
                    lsla     
                    ldx      #alleye_t 
                    ldx      a,x                          ; ldx alleyNe 
                    jsr      Random 
                    sta      temp                         ; keep for later 
                    anda     #%00000011                   ; mask off top 5 bits to limit answer 0-3 
                    adda     #1                           ; and add 1, use with enemy_t table 
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
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
STALL_CHECK         macro    
;; Add Ghost if stall in single alley for too long!
                    inc      stallcnt 
                    lda      #250 
                    cmpa     stallcnt 
                    bne      noghost 
;
                    jsr      Random 
                    anda     #%00000001 
                    sta      temp                         ; direction bit

                    lda      shippos 
                    lsla     
                    ldx      #alleye_t 
                    ldx      a,x 
                    ldb      ,x                           
                    cmpb     #0                           ; don't spawn if existing enemy in alley.
                    bne      noghost
  
                    ldb      #8                           ; Ghost! 
                    stb      ,x 
                    ldx      #alleyd_t 
                    ldx      a,x 
                    ldb      temp
                    stb      ,x
                    cmpb     #1
                    bne      ghost_l
                    ldb      #-127
                    bra      ghost_d_done
ghost_l 
                    ldb      #127
ghost_d_done
                    ldx      #alleyx_t 
                    ldx      a,x 
                    stb      ,x 
                    ldx      #alleys_t 
                    ldx      a,x 
                    ldb      #2 
                    stb      ,x 
;  END add ghost stuff, must tweak
noghost
                    endm     

FRAME_CNTS          macro
; increment the Test frame counter
; add more logic to set/increment SHAPE_f counters for desired animations

                    lda      #5 
                    inc      frm5cnt 
                    cmpa     frm5cnt 
                    bne      no5cntreset 
                    clr      frm5cnt 
                    inc      Bow_f
                    inc      Explode_f
no5cntreset 
                    lda      #10 
                    inc      frm10cnt 
                    cmpa     frm10cnt 
                    bne      no10cntreset 
                    clr      frm10cnt 
no10cntreset 
                    lda      #20 
                    inc      frm20cnt 
                    cmpa     frm20cnt 
                    bne      no20cntreset 
                    clr      frm20cnt 
no20cntreset 
                    lda      #25 
                    inc      frm25cnt 
                    cmpa     frm25cnt 
                    bne      no25cntreset 
                    clr      frm25cnt 
                    jsr      chkenemycnt                  ; check number of enemies spawned every .4 seconds 
no25cntreset 
                    lda      #50 
                    inc      frm50cnt 
                    cmpa     frm50cnt 
                    bne      no50cntreset 
                    clr      frm50cnt 
                    lda      #1 
                    sta      Arrow_f 
                    sta      Prize_f 
                    sta      Dash_f 
                    sta      Tank_f 
no50cntreset 
                    lda      #100                         ; frame count 100=2 seconds (at full speed) 0-99 == 100 
                                                          ; frame freq 1, 2, 4, 5, 10, 20, 25,50, 100 
                                                          ; frame len .02, .04, .08, .1, .2, .4, .5, 1, 2 
                    inc      frm100cnt 
                    cmpa     frm100cnt 
                    bne      no100cntreset 
                    clra     
                    sta      frm100cnt 
                                                          ; Reset all frame counts 
                    sta      Arrow_f 
                    sta      Bow_f 
                    sta      Dash_f 
                                                          ; sta Wedge_f 
                                                          ; sta Ghost_f 
                    sta      Prize_f 
                                                          ; sta Cannonball_f 
                    sta      Tank_f 
                    sta      Explode_f 
no100cntreset 
                    endm