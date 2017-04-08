;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; vim: ts=4
; vim: syntax=asm6809
; MACROS
READ_BUTTONS        macro    
                    jsr      Read_Btns 
                    lda      Vec_Button_1_2 
                    beq      toad 
                    lda      #1 
                    sta      Ship_Dead 
toad 
                    lda      Vec_Btn_State 
                    beq      no_press 
                                                          ; adding bullet to alley if no other bullet is already there 
                    lda      shippos 
                    asla     
                    ldx      #bullete_t 
                    ldx      a,x 
                    lda      ,x 
                    bne      already_exists 
                    ldb      #1 
                    stb      ,x                           ; set EXIST 
; left(0) or right(1)?
                    lda      shippos 
                    asla     
                    ldx      #bulletd_t 
                    ldb      shipdir 
                    ldx      b,x 
                    stb      ,x                           ; set DIRECTION 
; starting x coordinates
                    lda      shippos 
                    asla     
                    ldx      #bulletx_t 
                    ldx      a,x 
                    ldb      shipdir 
                    beq      negstart 
                    ldb      #6 
                    stb      ,x                           ; set start X 
                    bra      newshotdone 

negstart 
                    ldb      #-9 
                    stb      ,x                           ; set start -X 
newshotdone 
no_press 
already_exists 
                    endm                                  ; rts 


NEW_ENEMY         macro    
; need code to generate new random enemy OR prize in random alley
; type, and direction, direction decides initial X placement
; store answer in alleyNe (value from enemy_t offset), (bool)alleyNd (0 left, 1 right), (signed int)alleyNx (-127 or 127 )
                    

                    ; don't even do spawn logic if maximum enemies are out
                    lda     level
                    ldx     max_enemys_t
                    lda     a,x
                    cmpa     enemycnt
                    bge     enemy_done    
                    

                    lda     alley0e
                    bne     enemy_done
                    jsr      Random_3  
                    sta      temp                        
                    anda     #%00000011                    ; mask off top 5 bits to limit answer 0-3
                    adda     #1                           ; and add 1, use with enemyspawn_t table
                    sta      alley0e                        

                    ; figure out speed stuff here
                    lda      temp
                    anda     #%11100000
                    lsra
                    lsra
                    lsra
                    lsra
                    lsra                                  ; mask top 3 bits, shift til 3 bits 0-7             
                    sta      alley0s
                    ; initial direction which sets initial X pos
                    lda      temp
                    anda     #%00010000                    ; mask some other random bit to derive start direction
                    lsra    
                    lsra 
                    lsra 
                    lsra  
                    sta      alley0d

                    beq      set_enemy_going_left
                    lda      #-126
                    sta      alley0x
                    bra      enemy_done
set_enemy_going_left
                    lda      #126
                    sta      alley0x
enemy_done

                    endm   

  
RESET0REF           macro    
                    ldd      #$00CC 
                    stb      <VIA_cntl                    ;/BLANK low and /ZERO low 
                    sta      <VIA_shift_reg               ;clear shift register 
                    ldd      #$0302 
                    clr      <VIA_port_a                  ;clear D/A register 
                    sta      <VIA_port_b                  ;mux=1, disable mux 
                    stb      <VIA_port_b                  ;mux=1, enable mux 
                    stb      <VIA_port_b                  ;do it again 
                    ldb      #$01 
                    stb      <VIA_port_b                  ;disable mu 
                    endm     
MOVETO_D            macro    
                    local    MLF318, MLF33B,MLF33D,MLF341,MLF345,moveto_d_done 
                    sta      <VIA_port_a                  ;Store Y in D/A register 
                    clr      <VIA_port_b                  ;Enable mux 
                    pshs     b,a                          ;Save D-register on stack 
MLF318:             lda      #$CE                         ;Blank low, zero high? 
                    sta      <VIA_cntl 
                    clr      <VIA_shift_reg               ;Clear shift regigster 
                    inc      <VIA_port_b                  ;Disable mux 
                    stb      <VIA_port_a                  ;Store X in D/A register 
                    clr      <VIA_t1_cnt_hi               ;timer 1 count high 
                    puls     a,b                          ;Get back D-reg 
                    jsr      Abs_a_b 
                    stb      -1,s 
                    ora      -1,s 
                    ldb      #$40 
                    cmpa     #$40 
                    bls      MLF345 
                    cmpa     #$64 
                    bls      MLF33B 
                    lda      #$08 
                    bra      MLF33D 

MLF33B:             lda      #$04                         ;Wait for timer 1 
MLF33D:             bitb     <VIA_int_flags 
                    beq      MLF33D 
MLF341:             deca                                  ;Delay a moment 
                    bne      MLF341 
                    bra      moveto_d_done 

MLF345:             bitb     <VIA_int_flags               ;Wait for timer 1 
                    beq      MLF345 
moveto_d_done 
                    endm     
INTENSITY_A         macro    
                    sta      <VIA_port_a                  ;Store intensity in D/A 
                    sta      Vec_Brightness               ;Save intensity in $C827 
                    ldd      #$0504                       ;mux disabled channel 2 
                    sta      <VIA_port_b 
                    stb      <VIA_port_b                  ;mux enabled channel 2 
                    stb      <VIA_port_b                  ;do it again just because 
                    ldb      #$01 
                    stb      <VIA_port_b                  ;turn off mux 
                    endm     
JOYSTICK_TEST       macro    
                    jsr      Joy_Digital 
                    lda      in_alley                     ; inside an alley 
                    bne      jsdoneY                      ; disable Y position poll 
                    lda      Vec_Joy_1_Y 
                    beq      jsdoneY                      ; no Y motion 
                    bmi      going_down 
                    lda      shippos 
                    cmpa     #6                           ; slot 6 as far up as u can go 
                    beq      jsdoneY 
                    inc      shippos 
                    bra      jsdoneY 

going_down 
                    lda      shippos 
                    beq      jsdoneY 
                    dec      shippos 
jsdoneY 
                
; now test X first test should be if there is a prize in this alley.
                    ldb      shipXpos                ; is X basically in the middle alley? unset in_alley flag
                    jsr      Abs_b
                    cmpb     #3
                    bpl      leave_flag              ; if b-3 > 0 then clr in_alley 
                    clr      in_alley                ; clear in alley flag when in middle
leave_flag
                    lda      Vec_Joy_1_X 
                    beq      jsdoneX 
                    bmi      going_left 
going_right
                    lda      #1 
                    sta      in_alley 
                    lda      #RIGHT 
                    sta      shipdir 
                    lda      #4 
                   ; adda     shipXpos 
                    bvs      setMaxRight
                    bra      setRightDone
setMaxRight
                    lda      #110
setRightDone
                  ;  sta      shipXpos 
                    bra      jsdoneX 

going_left 
                    lda      #1 
                    sta      in_alley 
                    lda      #LEFT 
                    sta      shipdir 
                    lda     shipXpos
                    suba    #4
                    bvs      setMaxLeft
                    bra      setLeftDone
setMaxLeft
                    lda      #-110
setLeftDone 
                  ;  sta      shipXpos 
jsdoneX 
                    endm

     
DRAW_VLC            macro    
                    local    LF3F4,Draw_VLa
                    lda      ,x+ 
Draw_VLa 
                    sta      $C823 
                    ldd      ,x 
                    sta      <VIA_port_a                  ;Send Y to A/D 
                    clr      <VIA_port_b                  ;Enable mux 
                    leax     2,x                          ;Point to next coordinate pair 
                    nop                                   ;Wait a moment 
                    inc      <VIA_port_b                  ;Disable mux 
                    stb      <VIA_port_a                  ;Send X to A/D 
                    ldd      #$FF00                       ;Shift reg=$FF (solid line), T1H=0 
                    sta      <VIA_shift_reg               ;Put pattern in shift register 
                    stb      <VIA_t1_cnt_hi               ;Set T1H (scale factor?) 
                    ldd      #$0040                       ;B-reg = T1 interrupt bit 
LF3F4:              bitb     <VIA_int_flags               ;Wait for T1 to time out 
                    beq      LF3F4 
                    nop                                   ;Wait a moment more 
                    sta      <VIA_shift_reg               ;Clear shift register (blank output) 
                    lda      $C823                        ;Decrement line count 
                    deca     
                    bpl      Draw_VLa                     ;Go back for more points 
                                                          ; jmp Check0Ref ;Reset zero reference if necessary 
                    endm     
