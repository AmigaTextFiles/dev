MODULE 'dos/dos'

PMODULE 'mdArray'

ENUM ER_NONE,
     ER_ARRAY_OUT_OF_BOUNDS

CONST XDIM = 2,
      YDIM = 2,
      ZDIM = 2

PROC main () HANDLE
  DEF myArray : md_arrayType,
      x, y, z,                       /* Loop counters.           */
      val = 32000                    /* Value placed into array. */

  /*-- Set the exception to raise if array bounds check fails. --*/
  md_constraintError := ER_ARRAY_OUT_OF_BOUNDS

  /*-- Create the array. --*/
  md_dim (myArray, [XDIM, YDIM, ZDIM], SIZEOF_INT)

/*-----------------------------------------------------------------------*/
  /*-- Test the indices-to-offset conversion function: --*/
  FOR x := 0 TO listItem (myArray.uBound, 0)
    FOR y := 0 TO listItem (myArray.uBound, 1)
      FOR z := 0 TO listItem (myArray.uBound, 2)
        WriteF ('[\d,\d,\d]=\d\n', x, y, z, md_offset (myArray, [x,y,z]))
      ENDFOR
    ENDFOR
  ENDFOR
/*-----------------------------------------------------------------------*/

  /*-- Put stuff in each element. --*/
  FOR x := 0 TO listItem (myArray.uBound, 0)
    FOR y := 0 TO listItem (myArray.uBound, 1)
      FOR z := 0 TO listItem (myArray.uBound, 2)
        md_set (myArray, [x,y,z], val++)
      ENDFOR
    ENDFOR
  ENDFOR

  /*-- Get it back out. --*/
  FOR x := 0 TO listItem (myArray.uBound, 0)
    FOR y := 0 TO listItem (myArray.uBound, 1)
      FOR z := 0 TO listItem (myArray.uBound, 2)
        WriteF ('myArray [\d,\d,\d]=\d\n', x, y, z, md_get (myArray, [x,y,z]))
      ENDFOR
    ENDFOR
  ENDFOR

/*-----------------------------------------------------------------------
  /*-- Bounds check with exception. --*/
  VOID md_get (myArray, [9,9,9])
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
