turmoil_start: 
 DW 96 ; vbl_len 
; translation data 
; DB $08; bytes follow 
; bits used, code, real 'byte' 
turmoil_reg_0: 
 DB $01, $01, $06 ;48 
 DB $03, $03, $06 ;24 
; phrases follow 
turmoil_pd_0: 
 DB $B2, $B2, $B3, $B3, $B4, $B4; 48 
 DB $A8, $A8, $A9, $A9, $AA, $AA; 24 
; data follows 
turmoil_reg_0_data: 
 DB $D0, $B3, $D1, $C9, $65, $25, $9E, $85, $4D, $2E
 DB $4A, $89, $2A, $40 ; flushed
; translation data 
; DB $01; bytes follow 
; bits used, code, real 'byte' 
turmoil_reg_1: 
; phrases follow 
turmoil_pd_1: 
; data follows 
turmoil_reg_1_data: 
 DB $FB, $00, $00 ; flushed
; translation data 
; DB $01; bytes follow 
; bits used, code, real 'byte' 
turmoil_reg_2: 
; phrases follow 
turmoil_pd_2: 
; data follows 
turmoil_reg_2_data: 
 DB $FB, $02, $C8 ; flushed
; translation data 
; DB $01; bytes follow 
; bits used, code, real 'byte' 
turmoil_reg_3: 
; phrases follow 
turmoil_pd_3: 
; data follows 
turmoil_reg_3_data: 
 DB $FB, $00, $00 ; flushed
; translation data 
; DB $0B; bytes follow 
; bits used, code, real 'byte' 
turmoil_reg_4: 
; phrases follow 
turmoil_pd_4: 
; data follows 
turmoil_reg_4_data: 
 DB $3E, $83, $83, $DB, $D0, $9D, $F6, $2F, $8F, $60
 DB $C0, $EA, $19, $F4, $18, $C3, $20, $E0, $4B, $F4
 DB $2B, $E0 ; flushed
; translation data 
; DB $04; bytes follow 
; bits used, code, real 'byte' 
turmoil_reg_5: 
; phrases follow 
turmoil_pd_5: 
; data follows 
turmoil_reg_5_data: 
 DB $06, $42, $F4, $27, $D8, $00, $64, $2D, $27, $F4
 DB $80 ; flushed
; translation data 
; DB $02; bytes follow 
; bits used, code, real 'byte' 
turmoil_reg_6: 
; phrases follow 
turmoil_pd_6: 
; data follows 
turmoil_reg_6_data: 
 DB $B1, $9E, $A8, $1E, $C1, $9D, $80, $40 ; flushed
; translation data 
; DB $04; bytes follow 
; bits used, code, real 'byte' 
turmoil_reg_7: 
; phrases follow 
turmoil_pd_7: 
; data follows 
turmoil_reg_7_data: 
 DB $1A, $A3, $A3, $EE, $F1, $ED, $8E, $86, $A8, $EA
 DB $EF, $86, $A8, $EA, $EF, $B7, $9E, $D2, $F8 ; flushed
; translation data 
; DB $01; bytes follow 
; bits used, code, real 'byte' 
turmoil_reg_8: 
; phrases follow 
turmoil_pd_8: 
; data follows 
turmoil_reg_8_data: 
 DB $FB, $02, $00 ; flushed
; translation data 
; DB $01; bytes follow 
; bits used, code, real 'byte' 
turmoil_reg_9: 
; phrases follow 
turmoil_pd_9: 
; data follows 
turmoil_reg_9_data: 
 DB $FB, $00, $00 ; flushed
; translation data 
; DB $11; bytes follow 
; bits used, code, real 'byte' 
turmoil_reg_10: 
 DB $02, $03, $0C ;36 
; phrases follow 
turmoil_pd_10: 
 DB $0F, $0E, $0D, $0C, $0B, $0A, $09, $08, $07, $06, $05, $04; 36 
; data follows 
turmoil_reg_10_data: 
 DB $A9, $E0, $07, $8D, $16, $24, $38, $51, $E3, $45
 DB $89, $0E, $14, $78, $D1, $62, $43, $85, $97, $A9
 DB $F7, $02, $A7, $DC, $07, $06, $08, $0E, $90, $00
 ; flushed
; translation data 
; DB $03; bytes follow 
; bits used, code, real 'byte' 
turmoil_reg_11: 
; phrases follow 
turmoil_pd_11: 
; data follows 
turmoil_reg_11_data: 
 DB $F7, $82, $DD, $82, $A9, $0A, $E8, $2A, $90, $AE
 DB $82, $A9, $0A, $E8, $2A, $90, $AE, $82, $A0 ; flushed
; translation data 
; DB $01; bytes follow 
; bits used, code, real 'byte' 
turmoil_reg_12: 
; phrases follow 
turmoil_pd_12: 
; data follows 
turmoil_reg_12_data: 
 DB $FB, $00, $00 ; flushed
; translation data 
; DB $02; bytes follow 
; bits used, code, real 'byte' 
turmoil_reg_13: 
; phrases follow 
turmoil_pd_13: 
; data follows 
turmoil_reg_13_data: 
 DB $11, $F5, $F7, $C0 ; flushed
turmoil_data: 
 DW turmoil_start 
 DB $00
 DW turmoil_reg_0, turmoil_pd_0, turmoil_reg_0_data
 DB $01
 DW turmoil_reg_1, turmoil_pd_1, turmoil_reg_1_data
 DB $02
 DW turmoil_reg_2, turmoil_pd_2, turmoil_reg_2_data
 DB $03
 DW turmoil_reg_3, turmoil_pd_3, turmoil_reg_3_data
 DB $04
 DW turmoil_reg_4, turmoil_pd_4, turmoil_reg_4_data
 DB $05
 DW turmoil_reg_5, turmoil_pd_5, turmoil_reg_5_data
 DB $06
 DW turmoil_reg_6, turmoil_pd_6, turmoil_reg_6_data
 DB $07
 DW turmoil_reg_7, turmoil_pd_7, turmoil_reg_7_data
 DB $08
 DW turmoil_reg_8, turmoil_pd_8, turmoil_reg_8_data
 DB $09
 DW turmoil_reg_9, turmoil_pd_9, turmoil_reg_9_data
 DB $0A
 DW turmoil_reg_10, turmoil_pd_10, turmoil_reg_10_data
 DB $0B
 DW turmoil_reg_11, turmoil_pd_11, turmoil_reg_11_data
 DB $0C
 DW turmoil_reg_12, turmoil_pd_12, turmoil_reg_12_data
 DB $0D
 DW turmoil_reg_13, turmoil_pd_13, turmoil_reg_13_data
 DB $FF
SONG_DATA EQU turmoil_data 
turmoil_name: 
 DB $55, $4E, $54, $49, $54, $4C, $45, $44, $80 
