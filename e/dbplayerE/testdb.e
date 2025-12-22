

MODULE 'dbplayer/digibooster','dbplayer/dbplayer','utility/tagitem'

PROC main()
DEF db:PTR TO digibooster,tagi:PTR TO tagitem,inst=0,tag:PTR TO tagitem,i=0
DEF modname=0,channum=0,pattnum=0,instnames=0:PTR TO LONG


VOID '$VER: TestDigiPlayer v2.0 (22.02.99) By WZP/DEFEAT'


NEW db.init()

IF (db.loadfile(arg))=TRUE

tagi:=[DBMATTR_InstNum,0,DBMATTR_ModName,0,DBMATTR_ChanNum,0,DBMATTR_PattNum,0,DBMATTR_InstNames,0,TAG_DONE]
tagi[0].data:={inst}
tagi[1].data:={modname}
tagi[2].data:={channum}
tagi[3].data:={pattnum}
tagi[4].data:={instnames}

db.playmodule()

db.getattr(tagi)


WriteF('\n')
WriteF('InstNum: \d\n',inst)
WriteF('ChanNum: \d\n',channum)
WriteF('PattNum: \d\n',pattnum)
WriteF('ModName: "\s"\n',modname)

WriteF('\n\e[1mSamples name:\e[0m\n---------------------\n')

FOR i:=1 TO inst

WriteF('[\h[2]] - \s\n',i,instnames[i])

ENDFOR

WriteF('--------------------\n')

WriteF('\nPress Mouse Button To Quit!\n\n')

REPEAT
UNTIL Mouse()=1 

db.stopmodule()

ELSE
WriteF('Can''t load file!\n')
ENDIF

db.dispose()
END db


ENDPROC
