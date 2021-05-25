pro TimeSearch

;;;;;;;;;;;;;;;;;;;;;;;
;
; This code is intended to provide a user with a list of objects in the sky above
; when a given date and time are supplied.
;
; 
; Uses some example code from Harris Geospatial IDL Documentation
;
; Written By: Brian Barker
; Last Update: 3-17-2021
;
;
;;;;;;;;;;;;;;;;;;;;;;;

; User Inputs

repeat begin
    print,""
	print,"Is The Observation Date During Daylight Savings Time? "
	read,time_mode,prompt="|1 = Yes| |0 = No| "
    print,""
endrep until (time_mode le 1) && (time_mode ge 0)

    if time_mode eq 0 then begin

        read,MST,prompt="What Is The Hour Of Observation In 24-hr Format? "
        print,""

        HAms = MST - 12
        

        ; Find RAms
        repeat begin
            repeat begin
                print,"How Would You Like To Calculate Right Ascension Of The Mean Sun?"
                read,search_mode,prompt="|1 = Using Day Of The Julian Calendar| |2 = Using Days Since Vernal Equinox| "
                print,""
            endrep until search_mode le 2 && search_mode ge 1                                 ; The beginning question repeats until one of the available choices is picked


                ; If search_mode 1 is picked do this
                if search_mode eq 1 then begin 

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
                

                ; If search_mode 2 is picked, do this
                if search_mode eq 2 then begin

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

                print,"Would You Like To Calculate A New RA?"
                read,end_RASun,prompt="|1 = Yes| |0 = No| "
                print,""

        endrep until end_RASun eq 0


            LST = RAms + HAms

            print,"The Local Sidereal Time Is: ",LST
            print,""

            RA_w = LST - 6


            RA_e = LST + 6

            print,"Looking South At This Time, Sources With An RA Hour Between The Following Two Values Will Be Visible. "
            print,"RA To The East ",floor(RA_e)
            print,"RA To The West ",floor(RA_w)
    endif

    if time_mode eq 1 then begin

        read,MST,prompt="What Is The Hour Of Observation In 24-hr Format? "
        print,""

        DST = MST + 1

        HAms = DST - 13
        

        ; Find RAms
        repeat begin
            repeat begin
                print,"How Would You Like To Calculate Right Ascension Of The Mean Sun?"
                read,search_mode,prompt="|1 = Using Day Of The Julian Calendar| |2 = Using Days Since Vernal Equinox| "
                print,""
            endrep until search_mode le 2 && search_mode ge 1                                 ; The beginning question repeats until one of the available choices is picked


                ; If search_mode 1 is picked do this
                if search_mode eq 1 then begin 

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
                

                ; If search_mode 2 is picked, do this
                if search_mode eq 2 then begin

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

                print,"Would You Like To Calculate A New RA?"
                read,end_RASun,prompt="|1 = Yes| |0 = No| "
                print,""

        endrep until end_RASun eq 0

            print,HAms

            LST = RAms + HAms

            print,"The Local Sidereal Time Is: ",LST
            print,""

            RA_w = LST - 6


            RA_e = LST + 6

            print,"Looking South At This Time, Sources With An RA Hour Between The Following Two Values Will Be Visible. "
            print,""
            print,"RA To The East ",RA_e
            print,"RA To The West ",RA_w
            print,""
    endif



end