100   scnclr: print "Xterm v3.1 by K.L. Colclasure (11/16/85)"
110   print: print "Commercial distribution prohibited without"
120   print "express written permission of author ..."
130   'RS232 drivers derived from UART.BAS by John Hodgson
150   size% = 5: timeout% = 500: baud% = 300
290   gosub 900: goto 500
300   key% = asc(key$): poke_w out%, key% + 256
310   return
320   gflag% = 0: char% = peek_w(in%)
330   if (char% and 16384) = 0 then return else gflag% = -1
340   char% = char% and 127: poke intrq%, 8: return
350   t = 0: toflag% = 0
360   char% = peek_w(in%)
370   if (char% and 16384) = 0 then t = t + 1 else 400
380   if t > timeout% then toflag% = -1: return
390   goto 360
400   char% = char% and 255: poke intrq%, 8: return
410   cksum% = 0: for i = 1 to 131
420   cksum% = (cksum% + buf%(n,i)) and 255: next i
430   if cksum% = buf%(n,132) then 450
440   print "Cksum error in"; blk%: key$ = nak$: return
450   mblk% = blk% and 255
460   if mblk% = buf%(n,2) then 480
470   print "Sync error in"; blk%: key$ = nak$: return
480   blk% = blk% + 1: n = n + 1: key$ = ack$
490   print "  Recieved"; blk% - 1; chr$(13);: return
500   print: print "[Term: use HELP key for instructions]"
505   print: on error goto 0
510   get key$: if key$ = "" then 540
520   if key$ = chr$(155) then 800
530   gosub 300
540   gosub 320: if (gflag%) then print chr$(char%);
550   goto 510
600   print: print "Recieve, enter filename: ";
610   line input file$: if file$ = "" then 500
620   open "o",#1,file$: close #1
630   blk% = 1: n = 1: eotflag% = 0: key$ = nak$
650   gosub 300: for i = 1 to 132: gosub 350
651   if (toflag%) then key$ = nak$: goto 650
652   if (i = 1) and (char% = eot) then 660
653   buf%(n,i) = char%: next i: gosub 410
654   if n > top% then 670 else 650
660   eotflag% = -1
670   open "a",#1,file$
671   for x = 1 to (n - 1): for y = 4 to 131
672   print #1, chr$(buf%(x,y));
673   next y,x
674   close #1
680   if not (eotflag%) then n = 1: goto 650
685   gosub 300
690   print: print "Transfer complete ...": goto 500
700   print: print "Send, enter filename: ";
701   line input file$: if file$ = "" then 500
702   on error goto 2500
703   open "i",#1,file$
704   on error goto 0
710   n = lof(1): n = n / 128
711   if int(n) < n then n = int(n) + 1 else n = int(n)
712   print "File open,";n;"records."
720   n = 1: blk% = 1
730   buf%(n,1) = soh: buf%(n,2) = blk% and 255
731   buf%(n,3) = buf%(n,2) xor 255
740   for i = 4 to 131
741   if not eof(1) then get #1, char$ else char$ = eof$
742   buf%(n,i) = asc(char$): next i
743   gosub 770: gosub 780: print "  Sent block"; blk%; chr$(13);
744   if not eof(1) then blk% = blk% + 1: goto 730
750   close #1
760   key$ = chr$(eot): gosub 300
761   gosub 320: if not gflag% then 761
762   if char% = nak then 760
763   if char% = ack then 690 else 761
770   cksum% = 0: for i = 1 to 131
771   cksum% = (cksum% + buf%(n,i)) and 255: next i
772   buf%(n,132) = cksum%: return
780   if blk% = 1 then 783
781   for i = 1 to 132: key$ = chr$(buf%(n,i))
782   gosub 300: sleep 30000: next i
783   gosub 320: if not gflag% then 783
784   if char% = nak then 781
785   if char% = ack then return else 783
800   get key$: if key$ = "" then 510 else fkey% = asc(key$)
810   fkey% = fkey% - 47: get key$: if key$ <> chr$(126) then 510
820   if fkey% = 16 then 2000
830   on fkey% goto 1000,1000,1000,1000,1000,600,700,600,600,1500
900   option base 1: dim buf%(size%*8,132): top% = size% * 8
910   baudr% = &hdff032: out% = &hdff030
920   in% = &hdff018: intrq% = &hdff09c
930   poke_w baudr%, (1/baud%)/(.2794*1e-06)
940   ack$ = chr$(6): nak$ = chr$(21): eot$ = chr$(4)
950   ack = 6: nak = 21: eot = 4: soh = 1
960   eof$ = chr$(26)
990   return
1000  goto 2000
1500  key$ = chr$(3): gosub 300: goto 510
2000  print: print "Function key assignments ..."
2010  print
2020  print "[F1] thru [F5]: User definable. (Not implemented)"
2030  print "[F6]: Recieve file with Xmodem protocol."
2040  print "[F7]: Send file with Xmodem protocol."
2050  print "[F8] and [F9]: Reserved for future expansion."
2060  print "[F10]: Send Control-C to host system."
2070  print
2080  print "Typing a Control-C will terminate the program. Use [F10]"
2090  print "to send this character!"
2100  goto 500
2500  print "Unable to open file ...": resume 500
