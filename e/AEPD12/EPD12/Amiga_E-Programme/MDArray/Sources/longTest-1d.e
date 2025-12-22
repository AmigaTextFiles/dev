MODULE 'dos/dos'

PMODULE 'mdArray'

ENUM ER_NONE,
     ER_ARRAY_OUT_OF_BOUNDS

CONST XDIM = 8

PROC main () HANDLE
  DEF myArray : md_arrayType,
      x,                             /* Loop counter.            */
      val = 2000000000               /* Value placed into array. */

  /*-- Set the exception to raise if array bounds check fails. --*/
  md_constraintError := ER_ARRAY_OUT_OF_BOUNDS

  /*-- Create the array. --*/
  md_dim (myArray, [XDIM], SIZEOF_LONG)

/*-----------------------------------------------------------------------*/
  /*-- Test the indices-to-offset conversion function: --*/
  FOR x := 0 TO listItem (myArray.uBound, 0)
    WriteF ('[\d]=\d\n', x, md_offset (myArray, [x]))
  ENDFOR
/*-----------------------------------------------------------------------*/

  /*-- Put stuff in each element. --*/
  FOR x := 0 TO listItem (myArray.uBound, 0)
    md_set (myArray, [x], val++)
  ENDFOR

  /*-- Get it back out. --*/
  FOR x := 0 TO listItem (myArray.uBound, 0)
    WriteF ('myArray [\d]=\d\n', x, md_get (myArray, [x]))
  ENDFOR

/*-----------------------------------------------------------------------
  /*-- Bounds check with exception. --*/
  VOID md_get (myArray, [9])
-----------------------------------------------------------------------*/

  /*-- Cleanup. --*/
  md_dispose (myArray)

EXCEPT
  SELECT exception
    CASE ER_ARRAY_OUT_OF_BOUNDS; WriteF ('Bounds check failed.\n')
    DEFAULT;                     WriteF ('Oof!  What hit me?\n')
  ENDSELECT
  CleanUp (RETURN_FAIL)
ENDPROC
  /* main */
