; vim: ts=4
; vim: syntax=asm6809
                    title    "Alley Anxiety"
; DESCRIPTION
; Port of 20th Century Fox Atari 2600 game Turmoil
;
;#TOOLS USED
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
                    fcc      "-2018", $80                 ; 3 solid blocks ending with $80 
                    db       0                            ; end of game header 
;                   bra restart ; TESTING skip intro to get right to it.  
		
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
; here the cartridge program starts off   
introSplash 
                    lda      #1 
                    sta      Demo_Mode                    ; in Demo_Mode on boot 
                    ldu      #ustacktemp 
                    stu      ustacktempptr                ; only do this once 
                    jsr      setup                        ; remove when done testing 
                    jsr      fill_hs_tbl 				; filling from ROM eventually pull from EPROM
                    jsr      titleScreen 
                                                         
                    jsr      joystick_config              ; move else were? 
restart 
                    ldd      #$3075 
                    std      Vec_Rfrsh                    ; make sure we are at 50hz 
                    jsr      setup 
                    jsr      levelsplash 
;start 
                    lda      #0 
                    sta      shipYpos 
                    sta      shipXpos 
                    sta      In_Alley 
                    sta      Ship_Dead 
                    ldb      #LEFT 
                    stb      shipdir 
                    ldx      #score 
                    jsr      Clear_Score 
                    lda      #1                           ; normally 5 FIX 
                    sta      shipcnt 
                    lda      #$5F                         ; for high score input _ under scores _ 
                    sta      hstempstr 
                    sta      hstempstr+1 
                    sta      hstempstr+2 
                    lda      #$80                         ; EOL 
                    sta      hstempstr+3 
;----------------------------------------------------------------------------
main: 
                    jsr      Wait_Recal 
				  jsr      Do_Sound
                    READ_JOYSTICK  
                    lda      #$5F 
                    INTENSITY_A  
				  ldd     #$FFFF
                    DRAW_LINE_WALLS  
				  ldd     #$FFFF
                    DRAW_SHIP  
                    READ_BUTTONS  
                    MOVE_BULLETS  
                    lda      #$7F 
                    INTENSITY_A  
                    DRAW_BULLETS  
                    lda      #$5F 
                    INTENSITY_A  
                                                          ; display score and ships left 
                    DRAW_VECTOR_SCORE  
                    lda      #127                         ; scale 
                    sta      VIA_t1_cnt_lo 
                    PRINT_SHIPS  
; decrement counters on alley respawn timeouts                                    ; jmp no_score 
no_score: 
                    ldd      prizecnt                     ; minumum counter for time between prize spawns 
                    addd     #1 
                    std      prizecnt 
                    lda      Is_Prize 
                    beq      noprizecntdown 
                    dec      prizecntdown 
noprizecntdown 
; end score+ship count
                    NEW_ENEMY  
                    FRAME_CNTS  
                    MOVE_ENEMYS  
                    DRAW_ENEMYS  
                    SHOT_COLLISION_DETECT  
                    SHIP_Y_COLLISION_DETECT  
                    SHIP_X_COLLISION_DETECT  
                    STALL_CHECK                           ; can't just sit in an open alley forever... 
                    ALLEY_TIMEOUT  
;
                    lda      Level_Done                   ; check level_done flag 
                    lbeq     nolevel 
                    jsr      newlevel                     ; and run routine 
nolevel 
                    CHECK_DEMO                            ; routine to handle button press during demo mode 
                    jmp      main                         ; and repeat forever, sorta 

; must go at bottom or fills up RAM instead of ROM 
                    include  "functions.i"
                    include  "data.i"
                    include  "rasterDraw.asm"
end 
