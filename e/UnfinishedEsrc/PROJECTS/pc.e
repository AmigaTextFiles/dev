->By Ian Chapman
->Spoof PC Emulator - Don't ask why! :)
->You need the IBM5 Font in your Fonts: dir
->You need newsgothic Font in your Fonts: dir
->Expects a SCREEN SIZE of at least 640x480

MODULE  'reqtools',
        'libraries/reqtools',
        'dos/dos',
        'intuition/screens',
        'diskfont',
        'libraries/diskfont',
        'graphics/text'
->        'tools/easysound'

DEF req:PTR TO rtscreenmoderequester,
    ret,
    font,
    fontatts,
    scr:PTR TO screen
->    beep:esound,
->    tick:esound

PROC main()

->loadraw('beep.raw',beep)
->loadraw('tick.raw',tick)



IF (diskfontbase:=OpenLibrary('diskfont.library',39))<>NIL


    IF (reqtoolsbase:=OpenLibrary('reqtools.library',37))<>NIL

        req:=RtAllocRequestA(RT_SCREENMODEREQ,NIL)

        IF (ret:=RtScreenModeRequestA(req,'Select Screenmode',[RT_REQPOS,REQPOS_POINTER,NIL,NIL]))<>NIL

            IF (scr:=OpenScreenTagList(0,[SA_DEPTH,req.displaydepth,
                                          SA_DISPLAYID,req.displayid,
                                          SA_SHOWTITLE,NIL,
                                          SA_WIDTH,req.displaywidth,
                                          SA_HEIGHT,req.displayheight,
                                          0,0]))<>NIL

                SetRGB4(scr.viewport,0,$0,$0,$0)
                SetRGB4(scr.viewport,1,$0,$0,$0)
                SetRGB4(scr.viewport,2,$0,$0,$0)
                SetRGB4(scr.viewport,3,$FF,$FF,$FF)
                SetAPen(scr.rastport,3)
                ->Main Program code

                Move(scr.rastport,10,20)

                fontatts:=['Ibm5.font',8,0,0]:textattr
                font:=OpenDiskFont(fontatts)
                SetFont(scr.rastport,font)
                Text(scr.rastport,'AMIBIOS (c) 1996 PnP 3.2i',25)
                Delay(50)

                Move(scr.rastport,10,30)
                Text(scr.rastport,'American Megatrends Inc.,',25)
                Delay(30)

                Move(scr.rastport,10,40)
                Text(scr.rastport,'RELEASE 11/26/97',16)
                Delay(30)

                Move(scr.rastport,10,60)
                Text(scr.rastport,'Main Processor : PENTIUM-MMX',28)
                Move(scr.rastport,10,70)
                Text(scr.rastport,'Processor Clock: 166Mhz',23)
                Delay(50)

                Move(scr.rastport,10,90)
                Text(scr.rastport,'Checking NVRAM...',17)
                Delay(30)

                Move(scr.rastport,10,100)
                Text(scr.rastport,'  640KB OK',10)
               -> playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(5)

                Move(scr.rastport,10,100)
                Text(scr.rastport,' 1024KB OK',10)
               -> playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(5)

                Move(scr.rastport,10,100)
                Text(scr.rastport,' 2048KB OK',10)
               -> playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(5)

                Move(scr.rastport,10,100)
                Text(scr.rastport,' 3072KB OK',10)
               -> playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(5)

                Move(scr.rastport,10,100)
                Text(scr.rastport,' 4096KB OK',10)
               -> playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(5)

                Move(scr.rastport,10,100)
                Text(scr.rastport,' 5120KB OK',10)
               -> playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(5)

                Move(scr.rastport,10,100)
                Text(scr.rastport,' 6144KB OK',10)
               -> playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(5)

                Move(scr.rastport,10,100)
                Text(scr.rastport,' 7168KB OK',10)
              ->  playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(5)

                Move(scr.rastport,10,100)
                Text(scr.rastport,' 8192KB OK',10)
              ->  playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(5)

                Move(scr.rastport,10,100)
                Text(scr.rastport,' 9216KB OK',10)
              ->  playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(5)

                Move(scr.rastport,10,100)
                Text(scr.rastport,'10240KB OK',10)
              ->  playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(5)

                Move(scr.rastport,10,100)
                Text(scr.rastport,'11264KB OK',10)
              ->  playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(5)

                Move(scr.rastport,10,100)
                Text(scr.rastport,'12288KB OK',10)
              ->  playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(5)

                Move(scr.rastport,10,100)
                Text(scr.rastport,'13312KB OK',10)
              ->  playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(5)

                Move(scr.rastport,10,100)
                Text(scr.rastport,'14336KB OK',10)
              ->  playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(5)

                Move(scr.rastport,10,100)
                Text(scr.rastport,'15360KB OK',10)
              ->  playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(5)

                Move(scr.rastport,10,100)
                Text(scr.rastport,'16384KB OK',10)
              ->  playsound(tick,30000,[1,2,4,8]:CHAR)
                Delay(80)

                Move(scr.rastport,10,100)
                Text(scr.rastport,'WAIT...   ',10)
              ->  playsound(beep,20000,[1,2,4,8]:CHAR)
                Delay(100)
              ->  clearsound(beep)
              ->  clearsound(tick)

                Move(scr.rastport,10,110)
                Text(scr.rastport,'Press <DEL> to enter setup.',27)
                Delay(50)

                Move(scr.rastport,10,130)
                Text(scr.rastport,'Pri Master: ST44431A',20)
                Delay(80)

                Move(scr.rastport,10,140)
                Text(scr.rastport,'Pri Slave : HITACHI CDROM',25)
                Delay(30)

                Move(scr.rastport,10,160)
                Text(scr.rastport,'Starting MS-DOS...',18)
                Delay(200)

                prompt(10,200)

                cursor(20,40,200)

                Move(scr.rastport,40,200)
                Text(scr.rastport,'win',3)

                cursor(6,63,200)

                cursor(10,10,210)

                Move(scr.rastport,10,210)
                Text(scr.rastport,'This program requires Microsoft Windows.',40)

                cursor(10,330,210)

                prompt(10,240)

                cursor(20,40,240)

                Move(scr.rastport,40,240)
                Text(scr.rastport,'D:',2)

                cursor(6,53,240)

                Move(scr.rastport,10,250)
                Text(scr.rastport,'Invalid Drive Specification.',28)

                cursor(6,230,250)

                prompt(10,280)

                cursor(10,40,280)

                Move(scr.rastport,40,280)
                Text(scr.rastport,'ARGHHHHH!',9)

                cursor(5,110,280)

                Move(scr.rastport,10,290)
                Text(scr.rastport,'Bad Command',12)

                prompt(10,330)
                cursor(10,40,330)

                Move(scr.rastport,0,0)
                ClearScreen(scr.rastport)

                CloseFont(font)

                SetRGB4(scr.viewport,3,$FF,$E5,$b5)

                fontatts:=['NewsGothic.font',56,0,0]:textattr
                font:=OpenDiskFont(fontatts)

                SetFont(scr.rastport,font)

                Move(scr.rastport,140,150)
                Text(scr.rastport,'It is now safe',14)

                Move(scr.rastport,160,200)
                Text(scr.rastport,'to switch off',13)

                Move(scr.rastport,140,250)
                Text(scr.rastport,'your computer.',14)

                Delay(200)

                CloseFont(font)



                CloseScreen(scr)

            ELSE
                PrintF('Unable to open screen!\n')
            ENDIF

            RtFreeRequest(req)

        ELSE
            PrintF('Unable to allocate screenmode requester!\n')
        ENDIF

        CloseLibrary(reqtoolsbase)

    ELSE
        PrintF('Unable to open reqtools.library V37+\n')
    ENDIF

    CloseLibrary(diskfontbase)

ELSE
    PrintF('Unable to open diskfont.library V39+\n')
ENDIF

ENDPROC

PROC cursor(times,xpos,ypos)
DEF x

FOR x:=1 TO times
    Move(scr.rastport,xpos,ypos)
    Text(scr.rastport,'_',1)
    Delay(15)
    Move(scr.rastport,xpos,ypos)
    Text(scr.rastport,' ',1)
    Delay(15)
ENDFOR
ENDPROC

PROC prompt(xpos,ypos)
Move(scr.rastport,xpos,ypos)
Text(scr.rastport,'C:\\>',4)
ENDPROC

