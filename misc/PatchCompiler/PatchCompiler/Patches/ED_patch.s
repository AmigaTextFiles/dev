; ED Patch      taken from FileMaster


check $1aad : "199"			; check if it's the right version !




if true					; yes, now patch window size
   begin
        Patch $1aad : "255"
        Text  "ED 1.4 will now open PAL window."
   end




if false				; no, it's a different version of ED !
   begin
        Text "Sorry, wrong version of ED !"
   end

	 
