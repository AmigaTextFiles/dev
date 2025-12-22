
-> recursive functions and non-basic arguments example (LS)

PROC main() IS ohyeah([1,2,3])

PROC ohyeah(x[3]:LIST)

   /* mess around with the values */
   x[0] := x[0] + x[2]
   x[1] := x[2] + x[0]
   x[2] := x[1] + x[0]

   PutFmt('\d,\d,\d\n', x)
   
   IF x[] < 1000 THEN ohyeah(x)
   
   PutFmt('\d,\d,\d\n', x)

ENDPROC


