10    ? "XMODEM Padding Remover"
20    ? "    By Jim Nangano"
30    ? "This program will produce"
40    ? "a loadable file from the "
50    ? "file downloaded by Xmodem"
60    ? :? "You will be prompted for"
70    ? "the input filename. The program"
80    ? "will output the same filename"
90    ? "with a '.OBJ' extension":?
100   INPUT "NAME OF FILE TO BE STRIPPED ? ",IN$
110   OPEN "N",#1,IN$,128
120   ON ERROR GOTO 140
140   ON ERROR GOTO 0
150   OPEN "N",#2,IN$+".OBJ"
160   FIELD #1,128 AS IBUFF$
170   FIELD #2,128 AS OBUFF$
180   NRECS=(LOF(1)/128)-1
185   rput #2,0
190   FOR I=1 TO NRECS
200   ? nrecs-i+1;"Records remaining ";chr$(13);
210   RGET #1,I:LSET OBUFF$=IBUFF$:RPUT #2,I
240   NEXT I:CLOSE #2
260   OPEN "A",#2,IN$+".OBJ":RGET #1,I:PTR=1
290   ? "CORRECTING LAST RECORD"
300   while mid$(ibuff$,ptr,2)<>chr$(3)+chr$(&hf2)
310   PRINT #2,MID$(IBUFF$,PTR,1);:PTR=PTR+1
330   WEND
332   print#2,mid$(ibuff$,ptr,2);
340   CLOSE #1: CLOSE #2
350   ? "Done!"
360   ? "at the CLI prompt enter"
370   ? IN$;".OBJ to run the program"
