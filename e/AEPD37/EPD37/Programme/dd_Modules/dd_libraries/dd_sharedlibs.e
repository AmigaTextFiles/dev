-> dd_sharedlibs.e

-> FOLD OPTS
OPT MODULE
OPT PREPROCESS
-> ENDFOLD
-> FOLD MODULES
MODULE 'asl'
MODULE 'amigaguide'
MODULE 'utility'
MODULE 'utility/tagitem'

MODULE '*dd_debugon'
MODULE 'tools/debug'


-> ENDFOLD
-> FOLD CONSTS
EXPORT ENUM
  DDA_LIB_Dummy=TAG_USER,
  DDA_LIB_LibraryList,
  DDM_LIB_OpenLibrary
-> ENDFOLD
-> FOLD OBJECTS
EXPORT OBJECT libentry
  name:PTR TO CHAR
  version
  baseptr
ENDOBJECT

EXPORT OBJECT sharedlibs PRIVATE
  liblist:PTR TO entry
ENDOBJECT

OBJECT entry
  PTR TO libentry
ENDOBJECT

EXPORT DEF libs:PTR TO sharedlibs
-> ENDFOLD

EXPORT PROC new(tags:PTR TO tagitem) OF sharedlibs
  DEF tag,entrynum,libentry:PTR TO libentry

  IF utilitybase:=OpenLibrary('utility.library',0)

    self.liblist:=GetTagData(DDA_LIB_LibraryList,NIL,tags)
    self.liblist:=[['a',1,1],['b',2,2]]
    IF self.liblist

      PrintF('self.liblist=\h\n',self.liblist)
      PrintF('self.liblist[]=\h\n',self.liblist[])
      PrintF('self.liblist[].name=\h\n',self.liblist[].name)

      PrintF('listlen=\d\n',ListLen(self.liblist))
      FOR entrynum:=1 TO ListLen(self.liblist)
        PrintF('\s\n',Long(self.liblist[entrynum].name))
      ENDFOR

    ENDIF
  ENDIF
ENDPROC

/*
EXPORT PROC do(method,message) OF sharedlibs
  DEF entrynum=0,found=FALSE,libbase=NIL,success=FALSE,libentry:PTR TO libentry
  SELECT method
  CASE DDM_LIB_OpenLibrary
    WHILE (entrynum<ListLen(self.liblist)) AND (found=FALSE)
      libentry:=self.liblist[entrynum]
      IF libentry.baseptr=message
        found:=TRUE
      ELSE
        entrynum:=entrynum+1
      ENDIF
    ENDWHILE
    IF found
      IF libbase:=OpenLibrary(self.liblist.libentry[entrynum].name,self.liblist.libentry[entrynum].version)
        PutLong(libbase,self.liblist.libentry[entrynum].baseptr)
        success:=TRUE
      ENDIF
    ENDIF
  DEFAULT
    KPUTSTR('Unknown method requested\n')
  ENDSELECT
ENDPROC
*/
-> ENDFOLD

