
---  CUT HERE  -------------------------------------------------------------

/*========================================================================*/
/*                                                                        */
/* 2D array in E.  It's as easy as this.                                  */
/*                                                                        */
/* User components are:                                                   */
/*   dd_arrayType and the components therein                              */
/*   dd_dim (), create the 2d array                                       */
/*   dd_set (), put a value into an element of the 2d array               */
/*   dd_get (), get a value from an element of the 2d array               */
/*                                                                        */
/* The other components of this module should not be useful.              */
/*                                                                        */
/*========================================================================*/


RAISE 0 IF CtrlC () = TRUE
/* You should define an error trap for New()=NIL. */


OBJECT dd_arrayType
  iUBound, jUBound, elSize, elements
ENDOBJECT


/* These are global to speed up array access. */
DEF dd_ar : PTR TO dd_arrayType,
    dd_charPtr : PTR TO CHAR,
    dd_intPtr : PTR TO INT,
    dd_longPtr : PTR TO LONG,
    dd_elSize


PROC dd_dim (i, j, elSize)
  IF (elSize <> 1) AND
     (elSize <> 2) AND
     (elSize <> 4) THEN Raise ('Invalid element size.')
  dd_ar := New (SIZEOF dd_arrayType)
  dd_ar.elements := New (i*j*elSize)
  dd_ar.iUBound := i - 1
  dd_ar.jUBound := j - 1
  dd_ar.elSize := elSize
ENDPROC  dd_ar


PROC checkBounds (i, j)
  /* dd_ar already points to array when this is called. */
  IF (i < 0) OR (i > dd_ar.iUBound) THEN Raise ('"i" subscript out of bounds.')
  IF (j < 0) OR (j > dd_ar.jUBound) THEN Raise ('"j" subscript out of bounds.')
ENDPROC  TRUE


PROC dd_offset (i, j) RETURN ((i * (dd_ar.jUBound + 1) + j) * dd_elSize)


PROC dd_set (array, i, j, value)
  dd_ar := array
  checkBounds (i, j)
  dd_elSize := dd_ar.elSize
  SELECT dd_elSize
    CASE 1
      dd_charPtr := dd_ar.elements
      dd_charPtr [dd_offset (i, j)] := value
    CASE 2
      dd_intPtr := dd_ar.elements
      dd_intPtr [dd_offset (i, j)] := value
    CASE 4
      dd_longPtr := dd_ar.elements
      dd_longPtr [dd_offset (i, j)] := value
  ENDSELECT
ENDPROC


PROC dd_get (array, i, j)
  DEF value
  dd_ar := array
  checkBounds (i, j)
  dd_elSize := dd_ar.elSize
  SELECT dd_elSize
    CASE 1
      dd_charPtr := dd_ar.elements
      value := dd_charPtr [dd_offset (i, j)]
    CASE 2
      dd_intPtr := dd_ar.elements
      value := dd_intPtr [dd_offset (i, j)]
    CASE 3
      dd_longPtr := dd_ar.elements
      value := dd_longPtr [dd_offset (i, j)]
  ENDSELECT
ENDPROC  value


PROC dd_dispose (array)
  dd_ar := array
  Dispose (dd_ar.elements)
  Dispose (dd_ar)
ENDPROC


PROC main () HANDLE
  DEF myArray : PTR TO dd_arrayType,  /* Only needs to PTR TO if you want */
                                      /* access to the OBJECT fields.     */
      xDim = 4, yDim = 4,             /* x and y dimensions.              */
      sizeofChar = 1,                 /* Just for readability.            */
      i, j, val = 0                   /* Loop counters.                   */

  /* Create the array. */
  myArray := dd_dim (xDim, yDim, sizeofChar)

  /* Put stuff in each element. */
  FOR i := 0 TO myArray.iUBound
    FOR j := 0 TO myArray.jUBound
      CtrlC()
      dd_set (myArray, i, j, val++)
    ENDFOR
  ENDFOR

  /* Get it back out. */
  FOR i := 0 TO myArray.iUBound
    FOR j := 0 TO myArray.jUBound
      WriteF ('myArray [\d,\d]=\d\n', i, j, dd_get (myArray, i, j))
    ENDFOR
  ENDFOR

  /* Cleanup. */
  dd_dispose (myArray)

EXCEPT
  IF exception THEN WriteF ('\s\n', exception)
  CleanUp (exception)
ENDPROC
