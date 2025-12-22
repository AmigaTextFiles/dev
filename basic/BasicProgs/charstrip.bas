20    '    Program to strip all non-printing characters from a file'
30    '-
40    '
50    input% = 1
60    output% = 2
70    legalchars$ = chr$(9) + chr$(10) + chr$(13)
100   input "Input file> "; infile$
110   input "Output file> "; outfile$
120   open "i", #input%, infile$
130   open "o", #output%, outfile$
200   if eof(input%) then goto 990
210   get #input%, char$
215   if ( instr (legalchars$,char$) > 0 ) then goto 220
216   if ( (char$ > "~") or (char$ < " ") ) then goto 200
220   print #output%, using "&"; char$;
500   goto 200
990   close #input%
991   close #output%
999   end
