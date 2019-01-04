;***************************************************************************
; DEFINE SECTION
;***************************************************************************
; load vectrex bios routine definitions
                    INCLUDE  "VECTREX.I"                  ; vectrex function includes
;***************************************************************************
; Variable / RAM SECTION
;***************************************************************************
; insert your variables (RAM usage) in the BSS section
; user RAM starts at $c880 
                    BSS                                   ; Block Started by Symbol 
                    ORG      $c880                        ; start of our ram space 
top0                db       1 
top1                db       1 
top2                db       1 
;right               db       1 
bright              db       1 
;***************************************************************************
LEVEL_SPLASH        macro    
; Lines from center to edge
                    jsr      Intensity_5F 
	bra  skip
                    jsr      Reset0Ref 
                    clra     
                    clrb     
                    jsr      Moveto_d 
                    lda      #127 
                    ldb      #127 
                    jsr      Draw_Line_d 
                    jsr      Reset0Int 
                    clra     
                    clrb     
                    jsr      Moveto_d 
                    lda      #127 
                    ldb      #-128 
                    jsr      Draw_Line_d 
                    jsr      Reset0Ref 
                    clra     
                    clrb     
                    jsr      Moveto_d 
                    lda      #-128 
                    ldb      #127 
                    jsr      Draw_Line_d 
                    jsr      Reset0Ref 
                    clra     
                    clrb     
                    jsr      Moveto_d 
                    lda      #-128 
                    ldb      #-128 
                    jsr      Draw_Line_d 
                    jsr      Reset0Ref 
skip
; first box
                    lda      top0 
                    jsr      Intensity_a 
                    lda      top0 
                    ldb      top0 
                    negb     
                    jsr      Moveto_d 
;
                    clra                                  ; Y movement 
                    ldb      top0                         ; X movement 
                    jsr      Draw_Line_d 
                    clra                                  ; Y movement 
                    ldb      top0                         ; X movement 
                    jsr      Draw_Line_d 
;
                    clrb                                  ; Y movement 
                    lda      top0                         ; X movement 
                    nega     
                    jsr      Draw_Line_d 
                    clrb                                  ; Y movement 
                    lda      top0                         ; X movement 
                    nega     
                    jsr      Draw_Line_d 
;
                    clra                                  ; Y movement 
                    ldb      top0                         ; X movement 
                    negb     
                    jsr      Draw_Line_d 
                    clra                                  ; Y movement 
                    ldb      top0 
                    negb                                  ; X movement 
                    jsr      Draw_Line_d 
;
                    clrb                                  ; Y movement 
                    lda      top0                         ; X movement 
                    jsr      Draw_Line_d 
                    clrb                                  ; Y movement 
                    lda      top0                         ; X movement 
                    jsr      Draw_Line_d 
; 2nd box
                    jsr      Reset0Ref 
                    lda      top1 
                    jsr      Intensity_a 
                    lda      top1 
                    ldb      top1 
                    negb     
                    jsr      Moveto_d 
;
                    clra                                  ; Y movement 
                    ldb      top1                         ; X movement 
                    jsr      Draw_Line_d 
                    clra                                  ; Y movement 
                    ldb      top1                         ; X movement 
                    jsr      Draw_Line_d 
;
                    clrb                                  ; Y movement 
                    lda      top1                         ; X movement 
                    nega     
                    jsr      Draw_Line_d 
                    clrb                                  ; Y movement 
                    lda      top1                         ; X movement 
                    nega     
                    jsr      Draw_Line_d 
;
                    clra                                  ; Y movement 
                    ldb      top1                         ; X movement 
                    negb     
                    jsr      Draw_Line_d 
                    clra                                  ; Y movement 
                    ldb      top1 
                    negb                                  ; X movement 
                    jsr      Draw_Line_d 
;
                    clrb                                  ; Y movement 
                    lda      top1                         ; X movement 
                    jsr      Draw_Line_d 
                    clrb                                  ; Y movement 
                    lda      top1                         ; X movement 
                    jsr      Draw_Line_d 
; 3rd box
                    jsr      Reset0Ref 
                    lda      top2 
                    jsr      Intensity_a 
                    lda      top2 
                    ldb      top2 
                    negb     
                    jsr      Moveto_d 
;
                    clra                                  ; Y movement 
                    ldb      top2                         ; X movement 
                    jsr      Draw_Line_d 
                    clra                                  ; Y movement 
                    ldb      top2                         ; X movement 
                    jsr      Draw_Line_d 
;
                    clrb                                  ; Y movement 
                    lda      top2                         ; X movement 
                    nega     
                    jsr      Draw_Line_d 
                    clrb                                  ; Y movement 
                    lda      top2                         ; X movement 
                    nega     
                    jsr      Draw_Line_d 
;
                    clra                                  ; Y movement 
                    ldb      top2                         ; X movement 
                    negb     
                    jsr      Draw_Line_d 
                    clra                                  ; Y movement 
                    ldb      top2 
                    negb                                  ; X movement 
                    jsr      Draw_Line_d 
;
                    clrb                                  ; Y movement 
                    lda      top2                         ; X movement 
                    jsr      Draw_Line_d 
                    clrb                                  ; Y movement 
                    lda      top2                         ; X movement 
                    jsr      Draw_Line_d 
; check loops below till end
                    inc      top0 
                    lda      #127 
                    cmpa     top0 
                    bne      top0ok 
                    clra     
                    sta      top0 
top0ok 
                    inc      top1 
                    lda      #127 
                    cmpa     top1 
                    bne      top1ok 
                    clra     
                    sta      top1 
top1ok 
                    inc      top2 
                    lda      #127 
                    cmpa     top2 
                    bne      main 
                    clra     
                    sta      top2 
                    endm     
;***************************************************************************
; HEADER SECTION
;***************************************************************************
; The cartridge ROM starts at address 0
                    CODE     
                    ORG      0 
; the first few bytes are mandatory, otherwise the BIOS will not load
; the ROM file, and will start MineStorm instead
                    DB       "g GCE 2019", $80 ; 'g' is copyright sign
                    DW       music1                       ; music from the rom 
                    DB       $F8, $50, $20, -$80          ; hight, width, rel y, rel x (from 0,0) 
                    DB       "3D HALLWAY", $80            ; some game information, ending with $80
                    DB       0                            ; end of game header 
; init variables
                    clra     
                    sta      top0 
                    lda      #33 
                    sta      top1 
                    lda      #66 
                    sta      top2 
;                    sta      right 
                    lda      #127 
                    sta      bright 
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
                    lda      #127 
                    sta      VIA_t1_cnt_lo                ; sets scale 
main: 
                    JSR      Wait_Recal                   ; Vectrex BIOS recalibration 
                    JSR      Intensity_5F                 ; Sets the intensity of the 
                                                          ; vector beam to $5f 
                                                           LDU #hello_world_string ; address of string 
                                                           LDA #$10 ; Text position relative Y 
                                                           LDB #-$50 ; Text position relative X 
                                                           JSR Print_Str_d ; Vectrex BIOS print routine 
                    lda      #164 
                    sta      VIA_t1_cnt_lo                ; sets scale 
                    LEVEL_SPLASH  
                    BRA      main                         ; and repeat forever 

;***************************************************************************
; DATA SECTION
;***************************************************************************
hello_world_string: 
                    DB       "HELLO WORLD"                ; only capital letters
                    DB       $80                          ; $80 is end of string 
