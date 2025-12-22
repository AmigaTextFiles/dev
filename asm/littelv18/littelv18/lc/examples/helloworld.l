   ; Hello World in LITTEL 0.16 :)

   #link amiga.lib      ; for example...
   #xref _puts

   STRING _hello "hello world!\n"

   PROC main
      dpr _puts _hello FLUSH ; print it
   ENDPROC

   END  ;dont forget this one
  



