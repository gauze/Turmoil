; vim: ts=4
; vim: syntax=asm6809 foldmethod=marker fdo-=search
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
; stuff that goes into RAM
                    include  "vars.i"                     ; RAM allocation starting at $C880 
                    include  "macros.i"                   ; inlined code to save jsr/rts cycles
;***************************************************************************
;{{{ HEADER SECTION
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
                    fcc      "-2020", $80                 ; more date
                    db       0                            ; end of game header 
;                   bra restart ; TESTING skip intro to get right to it.  
;                  jsr      levelsplash  ; REMOVE to return to normal flow
;}}} 
                    bra      introSplash 

;***************************************************************************
;{{{ MAGIC CARTHEADER SECTION
;      DO NOT CHANGE THIS STRUCT
;***************************************************************************
;                    ORG      $0030 
;                    fcb      "ThGS"                       ; magic handshake marker
;v4ecartversion      fdb      $0001                        ; I always have a version 
;                                                ; in comm. structs
;v4ecartflags        fdb      $4000 
;}}}
;***************************************************************************
;{{{ CODE SECTION
;***************************************************************************  
                    INTRO_BOOT                            ; runs ONCE per boot 
                    RESTART                               ; jump here on game restart 
main                                                      ;        top of game loop 
                    WAIT_RECAL  
                    READ_JOYSTICK  
                    DRAW_LINE_WALLS  
                    DRAW_SHIP  
                    READ_BUTTONS  
                    MOVE_BULLETS  
                    DRAW_BULLETS  
                    DRAW_VECTOR_SCORE  
                    PRINT_SHIPS  
                    NEW_ENEMY                             ; see if new enemy generation required 
                    FRAME_CNTS                            ; advance/reset frame counters/timers 
                    MOVE_ENEMYS                           ; math to move enemies 
                    DRAW_ENEMYS                           ; ... 
                    SHOT_COLLISION_DETECT  
                    SHIP_Y_COLLISION_DETECT  
                    SHIP_X_COLLISION_DETECT  
                    STALL_CHECK                           ; can't just sit in an open alley forever... 
                    ALLEY_TIMEOUT                         ; prevent alleys from respawning instantly 
                    CHECK_LEVEL_DONE  
                    CHECK_SFX                             ; sound update 
                    jmp      main                         ; and repeat forever 

;}}}
;-----------------------------------------------------------------------------------
;{{{ must go at bottom or fills up RAM instead of ROM 
                    include  "functions.i"                ; 
                    include  "data.i"                     ; static data, shapes, tables, text
                    include  "libsoundraw.i"              ; quick sound effects routines
                    include  "rawsounddata.i"
                    include  "rawsoundroutines.i"         ; 
                    include  "rasterDraw.asm"             ; title screen from VIDE
                    include  "ymPlayer.i"                 ; for song under high score
                    include  "turmoil_ym.asm"             ; our data for above
                    include  "ds2431LowLevel.i"           ; high score save stuff
                    include  "ds2431HighLevel.i"          ; using DS2431+ 1 wire eeprom
                    include  "eeprom.i"                   ; should be named eeprom.i oh well
                    include  "draw_synced_list.i"         ; from VIDE to, draw shapes with many vectors.
end 
;}}}
