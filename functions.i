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
                    ldx      #score 
                    jsr      Clear_Score 
                    lda      #1 
                    sta      level 
                    bsr      setuplevel 
                    rts      

setuplevel: 
                    ldd      #$FC50 
                    std      Vec_Text_HW

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
                    sta      alley0sd 
                    sta      alley1sd 
                    sta      alley2sd 
                    sta      alley3sd 
                    sta      alley4sd 
                    sta      alley5sd 
                    sta      alley6sd 
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
                    sta      frm4cnt 
                    sta      frm3cnt 
                    sta      frm2cnt 
                    sta      fmt1cnt 
                    sta      fmt0cnt 
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
                    sta      Demo_Mode 
                    sta      Ship_Dead 
                    sta      Level_Done 
                    sta      Line_Pat 
                    inc      Line_Pat                     ; never want this 0 based on how it works on ROL 
                    rts      

newlevel: 
                    inc      level 
                    jsr      levelsplash 
                    rts      

; ##########################################################################
gameover:                                                 ;        #isfunction 
;                    ldx      #score 
;                    ldu      #Vec_High_Score 
;                    jsr      New_High_Score 
                    jsr      check_highscore_entry 
                    jmp      print_hs_tbl 				; no RTS don't use jsr
goloop: 
                    jsr      Wait_Recal 
                    clr      Vec_Misc_Count 
                    lda      #$7F 
                    sta      VIA_t1_cnt_lo                ; sets scale 
                    jsr      Intensity_7F 
                    RESET0REF  
                    lda      #70 
                    ldb      #-15 
                    ldu      #gameoverstr 
                    jsr      Print_Str_d 
                    RESET0REF  
                    lda      #-50 
                    ldb      #-50 
                    ldu      #score 
                    jsr      Print_Str_d 
; high score stuff
                    ldu      #highscorelabel 
                    lda      #$F0 
                    ldb      -#127 
                    jsr      Print_Str_d 
                                                          ; ldu #Vec_High_Score 
                                                          ; ldd #$F050 
                                                          ; jsr Print_Str_d 
; print name example
                    ldx      #hsentryn_t 
                    ldu      ,x 
                    ldd      #$D400 
                    jsr      Print_Str_d 
; print name example
                    ldx      #hsentrys_t 
                    ldu      ,x 
                    ldd      #$D4B0 
                    jsr      Print_Str_d 
                    jsr      Read_Btns 
                    lda      Vec_Button_1_3 
                    lbne     restart 
                    bra      goloop 

;################################################################
levelsplash 
                    clr      stallcnt 
splashloop 
                    jsr      Wait_Recal 
                    clr      Vec_Misc_Count 
                    lda      #$80 
                    sta      VIA_t1_cnt_lo 
                    jsr      Intensity_7F 
                    ldd      # 'L'*256+'E'
                    std      lvllabelstr 
                    ldd      # 'V'*256+'E'
                    std      lvllabelstr+2 
                    ldd      # 'L'*256+$20
                    std      lvllabelstr+4 
                    lda      #$20 
                    sta      levelstr 
                    lda      level 
                    cmpa     #100 
                    blt      do_level 
                    lda      #$6C                         ; infinity sign 
                    sta      levelstr+1 
                    bra      score_format_done 

; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
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
                    lda      #$80 
                    sta      levelstr+2 
score_format_done 
                    ldu      #lvllabelstr 
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

;**********************************************************************
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
                    lda      #-20 
                    ldb      #-10 
                    jsr      Print_Str_d 
; ships left?
                    lda      #-50 
                    ldb      #65 
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
                    LDU      ustacktempptr                  ; save text w/h to stack 
                    LDD      Vec_Text_HW 
                                                          ; LDB Vec_Text_Width 
                    PSHU     d 
				  stu      ustacktempptr

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
				  sta      Vec_Expl_Chans
				  sta      Vec_Expl_1	 
				  sta      Vec_Expl_2
				  sta      Vec_Expl_3
				  sta      Vec_Expl_4
				  sta      Vec_Expl_Chan
				  sta      Vec_Expl_ChanA
				  sta      Vec_Expl_ChanB
				  sta      Vec_Expl_Timer
                    JSR      Clear_Sound 
                    rts      

;&&&&&&&&&&&&&&&%%%%%%%
joystick_config 
                    lda      #10 
                    sta      temp1 
                    lda      #$FF 
                    sta      Vec_Counter_1 
                    lda      #0 
                    sta      conf_box_index 
                    sta      frm10cnt 
                    inca     
                    sta      shipspeed 
conf_loop 
                    jsr      Wait_Recal 
                    jsr      Intensity_5F 
                    lda      frm10cnt 
                    bne      jsdoneYcal 
                    jsr      Joy_Digital 
                    nop      
                    lda      Vec_Joy_1_Y 
                    beq      jsdoneYcal                   ; no Y motion 
                    bmi      going_down_conf 
                    lda      conf_box_index 
                    beq      jsdoneYcal                   ; 0 is highest slot on screen !move 
                    dec      conf_box_index 
                    bra      jsdoneYcal 

going_down_conf 
                    lda      conf_box_index 
                    cmpa     #3                           ; 3 is lowest slot on screen !move 
                    beq      jsdoneYcal 
                    inc      conf_box_index 
jsdoneYcal 
                    jsr      Read_Btns 
                    lda      Vec_Button_1_4 
                    beq      no_press_cal 
                    jmp      conf_done 

no_press_cal 
                    RESET0REF  
                    lda      #110 
                    ldb      #-80 
                    ldu      #joycal_label 
                    jsr      Print_Str_d 
                    lda      #90 
                    ldb      #-33 
                    ldu      #fast_text 
                    jsr      Print_Str_d 
                    lda      #78 
                    ldb      #-43 
                    ldu      #med_text 
                    jsr      Print_Str_d 
                    lda      #66 
                    ldb      #-33 
                    ldu      #slow_text 
                    jsr      Print_Str_d 
                    lda      #54 
                    ldb      #-60 
                    ldu      #vslow_text 
                    jsr      Print_Str_d 
                    RESET0REF  
                    lda      conf_box_index 
                    ldx      #cboxYpos_t 
                    lda      a,x 
                    ldb      #-59 
                    MOVETO_D  
                    ldx      #Conf_Box_nomode 
                    DRAW_VLC  
                    lda      #10 
                    inc      frm10cnt 
                    cmpa     frm10cnt 
                    bne      no10cntresetC 
                    clr      frm10cnt 
no10cntresetC 
                    jsr      Dec_3_Counters 
                    tst      Vec_Counter_1 
                    bne      keepgoing 
                    dec      temp1 
                    beq      do_demo 
                    lda      #$FF 
                    sta      Vec_Counter_1 
keepgoing 
                    bra      conf_loop 

do_demo             inc      Demo_Mode 
                    jmp      restart 

conf_done 
                    lda      conf_box_index 
                    inca     
                    sta      shipspeed                    ; ship verical speed 
                    rts      

;***************    ********************************************************************** 
check_highscore_entry: 
                    ldd      #$9411                       ; change refresh rate 
                    std      Vec_Rfrsh 
; score compare see if we even need to do this
                    ldx      #hsentrys_t 
                    ldx      4,x                          ; check lowest entry 
                    ldu      #score 
                    jsr      Compare_Score                ; result in A 
                    cmpa     #2 
                    lbne     hs_check_done                ; 0 = same | 1 = x > u | 2 = x < u == new highscore 
                    lda      #0 
                    sta      hs_box_Yindex 
                    sta      hs_box_Xindex 
                    sta      frm5cnt 
                    sta      hsentry_index
				  sta      temp1 
hs_loop 
                    jsr      Wait_Recal 
                    jsr      Intensity_5F 
                    lda      frm5cnt 
                    lbne      hsbtn3_done                  ; joystick movement delay 
                    jsr      Joy_Digital 
; Y stick poll    
                    lda      Vec_Joy_1_Y 
                    beq      jsdoneYhs                    ; no Y motion 
                    bmi      going_down_hs
				  lda      #50 
				  sta      temp1 
                    lda      hs_box_Yindex 
                    beq      jsdoneYhs                    ; 0 is highest slot on screen !move 
                    dec      hs_box_Yindex 
                    bra      jsdoneYhs 

going_down_hs 
				  lda      #50 
				  sta      temp1
                    lda      hs_box_Yindex 
                    cmpa     #5                           ; 5 is lowest row on screen !move 
                    beq      jsdoneYhs 
                    inc      hs_box_Yindex 
jsdoneYhs 
; X stick poll    
                    lda      Vec_Joy_1_X 
                    beq      jsdoneXhs                    ; no X motion 
                    bmi      going_left_hs
				  lda      #50 
				  sta      temp1 
                    lda      hs_box_Xindex 
                    cmpa     #5 
                    beq      jsdoneXhs                    ; 5 is highest slot on screen !move 
                    inc      hs_box_Xindex 
                    bra      jsdoneXhs 

going_left_hs 
				  lda      #50 
				  sta      temp1
                    lda      hs_box_Xindex 
                    beq      jsdoneXhs 
                    dec      hs_box_Xindex 
jsdoneXhs 
; Buttons!!!
                    jsr      Read_Btns 
                    lda      Vec_Button_1_4 
                    beq      hsbtn4_done 
                    lda      hsentry_index 
                    cmpa     #3                           ; did 3 chars for HS, now SAVE 
                    lbeq     doHSsave 
                    lda      hs_box_Yindex 
                    lsla     
                    ldx      #hsgridrow 
                    ldx      a,x 
                    lda      hs_box_Xindex 
                    lda      a,x 
                    ldx      #hstempstr 
                    ldb      hsentry_index 
                    sta      b,x 
                    inc      hsentry_index 
				  lda      #50 
				  sta      temp1
hsbtn4_done 
                    lda      Vec_Button_1_3 
                    beq      hsbtn3_done 
                    lda      hsentry_index 
                    beq      hsbtn3_done                  ; already at start can't go back more 
                    dec      hsentry_index                ; go back one space left 
                    lda      #$5F                         ; load underscore char 
                    ldx      #hstempstr 
                    ldb      hsentry_index 
                    sta      b,x                          ; over write char
				  lda      #50 
				  sta      temp1 
hsbtn3_done 
; end INPUT handling
hsgridxpos          =        -59 
                    lda      #100 
                    ldb      #hsgridxpos 
                    ldu      #hs_abc_1 
                    jsr      Print_Str_d 
                    lda      #88 
                    ldb      #hsgridxpos 
                    ldu      #hs_abc_2 
                    jsr      Print_Str_d 
                    lda      #76 
                    ldb      #hsgridxpos 
                    ldu      #hs_abc_3 
                    jsr      Print_Str_d 
                    lda      #64 
                    ldb      #hsgridxpos 
                    ldu      #hs_abc_4 
                    jsr      Print_Str_d 
                    lda      #52 
                    ldb      #hsgridxpos 
                    ldu      #hs_abc_5 
                    jsr      Print_Str_d 
                    lda      #40 
                    ldb      #hsgridxpos 
                    ldu      #hs_abc_6 
                    jsr      Print_Str_d 
; test 
                    lda      #-50 
                    ldb      #-30 
                    ldu      #hstempstr 
                    jsr      Print_Str_d 
; test done
                    RESET0REF  
                    lda      hs_box_Yindex 
                    ldx      #hsboxYpos_t 
                    lda      a,x 
                    ldb      hs_box_Xindex 
                    ldx      #hsboxXpos_t 
                    ldb      b,x 
                    MOVETO_D  
                    ldx      #Letter_Select_nomode 
                    DRAW_VLC  
                    RESET0REF  
                    lda      #25 
                    inc      frm25cnt 
                    cmpa     frm25cnt 
                    bne      no25cntresetHS 
                    ldb      hsentry_index 
                    cmpb     #3 
                    beq      cursorchange_done 
                    ldx      #hstempstr 
                    ldb      hsentry_index 
                    lda      b,x 
                    cmpa     #$20 
                    beq      change_underscore 
                    lda      #$20 
                    sta      b,x 
                    bra      cursorchange_done 

change_underscore 
                    lda      #$5F 
                    sta      b,x 
cursorchange_done 
                    clr      frm25cnt 
no25cntresetHS 
                    lda      #10 
                    inc      frm5cnt 
                    cmpa     frm5cnt 
                    bne      no5cntresetHS 
                    clr      frm5cnt 
no5cntresetHS

;show_inst
                    RESET0REF  
                    ldd      Vec_Text_HW 
                    pshs     d 
                    ldd      #$FE40 
                    std      Vec_Text_HW 

				  lda      #117
				  ldb      #-60
				  ldu      #newhslabel
				  jsr      Print_Str_d

				  lda      temp1					    ; timer to hide instructions
				  beq      show_inst
				  dec      temp1
			       bne      no_ent_inst
show_inst
                    lda      #-110 
                    ldb      #-120 
                    ldu      #press_btn3_text 
                    jsr      Print_Str_d 
                    lda      #-120 
                    ldb      #-120 
                    ldu      #press_btn4_text 
                    jsr      Print_Str_d 
no_ent_inst
                    puls     d 
                    std      Vec_Text_HW
 
                    jmp      hs_loop 

doHSsave                                                  ;        finished HS entry 
;   hsentryXn = initials  hsentryXs = score
; tables  hsentryn_t      hsentrys_t   
; table has 5 slots for scores
; #hstempstr holds entered initials
                    lda      #4                           ; top 5 zero index 
                    sta      temp1 
hs_test_loop 
; score compare
                    lda      temp1 
                    lsla     
                    ldx      #hsentrys_t 
                    ldx      a,x 
                    ldu      #score 
                    jsr      Compare_Score                ; result in A 
                    cmpa     #2 
                    bne      hs_check_done                ; 0 = same | 1 = x > u | 2 = x < u == new highscore 
; remember indexes: top score == 0 5th = 4
; first copy current slot score to one slot higher in source index 0-3 only, discard on 4 
hs_copy_outer_loop 
                    lda      temp1 
                    cmpa     #4 
                    beq      no_copy_score 
                    lda      temp1 
                    lsla     
                    ldy      #hsentrys_t 
                    ldy      a,y                          ; Y = source 
                    inca     
                    inca     
                    ldx      #hsentrys_t 
                    ldx      a,x                          ; X = target 
hs_copy_old_down_1_loop 
                    lda      ,y+                          ; increments AFTER apparently!! 
                    sta      ,x+ 
                    bpl      hs_copy_old_down_1_loop 
                    lda      temp1 
                    lsla     
                    ldy      #hsentryn_t 
                    ldy      a,y                          ; Y = source 
                    inca     
                    inca     
                    ldx      #hsentryn_t 
                    ldx      a,x                          ; X = target 
hsn_copy_old_down_1_loop 
                    lda      ,y+                          ; increments AFTER apparently!! 
                    sta      ,x+ 
                    bpl      hsn_copy_old_down_1_loop 
no_copy_score 
;
                    lda      temp1 
                    lsla     
                    ldy      #score                       ; Y = source 
                    ldx      #hsentrys_t 
                    ldx      a,x                          ; X = target 
hs_copy_loop 
                    lda      ,y+                          ; increments AFTER apparently!! 
                    sta      ,x+ 
                    bpl      hs_copy_loop 
; NAME 2nd 
                    lda      temp1 
                    lsla     
                    ldy      #hstempstr                   ; from user input above 
                    ldx      #hsentryn_t 
                    ldx      a,x 
hsn_copy_loop 
                    lda      ,y+                          ; increments AFTER apparently!! 
                    sta      ,x+ 
                    bpl      hsn_copy_loop 
                    dec      temp1 
                    jmp      hs_test_loop 

hs_check_done 
                    rts      

;; populate hs table ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fill_hs_tbl: 
;name
                    ldb      #4                           ; 5 entries, 0 index 
                    lslb                                  ; 2 btye table 
get_nentry 
                    ldx      #hsentryn_t 
                    ldx      b,x 
                    ldy      #default_name 
_fill_nloop 
                    lda      ,y+ 
                    sta      ,x+ 
                    bpl      _fill_nloop                  ; $80 is string char terminator, also negative 
                    decb     
                    decb     
                    bpl      get_nentry 
; score    
                    ldb      #4                           ; 5 entries, 0 index 
                    lslb     
get_sentry 
                    ldx      #hsentrys_t 
                    ldx      b,x 
                    ldy      #default_high 
_fill_sloop 
                    lda      ,y+ 
                    sta      ,x+ 
                    bpl      _fill_sloop 
                    decb     
                    decb     
                    bpl      get_sentry 
                    rts      

;))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
print_hs_tbl 
                    lda      #2 
                    sta      temp1 
_keepshow 
                    jsr      Wait_Recal 
                    jsr      Intensity_5F 
                    ldd      #$7DC0 
                    ldu      #highscorelabel 
                    jsr      Print_Str_d 
                    ldb      #4 
_hsprtloop 
; first initials
                    lslb                                  ; double for 2 byte table 
                    ldx      #hsentryn_t 
                    ldu      b,x                          ; putting u value in first then D 
                    lsrb     
                    pshs     b 
                    ldx      #hsentrynYpos_t 
                    lda      b,x 
                    ldb      #-85 
                    jsr      Print_Str_d 
                    RESET0REF                             ; trashes d 
                    puls     b                            ; restore b 
; now names
                    lslb                                  ; double for 2 byte table 
                    ldx      #hsentrys_t 
                    ldu      b,x                          ; putting u value in first then D 
                    lsrb     
                    pshs     b 
                    ldx      #hsentrynYpos_t              ; same Y so they line up 
                    lda      b,x 
                    ldb      #10 
                    jsr      Print_Str_d 
                    puls     b                            ; restore b 
                    decb                                  ; next one up. 
                    bpl      _hsprtloop 
                    jsr      Read_Btns 
                    lda      Vec_Button_1_3 
                    lbne     restart                      ; break out 
; count down to next screen without button press
                    jsr      Dec_3_Counters 
                    tst      Vec_Counter_1 
                    bne      keepgoinghs 
                    dec      temp1 
                    beq      do_demohs 
                    lda      #$FF 
                    sta      Vec_Counter_1 
keepgoinghs 
                    bra      _keepshow 

do_demohs           inc      Demo_Mode 
                    jsr      titleScreen                  ; remove until cause of crash is figured out
                    jmp      restart 

                                                          ; bra _keepshow 
                    rts      

;((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
sort_hs_tbl 
                    rts      
