-> mg2.e - scans a directory recursively, prints a guide
->         consisting all text/guide files, to stdout.

/* 
   Makes use of some e+ features :
   o CloneStr()
   o big-type assignment
   o Static class-allocation
   o ObjectName()
   o Renamed constructor 
   o PTR TO self
*/

-> exercises : make it output to a user-defined file,
->             make it create html
->             etc

MODULE 'dos/dos'

OBJECT file
   next:PTR TO self -> next file/dir
   name:PTR TO STRING  -> name of file
   id:LONG
   parent:PTR TO self -> we are child of our parent
   fib:fileinfoblock
ENDOBJECT

PROC file(fib, name) OF file
   self.name := CloneStr(name)
   self.fib := fib
   self.id := getUID()
ENDPROC self.name

OBJECT dir OF file
   first:PTR TO self -> file/dir
   last:PTR TO self  -> file/dir
ENDOBJECT

PROC add(dir) OF dir -> add dir/file
   IF self.last
      self.last.next := dir
   ELSE
      self.first := dir
   ENDIF
   self.last := dir
   dir::file.parent := self
ENDPROC dir

DEF g_uid=1
PROC getUID() IS g_uid++

RAISE "MEM" IF New()=NIL,
      "ARGS" IF ReadArgs()=NIL,
      "OPEN" IF Open()=NIL

PROC main()
   DEF top:dir, rdargs=NIL, temp[2]:ARRAY OF LONG, lock

   rdargs := ReadArgs('DIR/A', temp, NIL)

   lock := Lock(temp[0], -2)
   Examine(lock, top.fib)
   UnLock(lock)
   top.name := CloneStr(temp[0])

   IF rdargs THEN FreeArgs(rdargs)

   scan(top)

   ->WriteF('done scanning...\n')


   WriteF('@database \s\n', top.name)
   WriteF('@node main\n\n')
   WriteF('[\d] - \s\n\n', 0, top.fib.filename)

   makeNodes(top)

EXCEPT

   WriteF('error!: ')

   SELECT exception
   CASE "MEM"  ;  WriteF('mem\n')
   CASE "ARGS" ;  WriteF('args\n')
   CASE "FILE" ;  WriteF('file\n')
   CASE "OPEN" ;  WriteF('open\n')
   ENDSELECT

ENDPROC

PROC makeNodes(dir:PTR TO dir)
   DEF n:PTR TO dir
   makeLinks(dir)
   WriteF('@endnode\n')
   n := dir.first
   WHILE n
      IF StrCmp(ObjectName(n), 'file')
         WriteF('@node __\d__ \q\s\q\n\n', n.id, n.fib.filename)
         WriteF('[\d] - \s / \s\n\n', n.id, n.parent.fib.filename, n.fib.filename)
         n.printFileText()
         WriteF('\n@endnode\n')
      ELSEIF StrCmp(ObjectName(n), 'dir')
         WriteF('@node __\d__ \q\s\q\n\n', n.id, n.fib.filename)
         WriteF('[\d] - \s / \s\n\n', n.id, n.parent.fib.filename,n.fib.filename)
         makeNodes(n)
      ENDIF
      n := n.next
   ENDWHILE
ENDPROC

PROC printFileText() OF file
   DEF fh, fmem
   fmem := New(self.fib.size+4)
   fh := Open(self.name, READWRITE)
   Read(fh, fmem, self.fib.size)
   Close(fh)
   Write(stdout, fmem, StrLen(fmem))
   Dispose(fmem)
ENDPROC

PROC makeLinks(dir:PTR TO dir)
   DEF d:PTR TO dir
   d := dir.first
   WHILE d
      WriteF('   @{\q \s \q link __\d__}\n\n', d.fib.filename, d.id)
      d := d.next
   ENDWHILE
ENDPROC

PROC scan(parent:PTR TO dir)
   DEF lock, info:fileinfoblock, s[500]:STRING, dir:PTR TO dir, file:PTR TO file
   IF lock := Lock(parent.name, -2)
      IF Examine(lock,info)
         IF info.direntrytype > 0
            WHILE ExNext(lock,info)
               IF info.direntrytype>0
                  StringF(s, '\s/\s', parent.name, info.filename)
                  NEW dir.dir(info, s)
                  scan(parent.add(dir))
               ELSE -> file
                  StringF(s, '\s/\s', parent.name, info.filename)
                  NEW file.file(info, s)
                  parent.add(file)
               ENDIF
            ENDWHILE  
         ELSE  
            WriteF('ehrrg...?\n')
         ENDIF
      ELSE
         WriteF('Examine on \q\s\q failed !\n', parent.name)
      ENDIF
      UnLock(lock)
   ELSE
     WriteF('Lock on \q\s\q failed !\n', parent.name)
   ENDIF
ENDPROC
