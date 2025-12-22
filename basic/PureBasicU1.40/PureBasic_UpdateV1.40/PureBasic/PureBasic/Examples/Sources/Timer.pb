
; ***********************************
;
;  Timer example file for Pure Basic
;
;  © 2000 - Fantaisie Software -
;
; ***********************************


 InitTimer()

 If AllocateTimer()

   PrintN("A timer is allocated.")

   StartTimer()
   cal.w=StopTimer()

   For b.l=0 To 5

     StartTimer()

     For c.l=0 To 999    ; } some delay here
     Next c              ; }

     time.w=StopTimer()

     If time > 0
       time-cal
       PrintNumber(time) : PrintN("")
     Else
       PrintN("Time taken is greater than one frame.")
     EndIf

   Next b

   FreeTimer()
 EndIf

 PrintN("End of Program.")
 End

