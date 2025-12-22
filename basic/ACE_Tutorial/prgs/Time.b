Hour$ = Left$(Time$, 2)

If Hour$ < "12" Then
  Print "Good Morning World"
EndIf
If Hour$ >= "12" Then
  Print "Good Afternoon World"
End If