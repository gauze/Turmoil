; vim: ts=4 syntax=asm6809 foldmethod=marker fdo-=search
;***************************************************************************
; Variable / RAM SECTION
;***************************************************************************
; key to variables/symbols (WIP)
; constants = ALL_UPPERCASE
; variables = all_lower_case
; flags = Camel_Case (delimited by underscore)
; insert your variables (RAM usage) in the BSS section
; user RAM starts at $c880 
                    bss      
                    org      $C880                        ; start of our ram space 
; game basics
score               ds       7                            ; 7 bytes 
running_score       ds       7                            ; 7 bytes used for animation of score. 
;highscore           ds       7                            ; 7 bytes ;use built in instead.
level               ds       1                            ; only does levels 1-99 then shows Infinity sign after that 
shipcnt             ds       1                            ; ships in reserve before GameOver 
smartbombcnt        ds       1                            ; only in Super_Game 
; game option selector vars
conf_box_index      ds       1                            ; configuration selector 
hs_box_Yindex       ds       1                            ; highscore input character selector, grid 
hs_box_Xindex       ds       1 
ls_tens_tmp         ds       1 
ls_ones_tmp         ds       1
ls_level_term       ds       1 
select_level_flag   ds       1
;
; your ship related variables, X,Y position and direction facing L/R, and number left
shipspeed           ds       1                            ; vertical speed, selected by user 
; 
shipdir             ds       1                            ; left or right 
shipYpos            ds       2 
shipXpos            ds       2 
shipYdir            ds       1                            ; up or down for Demo_Mode only 
; limits 
enemycnt            ds       1 
bulletcnt           ds       1                            ; is this used? 
; counters for events
stallcnt            ds       1                            ; generic slow down 
prizecnt            ds       2                            ; 16 bit counter 
prizecntdown        ds       1                            ; before prize turns to cannonball 
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
alley0d             ds       1                            ; which way is the monster moving? (Direction) 
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
warpdelay           ds       1 
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
temp                ds       2                            ; generic 2 byte temps 
temp1               ds       2 
temp2               ds       2 
temp3               ds       2 
temp4               ds       2 
speedtemp           ds       1 
speeddtemp          ds       1 
speeditemp          ds       1 
spawntemp           ds       1 
;masktemp            ds       1 
bulletYtemp         ds       1 
enemytemp           ds       1 
; high score entry screen stuff see also top of list for a couple more
hsentry_index       ds       1 
hsentry1n           ds       4                            ; name and score n/s 
hsentry1s           ds       7 
hsentry2n           ds       4 
hsentry2s           ds       7 
hsentry3n           ds       4 
hsentry3s           ds       7 
hsentry4n           ds       4 
hsentry4s           ds       7 
hsentry5n           ds       4 
hsentry5s           ds       7 
;hstempstr           ds       4                            ; hold temp name while sorting 
;
enemylvlcnt         ds       1                            ; how many enemies left in this level? 
; STATE FLAGS
Super_Game          ds       1 
Ship_Dead           ds       1 
Ship_Dead_Anim      ds       1 
Ship_Dead_Cnt       ds       1                            ; used for scale control 
In_Alley            ds       1                            ; ship is in 
Is_Prize            ds       1                            ; alley contains "prize" 
Level_Done          ds       1 
Demo_Mode           ds       1                            ; arcade selfplay mode. 
; used during jsr levelsplash
lvllabelstr         ds       6                            ; "LEVEL " 
levelstr            ds       2                            ; 1-2 digits (1-99) or infinity sign ∞ 
;lvlstrterm          ds       1 
Line_Pat            ds       1                            ; this is for LINE_DRAW_D stuff , 00000000 is nothing 11111111 is line 10101010 is dotted line 
ustacktempptr       ds       2                            ; for saving location of ustacktemp 
;calibrationValue    ds       1 
demo_label_cnt      ds       1                            ; for rotating list of info during Demo_Mode 
bigger              ds       1                            ; used in X collision math 
smaller             ds       1                            ; used in X collision math 
; SFX variables
tempW1              ds       2                            ; W? some kind of "pitch" related values 
tempW2              ds       2 
tempB3              ds       1 
sfxC1ID             ds       1                            ; ID is effects ID 
sfxC2ID             ds       1 
sfxC3ID             ds       1 
sfxC1W1             ds       2                            ; W length of time effect lasts. 
sfxC2W1             ds       2                            ; C = channel? 
sfxC3W1             ds       2 
;sfx_FC              ds       2                            ; "LFO" table it's cycled
; Stuff for zooming hallway thing between levels
top0                ds       1 
top1                ds       1 
top2                ds       1 
; DS2431+ EEPROM stuff
; constants
EEPROM_STORESIZE    equ      64                           ; only using 2 banks 
EEPROM_CHECKSUM     equ      69                           ; see eprom.i for valid values 
; Variables 
eeprom_buffer                                             ;        everything 
;eeprom_buffer0      ds       32 
;eeprom_buffer1      ds       32            
; scores
ee_hs1              ds       7 
ee_hs2              ds       7 
ee_hs3              ds       7 
ee_hs4              ds       7 
ee_hs5              ds       7 
; initials
ee_hsn1             ds       4 
ee_hsn2             ds       4 
ee_hsn3             ds       4 
ee_hsn4             ds       4 
ee_hsn5             ds       4 
; use this for OPTIONS  7 bytes total
ee_shipspeed        ds       1                            ; 1-4 faster to slower 
ee_game_mode        ds       1                            ; bool 1=Super game | 0=classic 
ee_filler           ds       5                            ; filler so it's exactly 63 bytes long, plus checksum digit 
;          
; ymplayer ram and USE_ENVELOPES flag, * ok for top of RAM
ym_ram              equ      * 
USE_ENVELOPES=1 
;
; CONSTANTS
;   ____ ___  _   _ ____ _____  _    _   _ _____ ____  
;  / ___/ _ \| \ | / ___|_   _|/ \  | \ | |_   _/ ___| 
; | |  | | | |  \| \___ \ | | / _ \ |  \| | | | \___ \ 
; | |__| |_| | |\  |___) || |/ ___ \| |\  | | |  ___) |
;  \____\___/|_| \_|____/ |_/_/   \_\_| \_| |_| |____/ 
;                                                      
;ALLEYWIDTH          =        17                           ; moved to macros.i near where it's used for quick access
LEFT                =        0 
RIGHT               =        1 
SCORE               =        10                           ; score 10 times speed/level something 
MOVEAMOUNT          =        8                            ; how many 'pixels per frame' 
; ENEMY TABLE 
GHOST               =        8                            ; various values for quick testing. positions are 
TANK                =        6                            ; from Enemy_t table 
EXPLOSION           =        9 
ARROW               =        1 
PRIZE               =        5 
CANNONBALL          =        7 
; U STACK for saving registers.
ustacktemp          equ      $CBD0                        ; few down from default S stack so it doesn't get overwritten 
