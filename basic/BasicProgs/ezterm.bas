0     screen 1,1,0:gosub 40000:print" F1 - Capture ON":Print " F2 - Capture OFF":print " F3 - Save Capture Buffer":print " F4 - Review Capture Buffer"

2     print " F5 - Load Buffer for Uploading":print " F6 - Start Uploading Buffer":print " F7 - Duplex Toggle":print " F8 - Clear Buffer":print " HELP - Help!!!"

3     print "ALT-Q - Quit Program"

5     dim a$(6000)

6     rem kelly kauffman, 3170 sprout way, sparks, nv, 89431:  CIS [70206,640]

7     rgb 0,0,0,10:rgb 1,10,10,10

10    print "A ""`"" acts as a CTRL-C at any time.":gosub 40

12    print:print

15    print "                           EZ-TERMINAL VER 1.17":print "                           )1985 Kelly Kauffman"

16    ?   :?"                           FOR PUBLIC USE ONLY"

17    ?:?:?" Put mouse in box -->     [ ]  and click LEFT button to initialize program"

20    get char$



23    if char$<>"" then if asc(char$)=155 then gosub 1000

25    if char$="`" then char$=chr$(3)

30    gosub 150:gosub 160:print char$;:goto 20



40    'Serial I/O driver



50    'config



60    BAUD%=300

70    iobase%=&hdff000



80    serdatr%=&h18+iobase%



90    serdat%=&h30+iobase%



100   serper%=&h32+iobase%



110   intreq%=&h9c+iobase%



120   poke_w serper%,(1/baud%)/(.2794*1e-06)



130   return



140   'write



150   if char$<>"" then if asc(char$)=241 then 42000

151   if char$="" then return else poke_w serdat%,asc(char$)+256

153   if plex=1 then print char$;

154   if plex=1 and cap=1 then buff$=buff$+char$

155   if plex=1 and asc(char$)=13 then print

156   if len(buff$)>253 then gosub 20000

157   return

160   'read



170   char%=peek_w(serdatr%)



175   on error goto 0

180   if (char% and 16384) = 0 then char$="":return



185   if len(buff$)>253 then gosub 20000

190   char$=chr$(char% and 127):poke intreq%,8:if cap=1 then buff$=buff$+char$



191   return

200   gosub 160: print char$;:goto 200

1000  get char$

1010  if char$="" then return

1020  if asc(char$)<48 or asc(char$)>63 then return

1030  if asc(char$)=48 then print "           C A P T U R E        O N ":cap=1:get char$:get char$:return

1040  if asc(char$)=49 then print "           C A P T U R E        O F F ":cap=0:get char$:get char$:num=num+1:a$(num)=buff$:buff$="":return

1050  if asc(char$)=50 then ?

1060  if asc(char$)=50 and len(buff$)=0 and num=0 then print "   B U T   T H E R E'S    N O T H I N G   T O   S A V E ! ! !":get char$:get char$:return

1065  if asc(char$)=50 then cap=0:num=num+1:a$(num)=buff$:buff$=""

1070  if asc(char$)=50 then get char$:get char$:input "Save as ---->";file$:if file$="" then return else open "o",#4,file$:for q=0 to num:print #4,a$(q);:next q:close #4:print "   C A P T U R E   B U F F E R  S A V E D":return

1072  if asc(char$)=51 then num=num+1:a$(num)=buff$:buff$=""

1073  if asc(char$)=51 then scnclr:get char$:get char$:for q=0 to num:print a$(q);:get char$:if char$<>"" then print :?:?"REVIEW ABORTED":return else next q:?:?:?:?:?"Buffer Review Complete.":return

1074  gosub 30000

1075  get char$:get char$

1080  return

20000 a$(num)=buff$

20010 num=num+1:buff$=""

20020 return

30000 on error goto 30999

30001 if asc(char$)=53 then gosub 33000:return

30010 if asc(char$)=52 then gosub 32000:return

30020 if asc(char$)=54 then gosub 34000:return

30030 if asc(char$)=63 then gosub 35000:return

30040 if asc(char$)=55 then gosub 36000:return

30999 return

32000 scnclr

32010 erase a$

32020 dim a$(3000)

32025 get char$:get char$

32027 print at(0,0)

32030 input "Load what Filename ------>";file$

32035 if file$="" then print "Aborted.":goto 32512

32036 x=instr(1,file$,".bas"):y=instr(1,file$,".BAS"):if x=0 or y=0 then bas=0 else bas=1

32038 bas=1

32040 close #4

32045 num=0:erase a$:dim a$(6000)

32050 open "i",#4,file$

32075 on error goto 32510

32080 if bas=1 then line input #4,buff$ else get #4,w$

32085 if bas<>1 and w$="" then 32510

32090 if bas=1 then a$(num)=buff$ else b=len(a$(num)):if b>253 then num=num+1:a$(num)=a$(num)+w$

32095 if bas<>1 and b<=253 then a$(num)=a$(num)+w$

32100 if bas=1 then num=num+1:buff$=""

32110 if not eof(4) then 32080

32510 print "Complete File Loaded."

32512 on error goto 0

32515 close #4

32520 return

33000 scnclr

33010 print

33011 get char$:get char$

33015 if bas=1 then print "Do you want to use the prompts for every line":input yn$:if yn$="n" or yn$="N" then prompt=0 else prompt=1

33017 print :print"Do you want a return sent after each line":input yn$:if yn$="Y" or yn$="y" then retn=1 else retn=0

33018 scnclr

33020 print " Beginning Upload"

33025 get char$:get char$

33030 for i=0 to num

33040 for q=1 to len(a$(i))

33045 qwer=asc(mid$(a$(i),q,1)): if bas=1 and qwer=10 then qwer=13

33047 get char$:if char$<>"" then print:?:?"UPLOAD ABORTED BY USER":print:print:goto 33090

33050 poke_w serdat%,qwer+256

33053 print mid$(a$(i),q,1);

33055 sleep 16000

33060 next q

33065 if retn=1 then poke_w serdat%,269:print

33067 if prompt=1 then gosub 37000

33070 next i

33075 print:print

33080 print "Buffer Upload Complete."

33090 return

34000 if plex=1 then plex=0:?:?:print "          F U L L   D U P L E X":goto 34020

34010 if plex=0 then plex=1:?:?:print "          H A L F   D U P L E X"

34020 get char$:get char$:return

35000 scnclr

35010 print "F1 - Turns Capture On.  All incoming data will be saved in the buffer."

35020 print "F2 - Turns Capture Off.  No data is saved in the buffer."

35030 print "F3 - Save Capture Buffer.  Saves the contents of the buffer to a file of your     choice."

35040 print "F4 - Review Buffer.  Lets you see the contents of the buffer.  Press any          key during the review to abort."

35050 print "F5 - Load Buffer.  This will load a file of your choice into the Buffer.          NOTE: It does NOT merge the data, it instead, clears out the old             information, then loads in the new."

35060 print "F6 - Upload Buffer.  The question about prompts means that the Amiga will         wait for the computer you are hooked up with sends a prompt character.       This character is the "">"" character.  If you are sending other than a"

35070 print "     source code, reply ""N""o to this question, then the Amiga will just           upload the entire buffer without waiting for prompts."

35080 print "F7 - Duplex.  This toggles between half and full duplex.  When in Full            duplex, the computer you are hooked up with, must echo back what you         type in order to see what you have typed.  If the computer you are  "

35090 print "     hooked up with does not echo back what you type, go to half duplex           and your typing will be put on the screen immediately."

35100 print "F8 - Clear buffer.  Clears out the capture/upload/review buffer."

35110 return

36000 print

36010 print

36020 print "                B U F F E R    C L E A R E D"

36030 erase a$

36040 dim a$(3000)

36050 buff$=""

36060 return

37000 gosub 160

37010 if char$<>">" then 37000

37020 return

40000 rem draw windows for Function definitions

40010 window #1,0,200,640,100

40020 print #1,inverse(1);"F1";inverse(0);"-Cap On ";inverse(1);"F2";inverse(0);"-Cap Off ";inverse(1);"F3";inverse(0);"-Save ";inverse(1);"F4";inverse(0);"-Review ";inverse(1);"F5";inverse(0);

40030 print #1,"-Load ";inverse(1);"F6";inverse(0);"-Upload ";inverse(1);"F7";inverse(0);"-Duplex ";inverse(1);"F8";inverse(0);"-Clear";

40040 window #2,0,0,640,186

40050 cmd 2

40060 return

42000 close #1,2

42010 end



