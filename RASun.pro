pro RASun

COMPILE_OPT IDL2, HIDDEN

;;;;;;;;;;;;;;;;;;;;;;;
;
; This code is for finding the right ascension of the mean sun
;
; Written by: Brian Barker
; Last Update: 03-22-2021
;
;;;;;;;;;;;;;;;;;;;;;;;

    ; This begins the procedure
    repeat begin
        repeat begin
            print,"How Would You Like To Calculate Right Ascension Of The Mean Sun?"
            read,mode,prompt="|1 = Using Day Of The Julian Calendar| |2 = Using Days Since Vernal Equinox| "
            print,""

                            ; If mode 1 is picked do this
                if mode eq 1 then begin 
                    ;t = 0.0
                    read,t,prompt="What Day Of The Julian Calendar Would You Like To Use? "
                    print,""
                    RA = 18.62 + (.0657 * t)

                    if RA gt 24 then begin
                        new_RA = RA - 24
                        print,"Right Ascension Of The Mean Sun On This Day Is: ", (new_RA)
                        print,""
                        RAms = new_RA
                    endif

                    if RA le 24 then begin
                       print,"Right Ascension Of The Mean Sun On This Day Is: ", RA
                        print,""
                        RAms = RA
                    endif
                endif
                

                ; If mode 2 is picked, do this
                if mode eq 2 then begin
                    ;tv = 0.0
                    read,tv,prompt="How Many Days Since The Vernal Equinox? "
                    print,""
                    RA = 0.0 + (24.0/365.0) * tv

                    if RA gt 24 then begin
                        new_RA = RA - 24
                        print,"Right Ascension Of The Mean Sun On This Day Is: ", (new_RA)
                        print,""
                        RAms = new_RA
                    endif

                    if RA le 24 then begin
                       print,"Right Ascension Of The Mean Sun On This Day Is: ", RA
                        print,""
                        RAms = RA
                    endif
                endif

            print,"Would You Like To Calculate Again?"
            read,end_RASun,prompt="|1 = Yes| |0 = No| "
            print,""

        endrep until end_RASun eq 0


        ; The beginning question repeats until one of the available choices is picked
    endrep until mode le 2 && mode ge 1
end