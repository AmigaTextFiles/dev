/* stream.e
 *
 * The stream object of the OOE.  Very important object,
 * really.
 *
 * 'i' refers to inputting things from the stream.
 * 'o' refers to outputting things to the stream.
 * 'limit' denotes how much can be in the buffer before
 *   a flush automatically becomes performed.
 */

OPT MODULE

MODULE 'oomodules/object','oomodules/sort/string'

EXPORT OBJECT stream OF object
 buffer:PTR TO string
 lim
ENDOBJECT

EXPORT PROC init() OF stream
 DEF tmp:PTR TO string
 self.buffer := NEW tmp.new()
ENDPROC

EXPORT PROC select(opt,i) OF stream
 DEF item
 item:=ListItem(opt,i)
 SELECT item
  CASE "lim"
   INC i
   self.limit(ListItem(opt,i))
  CASE "o"
   INC i
   self.o(ListItem(opt,i))
  CASE "oStr"
   INC i
   self.oString(ListItem(opt,i))
 ENDSELECT
ENDPROC i

EXPORT PROC flush() OF stream IS self.derivedClassResponse()

EXPORT PROC i(n=ALL) OF stream
 DEF buffer,out:PTR TO string
 IF self.buffer.length() = 0 THEN RETURN
 out:=self.iString(n)
 buffer:=String(out.length()+1)
 StrCopy(buffer,out.write())
 END out
 RETURN buffer
 /*
 IF self.buffer.length() = 0 THEN RETURN
 buffer:=self.buffer.write()
 size:=IF n=ALL THEN StrLen(buffer) ELSE n
 out:=String(size+1)
 StrCopy(out,buffer)
 DisposeLink(buffer)
 buffer:=String(self.buffer.length()-size+1)
 */
ENDPROC

EXPORT PROC iString(n=ALL) OF stream
 DEF buffer:PTR TO string,tmp:PTR TO string,out:PTR TO string
 IF self.buffer.length() = 0 THEN RETURN
 out:=self.buffer.left(n)
 buffer:=self.buffer.right(self.buffer.length()-n)
 tmp:=self.buffer
 self.buffer:=buffer
 END tmp
 RETURN out
 /*
 IF self.buffer.length() = 0 THEN RETURN
 buffer:=self.buffer.write()
 size := IF n=ALL THEN StrLen(buffer) ELSE n
 out:=String(size+1)
 StrCopy(out,buffer)
 NEW tmp.new(["set",out])
 DisposeLink(out)
 size := StrLen(buffer) - IF n=ALL THEN StrLen(buffer) ELSE n
 out:=String(size+1)
 StrCopy(out,buffer+size)
 bye:=self.buffer
 END bye
 DisposeLink(buffer)
 NEW bye.new(["set",out])
 DisposeLink(out)
 self.buffer := bye
 */
ENDPROC

EXPORT PROC needFlush() OF stream
 RETURN IF self.buffer.length() >= self.lim THEN TRUE ELSE FALSE
ENDPROC

EXPORT PROC o(a) OF stream
 self.buffer.cat(a)
ENDPROC

EXPORT PROC oString(a:PTR TO string) OF stream
 self.buffer.catString(a)
ENDPROC

EXPORT PROC end() OF stream
 DEF tmp:PTR TO string
 tmp := self.buffer
 END tmp
ENDPROC

EXPORT PROC limit(i) OF stream
 self.lim := i
ENDPROC

EXPORT PROC name() OF stream IS 'Stream'
