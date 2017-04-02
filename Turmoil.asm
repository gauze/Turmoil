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
score               equ      *                            ; 7 bytes 
highscore           equ      score+7                      ; 7 bytes 
shipdir             equ      highscore+7                  ; 1 byte 
shippos             equ      shipdir+1 
shipXpos            equ      shippos+1 
in_alley            equ      shipXpos+1 
bullet0e            equ      in_alley+1 
bullet1e            equ      bullet0e+1                   ; shit Exists in alley 
bullet2e            equ      bullet1e+1 
bullet3e            equ      bullet2e+1 
bullet4e            equ      bullet3e+1 
bullet5e            equ      bullet4e+1 
bullet6e            equ      bullet5e+1 
bullet0d            equ      bullet6e+1 
bullet1d            equ      bullet0d+1                   ; travel direction 
bullet2d            equ      bullet1d+1 
bullet3d            equ      bullet2d+1 
bullet4d            equ      bullet3d+1 
bullet5d            equ      bullet4d+1 
bullet6d            equ      bullet5d+1 
bullet0x            equ      bullet6d+1 
bullet1x            equ      bullet0x+1                   ; location on X axis 
bullet2x            equ      bullet1x+1 
bullet3x            equ      bullet2x+1 
bullet4x            equ      bullet3x+1 
bullet5x            equ      bullet4x+1 
bullet6x            equ      bullet5x+1 
alley0e             equ      bullet6x+1                   ; is there a monster in the alley? (Exists?) 
alley1e             equ      alley0e+1 
alley2e             equ      alley1e+1 
alley3e             equ      alley2e+1 
alley4e             equ      alley3e+1 
alley5e             equ      alley4e+1 
alley6e             equ      alley5e+1 
alley0d             equ      alley6e+1                    ; which way is the monster moving? 
alley1d             equ      alley0d+1 
alley2d             equ      alley1d+1 
alley3d             equ      alley2d+1 
alley4d             equ      alley3d+1 
alley5d             equ      alley4d+1 
alley6d             equ      alley5d+1 
alley0x             equ      alley6d+1                    ; where monster is on x axis 
alley1x             equ      alley0x+1 
alley2x             equ      alley1x+1 
alley3x             equ      alley2x+1 
alley4x             equ      alley3x+1 
alley5x             equ      alley4x+1 
alley6x             equ      alley5x+1 
bullet_count        equ      alley6x+1                    ; 1 byte 
ships_left          equ      bullet_count+1               ; 1 byte 
bulletYtemp         equ      ships_left+1 
Ship_Dead           equ      bulletYtemp+1 
temp                equ      Ship_Dead+1                  ; 2 bytes temp 
; variables to hold which frame for each shape enemy
; Arrow_t, Bow_t, Dash, Wedge_t, Ghost_t, Prize_t ;, CannonBall ;, Tank
Arrow_f             equ      temp+2 
Bow_f               equ      Arrow_f+1 
Dash_f              equ      Bow_f+1 
Wedge_f             equ      Dash_f+1 
Ghost_f             equ      Wedge_f+1 
Prize_f             equ      Ghost_f+1 
Cannonball_f        equ      Prize_f+1 
Tank_f              equ      Cannonball_f+1 
; frame counts for animations
frm100cnt           equ      Tank_f+1 
frm50cnt            equ      frm100cnt+1 
frm25cnt            equ      frm50cnt+1 
frm20cnt            equ      frm25cnt+1 
frm10cnt            equ      frm20cnt+1 
frm5cnt             equ      frm10cnt+1 
frm2cnt             equ      frm5cnt+1 
;
; CONSTANTS place after VARIABLES
ALLEYWIDTH          equ      17 
LEFT                equ      0 
RIGHT               equ      1 
;FALSE               equ      0 
;TRUE                equ      1 
MOVEAMOUNT          equ      8                            ; how many 'pixels per frame' FIX 
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
; end score+ship count
;;;; DRAW VARIOUS STUFF TEST ZONE
                    RESET0REF  
                    ldx      #bulletYpos_t 
                    lda      #6 
                    lda      a,x                          ; Y 
                    ldb      #-80                         ; X 
                    MOVETO_D  
                    lda      framecnt 
                    cmpa     #25 
                    bgt      bowl 
                    ldx      #Prize_t 
                    lda      #0 
                    ldx      a,x 
                                                          ; ldx #Prize_1 ; animation Primitive, switch every 100 frames 
                    bra      dobowdraw 

bowl 
                    ldx      #Prize_t 
                    lda      #2 
                    ldx      a,x 
dobowdraw 
                    jsr      Draw_VL_mode 
                    RESET0REF  
                    ldx      #bulletYpos_t 
                    lda      #0 
                    lda      a,x                          ; Y 
                                                          ; clra 
                                                          ; clrb ; X 
                    ldb      #-80 
                    MOVETO_D  
                    ldx      #Wedge_L                     ; 
                    jsr      Draw_VL_mode 
; increment then Test frame counter
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
                    bne      no100cntreset 
                    clr      frm5cnt 

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
no50cntreset

                    lda      #100                         ; frame count 100=2 seconds (at full speed) 0-99 == 100 
                                                          ; frame freq 1, 2, 4, 5, 10, 20, 25,50, 100 
                                                          ; frame len .02, .04, .08, .1, .2, .4, .5, 1, 2 
                    inc      frm100cnt 
                    cmpa     frm100cnt 
                    bne      no100cntreset 
                    clr      frm100cnt 
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
                    sta      framecnt 
                    sta      Arrow_f 
                    sta      Bow_f 
                    sta      Dash_f 
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

;***************************************************************************
; DATA SECTION
;***************************************************************************
                    					include  "data.i"
; JUNK below
;***************************************************************************
; SCRATCH AREA
;example
;                    ldu      #vData                       ; address of list 
;                    LDA      #$0                          ; Text position relative Y 
;                    LDB      #-$0                         ; Text position relative X 
;                    tfr      d,x                          ; in x position of list 
;                    lda      #$40                         ; scale positioning 
;                    ldb      #$40                         ; scale move in list 
;                    jsr      draw_synced_list 
;                    BRA      main                         ; and repeat forever 
;
;;***************************************************************************
;; SUBROUTINE SECTION
;;***************************************************************************
;;ZERO ing the integrators takes time. Measures at my vectrex show e.g.:
;;If you move the beam with a to x = -127 and y = -127 at diffferent scale values, the time to reach zero:
;;- scale $ff -> zero 110 cycles
;;- scale $7f -> zero 75 cycles
;;- scale $40 -> zero 57 cycles
;;- scale $20 -> zero 53 cycles
;ZERO_DELAY          EQU      7                            ; delay 7 counter is exactly 111 cycles delay between zero SETTING and zero unsetting (in moveto_d) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;U = address of vectorlist
;;X = (y,x) position of vectorlist (this will be point 0,0), positioning on screen
;;A = scalefactor "Move" (after sync)
;;B = scalefactor "Vector" (vectors in vectorlist)
;;
;;     mode, rel y, rel x,                                             
;;     mode, rel y, rel x,                                             
;;     .      .      .                                                
;;     .      .      .                                                
;;     mode, rel y, rel x,                                             
;;     0x02
;; where mode has the following meaning:         
;; negative draw line                    
;; 0 move to specified endpoint                              
;; 1 sync (and move to list start and than to place in vectorlist)      
;; 2 end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;draw_synced_list: 
;                    pshs     a                            ; remember out different scale factors 
;                    pshs     b 
;                                                          ; first list entry (first will be a sync + moveto_d, so we just stay here!) 
;                    lda      ,u+                          ; this will be a "1" 
;sync: 
;                    deca                                  ; test if real sync - or end of list (2) 
;                    lbne     drawdone                     ; if end of list -> jump 
;; zero integrators
;                    ldb      #$CC                         ; zero the integrators 
;                    stb      <VIA_cntl                    ; store zeroing values to cntl 
;                    ldb      #ZERO_DELAY                  ; and wait for zeroing to be actually done 
;; reset integrators
;                    clr      <VIA_port_a                  ; reset integrator offset 
;                    lda      #%10000010 
;; wait that zeroing surely has the desired effect!
;zeroLoop: 
;                    sta      <VIA_port_b                  ; while waiting, zero offsets 
;                    decb     
;                    bne      zeroLoop 
;                    inc      <VIA_port_b 
;; unzero is done by moveto_d
;                    lda      1,s                          ; scalefactor move 
;                    sta      <VIA_t1_cnt_lo               ; to timer t1 (lo= 
;                    tfr      x,d                          ; load our coordinates of "entry" of vectorlist 
;                    MOVETO_D                              ; move there 
;                    lda      ,s                           ; scale factor vector 
;                    sta      <VIA_t1_cnt_lo               ; to timer T1 (lo) 
;moveTo: 
;                    ldd      ,u++                         ; do our "internal" moveto d 
;                    beq      nextListEntry                ; there was a move 0,0, if so 
;                    MOVETO_D  
;nextListEntry: 
;                    lda      ,u+                          ; load next "mode" byte 
;                    beq      moveTo                       ; if 0, than we should move somewhere 
;                    bpl      sync                         ; if still positive it is a 1 pr 2 _> goto sync 
;; now we should draw a vector 
;                    ldd      ,u++                         ;Get next coordinate pair 
;                    STA      <VIA_port_a                  ;Send Y to A/D 
;                    CLR      <VIA_port_b                  ;Enable mux 
;                    LDA      #$ff                         ;Get pattern byte 
;                    INC      <VIA_port_b                  ;Disable mux 
;                    STB      <VIA_port_a                  ;Send X to A/D 
;                    LDB      #$40                         ;B-reg = T1 interrupt bit 
;                    CLR      <VIA_t1_cnt_hi               ;Clear T1H 
;                    STA      <VIA_shift_reg               ;Store pattern in shift register 
;setPatternLoop: 
;                    BITB     <VIA_int_flags               ;Wait for T1 to time out 
;                    beq      setPatternLoop               ; wait till line is finished 
;                    CLR      <VIA_shift_reg               ; switch the light off (for sure) 
;                    bra      nextListEntry 
;
;drawdone: 
;                    puls     d                            ; correct stack and go back 
;                    rts      
;
;;***************************************************************************
;; DATA SECTION
;;***************************************************************************
;vData               =        Tank 
;Tank: 
;                    fcb      +1, +8, -10                  ; sync and move to y, x 
;                    fcb      -1, +0, +21                  ; draw, y, x 
;                    fcb      -1, -4, +0                   ; draw, y, x 
;                    fcb      -1, +0, -9                   ; draw, y, x 
;                    fcb      -1, -3, +0                   ; draw, y, x 
;                    fcb      -1, +0, +9                   ; draw, y, x 
;                    fcb      -1, -2, +0                   ; draw, y, x 
;                    fcb      -1, +0, -9                   ; draw, y, x 
;                    fcb      -1, -3, +0                   ; draw, y, x 
;                    fcb      -1, +0, +9                   ; draw, y, x 
;                    fcb      -1, -4, +0                   ; draw, y, x 
;                    fcb      +1, -8, +11                  ; sync and move to y, x 
;                    fcb      -1, +0, -21                  ; draw, y, x 
;                    fcb      -1, +5, +0                   ; draw, y, x 
;                    fcb      -1, +0, +2                   ; draw, y, x 
;                    fcb      -1, +2, +0                   ; draw, y, x 
;                    fcb      -1, +0, -2                   ; draw, y, x 
;                    fcb      -1, +2, +0                   ; draw, y, x 
;                    fcb      -1, +0, +2                   ; draw, y, x 
;                    fcb      -1, +2, +0                   ; draw, y, x 
;                    fcb      -1, +0, -2                   ; draw, y, x 
;                    fcb      -1, +5, +0                   ; draw, y, x 
;                    fcb      +2                           ; endmarker 
