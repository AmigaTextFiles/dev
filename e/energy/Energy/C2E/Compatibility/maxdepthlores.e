/*  maxdepthlores.e
 *
 * This software is provided as-is and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 *
 */

MODULE 	'exec/types',
	'intuition/intuition',
	'graphics/displayinfo',
	'graphics/modeid',
	'intuition/screens',
	'dos/dos'

PROC quit(whytext,failcode)
 PrintF('\s\n',whytext)
 CleanUp(failcode)
ENDPROC

PROC main()

DEF    modeid = LORES_KEY,
	displayhandle,
	dimensioninfo:dimensioninfo,

    maxdepth:PTR TO INT, maxcolors:PTR TO INT,
    soerror = NIL,colornum,
    screen:PTR TO screen

    IF displayhandle:=FindDisplayInfo(modeid) = NIL THEN;
        quit('modeID not found in display database',RETURN_FAIL)

    IF GetDisplayInfoData(displayhandle,dimensioninfo,
    SIZEOF dimensioninfo,DTAG_DIMS,NIL) = NIL THEN;
        quit('mode dimension info not available',RETURN_FAIL)

    maxdepth:=dimensioninfo.maxdepth
    PrintF('dimensioninfo.maxdepth=\d\n',maxdepth)

    IF screen:=OpenScreenTagList(NIL,[SA_DISPLAYID ,modeid,
                                    SA_DEPTH        ,maxdepth,
                                    SA_TITLE        ,'MaxDepth LORES',
                                    SA_ERRORCODE    ,{soerror},
                                    SA_FULLPALETTE  ,TRUE,
                                    NIL])

            /* Zowee! we actually got the screen open!
             * now let's try drawing into it.
             */
            maxcolors:=Shl(1,maxdepth)
            
            PrintF('maxcolors=\d\n',maxcolors)
            
            FOR colornum:=0 TO maxcolors

                SetAPen(screen.rastport,colornum)
                Move(screen.rastport,colornum,screen.barheight + 2)
                Draw(screen.rastport,colornum,screen.height - 1)
            ENDFOR
            Delay(TICKS_PER_SECOND * 6)

            CloseScreen(screen)
    ELSE
            /* Hmmm.  Couldn't open the screen.  maybe not
             * enough CHIP RAM? Maybe not enough chips! ;-)
             */
            SELECT soerror

                CASE OSERR_NOCHIPS
                    quit('Bummer! You need new chips dude!',RETURN_FAIL)
                
                CASE OSERR_UNKNOWNMODE
                    quit('Bummer! Unknown screen mode.',RETURN_FAIL)
                
                CASE OSERR_NOCHIPMEM
                    quit('Not enough CHIP memory.',RETURN_FAIL)
                
                CASE OSERR_NOMEM
                    quit('Not enough FAST memory.',RETURN_FAIL)
                
                DEFAULT
                    PrintF('soerror=\d\n',soerror)
                    quit('Screen opening error.',RETURN_FAIL)
            ENDSELECT
            quit('Could not open screen.',RETURN_FAIL)
        ENDIF
ENDPROC
