pro DoY

COMPILE_OPT IDL2, HIDDEN

;;;;;;;;;;;;;;;;;;;;;;;
;
; This code is for finding the day of the year 
;
; Written by: Brian Barker
; Last Update: 03-22-2021
;
;;;;;;;;;;;;;;;;;;;;;;;

repeat begin

	; Input Date

		repeat begin
			read,Mon,prompt="Enter Month in MM Format: "
			print,""
		endrep until (Mon gt 0) && (Mon le 12)

		repeat begin
			read,Date,prompt="Enter Date in DD Format: "
			print,""
		endrep until (Date gt 0) && (Date le 31)

	; Determine Day

		; Months Array
			rmonths=['January','February','March','April','May','June','July','August','September','October','November','December']
			x = Mon-1
			
		; Days Array
			days=[1:31]

	; Determine the day of the year from the date

			DoY=0
			DoMon=[0,31,59,90,120,151,181,212,243,273,304,334]

			DoY=DoMon[Mon-1] + Date

			print,"The Day Of The Year is: ",DoY
			print,""

			print,"Would You Like To Calculate Again?"
			read,end_DOY,prompt="|1 = Yes| |0 = No| "
			print,""

	endrep until end_DOY eq 0		
end