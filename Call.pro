pro Call

close, /all

;;;;;;;;;;;;;;;;;;;;;;;
;
; This is the starting file that the user will use to pick which action to take
; based on their needs.
;
; Written By: Brian Barker
; Last Update: 3-22-2021
;
;
;;;;;;;;;;;;;;;;;;;;;;;

; This begins the procedure. It repeats until the users wants to stop
repeat begin

    ; Give the user options for what they want to do
    print,""
    print,"Home Menu:"
    read,choice,prompt="|1 - Source Reference|  |2 - Timekeeping Calculations| "

    ; If option 1 is picked do this
    if choice eq 1 then begin
        print,"...Accessing Source Reference Procedure..."
        call_procedure,"Ref4"
        print,"Would You Like To Return To The Home Menu?"
        read,over,prompt="|1 - Yes| |0 - No| "
    endif

    ; If option 2 is picked do this
    if choice eq 2 then begin
        print,""
        print,"...Accessing Timekeeping Calculation Procedure..."                  ; User experience
        print,""

        ; Show options for what the user can calculate
        print,"What Would You Like To Calculate?"
        read,mode,prompt="|1 - Day of Year Calc.|  |2 - Declination of the Mean Sun|  |3 - Right Ascension of the Mean Sun| "
        print,""

        ; If mode 1 is picked do this
        if mode eq 1 then begin
            call_procedure,"DoY"
        endif
        
        ; If mode 2 is picked do this
        if mode eq 2 then begin
            call_procedure,"DecSun"
        endif

        ; If mode 3 is picked do this
        if mode eq 3 then begin
            call_procedure,"RASun"
        endif


        ; Ask the user is they want to start over
        print,"Would You Like To Return To The Home Menu?"
        read,over,prompt="|1 - Yes| |0 - No| "
    endif
endrep until over eq 0

; Confirming end
print,"End Call.pro"
print,""
end