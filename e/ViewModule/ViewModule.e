
MODULE 'reqtools','libraries/reqtools'
CONST FILEREQ=0, FILEINFO=1

DEF finalstring[300]:STRING
DEF dir,completepath[200]:STRING


PROC main()
DEF newlock,oldlock,filename

checkit('C:PPMore')
checkit('C:ShowModule')

IF reqtoolsbase:=OpenLibrary('reqtools.library',37)

WriteF('\n')
WriteF('           Welcome to \e[1mViewModule')
WriteF('\e[0m - A GUI for the ShowModule utility.\n')
WriteF('                            © Pedro Duarte 1997\n')

     -> Cd emodules:
-> --------------------
newlock:=Lock('EMODULES:',-2)
oldlock:=CurrentDir(newlock)


WHILE filename:=fsel('Select module')

      StrCopy(finalstring,'showmodule >ram:module.DUMP ',ALL)
      StrAdd(finalstring,filename,ALL)
      exec(finalstring)

      exec('c:ppmore ram:module.DUMP')

ENDWHILE

   -> Restore dir
-> -----------------
oldlock:=CurrentDir(oldlock)


CloseLibrary(reqtoolsbase)
WriteF(' Bye !\n')
WriteF('')

   ELSE
       WriteF('You need Reqtools.library version 37 or higher !\n')
ENDIF

ENDPROC



-> »»»»»»»»»»»»»»»» The file selector »»»»»»»»»»»»»»»»»»

PROC fsel(text)

DEF buf[100]:STRING
DEF req:PTR TO rtfilerequester
DEF addst, temp[1]:STRING, len

      IF req:=RtAllocRequestA(FILEREQ,0)
         buf[0]:=0                           /*  <- Clear buf   */
         RtFileRequestA(req,buf,text,0)
         dir:=req.dir
         RtFreeRequest(req)

            IF buf[0]=NIL THEN RETURN 0


            len:=StrLen(dir)-1
      IF len>-1                  -> if the selected dir is NOT the current one
            MidStr(temp,dir,len,1)
               IF StrCmp(temp,':',1)=FALSE THEN addst:='/' ELSE addst:=''
            StrCopy(completepath,dir,ALL)
            StrAdd(completepath,addst,ALL)
            StrAdd(completepath,buf,ALL)
      ELSE
            StrCopy(completepath,buf,ALL)

      ENDIF
    ENDIF

ENDPROC completepath

/*           'buf' has the name of the file
             'dir' has the name of the dir
             'completepath' is the dir + file              */

-> »»»»»»»»»»»»»»»» A simple DOS command launcher »»»»»»»»»»»»»»»»»»

PROC exec(argum)
	Execute(argum,0,stdout)
ENDPROC

-> »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

PROC checkit(xx)
DEF bu

bu:=FileLength(xx)
IF bu=-1
      WriteF('Sorry. I couldn''t find the file "')
      WriteF('\s',xx)
      WriteF('" ...\n')
      Raise(0)
ENDIF
ENDPROC

-> »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
PROC bla() HANDLE
EXCEPT
ENDPROC
-> »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

CHAR '$VER: ViewModule v1.0 - first release. By Pedro Duarte.'
