/** showicon.e  v1.0  Amiga E v3.2e  (c)1996 Marco Talamelli **/

/* shortification to make code readable on 80colon' display */

MODULE	'workbench/workbench',
	'exec/ports',
	'icon',
	'intuition/screens',
	'intuition/iobsolete',
	'intuition/intuition'

PROC main()

DEF 	do:PTR TO diskobject,
	gd:PTR TO gadget,
	wd:PTR TO window,
	im:PTR TO intuimessage,
	done=FALSE,
	myargs:PTR TO LONG,rdargs
myargs:=[0]
IF rdargs:=ReadArgs('NAMEICON/A',myargs,NIL)
IF iconbase := OpenLibrary('icon.library', 0)
	IF do := GetDiskObject(myargs[0])
		gd := do.gadget
		gd.leftedge:=100-(gd.width/2)
		gd.topedge:=100-(gd.height/2)
		IF wd := OpenWindow([    0,	->leftedge
					 0,	->topedge
					 200,	->width
					 200,	->height
					  0,	->detailpen
					  1,	->blockpen
					 CLOSEWINDOW OR VANILLAKEY, ->idcmpflags
					WINDOWDRAG OR		    ->flags
					WINDOWCLOSE OR
					WINDOWDEPTH OR
					ACTIVATE OR
					RMBTRAP OR
					NOCAREREFRESH,
					gd,		->firstgadget
					NIL,		->checkmark
					'ShowIcon',	->title
					NIL,		->screen
					NIL,		->bitmap
					0,		->minwidth
					0,		->minheight
					0,		->maxwidth
					0,		->maxheight
					WBENCHSCREEN	->type
						]:nw)
				REPEAT
				Wait(Shl(1,wd.userport.sigbit))
				im := GetMsg(wd.userport)
				ReplyMsg(im)
				IF (im.class = CLOSEWINDOW) OR (im.class = VANILLAKEY)
				done:=TRUE
				ENDIF
				UNTIL done
		CloseWindow(wd)
		ENDIF
		FreeDiskObject(do)
	ENDIF
		CloseLibrary(iconbase)
ENDIF
    FreeArgs(rdargs)
  ELSE
    WriteF('Usage \aNAMEICONS\a\n')
  ENDIF
ENDPROC
