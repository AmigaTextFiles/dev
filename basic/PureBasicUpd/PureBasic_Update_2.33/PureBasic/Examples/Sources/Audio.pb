
; **********************************
;
;  Audio example file for PureBasic
;
;   © 2000 - Fantaisie Software -
;
; **********************************


 If InitAudio()

   If AllocateAudioChannels(15)

     chan.w=15
     snd_chan.w=3
     ptm_chan.w=12

   Else

     chan_mask.w=1

     For c.l=0 To 3
       tmp_chan.w=AllocateAudioChannels(chan_mask.w)
       chan.w | tmp_chan.w : chan_mask.w << 1
     Next

     snd_chan.w=chan.w & 3
     ptm_chan.w=chan.w & 12

   EndIf

   Print("Allocated channels ") : PrintNumberN(chan.w)

   UseAsSoundChannels(snd_chan.w)
   UseAsPTModuleChannels(ptm_chan.w)

 EndIF
 
 MouseWait()

 PrintN("End of Program.")
 End

