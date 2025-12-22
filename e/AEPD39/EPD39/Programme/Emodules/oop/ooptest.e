OPT OSVERSION=37
OPT PREPROCESS

/*
*-- AutoRev header do NOT edit!
*
*   Project         :   Test program for oop.library
*   File            :   ooptest.e
*   Copyright       :   © 1995 Piotr Gapinski
*   Author          :   Piotr Gapinski
*   Creation Date   :   28.12.95
*   Current version :   1.0
*   Translator      :   AmigaE v3.1+
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   28.12.95      1.0             first release
*
*-- REV_END --*
*/

MODULE 'utility/tagitem','utility/hooks',
       'libraries/oop','oop',
       'other/ecode','tools/exceptions'

#define PROGRAMVERSION '$VER: OOPtest 1.0 (28.12.95)'

ENUM ERR_OK,ERR_NOLIB,ERR_NOROOTCLASS,ERR_NOSUBCLASS,ERR_NOMEM
ENUM MC_METHOD1=4,MC_METHOD2

PROC main() HANDLE
  DEF rc=0,mc=0,mo=0,res

  IF (oopbase:=OpenLibrary(OOPNAME,OOPVERSION))=NIL THEN Raise(ERR_NOLIB)
  IF (rc:=OoP_FindClass(OOP_ROOTCLASS_NAME))=NIL THEN Raise(ERR_NOROOTCLASS)

-> create a new class (called 'class')
  mc:=OoP_NewObject(rc,
      [
       OOPRCA_VERSION,1,
       OOPRCA_REVISION,0,
       OOPRCA_INFO,'class - example',
       OOPRCA_AUTHOR,'Piotr Gapinski',
       TAG_END
      ])
  IF mc<>NIL
    addmethod(mc,MC_METHOD1,{methodfunc})
    addmethod(mc,MC_METHOD2,{methodfunc})
    OoP_AddSuperClass(mc,rc)
    res:=OoP_AddClass(mc,'class')
  ENDIF

-> invoke class ('class') methods
  IF (mc:=OoP_FindClass('class'))=NIL THEN Raise(ERR_NOSUBCLASS)
  mo:=OoP_NewObject(mc,NIL)
  IF mo<>NIL
    OoP_DoMethod(mo,MC_METHOD1,[1,2,3,4,5,6,7,8,9,TAG_DONE])
    OoP_DoMethod(mo,MC_METHOD2,
      [
       'Piotr',
       'Gapinski',
       'kolo8@sparc10.ely.pg.gda.pl',
       TAG_DONE
      ])
    OoP_DeleteObject(mo)
  ENDIF
EXCEPT DO
  IF mc
    OoP_RemClass(mc)         -> remove class from public list
    OoP_DeleteObject(mc)     -> delete class & all methods
  ENDIF
  IF oopbase THEN CloseLibrary(oopbase)
  IF exception
    SELECT exception
    CASE ERR_NOLIB
      WriteF('Couldn\at open \s\n',OOPNAME)
    CASE ERR_NOROOTCLASS
      WriteF('Couldn\at find RootClass !\n')
    CASE ERR_NOSUBCLASS
      WriteF('Couldn\at find my class !\n')
    CASE ERR_NOMEM
      WriteF('No free memory!\n')
    DEFAULT
      report_exception()
      WriteF('LEVEL: main()\n')
    ENDSELECT
  ENDIF
ENDPROC

PROC addmethod(obj,id,func)
  DEF mh:PTR TO hook,res

  NEW mh
  IF mh=NIL THEN Raise(ERR_NOMEM)
  mh.entry:=eCode(func)
  mh.subentry:=NIL
  mh.data:=NIL
  res:=OoP_AddMethod(obj,id,mh);
ENDPROC res

PROC methodfunc()
  DEF msg:PTR TO LONG,id

  MOVE.L A1,msg
  MOVE.L D1,id
  WriteF('METHOD ID=\d\n',id)
  SELECT id
  CASE MC_METHOD1
    WHILE ^msg<>TAG_DONE DO WriteF('  MSG: \h\n',^msg++)
  CASE MC_METHOD2
    WHILE ^msg<>TAG_DONE DO WriteF('  MSG: \s\n',^msg++)
  DEFAULT
    WriteF('Unknown\n')
  ENDSELECT
ENDPROC

CHAR PROGRAMVERSION,0
/*EE folds
-1
92 8 95 13 
EE folds*/
