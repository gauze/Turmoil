; vim: ts=4
; vim: syntax=asm6809
                    title    "Turmoil"
; DESCRIPTION
; Port of 20th Century Fox Atari 2600 game Turmoil
;
;#TOOLS USED
; Editing, graphic drawing, assembly: VIDE  http://vide.malban.de
; Testing on real hardware: VecFever
;***************************************************************************
; DEFINE SECTION
;***************************************************************************
; load vectrex bios routine definitions
                    include  "VECTREX.I"                  ; vectrex function includes
                    include  "macros.i"
;***************************************************************************
; Variable / RAM SECTION
;***************************************************************************
; insert your variables (RAM usage) in the BSS section
; user RAM starts at $c880 
                    bss      
                    org      $c880                        ; start of our ram space 
score               ds       7                            ; 7 bytes 
highscore           ds       7                            ; 7 bytes 
level               ds       1 
shipdir             ds       1 
shippos             ds       1 
shipXpos            ds       1 
in_alley            ds       1 
enemycnt            ds       1 
stallcnt            ds       1 
bullet0e            ds       1 
bullet1e            ds       1                            ; shit Exists in alley 
bullet2e            ds       1 
bullet3e            ds       1 
bullet4e            ds       1 
bullet5e            ds       1 
bullet6e            ds       1 
bullet0d            ds       1 
bullet1d            ds       1                            ; travel direction 
bullet2d            ds       1 
bullet3d            ds       1 
bullet4d            ds       1 
bullet5d            ds       1 
bullet6d            ds       1 
bullet0x            ds       1 
bullet1x            ds       1                            ; location on X axis 
bullet2x            ds       1 
bullet3x            ds       1 
bullet4x            ds       1 
bullet5x            ds       1 
bullet6x            ds       1 
alley0e             ds       1                            ; is there a monster in the alley? (Exists?) 
alley1e             ds       1 
alley2e             ds       1 
alley3e             ds       1 
alley4e             ds       1 
alley5e             ds       1 
alley6e             ds       1 
alley0d             ds       1                            ; which way is the monster moving? 
alley1d             ds       1 
alley2d             ds       1 
alley3d             ds       1 
alley4d             ds       1 
alley5d             ds       1 
alley6d             ds       1 
alley0x             ds       1                            ; where monster is on x axis 
alley1x             ds       1 
alley2x             ds       1 
alley3x             ds       1 
alley4x             ds       1 
alley5x             ds       1 
alley6x             ds       1 
alley0s             ds       1                            ; speed of monster 1-9 
alley1s             ds       1 
alley2s             ds       1 
alley3s             ds       1 
alley4s             ds       1 
alley5s             ds       1 
alley6s             ds       1 
bullet_count        ds       1                            ; 1 byte 
ships_left          ds       1                            ; 1 byte 
bulletYtemp         ds       1 
Ship_Dead           ds       1 
; variables to hold which frame for each shape enemy some might not have an animation...
Arrow_f             ds       1 
Bow_f               ds       1 
Dash_f              ds       1 
Wedge_f             ds       1 
Ghost_f             ds       1 
Prize_f             ds       1 
Cannonball_f        ds       1 
Tank_f              ds       1 
None_f              ds       1 
Explode_f           ds       1                            ; generic shape used when something is destroyed 
; frame counts for animations
frm100cnt           ds       1 
frm50cnt            ds       1 
frm25cnt            ds       1 
frm20cnt            ds       1 
frm10cnt            ds       1 
frm5cnt             ds       1 
frm2cnt             ds       1 
temp                ds       1                            ; generic 1 byte temp 
rottemp             ds       15                           ; rotation list temp 
titlescreen_y       ds       1 
;
; CONSTANTS place after VARIABLES
;ALLEYWIDTH          =        17 
LEFT                =        0 
RIGHT               =        1 
SCORE               =        10 
;FALSE              =     0 
;TRUE               =      1 
MOVEAMOUNT          =        8                            ; how many 'pixels per frame' TOD/FIX/something 
;***************************************************************************
; HEADER SECTION
;***************************************************************************
; The cartridge ROM starts at address 0
                    code     
                    org      0 
; the first few bytes are mandatory, otherwise the BIOS will not load
; the ROM file, and will start MineStorm instead
                    db       "g GCE gggg", $80 ; 'g' is copyright sign
                    dw       music1                       ; music from the rom 
                    db       $F8, $50, $20, -$35          ; hight, width, rel y, rel x (from 0,0) 
                    db       "TURMOIL", $80               ; some game information, ending with $80
                    db       0                            ; end of game header 
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
                    jsr      setup 
start 
                    lda      #0 
                    sta      shippos 
                    sta      shipXpos 
                    sta      in_alley 
                    ldb      #LEFT 
                    stb      shipdir 
                    ldx      #score 
                    jsr      Clear_Score 
                    lda      #5 
                    sta      ships_left 
                                                          ; jsr explodetest 
main: 
                    jsr      Wait_Recal 
                    JOYSTICK_TEST  
                    lda      #$5F 
                    INTENSITY_A  
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
; draw ship 
                    RESET0REF  
                    lda      #127 
                    sta      VIA_t1_cnt_lo                ; controls "scale" 
                    lda      shippos 
                                                          ; ldx #shippos_t 
                    ldx      #bulletYpos_t 
                    lda      a,x                          ; get pos from shippos_t table 
                    adda     #2+6                         ; small offset 
                                                          ; ldb #0 ; pointing LEFT stay as-is 
                    ldb      shipdir                      ; testing for 0|LEFT 1|RIGHT 
                    beq      donuthin1 
                                                          ; ldb shipXpos ;#-17 ; pointing RIGHT move to the left to center 
donuthin1 
                    ldb      shipXpos 
                    MOVETO_D  
                    ldx      #ShipL_nomode 
                    ldb      shipdir                      ; testing for 0|LEFT 1|RIGHT 
                    beq      donuthin2 
                    ldx      #ShipR_nomode 
donuthin2 
                    DRAW_VLC                              ; jsr Draw_VLc ;_mode 
; place bullets
                    READ_BUTTONS  
                    jsr      move_bullets 
                    lda      #$7F 
                    INTENSITY_A  
                    jsr      draw_bullets 
                    lda      #$5F 
                    INTENSITY_A  
                                                          ; jmp main ; don't print scores 
; display score and ships left
                    RESET0REF  
                    ldu      #score 
                    lda      #-127 
                    ldb      #0 
                    jsr      Print_Str_d 
                    lda      -50 
                    ldb      65 
                    MOVETO_D  
                    lda      ships_left                   ; vector draw ships remaining routine TEST 
                    sta      temp 
ships_left_loop 
                    ldx      #Ship_Marker 
                    DRAW_VLC  
                    dec      temp 
                    bne      ships_left_loop 
                                                          ; jmp main 
; end score+ship count
;;;; DRAW VARIOUS STUFF TEST ZONE
                    NEW_ENEMY  
                    RESET0REF  
                    ldx      #bulletYpos_t 
                    lda      #0 
                    lda      a,x                          ; Y 
                    ldb      alley0x                      ; X 
                    MOVETO_D  
; *_D -> index 0|1 (0=Left, 1=Right)
                    ldx      #enemy_t 
                    lda      alley0e 
                    lsla     
                    ldx      a,x                          ; sets *_D 
                    lda      alley0d 
                    lsla     
                    ldx      a,x                          ; gets *_t 
                    pshs     x                            ; store it 
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
;
                                                          ; RESET0REF 
                                                          ; ldx #bulletYpos_t 
                                                          ; lda #0 
                                                          ; lda a,x 
                                                          ; ldb #-30 
                                                          ; MOVETO_D 
                                                          ; ldx #Wedge_R_t 
                                                          ; lda Wedge_f 
                                                          ; ldx a,x 
                                                          ; jsr Draw_VL_mode 
; increment the Test frame counter
; add more logic to set/increment SHAPE_f counters for desired animations
; ANIMATION PSEUDOCODE
; lda #10 
; cmpa Arrow_f
; bne label
; inc Arrow_f
; bra donearrowf
; label:
; clr Arrow_f
; donearrowf 
; PSEUDOCODE ABOVE
                    lda      #5 
                    inc      frm5cnt 
                    cmpa     frm5cnt 
                    bne      no5cntreset 
                    clr      frm5cnt 
                    lda      #2 
                    sta      Explode_f 
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
no25cntreset 
                    lda      #50 
                    inc      frm50cnt 
                    cmpa     frm50cnt 
                    bne      no50cntreset 
                    clr      frm50cnt 
                    lda      #2 
                    sta      Prize_f                      ; add 2 for next table entry 
                    lda      #2 
                    sta      Bow_f 
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
                                                          ; sta Arrow_f 
                    sta      Bow_f 
                                                          ; sta Dash_f 
                                                          ; sta Wedge_f 
                                                          ; sta Ghost_f 
                    sta      Prize_f 
                                                          ; sta Cannonball_f 
                    sta      Tank_f 
                    sta      Explode_f 
no100cntreset 
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

                    inc      stallcnt 

                    COLLISION_DETECT
 
                    jmp      main                         ; and repeat forever 

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
                    lda      #0                           ; set a bunch of variables to 0 
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
                    rts      

move_bullets: 
                    lda      #127 
                    sta      VIA_t1_cnt_lo 
                    clra     
                    sta      bullet_count 
move_start 
                    lda      bullet_count 
                    asla     
                    ldx      #bullete_t 
                    ldx      a,x 
                    lda      ,x 
                    beq      next_bullet2                 ; don't do motion on non-existant bullets X 
                    lda      bullet_count 
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
                    lda      bullet_count 
                    asla     
                    ldx      #bullete_t 
                    ldx      a,x 
                    ldb      #0 
                    stb      ,x 
                    lda      bullet_count 
                    asla     
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
                    inc      bullet_count 
                    lda      bullet_count 
                    cmpa     #7 
                    beq      bullets_done2 
                    bra      move_start 

bullets_done2 
                    rts      

draw_bullets: 
                    lda      #$0F 
                    sta      Vec_Dot_Dwell                ; trying to make bullet brighter 
                    lda      #0 
                    sta      bullet_count 
bstart 
                    lda      bullet_count 
                    asla                                  ; shift left == multiply by 2 table is 2 byte entry 
                    ldx      #bullete_t 
                    ldx      a,x 
                    lda      ,x 
                    beq      next_bullet                  ; Doesn't EXIST 
                    RESET0REF                             ; reset before positioning beam 
; find Y pos
                    lda      bullet_count 
                    ldx      #bulletYpos_t                ; single mbyte table no asla 
                    lda      a,x                          ; do look up for Y pos from table TODO 
                    sta      bulletYtemp 
; find X pos
                    lda      bullet_count 
                    asla                                  ; shift left == multiply by 2 table is 2 byte entry 
                    ldx      #bulletx_t 
                    ldx      a,x                          ; get pointer from table 
                    ldb      ,x                           ; read from resolved address bulletNx 
                    lda      bulletYtemp 
                    MOVETO_D  
                                                          ; ldx #Shot 
                                                          ; jsr Draw_VL_mode 
                                                          ;jsr Dot_here 
; draw dot code inlined
                    lda      #$FF                         ;Set pattern to all 1's 
                    sta      <VIA_shift_reg               ;Store in VIA shift register 
                    ldb      Vec_Dot_Dwell                ;Get dot dwell (brightness) 
dwellcnt            decb                                  ;Delay leaving beam in place 
                    bne      dwellcnt 
                    clr      <VIA_shift_reg               ;Blank beam in VIA shift register 
; END draw dot inline END
next_bullet 
                    inc      bullet_count 
                    lda      bullet_count 
                    cmpa     #7 
                    beq      bullets_done 
                    jmp      bstart 

bullets_done 
                    lda      #$05 
                    sta      Vec_Dot_Dwell 
                    lda      #$5F 
                    INTENSITY_A  
                    rts      

titlescreen 
                    clr      titlescreen_y 
tsstart 
                    jsr      Wait_Recal 
                    clr      Vec_Misc_Count 
                    lda      #$80 
                    sta      VIA_t1_cnt_lo 
                    jsr      Intensity_7F 
                    RESET0REF  
                    lda      titlescreen_y 
                    ldb      #0 
                    jsr      Moveto_d 
                    lda      #0 
                    ldb      #30 
                    jsr      Draw_Line_d 
                    RESET0REF  
                    lda      titlescreen_y 
                    inca     
                    ldb      #0 
                    jsr      Moveto_d 
                    lda      #0 
                    ldb      #30 
                    jsr      Draw_Line_d 
                    RESET0REF  
                    lda      titlescreen_y 
                    inca     
                    inca     
                    ldb      #0 
                    jsr      Moveto_d 
                    lda      #0 
                    ldb      #30 
                    jsr      Draw_Line_d 
                    inc      titlescreen_y 
                    lda      titlescreen_y 
                    cmpa     #10 
                    bne      tsstart 
                    clr      titlescreen_y 
                    bra      tsstart     

explodetest: 
                    lda      #-1                          ; high bit set by any negative number 
                    sta      Vec_Expl_Flag                ; set high bit for Explosion flag 
loop 
                    jsr      DP_to_C8                     ; DP to RAM 
                    ldu      #EXP3                        ; point to explosion table entry 
                    jsr      Explosion_Snd                ; 
                    jsr      Wait_Recal                   ; call frame 
                    jsr      Do_Sound                     ; this actually plays the sound 
                    jmp      loop 

; must go at bottom or fills up RAM instead of ROM ??
                    include  "data.i"
end 
