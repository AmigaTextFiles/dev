;
; *************************************
;
; Clipboard example file for Pure Basic
;
;    © 2000 - Fantaisie Software -
;
; *************************************
;
;

SetClipboardText("Hello world - Amiga is Back")    ; Fill the clipboard with our text

a$ = GetClipboardText()                            ; Get the Clipboard content

PrintN("Clipboard content: "+a$)                   ; Display the content. Is it working ?
PrintN("Test it by just press 'Right Amiga + V'")  ; Check yourself

PrintN("") : PrintN("Mouse button to quit.")

MouseWait()

End
