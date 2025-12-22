REM bhelp for QB2C versions 3.2k and later - by Mario Stipcevic
REM This is a QB2C code. Compile it with: bcc
c$ = command$
line$ = "": nl% = 0
rem local_path$ = 
rem src_path$ = 
rem if exists()
helpf$ = "/home/mario/qb2c/manual.txt"
if c$ <> "" then
 open helpf$ for input as #1
  key$ = "o " + UCASE$(c$)
  leng% = len(key$)
  while (left$(line$, 20) <> "+ Reference Manual +") and not eof(1)
   line input #1, line$: nl% = nl% + 1
  wend
  while (left$(line$, leng%) <> key$) and not eof(1)
   line input #1, line$: nl% = nl% + 1
  wend
 close #1
 shell "vi +" + mid$(str$(nl%), 2) + " " + helpf$
else
 shell "vi " + helpf$
endif
END
