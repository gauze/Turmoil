;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; vim: ts=4
; vim: syntax=asm6809
;###########################################################################
; SUBROUTINES/FUNCTIONS
;###########################################################################
setup:                                                    ;        setting up hardware, resetting scores, once per boot 
                    lda      #1                           ; enable 
                    sta      Vec_Joy_Mux_1_X 
                    lda      #3 
                    sta      Vec_Joy_Mux_1_Y 
                    lda      #0                           ; disable for Joy Mux's 
                    sta      Vec_Joy_Mux_2_X 
                    sta      Vec_Joy_Mux_2_Y 
                                                          ; jsr Joy_Digital ; set joymode, not analog. 
                    ldx      #highscore 
                    jsr      Clear_Score 
                    ldx      #score 
                    jsr      Clear_Score 
                    lda      #1 
                    sta      level 
                    ldd      #0                           ; set a bunch of variables to 0 
                    sta      bullet0e 
                    sta      bullet1e 
                    sta      bullet2e 
                    sta      bullet3e 
                    sta      bullet4e 
                    sta      bullet5e 
                    sta      bullet6e 
                    sta      bullet0d 
                    sta      bullet1d 
                    sta      bullet2d 
                    sta      bullet3d 
                    sta      bullet4d 
                    sta      bullet5d 
                    sta      bullet6d 
                    sta      bullet0x 
                    sta      bullet1x 
                    sta      bullet2x 
                    sta      bullet3x 
                    sta      bullet4x 
                    sta      bullet5x 
                    sta      bullet6x 
                    sta      alley0e 
                    sta      alley1e 
                    sta      alley2e 
                    sta      alley3e 
                    sta      alley4e 
                    sta      alley5e 
                    sta      alley6e 
                    sta      alley0d 
                    sta      alley1d 
                    sta      alley2d 
                    sta      alley3d 
                    sta      alley4d 
                    sta      alley5d 
                    sta      alley6d 
                    sta      alley0x 
                    sta      alley1x 
                    sta      alley2x 
                    sta      alley3x 
                    sta      alley4x 
                    sta      alley5x 
                    sta      alley6x 
                    sta      alley1s 
                    sta      alley2s 
                    sta      alley3s 
                    sta      alley4s 
                    sta      alley5s 
                    sta      alley6s 
                    sta      frm100cnt 
                    sta      frm50cnt 
                    sta      frm25cnt 
                    sta      frm20cnt 
                    sta      frm10cnt 
                    sta      frm5cnt 
                    sta      Arrow_f 
                    sta      Bow_f 
                    sta      Dash_f 
                    sta      Explode_f 
                    sta      Wedge_f 
                    sta      Ghost_f 
                    sta      None_f 
                    sta      Prize_f 
                    sta      Cannonball_f 
                    sta      Tank_f 
                    sta      enemycnt
                    std      prizecnt 
                    sta      Is_Prize
                    sta      Ship_Dead
                    rts      

     


gameover            ; #isfunction
                    jsr      Wait_Recal 
                    clr      Vec_Misc_Count 
                    lda      #$80 
                    sta      VIA_t1_cnt_lo 
                    jsr      Intensity_7F 
                    RESET0REF  
                    lda      -70 
                    ldb      -10 
                    ldu      #gameoverstr 
                    jsr      Print_Str_d 
                    RESET0REF  
                    lda      -50 
                    ldb      -50 
                    ldu      #score 
                    jsr      Print_Str_d 
                    jsr      Read_Btns 
                    lda      Vec_Button_1_3 
                    lbne      restart 
                    bra      gameover



levelsplash 
                    clr      stallcnt
splashloop
                    jsr      Wait_Recal 
                    clr      Vec_Misc_Count 
                    lda      #$80 
                    sta      VIA_t1_cnt_lo 
                    jsr      Intensity_7F 
                    ldx      #levelstr_t
                    lda      level
                    lsla
                    ldu      a,x
                    lda      -20 
                    ldb      -10 
                    jsr      Print_Str_d 
                    inc      stallcnt
                    lda      stallcnt 
                    cmpa     #100
                    beq      donesplash
                    bra      splashloop
donesplash
                    rts  

deathsplash 
                    clr      stallcnt
deathloop
                    jsr      Wait_Recal 
                    clr      Vec_Misc_Count 
                    lda      #$80 
                    sta      VIA_t1_cnt_lo 
                    jsr      Intensity_7F 
; dead
                    ldu      #deadstring
                    lda      -20 
                    ldb      -10 
                    jsr      Print_Str_d 
; ships left?
                    lda      -50 
                    ldb      65 
                    MOVETO_D  
                    lda      shipcnt                      ; vector draw ships remaining routine TEST 
                    beq      no_ships
                    sta      temp 
                
ships_left_loop1 
                    ldx      #Ship_Marker 
                    DRAW_VLC  
                    dec      temp 
                    bne      ships_left_loop1
no_ships 
                    inc      stallcnt
                    lda      stallcnt 
                    cmpa     #100               ; 2 seconds
                    beq      donedeathloop
                    jmp      deathloop
donedeathloop
                    rts  