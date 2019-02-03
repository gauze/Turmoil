; vim: ts=4
; vim: syntax=asm6809
                    title    "Alley Anxiety"
; DESCRIPTION
; Port of 20th Century Fox Atari 2600 game Turmoil
;
; TOOLS USED
; Editing, graphic drawing, assembly: VIDE  http://vide.malban.de
; more sophisticated editing: VIM http://www.vim.org
; Testing on real hardware: MVBD + VecFever
;***************************************************************************
; DEFINE SECTION
;***************************************************************************
; load vectrex bios routine definitions
                    include  "VECTREX.I"                  ; vectrex bios function include
                    include  "vars.i"                     ; RAM allocation starting at $C880
                    include  "macros.i"                   ; inlined code to save jsr/rts
;***************************************************************************
; HEADER SECTION
;***************************************************************************
; The cartridge ROM starts at address 0
                    code     
                    ORG      $0000 
; the first few bytes are mandatory, otherwise the BIOS will not load
; the ROM file, and will start MineStorm instead
                    fcc      "g GCE 2016", $80 ; 'g' is copyright sign
                    fdb      music1                       ; music from the rom 
                    fdb      $FC50 
                    fcb      $20, -$45                    ; hight, width, rel y, rel x (from 0,0) 
                    fcc      "ALLEY ANXIETY", $80         ; title ending with $80
                    fdb      $F850 
                    fcb      -$40, -$30                   ; hight, width, rel y, rel x (from 0,0) 
                    fcc      $6E,$6E,$6F, $80             ; 3 solid blocks ending with $80 
                    fdb      $F850 
                    fcb      -$40, $23                    ; hight, width, rel y, rel x (from 0,0) 
                    fcc      "-2019", $80                 ; more date
                    db       0                            ; end of game header 
;                   bra restart ; TESTING skip intro to get right to it.  
;                  jsr      levelsplash  ; REMOVE to return to normal flow
                    bra      introSplash 

;***************************************************************************
; MAGIC CARTHEADER SECTION
;      DO NOT CHANGE THIS STRUCT
;***************************************************************************
;                    ORG      $0030 
;                    fcb      "ThGS"                       ; magic handshake marker
;v4ecartversion      fdb      $0001                        ; I always have a version 
;                                                ; in comm. structs
;v4ecartflags        fdb      $4000 
;***************************************************************************
; CODE SECTION
;***************************************************************************  
                    INTRO_BOOT                            ; runs ONCE per boot 
                    RESTART                               ; jump here on game restart 
main: 												; top game loop
                    WAIT_RECAL  
                    READ_JOYSTICK  
                    DRAW_LINE_WALLS  
                    DRAW_SHIP  
                    READ_BUTTONS  
                    MOVE_BULLETS  
                    DRAW_BULLETS  
                    DRAW_VECTOR_SCORE  
                    PRINT_SHIPS  
                    NEW_ENEMY  							; see if new enemy generation required
                    FRAME_CNTS  						; advance/reset frame counters/timers
                    MOVE_ENEMYS  						; math to move enemies
                    DRAW_ENEMYS  						; ...
                    SHOT_COLLISION_DETECT  
                    SHIP_Y_COLLISION_DETECT  
                    SHIP_X_COLLISION_DETECT  
                    STALL_CHECK                           ; can't just sit in an open alley forever... 
                    ALLEY_TIMEOUT  						; prevent alleys from respawning instantly
                    CHECK_LEVEL_DONE  
                    CHECK_SFX  
                    jmp      main                         ; and repeat forever, sorta 

;-----------------------------------------------------------------------------------
; must go at bottom or fills up RAM instead of ROM 
                    include  "functions.i"
                    include  "data.i"
                    include  "libsoundraw.i"
                    include  "rawsounddata.i"
                    include  "rawsoundroutines.i"
                    include  "rasterDraw.asm"
                    include  "ymPlayer.i"
                    include  "turmoil_ym.asm"
                    include  "ds2431LowLevel.i"
                    include  "ds2431HighLevel.i"
                    include  "eprom.i" 
end 
