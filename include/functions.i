;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; vim: ts=4 syntax=asm6809 foldmethod=marker fdo-=search
;###########################################################################
; SUBROUTINES/FUNCTIONS
;###########################################################################
;{{{ setup ;        setting up hardware, resetting scores, once per boot 
setup: 
                    lda      select_level_flag 
                    bne      no_level_set 
                    lda      #1 
                    sta      level 
no_level_set 
                    lda      #1                           ; enable 
                    sta      Vec_Joy_Mux_1_X 
                    lda      #3 
                    sta      Vec_Joy_Mux_1_Y 
                    lda      #0                           ; disable for Joy Mux's 
                    sta      Vec_Joy_Mux_2_X 
                    sta      Vec_Joy_Mux_2_Y 
                    ldx      #score 
                    jsr      Clear_Score 
                    ldx      #running_score 
                    jsr      Clear_Score 
;                    bsr      setuplevel 
;                    rts      
setuplevel: 
                    ldd      #$FC50 
                    std      Vec_Text_HW 
                    ldd      #0                           ; set a bunch of variables to 0 , no rush don't optimize 
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
                    sta      shipYdir 
                    sta      warpdelay 
                    sta      Ship_Dead 
                    sta      Level_Done 
                    sta      Line_Pat 
                    inc      Line_Pat                     ; never want this 0 based on how it works on ROL 
                    lda      Super_Game 
                    beq      not_superg 
                    lda      #1 
                    sta      smartbombcnt 
not_superg 
                    rts      

newlevel: 
                    lda      Demo_Mode 
                    bne      _no_add_lvl 
                    inc      level 
                    jsr      levelsplash 
_no_add_lvl 
                    rts      

;}}}
;{{{ gameover:   what to do when gameover #####################
gameover: 
                    lda      Demo_Mode 
                    bne      _no_chk_hs 
                    jsr      check_highscore_entry 
_no_chk_hs 
                    jmp      print_hs_tbl                 ; no RTS don't use jsr 

;}}}      
;{{{ levelsplash: bridge screen between levels
levelsplash: 
                    jsr      Clear_Sound 
                    clr      stallcnt 
                    lda      #0 
                    sta      top0 
                    lda      #33 
                    sta      top1 
                    lda      #66 
                    sta      top2 
; for 3D ship use 
Y_3d=temp1 
bright3d=temp2 
scale3d=temp3 
                    lda      #-1                          ; high bit set by any negative number 
                    sta      Vec_Expl_Flag                ; set high bit for Explosion flag 
                    ldd      #0 
                    std      temp 
                    std      temp2 
; end 3D
                    lda      #127 
                    sta      scale3d 
                    nega     
                    sta      Y_3d 
; don't check this when TESTING!! 
                    lda      Demo_Mode 
                    lbne     dundo_demo 
splashloop 
                    jsr      DP_to_C8                     ; DP to RAM 
                    ldu      #EXP4                        ; point to explosion table entry 
                    jsr      Explosion_Snd 
                    jsr      Wait_Recal 
                    clr      Vec_Misc_Count 
                    lda      #$80                         ; scale 128 
                    sta      VIA_t1_cnt_lo 
                    jsr      Intensity_7F 
                    ldd      # 'L'*256+'E' ; "LEVEL "
                    std      lvllabelstr 
                    ldd      # 'V'*256+'E'
                    std      lvllabelstr+2 
                    ldd      # 'L'*256+$20
                    std      lvllabelstr+4 
                    lda      #$20 
                    sta      levelstr 
                    lda      level 
                    cmpa     #100 
                    blt      do_level                     ; if level over 99 
                    lda      #$6C                         ; just show infinity sign 
                    sta      levelstr+1 
                    lda      #$80 
                    sta      levelstr+2 
                    bra      _score_format_done 

do_level 
; parse level into chars  $30-$39 0-9
                    lda      level 
                    cmpa     #9 
                    ble      ones_digit 
                    ldb      #$30 
                    stb      levelstr 
tens_digit 
                    suba     #10 
                    inc      levelstr 
                    cmpa     #9 
                    bgt      tens_digit 
ones_digit 
                    adda     #$30 
                    sta      levelstr+1 
                    lda      #$80 
                    sta      levelstr+2 
_score_format_done 
                    ldu      #lvllabelstr 
                    lda      #-0 
                    ldb      #-49 
                                                          ;jsr Print_Str_d 
                    PRINT_STR_D  
; staRT "3D moving Hallway" thing
; Lines from center to edge
;                    jsr      Intensity_5F 
; first box
                    lda      top0 
                    jsr      Intensity_a 
                    RESET0REF  
                    lda      top0 
                    ldb      top0 
                    negb     
                    jsr      Moveto_d 
;
                    clra                                  ; Y movement 
                    ldb      top0                         ; X movement 
                    jsr      Draw_Line_d 
                    clra                                  ; Y movement 
                    ldb      top0                         ; X movement 
                    jsr      Draw_Line_d 
;
                    clrb                                  ; Y movement 
                    lda      top0                         ; X movement 
                    nega     
                    jsr      Draw_Line_d 
                    clrb                                  ; Y movement 
                    lda      top0                         ; X movement 
                    nega     
                    jsr      Draw_Line_d 
;
                    clra                                  ; Y movement 
                    ldb      top0                         ; X movement 
                    negb     
                    jsr      Draw_Line_d 
                    clra                                  ; Y movement 
                    ldb      top0 
                    negb                                  ; X movement 
                    jsr      Draw_Line_d 
;
                    clrb                                  ; Y movement 
                    lda      top0                         ; X movement 
                    jsr      Draw_Line_d 
                    clrb                                  ; Y movement 
                    lda      top0                         ; X movement 
                    jsr      Draw_Line_d 
; 2nd box
                    RESET0REF  
                    lda      top1 
                    jsr      Intensity_a 
                    lda      top1 
                    ldb      top1 
                    negb     
                    jsr      Moveto_d 
;
                    clra                                  ; Y movement 
                    ldb      top1                         ; X movement 
                    jsr      Draw_Line_d 
                    clra                                  ; Y movement 
                    ldb      top1                         ; X movement 
                    jsr      Draw_Line_d 
;
                    clrb                                  ; Y movement 
                    lda      top1                         ; X movement 
                    nega     
                    jsr      Draw_Line_d 
                    clrb                                  ; Y movement 
                    lda      top1                         ; X movement 
                    nega     
                    jsr      Draw_Line_d 
;
                    clra                                  ; Y movement 
                    ldb      top1                         ; X movement 
                    negb     
                    jsr      Draw_Line_d 
                    clra                                  ; Y movement 
                    ldb      top1 
                    negb                                  ; X movement 
                    jsr      Draw_Line_d 
;
                    clrb                                  ; Y movement 
                    lda      top1                         ; X movement 
                    jsr      Draw_Line_d 
                    clrb                                  ; Y movement 
                    lda      top1                         ; X movement 
                    jsr      Draw_Line_d 
; 3rd box
                    RESET0REF  
                    lda      top2 
                    jsr      Intensity_a 
                    lda      top2 
                    ldb      top2 
                    negb     
                    jsr      Moveto_d 
;
                    clra                                  ; Y movement 
                    ldb      top2                         ; X movement 
                    jsr      Draw_Line_d 
                    clra                                  ; Y movement 
                    ldb      top2                         ; X movement 
                    jsr      Draw_Line_d 
;
                    clrb                                  ; Y movement 
                    lda      top2                         ; X movement 
                    nega     
                    jsr      Draw_Line_d 
                    clrb                                  ; Y movement 
                    lda      top2                         ; X movement 
                    nega     
                    jsr      Draw_Line_d 
;
                    clra                                  ; Y movement 
                    ldb      top2                         ; X movement 
                    negb     
                    jsr      Draw_Line_d 
                    clra                                  ; Y movement 
                    ldb      top2 
                    negb                                  ; X movement 
                    jsr      Draw_Line_d 
;
                    clrb                                  ; Y movement 
                    lda      top2                         ; X movement 
                    jsr      Draw_Line_d 
                    clrb                                  ; Y movement 
                    lda      top2                         ; X movement 
                    jsr      Draw_Line_d 
; check loops below till end
                    inc      top0 
                    lda      #127 
                    cmpa     top0 
                    bne      top0ok 
                    clra     
                    sta      top0 
top0ok 
                    inc      top1 
                    lda      #127 
                    cmpa     top1 
                    bne      top1ok 
                    clra     
                    sta      top1 
top1ok 
                    inc      top2 
                    lda      #127 
                    cmpa     top2 
                    bne      top2ok                       ; OOPS where do we go?? 
                    clra     
                    sta      top2 
top2ok 
; END of "Moving 3D Hallway" thing 
; 3-D Ship
                    RESET0REF  
                    lda      scale3d                      ; change to bright3d eventually. 
                    jsr      Intensity_a                  ; maybe reduce this as we scale smaller 
                    lda      Y_3d 
                    inc      Y_3d 
                    clrb     
                    tfr      d,x                          ; X=screen position y,x 
                    lda      #$F7                         ; A=MOVE scale B=Image scale 
                    ldb      scale3d 
                    ldu      #ShipIn3D_1 
                    jsr      draw_synced_list 
;
                    dec      scale3d 
                    inc      stallcnt 
                    lda      stallcnt 
                    cmpa     #100 
                    beq      donesplash 
                    jsr      Do_Sound 
                    lbra     splashloop 

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
dundo_demo 
                    jsr      Clear_Sound 
                    jsr      setuplevel 
                    jsr      SfxInit 
                    rts      

;}}}
;{{{ deathsplash when you're dead (currently never called) *******************
; looks like this as intended to be called when your shit died which I am doing inline not
; reuse for GAMEOVER??
;deathsplash: 
;                    clr      stallcnt 
;tempshipcnt         =        temp 
;deathloop 
;                    jsr      Wait_Recal 
;                    clr      Vec_Misc_Count 
;                    lda      #$80 
;                    sta      VIA_t1_cnt_lo 
;                    jsr      Intensity_7F 
; dead
;                    ldu      #deadstring                   
;                    lda      #-20 
;                    ldb      #-10 
;                    jsr      Print_Str_d 
; ships left?
;                    lda      #-50 
;                    ldb      #65 
;                    MOVETO_D  
;                    lda      shipcnt                      ; vector draw ships remaining routine TEST 
;                    beq      no_ships 
;                    sta      tempshipcnt 
;ships_left_loop1 
;                   ldx      #Ship_Marker 
;                    DRAW_VLC  
;                    dec      tempshipcnt 
;                    bne      ships_left_loop1 
;no_ships 
;                    inc      stallcnt 
;                    lda      stallcnt 
;                    cmpa     #100                         ; 2 seconds 
;                    beq      donedeathloop 
;                    jmp      deathloop 
;donedeathloop 
;                    rts      
;}}}
;{{{ titlescreen:  shaky screen thing
titleScreen: 
titlesfxcnt         =        temp 
logobrightness      =        temp2 
                    lda      #-1                          ; high bit set by any negative number 
                    sta      Vec_Expl_Flag                ; set high bit for Explosion flag 
                    lda      #-64                         ; init values above tsmain 
                    sta      shipXpos 
                    lda      #10 
                    sta      shipYpos 
                    lda      #200                         ; 'counter' for display of logo, 4 seconds 
                    sta      titlesfxcnt 
                    ldu      ustacktempptr                ; save text w/h to stack 
                    ldd      Vec_Text_HW 
                    pshu     d 
                    stu      ustacktempptr 
                    clr      logobrightness 
_tsmain 
                    jsr      DP_to_C8                     ; DP to RAM 
                    ldu      #LOGOEXP                     ; point to explosion table entry 
                    jsr      Explosion_Snd 
                    jsr      Wait_Recal                   ; Vectrex BIOS recalibration 
                    lda      logobrightness               ; fade logo in 
                    cmpa     #127 
                    beq      fullbright 
                    inc      logobrightness 
fullbright 
                    jsr      Intensity_a                  ; Sets the intensity of the 
                    jsr      Do_Sound 
                    lda      titlesfxcnt 
                    beq      _tsdone 
                    dec      titlesfxcnt 
                    lda      shipYpos                     ; Text position relative Y 
                    ldb      shipXpos                     ; Text position relative X 
                    jsr      Moveto_d 
                    lda      #-10 
                    sta      Vec_Text_Height 
                    lda      #$40 
                    sta      Vec_Text_Width 
;                    ldu      #alleyanxietylogo_data
                    ldu      #AALogo2021_data 
                    jsr      draw_raster_image 
                    lda      logobrightness               ; check if logo is full bright if not don't shake yet 
                    cmpa     #127 
                    bne      notfullbrightyet 
                    lda      shipYpos                     ; jiggle animation logic 
                    cmpa     #10 
                    beq      _incYPOS 
                    dec      shipYpos 
                    bra      _tsmain 

_incYPOS 
                    inc      shipYpos 
notfullbrightyet 
                    bra      _tsmain                      ; and repeat forever 

_tsdone 
                    ldu      ustacktempptr                ; loading 2 registers off U stack 
                    pulu     d 
                    std      Vec_Text_HW                  ; restoring 
                    stu      ustacktempptr                ; save for later 
                    lda      #0 
                    sta      Vec_Music_Flag 
                    sta      Vec_Expl_Flag 
                    sta      Vec_Expl_Chans 
                    sta      Vec_Expl_1 
                    sta      Vec_Expl_2 
                    sta      Vec_Expl_3 
                    sta      Vec_Expl_4 
                    sta      Vec_Expl_Chan 
                    sta      Vec_Expl_ChanA 
                    sta      Vec_Expl_ChanB 
                    sta      Vec_Expl_Timer 
                    jsr      Clear_Sound 
                    rts      

;}}}
;{{{ general_config: main config screen
general_config: 
                    jsr      Clear_Sound 
                    lda      #10                          ; set up timeout counter 
                    sta      temp1                        ; 10 iterations of 
                    lda      #$FF 
                    sta      Vec_Counter_1                ;; 255 2550/30 = about 85 seconds 
                    lda      #0 
                    sta      conf_box_index               ; index to start at 0 
                    sta      frm10cnt 
gconf_loop 
                    jsr      Wait_Recal 
                    jsr      Intensity_5F 
                    jsr      Do_Sound_FX_C1 
                    lda      frm10cnt 
                    bne      gcdoneYcal 
                    jsr      Joy_Digital 
                    nop      
                    lda      Vec_Joy_1_Y 
                    beq      gcdoneYcal                   ; no Y motion 
                    bmi      going_down_gconf 
                    lda      conf_box_index 
                    beq      gcdoneYcal                   ; 0 is highest slot on screen !move 
                    dec      conf_box_index 
                    jsr      SFX_Bloop 
                    bra      gcdoneYcal 

going_down_gconf 
                    ldx      #Vec_High_Score 
                    ldu      #Score_50000 
                    jsr      Compare_Score 
                    cmpa     #1 
                    bne      dontallow4slots 
                    lda      conf_box_index 
                    cmpa     #4                           ; 4 is lowest slot on screen !move 
                    beq      gcdoneYcal 
                    bra      dolsinc 

dontallow4slots 
                    lda      conf_box_index 
                    cmpa     #3                           ; 3 is lowest slot on screen !move 
                    beq      gcdoneYcal 
dolsinc 
                    inc      conf_box_index 
                    jsr      SFX_Bloop 
gcdoneYcal 
                    jsr      Read_Btns 
                    lda      Vec_Button_1_4 
                    beq      no_press_gcal 
                    jmp      gconf_done 

no_press_gcal 
                    RESET0REF  
                    lda      #110 
                    ldb      #-115 
                    ldu      #confopt_label 
                    jsr      Print_Str_d 
                    lda      #90 
                    ldb      #-83 
                    ldu      #gamemode_label 
                    jsr      Print_Str_d 
                    lda      #78 
                    ldb      #-85 
                    ldu      #joycal_label 
                    jsr      Print_Str_d 
                    lda      #66 
                    ldb      #-83 
                    ldu      #hs_reset_label 
                    jsr      Print_Str_d 
                    lda      #54 
                    ldb      #-60 
                    ldu      #return_text 
                    jsr      Print_Str_d 
                    ldx      #Vec_High_Score              ; only show level select option if HS over 50k 
                    ldu      #Score_50000 
                    jsr      Compare_Score 
                    cmpa     #1 
                    bne      dontshowls 
                    lda      #40 
                    ldb      #-80 
                    ldu      #select_level_label 
                    jsr      Print_Str_d 
dontshowls 
                    RESET0REF  
                    lda      conf_box_index 
                    ldx      #cboxYpos_t                  ; add to cboxYpos_t for additonal menu entries 
                    lda      a,x 
                    ldb      #-79 
                    MOVETO_D  
                    lda      #160 
                    sta      VIA_t1_cnt_lo 
                    ldx      #GConf_Box_nomode 
                    DRAW_VLC  
                    RESET0REF  
                    lda      #-120 
                    ldb      #-120 
                    ldu      #select_btn4_text 
                    jsr      Print_Str_d 
                    lda      #10 
                    inc      frm10cnt 
                    cmpa     frm10cnt 
                    bne      no10cntresetGC 
                    clr      frm10cnt 
no10cntresetGC 
                    jsr      Dec_3_Counters 
                    tst      Vec_Counter_1 
                    bne      gckeepgoing 
                    dec      temp1 
                    beq      do_demogc 
                    lda      #$FF 
                    sta      Vec_Counter_1 
gckeepgoing 
                    lbra     gconf_loop 

do_demogc           lda      #1 
                    sta      Demo_Mode                    ; go back to demo mode because no keypress in 85 seconds 
                    jmp      gc_rts 

gconf_done 
; process keypresses if any
                    lda      conf_box_index               ; load selected menu item index 
                    cmpa     #0                           ; menu choice 1 game select 
                    bne      gctrynext1 
                    jsr      game_select 
                    jsr      write2eeprom                 ; save if there was a change 
                    jmp      gckeep_running 

gctrynext1 
                    cmpa     #1                           ; menu choice 2 Joystick config 
                    bne      gctrynext2 
                    jsr      joystick_config 
                    jsr      write2eeprom                 ; save if there was a change 
                    jmp      gckeep_running 

gctrynext2 
                    cmpa     #2                           ; EEPROM FORMAT MENU 
                    bne      gctrynext3 
                    jsr      format_eeprom_menu 
                    jmp      gckeep_running 

gctrynext3 
                    cmpa     #3 
                    bne      gctrynext4 
                    rts                                   ; exit! return to main 

gctrynext4 
                    cmpa     #4 
                    bne      gckeep_running 
                    jsr      select_level 
gckeep_running 
                    jmp      general_config 

gc_rts 
                    rts      

;}}}
;{{{ joystick_config: screen where we config joystick speed
joystick_config: 
                    lda      #10 
                    sta      temp1 
                    lda      #$FF 
                    sta      Vec_Counter_1 
                    lda      #0 
                    sta      frm10cnt 
                    lda      shipspeed 
                    deca     
                    sta      conf_box_index 
;                    inca     
;                    sta      shipspeed 
conf_loop 
                    jsr      Wait_Recal 
                    jsr      Intensity_5F 
                    jsr      Do_Sound_FX_C1 
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
                    jsr      SFX_Bloop 
                    bra      jsdoneYcal 

going_down_conf 
                    lda      conf_box_index 
                    cmpa     #3                           ; 3 is lowest slot on screen !move 
                    beq      jsdoneYcal 
                    inc      conf_box_index 
                    jsr      SFX_Bloop 
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
                    RESET0REF  
                    lda      #-120 
                    ldb      #-120 
                    ldu      #finish_btn4_text 
                    jsr      Print_Str_d 
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
                    lbra     conf_loop 

do_demo             lda      #1 
                    sta      Demo_Mode 
                    jmp      restart 

conf_done 
                    lda      conf_box_index 
                    inca     
                    sta      shipspeed                    ; ship verical speed 
;                    jsr      game_select 
                    rts      

;}}}
;{{{ game_select: select Classic or Super Game
game_select: 
                    lda      #10                          ; time out counters 
                    sta      temp1 
                    lda      #$FF 
                    sta      Vec_Counter_1 
                    clra     
                    sta      frm10cnt 
                    lda      Super_Game                   ; set counter to current game mode 
                    sta      conf_box_index 
gs_loop 
                    jsr      Wait_Recal 
                    jsr      Intensity_5F 
                    jsr      Do_Sound_FX_C1 
                    lda      frm10cnt 
                    bne      gsdoneYcal                   ; every 10 frames check joystick move 
                    jsr      Joy_Digital 
                    nop      
                    lda      Vec_Joy_1_Y 
                    beq      gsdoneYcal                   ; no Y motion 
                    bmi      going_down_gs 
                    lda      conf_box_index 
                    beq      gsdoneYcal                   ; 0 is highest slot on screen !move 
                    dec      conf_box_index 
                    jsr      SFX_Bloop 
                    bra      gsdoneYcal 

going_down_gs 
                    lda      conf_box_index 
                    cmpa     #1                           ; 1 is lowest slot on screen !move 
                    beq      gsdoneYcal 
                    jsr      SFX_Bloop 
                    inc      conf_box_index 
gsdoneYcal                                                ;        check 4 button, exist if pressed 
                    jsr      Read_Btns 
                    lda      Vec_Button_1_4 
                    beq      no_pressgs 
                    jsr      SFX_Pip 
                    jmp      gs_done 

no_pressgs                                                ;        print screen stuff here 
                    RESET0REF  
                    lda      #110 
                    ldb      #-81 
                    ldu      #gamesel_label 
                    jsr      Print_Str_d 
                    lda      #90 
                    ldb      #-62 
                    ldu      #reggame_text 
                    jsr      Print_Str_d 
                    lda      #78 
                    ldb      #-58 
                    ldu      #supergame_text 
                    jsr      Print_Str_d 
                    RESET0REF  
                    lda      conf_box_index 
                    ldx      #cboxYpos_t 
                    lda      a,x 
                    ldb      #-80 
                    MOVETO_D  
                    ldx      #Game_Sel_Box_nomode 
                    DRAW_VLC  
                    RESET0REF  
                    lda      #-120 
                    ldb      #-120 
                    ldu      #finish_btn4_text 
                    jsr      Print_Str_d 
                    lda      #10 
                    inc      frm10cnt 
                    cmpa     frm10cnt 
                    bne      no10cntresetD 
                    clr      frm10cnt 
no10cntresetD 
                    jsr      Dec_3_Counters 
                    tst      Vec_Counter_1 
                    bne      gskeepgoing 
                    dec      temp1 
                    beq      do_demogs 
                    lda      #$FF 
                    sta      Vec_Counter_1 
gskeepgoing 
                    lbra     gs_loop 

do_demogs           lda      #1 
                    sta      Demo_Mode 
                    jmp      restart 

gs_done 
                    lda      conf_box_index 
                    sta      Super_Game 
                    rts      

;}}}
;{{{ format_eeprom_menu: erase all highscores and settings from 2431
format_eeprom_menu: 
                    lda      #10 
                    sta      temp1 
                    lda      #$FF 
                    sta      Vec_Counter_1 
                    lda      #0 
                    sta      conf_box_index 
                    sta      frm10cnt 
fem_loop 
                    jsr      Wait_Recal 
                    jsr      Intensity_5F 
                    jsr      Do_Sound_FX_C1 
                    lda      frm10cnt 
                    bne      femdoneYcal 
                    jsr      Joy_Digital 
                    nop      
                    lda      Vec_Joy_1_Y 
                    beq      femdoneYcal                  ; no Y motion 
                    bmi      going_down_fem 
                    lda      conf_box_index 
                    beq      femdoneYcal                  ; 0 is highest slot on screen !move 
                    dec      conf_box_index 
                    jsr      SFX_Bloop 
                    bra      femdoneYcal 

going_down_fem 
                    lda      conf_box_index 
                    cmpa     #1                           ; 3 is lowest slot on screen !move 
                    beq      femdoneYcal 
                    jsr      SFX_Bloop 
                    inc      conf_box_index 
femdoneYcal 
                    jsr      Read_Btns 
                    lda      Vec_Button_1_4 
                    beq      no_pressfem 
                    jsr      SFX_Pip 
                    jmp      fem_done 

no_pressfem 
                    RESET0REF  
                    lda      #125 
                    ldb      #-71 
                    ldu      #confirm_text 
                    jsr      Print_Str_d 
                    lda      #112 
                    ldb      #-118 
                    ldu      #ee_warn1_label 
                    jsr      Print_Str_d 
                    lda      #102 
                    ldb      #-122 
                    ldu      #ee_warn2_label 
                    jsr      Print_Str_d 
;
                    lda      #80 
                    ldb      #-62 
                    ldu      #no_text 
                    jsr      Print_Str_d 
                    lda      #68 
                    ldb      #-58 
                    ldu      #yes_text 
                    jsr      Print_Str_d 
                    RESET0REF  
                    lda      conf_box_index 
                    ldx      #eeboxYpos_t 
                    lda      a,x 
                    ldb      #-60 
                    MOVETO_D  
                    ldx      #Game_Sel_Box_nomode 
                    DRAW_VLC  
                    RESET0REF  
                    lda      #-120 
                    ldb      #-120 
                    ldu      #finish_btn4_text 
                    jsr      Print_Str_d 
                    lda      #10 
                    inc      frm10cnt 
                    cmpa     frm10cnt 
                    bne      no10cntresetFEM 
                    clr      frm10cnt 
no10cntresetFEM 
                    jsr      Dec_3_Counters 
                    tst      Vec_Counter_1 
                    bne      femkeepgoing 
                    dec      temp1 
                    beq      do_demofem 
                    lda      #$FF 
                    sta      Vec_Counter_1 
femkeepgoing 
                    lbra     fem_loop 

do_demofem          lda      #1                           ; do on TIMEOUT only 
                    sta      Demo_Mode 
                    jmp      restart 

fem_done 
                    lda      conf_box_index               ; default = 0 don't format. 
                    beq      fem_noformat 
                    jsr      eeprom_format                ; over writes entire eeprom 
                    jsr      eeprom_load                  ; reload so it updates internal vars 
                    jsr      fill_hs_tbl_eeprom           ; then copy to working buffer 
;   add screen saying format successful?? on unsuccessful format would be misleading
fem_noformat 
                    rts      

;}}}
;{{{ select_level: select level?
select_level: 
                    lda      #10                          ; time out counters 
                    sta      temp1 
                    lda      #$FF 
                    sta      Vec_Counter_1 
                    clra     
                    sta      frm5cnt 
                    lda      #1                           ; set counter lvl 1 
                    sta      conf_box_index 
                    sta      select_level_flag 
                    ldd      ls_level_text 
                    std      ls_tens_tmp 
                    lda      #$80 
                    sta      ls_level_term 
ls_loop 
                    jsr      Wait_Recal 
                    jsr      Intensity_5F 
                    jsr      Do_Sound_FX_C1 
                    lda      frm5cnt 
                    bne      lsdoneYcal                   ; every 10 frames check joystick move 
                    jsr      Joy_Digital 
                    nop      
                    lda      Vec_Joy_1_Y 
                    beq      lsdoneYcal                   ; no Y motion 
                    bmi      going_down_ls 
                    lda      conf_box_index               ; stick going UP so increment level, if ... 
                    cmpa     #99 
                    beq      lsdoneYcal                   ; 99 highest level, bail out 
                    inc      conf_box_index 
                    lda      ls_ones_tmp                  ; ones digit 
                    cmpa     # '9'
                    beq      ls_tens_inc 
                    inca     
                    sta      ls_ones_tmp                  ; ones digit 
                    jmp      done_ls_ones_inc 

ls_tens_inc 
                    inc      ls_tens_tmp 
                    lda      # '0'
                    sta      ls_ones_tmp 
done_ls_ones_inc 
                    jsr      SFX_Bloop 
                    bra      lsdoneYcal 

going_down_ls 
                    lda      conf_box_index 
                    cmpa     #1                           ; 1 is lowest slot on screen !move 
                    beq      lsdoneYcal 
                    jsr      SFX_Bloop 
                    dec      conf_box_index 
                    lda      ls_ones_tmp 
                    cmpa     # '0'
                    beq      ls_tens_dec 
                    dec      ls_ones_tmp 
                    jmp      lsdoneYcal 

ls_tens_dec 
                    dec      ls_tens_tmp 
                    lda      # '9'
                    sta      ls_ones_tmp 
lsdoneYcal                                                ;        check 4 button, exist if pressed 
                    jsr      Read_Btns 
                    lda      Vec_Button_1_4 
                    beq      no_pressls 
                    jsr      SFX_Pip 
                    jmp      ls_done 

no_pressls                                                ;        print screen stuff here 
                    RESET0REF  
                    lda      #110 
                    ldb      #-81 
                    ldu      #select_level_label 
                    jsr      Print_Str_d 
                    lda      #90 
                    ldb      #-16 
                    ldu      #ls_tens_tmp 
                    jsr      Print_Str_d 
                    RESET0REF  
                    lda      #-120 
                    ldb      #-120 
                    ldu      #finish_btn4_text 
                    jsr      Print_Str_d 
                    lda      #5 
                    inc      frm5cnt                      ; internal frame counter stuff got joystick/button handling 
                    cmpa     frm5cnt 
                    bne      no5cntresetLS 
                    clr      frm5cnt 
no5cntresetLS 
                    jsr      Dec_3_Counters               ; timeout counter stuff 
                    tst      Vec_Counter_1 
                    bne      lskeepgoing 
                    dec      temp1 
                    beq      do_demols 
                    lda      #$FF 
                    sta      Vec_Counter_1 
lskeepgoing 
                    lbra     ls_loop 

do_demols           lda      #1                           ; no user input don't save 
                    sta      Demo_Mode 
                    jmp      restart 

ls_done 
                    lda      conf_box_index               ; save 'em 
                    sta      level                        ; will use this value next time you start the game 
                    rts      

;}}}
;{{{ check_highscore_entry: see if score is high enough to get on board
check_highscore_entry: 
                    ldd      Vec_Rfrsh 
                    pshs     d 
                    SET_REFRESH_30  
; score compare see if we even need to do this
                    ldx      #hsentrys_t 
                    ldx      8,x                          ; check lowest entry 0-4 index w/ 1 left shift 
                    ldu      #score 
                    jsr      Compare_Score                ; result in A 
                    cmpa     #2 
                    lbne     hs_check_done                ; 0 = same | 1 = x > u | 2 = x < u == new highscore 
                    lda      #0 
                    sta      hs_box_Yindex 
                    sta      hs_box_Xindex 
                    sta      frm5cnt 
                    sta      hsentry_index 
                    sta      temp2 
hse_timeout         =        temp1 
hstempstr           =        temp3                        ; needs 4 bytes so uses bytes temp3 and 4 
                    lda      #10 
                    sta      hse_timeout 
                    lda      #$FF 
                    sta      Vec_Counter_1 
hs_loop 
                    jsr      Wait_Recal 
                    jsr      Intensity_5F 
                    jsr      Do_Sound_FX_C1 
                    lda      frm5cnt 
                    lbne     hsbtn3_done                  ; joystick movement delay 
                    jsr      Joy_Digital 
; Y stick poll    
                    lda      Vec_Joy_1_Y 
                    beq      jsdoneYhs                    ; no Y motion 
                    bmi      going_down_hs 
                    lda      #50 
                    sta      hse_timeout 
                    lda      hs_box_Yindex 
                    beq      jsdoneYhs                    ; 0 is highest slot on screen !move 
                    dec      hs_box_Yindex 
                    jsr      SFX_Bloop 
                    bra      jsdoneYhs 

going_down_hs 
                    lda      #50 
                    sta      hse_timeout 
                    lda      hs_box_Yindex 
                    cmpa     #6                           ; 5 is lowest row on screen !move 
                    beq      jsdoneYhs 
                    inc      hs_box_Yindex 
                    jsr      SFX_Bloop 
jsdoneYhs 
; X stick poll    
                    lda      Vec_Joy_1_X 
                    beq      jsdoneXhs                    ; no X motion 
                    bmi      going_left_hs 
                    lda      #50 
                    sta      hse_timeout 
                    lda      hs_box_Xindex 
                    cmpa     #5 
                    beq      _wrapX                       ; 5 is highest slot on screen wrap ... 
                    inc      hs_box_Xindex 
                    jsr      SFX_Bloop 
                    bra      jsdoneXhs 

_wrapX 
                    lda      hs_box_Yindex 
                    cmpa     #6 
                    beq      jsdoneXhs 
                    clr      hs_box_Xindex 
                    inc      hs_box_Yindex 
                    jsr      SFX_Bloop 
                    bra      jsdoneXhs 

going_left_hs 
                    lda      #50 
                    sta      hse_timeout 
                    lda      hs_box_Xindex 
                    beq      _unwrapX                     ; if zero move one line up, & end of line 
                    dec      hs_box_Xindex 
                    jsr      SFX_Bloop 
                    bra      jsdoneXhs 

_unwrapX 
                    lda      hs_box_Yindex                ; don't "un"wrap on zero 
                    beq      jsdoneXhs 
                    lda      #5 
                    sta      hs_box_Xindex 
                    dec      hs_box_Yindex 
                    jsr      SFX_Bloop 
                                                          ; bra jsdoneXhs 
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
                    jsr      SFX_Pip 
                    lda      #50 
                    sta      hse_timeout 
hsbtn4_done 
                    lda      Vec_Button_1_3 
                    beq      hsbtn3_done 
                    lda      hsentry_index 
                    beq      hsbtn3_done                  ; already at start can't go back more 
                    dec      hsentry_index                ; go back one space left 
                    jsr      SFX_RevBloop 
                    lda      #$5F                         ; load underscore char 
                    ldx      #hstempstr 
                    ldb      hsentry_index 
                    sta      b,x                          ; over write char 
                    lda      #50 
                    sta      hse_timeout 
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
                    lda      #28 
                    ldb      #hsgridxpos 
                    ldu      #hs_abc_7 
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
                    lda      #5 
                    inc      frm5cnt 
                    cmpa     frm5cnt 
                    bne      no5cntresetHS 
                    clr      frm5cnt 
no5cntresetHS 
                    lda      #2 
                    inc      frm2cnt 
                    cmpa     frm2cnt 
                    bne      no2cntresetHS 
                    clr      frm2cnt 
no2cntresetHS 
;show_inst
                    RESET0REF  
                    ldd      Vec_Text_HW 
                    pshs     d 
                    ldd      #$FE40 
                    std      Vec_Text_HW 
                    lda      #117 
                    ldb      #-60 
                    ldu      #new_hs_label 
                    jsr      Print_Str_d 
                    lda      temp2                        ; timer to hide instructions 
                    beq      show_inst 
                    dec      temp2 
                    lbne     no_ent_inst 
show_inst 
;                    lda      frm2cnt 
;                    lbne     noshow_3 
                    lda      #-110 
                    ldb      #-120 
                    ldu      #press_btn3_text 
                    PRINT_STR_D  
                    RESET0REF  
;noshow_3 
;                    lda      frm2cnt 
;                    lbeq     no_ent_inst 
                    lda      hsentry_index 
                    cmpa     #3                           ; if at last hs_entry cursor idx, show different text. 
                    lbeq     change_btn4_text 
                    ldu      #press_btn4_text 
                    lda      #-120 
                    ldb      #-120 
                    PRINT_STR_D  
                    lbra     no_ent_inst 

change_btn4_text 
                    ldu      #finish_btn4_text 
                    lda      #-120 
                    ldb      #-120 
                    PRINT_STR_D  
no_ent_inst 
; check time out
                    jsr      Dec_3_Counters 
                    tst      Vec_Counter_1 
                    bne      keepitgoing 
                    dec      hse_timeout 
                    beq      doHSsaveRestoreS 
                    lda      #$FF 
                    sta      Vec_Counter_1 
keepitgoing 
; done
                    puls     d 
                    std      Vec_Text_HW 
                    jmp      hs_loop 

doHSsaveRestoreS: 
                    puls     d                            ; otherwise stack is fukt 
                    std      Vec_Text_HW 
doHSsave: 
;   hsentryXn = initials  hsentryXs = score
; tables  hsentryn_t      hsentrys_t   
; table has 5 slots for scores
; #hstempstr holds entered initials
top5idx             =        temp1 
                    lda      #4                           ; top 5 zero index 
                    sta      top5idx 
hs_test_loop 
; score compare
                    lda      top5idx 
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
                    lda      top5idx 
                    cmpa     #4 
                    beq      no_copy_score 
                    lda      top5idx 
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
                    lda      top5idx 
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
                    lda      top5idx 
                    lsla     
                    ldy      #score                       ; Y = source 
                    ldx      #hsentrys_t 
                    ldx      a,x                          ; X = target 
hs_copy_loop 
                    lda      ,y+                          ; increments AFTER apparently!! 
                    sta      ,x+ 
                    bpl      hs_copy_loop 
; NAME 2nd 
                    lda      top5idx 
                    lsla     
                    ldy      #hstempstr                   ; from user input above 
                    ldx      #hsentryn_t 
                    ldx      a,x 
hsn_copy_loop 
                    lda      ,y+                          ; increments AFTER apparently!! 
                    sta      ,x+ 
                    bpl      hsn_copy_loop 
                    dec      top5idx 
                    jmp      hs_test_loop 

hs_check_done 
                    puls     d                            ; restore refresh to 50hz 
                    std      Vec_Rfrsh 
; copy hsentrys_t and hsentryn_t to ee_hs_t & ee_hsn_t        
; taken from fill_hs_tbl
; names
write2eeprom:                                             ;#isfunction  
                    ldb      #4                           ; 5 entries, 0 index 
                    lslb                                  ; 2 byte table 
get_nentry1 
                    ldx      #hsentryn_t                  ; names, 4 bytes RAM 
                    ldx      b,x 
                    ldy      #ee_hsn_t                    ; table of scores from EEPROM 
                    ldy      b,y 
_fill_nloop1 
                    lda      ,x+                          ; 'memcpy' loop 
                    sta      ,y+ 
                    cmpa     #$80 
                    bne      _fill_nloop1                 ; $80 is string terminator use instead of bpl incase any chars are above $80 
                    decb     
                    decb     
                    bpl      get_nentry1 
; scores    
                    ldb      #4                           ; 5 entries, 0 index 
                    lslb     
get_sentry1 
                    ldx      #hsentrys_t 
                    ldx      b,x 
                    ldy      #ee_hs_t 
                    ldy      b,y 
_fill_sloop1 
                    lda      ,x+ 
                    sta      ,y+ 
                    bpl      _fill_sloop1 
                    decb     
                    decb     
                    bpl      get_sentry1 
; above, copied from fill_hs_tbl to reverse copy order
; save config values too.
                    lda      shipspeed 
                    sta      ee_shipspeed 
                    lda      Super_Game 
                    sta      ee_game_mode 
                    jsr      eeprom_save 
; for vectreme and ?? copy current highscore to Vec_High_Score
                    ldx      #ee_hs1 
                    ldy      #Vec_High_Score 
                    COPY_STR  
;
                    rts      

;}}}
;{{{ fill_hs_table: populate hs table ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fill_hs_tbl:                                              ;        only used if eeprom not found. 
;name
                    ldb      #4                           ; 5 entries, 0 index 
                    lslb                                  ; 2 byte table 
get_nentry 
                    ldx      #hsentryn_t                  ; 
                    ldx      b,x 
                    ldy      #default_name_t 
                    ldy      b,y 
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
                    ldy      #default_high_t 
                    ldy      b,y 
_fill_sloop 
                    lda      ,y+ 
                    sta      ,x+ 
                    bpl      _fill_sloop 
                    decb     
                    decb     
                    bpl      get_sentry 
                    rts      

;}}}
;{{{ fill_hs_tbl_eeprom: fill HS table from eeprom. only do one time.
fill_hs_tbl_eeprom: 
; names
                    ldb      #4                           ; 5 entries, 0 index 
                    lslb                                  ; 2 byte table 
get_nentryee 
                    ldx      #hsentryn_t                  ; names, 4 bytes RAM 
                    ldx      b,x 
                    ldy      #ee_hsn_t                    ; table of scores from EEPROM 
                    ldy      b,y 
_fill_nloopee 
                    lda      ,y+                          ; memcpy loop 
                    sta      ,x+ 
                    cmpa     #$80 
                    bne      _fill_nloopee                ; $80 is string terminator use instead of bpl incase any chars are above $80 
                    decb     
                    decb     
                    bpl      get_nentryee 
; scores    
                    ldb      #4                           ; 5 entries, 0 index 
                    lslb     
get_sentryee 
                    ldx      #hsentrys_t 
                    ldx      b,x 
                    ldy      #ee_hs_t 
                    ldy      b,y 
_fill_sloopee 
                    lda      ,y+ 
                    sta      ,x+ 
                    bpl      _fill_sloopee 
                    decb     
                    decb     
                    bpl      get_sentryee 
; load config values too
                    lda      ee_shipspeed 
                    sta      shipspeed 
                    lda      ee_game_mode 
                    sta      Super_Game 
; for vectreme and ??
                    ldx      #ee_hs1 
                    ldy      #Vec_High_Score 
                    COPY_STR  
                    rts      

;}}}
;{{{ print_hs_tbl: print the high scores table
print_hs_tbl: 
                    lda      #2 
                    sta      temp1 
ym_restart 
                    ldu      #SONG_DATA 
                    jsr      init_ym_sound 
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
                    bne      leave_demo_mode_hs           ; break out 
                    lda      Vec_Button_1_2 
                    beq      noconfpress 
                    jsr      general_config 
noconfpress 
; count down to next screen without button press
                    jsr      Dec_3_Counters 
                    tst      Vec_Counter_1 
                    bne      keepgoinghs 
                    dec      temp1 
                    beq      do_demohs 
                    lda      #$FF 
                    sta      Vec_Counter_1 
keepgoinghs 
                    jsr      do_ym_sound 
                    ldd      ym_data_current 
                    lbeq     ym_restart                   ; loop default 
                    lbra     _keepshow 

do_demohs 
                                                          ; jsr credits_thanks ; remove after testing 
                    jsr      Random_3 
                    cmpa     #64 
                    blt      no_thanks 
                    jsr      credits_thanks 
no_thanks 
                    jsr      titleScreen 
                    lda      #1 
                    sta      Demo_Mode 
                    jmp      restart 

leave_demo_mode_hs 
                    clr      Demo_Mode 
                    jmp      restart 

;}}}
;{{{ credits_thanks: shoutouts
credits_thanks: 
                    lda      PSG_Ch1_Vol 
                    ldb      #0 
                    jsr      Sound_Byte_raw 
                    lda      PSG_Ch2_Vol 
                    ldb      #0 
                    jsr      Sound_Byte_raw 
                    lda      PSG_Ch3_Vol 
                    ldb      #0 
                    jsr      Sound_Byte_raw 
                    lda      PSG_OnOff 
                    ldb      #%00000000 
                    jsr      Sound_Byte_raw 
                    jsr      Clear_Sound 
                    lda      #127 
                    sta      VIA_t1_cnt_lo 
                    ldd      Vec_Text_HW 
                    std      temp                         ; save Text_HW on entry and restore at end 
                    ldd      #$F850 
                    std      Vec_Text_HW 
                    lda      #128 
                    sta      temp2                        ; temp2 is text Height, start high and dec till normal 
                    lda      #255 
                    sta      temp3                        ; temp3 is timer on how long text is displayed 
                    clr      temp4                        ; temp4 is counter for which text string to displayed 
                    clr      temp1                        ; temp1 direction of text height 0 dec & 1 inc 
                    jsr      SFX_Down_Burst 
_ct_loop 
                    lda      temp2 
                    sta      Vec_Text_Height 
                    jsr      Wait_Recal 
                    jsr      Do_Sound_FX_C2 
                    jsr      Intensity_5F 
                    ldx      #thanks_t 
                    lda      temp4 
                    lsla     
                    ldu      a,x 
                    lda      #50 
                    ldb      #-110 
                    jsr      Print_Str_d 
                    RESET0REF  
                    ldx      #thanks_t 
                    lda      temp4 
                    inca     
                    lsla     
                    ldu      a,x 
                    lda      #30 
                    ldb      #-110 
                    jsr      Print_Str_d 
                    RESET0REF  
                    ldx      #thanks_t 
                    lda      temp4 
                    inca     
                    inca     
                    lsla     
                    ldu      a,x 
                    lda      #10 
                    ldb      #-110 
                    jsr      Print_Str_d 
                    RESET0REF  
                    ldu      #thankstolabel 
                    lda      #70 
                    ldb      #-110 
                                                          ; jsr Print_Str_d 
                    PRINT_STR_D  
                    lda      temp2 
                    cmpa     temp                         ; should be $F8 
                    beq      dontdec2 
                    lda      temp1 
                    bne      HeightDec 
                    dec      temp2 
                    dec      temp2 
                    dec      temp2 
                    bra      donedec2 

HeightDec 
                    inc      temp2 
                    inc      temp2 
                    inc      temp2 
donedec2 
dontdec2 
                    dec      temp3 
                    lda      temp3 
                    bne      dontinctemp4 
                    lda      temp1 
                    bne      noinctemp1 
                    inc      temp1                        ; set up next round of text lines 
                    jsr      SFX_Up_Burst 
                    bra      donetemp1 

noinctemp1 
                    clr      temp1 
                    jsr      SFX_Up_Burst 
donetemp1 
                    lda      #126 
                    sta      temp2 
                    lda      #255 
                    sta      temp3 
                    inc      temp4 
                    inc      temp4 
                    inc      temp4 
                    lda      temp4 
                    cmpa     #6 
                    beq      creditsdone 
dontinctemp4 
                    lbra     _ct_loop 

creditsdone 
                    ldd      temp 
                    std      Vec_Text_HW 
                    rts      

;}}}
;{{{ set_hz
;}}}
;; from RUM commented out;
CURVY:              LDD      #$8118                       ;DRAW CURVED LINE FROM UPDATE TABLE <---- 
                    STA      VIA_port_b 
                    STB      VIA_aux_cntl                 ;U - REG IS POINTER 
                    BRA      RAINY 

JELLO               STB      VIA_port_b                   ;FORMAT- Y,ON/OFF,X,X,X 
                    STA      VIA_shift_reg                ; 0 GOES TO NEXT Y, ADDIT. 0 ENDS 
JALLO               LDA      ,U+ 
                    BEQ      BRAINY                       ;UPDATING X-VALUES 
                    STA      VIA_port_a 
                    BRA      JALLO 

BRAINY              LDB      #$81                         ;RAMP OFF 
                    STB      VIA_port_b 
                    STA      VIA_shift_reg                ;VID OFF 
RAINY               LDA      ,U+                          ;NEXT Y 
                    BEQ      JFIN                         ;IF DONE 
                    STA      VIA_port_a                   ;IF GOOD Y VAL 
                    DECB     
                    STB      VIA_port_b                   ;BEGIN S/H 
                    LDD      ,U++                         ;A=VID ENBL, B=NEXT X 
                    INC      VIA_port_b                   ;Y S/H DONE 
                    STB      VIA_port_a 
                    LDB      #$01 
                    BRA      JELLO 

JFIN                LDA      #$98 
                    STA      VIA_aux_cntl                 ;PUT BACK 
                    RTS
     
draw_curved_line:
                 LDD     #$1881            ; load D with VIA pokes
                 STB     VIA_port_b        ; poke $81 to port B
                                           ; disable MUX
                                           ; disable ~RAMP
                 STA     VIA_aux_cntl      ; poke $18 to AUX
                                           ; shift mode 4
                                           ; PB7 not timer controlled
                                           ; PB7 is ~RAMP
                 BRA     next_update_round ; jump to entry of loop
x_update_loop_init:
                 STB     VIA_port_b        ; MUX disable, ~RAMP enable
                 STA     VIA_shift_reg     ; poke the enable byte (A) found to
                                           ; shift, that enables/disables ~BLANK
x_update_loop:
                 LDA     ,U+               ; load next X_update value
                 BEQ     finnish_x_update  ; if zero, we are done with this
                                           ; X_update
                 STA     VIA_port_a        ; otherwise put the found value to
                                           ; DAC and thus to X integration
                 BRA     x_update_loop     ; go on, look if another X_update
                                           ; value is there...
finnish_x_update:
                 LDB     #$81              ; load value for ramp off, MUX off
                 STB     VIA_port_b        ; poke $81, ramp off, MUX off

                 NOP                       ; these NOP's seem to be neccessary
                 NOP                       ; since the delay between VIA and
                 NOP                       ; integration hardware
                 NOP                       ; otherwise, there is a space
                                           ; between Y_updates...    Malban
                 STA     VIA_shift_reg     ; A == %00000000
next_update_round:
                 LDA     ,U+               ; load next Y_update
                 BEQ     done_curved_line  ; go to done if 0
                 STA     VIA_port_a        ; poke to DAC
                 DECB                      ; B now $80
                 STB     VIA_port_b        ; enable MUX, that means put
                                           ; DAC to Y integrator S/H
                LDD     ,U++              ; A=VIDEO_enable, B=X_update
                 INC     VIA_port_b        ; MUX off, only X on DAC now
                 STB     VIA_port_a        ; store B (X_update) to DAC
                 LDB     #$01              ; load poke for MUX disable,
                                           ; ~RAMP enable
                 BRA     x_update_loop_init; goto x update loop
done_curved_line:
                 LDA     #$98              ; load AUX setting
                 STA     VIA_aux_cntl      ; restore usual AUX setting
                                           ; (enable PB7 timer, SHIFT mode 4)
                 RTS                       ; and out of here



; try to make horizontal version of CURVY??  maybe not possible
CURVX:              LDD      #$8118                       ;DRAW CURVED LINE FROM UPDATE TABLE <---- 
                    STA      VIA_port_b 
                    STB      VIA_aux_cntl                 ;U - REG IS POINTER 
                    BRA      TRAINY 

YELLO               STB      VIA_port_b                   ;FORMAT- Y,ON/OFF,X,X,X 
                    STA      VIA_shift_reg                ; 0 GOES TO NEXT Y, ADDIT. 0 ENDS 
YALLO               LDA      ,U+ 
                    BEQ      GRAINY                       ;UPDATING X-VALUES 
                    STA      VIA_port_a 
                    BRA      YALLO 

GRAINY              LDB      #$00                         ;RAMP OFF 
                    STB      VIA_port_b 
                    STA      VIA_shift_reg                ;VID OFF 
TRAINY               LDA      ,U+                          ;NEXT Y 
                    BEQ      KFIN                         ;IF DONE 
                    STA      VIA_port_a                   ;IF GOOD Y VAL 
                    DECB     
                    STB      VIA_port_b                   ;BEGIN S/H 
                    LDD      ,U++                         ;A=VID ENBL, B=NEXT X 
                    INC      VIA_port_b                   ;Y S/H DONE 
                    STB      VIA_port_a 
                    LDB      #$80 
                    BRA      YELLO 

KFIN                LDA      #$98 
                    STA      VIA_aux_cntl                 ;PUT BACK 
                    RTS  