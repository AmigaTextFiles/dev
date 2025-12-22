;
; *****************************************
;
;   Fast Array Sort Routine for PureBasic
;
;         © 1999 Fantaisie Software
;
; *****************************************
;

Dim n.b(20000)

n(0) = 5
n(10000) = 120
n(15000) = 2
n(18000) = 50
n(2000) = 32

SortDown(n(), 0, 20000)  ; Sorting the 20000 elements in few seconds !!

For k=0 To 4
  PrintN("Result = "+Str(n(k)))
Next

MouseWait()

End
