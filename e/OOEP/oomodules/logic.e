/* Logic.e
 *
 * Details the implementation of logical constructs.  Tons
 * o' fun.
 */

OPT MODULE

MODULE '*object'

EXPORT OBJECT logic OF object
/****** logic/--logic-- ******************************************

    NAME 
        logic of object

    PURPOSE
        Logic, derived from Object, handles logical statements.  I
        will likely change its name in the future due to further
        considerations (logical terms are different from
        statements).

    ATTRIBUTES
        All logical statements have truth, therefore, truth is its
        only attribute.  Truth is always either TRUE, FALSE, or
        UNDETERMINED.  Unfortunately, Amiga E has already assigned
        values to those three constants, so for my purposes, TRUE is
        '1', FALSE is '-1', and UNDETERMINED is '0'.  Fortunately, I
        have ways of testing this information without having to
        resort to clumsy IF/THEN statements.. more on this later.

    NOTES
 
******************************************************************************

History


*/
 truth
ENDOBJECT

DEF tmp_logic:PTR TO logic,query,if1,if2,ifT1,ifT2,ifF1,ifF2,ifU1,ifU2

EXPORT PROC select(opt,i) OF logic
/****** logic/select ******************************************

    NAME 
        select() -- Selection of action on initialization.

    SYNOPSIS
        logic.select()

    FUNCTION
        This method allows one to create a new instantiation of the
        Logic object.  'a' is an E list that may have the following:

            "set"  -- Sets the truth value to the following item.
            "true" -- Sets truth to true.
            "fals" -- Sets truth to false.

            The truth attribute always starts off undetermined.

    INPUTS
        opts -- The optionlist

        i -- The index of the optionlist

    SEE ALSO
        object/select()
******************************************************************************

History


*/
 DEF item
 item := ListItem(opt,i)
 SELECT item
  CASE "true"
   self.beTrue()
  CASE "fals"
   self.beFalse()
  CASE "?"
   self.beUndetermined()
  CASE "set"
   INC i
   self.truth := ListItem(opt,i)
 ENDSELECT
ENDPROC i


EXPORT PROC beTrue() OF logic
/****** logic/beTrue ******************************************

    NAME 
        beTrue() -- Force truth to be true.

    SYNOPSIS
        logic.beTrue()

    FUNCTION
        Forces truth to be true.

    SEE ALSO
        beFalse(), beUndetermined()
******************************************************************************

History


*/
 self.truth := 1
ENDPROC


EXPORT PROC beFalse() OF logic
/****** logic/beFalse ******************************************

    NAME 
        beFalse() -- Force truth to be false.

    SYNOPSIS
        logic.beFalse()

    FUNCTION
        Forces truth to be false.

    SEE ALSO
        beTrue(), beUndetermined()
******************************************************************************

History


*/
 self.truth := -1
ENDPROC


EXPORT PROC beUndetermined() OF logic
/****** logic/beUndetermined ******************************************

    NAME 
        beUndetermined() -- Force truth to be undetermined.

    SYNOPSIS
        logic.beUndetermined()

    FUNCTION
        Forces truth to be undetermined.

    SEE ALSO
        beTrue(), beFalse()
******************************************************************************

History


*/
 self.truth := 0
ENDPROC


EXPORT PROC copy(a=0:PTR TO logic) OF logic
/****** logic/copy ******************************************

    NAME 
        copy() -- Copy a logic object.

    SYNOPSIS
        logic.copy()

    FUNCTION
        This method allows you to copy a Logic statement.  If a is
        missing, it will create a new one.  If a is not missing, it
        will simply copy the contents of its truth to the incoming
        Logic statement.

    INPUTS
        a=NIL:PTR TO object -- Pointer to logic or NIL.

    RESULT
        PTR TO logic -- Freshly created logic object if the incoming
            object pointer was NIL.
******************************************************************************

History


*/
 DEF tmp:PTR TO logic
 IF a
  a.truth := self.truth
  tmp := a
 ELSE
  NEW tmp.new(["set",self.truth])
 ENDIF
ENDPROC tmp


EXPORT PROC isTrue() OF logic IS IF self.truth = 1 THEN TRUE ELSE FALSE
/****** logic/isTrue ******************************************

    NAME 
        isTrue() -- is the statement true?

    SYNOPSIS
        logic.isTrue()

    FUNCTION
        Determines if the truth is true.

    RESULT
        TRUE if truth is true, FALSE otherwise.

    SEE ALSO
        isFalse(), isUndetermined(), isDetermined()
******************************************************************************

History


*/

EXPORT PROC isFalse() OF logic IS IF self.truth = -1 THEN TRUE ELSE FALSE
/****** logic/isFalse ******************************************

    NAME 
        isFalse() -- is the statement false?

    SYNOPSIS
        logic.isFalse()

    FUNCTION
        Determines if the truth is false.

    RESULT
        TRUE if truth is false, FALSE otherwise.

    SEE ALSO
        isTrue(), isUndetermined(), isDetermined()
******************************************************************************

History


*/

EXPORT PROC isUndetermined() OF logic IS IF self.truth = 0 THEN TRUE ELSE FALSE
/****** logic/isUndetermined ******************************************

    NAME 
        isTrue() -- is the statement undetermined?

    SYNOPSIS
        logic.isUndetermined()

    FUNCTION
        Determines if the truth is undetermined.

    RESULT
        TRUE if truth is undetermined, FALSE otherwise.

    SEE ALSO
        isFalse(), isTrue(), isDetermined()
******************************************************************************

History


*/

EXPORT PROC isDetermined() OF logic IS IF self.truth <> 0 THEN TRUE ELSE FALSE
/****** logic/isDetermined ******************************************

    NAME 
        isDetermined() -- is the statement determined?

    SYNOPSIS
        logic.isDetermined()

    FUNCTION
        Determines if the truth is determined.

    RESULT
        TRUE if truth is determined, FALSE otherwise.

    SEE ALSO
        isFalse(), isUndetermined(), isTrue()
******************************************************************************

History


*/

EXPORT PROC if(q,a=0,b=0)
/****** logic/if ******************************************

    NAME 
        if() -- If... Then... Else... statement

    SYNOPSIS
        if(quotedExpression,quotedThenExpression,quotedElseExpression)

    FUNCTION
        This is the only procedure that isn't actually part of the
        logic object.  This may change in the future.  All
        parameters (q, a, and b) will be Eval()uated, and must
        therefore be "`" expressions... I chose to do things this
        way in order to save space, and in order to do things more
        easily.  I couldn't find another way to allow users to call
        their object's methods arbitrarily from within this function.

        Basically, 'q' should return either TRUE or FALSE (in the
        classic Amiga E sense).  If a or b has a value other than 0,
        a will be Eval()ed if q Eval()s to TRUE, b if q Eval()s to
        FALSE.  If a is missing, and q indicates TRUE, then TRUE
        will be returned.  If b is missing, and q indicates FALSE,
        then FALSE will be returned.

        So, in essence, this procedure acts as a very sophisticated
        IF THEN ELSE statement, but in a much more easily readable
        format.  This will become particularly useful as you read.

    INPUTS
        quotedExpression,
        quotedThenExpression,
        quotedElseExpression --- see above

    RESULT
        see above

******************************************************************************

History


*/
 query:=q
 if1:=a
 if2:=b
 IF Eval(query)
  IF if1
   RETURN Eval(if1)
  ELSE
   RETURN TRUE
  ENDIF
 ELSE
  IF if2
   RETURN Eval(if2)
  ELSE
   RETURN FALSE
  ENDIF
 ENDIF
ENDPROC


EXPORT PROC ifTrue(a=0,b=0) OF logic
/****** logic/ifTrue ******************************************

    NAME 
        ifTrue() -- If I am true, then... else...

    SYNOPSIS
        logic.ifTrue(quotedThenExpression,quotedElseExpression)

    FUNCTION
        If I am true, quotedThenExpression is evaluated, else
        quotedElseExpression will be evaluated.

    INPUTS
        quotedThenExpression,
        quotedElseExpression -- Quoted expressions

    RESULT
        Depends on the quoted expressions. See if() on that.

    SEE ALSO
        if()
******************************************************************************

History


*/
 ifT1:=a; ifT2:=b
 tmp_logic := self
 if(`tmp_logic.isTrue(),ifT1,ifT2)
ENDPROC


EXPORT PROC ifFalse(a=0,b=0) OF logic
/****** logic/ifFalse ******************************************

    NAME 
        ifFalse() -- If I am false, then... else...

    SYNOPSIS
        logic.ifFalse(quotedThenExpression,quotedElseExpression)

    FUNCTION
        If I am false, quotedThenExpression is evaluated, else
        quotedElseExpression will be evaluated.

    INPUTS
        quotedThenExpression,
        quotedElseExpression -- Quoted expressions

    RESULT
        Depends on the quoted expressions. See if() on that.

    SEE ALSO
        if()
******************************************************************************

History


*/
 ifF1:=a; ifF2:=b
 tmp_logic := self
 if(`tmp_logic.isFalse(),ifF1,ifF2)
ENDPROC


EXPORT PROC ifUndetermined(a=0,b=0) OF logic
/****** logic/ifUndetermined ******************************************

    NAME 
        ifUndetermined() -- If I am true, then... else...

    SYNOPSIS
        logic.ifUndetermined(quotedThenExpression,quotedElseExpression)

    FUNCTION
        If I am undetermined, quotedThenExpression is evaluated, else
        quotedElseExpression will be evaluated.

    INPUTS
        quotedThenExpression,
        quotedElseExpression -- Quoted expressions

    RESULT
        Depends on the quoted expressions. See if() on that.

    SEE ALSO
        if()
******************************************************************************

History


*/
 ifU1:=a; ifU2:=b
 tmp_logic := self
 if(`tmp_logic.isUndetermined(),ifU1,ifU2)
ENDPROC


EXPORT PROC ifDetermined(a=0,b=0) OF logic
/****** logic/ifDetermined ******************************************

    NAME 
        ifDetermined() -- If I am true, then... else...

    SYNOPSIS
        logic.ifDetermined(quotedThenExpression,quotedElseExpression)

    FUNCTION
        If I am determined, quotedThenExpression is evaluated, else
        quotedElseExpression will be evaluated.

    INPUTS
        quotedThenExpression,
        quotedElseExpression -- Quoted expressions

    RESULT
        Depends on the quoted expressions. See if() on that.

    SEE ALSO
        if()
******************************************************************************

History


*/
 ifU1:=a; ifU2:=b
 tmp_logic := self
 if(`tmp_logic.isDetermined(),ifU1,ifU2)
ENDPROC


EXPORT PROC write() OF logic
/****** logic/write ******************************************

    NAME 
        write() -- Write string with truth of statement.

    SYNOPSIS
        logic.write()

    FUNCTION
        This method will print 'This statement is' followed by
        either True, False, or Undetermined, depending on the value
        of truth.  This method will not exist in the future... it
        will be replaced with something more flexible.. currently,
        it will only write to stdout.

******************************************************************************

History


*/
 tmp_logic := self
 WriteF('This statement is ')
 self.ifDetermined(`tmp_logic.ifTrue(`WriteF('True'),`WriteF('False')),`WriteF('Undetermined'))
 WriteF('.\n')
ENDPROC

/*EE folds
1
11 31 14 45 16 22 18 22 20 22 22 35 120 60 122 32 124 32 126 32 128 32 130 27 
EE folds*/
