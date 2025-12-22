OPT MODULE
OPT EXPORT

MODULE 'DiskFont',
       'intuition/intuition',
       'libraries/diskfont',
       'graphics/text',
       'graphics/rastport'

CONST	ROMFONT = 1,
	DISKFONT= 2

PROC mOpenDiskFont(ver=0)
diskfontbase:=OpenLibrary('diskfont.library',ver)
RETURN diskfontbase
ENDPROC

PROC mChangeFont(rastport,name,ysize,style=0,flag=2)
DEF tattr:PTR TO textattr,tfont:PTR TO textfont
	tattr:=[name,ysize,style,flag]:textattr
	tfont:=OpenDiskFont(tattr)
		SetFont(rastport,tfont)
ENDPROC tfont

PROC mCloseDiskFont(dummy=0)
CloseLibrary(diskfontbase)
ENDPROC
