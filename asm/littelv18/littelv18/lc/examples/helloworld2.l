   ; Hello World 2  in LITTEL 0.16 :)

   #include "ainc:lib/dos.i"

   STRING _hello "hello world!"

   PROC main
      copy _hello   d1         ; adr of string
      copy 13       d2         ; lenght of string
      call _DOSBase WriteChars ; print it
   ENDPROC

   END  ;dont forget this one
  



