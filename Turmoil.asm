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
shipdir             ds       1 
shippos             ds       1 
shipXpos            ds       1 
in_alley            ds       1 
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
;
; CONSTANTS place after VARIABLES
ALLEYWIDTH          =        17 
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
                    lda      #3 
                    sta      ships_left 
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
                    RESET0REF  
                    ldx      #bulletYpos_t 
                    lda      #6 
                    lda      a,x                          ; Y 
                    ldb      #-30                         ; X 
                    MOVETO_D  
                    ldx      #Explode_D 
                    clra     
                    ldx      a,x                          ; get table lookup Left=0 
                    lda      Explode_f 
                    ldx      a,x 
                    jsr      Draw_VL_mode 
                    RESET0REF  
                    ldx      #bulletYpos_t 
                    lda      #0 
                    lda      a,x                          ; Y 
                                                          ; clra 
                                                          ; clrb ; X 
                    ldb      #-30 
                    MOVETO_D  
                    ldx      #Wedge_R_t 
                    lda      Wedge_f 
                    ldx      a,x 
                    jsr      Draw_VL_mode 
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
                    inc      Explode_f 
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
no25cntreset 
                    lda      #50 
                    inc      frm50cnt 
                    cmpa     frm50cnt 
                    bne      no50cntreset 
                    clr      frm50cnt 
                    inc      Prize_f 
                    inc      Prize_f                      ; add 2 for next table entry 
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
                    sta      Prize_f 
                    sta      Cannonball_f 
                    sta      Tank_f 
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

; must go at bottom or fills up RAM instead of ROM ??
                    include  "data.i"
end 
