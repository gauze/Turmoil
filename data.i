; vim: ts=4
; vim: syntax=asm6809
;***************************************************************************
; VECTOR GRAPHICS DATA
;***************************************************************************
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
; SHIP 
SHIP_SCALE=1 
ShipR_nomode:       fcb      9                          
                    fcb      +0*SHIP_SCALE, +17*SHIP_SCALE 
                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, -12*SHIP_SCALE 
                    fcb      +6*SHIP_SCALE, +20*SHIP_SCALE 
                    fcb      +1*SHIP_SCALE, 0*SHIP_SCALE  ; center 
                    fcb      +6*SHIP_SCALE, -20*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, +12*SHIP_SCALE 
                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, -17*SHIP_SCALE 
                    fcb      -17*SHIP_SCALE, +0*SHIP_SCALE 
ShipL_nomode:       fcb      9                          
                    fcb      +0*SHIP_SCALE, -17*SHIP_SCALE 
                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, +12*SHIP_SCALE 
                    fcb      +6*SHIP_SCALE, -20*SHIP_SCALE 
                    fcb      +1*SHIP_SCALE, 0*SHIP_SCALE  ; center 
                    fcb      +6*SHIP_SCALE, +20*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, -12*SHIP_SCALE 
                    fcb      +2*SHIP_SCALE, +0*SHIP_SCALE 
                    fcb      +0*SHIP_SCALE, +17*SHIP_SCALE 
                    fcb      -17*SHIP_SCALE, +0*SHIP_SCALE 
Shot:               fcb      2,0,10							; UNUSED 
                    fcb      2,1,0 
                    fcb      2,0,-10 
                    fcb      2,1,0 
                    fcb      2,0,10 
                    fcb      1 
; number of guys left 
Ship_Marker: 												; UNUSED
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
; NUMBERS all END at top right corner derive score from $c880 subtract $30 to get true value $20 == blank
zero:               fcb      5 
                    fcb      -5, +0 
                    fcb      +0, -4 
                    fcb      +5, +0 
                    fcb      +0, +4 
one:                fcb      3 
                    fcb      -5, +0 
                    fcb      +5, +0 
two:                fcb      3 
                    fcb      +0, -4 
                    fcb      +0, +4 
                    fcb      -5, -4 
three:              fcb      2, +0, +4 
                    fcb      2, -2, +0 
                    fcb      2, +0, -4 
                    fcb      0, +0, +4 
                    fcb      2, -3, +0 
                    fcb      2, +0, -4 
                    fcb      0, +5, +6 
                    fcb      1 
four:               fcb      0, -5, +4 
                    fcb      2, +5, 0 
                    fcb      2, -3, -4 
                    fcb      2, +0, +4 
                    fcb      0, +3, +2 
                    fcb      1 
five:               fcb      0, +0, +4 
                    fcb      2, +0, -4 
                    fcb      2, -3, +0 
                    fcb      2, +0, +4 
                    fcb      2, -2, +0 
                    fcb      2, +0, -4 
                    fcb      0, +5, +6 
                    fcb      1 
six:                fcb      2, -5, +0 
                    fcb      2, +0, +4 
                    fcb      2, +2, +0 
                    fcb      2, +0, -4 
                    fcb      0, +3, +6 
                    fcb      1 
seven:              fcb      0, -5, +4 
                    fcb      2, +5, +0 
                    fcb      2, +0, -4 
                    fcb      0, +0, +6 
                    fcb      1 
eight:              fcb      2, +0, +4 
                    fcb      2, -5, -4 
                    fcb      2, +0, +4 
                    fcb      2, +5, -4 
                    fcb      0, +0, +6 
                    fcb      1 
nine:               fcb      0, -5, +4 
                    fcb      2, +5, +0 
                    fcb      2, +0, -4 
                    fcb      2, -2, +0 
                    fcb      2, +0, +4 
                    fcb      0, +2, +2 
                    fcb      1 
;****************************************************************************************
; TABLES TABLES TABLES TABLES TABLES TABLES TABLES TABLES TABLES TABLES TABLES TABLES 
;****************************************************************************************
                                                          ; align $100 
;shippos_t          fcb      -3*ALLEYWIDTH,-2*ALLEYWIDTH,-1*ALLEYWIDTH,0,1*ALLEYWIDTH,2*ALLEYWIDTH,3*ALLEYWIDTH ; Y pos of ship 
BULLETYPOS          =        103                          ;; trail and error 
shippos_t 
bulletYpos_t        fcb      BULLETYPOS-(ALLEYHEIGHT*6*2), BULLETYPOS-(ALLEYHEIGHT*5*2), BULLETYPOS-(ALLEYHEIGHT*4*2), BULLETYPOS-(ALLEYHEIGHT*3*2), BULLETYPOS-(ALLEYHEIGHT*2*2),BULLETYPOS-(ALLEYHEIGHT*1*2), BULLETYPOS-(ALLEYHEIGHT*0*2) 
;bulletYpos_t        fcb      -90,-56,-22,12,46,80, BULLETPOS-(ALLEYHEIGHT*0)     ; Y pos of bullet/ship/enemy per alley || 0-7 index table
bullete_t           fdb      bullet0e,bullet1e,bullet2e,bullet3e,bullet4e,bullet5e,bullet6e ; exists 0=false, !0= true 
bulletd_t           fdb      bullet0d,bullet1d,bullet2d,bullet3d,bullet4d,bullet5d,bullet6d ; direction left/right 
bulletx_t           fdb      bullet0x,bullet1x,bullet2x,bullet3x,bullet4x,bullet5x,bullet6x ; X position 
alleye_t            fdb      alley0e,alley1e,alley2e,alley3e,alley4e,alley5e,alley6e ; exists + type code 
alleyd_t            fdb      alley0d,alley1d,alley2d,alley3d,alley4d,alley5d,alley6d ; direction 
alleyx_t            fdb      alley0x,alley1x,alley2x,alley3x,alley4x,alley5x,alley6x ; X pos 
alleys_t            fdb      alley0s,alley1s,alley2s,alley3s,alley4s,alley5s,alley6s ; speed 
alleyto_t           fdb      alley0to,alley1to,alley2to,alley3to,alley4to,alley5to,alley6to ; timeout before next spawn 
max_enemys_t        fcb      -1,3,4,5,5,6,6,7,7,7,7,7     ; maximum number of occupied alleys per level, repeat after 6 
;enemy_speed_t       fcb      -1,5,5,6,7,8,9,0,20          ; example TODO 
max_speed_mask_t    fcb      1,1,1,1,3,3,3,7,7,7,7,7,7    ; masking to lower speed range 7 == 100% 
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
;levelstr_t          fdb      $0000,level1str,level2str,level3str 
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
                    db       %11011110, %00000011, %01110111, %11100111, %11110011, %00011000, %01111000, %01100011, %11000000, %00000001, %11111110, %00000110, %01100101, %11100001, %11111000, %11111111, %10011100, %01101110, %00100011, %10001111, %10010001, %10000000, %11000111, %10000000, %00000000 ; forward 
                    db       %00000000, %00000001, %11110110, %00011111, %00001001, %11111111, %00001100, %01111110, %00111011, %00111111, %10011111, %10000011, %10111110, %01000000, %00111111, %10000000, %00000001, %11100110, %00011111, %11100000, %10000111, %11100111, %11111110, %11000000, %00111111 ; backward 
                    db       %11111100, %00000011, %11111111, %11100111, %11100000, %11111111, %11111000, %00101111, %10000000, %00000011, %11111000, %00000011, %11111111, %11000001, %11111011, %11111000, %11111110, %01111110, %00011111, %11111111, %10011111, %11111000, %01101111, %00000000, %00000000 ; forward 
                    db       %00000000, %00000000, %01111110, %00011111, %11110000, %11111111, %11110000, %00111110, %01111110, %00001111, %11001111, %10000011, %11101111, %11000000, %00011111, %10000000, %00000000, %11111110, %00001111, %11111110, %00000111, %11100011, %11111111, %10000000, %00011111 ; backward 
                    db       %11110000, %00000000, %11100001, %10000001, %10000000, %00011111, %11000000, %01111110, %00000000, %00000000, %11100000, %00000000, %11000011, %10000000, %01100000, %11000000, %00011100, %00111000, %00000001, %11111100, %00000011, %11100000, %11111110, %00000000, %00000000 ; forward 
                    db       %00000000, %00000000, %00111111, %10000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %01111111, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000 ; backward 
                    db       %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000001, %11111100, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000011, %11111000, %00000000, %00000000 ; forward 
                    db       %00000000, %00000000, %00011111, %11000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00011111, %10000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000 ; backward 
                    db       %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000001, %11111000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000011, %11110000, %00000000, %00000000 ; forward 
                    db       %00000000, %00000000, %00000111, %10000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000111, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000 ; backward 
;***********$$$$$$$$$$$$$$$**************$$$$$$$$$$$$$$$**************$$$$$$$$$
; TEXT STRINGS
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
deadstring          fcc      "SHIP HIT!",$80
gameoverstr         fcc      "GAME OVER",$80
highscorelabel      fcc      "HIGH SCORE",$80
meow                fcc      "SECRET GAME",$80
credits             fcc      "PROGRAMMED BY GAUZE 2016-2018",$80 
                    fcc      "KARRSOFT82LDMCBCJT82LDMCBCJ"
