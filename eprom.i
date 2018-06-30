; example code
;                    JSR      eeprom_load                   ; read if it can't it formats/load defaults
;                    inc      eeprom_buffer                 ; increment what was read
;                    JSR      eeprom_save                   ; save back to EEPROM
; Data
eeprom_defaults 
; Put 31 bytes of default data here! 
    db  "DOUCH", $80 ; Strings must be AT LEAST 3 signs, otherwise Print_Str is bugged!
    ds  29

;                    db       "SLAYER", $80                ; Strings must be AT LEAST 3 signs, otherwise Print_Str is bugged!
;                    ds       24 
; defined in data.i
; accessed with default_name_t and default_high_t tables
;default_high0       fcc      "  5000",$80
;default_high1       fcc      "  4000",$80
;default_high2       fcc      "  3000",$80
;default_high3       fcc      "  2000",$80
;default_high4       fcc      "  1000",$80
;test_score          fcc      " 50000",$80
;default_name0       fcc      "GOZ",$80
;default_name1       fcc      "JAW",$80
;default_name2       fcc      "GGG",$80
;default_name3       fcc      "GCE",$80
;default_name4       fcc      "GZE",$80
eeprom_load 
                    ldx      #eeprom_buffer1              ; 
                    jsr      ds2431_load                  ; load 32 byte eeprom to ram 
                    ldd      #$0020                       ; $20 = 32 dec should change. 
;                    ldd      #$0008 
eeload_loop                                               ;        
                    adda     ,x+                          ; sum the bytes 
                    decb                                  ; 
                    bne      eeload_loop                  ; 
                    cmpa     #EEPROM_CHECKSUM             ; equal to checksum? 
                    bne      eeprom_format                ; if not, then format the eeprom 
                    rts                                   ; otherwise, return 

eeprom_format 
                    ldu      #eeprom_defaults             ; 
                    ldx      #eeprom_buffer1              ; 
                    ldb      #$1f                         ; 31 amount of data in each 
                  ;  ldb      #7 
eeformat_loop                                             ;        copy default data (rom) to ram 
                    pulu     a                            ; 
                    sta      ,x+                          ; 
                    decb                                  ; 
                    bne      eeformat_loop                ; 
eeprom_save 
                    ldx      #eeprom_buffer1 
                    ;ldx      #default_name0               ; 
                    ldd      #(EEPROM_CHECKSUM<<8)+$1f    ; 
                   ; ldd      #(EEPROM_CHECKSUM<<8)+7      ; 
eesave_loop                                               ;        
                    suba     ,x+                          ; create checksum byte 
                    decb                                  ; 
                    bne      eesave_loop                  ; 
                    sta      ,x                           ; 
                    ldx      #eeprom_buffer1              ; 
                   ; ldx      #default_name0 
                    jsr      ds2431_verify                ; compare ram to eeprom 
                    tsta                                  ; 
                    lbne     ds2431_save                  ; if different, then update eeprom 
                    rts      
