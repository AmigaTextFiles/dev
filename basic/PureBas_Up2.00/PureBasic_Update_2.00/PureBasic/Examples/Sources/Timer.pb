
; ***********************************
;
;  Timer example file for Pure Basic
;
;    © 2000 - Fantaisie Software -
;
; ***********************************


 If InitTimer()

   StartTimer()
   calib.l=StopTimer()

   For b.l=0 To 5

     StartTimer()

     For c.l=0 To 999    ; } some delay here
     Next c              ; }

     time.l=StopTimer()

     PrintNumberN(time-calib)

   Next b

 EndIf

 PrintN("End of Program.")
 End

