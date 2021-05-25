pro DecSun

COMPILE_OPT IDL2, HIDDEN

;;;;;;;;;;;;;;;;;;;;;;;
;
; This code is for finding the declination of the mean sun
;
; Written by: Brian Barker
; Last Update: 03-22-2021
;
;;;;;;;;;;;;;;;;;;;;;;;

    ; This begins the procedure
    repeat begin

        repeat begin

            print,"How Would You Like To Calculate Declination Of The Mean Sun?"
            read,mode,prompt="|1 = Using Day Of The Julian Calendar| |2 = Using Days Since Vernal Equinox| "
            print,""

            ; If mode 1 is picked then do this
            if mode eq 1 then begin 
                read,t,prompt="What Day Of The Julian Calendar Would You Like To Use? "
                print,""
                Dec = 23.5*sin((2*!pi/365)*(t-79))
                print,"Declination Of The Mean Sun On This Day Is: ", Dec
                print,""
            endif

            ; If mode 2 is picked then do this
            if mode eq 2 then begin
                read,tv,prompt="How Many Days Since The Vernal Equinox? "
                print,""
                Dec = 23.5*sin((2*!pi/365)*tv)
                print,"Declination Of The Mean Sun On This Day Is: ", Dec
                print,""
            endif

            print,"Would You Like To Calculate Again?"
            read,end_DecSun,prompt="|1 = Yes| |0 = No| "
            print,""

        endrep until end_DecSun eq 0
    
    ; Repeats the mode selection until the user picks an available mode
    endrep until mode le 2 && mode ge 1


end