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
shipcnt             ds       1                            ; 1 byte 
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
spawntemp           ds       1 
masktemp            ds       1 
enemylvlcnt         ds       1 
;
; CONSTANTS place after VARIABLES
;ALLEYWIDTH          =        17 
LEFT                =        0 
RIGHT               =        1 
SCORE               =        10 
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
restart 
                    jsr      setup 
                    jsr      levelsplash 
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
                    sta      shipcnt 
                                                          ; jsr explodetest 
main: 
                    jsr      Wait_Recal 
                    JOYSTICK_TEST  
                    lda      #$5F 
                    INTENSITY_A  
                    DRAW_WALLS
                    DRAW_SHIP
; place bullets
                    READ_BUTTONS  
                    jsr      move_bullets 
                    lda      #$7F 
                    INTENSITY_A  
                    jsr      draw_bullets 
                    lda      #$6F 
                    INTENSITY_A  
                                                          ; jmp main ; don't print scores 
; display score and ships left
                    RESET0REF  
                    ldu      #score 
                    lda      #137 
                    ldb      #-40 
                    jsr      Print_Str_d 
                    lda      -50 
                    ldb      65 
                    MOVETO_D  
                    lda      shipcnt                      ; vector draw ships remaining routine TEST 
                    sta      temp 
ships_left_loop 
                    ldx      #Ship_Marker 
                    DRAW_VLC  
                    dec      temp 
                    bne      ships_left_loop 
                                                          ; jmp main 
; end score+ship count
                    NEW_ENEMY  
                    DRAW_ENEMYS  
                    FRAME_CNTS  
                    MOVE_ENEMYS  
                    SHOT_COLLISION_DETECT  
                    SHIP_COLLISION_DETECT  
                    lda      shipcnt 
                    bne      notgameover 
                    jsr      gameover 
notgameover 
                    STALL_CHECK  
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

gameover 
                    jsr      Wait_Recal 
                    clr      Vec_Misc_Count 
                    lda      #$80 
                    sta      VIA_t1_cnt_lo 
                    jsr      Intensity_7F 
                    RESET0REF  
                    lda      -70 
                    ldb      -50 
                    ldu      #gameoverstr 
                    jsr      Print_Str_d 
                    lda      -50 
                    ldb      -50 
                    ldu      #score 
                    jsr      Print_Str_d 
                    jsr      Read_Btns 
                    lda      Vec_Button_1_3 
                    lbne      restart 
                    bra      gameover

chkenemycnt: 
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
                    rts      

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

; must go at bottom or fills up RAM instead of ROM ??
                    include  "data.i"
end 
