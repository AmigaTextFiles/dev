/*

    This is a "do nothing" E class

    Just to show how AutoGuide works.

*/


/*
@node main "Foo - A do nothing class"

    This is a do nothing class, just to show AutoGuide capabilities.

    See these methods:

    @{" Foo()  " LINK foo_foo}
    @{" setx() " LINK foo_setx}
    @{" getx() " LINK foo_getx}

@endnode
*/

OBJECT foo
  x : INT
ENDOBJECT

/*
@node foo_foo "Foo constructor"

        NAME: foo()

      INPUTS: NONE

 DESCRIPTION: this is the class constructor.

@endnode
*/
PROC foo() OF foo
  self.x:=0
ENDPROC


/*
@node foo_setx "setx()"

        NAME: setx(v)

      INPUTS: v - new x value.

 DESCRIPTION: use this method to change x value.

@endnode
*/
PROC setx(v) OF foo
    self.x:=v
ENDPROC

/*
@node foo_getx "getx()"

        NAME: getx()

      INPUTS: NONE

 DESCRIPTION: use this method to get the x value.

@endnode
*/
PROC getx() OF foo IS self.x
