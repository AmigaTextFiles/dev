 check any
		arguments that were shift-selected with your icon.
		See WbArgs.e in the Src/Args dir how to
		make good use of wbmessage.


e.doc/wbmessage           e.doc/wbmessage

6E. built-in system variables
----------------------------
Following global variables are always available in you program,
they're called system variables.

arg     As discussed above, contains a pointer to a zero-terminated
		string, containing the command-line arguments. Don't use this
		variable if you wish to use ReadArgs() instead.
stdout      Contains a file-handle to the standard output (and input).
		If your program was started from the workbench, so no
		shell-output is available, WriteF() will open a
		CON: window for you and put its file handle here.
stdin       file-handle of standard input
conout      This is where that file handle is kept, and the console
		window will be automatically closed upon exit of your
		program. (see >> 9A <<, WriteF(), on how to use these two variables
		properly).
execbase,   These four variables are always provided with their
dosbase,    correct values.
gfxbase,
intuitionbase
stdrast     Pointer to standard rastport in use with your program,
		or NIL. The built-in graphics functions like Line()
		make use of this variable.
wbmessage   Contains a ptr to a message you got if you started
		from wb, else NIL. May be used as a boolean to detect
		if you started from workbench, or even check any
		arguments that were shift-selected with your icon.
		See WbArgs.e in the Src/Args dir how to
		make good use of wbmessage.


e.doc/CONST           e.doc/CONST

7A. const (CONST)
-----------------
syntax:     CONST <declarations>,...

Enables you to declare a constant. A declaration looks like:
<ident>=<value>
constants must be uppercase, and will in the rest of the program be
treated as <value>. Example:

CONST MAX_LINES=100, ER_NOMEM=1, ER_NOFILE=2

You cannot declare constants in terms of others that are being
declared in the same CONST statement: put these in the next.

CONST, ENUM and SET declarations are always global, i.e. it is not
possible to declare constants local to a PROC. The best place for
constant declarations is at the top of your source, but EC also
allows you to put them between two PROCs, for example.


e.doc/ENUM           e.doc/ENUM

7B. enumerations (ENUM)
-----------------------
Enumerations are a specific type of constant that need not be given values,
as they simply range from 0 .. n, the first being 0. At any given point
in an enumeration, you may use the '=<value>' notation to set or reset
the counter value. Example:

ENUM ZERO, ONE, TWO, THREE, MONDAY=1, TUESDAY, WEDNESDAY

ENUM ER_NOFILE=100, ER_NOMEM, ER_NOWINDOW


e.doc/SET           e.doc/SET

7C. sets (SET)
--------------
Sets are again like enumerations, with the difference that instead of
increasing a value (0,1,2,...) they increase a bitnumber (0,1,2,...) and
thus have values like (1,2,4,8,...). This has the added advantage that
they may be used as sets of flags, as the keyword says.
Suppose a set like the one below to describe properties of a window:

SET SIZEGAD,CLOSEGAD,SCROLLBAR,DEPTH

to initialise a variable to properties DEPTH and SIZEGAD:

winflags:=DEPTH OR SIZEGAD

to set an additional SCROLLBAR flag:

winflags:=winflags OR SCROLLBAR

and to test if either of both of two properties hold:

IF winflags AND (SCROLLBAR OR DEPTH) THEN /* whatever */


e.doc/TRUE           e.doc/TRUE

7D. built-in constants
---------------------
Following are built-in constants that may be used:

TRUE,FALSE  Represent the boolean values (-1,0)
NIL     (=0), the uninitialised pointer.
ALL     Used with string functions like StrCopy() to copy all characters
GADGETSIZE  Minimum size in bytes to hold one gadget; (see >> 9D <<, Gadget())
OLDFILE,NEWFILE Mode-parameters for use with Open()
EMPTY       used with methods (might be keyword in the future)
STRLEN      Always has the value of the length of the last immediate
		string used. Example:

		Write(handle,'hi folks!',STRLEN)      /* =9 */


e.doc/FALSE           e.doc/FALSE

7D. built-in constants
---------------------
Following are built-in constants that may be used:

TRUE,FALSE  Represent the boolean values (-1,0)
NIL     (=0), the uninitialised pointer.
ALL     Used with string functions like StrCopy() to copy all characters
GADGETSIZE  Minimum size in bytes to hold one gadget; (see >> 9D <<, Gadget())
OLDFILE,NEWFILE Mode-parameters for use with Open()
EMPTY       used with methods (might be keyword in the future)
STRLEN      Always has the value of the length of the last immediate
		string used. Example:

		Write(handle,'hi folks!',STRLEN)      /* =9 */


e.doc/NIL           e.doc/NIL

7D. built-in constants
---------------------
Following are built-in constants that may be used:

TRUE,FALSE  Represent the boolean values (-1,0)
NIL     (=0), the uninitialised pointer.
ALL     Used with string functions like StrCopy() to copy all characters
GADGETSIZE  Minimum size in bytes to hold one gadget; (see >> 9D <<, Gadget())
OLDFILE,NEWFILE Mode-parameters for use with Open()
EMPTY       used with methods (might be keyword in the future)
STRLEN      Always has the value of the length of the last immediate
		string used. Example:

		Write(handle,'hi folks!',STRLEN)      /* =9 */


e.doc/ALL           e.doc/ALL

7D. built-in constants
---------------------
Following are built-in constants that may be used:

TRUE,FALSE  Represent the boolean values (-1,0)
NIL     (=0), the uninitialised pointer.
ALL     Used with string functions like StrCopy() to copy all characters
GADGETSIZE  Minimum size in bytes to hold one gadget; (see >> 9D <<, Gadget())
OLDFILE,NEWFILE Mode-parameters for use with Open()
EMPTY       used with methods (might be keyword in the future)
STRLEN      Always has the value of the length of the last immediate
		string used. Example:

		Write(handle,'hi folks!',STRLEN)      /* =9 */


e.doc/GADGETSIZE           e.doc/GADGETSIZE

7D. built-in constants
---------------------
Following are built-in constants that may be used:

TRUE,FALSE  Represent the boolean values (-1,0)
NIL     (=0), the uninitialised pointer.
ALL     Used with string functions like StrCopy() to copy all characters
GADGETSIZE  Minimum size in bytes to hold one gadget; (see >> 9D <<, Gadget())
OLDFILE,NEWFILE Mode-parameters for use with Open()
EMPTY       used with methods (might be keyword in the future)
STRLEN      Always has the value of the length of the last immediate
		string used. Example:

		Write(handle,'hi folks!',STRLEN)      /* =9 */


e.doc/OLDFILE           e.doc/OLDFILE

7D. built-in constants
---------------------
Following are built-in constants that may be used:

TRUE,FALSE  Represent the boolean values (-1,0)
NIL     (=0), the uninitialised pointer.
ALL     Used with string functions like StrCopy() to copy all characters
GADGETSIZE  Minimum size in bytes to hold one gadget; (see >> 9D <<, Gadget())
OLDFILE,NEWFILE Mode-parameters for use with Open()
EMPTY       used with methods (might be keyword in the future)
STRLEN      Always has the value of the length of the last immediate
		string used. Example:

		Write(handle,'hi folks!',STRLEN)      /* =9 */


e.doc/NEWFILE           e.doc/NEWFILE

7D. built-in constants
---------------------
Following are built-in constants that may be used:

TRUE,FALSE  Represent the boolean values (-1,0)
NIL     (=0), the uninitialised pointer.
ALL     Used with string functions like StrCopy() to copy all characters
GADGETSIZE  Minimum size in bytes to hold one gadget; (see >> 9D <<, Gadget())
OLDFILE,NEWFILE Mode-parameters for use with Open()
EMPTY       used with methods (might be keyword in the future)
STRLEN      Always has the value of the length of the last immediate
		string used. Example:

		Write(handle,'hi folks!',STRLEN)      /* =9 */


e.doc/EMPTY           e.doc/EMPTY

7D. built-in constants
---------------------
Following are built-in constants that may be used:

TRUE,FALSE  Represent the boolean values (-1,0)
NIL     (=0), the uninitialised pointer.
ALL     Used with string functions like StrCopy() to copy all characters
GADGETSIZE  Minimum size in bytes to hold one gadget; (see >> 9D <<, Gadget())
OLDFILE,NEWFILE Mode-parameters for use with Open()
EMPTY       used with methods (might be keyword in the future)
STRLEN      Always has the value of the length of the last immediate
		string used. Example:

		Write(handle,'hi folks!',STRLEN)      /* =9 */


e.doc/STRLEN           e.doc/STRLEN

7D. built-in constants
---------------------
Following are built-in constants that may be used:

TRUE,FALSE  Represent the boolean values (-1,0)
NIL     (=0), the uninitialised pointer.
ALL     Used with string functions like StrCopy() to copy all characters
GADGETSIZE  Minimum size in bytes to hold one gadget; (see >> 9D <<, Gadget())
OLDFILE,NEWFILE Mode-parameters for use with Open()
EMPTY       used with methods (might be keyword in the future)
STRLEN      Always has the value of the length of the last immediate
		string used. Example:

		Write(handle,'hi folks!',STRLEN)      /* =9 */


e.doc/LONG           e.doc/LONG

8B. the basic type (LONG/PTR)
-----------------------------
There's only one basic, non-complex variable type in E, which is the
32bit type LONG. As this is the default type, it may be declared as:

DEF a:LONG             or just:            DEF a

This variable type may hold what's known as CHAR/INT/PTR/LONG types in other
languages. A special variation of LONG is the PTR type. This type
is compatible with LONG, with the only difference that it specifies
to what type it is a pointer. By default, the type LONG is specified
as PTR TO CHAR. Syntax:

DEF <var>:PTR TO <type>

where type is either a simple type or a compound type. Example:

DEF x:PTR TO INT, myscreen:PTR TO screen

Note that 'screen' is the name of an object as defined in intuition/screens.m
For example, if you open your own screen with:

myscreen:=OpenS(...   etc.

you may use the pointer myscreen as in 'myscreen.rastport'. However,
if you do not wish to do anything with the variable until you call
CloseS(myscreen), you may simply declare it as

DEF myscreen

Variable declarations may have optional initialisations, but only
integer constants, i.e. no full expression:

DEF a=1, b=NIL:PTR TO textfont


e.doc/PTR           e.doc/PTR

8B. the basic type (LONG/PTR)
-----------------------------
There's only one basic, non-complex variable type in E, which is the
32bit type LONG. As this is the default type, it may be declared as:

DEF a:LONG             or just:            DEF a

This variable type may hold what's known as CHAR/INT/PTR/LONG types in other
languages. A special variation of LONG is the PTR type. This type
is compatible with LONG, with the only difference that it specifies
to what type it is a pointer. By default, the type LONG is specified
as PTR TO CHAR. Syntax:

DEF <var>:PTR TO <type>

where type is either a simple type or a compound type. Example:

DEF x:PTR TO INT, myscreen:PTR TO screen

Note that 'screen' is the name of an object as defined in intuition/screens.m
For example, if you open your own screen with:

myscreen:=OpenS(...   etc.

you may use the pointer myscreen as in 'myscreen.rastport'. However,
if you do not wish to do anything with the variable until you call
CloseS(myscreen), you may simply declare it as

DEF myscreen

Variable declarations may have optional initialisations, but only
integer constants, i.e. no full expression:

DEF a=1, b=NIL:PTR TO textfont

8C. the simple type (CHAR/INT/LONG)
-----------------------------------
The simple types CHAR (8bit) and INT (16bit) may not be used as types
for a basic (single) variable; the reason for this must be clear by now.
However they may be used as data type to build ARRAYs from, set PTRs to,
use in the definition of OBJECTs etc. See those for examples.


e.doc/CHAR           e.doc/CHAR

8C. the simple type (CHAR/INT/LONG)
-----------------------------------
The simple types CHAR (8bit) and INT (16bit) may not be used as types
for a basic (single) variable; the reason for this must be clear by now.
However they may be used as data type to build ARRAYs from, set PTRs to,
use in the definition of OBJECTs etc. See those for examples.


e.doc/INT           e.doc/INT

8C. the simple type (CHAR/INT/LONG)
-----------------------------------
The simple types CHAR (8bit) and INT (16bit) may not be used as types
for a basic (single) variable; the reason for this must be clear by now.
However they may be used as data type to build ARRAYs from, set PTRs to,
use in the definition of OBJECTs etc. See those for examples.


e.doc/ARRAY           e.doc/ARRAY

8D. the array type (ARRAY)
--------------------------
ARRAYs are declared by specifying their length (in bytes):

DEF b[100]:ARRAY

this defines an array of 100 bytes. Internally, 'b' is a variable of
type LONG and a PTR to this memory area.
Default type of an array-element is CHAR, it may be anything by specifying:

DEF x[100]:ARRAY OF LONG
DEF mymenus[10]:ARRAY OF newmenu

where "newmenu" is an example of a structure, called OBJECTs in E.
Array access is very easy with:   <var>[<sexp>]

b[1]:="a"
z:=mymenus[a+1].mutualexclude

Note that the index of an array of size n ranges from 0 to n-1,
and not from 1 to n.
Note that ARRAY OF <type> is compatible with PTR TO <type>, with the
only difference that the variable that is an ARRAY is already
initialised.


e.doc/STRING           e.doc/STRING

8E. the complex type (STRING/LIST)
----------------------------------

E has a datatype STRING. This is a string, from now on called 'Estring',
that may be modified and changed in size, as opposed to normal 'strings',
which will be used here for any zero-terminated sequence. Estrings are
downward compatible with strings, but not the other way around, so if an
argument requests a normal string, it can be either of them. If an Estring
is requested, don't use normal strings. Example of usage:

DEF s[80]:STRING, n                -> s is an estring with a maxlen of 80
ReadStr(stdout,s)                  -> read input from the console
n:=Val(s)                          -> get a number out of it
  -> etc.

Note that all string functions will handle cases where string tends to
get longer than the maximum length correctly;

DEF s[5]:STRING
StrAdd(s,'this string is longer than 5 characters',ALL)

s will contain just 'this '.
A string may also be allocated dynamically from system memory
with the function String(), (note: the pointer returned from this function
must always be checked against NIL)

- STRINGs. Similar to arrays, but different in the respect that they may
  only be changed by using E string functions, and that they contain
  length and maxlength information, so string functions may alter them in a
  safe fashion, i.e: the string can never grow bigger than the memory
  area it is in. Definition:

  DEF s[80]:STRING

  The STRING datatype (called an estring) is backwards compatible with
  PTR TO CHAR and of course ARRAY OF CHAR, but not the other way around.
  (see >> 9B << on string functions for more details).

- LISTs. These may be interpreted as a mix between a STRING and an ARRAY
  OF LONG. I.e: this data structure holds a list of LONG variables which may
  be extended and shortened like STRINGs. Definition:

  DEF x[100]:LIST

  A powerful addition to this datatype is that it also has a 'constant'
  equivalent [], like STRINGs have ''. LIST is backward compatible with
  PTR TO LONG and of course ARRAY OF LONG, but not the other way around.
  (see >> 9C << and 2G) for more on this.


e.doc/LIST           e.doc/LIST

8E. the complex type (STRING/LIST)
----------------------------------
Lists are like strings, only they consist of LONGs, not CHARs.
They may also be allocated either global, local or dynamic:

DEF mylist[100]:LIST         /* local or global */
DEF a
a:=List(10)                  /* dynamic */

(note that in the latter case, pointer 'a' may contain NIL)
Just as strings may be represented as constants in expressions, lists
have their constant equivalent:

[1,2,3,4]

The value of such an expression is a pointer to an already initialised list.
Special feature is that they may have dynamic parts, i.e, which will
be filled in at runtime:

a:=3
[1,2,a,4]

moreover, lists may have some other type than the default LONG, like:

[1,2,3]:INT
[65,66,67,0]:CHAR                    /* equivalent with   'ABC'   */
['topaz.font',8,0,0]:textattr
OpenScreenTagList(NIL,[SA_TITLE,'MyScreen',TAG_DONE])

As shown in the latter examples, lists are extremely useful with
system functions: they are downward compatible with an ARRAY OF LONG,
and object-typed ones can be used wherever a system function needs
a pointer to some structure, or an array of those.
Taglists and vararg functions may also be used this way.
NOTEZ BIEN: all list functions only work with LONG lists, typed-lists
are only convenient in building complex data structures and expressions.

As with strings, a certain hierarchy holds:
list variables -> constant lists -> array of long/ptr to long
When a function needs an array of long you might just as well give a list
as argument, but when a function needs a listvar, or a constant list,
then an array of long won't do.

It's important that one understands the power of lists and in particular
typed-lists: these can save you lots of trouble when building just
about any data-structure. Try to use these lists in your own programs,
and see what function they have in the example-programs.

summary:

[<item>,<item>,... ]        immediate list (of LONGs, use with listfuncs)
[<item>,<item>,... ]:<type> typed list (just to build data structures)

If <type> is a simple type like INT or CHAR, you'll just have the
initialised equivalent of ARRAY OF <type>, if <type> is an object-name,
you'll be building initialised objects, or ARRAY OF <object>, depending
on the length of the list.

If you write    [1,2,3]:INT   you'll create a data structure of 6 bytes,
of 3 16bit values to be precise. The value of this expression then
is a pointer to that memory area. Same works if, for example, you have
an object like:

OBJECT myobject
  a:LONG, b:CHAR, c:INT
ENDOBJECT

writing    [1,2,3]:myobject     would then mean creating a data structure
in memory of 8 bytes, with the first four bytes being a LONG with value 1,
the following byte a CHAR with value 2, then a pad byte, and the last
two bytes an INT (2 bytes) with value 3. you could also write:

[1,2,3,4,5,6,7,8,9]:myobject

you would be creating an ARRAY OF myobject with size 3. Note that such
lists don't have to be complete (3,6,9 and so on elements), you may
create partial objects with lists of any size

One last note on data size: on the amiga, you may rely on the fact that
a structure like 'myobject' has size 8, and that it has a pad byte
to have word (16bit) alignment. It is however very likely that an
E-compiler for 80x86 architectures will not use the pad byte and make
it a 7byte structure, and that an E-compiler for a sun-sparc architecture
(if I'm not mistaken) will try to align on 32bit boundaries, thus make
it a 10 or 12 byte structure. Some microprocessors (they are rare, but
they exist) even use (36:18:9) as numbers of bits for their types
(LONG:INT:CHAR), instead of (32:16:8) as we're used to. So don't make too
great an assumption on the structure of OBJECTs and LISTs if you want to
write code that stands a chance of being portable or doesn't rely on side
effects.

- LISTs. These may be interpreted as a mix between a STRING and an ARRAY
  OF LONG. I.e: this data structure holds a list of LONG variables which may
  be extended and shortened like STRINGs. Definition:

  DEF x[100]:LIST

  A powerful addition to this datatype is that it also has a 'constant'
  equivalent [], like STRINGs have ''. LIST is backward compatible with
  PTR TO LONG and of course ARRAY OF LONG, but not the other way around.
  (see >> 9C << and 2G) for more on this.


e.doc/OBJECT           e.doc/OBJECT

8F. the compound type (OBJECT)
------------------------------
OBJECTs are like a struct/class in C/C++ or a RECORD in pascal. Example:

OBJECT myobj
  a:LONG
  b:CHAR
  c:INT
ENDOBJECT

This defines a data structure consisting of three elements. Syntax:

OBJECT <objname>
  <membername> [ : <type> ]           /* any number of these */
ENDOBJECT

where type is one of the following:

CHAR/INT/LONG/<object>
PTR TO CHAR/INT/LONG/<object>
ARRAY OF CHAR/INT/LONG/<object>

(ARRAY is short for ARRAY OF CHAR)

like DEF declarations, omitting the type means :LONG.

Note that <membername> need not be a unique identifier,
it may be in other objects too. There are lots of ways to use objects:

DEF x:myobj                      /* x is a structure */
DEF y:PTR TO myobj               /* y is just a pointer to it */
DEF z[10]:ARRAY OF myobj

y:=[-1,"a",100]:myobj            /* typed lists */

IF y.b="a" THEN /* ... */

z[4].c:=z[d+1].b++

(see >> 4F << and other parts of chapter 4 for these)

ARRAYs in objects are always rounded to even sizes, and put on
even offsets:

OBJECT mystring
  len:CHAR, data[9]:ARRAY
ENDOBJECT

SIZEOF mystring is 12, and "data" starts at offset 2.

'PTR TO' is the only type in OBJECTs that may refer to yet undeclared
other objects.

(see >> 14A << for all other OBJECT features that are somehow OO related)

14A. OO features in E
---------------------
The features descibed here in this chapter are grouped as such
since they constitute what is generally seen as the three essential
main components that make a language 'Object Oriented' (i.e.
inheritance - data hiding - polymorhism). However in E they are
by no means a 'separate chapter' since each can be used in any
way with other E features.

14B. object inheritance
-----------------------
it's always annoying not being able to express dependencies between
OBJECTs, or reuse code that works on a particular OBJECT with a bigger
OBJECT that encapsulates the first. Object Inheritance allows you
to do just that in E. when you have an object a:

OBJECT a
  next, index, term
ENDOBJECT

you can make a new object b that has the same properties
as a (and is compatible with code for a):

OBJECT b OF a
  bla, x, burp
ENDOBJECT

is equivalent to:

OBJECT b
  next, index, term         /* from a */
  bla, x, burp
ENDOBJECT

with DEF p:b, you can directly not only access p.bla as usual,
but also p.next.

as an example, if one would have a module with an OBJECT to
implement a certain datatype (for example a doubly-linked-list),
and PROCs to support it, one could simply inherit from it, adding
own data to the object, and use the _existing_ functions to
manipulate the list. However, it's only in combination with
methods (descibed below), inheritance can show its real power.


e.doc/WriteF           e.doc/WriteF

9A. io functions
----------------

	WriteF(formatstring,args,...)
	PrintF(formatstring,args,...)

prints a string (which may contain formatting codes) to stdout. Zero
to unlimited arguments may be added. Note that, as formatstrings may
be created dynamically, no check on the correct number of arguments
is (can be) made. Examples:

WriteF('Hello, World!\n')   /* just write a lf terminated string */

WriteF('a = \d \n',a)       /* writes: "a = 123", if a was 123 */

(see >> 2F << about strings for more).
NOTE: if stdout=NIL, for example if your program was started from the
Workbench, WriteF() will create an output window, and put the handle
in conout and stdout. This window will automatically be closed on
exit of the program, after the user typed a <return>. WriteF() is the
only function that will open this window, so if you want to do IO
on stdout, and want to be sure stdout<>NIL, perform a "WriteF('')"
as first instruction of your program to ensure output. If you want
to open a console window yourself, you may do so by placing the resulting
file handle in the 'stdout' and 'conout' variables, as your window will
then be closed automatically upon exit. If you wish to close this window
manually, make sure to set 'conout' back to NIL, to signal E that there's
no console window to be closed. PrintF() is the same as WriteF only
uses the v37+ buffered IO.
both return the length of the string that was printed.

\n      a linefeed (ascii 10)
\a or ''    an apostrophe ' (the one used for enclosing the string)
\q      a doublequote: "
\e      escape (ascii 27)
\t      tab (ascii 9)
\\      a backslash
\0      a zero byte. Of rare use, as ALL strings are 0-terminated
\b      a carriage return (ascii 13)

Additionally, when used with formatting functions:

\d  print a decimal number
\h  print a hexadecimal
\s  print a string
\c  print a character
\z  set fill byte to '0' character
\l  format to left of field
\r  format to right of field (these last two act as toggles)

Field specifiers may follow the \d,\h and \s codes:

[x] specify exact field width x
(x,y)   specify minimum x and maximum y (strings only)

Example: print a hexadecimal number with 8 positions and leading zeroes:
WriteF('\z\h[8]\n',num)

A string may be extended over several lines by trailing them with a "+"
sign and a <lf>:

'this specifically long string ' +
'is separated over two lines'


e.doc/PrintF           e.doc/PrintF

9A. io functions
----------------

	WriteF(formatstring,args,...)
	PrintF(formatstring,args,...)

prints a string (which may contain formatting codes) to stdout. Zero
to unlimited arguments may be added. Note that, as formatstrings may
be created dynamically, no check on the correct number of arguments
is (can be) made. Examples:

WriteF('Hello, World!\n')   /* just write a lf terminated string */

WriteF('a = \d \n',a)       /* writes: "a = 123", if a was 123 */

(see >> 2F << about strings for more).
NOTE: if stdout=NIL, for example if your program was started from the
Workbench, WriteF() will create an output window, and put the handle
in conout and stdout. This window will automatically be closed on
exit of the program, after the user typed a <return>. WriteF() is the
only function that will open this window, so if you want to do IO
on stdout, and want to be sure stdout<>NIL, perform a "WriteF('')"
as first instruction of your program to ensure output. If you want
to open a console window yourself, you may do so by placing the resulting
file handle in the 'stdout' and 'conout' variables, as your window will
then be closed automatically upon exit. If you wish to close this window
manually, make sure to set 'conout' back to NIL, to signal E that there's
no console window to be closed. PrintF() is the same as Wrrg     As discussed above, contains a pointer to a zero-terminated
		string, containing the command-line arguments. Don't use this
		variable if you wish to use ReadArgs()