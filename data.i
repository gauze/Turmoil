; vim: ts=4
; vim: syntax=asm6809
;***************************************************************************
; VECTOR GRAPHICS DATA
;***************************************************************************
; BOXES AROUND MENU SELECTIONS []
Letter_Select_nomode: 
                    fcb      3 
                    fcb      0, +12 
                    fcb      -12, 0 
                    fcb      0, -12 
                    fcb      +12,0 
GConf_Box_nomode:   fcb      3 
                    fcb      0, 115 
                    fcb      -10, 0 
                    fcb      0, -115 
                    fcb      10, 0 
Conf_Box_nomode:    fcb      3 
                    fcb      0, 110 
                    fcb      -12, 0 
                    fcb      0, -110 
                    fcb      12, 0 
Game_Sel_Box_nomode  fcb     3 
                    fcb      0, 127 
                    fcb      -12, 0 
                    fcb      0, -127 
                    fcb      12, 0 
; WALLS AROUND ALLEYS 
Full_Wall_nomode:   fcb      5                            ; lda #5 ; sta $C823 ; vector count 
                    fcb      0,127 
                    fcb      0,127 
                    fcb      4,0 
                    fcb      0,-127 
                    fcb      0,-127 
                    fcb      -4,0 
Half_Wall:          fcb      3                            ; lda #3 ; sta $C823 
                    fcb      0,115 
                    fcb      3,0 
                    fcb      0,-115 
                    fcb      -3,0 
; Level graphic between levels, probably losing these ...
Level_Box1_nomode: 
                    fcb      3 
                    fcb      0, 100 
                    fcb      -10, 0 
                    fcb      0, -100 
                    fcb      10, 0 
Level_Box2_nomode: 
                    fcb      3 
                    fcb      0, 110 
                    fcb      -30, 0 
                    fcb      0, -110 
                    fcb      30, 0 
; SHIP 
SHIP_SCALE=1 
;ShipR_nomode:       fcb      9 
;                    fcb      +0*SHIP_SCALE, +12*SHIP_SCALE 
;                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
;                    fcb      +0*SHIP_SCALE, -9*SHIP_SCALE 
;                    fcb      +6*SHIP_SCALE, +18*SHIP_SCALE 
;                    fcb      +1*SHIP_SCALE, 0*SHIP_SCALE  ; center Move this to end ?
;                    fcb      +6*SHIP_SCALE, -18*SHIP_SCALE 
;                    fcb      +0*SHIP_SCALE, +9*SHIP_SCALE 
;                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
;                    fcb      +0*SHIP_SCALE, -12*SHIP_SCALE 
;                    fcb      -17*SHIP_SCALE, +0*SHIP_SCALE 
;ShipL_nomode:       fcb      9 
;                    fcb      +0*SHIP_SCALE, -12*SHIP_SCALE 
;                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
;                    fcb      +0*SHIP_SCALE, +9*SHIP_SCALE 
;                    fcb      +6*SHIP_SCALE, -18*SHIP_SCALE 
;                    fcb      +1*SHIP_SCALE, 0*SHIP_SCALE  ; center 
;                    fcb      +6*SHIP_SCALE, +18*SHIP_SCALE 
;                    fcb      +0*SHIP_SCALE, -9*SHIP_SCALE 
;                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
;                    fcb      +0*SHIP_SCALE, +12*SHIP_SCALE 
;                    fcb      -17*SHIP_SCALE, +0*SHIP_SCALE 
ShipR_nomode:       fcb      9 
                    fcb      +0, +21*SHIP_SCALE           ; was 10 
                                                          ; fcb +1*SHIP_SCALE, 0*SHIP_SCALE ; center Move this to end ? 
                    fcb      +6*SHIP_SCALE, -18*SHIP_SCALE ; tip 
                    fcb      +0*SHIP_SCALE, +9*SHIP_SCALE 
                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, -12*SHIP_SCALE 
                    fcb      -17*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, +12*SHIP_SCALE ; upper left corner 
                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, -9*SHIP_SCALE 
                    fcb      +6*SHIP_SCALE, +18*SHIP_SCALE 
ShipL_nomode:       fcb      9 
                    fcb      +0, -21*SHIP_SCALE 
                    fcb      +6*SHIP_SCALE, +18*SHIP_SCALE ; tip 
                    fcb      +0*SHIP_SCALE, -9*SHIP_SCALE 
                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, +12*SHIP_SCALE 
                    fcb      -17*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, -12*SHIP_SCALE ; upper right corner 
                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, +9*SHIP_SCALE 
                    fcb      +6*SHIP_SCALE, -18*SHIP_SCALE 
Ship3D_nomode:      fcb      11 
                    fcb      +0, -21*SHIP_SCALE 
                    fcb      +6*SHIP_SCALE, +18*SHIP_SCALE ; tip 
                    fcb      +0*SHIP_SCALE, -9*SHIP_SCALE 
                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, +12*SHIP_SCALE 
                    fcb      -17*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, -12*SHIP_SCALE ; upper right corner 
                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, +9*SHIP_SCALE 
                    fcb      +6*SHIP_SCALE, -18*SHIP_SCALE 
; UNUSED rectangular bullet using DOT instead
;Shot:               fcb      2,0,10                      
;                    fcb      2,1,0 
;                    fcb      2,0,-10 
;                    fcb      2,1,0 
;                    fcb      2,0,10 
;                    fcb      1 
; number of guys left 
Ship_Marker:                                              ;        UNUSED but makes assembly fail LEAVE IT 
                    fcb      3 
                    fcb      -7, +0 
                    fcb      +9, +3 
                    fcb      -9, +3 
                    fcb      +7, +0 
; Enemy list
Arrow_R_1: 
                    fcb      0, -5, 0 
                    fcb      2, +5, +5 
                    fcb      2, +0, -17 
                    fcb      2, +0, +17 
                    fcb      2, +5, -5 
                    fcb      1 
Arrow_R_2: 
                    fcb      0, -5, 0 
                    fcb      2, +3, +5 
                    fcb      2, +0, -17 
                    fcb      2, +0, +17 
                    fcb      2, +3, -5 
                    fcb      1 
Arrow_L_1: 
                    fcb      0, -5, 0 
                    fcb      2, +5, -5 
                    fcb      2, +0, +17 
                    fcb      2, +0, -17 
                    fcb      2, +5, +5 
                    fcb      1 
Arrow_L_2: 
                    fcb      0, -5, 0 
                    fcb      2, +3, -5 
                    fcb      2, +0, +17 
                    fcb      2, +0, -17 
                    fcb      2, +3, +5 
                    fcb      1 
Bow_1: 
                    fcb      0, +8, -10 
                    fcb      2, +0, +17 
                    fcb      2, -13, -17 
                    fcb      2, +0, +17 
                    fcb      2, +13, -17 
                    fcb      1 
Bow_2: 
                    fcb      0, +8, -10 
                    fcb      2, -13, +0 
                    fcb      2, +13, +17 
                    fcb      2, -13, +0 
                    fcb      2, +13, -17 
                    fcb      1 
Dash_1: 
                    fcb      0, +2, -5 
                    fcb      2, +0, +20 
                    fcb      2, -1, +0 
                    fcb      2, +0, -20 
                    fcb      2, -1, +0 
                    fcb      2, +0, +20 
                    fcb      2, -1, +0 
                    fcb      2, +0, -20 
                    fcb      2, +3, +0 
                    fcb      1 
Dash_2: 
                    fcb      0, +2, -5 
                    fcb      2, +0, +16 
                    fcb      2, -1, +0 
                    fcb      2, +0, -16 
                    fcb      2, -1, +0 
                    fcb      2, +0, +16 
                    fcb      2, -1, +0 
                    fcb      2, +0, -16 
                    fcb      2, +3, +0 
                    fcb      1 
Wedge_R: 
                    fcb      0, +5, -7 
                    fcb      $FF, -5, +17 
                    fcb      $FF, -5, -17 
                    fcb      $FF, +10, +0 
                    fcb      1 
Wedge_R_1: 
                    fcb      0, +5, -7 
                    fcb      $FF, -5, +17 
                    fcb      $FF, -5, -17 
                    fcb      $FF, +10, +0 
                    fcb      1 
Wedge_R_2: 
                    fcb      0, +3, -7 
                    fcb      $FF, -3, +17 
                    fcb      $FF, -3, -17 
                    fcb      $FF, +6, +0 
                    fcb      1 
Wedge_R_3: 
                    fcb      0, +1, -7 
                    fcb      $FF, -1, +17 
                    fcb      $FF, -1, -17 
                    fcb      $FF, +2, +0 
                    fcb      1 
Wedge_L: 
                    fcb      0, +5, -7 
                    fcb      2, -5, -17 
                    fcb      2, -5, +17 
                    fcb      2, +10, +0 
                    fcb      1 
Wedge_L_1: 
                    fcb      0, +5, -7 
                    fcb      2, -5, -17 
                    fcb      2, -5, +17 
                    fcb      2, +10, +0 
                    fcb      1 
Wedge_L_2: 
                    fcb      0, +3, -7 
                    fcb      2, -3, -17 
                    fcb      2, -3, +17 
                    fcb      2, +6, +0 
                    fcb      1 
Wedge_L_3: 
                    fcb      0, +1, -7 
                    fcb      2, -1, -17 
                    fcb      2, -1, +17 
                    fcb      2, +2, +0 
                    fcb      1 
Ghost: 
                    fcb      0, +1, -11 
                    fcb      2, +0, +22                   ; TOP 
                    fcb      2, +6, -11 
                    fcb      2, -6, -11 
                    fcb      0, -3, 0                     ; GAP 
                    fcb      2, +0, +22                   ; Bottom 
                    fcb      2, -6, -11 
                    fcb      2, +6, -11 
                    fcb      1 
Tank_R_1: 
                    fcb      0, +8, -10 
                    fcb      2, +0, -17 
                    fcb      2, -10, +2 
                    fcb      2, -10, -2 
                    fcb      2, +0, +17 
                    fcb      2, +4, +0 
                    fcb      2, +0, -6 
                    fcb      2, +4, +0 
                    fcb      2, +0, +13 
                    fcb      2, +4, +0 
                    fcb      2, +0, -13 
                    fcb      2, +4, +0 
                    fcb      2, +0, +6 
                    fcb      2, +4, +0 
                    fcb      1 
Tank_R_2: 
                    fcb      0, +8, -8 
                    fcb      2, +0, -17 
                    fcb      2, -10, +2 
                    fcb      2, -10, -2 
                    fcb      2, +0, +17 
                    fcb      2, +4, +0 
                    fcb      2, +0, -6 
                    fcb      2, +4, +0 
                    fcb      2, +0, +13 
                    fcb      2, +4, +0 
                    fcb      2, +0, -13 
                    fcb      2, +4, +0 
                    fcb      2, +0, +6 
                    fcb      2, +4, +0 
                    fcb      1                            ; endmarker 
Tank_L_1: 
                    fcb      0, +8, -10 
                    fcb      2, +0, +17 
                    fcb      2, -10, -2 
                    fcb      2, -10, +2 
                    fcb      2, +0, -17 
                    fcb      2, +4, +0 
                    fcb      2, +0, +6 
                    fcb      2, +4, +0 
                    fcb      2, +0, -13 
                    fcb      2, +4, +0 
                    fcb      2, +0, +13 
                    fcb      2, +4, +0 
                    fcb      2, +0, -6 
                    fcb      2, +4, +0 
                    fcb      1 
Tank_L_2: 
                    fcb      0, +8, -8 
                    fcb      2, +0, +17 
                    fcb      2, -10, -2 
                    fcb      2, -10, +2 
                    fcb      2, +0, -17 
                    fcb      2, +4, +0 
                    fcb      2, +0, +6 
                    fcb      2, +4, +0 
                    fcb      2, +0, -13 
                    fcb      2, +4, +0 
                    fcb      2, +0, +13 
                    fcb      2, +4, +0 
                    fcb      2, +0, -6 
                    fcb      2, +4, +0 
                    fcb      1 
Prize_1:            fcb      0, +5, 0 
                    fcb      2, -5, +7 
                    fcb      2, -5, -7 
                    fcb      2, +5, -7 
                    fcb      2, +5, +7 
                    fcb      1 
Prize_2:            fcb      0, +3, 0 
                    fcb      2, -3, +5 
                    fcb      2, -3, -5 
                    fcb      2, +3, -5 
                    fcb      2, +3, +5 
                    fcb      1 
Cannonball          fcb      0, +3, 0 
                    fcb      2, -3, +5 
                    fcb      2, -3, -5 
                    fcb      2, +3, -5 
                    fcb      2, +3, +5 
                    fcb      1 
Explode_0: 
                    fcb      0, -8, -5 
                    fcb      2, +16, +5 
                    fcb      2, -15, +5 
                    fcb      2, +10, -13 
                    fcb      2, +0, +15 
                    fcb      2, -11, -12 
                    fcb      1 
Explode_1: 
                    fcb      0, -9, +1 
                    fcb      2, +15, -6 
                    fcb      2, -9, +13 
                    fcb      2, +1, -16 
                    fcb      2, +9, +12 
                    fcb      2, -16, -3 
                    fcb      1 
Explode_2: 
                    fcb      0, -7, +6 
                    fcb      2, +9, -14 
                    fcb      2, +1, +16 
                    fcb      2, -10, -13 
                    fcb      2, +15, +4 
                    fcb      2, -15, +7 
                    fcb      1 
Explode_3: 
                    fcb      0, -2, +9 
                    fcb      2, +0, -17 
                    fcb      2, +9, +13 
                    fcb      2, -16, -5 
                    fcb      2, +15, -5 
                    fcb      2, -8, +14 
                    fcb      1 
Explode_4: 
                    fcb      0, +4, +9 
                    fcb      2, -10, -14 
                    fcb      2, +15, +5 
                    fcb      2, -16, +5 
                    fcb      2, +9, -12 
                    fcb      2, +2, +16 
                    fcb      1 
Explode_5: 
                    fcb      0, +8, +5 
                    fcb      2, -16, -5 
                    fcb      2, +15, -5 
                    fcb      2, -10, +13 
                    fcb      2, +0, -15 
                    fcb      2, +11, +12 
                    fcb      1 
Explode_6: 
                    fcb      0, +9, -1 
                    fcb      2, -15, +6 
                    fcb      2, +9, -13 
                    fcb      2, -1, +16 
                    fcb      2, -9, -12 
                    fcb      2, +16, +3 
                    fcb      1 
Explode_7: 
                    fcb      0, +7, -6 
                    fcb      2, -9, +14 
                    fcb      2, -1, -16 
                    fcb      2, +10, +13 
                    fcb      2, -15, -4 
                    fcb      2, +15, -7 
                    fcb      1 
Explode_8: 
                    fcb      0, +2, -9 
                    fcb      2, +0, +17 
                    fcb      2, -9, -13 
                    fcb      2, +16, +5 
                    fcb      2, -15, +5 
                    fcb      2, +8, -14 
                    fcb      1 
Explode_9: 
                    fcb      0, -4, -9 
                    fcb      2, +10, +14 
                    fcb      2, -15, -5 
                    fcb      2, +16, -5 
                    fcb      2, -9, +12 
                    fcb      2, -2, -16 
                    fcb      1 
Explode_10: 
                    fcb      0, -8, -5 
                    fcb      2, +16, +5 
                    fcb      2, -15, +5 
                    fcb      2, +10, -13 
                    fcb      2, +0, +15 
                    fcb      2, -11, -12 
                    fcb      1 
None:               fcb      1 
; NUMBERS all END at top right corner derive score from $c880 
; subtract $30 to get true value $20 == blank/space
NUM_GAP=65 
VNUM_SCALE=6 
zero: 
                    fcb      2, -10*VNUM_SCALE, +0 
                    fcb      2, +0, -8*VNUM_SCALE 
                    fcb      2, +10*VNUM_SCALE, +0 
                    fcb      2, +0, +8*VNUM_SCALE 
                    fcb      0, +0, +0+NUM_GAP 
                    fcb      1 
one: 
                    fcb      2, -10*VNUM_SCALE, +0 
                    fcb      0, +10*VNUM_SCALE, +0+NUM_GAP 
                                                          ;fcb 0, +0, +0+NUM_GAP 
                    fcb      1 
two: 
                    fcb      0, +0, -8*VNUM_SCALE 
                    fcb      2, +0, +8*VNUM_SCALE 
                    fcb      2, -10*VNUM_SCALE, -8*VNUM_SCALE 
                    fcb      2, +0, +8*VNUM_SCALE 
                    fcb      0, +10*VNUM_SCALE, +0+NUM_GAP 
                    fcb      1 
three:              fcb      0, +0, -8*VNUM_SCALE 
                    fcb      2, +0, +8*VNUM_SCALE 
                    fcb      2, -4*VNUM_SCALE, +0 
                    fcb      2, +0, -8*VNUM_SCALE 
                    fcb      0, +0, +8*VNUM_SCALE 
                    fcb      2, -6*VNUM_SCALE, +0 
                    fcb      2, +0, -8*VNUM_SCALE 
                    fcb      0, +10*VNUM_SCALE, +8*VNUM_SCALE+NUM_GAP 
                                                          ; fcb 0, +0, +0+NUM_GAP 
                    fcb      1 
four:               fcb      0, -10*VNUM_SCALE, 0 
                    fcb      2, +10*VNUM_SCALE, 0 
                    fcb      2, -6*VNUM_SCALE, -8*VNUM_SCALE 
                    fcb      2, +0, +8*VNUM_SCALE 
                    fcb      0, +6*VNUM_SCALE, +0+NUM_GAP 
                                                          ; fcb 0, +0, +0+NUM_GAP 
                    fcb      1 
five:               fcb      2, +0, -8*VNUM_SCALE 
                    fcb      2, -10*VNUM_SCALE, +8*VNUM_SCALE 
                    fcb      2, +0, -8*VNUM_SCALE 
                    fcb      0, +10*VNUM_SCALE, +8*VNUM_SCALE+NUM_GAP 
                    fcb      1 
six:                fcb      2, +0, -8*VNUM_SCALE 
                    fcb      2, -10*VNUM_SCALE, +0 
                    fcb      2, +0, +8*VNUM_SCALE 
                    fcb      2, +6*VNUM_SCALE, +0 
                    fcb      2, +0, -8*VNUM_SCALE 
                    fcb      0, +4*VNUM_SCALE, +8*VNUM_SCALE+NUM_GAP 
                    fcb      1 
seven:              fcb      0, -10*VNUM_SCALE, -0 
                    fcb      2, +10*VNUM_SCALE, +0 
                    fcb      2, +0, -8*VNUM_SCALE 
                    fcb      0, +0, +8*VNUM_SCALE+NUM_GAP 
                                                          ; fcb 0, +0, +0+NUM_GAP 
                    fcb      1 
eight:              fcb      2, +0, -8*VNUM_SCALE 
                    fcb      2, -10*VNUM_SCALE, +8*VNUM_SCALE 
                    fcb      2, +0, -8*VNUM_SCALE 
                    fcb      2, +10*VNUM_SCALE, +8*VNUM_SCALE 
                    fcb      0, +0, +0+NUM_GAP 
                    fcb      1 
nine:               fcb      0, -10*VNUM_SCALE, +0 
                    fcb      2, +10*VNUM_SCALE, +0 
                    fcb      2, +0, -8*VNUM_SCALE 
                    fcb      2, -6*VNUM_SCALE, +0 
                    fcb      2, +0, +8*VNUM_SCALE 
                    fcb      0, +6*VNUM_SCALE, +0+NUM_GAP 
                    fcb      1 
; LETTERS
; TODO
; STAR FIELD
; Format: brightness mode, y, x ???
starfield:          fcb      -100,100 
                    fcb      87,-2 
                    fcb      -34, -2 
                    fcb      -3 , -76 
                    fcb      -1, 45 
;****************************************************************************************
; TABLES TABLES TABLES TABLES TABLES TABLES TABLES TABLES TABLES TABLES TABLES TABLES 
;****************************************************************************************
                                                          ; align $100 
;shippos_t          fcb      -3*ALLEYWIDTH,-2*ALLEYWIDTH,-1*ALLEYWIDTH,0,1*ALLEYWIDTH,2*ALLEYWIDTH,3*ALLEYWIDTH ; Y pos of ship 
; position of cursor
cboxYpos_t          db       93,81,69,57                  ; position of select box for Joystick conf 
eeboxYpos_t         db       83,71                        ; position of select box for Joystick conf 
hsentrynYpos_t                                            ;        position of hs table 
hsboxYpos_t         db       103,91,79,67,55,43,31        ; Y,X pos of hs initials entry cusor 
hsboxXpos_t         db       -54,-31,-9,13,35,58 
; high score entry grid tables
hsgridrow           dw       hsgr0,hsgr1,hsgr2,hsgr3, hsgr4,hsgr5,hsgr6 
hsgr0               db       "A", "B", "C", "D", "E", "F"   
hsgr1               db       "G", "H", "I", "J", "K", "L"
hsgr2               db       "M", "N", "O", "P", "Q", "R"
hsgr3               db       "S", "T", "U", "V", "W", "X"
hsgr4               db       "Y", "Z", "0", "1", "2", "3"
hsgr5               db       "4", "5", "6", "7", "8", "9"
hsgr6               db       " ", ".", "!", "?", "_", "$"
; high scores + initials in RAM
hsentryn_t          dw       hsentry1n, hsentry2n, hsentry3n, hsentry4n, hsentry5n 
hsentrys_t          dw       hsentry1s, hsentry2s, hsentry3s, hsentry4s, hsentry5s 
; high scores + initials in EEPROM
ee_hs_t             dw       ee_hs1 , ee_hs2, ee_hs3, ee_hs4, ee_hs5 
ee_hsn_t            dw       ee_hsn1 , ee_hsn2, ee_hsn3, ee_hsn4, ee_hsn5 
; game positions
BULLETYPOS          =        103                          ;; trail and error for top alley 
shippos_t 
bulletYpos_t        fcb      BULLETYPOS-(ALLEYHEIGHT*6*2), BULLETYPOS-(ALLEYHEIGHT*5*2), BULLETYPOS-(ALLEYHEIGHT*4*2), BULLETYPOS-(ALLEYHEIGHT*3*2), BULLETYPOS-(ALLEYHEIGHT*2*2),BULLETYPOS-(ALLEYHEIGHT*1*2), BULLETYPOS-(ALLEYHEIGHT*0*2) 
bullete_t           fdb      bullet0e,bullet1e,bullet2e,bullet3e,bullet4e,bullet5e,bullet6e ; exists 0=false, !0= true 
bulletd_t           fdb      bullet0d,bullet1d,bullet2d,bullet3d,bullet4d,bullet5d,bullet6d ; direction left/right 
bulletx_t           fdb      bullet0x,bullet1x,bullet2x,bullet3x,bullet4x,bullet5x,bullet6x ; X position 
alleye_t            fdb      alley0e,alley1e,alley2e,alley3e,alley4e,alley5e,alley6e ; exists + type code 
alleyd_t            fdb      alley0d,alley1d,alley2d,alley3d,alley4d,alley5d,alley6d ; direction 
alleyx_t            fdb      alley0x,alley1x,alley2x,alley3x,alley4x,alley5x,alley6x ; X pos 
alleys_t            fdb      alley0s,alley1s,alley2s,alley3s,alley4s,alley5s,alley6s ; speed 
alleysd_t           fdb      alley0sd,alley1sd,alley2sd,alley3sd,alley4sd,alley5sd,alley6sd ; speed divisor 
alleyto_t           fdb      alley0to,alley1to,alley2to,alley3to,alley4to,alley5to,alley6to ; timeout before next spawn 
max_enemys_t        fcb      -1,3,4,5,5,6,6,7,7,7,7,7     ; maximum number of occupied alleys per level, repeat after 6 
bitmasks            db       0, %00000001, %00000011, %00000111, %00001111, %00011111, %00111111, %01111111, 255 
difficulty_t        db       0                            ; maybe unused if I don't add difficult setting?? 
; speed table divisor  (not used)0, 1(default), 2 , 3, 4, 5
speed_t             dw       fmt0cnt, fmt1cnt, frm2cnt, frm3cnt, frm4cnt, frm5cnt,0,0,0,0,frm10cnt ; which frame to do enemy moves on 
;speed tables 21 divisions .2, .25, .33, .5. 1, 1.5, 2, 2.5, 3, 3.5, ... , 9
speedTop_t          db       1, 1, 1, 1, 1, 1, 3, 2, 5, 3, 7, 4, 9, 5, 11, 6, 13, 7, 15, 8, 17, 9 ; move X 'pixels' 
speedBot_t          db       10, 5, 4, 3, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1 ; every Y frames 
; too unwieldy, can't increment x easily without reloading it
; all values in one table and do X+ to read next byte after loading table
;speedComb_t         db      1,10, 1,5, 1,4, 1,3, 1,2, 1,1, 2,1, 5,2, 3,1, 7,2, 4,1, 9,2, 5,1, 11,2, 6,1, 13,2, 7,1, 15,2, 8,1, 17,2, 9,1 
; and set up symbolic names for each speed with assigns
TENTH_S             =        0 
FIFTH_S             =        1 
FORTH_S             =        2 
THIRD_S             =        3 
HALF_S              =        4 
ONE_S               =        5 
ONE_AND_HALF_S      =        6 
TWO_S               =        7 
TWO_AND_HALF_S      =        8 
THREE_S             =        9 
THREE_HALF_S        =        10 
FOUR_S              =        11 
FOUR_AND_HALF       =        12 
FIVE_S              =        13 
FIVE_AND_HALF_S     =        14 
SIX_S               =        15 
SIX_AND_HALF_S      =        16 
SEVEN_S             =        17 
SEVEN_AND_HALF_S    =        18 
EIGHT_S             =        19 
EIGHT_AND_HALF_S    =        20 
NINE_S              =        21 
; LARGE table needs NEGATIVE indexes
                    db       ONE_S,HALF_S, FIFTH_S, ONE_S, TWO_S,ONE_S,ONE_AND_HALF_S, HALF_S 
                    db       THREE_S,TWO_AND_HALF_S,TWO_S,ONE_AND_HALF_S,ONE_S,HALF_S,FORTH_S,TENTH_S 
                    db       FOUR_S,THREE_S,TWO_S,ONE_S,ONE_S 
                    db       HALF_S,THIRD_S,FIFTH_S,TENTH_S,HALF_S,FORTH_S,ONE_S,ONE_S,TWO_S,THREE_S,FOUR_S 
                    db       FIVE_S,FOUR_S,THREE_S,TWO_S,ONE_AND_HALF_S,ONE_S,HALF_S,ONE_S,HALF_S 
                    db       TWO_S,FIFTH_S,TENTH_S,THREE_S,ONE_S,THIRD_S,FIVE_S,FOUR_S,THIRD_S,ONE_S 
                    db       THREE_S,TENTH_S,FIFTH_S,TWO_S,HALF_S,ONE_S,HALF_S,ONE_S,ONE_AND_HALF_S,TWO_S 
                    db       THREE_S,FOUR_S,FIVE_S, SEVEN_S,SIX_S,FIVE_S,FOUR_S,THREE_S,TWO_S,ONE_S 
                    db       HALF_S,FIFTH_S,FORTH_S,THIRD_S,HALF_S,TENTH_S,ONE_S,ONE_S,HALF_S,TWO_AND_HALF_S 
                    db       ONE_S,TWO_S,HALF_S,ONE_S,HALF_S,ONE_AND_HALF_S,ONE_S,HALF_S,TENTH_S,THIRD_S 
                    db       ONE_S,TWO_S,HALF_S,ONE_S,HALF_S,ONE_AND_HALF_S,ONE_S,HALF_S,TENTH_S,FORTH_S 
                    db       ONE_S,TWO_S,HALF_S,ONE_S,HALF_S,ONE_AND_HALF_S,ONE_S,HALF_S,TENTH_S,FIFTH_S 
                    db       TWO_AND_HALF_S,ONE_S,HALF_S,TWO_S,ONE_S,FIFTH_S,FORTH_S,THIRD_S,HALF_S,TENTH_S 
                    db       ONE_S,TWO_S,THREE_S,FOUR_S,FIVE_S,SIX_S,SEVEN_S ; level 8 (all of above and below) 
enemyspeed_t        db       ONE_S,HALF_S                 ; level 1 (2^1) 
                    db       FIFTH_S, ONE_S               ; level 2 + above (2^2) 
                    db       TWO_S,ONE_S,ONE_AND_HALF_S, HALF_S ; level 3 + above (2^3) 
                    db       THREE_S,TWO_AND_HALF_S,TWO_S,ONE_AND_HALF_S,ONE_S,HALF_S,FORTH_S,TENTH_S ; level 4 + above (2^4) 
                    db       FOUR_S,THREE_S,TWO_S,ONE_S,ONE_S ; level 5 
                    db       HALF_S,THIRD_S,FIFTH_S,TENTH_S,HALF_S,FORTH_S,ONE_S,ONE_S,TWO_S,THREE_S,FOUR_S ; level 5 + above (2^5) 
                    db       FIVE_S,FOUR_S,THREE_S,TWO_S,ONE_AND_HALF_S,ONE_S,HALF_S,ONE_S,HALF_S 
                    db       TWO_S,FIFTH_S,TENTH_S,THREE_S,ONE_S,THIRD_S,FIVE_S,FOUR_S,THIRD_S,ONE_S 
                    db       THREE_S,TENTH_S,FIFTH_S,TWO_S,HALF_S,ONE_S,HALF_S,ONE_S,ONE_AND_HALF_S,TWO_S 
                    db       THREE_S,FOUR_S,FIVE_S        ; level 6 + above (2^6) 
                    db       SEVEN_S,SIX_S,FIVE_S,FOUR_S,THREE_S,TWO_S,ONE_S 
                    db       HALF_S,FIFTH_S,FORTH_S,THIRD_S,HALF_S,TENTH_S,ONE_S,ONE_S,HALF_S,TWO_AND_HALF_S 
                    db       ONE_S,TWO_S,HALF_S,ONE_S,HALF_S,ONE_AND_HALF_S,ONE_S,HALF_S,TENTH_S,THIRD_S 
                    db       ONE_S,TWO_S,HALF_S,ONE_S,HALF_S,ONE_AND_HALF_S,ONE_S,HALF_S,TENTH_S,FORTH_S 
                    db       ONE_S,TWO_S,HALF_S,ONE_S,HALF_S,ONE_AND_HALF_S,ONE_S,HALF_S,TENTH_S,FIFTH_S 
                    db       TWO_AND_HALF_S,ONE_S,HALF_S,TWO_S,ONE_S,FIFTH_S,FORTH_S,THIRD_S,HALF_S,TENTH_S 
                    db       ONE_S,TWO_S,THREE_S,FOUR_S,FIVE_S,SIX_S,SEVEN_S ;level 7 + above (2^7) 
; END SPEED TABLES
;OBSOLETE max_speed_mask_t    fcb      1,1,1,1,3,3,3,7,7,7,7,7,7    ; masking to lower speed range 7 == 100% TODO/FIX/CHANGE 
enemylvlcnt_t       fcb      0,50,60,70,75,80,90,100,100,100,100,100,110,120,130,140,150,160,170,180,190 
                    fcb      200,210,220,230,235,240,245,250,255,255,255,255,255,255,255,255,255,255,255,255 
                    fcb      255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
                    fcb      255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
                    fcb      255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
numbers_t           fdb      zero, one, two, three, four, five, six, seven, eight, nine, zero 
; SPAWNABLE enemy table
;                                0,       1,     2,     3,        4,       5,     6,             7,       8  
enemyspawn_t        fdb      None_D, Arrow_D, Bow_D, Dash_D, Wedge_D, Prize_D 
; Possible Enemys 
enemy_t             fdb      None_D, Arrow_D, Bow_D, Dash_D, Wedge_D, Prize_D, Tank_D, Cannonball_D, Ghost_D, Explode_D 
;                                0,       1,     2,     3,        4,       5,      6,             7,       8,         9
enemyframe_t        fdb      None_f, Arrow_f, Bow_f, Dash_f, Wedge_f, Prize_f, Tank_f, Cannonball_f, Ghost_f, Explode_f 
; Enemy direction table, dupe entry means same graphics both ways;  _D = direction
; Arrow -> Tank
; Prize -> Cannonball
; Ghost only spawns when player captures prize OR lingers in alley too long (??)
None_D              fdb      None_t, None_t               ; No enemy 
Arrow_D             fdb      Arrow_L_t, Arrow_R_t 
Bow_D               fdb      Bow_t, Bow_t 
Cannonball_D        fdb      Cannonball_t, Cannonball_t 
Dash_D              fdb      Dash_t, Dash_t 
Explode_D           fdb      Explode_t, Explode_t 
Ghost_D             fdb      Ghost_t, Ghost_t 
Prize_D             fdb      Prize_t, Prize_t 
Tank_D              fdb      Tank_L_t, Tank_R_t 
Wedge_D             fdb      Wedge_L_t, Wedge_R_t 
; Animation tables counts must be mod 100 == 0 ie 1,2,4,5,10,20,25,50,100 see FRAME_CNTS macro
Arrow_L_t           fdb      Arrow_L_1, Arrow_L_2 
Arrow_R_t           fdb      Arrow_R_1, Arrow_R_2 
Bow_t               fdb      Bow_1, Bow_2, Bow_1, Bow_2, Bow_1, Bow_2, Bow_1, Bow_2, Bow_1, Bow_2 ; 
                    fdb      Bow_1, Bow_2, Bow_1, Bow_2, Bow_1, Bow_2, Bow_1, Bow_2, Bow_1, Bow_2 ; flippy 90 degree animation (100/2 frames each) 
Cannonball_t        fdb      Cannonball, Cannonball 
Dash_t              fdb      Dash_1, Dash_2               ; same, no animation (100 frames) 
Explode_t           fdb      Explode_0 ,Explode_2 ,Explode_3 ,Explode_4 ,Explode_5 ; (100/20 frames each) 
                    fdb      Explode_6 ,Explode_7 ,Explode_8 ,Explode_9 ,Explode_9 
                    fdb      Explode_0 ,Explode_2 ,Explode_3 ,Explode_4 ,Explode_5 
                    fdb      Explode_6 ,Explode_7 ,Explode_8 ,Explode_9 ,Explode_9 
Ghost_t             fdb      Ghost                        ; same, no animation (100 frames) 
None_t              fdb      None 
Tank_L_t            fdb      Tank_L_1,Tank_L_2 
Tank_R_t            fdb      Tank_R_1,Tank_R_2 
Prize_t             fdb      Prize_1,Prize_2,Prize_1,Prize_2 ; big/small animation 
Wedge_L_t           fdb      Wedge_L_1, Wedge_L_2, Wedge_L_3, Wedge_L_2 
Wedge_R_t           fdb      Wedge_R_1, Wedge_R_2, Wedge_R_3, Wedge_R_2 
Demo_Label_t        fdb      demo_label, press_btn4_start_text, press_btn2_conf_text ,press_btn1_hs_text 
default_name_t      fdb      default_name0,default_name1,default_name2,default_name3,default_name4 
default_high_t      fdb      default_high0,default_high1,default_high2,default_high3,default_high4 
thanks_t            fdb      thanks0,thanks1,thanks2,thanks3,thanks4, thanks5 
;##################################################################################
; SOUND data SOUND SOUND SOUND SOUND
;##################################################################################
LOGOEXP             db       $15,$00,$01,$01 
EXP1                db       $19,$3F,$00,$02 
EXP2                db       $3F,$00,$00,$01 
EXP3                db       $01,-1,1,$04 
;########################################################################
; RASTER GRAPHICS DATA
;########################################################################
; format:
; height, width
; shiftreg, ...,  shiftreg
; ....
; shiftreg, ...,  shiftreg
; 
; every second row is a 'backward' row
; backward rows have the direction AND the bits reversed!
alleyanxietylogo_data: 
                    db       $1C, $19                     ; height , width in bytes 
                    db       %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000010, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000 ; forward 
                    db       %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000111, %11100000, %00000000, %00000000, %00000000, %00000000, %00000000, %01000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %01111110, %01111110, %00000000, %00000000, %00000000 ; backward 
                    db       %00000000, %00111111, %10000000, %01111110, %01111110, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00111111, %10000000, %00000000, %00000000, %00000000, %00000000, %00000111, %11100000, %00000000, %00000011, %11110000, %00000000, %00000000, %00000000 ; forward 
                    db       %00000000, %00000000, %00000000, %00001111, %11000000, %00000000, %00000111, %11100000, %00000000, %00000000, %00000000, %00000000, %00000001, %11001110, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %01111110, %01111111, %00000001, %11001110, %00000000 ; backward 
                    db       %00000000, %01100001, %11000000, %11111110, %11111110, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %11100011, %10000000, %00000000, %00000000, %00000000, %00000000, %00000111, %11000000, %00000000, %00000011, %11110000, %00000000, %00000000, %00000000 ; forward 
                    db       %00000000, %00000000, %00000000, %00001111, %11100000, %00000000, %00000011, %11000000, %00000000, %00000000, %00000000, %00000000, %00000001, %11000011, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %01111111, %00111111, %00000011, %10000111, %00000000 ; backward 
                    db       %00000000, %11111001, %11000000, %11111100, %11011100, %00011111, %11100000, %11110000, %00011111, %00000000, %00000001, %11110001, %10000000, %11100011, %11110000, %01111100, %00001111, %00001111, %10000001, %11111110, %00011110, %01111111, %11100000, %00011101, %00000000 ; forward 
                    db       %00000000, %11111100, %00011111, %11111000, %00111001, %10000111, %11100001, %11110011, %11111000, %01111110, %00111001, %11111011, %10000011, %10011111, %11000000, %00000001, %11111000, %00011111, %00011000, %11111110, %00111111, %00111111, %00000011, %10111111, %10000000 ; backward 
                    db       %00000011, %11111101, %11000001, %11111100, %11111100, %11111111, %10011100, %10111000, %00111111, %10000000, %00000011, %11111101, %11000001, %10011110, %00011100, %00100111, %00111111, %11011111, %10001111, %11110001, %11011000, %11111111, %10111000, %01111111, %00000000 ; forward 
                    db       %00000000, %01111110, %00011101, %11111111, %10111011, %10011111, %11111001, %11011001, %11111111, %11001100, %01110001, %11111101, %10000011, %10111111, %11100000, %00000000, %11111110, %00111101, %00110011, %11111111, %10111111, %10011111, %10000111, %10111111, %11000000 ; backward 
                    db       %00000111, %11110101, %11100001, %11111001, %10111101, %11111000, %01101110, %11111100, %01111110, %00000000, %00001111, %11101101, %11000001, %01111111, %11011110, %00011011, %11111111, %00011111, %10111111, %10000101, %11101101, %11100001, %10111000, %11111110, %00000000 ; forward 
                    db       %00000000, %00111111, %00011101, %10000011, %11110111, %10100000, %11101101, %11111000, %00111111, %00011000, %01111011, %00011110, %11000011, %10110111, %11110000, %00000000, %01111111, %00111011, %01110110, %00011110, %11011101, %10011111, %10000111, %00100111, %11110000 ; backward 
                    db       %00001111, %11000110, %11100011, %11111011, %11111011, %00111111, %11101110, %11011100, %11111100, %00000000, %00011111, %11000100, %11000011, %01110000, %11011110, %00001100, %11111000, %00111111, %01100011, %11111101, %11101111, %11000001, %10111001, %11111000, %00000000 ; forward 
                    db       %00000000, %00011111, %11111111, %00000011, %11111111, %11111111, %11100110, %11101100, %00001111, %00110000, %00111011, %00001111, %11000111, %00110011, %11011000, %00000000, %00011111, %10111010, %01111111, %11111110, %11111111, %11001111, %11000111, %01100011, %10011000 ; backward 
                    db       %00111000, %11111110, %11100011, %11110011, %11111110, %11111111, %11111110, %01011111, %11111000, %00000000, %00110001, %11111100, %11100010, %11110000, %11111100, %00001100, %01110000, %00111111, %01101111, %11111111, %11011111, %11000000, %11011111, %11110000, %00000000 ; forward 
                    db       %00000000, %00000111, %11111011, %00000001, %11111000, %11111110, %11110110, %11111100, %00001110, %00111000, %00111111, %00000111, %01100111, %00000000, %00001110, %00000000, %00001111, %11110010, %00011111, %11111111, %01101111, %11001111, %11100111, %00000000, %00001100 ; backward 
                    db       %01101111, %11111000, %11110111, %11110011, %11110110, %01110000, %00000000, %01101111, %11100000, %00000000, %01111111, %11111000, %11100110, %11100001, %11111100, %00111111, %00110000, %00111111, %01100110, %00000000, %00011011, %10000000, %11001111, %11100000, %00000000 ; forward 
                    db       %00000000, %00000011, %11000011, %00000001, %11011000, %00000000, %11100110, %01110110, %00011100, %11111110, %00011111, %10000111, %11100111, %00111111, %11111111, %00000000, %00000111, %11000110, %00000000, %00001100, %01001111, %11101111, %11101110, %01111111, %11111110 ; backward 
                    db       %01011110, %00000011, %01110111, %11100111, %11110011, %00011000, %01111000, %01100011, %11000000, %00000001, %11111110, %00000110, %01100101, %11100001, %11111000, %11111111, %10011100, %01101110, %00100011, %10001111, %10010001, %10000000, %11000111, %10000000, %00000000 ; forward 
                    db       %00000000, %00000001, %11110110, %00011111, %00001001, %11111111, %00001100, %01111110, %00111011, %00111111, %10011111, %10000011, %10111110, %01000000, %00111111, %10000000, %00000001, %11100110, %00011111, %11100000, %10000111, %11100111, %11111110, %11000000, %00111110 ; backward 
                    db       %01111100, %00000011, %11111111, %11100111, %11100000, %11111111, %11111000, %00101111, %10000000, %00000011, %11111000, %00000011, %11111111, %11000001, %11111011, %11111000, %11111110, %01111110, %00011111, %11111111, %10011111, %11111000, %01101111, %00000000, %00000000 ; forward 
                    db       %00000000, %00000000, %01111110, %00011111, %11110000, %11111111, %11110000, %00111110, %01111110, %00001111, %11001111, %10000011, %11101111, %11000000, %00011111, %10000000, %00000000, %11111110, %00001111, %11111110, %00000111, %11100011, %11111111, %10000000, %00011110 ; backward 
                    db       %01110000, %00000000, %11100001, %10000001, %10000000, %00011111, %11000000, %01111110, %00000000, %00000000, %11100000, %00000000, %11000011, %10000000, %01100000, %11000000, %00011100, %00111000, %00000001, %11111100, %00000011, %11100000, %11111110, %00000000, %00000000 ; forward 
                    db       %00000000, %00000000, %00111111, %10000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %01111111, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000 ; backward 
                    db       %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000001, %11111100, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000011, %11111000, %00000000, %00000000 ; forward 
                    db       %00000000, %00000000, %00011111, %11000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00011111, %10000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000 ; backward 
                    db       %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000001, %11111000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000011, %11110000, %00000000, %00000000 ; forward 
                    db       %00000000, %00000000, %00000111, %10000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000111, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000 ; backward 
;***********$$$$$$$$$$$$$$$**************$$$$$$$$$$$$$$$**************$$$$$$$$$
; TEXT STRINGS
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;deadstring          fcc      "SHIP HIT!",$80
; CONFIGURATION VALUES
; OPTIONS menu
confopt_label       fcc      "CONFIGURATION OPTIONS",$80
level_start_label   fcc      "LEVEL TO START AT",$80
ee_warn1_label      fcc      "THIS WILL ERASE HIGH",$80
ee_warn2_label      fcc      "SCORES AND ALL SETTINGS",$80
hs_reset_label      fcc      "FORMAT EEPROM?",$80
confirm_text        fcc      "ARE YOU SURE?",$80
yes_text            fcc      "   YES",$80
no_text             fcc      "    NO",$80
return_text         fcc      "  EXIT",$80
; JOYSTICK menu
joycal_label        fcc      "  SHIP SPEED",$80
vslow_text          fcc      "VERY SLOW",$80
slow_text           fcc      "SLOW",$80
med_text            fcc      "MEDIUM",$80
fast_text           fcc      "FAST",$80
; GAME MODE MENU
gamemode_label      fcc      "  GAME MODE",$80
gamesel_label       fcc      "  GAME SELECT",$80
reggame_text        fcc      "CLASSICGAME",$80
supergame_text      fcc      "SUPER GAME",$80
; GENERAL
gameoverstr         fcc      "GAME OVER",$80
highscorelabel      fcc      "HIGH SCORE",$80
thankstolabel       fcc      "THANKS TO:",$80
; HIGH SCORE ENTRY STUFF 
new_hs_label        fcc      "NEW HIGH SCORE",$80
press_btn3_text     fcc      "PRESS BUTTON 3 TO BACKSPACE",$80
press_btn4_text     fcc      "PRESS BUTTON 4 TO ENTER",$80
finish_btn4_text    fcc      "PRESS BUTTON 4 TO FINISH",$80
select_btn4_text    fcc      "PRESS BUTTON 4 TO SELECT",$80
;
; Demo button stuff
demo_label          fcc      "     DEMO MODE    ",$80
press_btn4_start_text  fcc   "BUTTON 4 TO START",$80
press_btn2_conf_text  fcc    "BUTTON 2 TO CONFIG",$80
press_btn1_hs_text  fcc      "BUTTON 1 TO VIEW HIGHSCORES",$80
; high score entry 
hs_abc_1            fcc      "A B C D E F",$80
hs_abc_2            fcc      "G H I J K L",$80
hs_abc_3            fcc      "M N O P Q R",$80
hs_abc_4            fcc      "S T U V W X",$80
hs_abc_5            fcc      "Y Z 0 1 2 3",$80
hs_abc_6            fcc      "4 5 6 7 8 9",$80
hs_abc_7            fcc      "  . ! ? _ $",$80
; default highs if ds2431 is corrupted or not found
default_high0       fcc      "  5000",$80
default_high1       fcc      "  4000",$80
default_high2       fcc      "  3000",$80
default_high3       fcc      "  2000",$80
default_high4       fcc      "  1000",$80
;test_score          fcc      " 50000",$80
default_name0       fcc      "GOZ",$80
default_name1       fcc      "JAW",$80
default_name2       fcc      "GGG",$80
default_name3       fcc      "GCE",$80
default_name4       fcc      "GZE",$80
default_shipspeed   db       3                            ; medium 
default_gamemode    db       0                            ; classic game 
eeprom_filler       db       0,0,0,0,0                    ; padding to 63 bytes 
; misc
thanks0             fcc      "   MALBAN, VECTREXER   ",$80
thanks1             fcc      " VECTORX, TODD W, EFNET",$80
thanks2             fcc      "   CHRIS BINARYSTAR    ",$80
thanks3             fcc      "THOMAS S, CHRIS PARSONS",$80 
thanks4             fcc      " ARCADE WEDNESDAY CREW ",$80
thanks5             fcc      "   DER LUCHS, V.ROLI   ",$80
                    fcc      "SECRET GAME",$80
credits             fcc      "PROGRAMMED BY GAUZE 2016-2020",$80 
                    FCC      "DISASSEMBLED BY MALBAN",$6B
                    fcc      "KARRSOFT82LDMCBCJT82LDMCBCJ"
; table negative indexes start here 128-255 leave as reminder 
;                     db       128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255
;shit_t               db       0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127, 42, 69
