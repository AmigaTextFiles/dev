
-> hmm.. helloworld in a complicated way. (LS)

PROC main()

   rPrintAll([["h", "e", [["l"]], "l"],
              ["o", [" "], ["t", "h"]],
              ["e", "r", ["e","!","!"],
              "!", ["\n"]]])
   
ENDPROC NIL

PROC rPrintAll(l) IS ForAll(l, `IF \1 > 255 THEN rPrintAll(\1) ELSE PrintF('\c', \1))





