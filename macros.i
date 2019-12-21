;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; vim: ts=4
; vim: syntax=asm6809
; MACROS
INTRO_BOOT          macro                                 ; run once on cold or warm boot 
introSplash 
                    lda      #1 
                    sta      Demo_Mode                    ; in Demo_Mode on boot 
                    ldu      #ustacktemp 
                    stu      ustacktempptr                ; only do this once 
                    jsr      setup                        ; remove when done testing 
;                    jsr      fill_hs_tbl                  ; filling from ROM eventually pull from EPROM 
                    jsr      eeprom_load 
                    jsr      fill_hs_tbl_eeprom 			; also loads game options
                    jsr      titleScreen 
                    jsr      SfxInit 
; only do this if eeprom_load doesn't find default values? nah skip it and allow access to config from #2 button press
;                    jsr      joystick_config 
                    endm     
;
RESTART             macro    
restart 
                    ldd      #$3075 
                    std      Vec_Rfrsh                    ; make sure we are at 50hz 
                    jsr      setup 
                    jsr      levelsplash 
                    lda      #0 
                    sta      shipYpos 
                    sta      shipXpos 
                    sta      In_Alley 
                    sta      Ship_Dead 
                    ldb      #LEFT 
                    stb      shipdir 
                    ldx      #score 
                    jsr      Clear_Score 
                    lda      #3                           ; normally 5 FIX 
                    sta      shipcnt 
                    lda      #$5F                         ; for high score input _ under scores _ 
                    sta      hstempstr 
                    sta      hstempstr+1 
                    sta      hstempstr+2 
                    lda      #$80                         ; EOL 
                    sta      hstempstr+3 
                    clr      demo_label_cnt 
                    jsr      SfxInit 
                    endm     
;
WAIT_RECAL          macro    
                    jsr      Wait_Recal 
                    endm     
DRAW_SHIP           macro    
; draw ship 
                    RESET0REF  
                    lda      #127 
                    sta      VIA_t1_cnt_lo                ; controls "scale" 
                    lda      shipYpos 
                    ldx      #bulletYpos_t 
                    lda      a,x                          ; get pos from shippos_t table 
                                                          ; suba #8 ; small offset to center in lane horizontally 
                    ldb      shipXpos 
;_donuthin 
                    MOVETO_D  
; test if we are dead.
                    lda      #127 
                    sta      VIA_t1_cnt_lo                ; controls "scale" 
                    lda      Ship_Dead 
                    bne      _is_dead 
                    bra      scale_done 

_is_dead 
                                                          ; lda #127 
                    ldb      Ship_Dead_Anim               ; 1 = shrink 
                    bne      ship_shrink                  ; shrink 
                    lda      Ship_Dead_Cnt 
                    inc      Ship_Dead_Cnt 
                    inc      Ship_Dead_Cnt 
                    bra      ship_grow 

ship_shrink 
                    lda      Ship_Dead_Cnt 
                    dec      Ship_Dead_Cnt 
                    dec      Ship_Dead_Cnt 
ship_grow 
                    sta      VIA_t1_cnt_lo                ; controls "scale" 
scale_done 
                    lda      Ship_Dead_Cnt 
                    bmi      change_dir 
                    cmpa     #126 
                    bne      shitballs                    ; animation done clear flags+counter 
                    clr      Ship_Dead 
                    clr      Ship_Dead_Cnt 
                    clr      shipXpos 
                    clr      In_Alley 
change_dir 
                    clr      Ship_Dead_Anim 
                    clr      Ship_Dead_Cnt                ; don't let it go minus. UNSIGNED 
                    CHECK_GAMEOVER  
shitballs 
                    ldx      #ShipL_nomode 
                    ldb      shipdir                      ; testing for 0|LEFT 1|RIGHT 
                    beq      _donuthin1 
                    ldx      #ShipR_nomode 
_donuthin1 
                    DRAW_VLC                              ; jsr Draw_VLc ;_mode 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALLEYWALL_Y         =        60 
ALLEYHEIGHT         =        17 
DRAW_LINE_WALLS     macro    
                    lda      #$3F 
                    INTENSITY_A  
                    clr      Vec_Misc_Count 
                    rol      Line_Pat                     ; 1->2->4->8->16-> etc 
                    bne      _topline                     ; check for 0 
                    inc      Line_Pat                     ; if it's zero set to 1 ie reset it 
                    RESET0REF  
_topline 
                    lda      #(ALLEYWALL_Y) 
                    ldb      #-128 
                    MOVETO_D                              ; PLACE EXTRA CODE VERSION HERE 
                    ldd      #$007F                       ; start far left, end middle 
                    DRAW_LINE_D  
                    LDD      #$007F                       ; start middle, end far right 
                    DRAW_LINE_D  
_toplineEnd 
                    RESET0REF  
_line1 
                    lda      #(ALLEYWALL_Y - (ALLEYHEIGHT*1) ) 
                    ldb      #-127 
                    MOVETO_D                              ; PLACE EXTRA CODE VERSION HERE 
                    ldd      #$0074 
                    DRAW_LINE_D_PAT                       ; dotted line 
                    LDD      #$0016 
                    MOVETO_D                              ; alley gap 
                    ldd      #$007F 
                    DRAW_LINE_D_PAT                       ; dotted line 
_line1End 
                    RESET0REF  
_line2 
                    lda      #(ALLEYWALL_Y - (ALLEYHEIGHT*2) ) 
                    ldb      #-127 
                    MOVETO_D                              ; PLACE EXTRA CODE VERSION HERE 
                    ldd      #$0074 
                    DRAW_LINE_D_PAT  
                    LDD      #$0016 
                    MOVETO_D                              ; alley gap 
                    ldd      #$0074 
                    DRAW_LINE_D_PAT  
_line2End 
                    RESET0REF  
_line3 
                    lda      #(ALLEYWALL_Y-(ALLEYHEIGHT*3)) 
                    ldb      #-127 
                    MOVETO_D                              ; PLACE EXTRA CODE VERSION HERE 
                    ldd      #$0074 
                    DRAW_LINE_D_PAT  
                    LDD      #$0016 
                    MOVETO_D                              ; alley gap 
                    ldd      #$007F 
                    DRAW_LINE_D_PAT  
_line3End 
                    RESET0REF  
_line4 
                    lda      #(ALLEYWALL_Y-(ALLEYHEIGHT*4)) 
                    ldb      #-127 
                    MOVETO_D                              ; PLACE EXTRA CODE VERSION HERE 
                    ldd      #$0074 
                    DRAW_LINE_D_PAT  
                    LDD      #$0016 
                    MOVETO_D                              ; alley gap 
                    ldd      #$007F 
                    DRAW_LINE_D_PAT  
_line4End 
                    RESET0REF  
_line5 
                    lda      #(ALLEYWALL_Y-(ALLEYHEIGHT*5)) 
                    ldb      #-127 
                    MOVETO_D                              ; PLACE EXTRA CODE VERSION HERE 
                    ldd      #$0074 
                    DRAW_LINE_D_PAT  
                    LDD      #$0016 
                    MOVETO_D                              ; alley gap 
                    ldd      #$007F 
                    DRAW_LINE_D_PAT  
_line5End 
                    RESET0REF  
_line6 
                    lda      #(ALLEYWALL_Y-(ALLEYHEIGHT*6)) 
                    ldb      #-127 
                    MOVETO_D                              ; PLACE EXTRA CODE VERSION HERE 
                    ldd      #$0074 
                    DRAW_LINE_D_PAT  
                    LDD      #$0016 
                    MOVETO_D                              ; alley gap 
                    ldd      #$007F 
                    DRAW_LINE_D_PAT  
_line6End 
                    RESET0REF  
_bottomLine 
                    lda      #(ALLEYWALL_Y-(ALLEYHEIGHT*7)) 
                    ldb      #-127 
                    MOVETO_D                              ; PLACE EXTRA CODE VERSION HERE 
                    ldd      #$007F 
                    DRAW_LINE_D  
                    ldd      #$007F                       ; start far left end far right 
                    DRAW_LINE_D  
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DRAW_ENEMYS         macro    
; *_D -> index 0|1 (0=Left, 1=Right)
                    RESET0REF  
                    lda      alley0e 
                    lbeq     skip0a 
break1 
                    ldx      #enemy_t 
                    lsla     
                    ldx      a,x                          ; sets *_D 
                    lda      alley0d 
                    lsla     
                    ldx      a,x                          ; gets *_t 
                    pshs     x                            ; store it 
                    ldx      #bulletYpos_t                ; also enemy Y table 
                    lda      ,x                           ; Y enemy 
                    ldb      alley0x                      ; X enemy 
                    MOVETO_D                              ; PLACE EXTRA CODE VERSION HERE 
; *_f  frame count -> index list of frames, see definition in data.i 
                    lda      alley0e 
                    lsla     
                    ldx      #enemyframe_t 
                    lda      [a,x]                        ; A = *_f var 
                    lsla                                  ; sets enemy type X and which frame a 
                    puls     x                            ; pull X back 
                    ldx      a,x 
break2 
                    DRAW_VL_MODE  
skip0a 
;################################################################################################
                    RESET0REF  
                    lda      alley1e 
                    lbeq     skip1a 
                    ldx      #enemy_t 
                    lsla     
                    ldx      a,x                          ; sets *_D 
                    lda      alley1d 
                    lsla     
                    ldx      a,x                          ; gets *_t 
                    pshs     x                            ; store it 
                    ldx      #bulletYpos_t 
                    lda      1,x                          ; Y 
                    ldb      alley1x                      ; X 
                    MOVETO_D  
; *_f  frame count -> index list of frames, see definition in data.i 
                    lda      alley1e 
                    lsla     
                    ldx      #enemyframe_t 
                    lda      [a,x]                        ; A = *_f var 
                    lsla     
                    puls     x                            ; pull X back 
                    ldx      a,x 
                    DRAW_VL_MODE  
skip1a 
;###########################################################################
                    RESET0REF  
                    lda      alley2e 
                    lbeq     skip2a 
                    ldx      #enemy_t 
                    lsla     
                    ldx      a,x                          ; sets *_D 
                    lda      alley2d 
                    lsla     
                    ldx      a,x                          ; gets *_t 
                    pshs     x                            ; store it 
                    ldx      #bulletYpos_t 
                    lda      2,x                          ; Y 
                    ldb      alley2x                      ; X 
                    MOVETO_D  
; *_f  frame count -> index list of frames, see definition in data.i 
                    lda      alley2e 
                    lsla     
                    ldx      #enemyframe_t 
                    lda      [a,x]                        ; A = *_f var 
                    lsla     
                    puls     x                            ; pull X back 
                    ldx      a,x 
                    DRAW_VL_MODE  
skip2a 
;###########################################################################
                    RESET0REF  
                    lda      alley3e 
                    lbeq     skip3a 
                    ldx      #enemy_t 
                    lsla     
                    ldx      a,x                          ; sets *_D 
                    lda      alley3d 
                    lsla     
                    ldx      a,x                          ; gets *_t 
                    pshs     x                            ; store it 
                    ldx      #bulletYpos_t 
                    lda      3,x                          ; Y 
                    ldb      alley3x                      ; X 
                    MOVETO_D  
; *_f  frame count -> index list of frames, see definition in data.i 
                    lda      alley3e 
                    lsla     
                    ldx      #enemyframe_t 
                    lda      [a,x]                        ; A = *_f var 
                    lsla     
                    puls     x                            ; pull X back 
                    ldx      a,x 
                    DRAW_VL_MODE  
skip3a 
;###########################################################################
                    RESET0REF  
                    lda      alley4e 
                    lbeq     skip4a 
                    ldx      #enemy_t 
                    lsla     
                    ldx      a,x                          ; sets *_D 
                    lda      alley4d 
                    lsla     
                    ldx      a,x                          ; gets *_t 
                    pshs     x                            ; store it 
                    ldx      #bulletYpos_t 
                    lda      4,x                          ; Y 
                    ldb      alley4x                      ; X 
                    MOVETO_D  
; *_f  frame count -> index list of frames, see definition in data.i 
                    lda      alley4e 
                    lsla     
                    ldx      #enemyframe_t 
                    lda      [a,x]                        ; A = *_f var 
                    lsla     
                    puls     x                            ; pull X back 
                    ldx      a,x 
                    DRAW_VL_MODE  
skip4a 
;###########################################################################
                    RESET0REF  
                    lda      alley5e 
                    lbeq     skip5a 
                    ldx      #enemy_t 
                    lsla     
                    ldx      a,x                          ; sets *_D 
                    lda      alley5d 
                    lsla     
                    ldx      a,x                          ; gets *_t 
                    pshs     x                            ; store it 
                    ldx      #bulletYpos_t 
                    lda      5,x                          ; Y 
                    ldb      alley5x                      ; X 
                    MOVETO_D  
; *_f  frame count -> index list of frames, see definition in data.i 
                    lda      alley5e 
                    lsla     
                    ldx      #enemyframe_t 
                    lda      [a,x]                        ; A = *_f var 
                    lsla     
                    puls     x                            ; pull X back 
                    ldx      a,x 
                    DRAW_VL_MODE  
skip5a 
;###########################################################################
                    RESET0REF  
                    lda      alley6e 
                    lbeq     skip6a 
                    ldx      #enemy_t 
                    lsla     
                    ldx      a,x                          ; sets *_D 
                    lda      alley6d 
                    lsla     
                    ldx      a,x                          ; gets *_t 
                    pshs     x                            ; store it 
                    ldx      #bulletYpos_t 
                    lda      6,x                          ; Y 
                    ldb      alley6x                      ; X 
                    MOVETO_D  
; *_f  frame count -> index list of frames, see definition in data.i 
                    lda      alley6e 
                    lsla     
                    ldx      #enemyframe_t 
                    lda      [a,x]                        ; A = *_f var 
                    lsla     
                    puls     x                            ; pull X back 
                    ldx      a,x 
                    DRAW_VL_MODE  
skip6a 
;###########################################################################
                    endm     
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
MOVE_ENEMYS         macro    
; move enemies0
                    lda      Ship_Dead 
                    lbne     subdone6 
; ships dead do not move enemys while doing ship dying animation
                    lda      alley0e 
                    cmpa     #PRIZE 
                    bne      noprize0 
                    lda      prizecntdown 
                    beq      prize2cannonball0 
noprize0 
                                                          ; cmpa #EXPLOSION ; don't scale Explosion speed 
                                                          ; beq framecont0 
                    lda      alley0sd                     ; speed divisor code 
                    lsla     
                    ldx      #speed_t 
                    lda      [a,x]                        ; check scale divisor vs current count from table 
                    beq      framecont0                   ; move on current frame or 
                    bra      subdone0                     ; skip move on current frame 

framecont0 
                    lda      alley0x 
                    sta      temp 
                    ldb      alley0d 
                    bne      add0                         ; moving left 
                    suba     alley0s 
                    bvs      alley0of 
                    sta      alley0x 
                    bra      subdone0 

prize2cannonball0 
                    lda      #255 
                    sta      prizecntdown 
                    clr      Is_Prize 
                    lda      #CANNONBALL 
                    sta      alley0e                      ; change enemy type and speed 
                    lda      #8 
                    sta      alley0s 
                    lda      #1 
                    sta      alley0sd 
                    bra      subdone0 

add0 
                    adda     alley0s                      ; moving right 
                    bvs      alley0of 
                    sta      alley0x 
                    bra      subdone0 

alley0of                                                  ;        object hit the wall, destroy or bounce? 
                                                          ; bra bounce0 ; TEST always bounce 
                    lda      alley0e 
                    cmpa     #TANK                        ; Tank 
                    beq      bounce0 
                    cmpa     #CANNONBALL                  ; Cannonball 
                    beq      bounce0 
                    cmpa     #ARROW                       ; Arrow 
                    beq      dotank0 
                    clra     
                    sta      alley0e                      ; else destroy 
                    sta      alley0x 
                    sta      alley0d 
                    sta      alley0s 
                    sta      alley0sd 
                    bra      subdone0 

dotank0                                                   ;        change type from arrow to tank 
                    lda      #TANK 
                    sta      alley0e 
bounce0 
                    lda      alley0e 
                    cmpa     #CANNONBALL 
                    bne      notcb0 
                    jsr      SFX_CB_Bounce 
notcb0 
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
                    lda      alley1e 
                    cmpa     #PRIZE 
                    bne      noprize1 
                    lda      prizecntdown 
                    beq      prize2cannonball1 
noprize1 
                    lda      alley1sd                     ; speed divisor code 
                    lsla     
                    ldx      #speed_t 
                    lda      [a,x]                        ; check scale divisor vs current count from table 
                    beq      framecont1                   ; move on current frame or 
                    bra      subdone1                     ; skip move on current frame 

framecont1 
                    lda      alley1x 
                    sta      temp 
                    ldb      alley1d 
                    bne      add1 
                    suba     alley1s 
                    bvs      alley1of 
                    sta      alley1x 
                    bra      subdone1 

prize2cannonball1 
                    lda      #255 
                    sta      prizecntdown 
                    clr      Is_Prize 
                    lda      #CANNONBALL 
                    sta      alley1e                      ; change enemy type and speed 
                    lda      #8 
                    sta      alley1s 
                    lda      #1 
                    sta      alley1sd 
                    bra      subdone1 

add1 
                    adda     alley1s 
                    bvs      alley1of 
                    sta      alley1x 
                    bra      subdone1 

alley1of                                                  ;        object hit the wall, destroy or bounce? 
                                                          ; bra bounce1 ; TEST always bounce 
                    lda      alley1e 
                    cmpa     #TANK                        ; Tank 
                    beq      bounce1 
                    cmpa     #CANNONBALL                  ; Cannonball 
                    beq      bounce1 
                    cmpa     #ARROW                       ; Arrow 
                    beq      dotank1 
                    clra     
                    sta      alley1e                      ; else destroy 
                    sta      alley1x 
                    sta      alley1d 
                    sta      alley1s 
                    sta      alley1sd 
                    bra      subdone1 

dotank1                                                   ;        change type from arrow to tank 
                    lda      #TANK 
                    sta      alley1e 
bounce1 
                    lda      alley1e 
                    cmpa     #CANNONBALL 
                    bne      notcb1 
                    jsr      SFX_CB_Bounce 
notcb1 
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
                    lda      alley2e 
                    cmpa     #PRIZE 
                    bne      noprizey2 
                    lda      prizecntdown 
                    beq      prize2cannonball2 
noprizey2 
                    lda      alley2sd                     ; speed divisor code 
                    lsla     
                    ldx      #speed_t 
                    lda      [a,x]                        ; check scale divisor vs current count from table 
                    beq      framecont2                   ; move on current frame or 
                    bra      subdone2                     ; skip move on current frame 

framecont2 
                    lda      alley2x 
                    sta      temp 
                    ldb      alley2d 
                    bne      add2 
                    suba     alley2s 
                    bvs      alley2of 
                    sta      alley2x 
                    bra      subdone2 

prize2cannonball2 
                    lda      #255 
                    sta      prizecntdown 
                    clr      Is_Prize 
                    lda      #CANNONBALL 
                    sta      alley2e                      ; change enemy type and speed 
                    lda      #8 
                    sta      alley2s 
                    lda      #1 
                    sta      alley2sd 
                    bra      subdone2 

add2 
                    adda     alley2s 
                    bvs      alley2of 
                    sta      alley2x 
                    bra      subdone2 

alley2of                                                  ;        object hit the wall, destroy or bounce? 
                                                          ; bra bounce2 ; TEST always bounce 
                    lda      alley2e 
                    cmpa     #TANK                        ; Tank 
                    beq      bounce2 
                    cmpa     #CANNONBALL                  ; Cannonball 
                    beq      bounce2 
                    cmpa     #ARROW                       ; Arrow 
                    beq      dotank2 
                    clra     
                    sta      alley2e                      ; else destroy 
                    sta      alley2x 
                    sta      alley2d 
                    sta      alley2s 
                    sta      alley2sd 
                    bra      subdone2 

dotank2                                                   ;        change type from arrow to tank 
                    lda      #TANK 
                    sta      alley2e 
bounce2 
                    lda      alley2e 
                    cmpa     #CANNONBALL 
                    bne      notcb2 
                    jsr      SFX_CB_Bounce 
notcb2 
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
                    lda      alley3e 
                    cmpa     #PRIZE 
                    bne      noprize3 
                    lda      prizecntdown 
                    beq      prize2cannonball3 
noprize3 
                    lda      alley3sd                     ; speed divisor code 
                    lsla     
                    ldx      #speed_t 
                    lda      [a,x]                        ; check scale divisor vs current count from table 
                    beq      framecont3                   ; move on current frame or 
                    bra      subdone3                     ; skip move on current frame 

framecont3 
                    lda      alley3x 
                    sta      temp 
                    ldb      alley3d 
                    bne      add3 
                    suba     alley3s 
                    bvs      alley3of 
                    sta      alley3x 
                    bra      subdone3 

prize2cannonball3 
                    lda      #255 
                    sta      prizecntdown 
                    clr      Is_Prize 
                    lda      #CANNONBALL 
                    sta      alley3e                      ; change enemy type and speed 
                    lda      #8 
                    sta      alley3s 
                    lda      #1 
                    sta      alley3sd 
                    bra      subdone3 

add3 
                    adda     alley3s 
                    bvs      alley3of 
                    sta      alley3x 
                    bra      subdone3 

alley3of                                                  ;        object hit the wall, destroy or bounce? 
                                                          ; bra bounce3 ; TEST always bounce 
                    lda      alley3e 
                    cmpa     #TANK                        ; Tank 
                    beq      bounce3 
                    cmpa     #CANNONBALL                  ; Cannonball 
                    beq      bounce3 
                    cmpa     #1                           ; Arrow 
                    beq      dotank3 
                    clra     
                    sta      alley3e                      ; else destroy 
                    sta      alley3x 
                    sta      alley3d 
                    sta      alley3s 
                    sta      alley3sd 
                    bra      subdone3 

dotank3                                                   ;        change type from arrow to tank 
                    lda      #TANK 
                    sta      alley3e 
bounce3 
                    lda      alley3e 
                    cmpa     #CANNONBALL 
                    bne      notcb3 
                    jsr      SFX_CB_Bounce 
notcb3 
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
                    lda      alley4e 
                    cmpa     #PRIZE 
                    bne      noprize4 
                    lda      prizecntdown 
                    beq      prize2cannonball4 
noprize4 
                    lda      alley4sd                     ; speed divisor code 
                    lsla     
                    ldx      #speed_t 
                    lda      [a,x]                        ; check scale divisor vs current count from table 
                    beq      framecont4                   ; move on current frame or 
                    bra      subdone4                     ; skip move on current frame 

framecont4 
                    lda      alley4x 
                    sta      temp 
                    ldb      alley4d 
                    bne      add4 
                    suba     alley4s 
                    bvs      alley4of 
                    sta      alley4x 
                    bra      subdone4 

prize2cannonball4 
                    lda      #255 
                    sta      prizecntdown 
                    clr      Is_Prize 
                    lda      #CANNONBALL 
                    sta      alley4e                      ; change enemy type and speed 
                    lda      #8 
                    sta      alley4s 
                    lda      #1 
                    sta      alley4sd 
                    bra      subdone4 

add4 
                    adda     alley4s 
                    bvs      alley4of 
                    sta      alley4x 
                    bra      subdone4 

alley4of                                                  ;        object hit the wall, destroy or bounce? 
                                                          ; bra bounce4 ; TEST always bounce 
                    lda      alley4e 
                    cmpa     #TANK                        ; Tank 
                    beq      bounce4 
                    cmpa     #CANNONBALL                  ; Cannonball 
                    beq      bounce4 
                    cmpa     #ARROW                       ; Arrow 
                    beq      dotank4 
                    clra     
                    sta      alley4e                      ; else destroy 
                    sta      alley4x 
                    sta      alley4d 
                    sta      alley4s 
                    sta      alley4sd 
                    bra      subdone4 

dotank4                                                   ;        change type from arrow to tank 
                    lda      #TANK 
                    sta      alley4e 
bounce4 
                    lda      alley4e 
                    cmpa     #CANNONBALL 
                    bne      notcb4 
                    jsr      SFX_CB_Bounce 
notcb4 
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
                    lda      alley5e 
                    cmpa     #PRIZE 
                    bne      noprize5 
                    lda      prizecntdown 
                    beq      prize2cannonball5 
noprize5 
                    lda      alley5sd                     ; speed divisor code 
                    lsla     
                    ldx      #speed_t 
                    lda      [a,x]                        ; check scale divisor vs current count from table 
                    beq      framecont5                   ; move on current frame or 
                    bra      subdone5                     ; skip move on current frame 

framecont5 
                    lda      alley5x 
                    sta      temp 
                    ldb      alley5d 
                    bne      add5 
                    suba     alley5s 
                    bvs      alley5of 
                    sta      alley5x 
                    bra      subdone5 

prize2cannonball5 
                    lda      #255 
                    sta      prizecntdown 
                    clr      Is_Prize 
                    lda      #CANNONBALL 
                    sta      alley5e                      ; change enemy type and speed 
                    lda      #8 
                    sta      alley5s 
                    lda      #1 
                    sta      alley5sd 
                    bra      subdone5 

add5 
                    adda     alley5s 
                    bvs      alley5of 
                    sta      alley5x 
                    bra      subdone5 

alley5of                                                  ;        object hit the wall, destroy or bounce? 
                                                          ; bra bounce5 ; TEST always bounce 
                    lda      alley5e 
                    cmpa     #TANK                        ; Tank 
                    beq      bounce5 
                    cmpa     #CANNONBALL                  ; Cannonball 
                    beq      bounce5 
                    cmpa     #ARROW                       ; Arrow 
                    beq      dotank5 
                    clra     
                    sta      alley5e                      ; else destroy 
                    sta      alley5x 
                    sta      alley5d 
                    sta      alley5s 
                    sta      alley5sd 
                    bra      subdone5 

dotank5                                                   ;        change type from arrow to tank 
                    lda      #TANK 
                    sta      alley5e 
bounce5 
                    lda      alley5e 
                    cmpa     #CANNONBALL 
                    bne      notcb5 
                    jsr      SFX_CB_Bounce 
notcb5 
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
                    lda      alley6e 
                    cmpa     #PRIZE 
                    bne      noprize6 
                    lda      prizecntdown 
                    beq      prize2cannonball6 
noprize6 
                    lda      alley6sd                     ; speed divisor code 
                    lsla     
                    ldx      #speed_t 
                    lda      [a,x]                        ; check scale divisor vs current count from table 
                    beq      framecont6                   ; move on current frame or 
                    bra      subdone6                     ; skip move on current frame 

framecont6 
                    lda      alley6x 
                    sta      temp 
                    ldb      alley6d 
                    bne      add6 
                    suba     alley6s 
                    bvs      alley6of 
                    sta      alley6x 
                    bra      subdone6 

prize2cannonball6 
                    lda      #255 
                    sta      prizecntdown 
                    clr      Is_Prize 
                    lda      #CANNONBALL 
                    sta      alley6e                      ; change enemy type and speed 
                    lda      #8 
                    sta      alley6s 
                    lda      #1 
                    sta      alley6sd 
                    bra      subdone6 

add6 
                    adda     alley6s 
                    bvs      alley6of 
                    sta      alley6x 
                    bra      subdone6 

alley6of                                                  ;        object hit the wall, destroy or bounce? 
                                                          ; bra bounce6 ; TEST always bounce 
                    lda      alley6e 
                    cmpa     #TANK                        ; Tank 
                    beq      bounce6 
                    cmpa     #CANNONBALL                  ; Cannonball 
                    beq      bounce6 
                    cmpa     #ARROW                       ; Arrow 
                    beq      dotank6 
                    clra     
                    sta      alley6e                      ; else destroy 
                    sta      alley6x 
                    sta      alley6d 
                    sta      alley6s 
                    sta      alley6sd 
                    bra      subdone6 

dotank6                                                   ;        change type from arrow to tank 
                    lda      #TANK 
                    sta      alley6e 
bounce6 
                    lda      alley6e 
                    cmpa     #CANNONBALL 
                    bne      notcb6 
                    jsr      SFX_CB_Bounce 
notcb6 
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
SHIP_Y_COLLISION_DETECT  macro  
                    lda      Ship_Dead                    ; if Ship_Dead do not do collision routine 
                    bne      no_hit 
                    lda      In_Alley 
                    bne      no_hit 
                    lda      shipYpos 
                    lsla     
                    ldx      #alleye_t 
                                                          ;ldx a,x 
                    lda      [a,x] 
                    beq      no_hit 
                    lda      shipYpos 
                    lsla     
                    ldx      #alleyx_t 
                                                          ;ldx a,x 
                    ldb      [a,x] 
                    jsr      Abs_b 
                    cmpb     #15                          ; trial and error 
                    bgt      no_hit 
                    dec      shipcnt                      ; lose one ship 
                    clrb     
                    lda      shipYpos                     ; clear e exist flag for this alley, ie destroy it 
                    lsla     
                    ldx      #alleye_t 
                    stb      [a,x] 
                    ldx      #alleyd_t 
                    stb      [a,x] 
                    ldx      #alleyx_t 
                    stb      [a,x] 
                    ldx      #alleys_t 
                    stb      [a,x] 
TATER 
                    dec      enemycnt 
                                                          ; jsr deathsplash 
                    lda      #127                         ; sets counter for 127 frames 2.5 seconds 
                    sta      Ship_Dead_Cnt 
                    inc      Ship_Dead 
                    inc      Ship_Dead_Anim 
;skipme
no_hit 
                    endm     
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
SHIP_X_COLLISION_DETECT  macro  
                    lda      Ship_Dead                    ; if Ship_Dead do not do collision routine 
                    lbne     donezo 
                    lda      In_Alley                     ; ONLY used when inside an alley 
                    lbeq     not_in_alley 
                    lda      shipYpos 
                    lsla     
                    ldx      #alleye_t 
                    lda      [a,x] 
;                    cmpa     #CANNONBALL 
;                    beq      can_collide 
;                    cmpa     #GHOST 
;                    beq      can_collide 
                    cmpa     #PRIZE 
                    beq      prize_test 
                    tsta                                  ; testing A to see if there is anything in the alley 
                    bne      can_collide 
prize_test 
                    lda      shipYpos 
                    lsla     
                    ldx      #alleyd_t 
                    ldb      [a,x] 
                    stb      temp 
                    lda      shipdir 
                    bne      ship_moving_right 
ship_moving_left 
                    lda      temp                         ; temp is side prize is on 
                    lbeq     no_prize_score 
                    lda      -#106 
                    cmpa     shipXpos 
                    bvs      wee_prize_score 
                    lbra     no_prize_score 

ship_moving_right 
                    lda      temp                         ; temp is side prize is on 
                    lbne     no_prize_score 
                    lda      shipXpos 
                    cmpa     #106 
                    lblt     no_prize_score 
; prize score is done like this:  800 == #2048 == 100 0000 0000 BCD value 
wee_prize_score 
                    jsr      SFX_Ghost_Spawn 
                    ldd      #$800 
                    ldx      #score 
                    jsr      Add_Score_d 
                    lda      shipYpos 
                    lsla     
                    ldx      #alleye_t 
                    ldb      #GHOST                       ; change char to ghost 
                    stb      [a,x] 
                    ldx      #alleys_t                    ; set speed to 2 
                    ldb      #1 
                    stb      [a,x] 
                    ldx      #alleyd_t 
                    ldb      [a,x] 
                    bne      set_dir_l 
                    inc      [a,x]                        ; change direction from right to left 
                    ldb      -#127 
                    bra      done_set_dir 

set_dir_l 
                    clr      [a,x]                        ; change direction from left to right 
                    ldb      #127 
done_set_dir 
                    ldx      #alleyx_t 
                    stb      [a,x] 
                    bra      donezo 

can_collide 
;first test of both numbers are same sign
                    lda      shipYpos 
                    lsla     
                    ldx      #alleyx_t 
                    lda      [a,x] 
                    sta      temp2 
                    anda     #%10000000                   ; load alleyX with then AND for sign 
                    sta      temp1                        ; store 
                    lda      shipXpos                     ; load shipXpos then AND for sign 
                    anda     #%10000000 
                    eora     temp1                        ; eor == XOR only check collision if signs match 
                    bne      donezo 
; work around for Abs_b odd behaviour with $80
                    lda      shipXpos 
                    cmpa     #$80 
                    bne      no_inc_shipos 
                    inc      shipXpos 
no_inc_shipos 
; collision check
                    lda      temp2 
                    cmpa     shipXpos 
                    bhs      stres 
                    lda      shipXpos 
                    ldb      temp2 
                    sta      bigger 
                    stb      smaller 
                    bra      nostres 

stres 
                    ldb      shipXpos 
                    lda      temp2 
                    sta      bigger 
                    stb      smaller 
nostres 
                    suba     smaller 
                    cmpa     #8 
                    bgt      donezo 
Xhit                dec      shipcnt                      ; lose one ship 
                    clrb                                  ; set to zero and use to reset alley vars 
                    lda      shipYpos                     ; clear e exist flag for this alley, ie destroy it 
                    lsla     
                    ldx      #alleye_t 
                    stb      [a,x] 
                    ldx      #alleyd_t 
                    stb      [a,x] 
                    ldx      #alleyx_t 
                    stb      [a,x] 
                    ldx      #alleys_t 
                    stb      [a,x] 
                    dec      enemycnt 
                    lda      #127                         ; sets counter for 127 frames 2.5 seconds 
                    sta      Ship_Dead_Cnt 
                    inc      Ship_Dead 
                    inc      Ship_Dead_Anim 
not_in_alley 
no_prize_score 
donezo 
                    endm     
;-----------------------------------------------------------------------------------
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
                    lbeq     bullet0_done 
                    lda      alley0e                      ; can't destroy Ghost 
                    cmpa     #GHOST 
                    lbeq     bullet0_done 
                    cmpa     #PRIZE                       ; NEW TESTING 
                    lbeq     bullet0_done 
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
                    cmpa     #TANK 
                    beq      tank0 
eventankdies0 
                    ldx      #score 
                    lda      alley0s 
                    ldb      #SCORE 
                    mul      
                    tfr      b,a 
                    jsr      Add_Score_a 
                    lda      #EXPLOSION                   ; change monster into explosion graphic 
                    sta      alley0e 
                    lda      bullet0d                     ; take bullets dir, str to explosions dir 
                    sta      alley0d 
                    lda      #2 
                    sta      alley0s 
                    deca     
                    sta      alley0sd 
                    clra     
                    sta      bullet0e 
                    sta      bullet0x 
                    sta      bullet0d 
                    lda      #100 
                    sta      alley0to 
                    dec      enemycnt 
                    dec      enemylvlcnt 
                    beq      set_level_done0 
                    bra      bullet0_done 

set_level_done0 
                    inc      Level_Done 
                    bra      bullet0_done 

tank0 
                    clr      bullet0e                     ; destroy bullet on nondestructive hit 
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
                    lda      bullet1e                     ; no bullet to test 
                    lbeq     bullet1_done 
                    lda      alley1e                      ; can't destroy Ghost 
                    cmpa     #GHOST 
                    lbeq     bullet1_done 
                    cmpa     #PRIZE 
                    lbeq     bullet1_done 
                    lda      bullet1d 
                    beq      bullet1d_l 
                    ldb      bullet1x                     ; test bullet going right 1-127 possible hit range 
                    bmi      bullet1_miss                 ; bullet going wrong direction can't hit. 
                    lda      alley1x 
                    cmpa     bullet1x 
                    ble      bullet1_miss 
                    bra      bullhit1                     ; hit 

bullet1d_l 
                    ldb      bullet1x                     ; test bullet going left (-127)-1 possible hit range 
                    bpl      bullet1_miss                 ; bullet on wrong side can't hit 
                    lda      alley1x 
                    cmpa     bullet1x 
                    bge      bullet1_miss 
; add to score then destroy bullet and enemy
bullhit1 
                    lda      alley1d 
                    cmpa     bullet1d 
                    beq      eventankdies1 
                    lda      alley1e 
                    cmpa     #TANK 
                    beq      tank1 
eventankdies1 
                    ldx      #score 
                    lda      alley1s 
                    ldb      #SCORE 
                    mul      
                    tfr      b,a 
                    jsr      Add_Score_a 
                    lda      #EXPLOSION                   ; change monster into explosion graphic 
                    sta      alley1e 
                    lda      bullet1d                     ; take bullets dir, str to explosions dir 
                    sta      alley1d 
                    lda      #2 
                    sta      alley1s 
                    deca     
                    sta      alley1sd 
                    clra     
                    sta      bullet1e 
                    sta      bullet1x 
                    sta      bullet1d 
                    lda      #100 
                    sta      alley1to 
                    dec      enemycnt 
                    dec      enemylvlcnt 
                    beq      set_level_done1 
                    bra      bullet1_done 

set_level_done1 
                    inc      Level_Done 
                    bra      bullet1_done 

tank1 
                    clr      bullet1e                     ; destroy bullet on nondestructive hit 
                    lda      alley1x 
                    ldb      alley1d 
                    beq      tankleft1 
                    suba     alley1s 
                    bra      tankright1 

tankleft1 
                    adda     alley1s 
tankright1 
                    sta      alley1x 
bullet1_done 
bullet1_miss 
                    lda      bullet2e                     ; no bullet to test 
                    lbeq     bullet2_done 
                    lda      alley2e                      ; can't destroy Ghost 
                    cmpa     #GHOST 
                    lbeq     bullet2_done 
                    cmpa     #PRIZE 
                    lbeq     bullet2_done 
                    lda      bullet2d 
                    beq      bullet2d_l 
                    ldb      bullet2x                     ; test bullet going right 2-127 possible hit range 
                    bmi      bullet2_miss                 ; bullet going wrong direction can't hit. 
                    lda      alley2x 
                    cmpa     bullet2x 
                    ble      bullet2_miss 
                    bra      bullhit2                     ; hit 

bullet2d_l 
                    ldb      bullet2x                     ; test bullet going left (-127)-2 possible hit range 
                    bpl      bullet2_miss                 ; bullet on wrong side can't hit 
                    lda      alley2x 
                    cmpa     bullet2x 
                    bge      bullet2_miss 
; add to score then destroy bullet and enemy
bullhit2 
                    lda      alley2d 
                    cmpa     bullet2d 
                    beq      eventankdies2 
                    lda      alley2e 
                    cmpa     #TANK 
                    beq      tank2 
eventankdies2 
                    ldx      #score 
                    lda      alley2s 
                    ldb      #SCORE 
                    mul      
                    tfr      b,a 
                    jsr      Add_Score_a 
                    lda      #EXPLOSION                   ; change monster into explosion graphic 
                    sta      alley2e 
                    lda      bullet2d                     ; take bullets dir, str to explosions dir 
                    sta      alley2d 
                    lda      #2 
                    sta      alley2s 
                    deca     
                    sta      alley2sd 
                    clra     
                    sta      bullet2e 
                    sta      bullet2x 
                    sta      bullet2d 
                    lda      #100 
                    sta      alley2to 
                    dec      enemycnt 
                    dec      enemylvlcnt 
                    beq      set_level_done2 
                    bra      bullet2_done 

set_level_done2 
                    inc      Level_Done 
                    bra      bullet2_done 

tank2 
                    clr      bullet2e                     ; destroy bullet on nondestructive hit 
                    lda      alley2x 
                    ldb      alley2d 
                    beq      tankleft2 
                    suba     alley2s 
                    bra      tankright2 

tankleft2 
                    adda     alley2s 
tankright2 
                    sta      alley2x 
bullet2_done 
bullet2_miss 
                    lda      bullet3e                     ; no bullet to test 
                    lbeq     bullet3_done 
                    lda      alley3e                      ; can't destroy Ghost 
                    cmpa     #GHOST 
                    lbeq     bullet3_done 
                    cmpa     #PRIZE 
                    lbeq     bullet3_done 
                    lda      bullet3d 
                    beq      bullet3d_l 
                    ldb      bullet3x                     ; test bullet going right 3-127 possible hit range 
                    bmi      bullet3_miss                 ; bullet going wrong direction can't hit. 
                    lda      alley3x 
                    cmpa     bullet3x 
                    ble      bullet3_miss 
                    bra      bullhit3                     ; hit 

bullet3d_l 
                    ldb      bullet3x                     ; test bullet going left (-127)-3 possible hit range 
                    bpl      bullet3_miss                 ; bullet on wrong side can't hit 
                    lda      alley3x 
                    cmpa     bullet3x 
                    bge      bullet3_miss 
; add to score then destroy bullet and enemy
bullhit3 
                    lda      alley3d 
                    cmpa     bullet3d 
                    beq      eventankdies3 
                    lda      alley3e 
                    cmpa     #TANK 
                    beq      tank3 
eventankdies3 
                    ldx      #score 
                    lda      alley3s 
                    ldb      #SCORE 
                    mul      
                    tfr      b,a 
                    jsr      Add_Score_a 
                    lda      #EXPLOSION                   ; change monster into explosion graphic 
                    sta      alley3e 
                    lda      bullet3d                     ; take bullets dir, str to explosions dir 
                    sta      alley3d 
                    lda      #2 
                    sta      alley3s 
                    deca     
                    sta      alley3sd 
                    clra     
                    sta      bullet3e 
                    sta      bullet3x 
                    sta      bullet3d 
                    lda      #100 
                    sta      alley3to 
                    dec      enemycnt 
                    dec      enemylvlcnt 
                    beq      set_level_done3 
                    bra      bullet3_done 

set_level_done3 
                    inc      Level_Done 
                    bra      bullet3_done 

tank3 
                    clr      bullet3e                     ; destroy bullet on nondestructive hit 
                    lda      alley3x 
                    ldb      alley3d 
                    beq      tankleft3 
                    suba     alley3s 
                    bra      tankright3 

tankleft3 
                    adda     alley3s 
tankright3 
                    sta      alley3x 
bullet3_done 
bullet3_miss 
                    lda      bullet4e                     ; no bullet to test 
                    lbeq     bullet4_done 
                    lda      alley4e                      ; can't destroy Ghost 
                    cmpa     #GHOST 
                    lbeq     bullet4_done 
                    cmpa     #PRIZE 
                    lbeq     bullet4_done 
                    lda      bullet4d 
                    beq      bullet4d_l 
                    ldb      bullet4x                     ; test bullet going right 4-127 possible hit range 
                    bmi      bullet4_miss                 ; bullet going wrong direction can't hit. 
                    lda      alley4x 
                    cmpa     bullet4x 
                    ble      bullet4_miss 
                    bra      bullhit4                     ; hit 

bullet4d_l 
                    ldb      bullet4x                     ; test bullet going left (-127)-4 possible hit range 
                    bpl      bullet4_miss                 ; bullet on wrong side can't hit 
                    lda      alley4x 
                    cmpa     bullet4x 
                    bge      bullet4_miss 
; add to score then destroy bullet and enemy
bullhit4 
                    lda      alley4d 
                    cmpa     bullet4d 
                    beq      eventankdies4 
                    lda      alley4e 
                    cmpa     #TANK 
                    beq      tank4 
eventankdies4 
                    ldx      #score 
                    lda      alley4s 
                    ldb      #SCORE 
                    mul      
                    tfr      b,a 
                    jsr      Add_Score_a 
                    lda      #EXPLOSION                   ; change monster into explosion graphic 
                    sta      alley4e 
                    lda      bullet4d                     ; take bullets dir, str to explosions dir 
                    sta      alley4d 
                    lda      #2 
                    sta      alley4s 
                    deca     
                    sta      alley4sd 
                    clra     
                    sta      bullet4e 
                    sta      bullet4x 
                    sta      bullet4d 
                    lda      #100 
                    sta      alley4to 
                    dec      enemycnt 
                    dec      enemylvlcnt 
                    beq      set_level_done4 
                    bra      bullet4_done 

set_level_done4 
                    inc      Level_Done 
                    bra      bullet4_done 

tank4 
                    clr      bullet4e                     ; destroy bullet on nondestructive hit 
                    lda      alley4x 
                    ldb      alley4d 
                    beq      tankleft4 
                    suba     alley4s 
                    bra      tankright4 

tankleft4 
                    adda     alley4s 
tankright4 
                    sta      alley4x 
bullet4_done 
bullet4_miss 
                    lda      bullet5e                     ; no bullet to test 
                    lbeq     bullet5_done 
                    lda      alley5e                      ; can't destroy Ghost 
                    cmpa     #GHOST 
                    lbeq     bullet5_done 
                    cmpa     #PRIZE 
                    lbeq     bullet5_done 
                    lda      bullet5d 
                    beq      bullet5d_l 
                    ldb      bullet5x                     ; test bullet going right 5-127 possible hit range 
                    bmi      bullet5_miss                 ; bullet going wrong direction can't hit. 
                    lda      alley5x 
                    cmpa     bullet5x 
                    ble      bullet5_miss 
                    bra      bullhit5                     ; hit 

bullet5d_l 
                    ldb      bullet5x                     ; test bullet going left (-127)-5 possible hit range 
                    bpl      bullet5_miss                 ; bullet on wrong side can't hit 
                    lda      alley5x 
                    cmpa     bullet5x 
                    bge      bullet5_miss 
; add to score then destroy bullet and enemy
bullhit5 
                    lda      alley5d 
                    cmpa     bullet5d 
                    beq      eventankdies5 
                    lda      alley5e 
                    cmpa     #TANK 
                    beq      tank5 
eventankdies5 
                    ldx      #score 
                    lda      alley5s 
                    ldb      #SCORE 
                    mul      
                    tfr      b,a 
                    jsr      Add_Score_a 
                    lda      #EXPLOSION                   ; change monster into explosion graphic 
                    sta      alley5e 
                    lda      bullet5d                     ; take bullets dir, str to explosions dir 
                    sta      alley5d 
                    lda      #2 
                    sta      alley5s 
                    deca     
                    sta      alley5sd 
                    clra     
                    sta      bullet5e 
                    sta      bullet5x 
                    sta      bullet5d 
                    lda      #100 
                    sta      alley5to 
                    dec      enemycnt 
                    dec      enemylvlcnt 
                    beq      set_level_done5 
                    bra      bullet5_done 

set_level_done5 
                    inc      Level_Done 
                    bra      bullet5_done 

tank5 
                    clr      bullet5e                     ; destroy bullet on nondestructive hit 
                    lda      alley5x 
                    ldb      alley5d 
                    beq      tankleft5 
                    suba     alley5s 
                    bra      tankright5 

tankleft5 
                    adda     alley5s 
tankright5 
                    sta      alley5x 
bullet5_done 
bullet5_miss 
                    lda      bullet6e                     ; no bullet to test 
                    lbeq     bullet6_done 
                    lda      alley6e                      ; can't destroy Ghost 
                    cmpa     #GHOST 
                    lbeq     bullet6_done 
                    cmpa     #PRIZE 
                    lbeq     bullet6_done 
                    lda      bullet6d 
                    beq      bullet6d_l 
                    ldb      bullet6x                     ; test bullet going right 6-127 possible hit range 
                    bmi      bullet6_miss                 ; bullet going wrong direction can't hit. 
                    lda      alley6x 
                    cmpa     bullet6x 
                    ble      bullet6_miss 
                    bra      bullhit6                     ; hit 

bullet6d_l 
                    ldb      bullet6x                     ; test bullet going left (-127)-6 possible hit range 
                    bpl      bullet6_miss                 ; bullet on wrong side can't hit 
                    lda      alley6x 
                    cmpa     bullet6x 
                    bge      bullet6_miss 
; add to score then destroy bullet and enemy
bullhit6 
                    lda      alley6d 
                    cmpa     bullet6d 
                    beq      eventankdies6 
                    lda      alley6e 
                    cmpa     #TANK 
                    beq      tank6 
eventankdies6 
                    ldx      #score 
                    lda      alley6s 
                    ldb      #SCORE 
                    mul      
                    tfr      b,a 
                    jsr      Add_Score_a 
                    lda      #EXPLOSION                   ; change monster into explosion graphic 
                    sta      alley6e 
                    lda      bullet6d                     ; take bullets dir, str to explosions dir 
                    sta      alley6d 
                    lda      #2 
                    sta      alley6s 
                    deca     
                    sta      alley6sd 
                    clra     
                    sta      bullet6e 
                    sta      bullet6x 
                    sta      bullet6d 
                    lda      #100 
                    sta      alley6to 
                    dec      enemycnt 
                    dec      enemylvlcnt 
                    beq      set_level_done6 
                    bra      bullet6_done 

set_level_done6 
                    inc      Level_Done 
                    bra      bullet6_done 

tank6 
                    clr      bullet6e                     ; destroy bullet on nondestructive hit 
                    lda      alley6x 
                    ldb      alley6d 
                    beq      tankleft6 
                    suba     alley6s 
                    bra      tankright6 

tankleft6 
                    adda     alley6s 
tankright6 
                    sta      alley6x 
bullet6_done 
bullet6_miss 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
READ_BUTTONS        macro    
                    lda      warpdelay 
                    beq      no_warp_delay 
                    dec      warpdelay 
no_warp_delay 
                    jsr      Read_Btns                    ; maybe only do one of these per loop? 
                    lda      Demo_Mode 
                    beq      no_check_needed 
                    lda      Vec_Button_1_2 
                    beq      no_conf_press 
                    jsr      general_config
				  jmp      main 						; return from GC menu still has buffered button presses, avoid by jmping to main
no_conf_press 
                    lda      Vec_Button_1_4 
                    beq      no_check_needed 
                    clr      Demo_Mode 
                    jmp      restart 

no_check_needed 
                    lda      Ship_Dead 
                    lbne     cant_shoot_while_dead 
                    lda      Demo_Mode 
                    lbne     demo_mode_firing 
                    jsr      DP_to_D0 
                                                          ; jsr Read_Btns 
                    lda      Vec_Btn_State 
                    lbeq     no_press 
                    ldb      Super_Game 
                    lbeq     not_super 
                                                          ;lda Vec_Btn_State 
                    cmpa     #1 
                    lbne     no_warp 
warp 
                    ldb      In_Alley 
                    lbne     cant_warp_in_alley 
                    ldb      warpdelay 
                    lbne     no_press                     ; too soon to warp again software debounce 
                    pshs     a 
                    jsr      Random 
                    anda     #%00000111 
                    cmpa     #7 
                    beq      warp 
                    sta      shipYpos 
                    jsr      SFX_Up_Burst 
                    lda      #25 
                    sta      warpdelay 
                    jmp      no_press 

cant_warp_in_alley 
no_warp 
                                                          ; a should still have original lda ; lda Vec_Btn_State 
                    cmpa     #2 
                    lbne     no_smart_bomb                ; not pressing button2 continue 
                    lda      smartbombcnt 
                    lbeq     no_press                     ; pressing 2 but used bomb already, so exit 
                    SMART_BOMB  
                    jsr      SFX_Bloop 
                    jmp      no_press                     ; did smart bomb just now, so exit 

no_smart_bomb 
not_super 
; adding bullet to alley if no other bullet is already there 
demo_mode_firing 
; don't shoot at Prize or explosion
                    lda      shipYpos 
                    asla     
                    ldx      #alleye_t 
                    lda      [a,x] 
                    cmpa     #EXPLOSION 
                    lbeq     noshootexplode 
                    cmpa     #PRIZE 
                    lbeq     noshootprize 
                    lda      In_Alley 
                    lbne     cant_shoot_in_alley 
                    lda      shipYpos 
                    asla     
                    ldx      #bullete_t 
                    ldx      a,x 
                    lda      ,x 
                    bne      already_exists 
                    jsr      SFX_Shot                     ; adding SFX here so there is actual shot added. 
                    ldb      #1 
                    stb      ,x                           ; set EXIST (int) 
; left(0) or right(1)?
                    lda      shipYpos 
                    asla     
                    ldx      #bulletd_t 
                    ldx      a,x 
                    ldb      shipdir 
                    stb      ,x                           ; set DIRECTION (bool) 
; starting x coordinates
                    lda      shipYpos 
                    asla     
                    ldx      #bulletx_t 
                    ldx      a,x 
                    ldb      shipdir 
                    beq      negstart 
                    ldb      #6                           ; trying to line up bullet creation with tip of ships nose 
                    stb      ,x                           ; set start X 
                    bra      newshotdone 

negstart 
                    ldb      #-6 
                    stb      ,x                           ; set start -X 
newshotdone 
no_press 
already_exists 
noshootexplode 
noshootprize 
cant_shoot_while_dead 
cant_shoot_in_alley 
                    endm                                  ; rts 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NEW_ENEMY           macro    
; need code to generate new random enemy OR prize in random alley
; type, and direction, direction decides initial X placement
; store answer in alleyNe (value from enemy_t offset), (bool)alleyNd (0 left, 1 right), (signed int)alleyNx (-127 or 127 )
;
; don't even do spawn logic if maximum enemies are out or ship is dead
                    lda      Ship_Dead 
                    lbne     no_new_enemy 
                    lda      level 
                    cmpa     #7 
                    blt      dontfix 
                    lda      #7                           ; after level 7 enemy count == 7, some logic to just set this and not rely on table 
                    bra      doenemycntchk 

dontfix 
                    ldx      #max_enemys_t 
                    lda      a,x 
doenemycntchk 
                    cmpa     enemycnt 
                    lble     no_new_enemy 
; check spawn throttle count logic only allow one per second hm
                                                          ; lda frm100cnt 
                                                          ; cmpa #20 
                                                          ; lbne no_new_enemy 
; spawn new enemy
                    lda      #15                          ; number of attempts to create new enemy 
                    sta      temp 
randloop 
                    dec      temp 
                    lbeq     no_new_enemy                 ; if it takes more than 14 loops, abort 
;    
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
; next test "timeout" field if NOT 0 still counting down from last enemy destruction
                    ldx      #alleyto_t 
                    lda      spawntemp 
                    lsla     
                    ldb      [a,x] 
                    lbne     no_new_enemy 
; 
                                                          ; lda spawntemp 
                                                          ; lsla 
                    ldx      #alleye_t 
                    ldx      a,x                          ; ldx alleyNe 
                    jsr      Random 
                    sta      temp                         ; keep for later 
                    anda     #%00000011                   ; mask off top 5 bits to limit answer 0-3 
                    inca                                  ; and add 1, use with enemy_t table 
                    sta      enemytemp 
                    lda      Is_Prize 
                    bne      noprize 
                    ldd      prizecnt 
                    cmpd     #300                         ; after 6 seconds make prize spawn possible 
                    blt      noprize 
                    inc      enemytemp                    ; adding another one means might be a prize! 
noprize 
                    lda      enemytemp 
                    sta      ,x                           ; set alleyNe enemy type 
                    cmpa     #PRIZE 
                    bne      noprize2 
                    lda      #1                           ; set prize parameters 
                    sta      Is_Prize 
                    clr      prizecnt 
                    clr      prizecnt+1 
                    clrb                                  ; 
                    lda      >spawntemp                   ; oops not level 
                    lsla     
                    ldx      #alleys_t 
                    stb      [a,x]                        ; prize has zero speed 
                    ldb      #255 
                    stb      >prizecntdown 
                    bra      nospeedcalc 

noprize2 
                                                          ; figure out speed stuff here 
;                    lda      level 
;                    cmpa     #5 
;                    blt      nofixmask 
;                    ldb      #7 
;                    stb      masktemp 
;                    bra      dofixmask 
;nofixmask 
;                    ldx      #max_speed_mask_t 
;                    ldb      a,x 
;                    stb      masktemp 
;dofixmask 
;                    lda      temp 
;                    lsra     
;                    lsra     
;                    lsra     
;                    lsra     
;                    lsra                                  ;shift til 3 bits 0-7 
;                    anda     masktemp                     ; then apply mask 
;                    ldx      #alleys_t 
;                    ldb      spawntemp 
;                    lslb     
;                    tsta     
;                    beq      nozerospeed 
;addspdreturn 
;                    sta      [b,x] 
;                    bra      speedset_done 
;nozerospeed 
;                    inca     
;                    bra      addspdreturn 
;nospeedcalc 
;speedset_done
;START new speed set routine 
                    jsr      Random                       ; fills A reg 
                    sta      temp1                        ; put aside 
                    ldb      level                        ; index to bitmask table might have to change 
                    ldx      #bitmasks 
                    ldb      b,x                          ; b holds bitmask 
                    andb     temp1                        ; result of random speed index held in B 
                    lslb                                  ; double index 
;
                    ldx      #enemyspeed_t                ; table index 
                    lda      b,x 
                    sta      speeditemp                   ; put aside 
                    ldx      #speedTop_t 
                    lda      a,x                          ; load value postion to A 
                    ldb      spawntemp 
                    lslb     
                    ldx      #alleys_t 
                    sta      [b,x]                        ; this is alleyXs 
;
                    lda      speeditemp 
                    ldx      #speedBot_t 
                    lda      a,x                          ; load value postion to A 
                    ldb      spawntemp 
                    lslb     
                    ldx      #alleysd_t 
                    sta      [b,x]                        ; this is alleyXsd 
;END new speed set routine 
nospeedcalc 
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
                    sta      [b,x] 
                    beq      set_enemy_going_left 
                    lda      #-127 
                    ldx      #alleyx_t 
                    ldb      spawntemp 
                    lslb     
                    sta      [b,x] 
                    bra      enemy_done 

set_enemy_going_left 
                    lda      #127 
                    ldx      #alleyx_t 
                    ldb      spawntemp 
                    lslb     
                    sta      [b,x] 
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
; could insert some routines in here before checking countdown?
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
READ_JOYSTICK       macro    
                    lda      Ship_Dead 
                    lbne     jsdone 
; can't move, done 
                    lda      Demo_Mode 
                    beq      not_demo_rjs 
                    lda      frm10cnt 
                    lbne     jsdone 
                    jsr      Random 
                    anda     #%00000001 
                    sta      shipdir                      ; set random ship direction 
                    lda      shipYdir                     ; 0 = up 1 = down 
                    bne      do_demo_dec 
                    lda      shipYpos 
                    cmpa     #6 
                    beq      rev_shipdir_down 
                    inc      shipYpos 
                    jmp      jsdone 

rev_shipdir_down 
                    inc      shipYdir 
                    dec      shipYpos 
                    jmp      jsdone 

do_demo_dec 
                    lda      shipYpos 
                    beq      rev_shipdir 
                    dec      shipYpos 
                    jmp      jsdone 

rev_shipdir 
                    clr      shipYdir 
                    inc      shipYpos 
                    jmp      jsdone 

not_demo_rjs 
                    lda      shipspeed                    ; user defined joystick speed 
                    lsla     
                    ldx      #speed_t 
                    lda      [a,x] 
                    bne      jsdoneY                      ; slowing down Y movement by half for more control 
                    jsr      Joy_Digital 
                    lda      In_Alley                     ; inside an alley ? 
                    bne      jsdoneY                      ; disable Y position poll 
                    lda      Vec_Joy_1_Y 
                    beq      jsdoneY                      ; no Y motion 
                    bmi      going_down 
                    lda      shipYpos 
                    cmpa     #6                           ; slot 6 as far up as u can go don't move 
                    beq      jsdoneY 
                    jsr      SFX_VertMove 
                    inc      shipYpos 
                    clr      stallcnt 
                    bra      jsdoneY 

going_down 
                    lda      shipYpos 
                    beq      jsdoneY                      ; in slot 0 as far down as u can go 
                    jsr      SFX_VertMove 
                    dec      shipYpos 
                    clr      stallcnt                     ; reset stall counter 
jsdoneY 
; now test X, first test should be if there is a prize in this alley.
                    lda      In_Alley 
                    bne      already_in 
                    lda      shipYpos 
                    lsla     
                    ldx      #alleye_t 
                    ldb      [a,x] 
                    cmpb     #PRIZE                       ; is there a prize in alley? 
                    bne      nope_prize 
                                                          ; logic for first move into alley and jumping us 8 spots 
                                                          ; into alley to avoid return to centering test 
                    lda      Vec_Joy_1_X 
                    beq      jsdoneX 
                    inc      In_Alley 
                    bmi      going_left1 
going_right1 
                    lda      #RIGHT 
                    sta      shipdir 
                    lda      #8 
                    adda     shipXpos 
                    bra      jsdone 

; unreachable
;                    sta      shipXpos 
;                    bra      jsdoneX 
going_left1 
                    lda      #LEFT 
                    sta      shipdir 
;                    lda      shipXpos 
                    suba     #8 
                    sta      shipXpos 
                    bra      jsdoneX 

nope_prize 
already_in 
;                    lda      shipdir 
;                    bne      facing_right 
;                                                          ; left 
;                    lda      shipXpos                     ; is X basically in the middle alley? unset in_alley flag 
;                    cmpa     #5 
;                    bgt      leave_flag                   ; if a-5 > 0 then clr in_alley 
;                    clr      In_Alley                     ; clear in alley flag when in middle 
;;                    clr      shipXpos 
;                    bra      center_done 
;leave_flag 
;facing_right 
;                    lda      shipXpos 
;                    cmpa     #-5 
;                    blt      center_done 
;                    clr      In_Alley 
;                    clr      shipXpos 
;center_done 
;
                    lda      Vec_Joy_1_X 
                    beq      jsdoneX 
                    bmi      going_left 
going_right 
                    lda      #RIGHT 
                    sta      shipdir 
                    lda      In_Alley 
                    beq      setRightDone 
                    lda      #4 
                    adda     shipXpos 
                    bvs      setMaxRight 
;  centering code here
                    tsta     
                    bpl      setRightDone 
                    cmpa     #-5 
                    blt      setRightDone 
                    clr      In_Alley 
                    clra                                  ; saved to shipXpos later 
; end center 
                    bra      setRightDone 

setMaxRight 
                    lda      #110 
setRightDone 
                    sta      shipXpos 
                    bra      jsdoneX 

going_left 
                    lda      #LEFT 
                    sta      shipdir 
                    lda      In_Alley 
                    beq      setLeftDone 
                    lda      shipXpos 
                    suba     #4 
                    bvs      setMaxLeft 
; centering code here 
                    tsta     
                    bmi      setLeftDone 
                    cmpa     #5                           ; if ship is closer than 5 
                    bgt      setLeftDone                  ; center it on screen 
                    clr      In_Alley                     ; and remove from In_Alley 
                    clra                                  ; saved to shipXpos later 
; center done 
                    bra      setLeftDone 

setMaxLeft 
                    lda      #-110 
setLeftDone 
                    sta      shipXpos 
jsdoneX 
jsdone 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
MOVE_BULLETS        macro    
                    lda      #127 
                    sta      VIA_t1_cnt_lo 
                    clra     
                    sta      bulletcnt                    ; bulletcnt=0 
move_start 
                    lda      bulletcnt 
                    asla     
                    ldx      #bullete_t 
                    ldx      a,x 
                    lda      ,x 
                    beq      next_bullet2                 ; don't do motion on non-existant bullets X 
                    lda      bulletcnt 
                    asla                                  ; shift left == multiply by 2 table is 2 byte entry 
                    ldx      #bulletx_t 
                    ldx      a,x                          ; get pointer from table 
                    ldb      ,x                           ; read from resolved address bulletNx 
                    bmi      moving_left 
                    addb     #MOVEAMOUNT 
                    bvs      destroy_bullet               ; if moving goes out of bounds destroy_bullet 
                    stb      ,x 
                    bra      next_bullet2 

destroy_bullet 
                    lda      bulletcnt 
                    asla     
                    ldx      #bullete_t 
                    ldx      a,x 
                    ldb      #0 
                    stb      ,x 
;                    lda      bulletcnt       A doesn't change since last lda
;                    asla     
                    ldx      #bulletx_t 
                    ldx      a,x 
                    ldb      #0 
                    stb      ,x 
                    bra      next_bullet2 

moving_left 
                    subb     #MOVEAMOUNT 
                    bvs      destroy_bullet               ; if moving goes out of bounds destroy_bullet 
                    stb      ,x 
next_bullet2 
                    inc      bulletcnt 
                    lda      bulletcnt 
                    cmpa     #7 
                    beq      bullets_done2 
                    bra      move_start 

bullets_done2 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DRAW_BULLETS        macro    
                    lda      #$7F 
                    INTENSITY_A  
                    lda      #$0F 
                    sta      Vec_Dot_Dwell                ; trying to make bullet brighter 
                    lda      #0 
                    sta      bulletcnt 
bstart 
                    lda      bulletcnt 
                    asla                                  ; shift left == multiply by 2 table is 2 byte entry 
                    ldx      #bullete_t 
                                                          ; ldx a,x 
                    lda      [a,x] 
                    beq      next_bullet                  ; Doesn't EXIST 
                    RESET0REF                             ; reset before positioning beam 
; find Y pos
                    lda      bulletcnt 
                    ldx      #bulletYpos_t                ; single mbyte table no asla 
                    lda      a,x                          ; do look up for Y pos from table TODO 
                    sta      bulletYtemp 
; find X pos
                    lda      bulletcnt 
                    asla                                  ; shift left == multiply by 2 table is 2 byte entry 
                    ldx      #bulletx_t 
                                                          ; ldx a,x ; get pointer from table 
                    ldb      [a,x]                        ; read from resolved address bulletNx 
                    lda      bulletYtemp 
                    MOVETO_D  
; draw dot code inlined
                    lda      #$FF                         ;Set pattern to all 1's 
                    sta      <VIA_shift_reg               ;Store in VIA shift register 
                    ldb      Vec_Dot_Dwell                ;Get dot dwell (brightness) 
dwellcnt            decb                                  ;Delay leaving beam in place 
                    bne      dwellcnt 
                    clr      <VIA_shift_reg               ;Blank beam in VIA shift register 
; END draw dot inline END
next_bullet 
                    inc      bulletcnt 
                    lda      bulletcnt 
                    cmpa     #7 
                    beq      bullets_done 
                    jmp      bstart 

bullets_done 
                    lda      #$05 
                    sta      Vec_Dot_Dwell 
                    lda      #$5F 
                    INTENSITY_A  
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
                    lda      In_Alley 
                    bne      no_ghost 
;; Add Ghost if stall in single alley for too long!
                    inc      stallcnt 
                    lda      #250 
                    cmpa     stallcnt 
                    bne      no_ghost 
                    jsr      SFX_Ghost_Spawn 
                    jsr      Random 
                    anda     #%00000001 
                    sta      temp                         ; direction bit 
                    lda      shipYpos 
                    lsla     
                    ldx      #alleye_t 
                    ldx      a,x 
                    ldb      ,x 
                    cmpb     #0                           ; don't spawn if existing enemy in alley. 
                    bne      no_ghost 
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
                                                          ; ldx a,x 
                    ldb      #2 
                    stb      [a,x] 
;  END add ghost stuff, must tweak
no_ghost 
                    endm     
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
FRAME_CNTS          macro    
; increment the Test frame counter
; add more logic to set/increment SHAPE_f counters for desired animations
                    lda      #2 
                    inc      frm2cnt 
                    cmpa     frm2cnt 
                    bne      no2cntreset 
                    clr      frm2cnt 
no2cntreset 
                    lda      #3 
                    inc      frm3cnt 
                    cmpa     frm3cnt 
                    bne      no3cntreset 
                    clr      frm3cnt 
no3cntreset 
                    lda      #4 
                    inc      frm4cnt 
                    cmpa     frm4cnt 
                    bne      no4cntreset 
                    clr      frm4cnt 
no4cntreset 
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
                    CHKENEMYCNT                           ; check number of enemies spawned every .4 seconds 
no20cntreset 
                    lda      #25 
                    inc      frm25cnt 
                    cmpa     frm25cnt 
                    bne      no25cntreset 
                    clr      frm25cnt 
                    inc      Prize_f 
                    inc      Wedge_f 
no25cntreset 
                    lda      #50 
                    inc      frm50cnt 
                    cmpa     frm50cnt 
                    bne      no50cntreset 
                    clr      frm50cnt 
                    inc      demo_label_cnt 
                    lda      #1 
                    sta      Arrow_f 
                    sta      Dash_f 
                    sta      Tank_f 
                    CHKPRIZEEXIST                         ; check if prize exists every 1 second 
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
                    sta      Wedge_f 
                    sta      Prize_f 
                    sta      Tank_f 
                    sta      Explode_f 
no100cntreset 
                    lda      demo_label_cnt 
                    cmpa     #3 
                    bne      noclrdlc 
                    clr      demo_label_cnt 
noclrdlc 
                    endm     
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
CHECK_GAMEOVER      macro                                 ; TO DO add some kind of ship destruction animation 
                    lda      shipcnt 
                    bne      notgameover 
                    jmp      gameover 

notgameover 
                    endm     
;###########################################################################################################
CHKENEMYCNT         macro    
                    clr      temp 
                    lda      alley0e 
                    beq      nextE0 
                    inc      temp 
nextE0 
                    lda      alley1e 
                    beq      nextE1 
                    inc      temp 
nextE1 
                    lda      alley2e 
                    beq      nextE2 
                    inc      temp 
nextE2 
                    lda      alley3e 
                    beq      nextE3 
                    inc      temp 
nextE3 
                    lda      alley4e 
                    beq      nextE4 
                    inc      temp 
nextE4 
                    lda      alley5e 
                    beq      nextE5 
                    inc      temp 
nextE5 
                    lda      alley6e 
                    beq      nextE6 
                    inc      temp 
nextE6 
                    lda      temp 
                    sta      enemycnt 
                    endm     
;###########################################################################################################
CHKPRIZEEXIST       macro    
                    lda      alley0e 
                    cmpa     #PRIZE 
                    beq      prize_exist 
                    lda      alley1e 
                    cmpa     #PRIZE 
                    beq      prize_exist 
                    lda      alley2e 
                    cmpa     #PRIZE 
                    beq      prize_exist 
                    lda      alley3e 
                    cmpa     #PRIZE 
                    beq      prize_exist 
                    lda      alley4e 
                    cmpa     #PRIZE 
                    beq      prize_exist 
                    lda      alley5e 
                    cmpa     #PRIZE 
                    beq      prize_exist 
                    lda      alley6e 
                    cmpa     #PRIZE 
                    beq      prize_exist 
                    clr      Is_Prize                     ; fail all tests, reset Is_Prize 
prize_exist 
                    endm     
;::::::::::::::::::::::::::::::::
ALLEY_TIMEOUT       macro    
; decrement counters on alley respawn timeouts                                     
                    ldd      prizecnt                     ; minumum counter for time between prize spawns 
                    addd     #1 
                    std      prizecnt 
                    lda      Is_Prize 
                    beq      noprizecntdown 
                    dec      prizecntdown 
noprizecntdown 
;
                    ldx      #alleyto_t 
                    lda      #6 
                    lsla     
respawncounter 
                    ldb      [a,x] 
                    beq      cntatzero 
                    dec      [a,x] 
cntatzero 
                    lsra     
                    deca     
                    lsla     
                    bge      respawncounter 
                    endm     
;########################################################################################################
;#########################################################################################################
;########################DRAWING MACROS
DRAW_VL_MODE        macro    
                    local    next_byte, next_line, dvm_done ,dorgle, fuckle, draw_solid 
next_byte:          lda      ,x+                          ;Get the next mode byte 
                    bne      draw_solid 
                                                          ; MOV_DRAW_VL ;If =0, move to the next point 
                    ldd      ,x                           ;Get next coordinate pair 
                    sta      <VIA_port_a                  ;Send Y to A/D 
                    clr      <VIA_port_b                  ;Enable mux 
                    leax     2,x                          ;Point to next coordinate pair 
                    nop                                   ;Wait a moment 
                    inc      <VIA_port_b                  ;Disable mux 
                    stb      <VIA_port_a                  ;Send X to A/D 
                    ldd      #$0000                       ;Shift reg=0 (no draw), T1H=0 
                                                          ; BRA LF3ED ;A->D00A, B->D005 
                    sta      <VIA_shift_reg               ;Put pattern in shift register 
                    stb      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    ldd      #$0040                       ;B-reg = T1 interrupt bit 
fuckle:             bitb     <VIA_int_flags               ;Wait for T1 to time out 
                    beq      fuckle 
                    nop                                   ;Wait a moment more 
                    sta      <VIA_shift_reg               ;Clear shift register (blank output) 
                                                          ; commented because not 'VL_c' which has vector line count 
                                                          ; lda $C823 ;Decrement line count 
                                                          ; deca 
                    bra      next_byte 

draw_solid:         deca     
                    beq      dvm_done                     ;value was 1 which si end of packlet marker 
                                                          ; DRAW_VL ;If <>1, draw a solid line 
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
; could insert some routines in here before checking countdown?
dorgle:             bitb     <VIA_int_flags               ;Wait for T1 to time out 
                    beq      dorgle 
                    nop                                   ;Wait a moment more 
                    sta      <VIA_shift_reg               ;Clear shift register (blank output) 
                    bra      next_byte 

dvm_done 
                    endm     
;;;;;;;;;;;; from BIOS optimized slightly ;;;;;;;;;;;;;;;;;;;;;;;;
DRAW_LINE_D         macro    
                    local    timeout 
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLR      <VIA_port_b                  ;Enable mux 
;                   LEAX     2,X                          ;Point to next coordinate pair 
                    NOP                                   ;Wait a moment 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                                                          ; Add pattern logic here for weirdly strobing line 
                    LDD      #$FF00                       ;Shift reg=$FF (solid line), T1H=0 
                    STA      <VIA_shift_reg               ;Put pattern in shift register 
                    STB      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    LDD      #$0040                       ;B-reg = T1 interrupt bit 
timeout:            BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    BEQ      timeout 
                    NOP                                   ;Wait a moment more 
                    STA      <VIA_shift_reg               ;Clear shift register (blank output) 
                                                          ;LDA $C823 ;Decrement line count 
                                                          ;DECA 
                                                          ;BPL Draw_VL_a ;Go back for more points 
                                                          ;JMP Check0Ref ;Reset zero reference if necessary 
                    endm     
;;;;;;;;;;;; from BIOS optimized slightly ;;;;;;;;;;;;;;;;;;;;;;;;
DRAW_LINE_D_PAT     macro    
                    local    _timeout_pat 
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLR      <VIA_port_b                  ;Enable mux 
                    NOP                                   ;Wait a moment 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    CLR      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    LDB      #$40                         ;B-reg = T1 interrupt bit 
                    LDA      Line_Pat                     ;Shift reg 
_timeout_pat        STA      <VIA_shift_reg               ;Put pattern in shift register 
                    BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    BEQ      _timeout_pat 
                    NOP                                   ;Wait a moment more 
                    CLR      <VIA_shift_reg               ;Clear shift register (blank output) 
                    endm     
;;;;;;;;;;;; from BIOS optimized slightly ;;;;;;;;;;;;;;;;;;;;;;;;    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DRAW_VECTOR_SCORE   macro    
                    lda      #$5F 
                    INTENSITY_A  
                    lda      frm2cnt 
                    lbeq     _no_print_vscore 
                    lda      Demo_Mode 
                    lbne     demo_score 
                    RESET0REF  
                    lda      #-127                        ; position before scaling 
                    ldb      #-20 
                    MOVETO_D  
                    lda      #14                          ; scale it lower is better 
                    sta      VIA_t1_cnt_lo 
                    ldy      #score 
_scoreloop 
                    lda      ,y+ 
                    cmpa     #$20                         ; is space? 
                    beq      _is_zero 
                    cmpa     #$80                         ; is EOL? 
                    lbeq     score_done 
                    suba     #$30                         ; otherwise get DEC value 
                    lsla     
                    ldx      #numbers_t 
                    ldx      a,x 
                    DRAW_VL_MODE  
                    bra      _scoreloop 

_is_zero 
                    ldx      #zero 
                    DRAW_VL_MODE  
                    ldx      #numbers_t 
                    lbra      _scoreloop 

demo_score 
                    RESET0REF  
                    lda      demo_label_cnt 
                    lsla     
                    ldu      #Demo_Label_t 
                    ldu      a,u 
                    lda      #-127 
                    ldb      #-100 
                    PRINT_STR_D  
                                                          ;jsr Print_Str_d 
score_done 
_no_print_vscore 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DRAW_RASTER_SCORE   macro    
                    lda      frm2cnt 
                    beq      _no_print_score 
                    RESET0REF  
                                                          ; ldd #$FC50 ; probably don't need to do this every frame 
                                                          ;; std Vec_Text_HW ; wastes 8 cycles 
                                                          ; lda #128 
                                                          ; ldb #-50 
                    ldd      #$80CE 
                    ldu      #score 
                    jsr      Print_Str_d 
_no_print_score 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRINT_VECTOR_SHIPS  macro    
                    RESET0REF  
                    lda      #-127 
                    ldb      #50 
                    MOVETO_D  
                    lda      shipcnt                      ; vector draw ships remaining routine TEST 
                    sta      temp 
_ships_left_loop 
                    ldx      #Ship_Marker 
                    DRAW_VLC  
                    dec      temp 
                    bne      _ships_left_loop 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRINT_SHIPS         macro    
                    lda      #127                         ; restore scale 
                    sta      VIA_t1_cnt_lo 
                    lda      Demo_Mode 
                    bne      _no_print_ships 
                    lda      frm2cnt 
                    bne      _no_print_ships 
                    RESET0REF  
                                                          ; lda #-127 
                                                          ; ldb #60 
                    ldx      #$8150                       ; coords 
                    lda      #$68                         ; asteroids ship 
                    ldb      shipcnt 
                    jsr      Print_Ships 
_no_print_ships 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_DEMO          macro    
                    lda      Demo_Mode 
                    beq      no_check_needed 
                    jsr      Read_Btns                    ; maybe only do one of these per loop? 
                    lda      Vec_Button_1_2 
                    beq      no_conf_pressD 
                    jsr      joystick_config 
no_conf_pressD 
                    lda      Vec_Button_1_4 
                    beq      no_check_needed 
                    clr      Demo_Mode 
                    jmp      restart 

no_check_needed 
                    endm     
;&&&&&&&&&&&&&&&^^^^^^^^^^^^^^^^^^^^^^^^^&&&&&&&&&&&&&&&&&&&&&&&&&^^^^^^^^^^^^^^^^^
MOVETO_D_BEFORE     macro    
                    sta      <VIA_port_a                  ;Store Y in D/A register 
                    clr      <VIA_port_b                  ;Enable mux 
                    pshs     b,a                          ;Save D-register on stack 
                    lda      #$CE                         ;Blank low, zero high? 
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

                    endm     
; ^%^%$^%@*&^@(  
MOVETO_D_AFTER      macro    
                    local    AMLF33B,AMLF33D,AMLF341,AMLF345,moveto_d_a_done 
AMLF33B:            lda      #$04                         ;Wait for timer 1 
; could insert some routines in here before checking countdown?
AMLF33D:            bitb     <VIA_int_flags 
                    beq      AMLF33D 
AMLF341:            deca                                  ;Delay a moment 
                    bne      AMLF341 
                    bra      moveto_d_done 

AMLF345             bitb     <VIA_int_flags               ;Wait for timer 1 
                    beq      AMLF345 
moveto_d_a_done 
                    endm     
;###################################################################################
SMART_BOMB          macro    
                    ldb      alley0e                      ; ENEMY FLAG 
                    beq      no_enemy0                    ; NO ENEMY BRANCH 
                    lda      #EXPLOSION 
                    sta      alley0e                      ; SET ENEMY TYPE TO #EXPLOSION 
                    lda      #1 
                    sta      alley0sd                     ; SET SPEED denominator TO 1 
                    tst      alley0x                      ; CHECK x POS TO MAKE SURE STAR FLIES IN RIGHT DIRECTION 
                    bpl      pos0 
                    clra     
pos0 
                    sta      alley0d 
                    lda      #2 
                    sta      alley0s                      ; SPEED TO 2 
no_enemy0 
                    ldb      alley1e 
                    beq      no_enemy1 
                    lda      #EXPLOSION 
                    sta      alley1e 
                    lda      #1 
                    sta      alley1sd 
                    tst      alley1x 
                    bpl      pos1 
                    clra     
pos1 
                    sta      alley1d 
                    lda      #2 
                    sta      alley1s 
no_enemy1 
                    ldb      alley2e 
                    beq      no_enemy2 
                    lda      #EXPLOSION 
                    sta      alley2e 
                    lda      #1 
                    sta      alley2sd 
                    tst      alley2x 
                    bpl      pos2 
                    clra     
pos2 
                    sta      alley2d 
                    lda      #2 
                    sta      alley2s 
no_enemy2 
                    ldb      alley3e 
                    beq      no_enemy3 
                    lda      #EXPLOSION 
                    sta      alley3e 
                    lda      #1 
                    sta      alley3sd 
                    tst      alley3x 
                    bpl      pos3 
                    clra     
pos3 
                    sta      alley3d 
                    lda      #2 
                    sta      alley3s 
no_enemy3 
                    ldb      alley4e 
                    beq      no_enemy4 
                    lda      #EXPLOSION 
                    sta      alley4e 
                    lda      #1 
                    sta      alley4sd 
                    tst      alley4x 
                    bpl      pos4 
                    clra     
pos4 
                    sta      alley4d 
                    lda      #2 
                    sta      alley4s 
no_enemy4 
                    ldb      alley5e 
                    beq      no_enemy5 
                    lda      #EXPLOSION 
                    sta      alley5e 
                    lda      #1 
                    sta      alley5sd 
                    tst      alley5x 
                    bpl      pos5 
                    clra     
pos5 
                    sta      alley5d 
                    lda      #2 
                    sta      alley5s 
no_enemy5 
                    ldb      alley6e 
                    beq      no_enemy6 
                    lda      #EXPLOSION 
                    sta      alley6e 
                    lda      #1 
                    sta      alley6sd 
                    tst      alley6x 
                    bpl      pos6 
                    clra     
pos6 
                    sta      alley6d 
                    lda      #2 
                    sta      alley6s 
no_enemy6 
                    clr      smartbombcnt 
                    endm     
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CHECK_LEVEL_DONE    macro    
                    lda      Level_Done                   ; check level_done flag 
                    lbeq     nolevel 
                    jsr      newlevel                     ; and run routine 
nolevel 
                    endm     
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CHECK_SFX           macro    
                    lda      Demo_Mode 
                    bne      no_sfx_demo 
                    jsr      Do_Sound_FX_C1 
                    jsr      Do_Sound_FX_C2 
                    jsr      Do_Sound_FX_C3 
no_sfx_demo 
                    endm     
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
ABS_A_B             macro    
                    local    abs_end, _Abs_b 
                    TSTA     
                    BPL      _Abs_b 
                    NEGA     
                    BVC      _Abs_b 
                    DECA     
_Abs_b              TSTB     
                    BPL      abs_end 
                    NEGB     
                    BVC      abs_end 
                    DECB     
abs_end 
                    endm     
;#############################################################
PRINT_STR_D         macro    
                    local    psdelayloop, psddone,linestart, moveflagset 
                    local    movedelay, movetimer1, movetimer2, movedone 
                    local    charlineread,charlinenext 
;                    JSR      >Moveto_d_7F 
;Moveto_d_7F:   
                    STA      <VIA_port_a                  ;Store Y in D/A register 
                    PSHS     d                            ;Save D-register on stack 
                                                          ;clr temp1 
                    LDA      #$7F                         ;Set scale factor to $7F 
                    STA      <VIA_t1_cnt_lo 
                    CLR      <VIA_port_b                  ;Enable mux 
;                    BRA      LF318 
;LF318:
                    LDA      #$CE                         ;Blank low, zero high? 
;                            %1100 1110  
                    STA      <VIA_cntl 
                    CLR      <VIA_shift_reg               ;Clear shift regigster 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Store X in D/A register 
                    CLR      <VIA_t1_cnt_hi               ;timer 1 count high 
                    PULS     d                            ;Get back D-reg 
                                                          ;JSR Abs_a_b 
                    ABS_A_B  
                    STB      -1,s 
                    ORA      -1,s 
                    LDB      #$40                         ; used in tests below of VIA_int_flags 
                    CMPA     #$40                         ; %01000000 
                    BLS      movetimer2                   ; 'a' <= 0x40, skip first set of delays while moving 
                                                          ; 0x64 %0110 0100 
                    CMPA     #$64                         ; 'a' <= 0x64, set flag to '4' 
                    BLS      moveflagset 
                    LDA      #$08                         ; delay used in movedelay set flag to '8' 
                    BRA      movetimer1 

moveflagset         LDA      #$04                         ; delay used in movedelay 
movetimer1          BITB     <VIA_int_flags               ;Wait for timer 1 , BIT vs $40==0100 0000 
                    BEQ      movetimer1 
movedelay           DECA                                  ;Delay a moment 4 or 8 depending on scale 
                    BNE      movedelay 
                    bra      movedone 

movetimer2          BITB     <VIA_int_flags               ;Wait for timer 1 
                    BEQ      movetimer2                   ; 
movedone 
;                    RTS      
; End Moveto_d_7F
                    NOP      10                           ; pause 20 cycles more readable? 
                                                          ; JSR Delay_1 ; pauze 20 cycles 
                                                          ; JMP Print_Str 
                    STU      Vec_Str_Ptr                  ;Save string pointer 
                                                          ; LDX #Char_Table-$20 ;Point to start of chargen bitmaps 
                    LDD      #$1883                       ;$8x = enable RAMP? 
;                            a=  %0001 1000 | b= %1000 0011
                    CLR      <VIA_port_a                  ;Clear D/A output 
                    STA      <VIA_aux_cntl                ;Shift reg mode = 110, T1 PB7 enabled 
                    LDX      #Char_Table-$20              ;Point to start of chargen bitmaps 
linestart           STB      <VIA_port_b                  ;Update RAMP, set mux to channel 1 
                    DEC      <VIA_port_b                  ;Enable mux 
                    LDD      #$8081 
                    NOP                                   ;Wait a moment 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_b                  ;Enable RAMP, set mux to channel 0 
                    STA      <VIA_port_b                  ;Enable mux 
                    TST      $C800                        ;I think this is a delay only 
                    INC      <VIA_port_b                  ;Enable RAMP, disable mux 
                    LDA      Vec_Text_Width               ;Get text width 
                    STA      <VIA_port_a                  ;Send it to the D/A 
                    LDD      #$0100 
                    LDU      Vec_Str_Ptr                  ;Point to start of text string 
                    STA      <VIA_port_b                  ;Disable RAMP, disable mux 
                    BRA      charlinenext 

; reading each line from chargen (character generator) table to form letters
charlineread        LDA      a,x                          ;Get bitmap from chargen table 
                    STA      <VIA_shift_reg               ;Save in shift register 
charlinenext 
                    LDA      ,u+                          ;Get next char 
;                    cmpa     #$4F                         ; 'O' 
;                    BNE      charlinenext 
;                  pshs     a
;                    lda      #127 
;                    sta      <VIA_port_a
;                  puls     a 
                    BPL      charlineread                 ;Go back if not terminator 
; continue next line
                    LDA      #$81 
                    STA      <VIA_port_b                  ;Enable RAMP, disable mux 
                    NEG      <VIA_port_a                  ;Negate text width to D/A 
                    LDA      #$01 
                    STA      <VIA_port_b                  ;Disable RAMP, disable mux 
                    CMPX     #Char_Table_End-$20          ; Check for last row 
                    BEQ      psddone                      ;Branch if last row 
                    LEAX     $50,x                        ;Point to next chargen row 
                    TFR      u,d                          ;Get string length 
                    SUBD     Vec_Str_Ptr 
                    SUBB     #$02                         ; - 2 
                    ASLB                                  ; * 2 
                    BRN      psdelayloop                  ;3 cycles Delay a moment BRN=branch never 
psdelayloop         LDA      #$81 
                    NOP      
                    DECB     
                    BNE      psdelayloop                  ;Delay some more in a loop 
                    STA      <VIA_port_b                  ;Enable RAMP, disable mux 
                    LDB      Vec_Text_Height              ;Get text height 
                    STB      <VIA_port_a                  ;Store text height in D/A 
                    DEC      <VIA_port_b                  ;Enable mux 
                    LDD      #$8101 
                    NOP                                   ;Wait a moment 
                    STA      <VIA_port_b                  ;Enable RAMP, disable mux 
                    CLR      <VIA_port_a                  ;Clear D/A 
                    STB      <VIA_port_b                  ;Disable RAMP, disable mux 
                    STA      <VIA_port_b                  ;Enable RAMP, disable mux 
; maybe change brightness here?
                                                          ; LDA #127 
                                                          ; INTENSITY_A 
                    LDB      #$03                         ;$0x = disable RAMP? 
                    BRA      linestart                    ;Go back for next scan line 

psddone             LDA      #$98 
                    STA      <VIA_aux_cntl                ;T1->PB7 enabled 
                                                          ; JMP Reset0Ref ;Reset the zero reference 
                    endm     
