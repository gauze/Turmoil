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
                                                          ; ldx #Vec_High_Score 
                                                          ; jsr Clear_Score 
                    ldx      #score 
                    jsr      Clear_Score 
                    lda      #1 
                    sta      level 
                    bsr      setuplevel 
                    rts      

setuplevel: 
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
                    sta      alley0s 
                    sta      alley1s 
                    sta      alley2s 
                    sta      alley3s 
                    sta      alley4s 
                    sta      alley5s 
                    sta      alley6s 
                    sta      alley0to 
                    sta      alley1to 
                    sta      alley2to 
                    sta      alley3to 
                    sta      alley4to 
                    sta      alley5to 
                    sta      alley6to 
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
                    sta      Level_Done 
                    sta      Line_Pat 
                                                          ; lda #1 
                                                          ; sta level 
                    rts      

newlevel: 
                    inc      level 
                    jsr      levelsplash 
                    rts      

gameover:                                                 ;        #isfunction 
                    jsr      Wait_Recal 
                    clr      Vec_Misc_Count 
                    lda      #$80 
                    sta      VIA_t1_cnt_lo                ; sets scale 
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
; high score stuff
                    ldu      #highscorelabel 
                    lda      #$F0 
                    ldb      -#127 
                    jsr      Print_Str_d 
                    ldx      #score 
                    ldu      #Vec_High_Score 
                    jsr      New_High_Score 
                    ldu      #Vec_High_Score 
                    ldd      #$F050 
                    jsr      Print_Str_d 
                    jsr      Read_Btns 
                    lda      Vec_Button_1_3 
                    lbne     restart 
                    bra      gameover 

levelsplash 
                    clr      stallcnt 
                                                          ; ldd #$F850 
                                                          ; std Vec_Text_HW 
splashloop 
                    jsr      Wait_Recal 
                    clr      Vec_Misc_Count 
                    lda      #$80 
                    sta      VIA_t1_cnt_lo 
                    jsr      Intensity_7F 
                    ldd      # 'L'*256+'E'
                    std      lvlstr 
                    ldd      # 'V'*256+'E'
                    std      lvlstr+2 
                    ldd      # 'L'*256+$20
                    std      lvlstr+4 
                    lda      #$20 
                    sta      levelstr 
                    lda      level 
                    cmpa     #100 
                    blt      do_level 
                    lda      #$6C                         ; infinity sign 
                    sta      levelstr+1 
                    bra      score_format_done 

do_level 
; parse level into chars  $30-$39 0-9
                    lda      level 
                    cmpa     #9 
                    ble      one_digit 
                    ldb      #$30 
                    stb      levelstr 
tens_digit 
                    suba     #10 
                    inc      levelstr 
                    cmpa     #9 
                    bgt      tens_digit 
one_digit 
                    adda     #$30 
                    sta      levelstr+1 
score_format_done 
                    lda      #$80 
                    sta      lvlstrterm 
                    ldu      #lvlstr 
                    lda      -20 
                    ldb      -10 
                    jsr      Print_Str_d 
                    inc      stallcnt 
                    lda      stallcnt 
                    cmpa     #100 
                    beq      donesplash 
                    bra      splashloop 

donesplash 
                    lda      level 
                    cmpa     #30 
                    blt      do_cnt_tbl 
                    lda      #255 
                    bra      store_max_enemy_cnt 

do_cnt_tbl 
                    ldx      #enemylvlcnt_t 
                    lda      level 
                    lda      a,x 
store_max_enemy_cnt 
                    sta      enemylvlcnt 
                    inc      shipcnt                      ; free ship 
                    jsr      setuplevel 
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
                    cmpa     #100                         ; 2 seconds 
                    beq      donedeathloop 
                    jmp      deathloop 

donedeathloop 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
titleScreen: 
                    LDA      #-1                          ; high bit set by any negative number 
                    STA      Vec_Expl_Flag                ; set high bit for Explosion flag 
                    LDA      #-40                         ; init values above tsmain 
                    STA      shipXpos 
                    LDA      #10 
                    STA      shipYpos 
                    LDA      #200                         ; 'counter' for display of logo, 4 seconds 
                    STA      temp 
                    LDU      #ustacktemp                  ; save text w/h to stack 
                    LDD      Vec_Text_HW 
                                                          ; LDB Vec_Text_Width 
                    PSHU     d 
                    STU      ustacktempptr 
_tsmain 
                    JSR      DP_to_C8                     ; DP to RAM 
                    LDU      #LOGOEXP                     ; point to explosion table entry 
                    JSR      Explosion_Snd 
                    JSR      Wait_Recal                   ; Vectrex BIOS recalibration 
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                                                          ; vector beam to $5f 
                    JSR      Do_Sound 
                    LDA      temp 
                    BEQ      _tsdone 
                    DEC      temp 
                    LDA      shipYpos                     ; Text position relative Y 
                    LDB      shipXpos                     ; Text position relative X 
                    JSR      Moveto_d 
                    LDA      #-10 
                    STA      Vec_Text_Height 
                    LDA      #$40 
                    STA      Vec_Text_Width 
                    LDU      #alleyanxietylogo_data 
                    JSR      draw_raster_image 
                    LDA      shipYpos                     ; jiggle animation logic 
                    CMPA     #10 
                    BEQ      _incYPOS 
                    DEC      shipYpos 
                    BRA      _tsmain 

_incYPOS 
                    INC      shipYpos 
                    BRA      _tsmain                      ; and repeat forever 

_tsdone 
                    LDU      ustacktempptr                ; loading 2 registers off U stack 
                    PULU     d 
                    STD      Vec_Text_HW                  ; restoring 
                                                          ;STB Vec_Text_Width 
                    STU      ustacktempptr                ; save for later 
                    LDA      #0 
                    STA      Vec_Music_Flag 
                    STA      Vec_Expl_Flag 
                    JSR      Clear_Sound 
                    RTS      
