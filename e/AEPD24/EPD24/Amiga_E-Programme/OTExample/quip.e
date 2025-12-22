OPT MODULE

MODULE 'dos/dos','other/stderr','other/queuestack'

/*
 * Sorry folks.. you'll need these three modules.  You
 * should have the first one, but if you're missing the
 * other two I think you can find them in aminet:dev/e.
 * I should hope so, anyway.. I wrote them and uploaded
 * both of them there.
 */

RAISE "OPEN" IF Open() = NIL,
      "MEM" IF String() = NIL,
      "MEM" IF List() = NIL,
      "MEM" IF New() = NIL,
      "file" IF FileLength() = -1,
      "^C"   IF CtrlC() = TRUE

-> Flags to signal behavior.  I like playing with bits when
-> possible.  QRND determines whether the quips are selected
-> sequentially or randomly, while QQUIET determines if certain
-> messages ought to be printed or not.

EXPORT SET QRND,QQUIET

-> Here's the base 'quip' object.  All other quip objects
-> will be derived from this.

EXPORT OBJECT quip
 prefix			-> The prefix string.
 suffix			-> The suffix string.
 middle			-> A string to go between multiple quips (not implemented).
 filter			-> A filter process (not implemented)
PRIVATE
 quip:PTR TO queuestack -> Stores a list of quips.
ENDOBJECT

-> This is the 'fquip' object, designed to handle normal, dull, boring
-> quip files without using a tablefile.

EXPORT OBJECT fquip OF quip
 delimit		-> The character to look for preceding a quip.
 which			-> Which quip to grab.
 number			-> The number of quips to get.
PRIVATE
 flag			-> Can modify some behaviors of the object.
 fname			-> A filename for the datafile from which to grab quips.
 fh			-> A filehandler for the datafile.
ENDOBJECT

-> This is the 'tquip' object, designed to handle files that have tablefiles
-> associated with them (which helps speed up the aquisition of serial quips).

EXPORT OBJECT tquip OF fquip
PRIVATE
 tname			-> The name of the tablefile (provided by self).
 tfh			-> A filehandler for the tablefile.
 maxrnd			-> The maximum number of quips available.
ENDOBJECT

-> The next object I want to create is a 'cquip' object to handle compressed
-> quips.  It'll likely be derived from 'tquip', since it'll use files and
-> something resembling a 'tablefile' within the compressed file itself.

/**************************************************************************/

-> These globals help me create temporary objects for manipulation.  I prefer to use
-> a global rather than an internal temporary one.. perhaps because I suspect it can
-> save some room.

DEF qstmp:PTR TO queuestack  -> For allocating queuestacks.

/**************************************************************************/

-> Now we start with the methods associated with the baseclass 'quip':

-> A contructor.  I prefer to use 'new()' because it's easy to remember... one
-> allocates an instance with a 'NEW object.new()'.  Very easy.  All the derived
-> classes use this same method.

EXPORT PROC new(opt=0) OF quip
 self.init()
 self.opts(opt)
ENDPROC

-> init() actually handles the initiation of the 'quip' baseclass.  All we really
-> need to do is initiate the queuestack.  Each derived class has its own init()
-> method which calls a super init method.

PROC init() OF quip
 self.quip:=NEW qstmp.new()
ENDPROC

-> opts() reads a list and performs various functions accordingly.  It's good
-> for setting many options at one time.  I need to clean this code up a bit;
-> currently, each object has its own opts(), yet a lot of the same things are
-> being done; this is ugly, and non-OT-like.  I have a plan to change this,
-> but to get this out I'll let you imagine it.

EXPORT PROC opts(opt) OF quip HANDLE
 DEF i,item
 IF opt=NIL THEN RETURN
 FOR i:=0 TO ListLen(opt)
  item:=ListItem(opt,i)
  SELECT item
   CASE "pre"			-> "pre" will simply set prefix to a string.
    INC i
    self.prefix:=ListItem(opt,i)
   CASE "fpre"			-> "fpre" will do the above to a filename.
    INC i
    self.pre(ListItem(opt,i))
   CASE "suf"			-> "suf" sets a suffix to a string.
    INC i
    self.suffix:=ListItem(opt,i)
   CASE "fsuf"			-> "fsuf" for a file-suffix.
    INC i
    self.suf(ListItem(opt,i))
   CASE "mid"			-> "mid" for a middle string.
    INC i
    self.middle:=ListItem(opt,i)
   CASE "fmid"			-> "fmid" for a file-middle.
    INC i
    self.mid(ListItem(opt,i))
   CASE "quip"			-> "quip" will insert a quip into the queuestack.
    INC i
    self.add(ListItem(opt,i))
  ENDSELECT
 ENDFOR
EXCEPT
 Raise(exception)
ENDPROC

-> kill() will be used to iterate through the queuestack, removing all the items within
-> it.  This is useful for deleting several quips at one time, and will come in quite
-> handy when someone needs to END a 'quip' object.  NOTE: It's not associated with any
-> of the objects.  It's an internal procedure.
-> Additional note: I think there's a method within queuestack to kill all its elements.
-> I forgot about it, though.  This procedure is not necessary.

PROC kill(i)
 IF i THEN END i
ENDPROC

-> pre() allows you to enter a file's text as a prefix string.  You could normally
-> simply assign it, but this takes a filename as a parameter, grabbing the file's
-> contents itself... saving you from any work.

-> suf() and mid() are the same way.

EXPORT PROC pre(fname) OF quip HANDLE
 IF fname
  self.prefix:=self.textfile(fname)
 ENDIF
EXCEPT
 SELECT exception
  CASE "file"
   err_WriteF('No prefix file "\s".\n',[fname])
  DEFAULT
   Raise(exception)
 ENDSELECT
ENDPROC

EXPORT PROC suf(fname) OF quip HANDLE
 self.suffix:=self.textfile(fname)
EXCEPT
 SELECT exception
  CASE "file"
   err_WriteF('No suffix file "\s".\n',[fname])
  DEFAULT
   Raise(exception)
 ENDSELECT
ENDPROC

EXPORT PROC mid(fname) OF quip HANDLE
 self.middle:=self.textfile(fname)
EXCEPT
 SELECT exception
  CASE "file"
   err_WriteF('No middle file "\s".\n',[fname])
  DEFAULT
   Raise(exception)
 ENDSELECT
ENDPROC

-> add() will put a string into the internal queuestack.  This string is assumed
-> to be a quip.

EXPORT PROC add(quip) OF quip
 self.quip.addFirst(quip)
ENDPROC

-> get() will retrieve a quip from the queuestack (if available) and return a pointer
-> to it.  It'll also return a pointer to the 'middle' if it's needed (for, say,
-> multiple quips).  The string returned has the prefix and suffix strings pre/appended
-> to the quip already.

EXPORT PROC get() OF quip HANDLE
 DEF tmp,quip
 IF self.isMore() THEN quip:=self.quip.getLast()
 tmp:=String(StrLen(self.prefix) + StrLen(self.suffix) + StrLen(quip) + 1)
 IF self.prefix
  StrAdd(tmp,self.prefix)
 ENDIF
 IF quip
  StrAdd(tmp,quip)
 ENDIF
 IF self.suffix
  StrAdd(tmp,self.suffix)
 ENDIF
 RETURN tmp,self.middle
EXCEPT
 Raise(exception)
ENDPROC

-> isMore() will return the size of the queuestack.  This is useful to determine
-> whether or not to actually TRY to get any quips.

EXPORT PROC isMore() OF quip
 RETURN self.quip.getSize()
ENDPROC

-> textfile() is an internal routine that handles grabbing a file and stuffing it in
-> memory.  It'll return with that memory area, filled with (hopefully) text.
-> It's used for prefix/suffix/middle strings in the pre()/suf()/mid() functions.

PROC textfile(fname) OF quip HANDLE
 -> read a textfile into a memory area and return memory area
 DEF size,out=0,fh=0
 size := FileLength(fname)
 out:=String(size+1)
 fh:=Open(fname,OLDFILE)
 IF Fread(fh,out,size,1)<1   -> If this fails, we have an I/O error.
  Close(fh)
  fh:=0
  Dispose(out)
  out:=0
  Raise("READ")
 ENDIF
 Close(fh)
 fh:=0
 RETURN out
EXCEPT
 IF out THEN Dispose(out)
 IF fh THEN Close(fh)
 IF exception="READ"
  err_WriteF('Error reading "\s".\n',[fname])
  RETURN					-> This isn't a killer.
 ENDIF
 Raise(exception)
ENDPROC

-> end() is an automatic destructor.  It's called when 'END object' is used.
-> Basically, it deallocates the prefix/suffix/middle strings, any strings in the
-> queuestack, and then the queuestack itself.

EXPORT PROC end() OF quip
 IF self.prefix THEN Dispose(self.prefix)
 IF self.suffix THEN Dispose(self.suffix)
 IF self.middle THEN Dispose(self.middle)
 IF self.quip
  qstmp:=self.quip
  qstmp.do({kill})
  END qstmp
 ENDIF
ENDPROC

/**************************************************************************/

-> Now we move on to the methods assign to derived class 'fquip'

-> You'll note: I'm missing a 'new()' initializer, since the 'quip' one will do.
-> The super-object's ("quip"'s) own new() method will call the fquip init() and
-> opts() methods.

-> init() sets the default delimiter, the default filename, and the default number
-> of quips to retrieve, before initializing the superclass elements (quip).

PROC init() OF fquip
 DEF moo			-> Go figure.. I couldn't use '^defaultDelimit'
 moo:={defaultDelimit}
 self.delimit:=^moo
 self.fname:={defaultFilename}
 self.number:=1
 SUPER self.init()	-> Why repeat the work?
ENDPROC

-> I could simply call SUPER opts() after processing these for my own
-> needs, but it would slow things down.  This is perhaps more efficient (for speed).
-> In retrospect, I think I can make another procedure for handling this kind
-> of thing (working with opts), but for now, consider the opts() methods to
-> be slightly out-of-step with proper OT handling.  For the sake of getting
-> an example of fairly good OT organization out, I'm going to release this
-> slight inelegance, but rest assured, my 'opts()' methods are going to change.

PROC opts(opt) OF fquip HANDLE
 DEF i,item
 IF opt=NIL THEN RETURN
 FOR i:=0 TO ListLen(opt)
  item:=ListItem(opt,i)
  SELECT item
   CASE "pre"
    INC i
    self.prefix:=ListItem(opt,i)
   CASE "fpre"
    INC i
    self.pre(ListItem(opt,i))
   CASE "suf"
    INC i
    self.suffix:=ListItem(opt,i)
   CASE "fsuf"
    INC i
    self.suf(ListItem(opt,i))
   CASE "mid"
    INC i
    self.middle:=ListItem(opt,i)
   CASE "fmid"
    INC i
    self.mid(ListItem(opt,i))
   CASE "quip"
    INC i
    self.add(ListItem(opt,i))
   CASE "rnd"				-> Sets 'flag' for random quips.
    self.rnd()
   CASE "ser"				-> Sets 'flag' for serial quips.
    self.ser()
   CASE "dlmt"				-> Sets the delimiter.
    INC i
    self.delimit:=ListItem(opt,i)
   CASE "whch"				-> Sets which quip should be grabbed.
    INC i
    self.which:=ListItem(opt,i)
   CASE "file"				-> Sets the filename for the datafile.
    INC i
    self.file(ListItem(opt,i))
   CASE "shhh"				-> Sets 'flag' to cause .mention() to be quiet.
    self.quiet()
   CASE "num"				-> Sets how many quips to retrieve.
    INC i
    self.number:=ListItem(opt,i)
  ENDSELECT
 ENDFOR
EXCEPT
 Raise(exception)
ENDPROC

-> quiet() tells 'mention()' not to print anything.

EXPORT PROC quiet() OF fquip
 self.flag:=Eor(self.flag,QQUIET)
ENDPROC

-> mention() will call err_WriteF() (my stderr port handler) only if the QQUIET
-> flag is not on.  This controls whether or not to print progress reports.

EXPORT PROC mention(in=0,tags=0) OF fquip
 IF (self.flag AND QQUIET) THEN RETURN
 err_WriteF(in,tags)
ENDPROC

-> This sets the datafile name.  In retrospect, one could use it to close the
-> current file, too.

EXPORT PROC file(in=0) OF fquip
 IF in
  IF self.fh
   Close(self.fh)
   self.fh:=0
  ENDIF
 ENDIF
 self.fname:=in
ENDPROC

-> get() will retrieve a quip ONLY if there are any quips to retrieve.  If not,
-> it'll cause the fquip object to grab some.

EXPORT PROC get() OF fquip
 IF self.isMore()=NIL THEN self.grab()
 RETURN SUPER self.get()
ENDPROC

-> grab() calls the methods necessary to fill the queuestack with quip(s).
-> It determines whether to use the random or serial routines.

EXPORT PROC grab() OF fquip
 IF self.flag AND QRND
  self.getRandom()
 ELSE
  self.getSerial()
 ENDIF
ENDPROC

-> getRandom() will randomly select a place somewhere in the (hopefully) text file
-> and search for the delimiter.  From there, it'll grab the next quip, or try again
-> (if instead of a delimiter it reached the end of the file).  This behavior is not
-> as random as one might like, but it's the best one can do without a tablefile.

PROC getRandom() OF fquip HANDLE
 DEF size=0,rpos,quip
 IF self.fname
  IF self.fh = NIL
   self.fh:=Open(self.fname,MODE_OLDFILE)
  ENDIF
again:
  CtrlC()
  size:=FileLength(self.fname)
  rpos := Rnd(size)
  Seek(self.fh,rpos,OFFSET_BEGINNING) 
  IF (rpos:=self.pass()) = -1 THEN JUMP again                   -> see comment below
  IF (size:=self.pass()) = -1 THEN size:=FileLength(self.fname)+1
  quip:=String(size-rpos+1)
  Seek(self.fh,rpos,OFFSET_BEGINNING)
  Fread(self.fh,quip,size-rpos-1,1)
  self.add(quip)
  self.number:=self.number-1
  IF self.number THEN JUMP again  -> Yes, I know... JUMPs are ugly, but I think
  Close(self.fh)		  -> an exception can be made here.. no pun intended.
  self.fh:=0
 ENDIF
EXCEPT
 IF self.fh
  Close(self.fh)
  self.fh:=0
 ENDIF
 SELECT exception
  CASE "OPEN"
   err_WriteF('Unable to open "\s" for random quips.\n',[self.fname])
  CASE "file"
   err_WriteF('File "\s" doesn''t exist!\n',[self.fname])
  DEFAULT
   Raise(exception)
 ENDSELECT
ENDPROC

-> pass() will search from the current position of the datafile to the next
-> character matching the delimiter character, or the EOF.  If it reaches the
-> end of the file, it'll return a -1, otherwise it returns the current position.

PROC pass() OF fquip
 DEF size=0
 IF self.fh = NIL
  self.fh := Open(self.fname,MODE_OLDFILE)
  Seek(self.fh,0,OFFSET_CURRENT)
 ENDIF
 IF size = self.delimit THEN INC size
 WHILE (size <> -1) AND (size <> self.delimit)
  size:=Inp(self.fh)
 ENDWHILE
 IF size = -1
  SetIoErr(0)		-> a Seek() error is certain, but no need for alarm.
  RETURN size
 ENDIF
 RETURN Seek(self.fh,0,OFFSET_CURRENT)
ENDPROC

-> getSerial() will grab a number of quips from a datafile, but in sequential order
-> according to how they appear in the datafile.  It will get the current number
-> it's supposed to get (provided the number isn't already set in the object) and
-> slowly, ponderously, annoying pass() its way to that quip.  If "shhh" isn't set,
-> it'll give a progress report.

PROC getSerial() OF fquip HANDLE
 DEF i,rpos,size,quip
 IF self.fh = 0 THEN self.fh := Open(self.fname,MODE_OLDFILE)
 Seek(self.fh,0,OFFSET_BEGINNING)
 IF self.which=NIL THEN self.nextNum()   -> select which quip to get.
 SetIoErr(0)                             -> just in case.. it could screw up err_WriteF()
 self.mention('1         - Quip #\b')
 FOR i:=1 TO self.which			 -> This finds the quip, or restarts from 1.
  IF (rpos:=self.pass()) = -1
   self.which:=1
   i:=1
  ENDIF
  self.mention('\d\b',[i])
 ENDFOR
 FOR i:=1 TO self.number		 -> Now we get a collection of quips.
  IF (size:=self.pass()) = -1
   self.which:=1
   Seek(self.fh,0,OFFSET_BEGINNING)
   self.mention('         \b')
   IF (rpos:=self.pass())=-1
    err_WriteF('Either "\s" is not a datafile or "\c" is not the delimiter.\n',
               [self.fname,self.delimit])
    Raise("quip")			 -> This should rarely, if ever, happen.
   ENDIF
   IF (size:=self.pass())=-1 THEN size:=FileLength(self.fname)
  ENDIF
  Seek(self.fh,rpos,OFFSET_BEGINNING)
  quip:=String(size-rpos+1)
  Fread(self.fh,quip,size-rpos-1,1)
  self.add(quip)
  Seek(self.fh,size,OFFSET_BEGINNING)
  SetIoErr(0)
  rpos:=size
  self.which:=self.which+1
  self.mention('\d\b',[self.which-1])
 ENDFOR
 self.update()				 -> make sure we change the pointer in the file
 self.mention('\n')
EXCEPT
 IF self.fh
  Close(self.fh)
  self.fh:=0
 ENDIF
 SELECT exception
  CASE "OPEN"
   err_WriteF('Unable to open "\s" for random quips.\n',[self.fname])
  CASE "file"
   err_WriteF('File "\s" didn''t read properly\n',[self.fname])
  DEFAULT
   Raise(exception)
 ENDSELECT
ENDPROC

-> nextNum() looks in the datafile for which quip it should retrieve.

PROC nextNum() OF fquip
 DEF val
 IF self.fh = NIL THEN self.fh:=Open(self.fname,MODE_OLDFILE)
 Seek(self.fh,0,OFFSET_BEGINNING)
 val:=String(80)
 IF ReadStr(self.fh,val)<>NIL THEN Raise("file")
 self.which := Val(val,0)
ENDPROC

-> update() will change the number in the quip file to the current 'which' value.

PROC update() OF fquip
 DEF which
 which:=self.which
 IF self.fh=NIL THEN self.fh:=Open(self.fname,OLDFILE)
 Seek(self.fh,0,OFFSET_BEGINNING)
 IF (VfPrintf(self.fh,'%-12ld',{which}))=-1 THEN Raise("file")
 Close(self.fh)
 self.fh:=0
ENDPROC

-> put() isn't done yet.  I intend to design it to allow people to add new
-> quips to the current datafile, but I haven't gotten around to it <sigh>.
-> It should be too hard to do, though.

EXPORT PROC put(opt=0) OF fquip
 DEF i,max,item
 max:=ListLen(opt)
 FOR i:=0 TO max
  item:=ListItem(opt,i)
  SELECT item
   CASE "one"			-> One string.
   CASE "many"			-> The whole queuestack to 'number'.
  ENDSELECT
 ENDFOR
ENDPROC

-> This sets the 'flag' so get() will select the serial routine.

EXPORT PROC ser() OF fquip
 self.flag:=self.flag AND Not(QRND)
ENDPROC

-> This sets the 'flag' so get() will select the random routine.

EXPORT PROC rnd() OF fquip
 self.flag:=self.flag OR QRND
ENDPROC

-> end().. our happy little deallocator <smile>.  Note how it calls the super
-> deallocator.

PROC end() OF fquip
 IF self.fh THEN Close(self.fh)
 self.fh:=0
 SUPER self.end()
ENDPROC

/**************************************************************************/

-> And now, 'fquip's derived class 'tquip's associated methods.

-> init() will set the defaultTablename, just to speed things along a bit.

PROC init() OF tquip
 self.tname:={defaultTablename}
 SUPER self.init()
ENDPROC

-> getRandom() was rewritten in order to take advantage of the tablefile.
-> A tablefile can provide better randomness, since you can select according
-> to how many quips are in the datafile, rather than randomly Seek()ing (which
-> is not as random, as larger quips will be ignored, prefering smaller ones).

PROC getRandom() OF tquip HANDLE
 DEF size,rpos,quip,i
 self.maxrnd:=FileLength(self.tname)
 FOR i:=1 TO self.number
  CtrlC()
  size:=Div(self.maxrnd,4)
  size:=Rnd(size)
  self.which:=size+2
  IF self.tfh = NIL THEN self.tfh := Open(self.tname,OLDFILE)
  Seek(self.tfh,size*4,OFFSET_BEGINNING)
  Fread(self.tfh,{rpos},4,1)
  IF self.fh = NIL THEN self.fh := Open(self.fname,OLDFILE)
  Seek(self.fh,rpos,OFFSET_BEGINNING)
  IF (size:=self.pass())=-1 THEN size:=FileLength(self.fname)+1
  Seek(self.fh,rpos,OFFSET_BEGINNING)
  quip:=String(size-rpos+1)           -> You'll note my paranoia
  Fread(self.fh,quip,size-rpos-1,1)
  self.add(quip)
 ENDFOR
 Close(self.tfh) ; self.tfh:=0
 Close(self.fh) ; self.fh:=0
EXCEPT
 IF self.fh THEN Close(self.fh)
 IF self.tfh THEN Close(self.tfh)
 self.fh:=0
 self.tfh:=0
 SELECT exception
  CASE "file"
   err_WriteF('File \s doesn''t exist.\n',[self.tname])
  CASE "OPEN"
   err_WriteF('Couldn''t open file.\n')
 ENDSELECT
 Raise(exception)
ENDPROC

-> getSerial() required modifications for the same reason.  But OH how this works
-> much faster than 'fquip's way.

PROC getSerial() OF tquip HANDLE
 DEF size=0,rpos=0,i,quip,flag=0
 IF self.which = NIL THEN self.nextNum()
 IF self.tfh=NIL THEN self.tfh:=Open(self.tname,OLDFILE)
 Seek(self.tfh,4*(self.which-1),OFFSET_BEGINNING)
 IF self.fh=NIL THEN self.fh:=Open(self.fname,OLDFILE)
 Fread(self.tfh,{rpos},4,1)
 FOR i:=1 TO self.number
  Fread(self.tfh,{size},4,1)
  Seek(self.fh,rpos,OFFSET_BEGINNING)
  IF IoErr()
   size:=FileLength(self.fname)+1
   SetIoErr(0)
   flag:=TRUE
  ENDIF
  quip:=String(size-rpos+1)
  Seek(self.fh,rpos,OFFSET_BEGINNING)
  Fread(self.fh,quip,size-rpos-1,1)
  self.add(quip)
  IF flag
   flag:=FALSE
   Seek(self.tfh,0,OFFSET_BEGINNING)
   Fread(self.tfh,{rpos},4,1)
   self.which:=0
  ELSE
   rpos:=size
  ENDIF
  self.which:=self.which+1
 ENDFOR
 self.update()
 IF self.tfh
  Close(self.tfh); self.tfh:=0
 ENDIF
 IF self.fh
  Close(self.fh); self.fh:=0
 ENDIF
EXCEPT
 Raise(exception)
ENDPROC

-> put() for this procedure is also not done yet... basically, I'll call the
-> SUPER put(), then update the tablefile.

EXPORT PROC put(opt=0) OF tquip
 SUPER self.put(opt)
ENDPROC

-> table() will create a new (or update an old) tablefile.

EXPORT PROC table(num=0) OF tquip HANDLE
 DEF size=0,rpos=0,hold=0
 IF num
  size:=FileLength(self.tname)
  hold:=New(size+1)
  IF self.tfh = NIL THEN self.tfh:=Open(self.tname,OLDFILE)
  Seek(self.tfh,0,OFFSET_BEGINNING)
  Fread(self.tfh,hold,(num-1)*4,1)
  Fread(self.tfh,{rpos},4,1)
  Close(self.tfh)
  self.tfh:=Open(self.tname,NEWFILE)
  Fwrite(self.tfh,hold,num*4,1)
  Seek(self.tfh,-4,OFFSET_CURRENT)
  Fwrite(self.tfh,{rpos},4,1)
  IF self.fh = NIL THEN self.fh:=Open(self.fname,OLDFILE)
  Seek(self.fh,rpos+1,OFFSET_BEGINNING)
  self.mention('Now writing tablefile \s from #\d.\n',[self.tname,num])
 ELSE
  IF self.tfh THEN Close(self.tfh)
  self.tfh:=Open(self.tname,NEWFILE)
  Seek(self.tfh,0,OFFSET_BEGINNING)
  self.mention('Now writing tablefile \s from #\d.\n',[self.tname,num+1])
 ENDIF
 LOOP
  CtrlC()
  IF (rpos:=self.pass())=-1 THEN Raise("OK")
  self.mention('\d\b',{num})
  Fwrite(self.tfh,{rpos},4,1)
  INC num
 ENDLOOP
EXCEPT
 IF self.fh
  Close(self.fh); self.fh:=0
 ENDIF
 IF self.tfh
  Close(self.tfh); self.tfh:=0
 ENDIF
 IF hold THEN Dispose(hold)
 SELECT exception
  self.mention('\e[ p')
  CASE "OK"
   self.mention('\d - quips in file.\n',{num})
   RETURN
  CASE "^C"
   err_WriteF('You will need to re-create datafile.\n')
  DEFAULT
   err_WriteF('There were problems updating the tablefile.\n')
 ENDSELECT
 Raise(exception)
ENDPROC

-> file() had to be replaced in order to set the filename for the table file.
-> I saw no reason for the caller to determine the tablefile's name <grin>.

EXPORT PROC file(in) OF tquip
 self.tname:=tablename(in)
 IF self.tfh
  Close(self.tfh); self.tfh:=0
 ENDIF
 SUPER self.file(in)
ENDPROC

-> tablename() lets you change/append a suffix to a filename.  You'll note that
-> it's not associated with any objects, but I've exported it in case someone else
-> might find it useful for some reason.

EXPORT PROC tablename(filename,fappend=0)
 DEF fname=0,f=0,found=0
 IF fappend = 0 THEN fappend:='tab'
 WHILE f<>-1
  f:=InStr(filename,'.',fname+1)
  IF f<>-1
   fname:=f
   found:=1
  ENDIF
 ENDWHILE
 IF found=1
  fname := fname + 1
  f:=String(fname+StrLen(fappend))
  StrCopy(f,filename,fname)
  StrAdd(f,fappend,ALL)
 ELSE
  f:=String(StrLen(fappend)+StrLen(filename)+1)
  StrAdd(f,filename,ALL)
  StrAdd(f,'.',ALL)
  StrAdd(f,fappend,ALL)
 ENDIF
ENDPROC f

-> end() is the automatic deallocator method.

PROC end() OF tquip
 IF self.tfh THEN Close(self.tfh)
 Dispose(self.tname)
 SUPER self.end()
ENDPROC

/**************************************************************************/

-> These are some various bits of data that serve as defaults in the module.  I put
-> them here in order to change them more easily if I have to.

defaultTablename:
 CHAR 's:quip.tab',0
defaultFilename:
 CHAR 's:quip.dat',0
defaultDelimit:
 LONG "@"
