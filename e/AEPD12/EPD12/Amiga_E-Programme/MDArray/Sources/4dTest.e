MODULE 'dos/dos'

PMODULE 'PModules/mdArray'

ENUM ER_NONE,
     ER_ARRAY_OUT_OF_BOUNDS

CONST DIM1 = 2,
      DIM2 = 3,
      DIM3 = 4,
      DIM4 = 5

PROC main () HANDLE
  DEF myArray : md_arrayType,
      i1, i2, i3, i4,                /* Loop counters.           */
      val = 0                        /* Value placed into array. */

  /*-- Set the exception to raise if array bounds check fails. --*/
  md_constraintError := ER_ARRAY_OUT_OF_BOUNDS

  /*-- Create the array. --*/
  md_dim (myArray, [DIM1,DIM2,DIM3,DIM4], SIZEOF_CHAR)

/*-----------------------------------------------------------------------*/
  /*-- Test the indices-to-offset conversion function: --*/
  FOR i1 := 0 TO listItem (myArray.uBound, 0)
    FOR i2 := 0 TO listItem (myArray.uBound, 1)
      FOR i3 := 0 TO listItem (myArray.uBound, 2)
        FOR i4 := 0 TO listItem (myArray.uBound, 3)
            WriteF ('[\d,\d,\d,\d]=\d\n',
                    i1, i2, i3, i4,
                    md_offset (myArray, [i1,i2,i3,i4]))
        ENDFOR
      ENDFOR
    ENDFOR
  ENDFOR
/*-----------------------------------------------------------------------*/

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
