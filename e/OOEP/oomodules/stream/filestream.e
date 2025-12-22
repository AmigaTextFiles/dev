/* file.e
 * 
 * Streaming file I/O is handled here (hopefully).
 */

OPT MODULE
MODULE 'oomodules/object','oomodules/list/queuestack','oomodules/stream',
       'oomodules/sort/string','dos/dos'

EXPORT OBJECT filestream
 fh
 filename
ENDOBJECT

EXPORT PROC select(opt,i) OF filestream
 DEF item
 item := ListItem(opt,i)
 SELECT item
  CASE "name"
   INC i
   self.open(ListItem(opt,i))
 ENDSELECT
ENDPROC i

EXPORT PROC open(fname,pos=0,offset=OFFSET_BEGINNING) OF filestream
 IF self.fh THEN Close(self.fh)
 self.filename := fname
 self.fh := IF fname = stdout THEN stdout ELSE Open(self.filename,MODE_OLDFILE)
 IF pos THEN Seek(self.fh,pos,offset)
ENDPROC

EXPORT PROC check() OF filestream IS IF self.fh THEN TRUE ELSE FALSE

EXPORT PROC close() OF filestream
 IF self.check() THEN Close(self.fh)
 self.fh := 0
ENDPROC

EXPORT PROC needFlush() OF filestream
ENDPROC

EXPORT PROC pos(where=0,offset=OFFSET_BEGINNING) OF filestream
 IF self.check()=FALSE THEN RETURN
 Seek(self.fh,where,offset)
ENDPROC

EXPORT PROC write(what,size=0) OF filestream
ENDPROC

EXPORT PROC read(where,size=1) OF filestream
ENDPROC

EXPORT PROC flush() OF filestream
ENDPROC

EXPORT PROC end() OF filestream
 self.close()
ENDPROC
