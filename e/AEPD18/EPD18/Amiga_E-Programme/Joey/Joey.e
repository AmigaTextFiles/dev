/* Joey.e   -   A Deiconner utility */
/* Version 1.0 - The first reasonable one */

MODULE 'dos/dos'

DEF path[100]:STRING


PROC showtitle()
   WriteF('Joey V1.0 © SoupySoft by Paul Stevenson\n')
ENDPROC

/* WE START HERE... */

PROC main()
   DEF lock,fib:fileinfoblock,pathchar[1]:STRING

   showtitle()
   IF StrCmp(arg,'',ALL)
      WriteF('Usage is :  Joey <dir>\n')
   ELSE
   IF lock:=Lock(arg,ACCESS_READ)
      IF Examine(lock,fib)
         IF fib.direntrytype>0

/* We have a valid user input (directory as argument). We need to do a
   little work to make things easier later. If the argument ends in ':'
   then we are okay (the input is df0: or something) if not, we assume
   the input is something like df0:t and if this is the case, we need to
   append a '/' to the argument. */

            StrAdd(path,arg,ALL)
            RightStr(pathchar,path,1)
            IF StrCmp(pathchar,':',1)=NIL THEN StrAdd(path,'/',1)
            dodir(lock)
         ELSE
            WriteF('\s is not a directory\n',arg);
         ENDIF
      ELSE
         WriteF('Error: could not examine \s\n',arg);
      ENDIF
      UnLock(lock)
   ELSE
         WriteF('\s not found\n',arg);
   ENDIF
   ENDIF
ENDPROC


/* dodir function:
   This function takes as its argument a lock on a directory, it then
   examines all the entries in the directory, deleting each .info file,
   and calling itself whenever it comes to another (sub)directory. In
   this way, all directories are recusively checked. */


PROC dodir(lok)
   DEF info:fileinfoblock,delcheck,oldpath[100]:STRING,check[6]:STRING,
      filepath[100]:STRING,oldlok

   Examine(lok,info)
   StrCopy(oldpath,path,ALL)
   WHILE ExNext(lok,info)
      IF info.direntrytype>0
         oldlok := lok
         StrAdd(path,info.filename,ALL)
         lok := Lock(path,ACCESS_READ)
         StrAdd(path,'/',1)
         IF lok = 0 THEN WriteF('Could not lock \s\n',path)
         dodir(lok)
         IF lok THEN UnLock(lok)
         StrCopy(path,oldpath,ALL)
         lok := oldlok
      ELSE
         StrCopy(filepath,info.filename,ALL)
         RightStr(check,filepath,5)
         IF StrCmp(check,'.info',5)
            StrCopy(filepath,path,ALL)
            StrAdd(filepath,info.filename,ALL)
            delcheck := DeleteFile(filepath)
            IF delcheck = NIL
               WriteF('\s could not be deleted.\n',filepath)
            ELSE
               WriteF('Deleted \s\n',filepath)
            ENDIF
         ENDIF
      ENDIF
   ENDWHILE
   StrCopy(path,oldpath,ALL)
ENDPROC



