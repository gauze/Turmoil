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
                    include  "VECTREX.I"                  ; vectrex bios function include
                    include  "vars.i"
                    include  "macros.i"
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
                    sta      In_Alley 
                    ldb      #LEFT 
                    stb      shipdir 
                    ldx      #score 
                    jsr      Clear_Score 
                    lda      #5 
                    sta      shipcnt 
main: 
                    jsr      Wait_Recal 
                    CHECK_GAMEOVER  
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
                    jmp      no_score 

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
no_score: 
; end score+ship count
                    NEW_ENEMY  
                    DRAW_ENEMYS  
                    FRAME_CNTS  
                    MOVE_ENEMYS  
                    SHOT_COLLISION_DETECT  
                    SHIP_COLLISION_DETECT  
                    STALL_CHECK  
                    jmp      main                         ; and repeat forever 

; must go at bottom or fills up RAM instead of ROM ??
                    include  "functions.i"
                    include  "data.i"
end 
