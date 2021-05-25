pro Ref4, SourceInfo_file, RAh, RAm, RAs, DecD, DecM, DecS

COMPILE_OPT IDL2, HIDDEN

;;;;;;;;;;;;;;;;;;;;;;;
;
; This code is intended to pull data from a .csv file and match it with a list of source names.
; The program will provide the Right Ascension hours, minutes, and seconds as well as the Declination
; degrees, minutes, and seconds for each of the sources that match the users searches.
; 
; Uses some example code from Harris Geospatial IDL Documentation
;
; Written By: Brian Barker
; Last Update: 5-18-2021
;
;
;;;;;;;;;;;;;;;;;;;;;;;

print,""
print,"Please Pick The .CSV File That You Would Like To Search"

; Declarations

	RAh = 0.0
	RAm = 0.0
	RAs = 0.0
	DecD = 0.0
	DecM = 0.0
	DecS = 0.0

; Close any previously opened file and open a file for the search history

	close, /all
	openw,2,'GDLSearch.txt'

; Use DIALOG_PICKFILE to locate the file to be used and assign it a name

	file = dialog_pickfile(FILTER='*.csv',/read)      ; The name is "file" and the filter can be changed to any file type or taken out. /read changes the title of the dialog box

; Read the file in and assign it to the Source_Data variable, assign the header information to variables

	Source_Data = read_csv(file, COUNT=count, HEADER=SourceHead, N_TABLE_HEADER=0)   

; Take the columns (FIELDS) of the csv and assign them variables for later use
	
	Names = Source_Data.FIELD1
	RAHs = Source_Data.FIELD2
	RAMs = Source_Data.FIELD3
	RASs = Source_Data.FIELD4
	DECDs = Source_Data.FIELD5
	DECMs = Source_Data.FIELD6
	DECSs = Source_Data.FIELD7


; Put all the columns from the csv into one list

	DataList = list(Names,RAHs,RAMs,RASs,DECDs,DECMs,DECSs)

; This command will provide a readout of what is printed to the screen for the entire process until it is ended so there is a record.

	JOURNAL,"GDLsearchJournal.txt"

	; This begins the search process. It repeats the whole process until the user decides to stop

	repeat begin

		; Ask user if they want to search by Source Name, RAh, or DecD

			print,""
			print,"How Would You Like To Search The File? "
			print,""
			read,mode,prompt="|1 = Source Name| |2 = Right Ascension Hours| |3 = Declination Degrees| "
			print,""

		; Mode 1 Selected ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		; This is the code that runs if Mode 1 is selected
		
			if mode eq 1 then begin 

			; Print the list of sources with selector numbers so the user can pick which one they want

				repeat begin
					for i=0,N_ELEMENTS(Names)-1 do begin
						print,i+1," --- ",Names[i]
					endfor

			; User selects source
					print,""
					read,source_selector,prompt="Which Source Would You Like Information For? "

			; This question repeats until the user enters a number that is on the list

					repeat begin	
						if source_selector gt N_ELEMENTS(Names) then begin
							read,source_selector,prompt="Which Source Would You Like Information For? "
						endif
					endrep until source_selector le N_ELEMENTS(Names)

			; Assign the most recent selected source's data to variables for display
					RAh = RAHs[source_selector-1]
					RAm = RAMs[source_selector-1]
					RAs = RASs[source_selector-1]
					DecD = DECDs[source_selector-1]
					DecM = DECMs[source_selector-1]
					DecS = DECSs[source_selector-1]

			; Display the source information chosen by user

					print,""
					print,Names[source_selector-1],":"
					print,""
					print,"RA Hr: ",RAh
					print,"RA Min: ",RAm
					print,"RA Sec: ",RAs
					print,"Dec Deg: ",DecD
					print,"Dec Min: ",DecM
					print,"Dec Sec: ",DecS
					print,""

			; Identify if the chosen source is a star or constellation
				
				if (RAm eq 0) and (DecM eq 0) then begin
					print,"This Source Is A Constellation!"
					print,""
				endif else begin
					print,"This Source Is A Star!"
					print,""
				endelse


			; Allow the user to pick another source until they are satisfied

					print,"Would You Like to Pick Another Source From The List? If Not, The Most Recent Values Will Be Stored For Computation. "
					read,cont,prompt="|1 = Yes| |0 = No| "
					print,""
			
			; Repeat this question until either 1 or 0 is chosen
					repeat begin	
						if cont gt 1 then begin
							print,"Would You Like to Pick Another Source From The List? If Not, The Most Recent Values Will Be Stored For Computation. "
							read,cont,prompt="|1 = Yes| |0 = No| "
						endif
					endrep until cont le 1

				endrep until cont eq 0              ; End to the repeat loop at the beginning of Mode 1

			; Print the final choice from user and indicate the next step is being started

				print,""
				print,"Proceeding with: "
				print,Names[source_selector-1]
				print,""
				print,"RA Hr: ",RAh
				print,"RA Min: ",RAm
				print,"RA Sec: ",RAs
				print,"Dec Deg: ",DecD
				print,"Dec Min: ",DecM
				print,"Dec Sec: ",DecS
				print,""


			; Print the selected source and its info to the GDLSearch file		
				printf,2,systime()
				printf,2,Names[source_selector-1],":"
				printf,2,"RAh: ",RAh
				printf,2,"RAm: ",RAm
				printf,2,"RAs: ",RAs
				printf,2,"DecD: ",DecD
				printf,2,"DecM: ",DecM
				printf,2,"DecS: ",DecS
				
			; Save the variables to be called by other procedures
				save, RAh,RAm,RAs,DecD,DecM,DecS, FILENAME = 'RefVar.sav'

			endif          ; End if to initialize Mode 1

		; Mode 2 Selected ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		; This is the code that runs if Mode 2 is selected

			if mode eq 2 then begin

			; Ask the user what RA they want

				read,user_RAh,prompt="What Right Ascension Hour Are You Searching For? "
				print,""

			; Ask for a search range input and then indicate searching

				read,user_range,prompt="Please Enter A Plus Or Minus Value For The Search Range. Entering 0 Means Only Exact Matches Will Be Shown. "
				print,""
				print,"Searching for RA Hours With Your Value..."
				print,""

			; Create some lists and arrays to be able to manipulate the master file

				RALS = list()
				RAA = []
				RAAS = list()
				NAA = list()
				CC = list()

			; Print titles for the displayed info

				print," Name ------- RAh ------- RAm ------- RAs ------- DecD ------- DecM ------- DecS "

			; Go through DataList and search for RAH minus user_range

			if user_range gt 0 then begin
				search_floor = (user_RAh - user_range)

				for i=0,N_ELEMENTS(RAHs)-1 do begin
					if RAHs[i] eq search_floor then begin
						RAA = [RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]]                  ; Take only the number columns and add them to a temporary list
						RAAS.add,RAA																; Add them
						NAA.add,Names[i]
						CC.add,Names[i]															; Take all the names that match that data and add them to another temporary list
						RALS = list(Names[i],RAA,/EXTRACT)											; Combine the lists to show user's search results and provide a count
						print,Names[i],RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]			; Print user's search results
					endif
				endfor
			
				for i=0,N_ELEMENTS(RAHs)-1 do begin
					if (RAHs[i] gt search_floor) && (RAHs[i] lt user_RAh) then begin
						RAA = [RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]]                  ; Take only the number columns and add them to a temporary list
						RAAS.add,RAA																; Add them
						NAA.add,Names[i]															; Take all the names that match that data and add them to another temporary list
						CC.add,Names[i]	
						RALS = list(Names[i],RAA,/EXTRACT)											; Combine the lists to show user's search results and provide a count
						print,Names[i],RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]			; Print user's search results
					endif
				endfor
			endif

			; Go through DataList and search for matching RAHs

				for i=0,N_ELEMENTS(RAHs)-1 do begin
					if RAHs[i] eq user_RAh then begin
						RAA = [RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]]                  ; Take only the number columns and add them to a temporary list
						RAAS.add,RAA																; Add them
						NAA.add,Names[i]															; Take all the names that match that data and add them to another temporary list
						CC.add,Names[i]	
						RALS = list(Names[i],RAA,/EXTRACT)											; Combine the lists to show user's search results and provide a count
						print,Names[i],RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]			; Print user's search results
					endif
				endfor

			; Go through DataList and search for RAH plus user_range

			if user_range gt 0 then begin 
				search_ceiling = (user_RAh + user_range)

				for i=0,N_ELEMENTS(RAHs)-1 do begin
					if (RAHs[i] gt user_RAh) && (RAHs[i] lt search_ceiling) then begin
						RAA = [RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]]                  ; Take only the number columns and add them to a temporary list
						RAAS.add,RAA																; Add them
						NAA.add,Names[i]															; Take all the names that match that data and add them to another temporary list
						CC.add,Names[i]	
						RALS = list(Names[i],RAA,/EXTRACT)											; Combine the lists to show user's search results and provide a count
						print,Names[i],RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]			; Print user's search results
					endif
				endfor

				for i=0,N_ELEMENTS(RAHs)-1 do begin
					if RAHs[i] eq search_ceiling then begin
						RAA = [RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]]                  ; Take only the number columns and add them to a temporary list
						RAAS.add,RAA																; Add them
						NAA.add,Names[i]															; Take all the names that match that data and add them to another temporary list
						CC.add,Names[i]	
						RALS = list(Names[i],RAA,/EXTRACT)											; Combine the lists to show user's search results and provide a count
						print,Names[i],RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]			; Print user's search results
					endif
				endfor
			endif

			; Counts the temporary lists to make sure they have stuff in them and prints communications

				RC = RALS.count()
				Counter = CC.count()

				if RC lt 1 then begin                             ; If there are no matches
					print,"Sorry. No Matches."
					print,""
				endif

				if user_RAh gt 23 then begin						; If the user enters a number bigger than 23.99, explain why that isn't allowed
					print,"Right Ascension Hours Go From 1 - 23.99"
					print,""
				endif

			; If there are matches, ask the user to pick one to proceed with


				if	RC ge 1 then begin								
					print,""
					repeat begin
						read,line_selector,prompt="Which Line Would You Like to Proceed With? "
						print,""
					endrep until line_selector le Counter

				; Assign the most recent selected source's data to variables for display
					RAh = RAAS[line_selector - 1,0]
					RAm = RAAS[line_selector - 1,1]
					RAs = RAAS[line_selector - 1,2]
					DecD = RAAS[line_selector - 1,3]
					DecM = RAAS[line_selector - 1,4]
					DecS = RAAS[line_selector - 1,5]

				; Print the final choice from user and indicate the next step is being started

					print,""
					print,"Proceeding with: "
					print,NAA[line_selector - 1]
					print,""
					print,"RA Hr: ",RAh
					print,"RA Min: ",RAm
					print,"RA Sec: ",RAs
					print,"Dec Deg: ",DecD
					print,"Dec Min: ",DecM
					print,"Dec Sec: ",DecS
					print,""

				; Identify if the chosen source is a star or constellation
					
					if (RAm eq 0) and (DecM eq 0) then begin
						print,"This Source Is A Constellation!"
						print,""
					endif else begin
						print,"This Source Is A Star!"
						print,""
					endelse

				; Print the selected source and its info to the GDLSearch file	

					printf,2,systime()
					printf,2,NAA[line_selector - 1],":"
					printf,2,"RAh: ",RAh
					printf,2,"RAm: ",RAm
					printf,2,"RAs: ",RAs
					printf,2,"DecD: ",DecD
					printf,2,"DecM: ",DecM
					printf,2,"DecS: ",DecS
				; Save the variables to be called by other procedures
					save, RAh,RAm,RAs,DecD,DecM,DecS, FILENAME = "RefVar.txt"
				endif

			endif			; End if mode 2 is selected

		; Mode 3 Selected ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		; This is the code that runs if Mode 1 is selected

			if mode eq 3 then begin

			; Ask the user what Dec Degrees they want
				read,user_DecD,prompt="What Declination Degrees Are You Searching For? "
				print,""

			; Ask for a search range input and then indicate searching

				read,user_range,prompt="Please Enter A Plus Or Minus Value For The Search Range. Entering 0 Means Only Exact Matches Will Be Shown. "
				print,""
				print,"Searching for Dec Degrees With Your Value..."
				print,""

			; Create some lists and arrays to be able to manipulate the master file
				DecDL = list()
				RALS = list()
				DLL = []
				DLLS = list()
				NAAS = list()
				CC = list()


			; Print titles

				print," Name ------- RAh ------- RAm ------- RAs ------- DecD ------- DecM ------- DecS "


			; Go through DataList and search for DECDs minus user_range

			if user_range gt 0 then begin
				search_floor = (user_DecD - user_range)

				for i=0,N_ELEMENTS(DECDs)-1 do begin
					if DECDs[i] eq search_floor then begin
						DLL = [RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]]				; Take only the numbers from the list and arrange them to be checked and displayed
						DLLS.add,DLL															; Add them to a temporary list
						NAAS.add,Names[i]														; Add the names to a temporary list
						CC.add,Names[i]
						DecDL = list(Names[i],DLL,/EXTRACT)										; Combine the temporary lists
						print,Names[i],RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]		; Print the matches for the users search
					endif
				endfor

				for i=0,N_ELEMENTS(DECDs)-1 do begin
					if (DECDs[i] gt search_floor) && (DECDs[i] lt user_DecD) then begin
						DLL = [RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]]				; Take only the numbers from the list and arrange them to be checked and displayed
						DLLS.add,DLL															; Add them to a temporary list
						NAAS.add,Names[i]														; Add the names to a temporary list
						CC.add,Names[i]
						DecDL = list(Names[i],DLL,/EXTRACT)										; Combine the temporary lists
						print,Names[i],RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]		; Print the matches for the users search
					endif
				endfor

			endif

			; Go through DataList and search for DECDs that match the users search

				for i=0,N_ELEMENTS(DECDs)-1 do begin
					if DECDs[i] eq user_DecD then begin
						DLL = [RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]]				; Take only the numbers from the list and arrange them to be checked and displayed
						DLLS.add,DLL															; Add them to a temporary list
						NAAS.add,Names[i]														; Add the names to a temporary list
						CC.add,Names[i]
						DecDL = list(Names[i],DLL,/EXTRACT)										; Combine the temporary lists
						print,Names[i],RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]		; Print the matches for the users search
					endif
				endfor

			; Go through DataList and search for DECDs plus user_range

			if user_range gt 0 then begin
				search_ceiling = (user_DecD + user_range)

				for i=0,N_ELEMENTS(DECDs)-1 do begin
					if (DECDs[i] gt user_DecD) && (DECDs[i] lt search_ceiling) then begin
						DLL = [RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]]				; Take only the numbers from the list and arrange them to be checked and displayed
						DLLS.add,DLL															; Add them to a temporary list
						NAAS.add,Names[i]														; Add the names to a temporary list
						CC.add,Names[i]
						DecDL = list(Names[i],DLL,/EXTRACT)										; Combine the temporary lists
						print,Names[i],RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]		; Print the matches for the users search
					endif
				endfor

				for i=0,N_ELEMENTS(DECDs)-1 do begin
					if DECDs[i] eq search_ceiling then begin
						DLL = [RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]]				; Take only the numbers from the list and arrange them to be checked and displayed
						DLLS.add,DLL															; Add them to a temporary list
						NAAS.add,Names[i]														; Add the names to a temporary list
						CC.add,Names[i]
						DecDL = list(Names[i],DLL,/EXTRACT)										; Combine the temporary lists
						print,Names[i],RAHs[i],RAMs[i],RASs[i],DECDs[i],DECMs[i],DECSs[i]		; Print the matches for the users search
					endif
				endfor

			endif
			
			; Test to make sure there are matches to the users search

				DL = DecDL.count()
				Counter = CC.count()

				if DL lt 1 then begin										; If there are no matches
					print,"Sorry. No Matches."
					print,""
				endif

			; If there are matches, ask the user to pick one to proceed with


				if	DL ge 1 then begin								
					print,""
					repeat begin
						read,line_selector,prompt="Which Line Would You Like to Proceed With? "
						print,""
					endrep until line_selector le Counter

					; Assign the most recent selected source's data to variables for display
					RAh = DLLS[line_selector - 1,0]
					RAm = DLLS[line_selector - 1,1]
					RAs = DLLS[line_selector - 1,2]
					DecD = DLLS[line_selector - 1,3]
					DecM = DLLS[line_selector - 1,4]
					DecS = DLLS[line_selector - 1,5]

					; Print the final choice from user and indicate the next step is being started

					print,""
					print,"Proceeding with: "
					print,""
					print,NAAS[line_selector - 1]
					print,""
					print,"RA Hr: ",RAh
					print,"RA Min: ",RAm
					print,"RA Sec: ",RAs
					print,"Dec Deg: ",DecD
					print,"Dec Min: ",DecM
					print,"Dec Sec: ",DecS
					print,""

				; Identify if the chosen source is a star or constellation
					
					if (RAm eq 0) and (DecM eq 0) then begin
						print,"This Source Is A Constellation!"
						print,""
					endif else begin
						print,"This Source Is A Star!"
						print,""
					endelse

				; Print the selected source and its info to the GDLSearch file

					printf,2,systime()
					printf,2,NAAS[line_selector - 1],':'
					printf,2,"RAh: ",RAh
					printf,2,"RAm: ",RAm
					printf,2,"RAs: ",RAs
					printf,2,"DecD: ",DecD
					printf,2,"DecM: ",DecM
					printf,2,"DecS: ",DecS

				; Save the variables to be called by other procedures
					save, RAh,RAm,RAs,DecD,DecM,DecS, FILENAME = "RefVar.txt"
				endif


				
			endif   ; End if mode 3 is selected

; Ask the user if they want to start over and search again

	print,"Would You Like To Start The Search Over Again?"
	read,end_Ref4,prompt="|1 = Yes| |0 = No| "

	endrep until end_Ref4 eq 0				; End repeat from very beginning if user chooses not to start over

	JOURNAL								; End journal entries

; Make sure the user knows where to find the files that log what happened in their session. Warn them that they will be overwritten with every new session

	print,""
	print,"***"
	print,"Please Make Sure To Find 'GDLSearch.txt' As Well As 'GDLsearchJournal.txt' In The Directory Where This Program Is Saved."
	print,"'GDLSearch.txt' Provides A Log of The Stars That Were Selected. 'GDLsearchJournal' Provides A Detailed Log Of Everything Printed To Screen."
	print,"Both Files Are Overwritten With Every New Call Of The Program. Once It Is Started Again, This Session Will Be Lost."
	print,"***"
	print,""

; End the program
	print,"End Search."
	print,""
end