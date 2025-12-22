PROC main()

   DEF c, n, k

   FOR n := 0 TO 255
      c := n
      FOR k := 0 TO 7
        IF c AND 1
           c := Eor($edb88320, c SHR 1)
        ELSE
           c := c SHR 1
        ENDIF
      ENDFOR
      WriteF('$\h,\n', c)
   ENDFOR

ENDPROC
