;***************************************************************************
; DATA SECTION
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
ShipR_nomode:       fcb      8                            ; fcb 0, +8, -12 
                    fcb      -16, +0 
                    fcb      +0, +17 
                    fcb      +2, +0 
                    fcb      +0, -12 
                    fcb      +6, +20 
                    fcb      +6, -20 
                    fcb      +0, +12 
                    fcb      +2, +0 
                    fcb      +0, -17 
ShipL_nomode:       fcb      8                            ; fcb 0, +8, +12 
                    fcb      -16, +0 
                    fcb      +0, -17 
                    fcb      +2, +0 
                    fcb      +0, +12 
                    fcb      +6, -20 
                    fcb      +6, +20 
                    fcb      +0, -12 
                    fcb      +2, +0 
                    fcb      +0, +17 
Shot:               fcb      2,0,10 
                    fcb      2,1,0 
                    fcb      2,0,-10 
                    fcb      2,1,0 
                    fcb      2,0,10 
                    fcb      1 
Ship_Marker: 
                    fcb      3 
                    fcb      -7, +0 
                    fcb      +9, +3 
                    fcb      -9, +3 
                    fcb      +7, +0 
; Enemy list
Arrow_R: 
                    fcb      0, 3, 0 
                    fcb      2, -5, +5 
                    fcb      2, +0, -17 
                    fcb      2, +0, +17 
                    fcb      2, -5, -5 
                    fcb      1 
Arrow_L: 
                    fcb      0, 3, 0 
                    fcb      2, +5, -5 
                    fcb      2, +0, +17 
                    fcb      2, +0, -17 
                    fcb      2, +5, +5 
                    fcb      1 
Bow_1: 
                    fcb      0, +8, -10 
                    fcb      2, +0, +17 
                    fcb      2, -13, -17 
                    fcb      2, +0, +17 
                    fcb      2, +13, -17 
                    fcb      1 
Bow_2: 
                    fcb      0, -10, -8 
                    fcb      2, +17, +0 
                    fcb      2, -17, +13 
                    fcb      2, +17, +0 
                    fcb      2, -17, -13 
                    fcb      1 
Dash: 
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
Wedge_R: 
                    fcb      0, +5, -7 
                    fcb      2, -5, +17 
                    fcb      2, -5, -17 
                    fcb      2, +10, +0 
                    fcb      1 
Wedge_L: 
                    fcb      0, +5, -7 
                    fcb      2, -5, -17 
                    fcb      2, -5, +17 
                    fcb      2, +10, +0 
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
Tank_R:
Tank_L:
Tank_doh: 
                    fcb      0, +8, -10                   ; sync and move to y, x 
                    fcb      2, +0, +21                   ; draw, y, x 
                    fcb      2, -4, +0                    ; draw, y, x 
                    fcb      2, +0, -9                    ; draw, y, x 
                    fcb      2, -3, +0                    ; draw, y, x 
                    fcb      2, +0, +12                   ; draw, y, x 
                    fcb      2, -3, +0                    ; draw, y, x 
                    fcb      2, +0, -12                   ; draw, y, x 
                    fcb      2, -3, +0                    ; draw, y, x 
                    fcb      2, +0, +9                    ; draw, y, x 
                    fcb      2, -4, +0                    ; draw, y, x 
; fcb 0, -8, +11 ; sync and move to y, x
                    fcb      2, +0, -21                   ; draw, y, x 
                    fcb      2, +4, +0                    ; draw, y, x 
                    fcb      2, +0, +2                    ; draw, y, x 
                    fcb      2, +2, +0                    ; draw, y, x 
                    fcb      2, +0, -2                    ; draw, y, x 
                    fcb      2, +5, +0                    ; draw, y, x 
                    fcb      2, +0, +2                    ; draw, y, x 
                    fcb      2, +2, +0                    ; draw, y, x 
                    fcb      2, +0, -2                    ; draw, y, x 
                    fcb      2, +4, +0                    ; draw, y, x 
                    fcb      1                            ; endmarker 
; TABLES
;shippos_t:          fcb      -3*ALLEYWIDTH,-2*ALLEYWIDTH,-1*ALLEYWIDTH,0,1*ALLEYWIDTH,2*ALLEYWIDTH,3*ALLEYWIDTH ; Y pos of ship 
bulletYpos_t:       fcb      -98,-64,-31,3,37,70, 104     ; Y pos of bullet/ship/enemy per alley 
bullete_t:          fdb      bullet0e,bullet1e,bullet2e,bullet3e,bullet4e,bullet5e,bullet6e ; exists TRUE/FALSE 
bulletd_t:          fdb      bullet0d,bullet1d,bullet2d,bullet3d,bullet4d,bullet5d,bullet6d ; direction left/right 
bulletx_t:          fdb      bullet0x,bullet1x,bullet2x,bullet3x,bullet4x,bullet5x,bullet6x ; X position 
alleye_t:           fdb      alley0e,alley1e,alley2e,alley3e,alley4e,alley5e,alley6e 
alleyd_t:           fdb      alley0d,alley1d,alley2d,alley3d,alley4d,alley5d,alley6d 
alleyx_t:           fdb      alley0x,alley1x,alley2x,alley3x,alley4x,alley5x,alley6x 
enemy_t:            fdb      Arrow_t, Bow_t, Dash, Wedge_t, Ghost ;, Prize, CannonBall, Tank 
enemy_speed_t       fdb      5,5,6,7,8,9,0,20             ; example 
enemy_stuff_t       fdb      0 
Bow_t               fdb      Bow_1, Bow_2                 ; same, flippy 90 degree animation 
Arrow_t             fdb      Arrow_R, Arrow_L             ; Right, Left 
Wedge_t             fdb      Wedge_R, Wedge_L             ; Right, Left 
Ghost_t             fdb      Ghost                        ; same 
Dash_t              fdb      Dash                         ; same 
Tank_t              fdb      Tank_R, Tank_L               ; Right/left 
credits             fcc      "PROGRAMMED BY GAUZE 2016-2017, ",$80 
