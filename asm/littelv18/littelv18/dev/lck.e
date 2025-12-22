OPT MODULE 
 
OPT EXPORT 
 
MODULE '*misc2' 
MODULE '*lib' 
 
EXPORT DEF linkfiles, modestr 
 
 
 
PROC lck_Const(name, value) 
   DEF str[60]:STRING 
   StringF(str, '\s EQU \s\n', name, value) 
   write1(str) 
ENDPROC 
 
PROC lck_Incdir(dir) 
   DEF str[70]:STRING 
   StringF(str, '\n incdir \s\n', dir) 
   write2(str) 
ENDPROC 
 
PROC lck_mInclude(array:PTR TO LONG) 
   WHILE array[] DO lck_Include(array[]++) 
ENDPROC 
 
PROC lck_Include(name) 
   DEF str[70]:STRING 
   StringF(str, '\n include \s\n', name) 
   write2(str) 
ENDPROC 
 
/* 
PROC do_linkdir(dir) 
   StringF(linkdir, '\s', dir) 
ENDPROC 
*/ 
PROC lck_mLink(array:PTR TO LONG) 
   WHILE array[] DO lck_Link(array[]++) 
ENDPROC 
 
PROC lck_Link(name) 
  StrAdd(linkfiles, 'LITTEL:lib/') 
  StrAdd(linkfiles, name) 
  StrAdd(linkfiles, ' ') 
ENDPROC 
 
PROC lck_Mode(mode, a1, a2, a3, a4) 
   IF StrCmp(mode, 'LIBRARY') 
      lib_RegPreserve('d2-d7/a2-a4/a6') 
      lib_LibraryEnv('SHARED') 
      libsrc(a1, a2, a3, a4) 
   ENDIF 
   StrCopy(modestr, mode) 
ENDPROC 
 
PROC lck_mXref(array:PTR TO LONG) 
   WHILE array[] DO lck_Xref(array[]++) 
ENDPROC 
 
PROC lck_Xref(name) 
   DEF str[50]:STRING 
   StringF(str, ' xref \s\n', name) 
   write2(str) 
ENDPROC 
 
PROC lck_mXdef(array:PTR TO LONG) 
   WHILE array[] DO lck_Xdef(array[]++) 
ENDPROC 
 
PROC lck_Xdef(name) 
   DEF str[50]:STRING 
   StringF(str, ' xdef \s\n', name) 
   write2(str) 
ENDPROC 
