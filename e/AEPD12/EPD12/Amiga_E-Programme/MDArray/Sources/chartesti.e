/*========================================================================*/
/*                                                                        */
/* Multi-Dimensional arrays in E.                                          */
/*                                                                        */
/*========================================================================*/


MODULE 'dos/dos'


RAISE "MEM" IF New () = NIL,
      "MEM" IF List () = NIL


CONST SIZEOF_CHAR = 1,
      SIZEOF_INT  = 2,
      SIZEOF_LONG = 4


OBJECT md_arrayType
  uBound             : LONG
  elementSize        : LONG
  numberOfDimensions : LONG
  sizeOfDimension    : LONG
  elements           : LONG
ENDOBJECT


/*-- Set this to the value of the exception to be    --*/
/*-- raised if any of the array bounds checks fails. --*/
/*-- Default of -1 means raise no exception.         --*/
DEF md_constraintError = -1


ENUM ER_NONE,
     ER_ARRAY_OUT_OF_BOUNDS

CONST XDIM = 4,
      YDIM = 4,
      ZDIM = 5


PROC md_handleConstraintError ()
  IF md_constraintError <> -1 THEN Raise (md_constraintError)
ENDPROC


PROC listItem (listVar : PTR TO LONG, item) RETURN listVar [item]


PROC md_dim (array     : PTR TO md_arrayType,
             indexList : PTR TO LONG,
             elementSize)       /*-- Use one of the provided constants. --*/
  DEF numberOfElements = 1,
      sizeOfDimension = NIL : PTR TO LONG,
      i, j

  /*-- Compute number of elements and create array. --*/
  array.elementSize := elementSize
  array.numberOfDimensions := ListLen (indexList)
  FOR i := 0 TO (array.numberOfDimensions - 1) DO numberOfElements := Mul (numberOfElements, indexList [i])
  array.elements := New (Mul (numberOfElements, elementSize))

  /*-- Store upper bounds of each dimension. --*/
  array.uBound := List (array.numberOfDimensions)
  ListCopy (array.uBound, indexList, ALL)
  MapList ({i}, array.uBound, array.uBound, `i - 1)

  /*-- Compute and store size of each dimension for later index computations. --*/

  /*-- Init list. --*/
  array.sizeOfDimension := List (array.numberOfDimensions)
  SetList (array.sizeOfDimension, array.numberOfDimensions)
  MapList ({i}, array.sizeOfDimension, array.sizeOfDimension, `1)

  /*-- Compute size of each dimension. --*/
  sizeOfDimension := array.sizeOfDimension
  FOR i := 0 TO (array.numberOfDimensions - 1)
    FOR j := (i + 1) TO (array.numberOfDimensions - 1)
      sizeOfDimension [i] := Mul (sizeOfDimension [i], indexList [j])
    ENDFOR
  ENDFOR
ENDPROC
  /* md_dim */


PROC md_withinBounds (array     : PTR TO md_arrayType,
                      indexList : PTR TO LONG)
  DEF i
  FOR i := 0 TO (array.numberOfDimensions - 1) DO IF (indexList [i] < 0) OR
                                                     (indexList [i] > listItem (array.uBound, i)) THEN RETURN FALSE
ENDPROC  TRUE
  /* md_withinBounds */


PROC md_offset (array     : PTR TO md_arrayType,
                indexList : PTR TO LONG)
  DEF offset = 0, i
  FOR i := 0 TO (array.numberOfDimensions - 1)
    offset := offset + Mul (indexList [i],
                            listItem (array.sizeOfDimension, i))
  ENDFOR
ENDPROC  Mul (offset, array.elementSize)
  /* md_offset */


PROC md_set (array     : PTR TO md_arrayType,
             indexList : PTR TO LONG,
             value)
  DEF charPtr : PTR TO CHAR,
      intPtr  : PTR TO INT,
      longPtr : PTR TO LONG,
      elementSize
  IF md_withinBounds (array, indexList)
    elementSize := array.elementSize
    SELECT elementSize
      CASE SIZEOF_CHAR
        charPtr := array.elements + md_offset (array, indexList)
        charPtr [] := value
      CASE SIZEOF_INT
        intPtr := array.elements + md_offset (array, indexList)
        intPtr [] := value
      CASE SIZEOF_LONG
        longPtr := array.elements + md_offset (array, indexList)
        longPtr [] := value
    ENDSELECT
  ELSE
    md_handleConstraintError ()
  ENDIF
ENDPROC
  /* md_set */


PROC md_get (array     : PTR TO md_arrayType,
             indexList : PTR TO LONG)
  DEF charPtr : PTR TO CHAR,
      intPtr  : PTR TO INT,
      longPtr : PTR TO LONG,
      elementSize
  IF md_withinBounds (array, indexList)
    elementSize := array.elementSize
    SELECT elementSize
      CASE SIZEOF_CHAR
        charPtr := array.elements + md_offset (array, indexList)
        RETURN charPtr []
      CASE SIZEOF_INT
        intPtr := array.elements + md_offset (array, indexList)
        RETURN intPtr []
      CASE SIZEOF_LONG
        longPtr := array.elements + md_offset (array, indexList)
        RETURN longPtr []
    ENDSELECT
  ELSE
    md_handleConstraintError ()
  ENDIF
ENDPROC
  /* md_get */


PROC md_dispose (array : PTR TO md_arrayType)
  Dispose (array.uBound)
  Dispose (array.elements)
ENDPROC
  /* md_dispose */


PROC main () HANDLE
  DEF myArray : md_arrayType,
      x, y, z,                       /* Loop counters.           */
      val = 0                        /* Value placed into array. */

  /*-- Set the exception to raise if array bounds check fails. --*/
  md_constraintError := ER_ARRAY_OUT_OF_BOUNDS

  /*-- Create the array. --*/
  md_dim (myArray, [XDIM, YDIM, ZDIM], SIZEOF_CHAR)

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
