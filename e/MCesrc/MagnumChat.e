
->   SCAPE  -  Code MAXsBBS Doors in Amiga E!!!
->   Copyright © Chris Hearn */
->   mAGNUM cHAT! tHE bEST cHAT dOOR fOR mAXSBBS!
->   All Code is Copyright ©1997 Chris Hearn

MODULE 'exec/tasks',
       'exec/ports',
       'exec/nodes',
       'exec/lists',
       'exec/types',
       'amigalib/ports',
       'dos/dos',
       'afc/reqtooller',
       'other/stayrandom'

CONST LINELENGTH=1000

OBJECT doormsg
  door_msg:mn,
  command:INT,
  data:INT,
  string[80]:ARRAY OF CHAR,
  carrier:INT
ENDOBJECT

-> PROC main() is simply the startup code... write your door in
-> PROC theDoor()

-> These are all neaded by the startup code
DEF msgportname[12]:STRING, msgportname2[10]:STRING, mport=NIL:PTR TO mp,
    ourtask,cport=NIL:PTR TO mp, lost_carrier=0, wherefrom:PTR TO CHAR,
    p1:doormsg,chattype, xpos1, xpos2, ypos1, ypos2, freeze, key, wordtwo[80]:STRING,
    cleartype, time[20]:STRING, realtime[20]:STRING, bump, macroword[80]:STRING, spaceflag,
    username[80]:STRING

->  ####################
->  WRITE YOUR DOOR HERE
->  ####################

PROC theDoor()

  -> E-Strings for input and output...
  DEF n=0, space, t, space2, word[80]:STRING, chrt[30]:STRING,
      length, length2, chrt2[30]:STRING, confline[100]:STRING,rawulpath[200]:STRING,ntwo,
      city[30]:STRING, mins, length3, insert, timeleft, timenow,
      write, lastuser, ret, rt=NIL:PTR TO reqtooller, esc,
      filename, autolen, s:PTR TO CHAR, timestr[18]:STRING, time123[18]:STRING, line, stat,
      buf[LINELENGTH]:ARRAY, sqbrack, fh, last=NIL, k, first=NIL, auto[50]:STRING, i, strung[20]:ARRAY OF LONG

NEW rt.reqtooller()

/*
IF fh:=Open('DOORS:mAGNUMcHAT/macros.cfg',OLDFILE)
    WHILE Fgets(fh,buf,LINELENGTH)
        IF (k:=String(StrLen(buf)))=NIL THEN Raise("MEM")
        StrCopy(k,buf,ALL)
        IF last THEN Link(last,k) ELSE first:=k
        last:=k
        INC n
    ENDWHILE
    Close(fh)
    s:=first
ELSE
mxCls()
mxColour(3,0)
mxCentre(4,'Can\at find macro config file :(')
mxGotoXY(1,1)
mxHotKey()
RETURN
ENDIF



n:=1

IF fh:=Open('DOORS:mAGNUMcHAT/macros.cfg',OLDFILE)
    WHILE Fgets(fh,buf,LINELENGTH)
    IF (k:=String(StrLen(buf)))=NIL THEN Raise("MEM")
    StrCopy(k,buf,ALL)
    IF last THEN Link(last,s) ELSE first:=s
    last:=s
    INC n
    ENDWHILE
    Close(fh)
ELSE
mxCls()
mxColour(3,0)
mxCentre(4,'Can\at find macro config file :(')
mxGotoXY(1,1)
mxHotKey()
RETURN
ENDIF
*/

mxGetStrInfo(1,username)
mxGetStrInfo(3,city)

spaceflag:=1
write:=0
mxColour(7,0)
line:=1
stat:=0

Execute('Echo "0" >ENV:Chatting',0,0)

StrCopy(rawulpath,(confreadstr(1)),ALL)
cleartype:=confreadvalue(3)
chattype:=confreadvalue(2)

/*
REPEAT
StrCopy(autostr[line],(confreadauto(line)))
IF (StrCmp(autostr[line],'#',ALL))=TRUE THEN stat:=1
line:=line+1
UNTIL stat=1
*/

begin:

xpos1:=1
xpos2:=1
ypos1:=2
ypos2:=14
lastuser:=0

mxCls()

newchattype:

IF chattype=0
stayrandom()
rand:
chattype:=Rnd(7)
IF chattype=0 THEN JUMP rand
ENDIF

IF chattype=1
mxGotoXY(1,1)
mxColour(1,0)
mxPrint('µ¸¤þ©­®.¡­ððµ¸®®µþ¡®¤­©¤¤°¡©þ¡¤.þµ×®jß×¤©¤°¤¸¤¸©±©×þ°¢½.®¼×¤¾¾±½¤©±¤±¼¸©¸±¼©þ   ')
mxColour(3,0)
mxGotoXY(2,1)
mxPrintLine(0)
mxGotoXY(50,1)
mxPrint(' mAGNUM cHAT bY sTONEcOLD ')
mxGotoXY(1,13)
mxColour(1,0)
mxPrint('%6£¤¤¸þ©¤¾,þçø®¤°¸½,·¡¤©æþ½®,µþ¾®¸±¤,¤©¸þ­­¤­þå®©­þ©®¤©©¤©­¤®¤©¤©æ¤¤¤©¤¤©®þ®ø   ')
mxColour(3,0)
mxGotoXY(1,13)
mxPrint(' Chatting to ')
mxGotoXY(50,13)
mxPrint(' Time Remaining: %k mins ')
mxGotoXY(1,25)
mxColour(1,0)
mxPrint('þþµ¸ßµß®¸µß¼©µ¸¢µ¸¢®µ,¢®µ,®,µß®µ,©¢µ,µ©µ¼©¸µ©¼µ¸©µ©¸¾¸³¾¸¢¾©¸±¼±¾¸©¼¾©¸¼¾¸©¾©Å  ')
mxGotoXY(3,25)
mxColour(3,0)
mxPrint(' dEL/cTRL n - cLEAR sCREEN ')
mxGotoXY(32,25)
mxPrint(' cTRL Z - qUICK lOGoFF ')
mxGotoXY(60,25)
mxPrint(' cTRL Q - qUIT ')
mxGotoXY(14,13)
mxPrint(username)
mxGotoXY(1,2)
ENDIF

IF chattype=2
mxGotoXY(1,1)
mxColour(4,0)
mxPrint('------------------------------------------------------------------------------')
mxColour(6,0)
mxGotoXY(2,1)
mxPrintLine(0)
mxGotoXY(54,1)
mxPrint('mAGNUM cHAT bY sTONEcOLD')
mxGotoXY(1,13)
mxColour(6,0)
mxPrint(' Chatting to')
mxGotoXY(14,13)
mxColour(4,0)
mxPrint('-----------------------------------------------------------------')
mxGotoXY(52,13)
mxColour(6,0)
mxPrint('Time Remaining: %k mins')
mxGotoXY(1,25)
mxPrint('  dEL/cTRL-n - cLEAR sCREEN       cTRL-z - qUICK lOGOFF       cTRL-q  - qUIT   ')
mxColour(6,0)
mxGotoXY(14,13)
mxPrint(username)
mxGotoXY(1,2)
ENDIF

IF chattype=3
mxStyle(1)
mxGotoXY(1,1)
mxColour(7,4)
mxPrint('                                                                              ')
mxGotoXY(3,1)
mxPrintLine(0)
mxGotoXY(54,1)
mxColour(6,4)
mxPrint('mAGNUM cHAT bY sTONEcOLD')
mxGotoXY(1,13)
mxPrint('                                                                              ')
mxGotoXY(3,13)
mxColour(7,4)
mxPrint(username)
mxGotoXY(1,25)
mxColour(6,4)
mxPrint('-----<        >---<         >---<[DEL/Ctrl N] Clear Window(s) [Ctrl Q] Quit >-')
mxColour(3,4)
mxGotoXY(40,13)
mxPrint(city)
mxPrint(' - ')
mxPrint('%w')
mxStyle(0)
chattype1()
ENDIF

IF chattype=4
mxStyle(1)
mxGotoXY(1,1)
mxColour(7,4)
mxPrint('                                                                             ')
mxGotoXY(3,1)
mxPrintLine(0)
mxGotoXY(54,1)
mxColour(6,4)
mxPrint('mAGNUM cHAT bY sTONEcOLD')
mxGotoXY(1,25)
mxPrint('                                                                              ')
mxGotoXY(4,25)
mxColour(7,4)
mxPrint(username)
mxGotoXY(1,13)
mxColour(1,4)
mxPrint('-----<        >---<         >---<[DEL/Ctrl N] Clear Window(s) [Ctrl Q] Quit >-')
mxColour(3,4)
mxGotoXY(40,25)
mxPrint(city)
mxPrint(' - ')
mxPrint('%w')
mxStyle(0)
chattype1()
ENDIF

IF chattype=5
mxGotoXY(1,1)
mxColour(4,0)
mxPrint('ÄÄÄ[     ]ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ')
mxColour(6,0)
mxGotoXY(5,1)
mxPrint('Sysop')
mxColour(4,0)
mxGotoXY(1,13)
mxPrint('ÄÄÄ[ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ')
mxColour(6,0)
mxGotoXY(5,13)
mxPrint(username)
length:=StrLen(username)
mxColour(4,0)
mxGotoXY(length+5,13)
mxPrint(']')
mxGotoXY(1,25)
mxPrint('ÄÄÄ[ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ]ÄÄÄÄÄÄÄÄÄÄÄ[ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ]ÄÄÄÄÄÄÄÄÄÄÄ')
mxGotoXY(5,25)
mxColour(6,0)
mxPrint('mAGNUM cHAT v1.15 - SplitScreen Chat')
mxGotoXY(54,25)
mxColour(2,0)
mxPrint('Ctrl-Q to quit')
ENDIF


IF chattype=6
chatsix()
ENDIF


mxGetStrInfo(10,realtime)
mxSetPageFlag(0)
mxGetStrInfo(10,time123)
mxColour(7,0)


IF(lastuser=0)
mxGotoXY(xpos1,ypos1)
ELSE
mxGotoXY(xpos2,ypos2)
ENDIF

LOOP


/*

-> This is the mxNoWaitHotKey() system...

REPEAT
key:=mxNoWaitHotKey()
IF(lost_carrier=1) THEN RETURN
mxGetStrInfo(10,timestr)
IF(StrCmp(timestr,time123,ALL)=FALSE)
IF(lost_carrier=1) THEN RETURN
chattype1()
mxGetStrInfo(10,time123)
ENDIF
UNTIL key>0

*/

-> This is the normal mxHotKey() mode...

key:=mxHotKey()

IF(lost_carrier=1) THEN RETURN



IF(wherefrom=0)


SELECT key

IF lastuser=1
mxGotoXY(xpos1,ypos1)
ENDIF

lastuser:=0

CASE 23
IF write=4
write:=0
ELSE
write:=write+1
ENDIF
chattype1()
JUMP lkeypos

CASE 10
JUMP lkeypos

CASE 9
JUMP lkeypos

CASE 3
IF chattype=6
chattype:=1
ELSE
chattype:=chattype+1
ENDIF
JUMP newchattype

CASE 14
IF cleartype=0
FOR n:=2 TO 12
mxGotoXY(1,n)
mxPrint('\e[K')
ENDFOR
xpos1:=1
ypos1:=2
FOR n:=14 TO 24
mxGotoXY(1,n)
mxPrint('\e[K')
ENDFOR
xpos2:=1
ypos2:=14
chattype1()
spaceflag:=1
JUMP lkeypos
ENDIF
IF cleartype=1
mxGotoXY(1,14)
FOR t:=1 TO 11
mxPrint('\e[1M')
ENDFOR
mxGotoXY(1,2)
FOR t:=1 TO 11
mxPrint('\e[1M')
ENDFOR
mxGotoXY(1,2)
FOR t:=1 TO 11
mxPrint('\e[1L')
ENDFOR
mxGotoXY(1,14)
FOR t:=1 TO 11
mxPrint('\e[1L')
ENDFOR
xpos1:=1
ypos1:=2
xpos2:=1
ypos2:=14
chattype1()
StrCopy(word,'',ALL)
StrCopy(wordtwo,'',ALL)
spaceflag:=1
JUMP lkeypos
ENDIF

CASE 127
IF cleartype=0
FOR n:=2 TO 12
mxGotoXY(1,n)
mxPrint('\e[K')
ENDFOR
xpos1:=1
ypos1:=2
chattype1()
JUMP lkeypos
ENDIF
IF cleartype=1
mxGotoXY(1,2)
FOR t:=1 TO 11
mxPrint('\e[1M')
ENDFOR
mxGotoXY(1,2)
FOR t:=1 TO 11
mxPrint('\e[1L')
ENDFOR
xpos1:=1
ypos1:=2
chattype1()
StrCopy(word,'',ALL)
spaceflag:=1
JUMP lkeypos
ENDIF


CASE 12
IF cleartype=0
FOR n:=2 TO 12
mxGotoXY(1,n)
mxPrint('\e[K')
ENDFOR
xpos1:=1
ypos1:=2
chattype1()
JUMP lkeypos
ENDIF
IF cleartype=1
mxGotoXY(1,2)
FOR t:=1 TO 11
mxPrint('\e[1M')
ENDFOR
mxGotoXY(1,2)
FOR t:=1 TO 11
mxPrint('\e[1L')
ENDFOR
xpos1:=1
ypos1:=2
chattype1()
StrCopy(word,'',ALL)
spaceflag:=1
JUMP lkeypos
ENDIF

CASE 26
mxLogOff()
IF(lost_carrier=1) THEN RETURN

CASE 18
mxMenuFunct(23,100,rawulpath)
spaceflag:=1
JUMP begin

CASE 8
IF xpos1>1
mxCharbbs(8)
xpos1:=xpos1-1
IF bump=0
bump:=1
ELSE
bump:=0
ENDIF
IF(StrLen(word)=1)
StrCopy(word,'',ALL)
spaceflag:=1
ELSE
length:=(StrLen(word)-1)
StrCopy(word,word,length)
ENDIF
JUMP lkeypos
ENDIF


CASE 5
IF ypos1>2
ypos1:=ypos1-1
mxPrint('\e[A')
spaceflag:=1
ENDIF

CASE 24
IF ypos1>11
JUMP lkeypos
ELSE
ypos1:=ypos1+1
mxPrint('\e[B')
spaceflag:=1
JUMP lkeypos
ENDIF


CASE 4
IF xpos1=78
JUMP lkeypos
ELSE
mxPrint('\e[C')
xpos1:=xpos1+1
space:=xpos1
StrCopy(word,'',ALL)
spaceflag:=1
JUMP lkeypos
ENDIF

CASE 19
IF xpos1>1
xpos1:=xpos1-1
mxPrint('\e[D')
ENDIF


CASE 20
timeleft:=mxGetIntInfo(7)
freeze:=1

IF chattype=0
mxGotoXY(67,13)
mxColour(3,0)
mxPrint('fRoZeN   ')
ENDIF

IF chattype=1
mxGotoXY(68,13)
mxColour(6,0)
mxPrint('fRoZeN ')
ENDIF

IF chattype=2
mxGotoXY(21,25)
mxColour(7,4)
mxPrint('fRoZeN  ')
ENDIF

IF chattype=3
mxGotoXY(21,13)
mxColour(7,4)
mxPrint('fRoZeN  ')
ENDIF

mxGotoXY(xpos1,ypos1)
mxColour(7,0)
JUMP lkeypos

CASE 21
freeze:=0
chattype1()
JUMP lkeypos

CASE 1
FOR n:=14 TO 24
mxGotoXY(1,n)
mxPrint('\e[K')
ENDFOR
xpos2:=1
ypos2:=14
chattype1()
mxGotoXY(1,15)
mxPrintFile('DOORS:mAGNUMcHAT/Temp.ans')

rt.setattrs([RT_TITLE, 'Select Files To Send...', RT_PATH, 'SYS:', NIL, NIL])

rt.req(RTREQ_MULTI, [RT_OKGAD, 'Send', RT_FULLNAME, TRUE, NIL])


  WHILE (s:=rt.get(RT_MULTINEXT))
  mxMenuFunct(24,0,s)
  ENDWHILE

spaceflag:=1

JUMP begin

CASE 17
JUMP end


CASE 13
ypos1:=ypos1+1
IF ypos1=13
ypos1:=2
ENDIF
spaceflag:=1
mxGotoXY(1,ypos1)
mxPrint('\e[K')
xpos1:=1
StrCopy(word,'',ALL)
JUMP lkeypos

CASE 32
space:=xpos1
xpos1:=xpos1+1
StrCopy(word,'',ALL)
mxCharbbs(255)
spaceflag:=1

IF xpos1>78 AND ypos1=12
xpos1:=1
ypos1:=2
mxGotoXY(xpos1,ypos1)
mxPrint('\e[K')
ENDIF

IF xpos1>78
xpos1:=1
ypos1:=ypos1+1
mxGotoXY(xpos1,ypos1)
mxPrint('\e[K')
ENDIF

DEFAULT

SELECT write
CASE 1
voweled()
CASE 2
elitemode()
CASE 3
bumpy()
CASE 4
spacetag()
ENDSELECT

StringF(chrt,'\c',key)
StrAdd(word,chrt,ALL)

StrCopy(macroword,word,ALL)
UpperStr(macroword)

IF freeze=1
timenow:=mxGetIntInfo(7)
IF timenow<timeleft
mxAltertime(1)
ENDIF
ENDIF

/*
FOR i:=1 TO 4
IF(StrCmp(macroword,strung[i],ALL)=TRUE)
autolen:=StrLen(word)
xpos1:=xpos1-autolen
mxGotoXY(xpos1,ypos1)
StrCopy(auto,'by the way',ALL)
autolen:=StrLen(auto)
length:=autolen+xpos1+1
IF xpos1<2
mxPrint(auto)
xpos1:=xpos1+autolen+1
mxGotoXY(xpos1,ypos1)
JUMP lkeypos
ENDIF
IF length>78
mxGotoXY(xpos1,ypos1)
FOR t:=xpos1 TO 79
mxCharbbs(255)
ENDFOR
ypos1:=ypos1+1
xpos1:=1
mxGotoXY(xpos1,ypos1)
mxPrint(auto)
mxGotoXY(autolen+1,ypos1)
key:=0
xpos1:=autolen
ELSE
mxCharbbs(255)
mxPrint(auto)
xpos1:=xpos1+autolen+1
StrCopy(word,'',ALL)
mxGotoXY(xpos1,ypos1)
JUMP lkeypos
ENDIF
ENDIF
ENDFOR
*/

/*
FOR i:=1 TO 4 STEP 2
IF(StrCmp(macroword,(confreadauto(i)),ALL)=TRUE)
autolen:=StrLen(word)
xpos1:=xpos1-autolen
mxGotoXY(xpos1,ypos1)
StrCopy(auto,'by the way',ALL)
autolen:=StrLen(auto)
length:=autolen+xpos1+1
IF xpos1<2
mxPrint(auto)
xpos1:=xpos1+autolen+1
mxGotoXY(xpos1,ypos1)
JUMP lkeypos
ENDIF
IF length>78
mxGotoXY(xpos1,ypos1)
FOR t:=xpos1 TO 79
mxCharbbs(255)
ENDFOR
ypos1:=ypos1+1
xpos1:=1
mxGotoXY(xpos1,ypos1)
mxPrint(auto)
mxGotoXY(autolen+1,ypos1)
key:=0
xpos1:=autolen
ELSE
mxCharbbs(255)
mxPrint(auto)
xpos1:=xpos1+autolen+1
StrCopy(word,'',ALL)
mxGotoXY(xpos1,ypos1)
JUMP lkeypos
ENDIF
ENDIF
*/

IF(lost_carrier=1) THEN RETURN

IF ypos1=12 AND xpos1=79
IF key=32
xpos1:=1
ypos1:=2
mxGotoXY(1,2)
mxPrint('\e[K')
JUMP lkeypos
ENDIF
length:=StrLen(word)
IF length>60
xpos1:=1
ypos1:=2
mxGotoXY(xpos1,ypos1)
mxPrint('\e[K')
JUMP lkeypos
ENDIF
ypos1:=2
mxGotoXY(space,12)
FOR n:=space TO 79
xpos1:=xpos1+1
mxCharbbs(255)
ENDFOR
ypos1:=2
mxGotoXY(1,ypos1)
mxPrint('\e[K')
mxPrint(word)
xpos1:=79-space
mxCharbbs(8)
chattype1()
ENDIF


IF xpos1=79
length:=StrLen(word)
IF length>60
xpos1:=1
ypos1:=ypos1+1
mxGotoXY(xpos1,ypos1)
mxPrint('\e[K')
-> chattype1()
JUMP lkeypos
ENDIF
mxGotoXY(space,ypos1)
FOR n:=space TO 79
mxCharbbs(255)
ENDFOR
ypos1:=ypos1+1
mxGotoXY(1,ypos1)
mxPrint('\e[K')
mxPrint(word)
xpos1:=79-space
mxCharbbs(8)
chattype1()
ENDIF

mxCharbbs(key)
xpos1:=xpos1+1
lkeypos:

ENDSELECT

ELSE

-> **************************** REMOTE USER ************************************


SELECT key

IF lastuser=0
mxGotoXY(xpos2,ypos2)
ENDIF

lastuser:=1

CASE 14
IF cleartype=0
FOR n:=2 TO 12
mxGotoXY(1,n)
mxPrint('\e[K')
ENDFOR
xpos1:=1
ypos1:=2
FOR n:=14 TO 24
mxGotoXY(1,n)
mxPrint('\e[K')
ENDFOR
xpos2:=1
ypos2:=14
mxGotoXY(xpos1,ypos1)
JUMP lkeypos
ENDIF
IF cleartype=1
mxGotoXY(1,14)
FOR t:=1 TO 11
mxPrint('\e[1M')
ENDFOR
mxGotoXY(1,2)
FOR t:=1 TO 11
mxPrint('\e[1M')
ENDFOR
mxGotoXY(1,2)
FOR t:=1 TO 11
mxPrint('\e[1L')
ENDFOR
mxGotoXY(1,14)
FOR t:=1 TO 11
mxPrint('\e[1L')
ENDFOR
xpos1:=1
ypos1:=2
xpos2:=1
ypos2:=14
chattype1()
JUMP lkeypos
ENDIF

CASE 127
IF cleartype=0
FOR n:=14 TO 24
mxGotoXY(1,n)
mxPrint('\e[K')
ENDFOR
mxGotoXY(1,14)
xpos2:=1
ypos2:=14
chattype1()
JUMP lkeypos2
ENDIF

IF cleartype=1
mxGotoXY(1,14)
FOR t:=1 TO 11
mxPrint('\e[1M')
ENDFOR
mxGotoXY(1,14)
FOR t:=1 TO 11
mxPrint('\e[1L')
ENDFOR
xpos2:=1
ypos2:=14
chattype1()
JUMP lkeypos2
ENDIF

CASE 12
IF cleartype=0
FOR n:=2 TO 12
mxGotoXY(1,n)
mxPrint('\e[K')
ENDFOR
xpos1:=1
ypos1:=2
FOR n:=14 TO 24
mxGotoXY(1,n)
mxPrint('\e[K')
ENDFOR
xpos2:=1
ypos2:=14
chattype1()
JUMP lkeypos2
ENDIF
IF cleartype=1
mxGotoXY(1,14)
FOR t:=1 TO 11
mxPrint('\e[1M')
ENDFOR
mxGotoXY(1,14)
FOR t:=1 TO 11
mxPrint('\e[1L')
ENDFOR
xpos2:=1
ypos2:=14
chattype1()
JUMP lkeypos2
ENDIF

CASE 8
IF xpos2>1
mxCharbbs(8)
xpos2:=xpos2-1
IF(StrLen(wordtwo)=1)
StrCopy(wordtwo,'',ALL)
ELSE
length:=(StrLen(wordtwo)-1)
StrCopy(wordtwo,wordtwo,length)
ENDIF
JUMP lkeypos2
ENDIF

CASE 17
JUMP end

CASE 13
ypos2:=ypos2+1
IF ypos2=25
ypos2:=14
ENDIF
mxGotoXY(1,ypos2)
mxPrint('\e[K')
xpos2:=1
JUMP lkeypos2


CASE 32
space2:=xpos2
xpos2:=xpos2+1
StrCopy(wordtwo,'',ALL)
mxCharbbs(255)

IF xpos2>78 AND ypos2=24
xpos2:=1
ypos2:=14
mxGotoXY(xpos2,ypos2)
mxPrint('\e[K')
ENDIF

IF xpos2>78
xpos2:=1
ypos2:=ypos2+1
mxGotoXY(xpos2,ypos2)
mxPrint('\e[K')
ENDIF

DEFAULT

IF freeze=1
timenow:=mxGetIntInfo(7)
IF timenow<timeleft
mxAltertime(1)
ENDIF
ENDIF

IF key=27
esc:=1
JUMP lkeypos2
ENDIF

IF(key=91) AND (esc=1)
sqbrack:=1
esc:=0
JUMP lkeypos2
ENDIF

IF(key=65) AND (sqbrack=1)
sqbrack:=0
IF ypos2>14
ypos2:=ypos2-1
mxPrint('\e[A')
JUMP lkeypos2
ELSE
JUMP lkeypos2
ENDIF
ENDIF

IF(key=66) AND (sqbrack=1)
sqbrack:=0
IF ypos2>23
JUMP lkeypos2
ELSE
ypos2:=ypos2+1
mxPrint('\e[B')
JUMP lkeypos2
ENDIF
ENDIF

IF(key=67) AND (sqbrack=1)
sqbrack:=0
IF xpos2=78
JUMP lkeypos2
ELSE
mxPrint('\e[C')
StrCopy(wordtwo,'',ALL)
space2:=xpos2
xpos2:=xpos2+1
JUMP lkeypos2
ENDIF
ENDIF

IF(key=68) AND (sqbrack=1)
sqbrack:=0
IF xpos2>1
xpos2:=xpos2-1
mxPrint('\e[D')
JUMP lkeypos2
ELSE
JUMP lkeypos2
ENDIF
ENDIF


StringF(chrt2,'\c',key)
StrAdd(wordtwo,chrt2,ALL)

/*
IF(StrCmp(wordtwo,'BTW',ALL)=TRUE)
autolen:=StrLen(wordtwo)
xpos2:=xpos2-autolen
mxGotoXY(xpos2,ypos2)
StrCopy(auto,'by the way',ALL)
autolen:=StrLen(auto)
length:=autolen+xpos2+1
IF xpos2<2
mxPrint(auto)
xpos2:=xpos2+autolen+1
mxGotoXY(xpos2,ypos2)
JUMP lkeypos2
ENDIF
IF length>78
mxGotoXY(xpos2,ypos2)
FOR t:=xpos2 TO 79
mxCharbbs(255)
ENDFOR
ypos2:=ypos2+1
xpos2:=1
mxGotoXY(xpos2,ypos2)
mxPrint(auto)
mxGotoXY(autolen+1,ypos2)
key:=0
xpos2:=autolen
ELSE
mxPrint(' ')
mxPrint(auto)
xpos2:=xpos2+autolen+1
StrCopy(wordtwo,'',ALL)
mxGotoXY(xpos2,ypos2)
JUMP lkeypos2
ENDIF
ENDIF
*/


IF ypos2=24 AND xpos2=79
length2:=StrLen(wordtwo)
IF length2>60
xpos2:=1
ypos2:=14
mxGotoXY(xpos2,ypos2)
mxPrint('\e[K')
chattype1()
JUMP lkeypos2
ENDIF
ypos2:=14
mxGotoXY(space2,24)
FOR n:=space2 TO 79
xpos2:=xpos2+1
mxCharbbs(255)
ENDFOR
ypos2:=14
mxGotoXY(1,ypos2)
mxPrint('\e[K')
mxPrint(wordtwo)
xpos2:=79-space2
chattype1()
ENDIF

IF xpos2=79
length2:=StrLen(wordtwo)
IF length2>60
xpos2:=1
ypos2:=ypos2+1
mxGotoXY(xpos2,ypos2)
mxPrint('\e[K')
-> chattype1()
JUMP lkeypos2
ENDIF
mxGotoXY(space2,ypos2)
FOR n:=space2 TO 79
mxCharbbs(255)
ENDFOR
ypos2:=ypos2+1
mxGotoXY(1,ypos2)
mxPrint('\e[K')
mxPrint(wordtwo)
xpos2:=79-space2
chattype1()
ENDIF

xpos2:=xpos2+1

mxCharbbs(key)

lkeypos2:

ENDSELECT

ENDIF

ENDLOOP

end:
Execute('C:Delete ENV:Chatting QUIET',0,0)
ENDPROC

-> *************** PROCS **********

PROC elitemode()    -> Procedure for el!7e mode
SELECT key
CASE 97
key:=132

CASE 98
key:=225

CASE 99
key:=128

CASE 101
key:=228

CASE 102
key:=244

CASE 105
key:=33

CASE 106
key:=245

CASE 110
key:=239

CASE 111
key:=233

CASE 114
key:=226

CASE 115
key:=53

CASE 116
key:=55

CASE 117
key:=154

CASE 121
key:=157

CASE 63
key:=168
ENDSELECT
ENDPROC


PROC voweled()

SELECT key
CASE 97
key:=65

CASE 101
key:=69

CASE 105
key:=73

CASE 111
key:=79

CASE 117
key:=85
ENDSELECT
ENDPROC

PROC bumpy()

IF bump=0
SELECT key
CASE 97
key:=65
CASE 98
key:=66
CASE 99
key:=67
CASE 100
key:=68
CASE 101
key:=69
CASE 102
key:=70
CASE 103
key:=71
CASE 104
key:=72
CASE 105
key:=73
CASE 106
key:=74
CASE 107
key:=75
CASE 108
key:=76
CASE 109
key:=77
CASE 110
key:=78
CASE 111
key:=79
CASE 112
key:=80
CASE 113
key:=81
CASE 114
key:=82
CASE 115
key:=83
CASE 116
key:=84
CASE 117
key:=85
CASE 118
key:=86
CASE 119
key:=87
CASE 120
key:=88
CASE 121
key:=89
CASE 122
key:=90
ENDSELECT
bump:=1
ELSE
bump:=0
ENDIF
ENDPROC

PROC spacetag()
IF spaceflag=1

IF(key>64) AND (key<91)
key:=key+32
ENDIF

ELSE

IF(key>96) AND (key<123)
key:=key-32
ENDIF



ENDIF
spaceflag:=0
ENDPROC

PROC chattype1() -> Sort out auto-insert updating for Chat Type 0 & 1

SELECT chattype
CASE 1
IF freeze=0
mxGotoXY(50,13)
mxColour(3,0)
mxPrint(' Time Remaining: %k mins')
ENDIF
IF wherefrom=0
mxColour(7,0)
mxGotoXY(xpos1,ypos1)
ELSE
mxColour(7,0)
mxGotoXY(xpos2,ypos2)
ENDIF

CASE 2
IF freeze=0
mxGotoXY(52,13)
mxColour(6,0)
mxPrint('Time Remaining: %k mins')
ENDIF

CASE 3
IF freeze=0
mxGotoXY(21,25)
mxColour(7,4)
mxPrint('%k')
mxColour(6,4)
mxPrint(' mins')
ENDIF
mxGotoXY(7,25)
mxColour(7,4)
mxPrint('%d')

CASE 4
IF freeze=0
mxGotoXY(21,13)
mxColour(7,4)
mxPrint('%k')
mxColour(1,4)
mxPrint(' mins')
ENDIF
mxGotoXY(7,13)
mxColour(7,4)
mxPrint('%d')

ENDSELECT
IF wherefrom=0
mxColour(7,0)
mxGotoXY(xpos1,ypos1)
ELSE
mxColour(7,0)
mxGotoXY(xpos2,ypos2)
ENDIF
ENDPROC

PROC chatsix()
mxGotoXY(1,1)
mxColour(6,0)
mxPrint('-')
mxColour(3,0)
mxPrint(' tHE sYSOP: ')
mxColour(4,0)
mxPrint('>>>->>  ')
mxColour(6,0)
mxPrint('>>>->>  ')
mxColour(4,0)
mxPrint('>>>->>  ')
mxColour(6,0)
mxPrint('>>>->>  ')
mxColour(4,0)
mxPrint('>>>->>  ')
mxColour(6,0)
mxPrint('>>>->>  ')
mxColour(4,0)
mxPrint('>>>->>  ')
mxColour(6,0)
mxPrint('>>>->>  ')
mxColour(4,0)
mxPrint('>>')
mxGotoXY(14,1)
mxColour(3,0)
mxPrintLine(0)
mxCharbbs(255)
mxGotoXY(1,13)
mxColour(3,0)
mxPrint(' wITTERING tO ')
mxColour(6,0)
mxPrint('>>>->>  ')
mxColour(4,0)
mxPrint('>>>->>  ')
mxColour(6,0)
mxPrint('>>>->>  ')
mxColour(4,0)
mxPrint('>>>->>  ')
mxColour(6,0)
mxPrint('>>>->>  ')
mxColour(4,0)
mxPrint('>>>->>  ')
mxColour(6,0)
mxPrint('>>>->>  ')
mxColour(4,0)
mxPrint('>>>->>  ')
mxColour(6,0)
mxPrint('>')
mxGotoXY(15,13)
mxColour(3,0)
mxPrint(username)
mxCharbbs(255)
mxGotoXY(1,25)
mxColour(4,0)
mxPrint('>>>->>  ')
mxColour(6,0)
mxPrint('>>>->>')
mxColour(2,0)
mxPrint(' mAGNUM cHAT v1.15 bY sTONECOLD ')
mxColour(4,0)
mxPrint('>>>->>  ')
mxColour(6,0)
mxPrint('>>>->>  ')
mxColour(4,0)
mxPrint('>>>->>  ')
mxColour(6,0)
mxPrint('>>>->>  ')
mxColour(4,0)
mxPrint('>')

ENDPROC

-> Alter User Time  For the freeze time option!
PROC mxAltertime(timechange)
  p1.command:=21
  p1.data:=timechange
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Centre Text
PROC mxCentre(y,text)
DEF str[80]:STRING,len
len:=StrLen(text)
len:=(80-len)/2
StringF(str,'\e[\d;\dH\s',y,len,text)
mxPrint(str)
ENDPROC

-> Print a string
PROC mxPrint(str:PTR TO CHAR)
  p1.command:=1
  p1.data:=0
  doCopy(p1.string,str)
  putWaitMsg(p1)
ENDPROC

-> Print Text to local screen only
PROC mxPrintLocal(str:PTR TO CHAR)
  p1.command:=2
  p1.data:=0
  doCopy(p1.string,str)
  putWaitMsg(p1)
ENDPROC

-> Print character to serial port only
PROC mxCharSer(char:LONG)
  p1.command:=3
  p1.data:=char
  putWaitMsg(p1)
ENDPROC

-> Print Character to screen only
PROC mxCharScr(char:LONG)
  p1.command:=4
  p1.data:=char
  putWaitMsg(p1)
ENDPROC

-> Print Character to BBS
PROC mxCharbbs(char:LONG)
  p1.command:=5
  p1.data:=char
  putWaitMsg(p1)
ENDPROC

-> Input a string. NOTE: buffer *MUST* point to an E-String!!!!
PROC mxInput(maxlen:PTR TO INT,buffer)
  DEF rt
  p1.command:=6
  p1.data:=maxlen
  p1.string[]:=0
  rt:=putWaitMsg(p1)
  StrCopy(buffer,p1.string)
ENDPROC

-> Reads a key
-> Returns ASCII value
-> IF(wherefrom=0) its from the local terminal
-> IF(wherefrom=1) its from the remote terminal
PROC mxHotKey()
  DEF rt
  p1.command:=8
  p1.data:=0
  p1.string[]:=0
  rt:=putWaitMsg(p1)
  wherefrom:=Char(p1.string-1)
ENDPROC Char(p1.string)

-> Reads a key but returns to program
PROC mxNoWaitHotKey()
  DEF rt
  p1.command:=201
  p1.data:=0
  p1.string[]:=0
  rt:=putWaitMsg(p1)
  wherefrom:=Char(p1.string-1)
ENDPROC Char(p1.string)

-> Twit the user
PROC mxTwit()
  p1.command:=9
  putWaitMsg(p1)
ENDPROC

-> Print a text file
PROC mxPrintFile(filename)
  p1.command:=10
  p1.data:=0
  doCopy(p1.string,filename)
  putWaitMsg(p1)
ENDPROC

-> Check file is online
-> 1 if yes, -1 if no
PROC mxCheckFile(filename)
  DEF rt
  p1.command:=11
  p1.data:=0
  doCopy(p1.string,filename)
  rt:=putWaitMsg(p1)
ENDPROC p1.data

-> Get user information values
PROC mxGetIntInfo(type:PTR TO INT)
  p1.command:=13
  p1.data:=type
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC p1.data

-> Get user/BBS strings
-> buffer *MUST* point to an E-String
PROC mxGetStrInfo(type,buffer)
  p1.command:=14
  p1.data:=type
  p1.string[]:=0
  putWaitMsg(p1)
  StrCopy(buffer,p1.string)
ENDPROC

-> Change String
PROC mxChangeStr(type,buffer)
  p1.command:=16
  p1.data:=type
  p1.string[]:=0
  putWaitMsg(p1)
  StrCopy(buffer,p1.string)
ENDPROC

-> Get random number
PROC mxRandom(maxnum:LONG)
  p1.command:=17
  p1.data:=maxnum
ENDPROC p1.data

-> Reset Carrier PARAGON ONLY!
PROC mxResetCarr()
  p1.command:=18
ENDPROC

-> Show Gfx  PARAGON ONLY!
PROC mxShowGfx(filename:PTR TO CHAR)
  StrCopy(filename,ALL)
  p1.command:=19
ENDPROC

-> ShutDown Door Port
PROC mxShutDown()
p1.command:=20
ENDPROC

-> Standard LogOff
PROC mxLogOff()
  p1.command:=101
  p1.data:=0
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Goto Menu
PROC mxGotoMenu(menu)
  p1.command:=102
  p1.data:=menu
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Chat Call
PROC mxChatCall(plays)
  p1.command:=103
  p1.data:=plays
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Prompt User ANSI Flag
PROC mxSetAnsiFlag()
  p1.command:=104
  p1.data:=0
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Prompt CLS Flag
PROC mxSetCls()
  p1.command:=105
  p1.data:=0
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Prompt Pause Flag
PROC mxSetPause()
  p1.command:=106
  p1.data:=0
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Prompt FSE Flag
PROC mxSetFSE()
  p1.command:=107
  p1.data:=0
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Change # Screen Lines
PROC mxSetLines()
  p1.command:=108
  p1.data:=0
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Change Location
PROC mxSetLoc()
  p1.command:=109
  p1.data:=0
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Change Phone Number
PROC mxSetFone()
  p1.command:=110
  p1.data:=0
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Change Computer Desc
PROC mxSetCompDesc()
  p1.command:=111
  p1.data:=0
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Change User Password
PROC mxSetPass()
  p1.command:=112
  p1.data:=0
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

PROC mxPrintFileNP(filename)
  p1.command:=114
  p1.data:=0
  doCopy(p1.string,filename)
  putWaitMsg(p1)
ENDPROC

-> Print MAX Line   MAXsBBS Only
PROC mxPrintLine(line)
  p1.command:=115
  p1.data:=line
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Leave a message
PROC mxLeaveMessage(section,to)
  p1.command:=116
  doCopy(p1.data,section)
  doCopy(p1.string,to)
  putWaitMsg(p1)
ENDPROC

-> Read Messages
PROC mxReadMessage(section)
  p1.command:=117
  doCopy(p1.data,section)
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Read Messages w/o reply
PROC mxMessageNoReply(section)
  p1.command:=135
  doCopy(p1.data,section)
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> List/Search Users
PROC mxListUsers()
  p1.command:=118
  p1.data:=0
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Upload File
PROC mxUpload(section,path)
  p1.command:=123
  p1.data:=section
  doCopy(p1.string,path)
  putWaitMsg(p1)
ENDPROC

-> Download File
PROC mxDownload(section,filename)
  p1.command:=124
  p1.data:=section
  doCopy(p1.string,filename)
  putWaitMsg(p1)
ENDPROC

-> CLI
PROC mxCLI()
  p1.command:=128
  putWaitMsg(p1)
ENDPROC

-> Set Transfer Protocol
PROC mxProtocol()
  p1.command:=133
  p1.data:=0
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Set Junk Mail
PROC mxJunkMail()
  p1.command:=136
  p1.data:=0
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

-> Who's Online
PROC mxWho()
  p1.command:=138
  p1.data:=0
  p1.string[]:=0
  putWaitMsg(p1)
ENDPROC

PROC mxBeep()
DisplayBeep(NIL)
ENDPROC
  
-> Do a maxs bbs menu function
PROC mxMenuFunct(menufunc,extra,string)
  p1.command:=menufunc+100
  p1.data:=extra
  doCopy(p1.string,string)
  putWaitMsg(p1)
ENDPROC

-> Change a user int value
-> MAXs BBS only!
PROC mxChangeUserInt(uint,value)
  p1.command:=200
  p1.data:=uint
  p1.string[]:=value
  putWaitMsg(p1)
ENDPROC

-> Set page flag MAXsBBS ONLY!
PROC mxSetPageFlag(state)
  p1.command:=202
  p1.data:=state
  putWaitMsg(p1)
ENDPROC

-> Clear Screen
PROC mxCls()
  DEF str[1]:STRING
  StringF(str,'\c',12)
  mxPrint(str)
ENDPROC

-> Goto XY
PROC mxGotoXY(x,y)
  DEF goat[10]:STRING
  StringF(goat,'\e[\d;\dH',y,x)
  mxPrint(goat)
ENDPROC

-> Text Colour
PROC mxColour(f,b)
  DEF goat[10]:STRING
  StringF(goat,'\e[3\d;4\dm',f,b)
  mxPrint(goat)
ENDPROC

-> Set Text Style
PROC mxStyle(style)
  DEF goat[10]:STRING
  StringF(goat,'\e[\dm',style)
  mxPrint(goat)
ENDPROC

-> Move x Lines Up
PROC mxCursUp(x)
  DEF goat[10]:STRING
  StringF(goat,'\e[\dA',x)
  mxPrint(goat)
ENDPROC

-> Move x lines down
PROC mxCursDown(x)
  DEF goat[10]:STRING
  StringF(goat,'\e[\dB',x)
  mxPrint(goat)
ENDPROC

-> Move x Characters Left
PROC mxCharLeft(x)
  DEF goat[10]:STRING
  StringF(goat,'\e[\dC',x)
  mxPrint(goat)
ENDPROC

-> Move x Characters Right
PROC mxCharRight(x)
  DEF goat[10]:STRING
  StringF(goat,'\e[\dD',x)
  mxPrint(goat)
ENDPROC

-> Move x Lines Down and move to left
PROC mxCursDownLeft(x)
  DEF goat[10]:STRING
  StringF(goat,'\e[\dE',x)
  mxPrint(goat)
ENDPROC

-> Move x Lines Up and move to char 1
PROC mxCursUpChar(x)
  DEF goat[10]:STRING
  StringF(goat,'\e[\dF',x)
  mxPrint(goat)
ENDPROC

-> Move Line x Lines Up
PROC mxLineUp(x)
  DEF goat[10]:STRING
  StringF(goat,'\e[\dS',x)
  mxPrint(goat)
ENDPROC

-> Move Line x Lines Down
PROC mxLineDown(x)
  DEF goat[10]:STRING
  StringF(goat,'\e[\dT',x)
  mxPrint(goat)
ENDPROC

-> Wait for reply msg
-> returns ptr to string

PROC putWaitMsg(msg:PTR TO doormsg)
  DEF rmsg
  PutMsg(cport,msg)
waitloop:
  WaitPort(mport)
  IF(rmsg:=GetMsg(mport))=0 THEN JUMP waitloop
  lost_carrier:=p1.carrier
ENDPROC rmsg  

PROC doCopy(dest:PTR TO CHAR,src:PTR TO CHAR)
  DEF c
  FOR c:=0 TO StrLen(src)
    PutChar(dest+c,Char(src+c))
  ENDFOR
ENDPROC

PROC main()


  -> Grab the node number
   StringF(msgportname,'DoorControl\c',Char(arg))
   StringF(msgportname2,'DoorReply\c',Char(arg))


  -> Make msg port & msg:
  IF(mport:=createPort(msgportname2,0))

    ourtask:=FindTask(NIL)

    p1.door_msg.ln.type:=NT_MESSAGE
    p1.door_msg.replyport:=mport
    p1.door_msg.length:=SIZEOF doormsg

    -> Find  M A X's BBS door control port prt:

    Forbid()
    cport:=FindPort(msgportname)
    Permit()
    IF(cport>0)

      -> Startup code complete!
      theDoor()

      -> Closedown code
      p1.command:=20
      p1.data:=0
      putWaitMsg(p1)
    ELSE
      WriteF('This is a door for Paragon Door Systems!\n')
    ENDIF

    -> Clean up and return
    deletePort(mport)           -> Free port
  ENDIF
 
ENDPROC


PROC confreadstr(line)
DEF str[100]:STRING,confighandle,x,len

IF(confighandle:=Open('DOORS:MagnumChat/MagnumChat.cfg',MODE_OLDFILE))=NIL
mxCls()
mxCentre(6,'Can\at Open Magnum Chat Configuration File')
mxHotKey()
      p1.command:=20
      p1.data:=0
      putWaitMsg(p1)
ELSE
FOR x:=1 TO line
Fgets(confighandle,str,ALL)
ENDFOR

len:=StrLen(str)
StrCopy(str,str,len-1)
ENDIF

Close(confighandle)

ENDPROC str


PROC confreadvalue(line)
DEF str[100]:STRING, value, x, confighandle

IF (confighandle:=Open('DOORS:MagnumChat/MagnumChat.cfg',MODE_OLDFILE))=NIL
mxCls()
mxCentre(6,'Can\at Open Magnum Chat Configuration File')
mxHotKey()
      p1.command:=20
      p1.data:=0
      putWaitMsg(p1)
ELSE
FOR x:=1 TO line
Fgets(confighandle,str,100)
value:=Val(str,0)
ENDFOR
ENDIF
Close(confighandle)

ENDPROC value

PROC confreadauto(line)
DEF str[100]:STRING,confighandle,x,len

IF(confighandle:=Open('DOORS:MagnumChat/macros.cfg',MODE_OLDFILE))=NIL
mxCls()
mxCentre(6,'Can\at Open Magnum Chat Autoinsert.cfg File')
mxHotKey()
      p1.command:=20
      p1.data:=0
      putWaitMsg(p1)
ELSE
FOR x:=1 TO line
Fgets(confighandle,str,ALL)
ENDFOR

len:=StrLen(str)
StrCopy(str,str,len-1)
ENDIF

Close(confighandle)

ENDPROC str

