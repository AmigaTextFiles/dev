LIBRARY 'bla.library', 37, 1, 'bla.library by me 2001'

-> YAEC1.9a : Now opens exec,dos,gfx,intui automatically!
->            Printing is possible! (uses callers output)

/* NOTE1 : LIBRARY mode is not for beginners */

/* NOTE3 : do NOT pass out exceptions from librarycode */

/* NOTE4 : filename of library will be src-filename without .e */

/* NOTE5 : unlike ec3.3a, yaec libraries uses SHARED globals */
/* not shared mode may or may not happen depending on things and other stuff */

/* NOTE6 : .fd file gets created automatically, use bin/fdtool to get .ext */

/* our public entrypoints, starting at -30 */
                    
ENTRY Func1(x,y,z)(d0,a0,a1) IS func1(D0, A0, A1)
-> any regs BUT a2/a4/a7/d7 !

ENTRY Func2(x,y)(d0,a0)      IS func2(D0, A0)

/* yaec1.9 : now its possible to print from libraries. */
/* As the "stdout" variable is NIL, dos.library/Output() is */
/* automatically used instead. */
ENTRY Func3()()              IS WriteF('bla.library says hello!\n')

/* the four required functions */
/* see amiga dev cd x.x (RKM) for info about theese functions */
/* for example, do NOT use functions that could break Forbid()! */

/* The Init() and Open() routines should return <> NIL */
/* if all went okey, else NIL */

/* The Expunge routine should normally always return <>NIL */
/* But in some cases we want to prevent removing of lib, */
/* in that case return NIL */

PROC Init() -> gets called when loaded from disk !
ENDPROC TRUE  -> return TRUE (was: libbase) for success

PROC Open() -> gets called on every OpenLibrary() !
ENDPROC TRUE -> return TRUE (was: libbase) for success

PROC Close() -> gets called on every CloseLibrary() !
ENDPROC TRUE -> may return anything..

/* we end up here if we have no openers and system wants memory */
/* should we exit ? if so, cleanup and return <>NIL */
/* otherwise just return NIL */
PROC Expunge() -> gets called when (attempting) remove from mem !
ENDPROC TRUE -> allow lib to be removed from memory. (New for v1.9)
              ->  (returning FALSE prevents library from beeing removed)

/* just some silly(?) functions */

PROC func1(x, y, z) IS x+y*z

PROC func2(a, b) IS -a*b

