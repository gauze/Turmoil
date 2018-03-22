; vim: ts=4
; vim: syntax=asm6809
;***************************************************************************
; Variable / RAM SECTION
;***************************************************************************
; insert your variables (RAM usage) in the BSS section
; user RAM starts at $c880 
                    bss      
                    org      $C880                        ; start of our ram space 
; 
score               ds       7                            ; 7 bytes 
;highscore           ds       7                            ; 7 bytes ;use built in instead.
level               ds       1 
shipspeed           ds       1 
conf_box_index      ds       1 
hs_box_Yindex       ds       1 
hs_box_Xindex       ds       1 
;
; your ship related variables, X,Y position and direction facing L/R, and number left
shipdir             ds       1                            ; left or right 
shipYpos            ds       1 
shipXpos            ds       1 
shipcnt             ds       1                            ; 
; limits 
enemycnt            ds       1 
bulletcnt           ds       1                            ; 
; counters for events
stallcnt            ds       1 
prizecnt            ds       2                            ; 16 bit counter 
prizecntdown        ds       1 
; states and positions of all bullets and enemies
bullet0e            ds       1 
bullet1e            ds       1                            ; shit Exists in alley 
bullet2e            ds       1 
bullet3e            ds       1 
bullet4e            ds       1 
bullet5e            ds       1 
bullet6e            ds       1 
bullet0d            ds       1 
bullet1d            ds       1                            ; travel direction 
bullet2d            ds       1 
bullet3d            ds       1 
bullet4d            ds       1 
bullet5d            ds       1 
bullet6d            ds       1 
bullet0x            ds       1 
bullet1x            ds       1                            ; location on X axis 
bullet2x            ds       1 
bullet3x            ds       1 
bullet4x            ds       1 
bullet5x            ds       1 
bullet6x            ds       1 
alley0e             ds       1                            ; is there a monster in the alley? (Exists?) 
alley1e             ds       1 
alley2e             ds       1 
alley3e             ds       1 
alley4e             ds       1 
alley5e             ds       1 
alley6e             ds       1 
alley0d             ds       1                            ; which way is the monster moving? 
alley1d             ds       1 
alley2d             ds       1 
alley3d             ds       1 
alley4d             ds       1 
alley5d             ds       1 
alley6d             ds       1 
alley0x             ds       1                            ; where monster is on x axis 
alley1x             ds       1 
alley2x             ds       1 
alley3x             ds       1 
alley4x             ds       1 
alley5x             ds       1 
alley6x             ds       1 
alley0s             ds       1                            ; speed==X/Y, X speed of monster 1-9 
alley1s             ds       1 
alley2s             ds       1 
alley3s             ds       1 
alley4s             ds       1 
alley5s             ds       1 
alley6s             ds       1 
alley0sd            ds       1                            ; speed==X/Y, Y speed of monster 1-9 
alley1sd            ds       1                            ; d = denominator 
alley2sd            ds       1 
alley3sd            ds       1 
alley4sd            ds       1 
alley5sd            ds       1 
alley6sd            ds       1 
; timeout before respawn per alley
alley0to            ds       1 
alley1to            ds       1 
alley2to            ds       1 
alley3to            ds       1 
alley4to            ds       1 
alley5to            ds       1 
alley6to            ds       1 
; variables to hold which frame for each shape enemy some might not have an animation...
Arrow_f             ds       1 
Bow_f               ds       1 
Dash_f              ds       1 
Wedge_f             ds       1 
Ghost_f             ds       1 
Prize_f             ds       1 
Cannonball_f        ds       1 
Tank_f              ds       1 
None_f              ds       1 
Explode_f           ds       1                            ; generic shape used when something is destroyed 
; frame counts for animations/speed
frm100cnt           ds       1 
frm50cnt            ds       1 
frm25cnt            ds       1 
frm20cnt            ds       1 
frm10cnt            ds       1 
frm5cnt             ds       1 
frm4cnt             ds       1 
frm3cnt             ds       1 
frm2cnt             ds       1 
fmt1cnt             ds       1 
fmt0cnt             ds       1 
; temporary storage
temp                ds       1                            ; generic 1 byte temp 
temp1               ds       1 
speedtemp           ds       1 
speeddtemp          ds       1 
speeditemp          ds       1 
spawntemp           ds       1 
;masktemp            ds       1 
bulletYtemp         ds       1 
enemytemp           ds       1 
hsentry_index       ds       1
hsentry1n           ds       4
hsentry1s           ds       7
hsentry2n           ds       4
hsentry2s           ds       7
hsentry3n           ds       4
hsentry3s           ds       7
hsentry4n           ds       4
hsentry4s           ds       7
hsentry5n           ds       4
hsentry5s           ds       7
hstempstr		  ds       4
;
enemylvlcnt         ds       1                            ; how many enemies left in this level? 
; STATE FLAGS
Ship_Dead           ds       1 
Ship_Dead_Anim      ds       1 
Ship_Dead_Cnt       ds       1 
In_Alley            ds       1                            ; ship is in 
Is_Prize            ds       1                            ; alley contains "prize" 
;
lvllabelstr         ds       6 
levelstr            ds       2 
;lvlstrterm          ds       1 
Level_Done          ds       1 
Demo_Mode           ds       1                            ; arcade selfplay mode. 
Line_Pat            ds       1                            ; this is for LINE_DRAW_D stuff , 00000000 is nothing 11111111 is line 10101010 is dotted line 
ustacktempptr       ds       2                            ; for saving location of ustacktemp 
calibrationValue    ds       1 
;
; CONSTANTS place after VARIABLES
;ALLEYWIDTH          =        17 
LEFT                =        0 
RIGHT               =        1 
SCORE               =        10                           ; score 10 times sped/level something 
MOVEAMOUNT          =        8                            ; how many 'pixels per frame' TODO/FIX/something 
;
GHOST               =        8                            ; various values for quick testing. positions are 
TANK                =        6                            ; from Enemy_t table 
EXPLOSION           =        9 
ARROW               =        1 
PRIZE               =        5 
CANNONBALL          =        7 
; U STACK for saving registers.
ustacktemp          equ      $CBD0                        ; few down from default S stack so it doesn't get overwritten 
