OPT MODULE
OPT EXPORT

MODULE 'oomodules/sort','oomodules/sort/numbers/integer'

-> string.e: a derived object from 'sort' to handle
-> strings.  Much more work needs to be done with this.

OBJECT string OF sort
/****** string/--string-- ******************************************

    NAME 
        string of sort

    ATTRIBUTES
        item -- Pointer to the characters in this string. Is the first
            element of a string chain that is modified by such functions
            as cat(). Various functions work with the string chain, write()
            for example reduces the size of it to one entry.

        len:PTR TO integer -- The length of this instance.

    NOTES
      Through this document there are the following terms used:
          'String' -- this is the object we're talking about.
          string -- a chain of characters ('this is one'). It is terminated
              with a 0-byte. When there is a string required you may
              also provide an estring.

    SEE ALSO
        sort/--sort--
******************************************************************************

History


*/
 item
 len:PTR TO integer  -> I made this 'integer' in order to use the cmp in there.
ENDOBJECT

-> size() gives an idea how much memory you can expect is used

PROC size() OF string IS 12
/****** string/size ******************************************

    NAME 
        size() -- Get size of instance.

    SYNOPSIS
        string.size()

    FUNCTION
        Returns the size of the instance.

******************************************************************************

History


*/

-> name() returns the name of this kind of object.

PROC name() OF string IS 'String'
/****** string/name ******************************************

    NAME 
        name() -- Get name of object.

    SYNOPSIS
        string.name()

    FUNCTION
        Returns the name of the object. In this case 'String'.

******************************************************************************

History


*/

-> We need to have a way to initialize 'len'.

PROC init() OF string
/****** string/init ******************************************

    NAME 
        init() -- Initialize the object.

    SYNOPSIS
        string.init()

    FUNCTION
        Allocates the Integer object used for len.

    SEE ALSO
        integer/--integer--
******************************************************************************

History


*/
 DEF tmp:PTR TO integer
 NEW tmp.new()
 self.len := tmp
ENDPROC


PROC select(opt,i) OF string
/****** string/select ******************************************

    NAME 
        select() -- Select action on initialization.

    SYNOPSIS
        string.select(optionlist,index)

    FUNCTION
        Recognizes the following items:
          "set" -- calls self.cat() with the following item

          "sset" -- calls self.catString() with the following item

    INPUTS
        optionlist -- The optionlist

        index -- The index of the optionlist

    SEE ALSO
        object/select()
******************************************************************************

History


*/
 DEF item
 item:=ListItem(opt,i)
 SELECT item
  CASE "set"
   INC i
   self.cat(ListItem(opt,i))
  CASE "sset"
   INC i
   self.catString(ListItem(opt,i))
 ENDSELECT
ENDPROC i

-> We have to dispose of the string and the 'len' pointer.

PROC end() OF string
/****** string/end ******************************************

    NAME 
      end() -- Global destructor.

    SYNOPSIS
      string.end()

    FUNCTION
      Frees used resources of the instance. It frees the string and the
      length Integer.

    SEE ALSO
      object/end()
******************************************************************************

History


*/
 DEF tmp,str
 str:=self.item
 tmp:=self.len
 DisposeLink(str)   -> get rid of the string.
 END tmp     -> get rid of its length, too
ENDPROC


-> cmp() compares two strings quickly.. but it doesn't handle international characters.
-> Many improvements could be made to this, I'm sure, but it has the virtue of being
-> fairly quick.  Perhaps locale.library support would be nice.

PROC cmp(item:PTR TO string) OF string
/****** string/cmp ******************************************

    NAME 
        cmp() -- Compare to another 'String'.

    SYNOPSIS
        string.cmp(item:PTR TO string)

    FUNCTION
        Compares itself to another 'String' via E's builtin OstrCmp().

    INPUTS
        item:PTR TO string -- The 'String' to compare to.

    RESULT
        'Ordered String Compare' returns 1 if string2>string1, 0 for equal
        and 1 for less.

    NOTES
        cmp() compares two strings quickly.. but it doesn't handle
        international characters. Many improvements could be made to this,
        I'm sure, but it has the virtue of being fairly quick.  Perhaps
        locale.library support would be nice.

    SEE ALSO
        E reference/OstrCmp()
******************************************************************************

History


*/
 DEF i,inner,outer
 inner:=self.write()
 outer:=item.write()
 RETURN OstrCmp(inner,outer)
ENDPROC

-> set() lets you put a value into the string.

PROC set(in) OF string
/****** string/set ******************************************

    NAME 
        set() -- Set the 'String''s contents.

    SYNOPSIS
        string.set(in)

    FUNCTION
        Sets the contents of itself. An already present string will be freed
        first.

    INPUTS
        in -- Pointer to normal 0-terminated string. Could be an estring
            as well.

    EXAMPLE

        PROC main()
        DEF string:PTR TO string

          NEW string.new()    -> allocate and initialize
          string.set('build no schools, construct no roads')
          string.cat('mark them as fools, let ignorance rule')

          WriteF('\s\n', string.write())  ->get string and write it

        ENDPROC

    SEE ALSO
        cat()
******************************************************************************

History


*/
 IF self.item THEN DisposeLink(self.item)
 self.len.set(0)
 self.cat(in)
ENDPROC

-> length() returns the length of the string.

PROC length() OF string
/****** string/length ******************************************

    NAME 
        length() -- Get length of 'String'.

    SYNOPSIS
        string.length()

    FUNCTION
        Gets the length of itself.

    RESULT
        Length of itself.

    SEE ALSO
        integer/get()
******************************************************************************

History


*/
 RETURN self.len.get()
ENDPROC


PROC write() OF string
/****** string/write ******************************************

    NAME 
      write() -- Turn 'String' into printable string.

    SYNOPSIS
      string.write()

    FUNCTION
      If you want to turn 'String' into a normal string (or estring) so
      you can work with it as if it was a normal series of characters you
      should call this function. It returns a pointer to an estring that
      contains 'String''s contents.

    RESULT
      Pointer to estring containing

    NOTES
      Works on the internal string chain and builds one continuous string
      from it. The string chain contains only one entry after the call
      of this proc.

    EXAMPLE
        PROC main()
        DEF string:PTR TO string

          NEW string.new()    -> allocate and initialize
          string.set('build no schools, construct no roads')
          string.cat('mark them as fools, let ignorance rule')

          WriteF('\s\n', string.write())  ->get string and write it

        ENDPROC

******************************************************************************

History


*/
 DEF out,this,next=0
 this:=self.item
 next:=Next(this)
 IF next
  out:=String(self.len.get()+1)
  WHILE next
   next:=Next(this)
   StrAdd(out,this)
   this:=next
  ENDWHILE
  DisposeLink(self.item)
  self.item:=out
 ELSE
  out:=self.item
 ENDIF
ENDPROC out


PROC get() OF string
/****** string/get ******************************************

    NAME 
        get() -- Get 'String''s item.

    SYNOPSIS
        string.get()

    FUNCTION
        Gets its item. Only for internal use, if you want to print the 'String'
        or work with it you have to call write().

    RESULT
        string.item

    SEE ALSO
        write()
******************************************************************************

History


*/
 RETURN self.item
ENDPROC


PROC cat(in) OF string
/****** string/cat ******************************************

    NAME 
        cat() -- Add normal string.

    SYNOPSIS
        string.cat(in)

    FUNCTION
        Adds a normal string to itself. This can be a 0-terminated array of
        char or an estring. The string is copied and added at the end.

    INPUTS
        in -- string to add.

    RESULT
        Pointer to the estring copy of the string to add.

    EXAMPLE
        PROC main()
        DEF string:PTR TO string

          NEW string.new()    -> allocate and initialize
          string.set('build no schools, construct no roads ')
          string.cat('mark them as fools, let ignorance rule')

          WriteF('\s\n', string.write())  ->get string and write it

        ENDPROC


    SEE ALSO
        concat(), catString(), concatString()
******************************************************************************

History


*/
 DEF tmp,count
 count:=StrLen(in)
 tmp := String(count+1)
 StrCopy(tmp,in)
 self.concat(tmp,count)
ENDPROC tmp


PROC concat(in,count=0) OF string
/****** string/concat ******************************************

    NAME 
        concat() -- Add string to the internal string chain.

    SYNOPSIS
        string.concat(in,count=0)

    FUNCTION
        Adds a string to the internal string chain. The length is set to the
        new length.

    INPUTS
        in -- normal string to add.

        count -- the length of in. Can be left 0 normally, in that case the
            length is found out by StrLen().

    NOTES
        Mainly for internal use. Mortal beings use catString().

    SEE ALSO
        cat(), concatString(), catString()
******************************************************************************

History


*/
 DEF tmp,next
 IF self.item
  next:=tmp:=self.item
  WHILE next
   IF next:=Next(tmp) THEN tmp:=next
  ENDWHILE
  Link(tmp,in)
 ELSE
  self.item:=in
 ENDIF
 IF count THEN self.len.add(count) ELSE self.len.add(StrLen(in))
ENDPROC


PROC concatString(in:PTR TO string) OF string
/****** string/concatString ******************************************

    NAME 
        concatString() -- Add 'String' to the internal string chain.

    SYNOPSIS
        string.concatString(in:PTR TO string)

    FUNCTION
        Adds a 'String' to the internal string chain. The length is set to the
        new length.

    INPUTS
        in -- 'String' to add.

    RESULT
        Pointer to new string or 0 if in was NIL.

    NOTES
        Mainly for internal use. Mortal beings use catString().

    SEE ALSO
        cat(), concat(), catString()
******************************************************************************

History


*/
 IF in THEN self.concat(in.item,in.length()) ELSE RETURN 0
ENDPROC self.item


PROC catString(in:PTR TO string) OF string
/****** string/catString ******************************************

    NAME 
        catString() -- Cat a 'String' to another.

    SYNOPSIS
        catString(in:PTR TO string)

    FUNCTION
        Puts a 'String' at the end of itself.

    INPUTS
        in:PTR TO string -- 'String' to add.

    RESULT
        item of itself.

    SEE ALSO
        concatString()

******************************************************************************

History


*/
 IF in THEN self.cat(in.write()) ELSE RETURN 0
ENDPROC self.item


PROC upper() OF string
/****** string/upper ******************************************

    NAME 
      upper() -- Change the case of each character to upper.

    SYNOPSIS
      string.upper()

    FUNCTION
      The case of each character in the 'String' is turned to upper.

    NOTES
      Calls write().

******************************************************************************

History


*/
 self.write()
 UpperStr(self.item)
ENDPROC


PROC lower() OF string
/****** string/lower ******************************************

    NAME 
      lower() -- Change the case of each character to lower.

    SYNOPSIS
      string.lower()

    FUNCTION
      The case of each character in the 'String' is turned to lower.

    NOTES
      Calls write().

******************************************************************************

History


*/
 self.write()
 LowerStr(self.item)
ENDPROC


PROC trimmed() OF string
/****** string/trimmed ******************************************

    NAME 
        trimmed() -- Trim whitespace from 'String'.

    SYNOPSIS
        string.trimmed()

    FUNCTION
        Trims itself, i.e. returns a string that starts with the first
        non-whitespace character.

    RESULT
        Pointer to 'String' which contains the trimmed contents of self.
        It is a newly created 'String', you have to END() it yourself when
        you don't need it anymore.

******************************************************************************

History


*/
 DEF out,tmp,spank:PTR TO string
 self.write()
 out:=String(self.length()+1)
 tmp:=TrimStr(self.item)
 StrCopy(out,tmp)
 NEW spank.new(["set",out])
 DisposeLink(out)
ENDPROC spank


PROC find(in:PTR TO string) OF string
/****** string/find ******************************************

    NAME 
        find() -- Test if 'String' is in 'String'.

    SYNOPSIS
        string.find(in:PTR TO string)

    FUNCTION
        Searches a 'String' in itself.

    INPUTS
        in:PTR TO string -- 'String' to search for

    RESULT
        TRUE if in is in self, FALSE otherwise.

    NOTES
        Calls write() on in.

******************************************************************************

History


*/
 DEF me,he
 me:=self.write()
 he:=in.write()
 RETURN IF InStr(me,he,0)<>-1 THEN TRUE ELSE FALSE
ENDPROC


PROC asInteger() OF string
/****** string/asInteger ******************************************

    NAME 
        asInteger() -- Turn 'String' to Integer

    SYNOPSIS
        string.asInteger()

    FUNCTION
        Tries to turn itself to an Integer.

    RESULT
        PTR TO integer -- The integer that was in 'String'.

    NOTES
        Only call when you know that the string contains an integer. There
        is actually no way to test if the proc ran successful over the
        strings contents.

        Call write().

******************************************************************************

History


*/
 DEF valstring,value,read,out:PTR TO integer
 valstring:=self.write()
 value,read:=Val(valstring)
 NEW out.new(["set",value])
ENDPROC out


PROC right(n) OF string
/****** string/right ******************************************

    NAME 
        right() -- Get right part of 'String'.

    SYNOPSIS
        string.right(length)

    FUNCTION
        Gets part from the right side of itself and builds a new 'String'
        from it.

    INPUTS
        length -- get how many characters.

    RESULT
        PTR TO string -- a freshly created 'String' that contains the desired
            string part.

    EXAMPLE

        PROC main()
        DEF mainString:PTR TO string,
            partOfString:PTR TO string

          NEW mainString.new(["set", 'down in Los Angeles'])

          partOfString := mainString.right(11)

          WriteF('\s\n', partOfString.write())

          END partOfString
          END mainString
        ENDPROC

    SEE ALSO
        left(), middle()
******************************************************************************

History


*/
 RETURN self.middle(self.length()-n-1,n)
ENDPROC


PROC middle(pos,len=ALL) OF string
/****** string/middle ******************************************

    NAME 
        middle() -- Get a part of 'String'.

    SYNOPSIS
        string.middle(position,length)

    FUNCTION
        Gets a part from itself and builds a new 'String' from it.

    INPUTS
        position -- Start at what position of itself.

        length -- get how many characters from position up to the end.

    RESULT
        PTR TO string -- a freshly created 'String' that contains the desired
            string part.

    EXAMPLE

        PROC main()
        DEF mainString:PTR TO string,
            partOfString:PTR TO string

          NEW mainString.new(["set", 'down in Los Angeles'])

          partOfString := mainString.middle(5,2)

          WriteF('\s\n', partOfString.write())

          END partOfString
          END mainString
        ENDPROC

    SEE ALSO
        left(), right()
******************************************************************************

History


*/
 DEF out:PTR TO string,buffer,other
 IF pos>=self.length() THEN RETURN 0
 buffer:=String(IF len=ALL THEN self.length()-pos ELSE len)
 other:=self.write()
 MidStr(buffer,other,pos,len)
 NEW out.new(["set",buffer])
 DisposeLink(buffer)
ENDPROC out


PROC left(n) OF string
/****** string/left ******************************************

    NAME 
        left() -- Get left part of 'String'.

    SYNOPSIS
        string.left(length)

    FUNCTION
        Gets a part from the left side of itself and builds a new 'String'
        from it.

    INPUTS
        length -- get how many characters.

    RESULT
        PTR TO string -- a freshly created 'String' that contains the desired
            string part.

    EXAMPLE

        PROC main()
        DEF mainString:PTR TO string,
            partOfString:PTR TO string

          NEW mainString.new(["set", 'down in Los Angeles'])

          partOfString := mainString.left(4)

          WriteF('\s\n', partOfString.write())

          END partOfString
          END mainString
        ENDPROC

    SEE ALSO
        middle(), right()
******************************************************************************

History


*/
 RETURN self.middle(0,n)
ENDPROC

