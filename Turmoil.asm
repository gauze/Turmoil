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
                    include  "include/VECTREX.I"                  ; vectrex bios function include
; stuff that goes into RAM
                    include  "include/vars.i"                     ; RAM allocation starting at $C880 
                    include  "include/macros.i"                   ; inlined code to save jsr/rts cycles
                    include  "include/freq.i"                     ; refresh rates macros
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
                    fcc      "-2022", $80                 ; more date
                    db       0                            ; end of game header 
;                   bra restart ; TESTING skip intro to get right to it.  
;                  jsr      levelsplash  ; REMOVE to return to normal flow
;}}} 
;                    bra      introSplash 
;***************************************************************************
;{{{ MAGIC CARTHEADER SECTION for vecfever
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
main 
                    WAIT_RECAL  
; TEST area                                                      ;        top of game loop 
;                    lda      #10 
;                    sta      VIA_t1_cnt_lo                ; controls "scale" 
;                  jsr Intensity_7F
;                  clrd
;                  MOVETO_D
;                  jsr Dot_here
;                  ldu  #Tank_69
;                  jsr  CURVY 
;                  clrd
;                  MOVETO_D
;                  jsr Dot_here
;                  ldu  #Tank_70
;				jsr draw_curved_line
;                  jsr  CURVY 
 
;                  jmp main
; END TEST
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
                    CHECK_LEVEL_DONE                      ; check if level is over (all enemies killed) 
                    CHECK_SFX                             ; sound update 
;                    ldu      #Tank_69 
;                    jsr      CURVY                        ; testing commented out RUM code ?? 
                    jmp      main                         ; and repeat forever 

;}}}
;-----------------------------------------------------------------------------------
;{{{ must go at bottom or fills up RAM instead of ROM 
                    include  "include/functions.i"                ; ...
                    include  "include/data.i"                     ; static data, shapes, tables, text
                    include  "include/libsoundraw.i"              ; quick sound effects routines
                    include  "include/rawsounddata.i"             ; the data used by
                    include  "include/rawsoundroutines.i"         ; the functions routing sounds to  3 channels
                    include  "include/rasterDraw.asm"             ; title screen from VIDE
                    include  "include/ymPlayer.i"                 ; for song under high score
                    include  "include/turmoil_ym.asm"             ; our data for above
                    include  "include/ds2431LowLevel.i"           ; high score save stuff
                    include  "include/ds2431HighLevel.i"          ; using DS2431+ 1 wire eeprom
                    include  "include/eeprom.i"                   ; uses the 2 above 
                    include  "include/draw_synced_list.i"         ; from VIDE to, draw shapes with many vectors.
end 
;}}}
