/* depthawarevisitor.e
 *
 * (c) Copyright 1992 Commodore-Amiga, Inc.  All rights reserved.
 *
 * This software is provided as-is and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 *
 */

MODULE	'intuition/intuition',
	'intuition/iobsolete',
	'intuition/screens',
	'dos/dos'

DEF screen:PTR TO screen

PROC quit(whytext, failcode)
    IF whytext THEN WriteF('\s\n',whytext)
    IF (screen)	THEN UnlockPubScreen(NIL, screen)
ENDPROC failcode


PROC main()

DEF drawinfo:PTR TO drawinfo,window:PTR TO window,depth

    screen := LockPubScreen(NIL)
	IF screen=NIL THEN quit('Can\at lock default public screen',RETURN_FAIL)

    /* Here's where we'll ask Intuition about the screen. */
    drawinfo:=GetScreenDrawInfo(screen)
	IF drawinfo=NIL THEN quit('Can\at get DrawInfo',RETURN_FAIL)

    depth:=drawinfo.depth

    /* Because Intuition allocates the DrawInfo structure,
     * we have to tell it when we're done, to get the memory back.
     */
    FreeScreenDrawInfo(screen, drawinfo)

    /* This next line takes advantage of the stack-based amiga.lib
     * version of OpenWindowTagList.
     */
    IF window := OpenWindowTagList(NIL,
				[WA_PUBSCREEN,screen,
                                 WA_LEFT      ,0,
                                 WA_WIDTH     ,screen.width,
                                 WA_TOP       ,screen.barheight,
                                 WA_HEIGHT    ,screen.height - screen.barheight,
                                 WA_FLAGS     ,WINDOWDRAG OR
						WINDOWDEPTH OR
						WINDOWCLOSE OR
                                             	ACTIVATE OR
						SIMPLE_REFRESH OR
						NOCAREREFRESH,
                                 WA_TITLE     ,'Big Visitor',
                                 NIL])
        WriteF('depth=\d\n',depth)
        
        /* All our window event handling might go here */

        Delay(TICKS_PER_SECOND * 10)

        /* Of course, some other program might come along
         * and change the attributes of the screen that we read from
         * DrawInfo, but that's a mean thing to do to a public screen,
         * so let's hope it doesn't happen.
         */

        CloseWindow(window)
    ENDIF

quit('',RETURN_OK)	/* clean up (close/unlock) and exit */
ENDPROC
