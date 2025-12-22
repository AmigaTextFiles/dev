;
; Timer example
;
; by Francis G. Loch
;

InitRequester()

ResetTimer()

For loop=0 To 100
  VWait()
Next

result.l=Timer()

req.l=EasyRequester("Information", "Loop took "+Str(result)+" ticks.", "Okay")