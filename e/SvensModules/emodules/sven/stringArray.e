/* all you need to create an array of strings
*/

OPT MODULE
OPT PREPROCESS
OPT EXPORT

MODULE 'sven/support/string'


/* the new type :-)
*/
#define STRINGARRAY PTR TO LONG


/* Allocates an string array (with an NIL-pointer as last entry, makes
** usage as contents of eq. listview's or cycle-gadgets very easy).
** 'nr' is the number of entries
** 'maxlen' is the maximum length of one string
*/
PROC allocStringArray(nr,maxlen) HANDLE
DEF arr=NIL:STRINGARRAY,i

  NEW arr[nr+2]
  arr[]++:=nr     -> store the number OF entries
  FOR i:=0 TO nr-1 DO arr[i]:=allocString(maxlen)

EXCEPT
  disposeStringArray(arr)
  ReThrow()

ENDPROC arr


/* Disposes an string array
** Returns NIL
*/
PROC disposeStringArray(arr:STRINGARRAY)
DEF i,nr

  IF arr
    nr:=arr[-1]
    FOR i:=0 TO nr-1 DO disposeString(arr[i])
    arr--
    END arr[nr+2]
  ENDIF

ENDPROC NIL


/* copyies an string array into another.
** The stringarrays may be of different size.
** Returns the destination.
*/
PROC stringArrayCopy(dst:STRINGARRAY,src:STRINGARRAY)
DEF i,nr

  nr:=Min(src[-1],dst[-1])
  FOR i:=0 TO nr-1 DO StrCopy(dst[i],src[i])

ENDPROC dst


/* creates an copy of an stringarray
*/
PROC stringArrayCreateCopy(arr:STRINGARRAY)
DEF newarr:STRINGARRAY

  IF arr=NIL THEN RETURN NIL
  newarr:=allocStringArray(arr[-1],StrMax(arr[]))

ENDPROC stringArrayCopy(newarr,arr)

