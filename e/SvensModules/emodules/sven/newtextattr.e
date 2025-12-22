/* TextAttr-compatible structure.
** The TextAttr-structure is very nasty because it has an pointer
** to an string buffer. This means that you must keep an extra string.
** The newtextattr-structure already contains the string (fixed width)
** and therefore you only need one pointer. You can pass this structure
** to all functions that need an TextAttr-structure.
**
** Note: You must initialize an newtextattr-structure via initNewTextAttr()
**       (at least once).
**
*/

OPT MODULE

MODULE 'graphics/text'

EXPORT CONST NTA_MaxNameLength=65   -> for padding
CONST NTA_MaxNameLengthZero=NTA_MaxNameLength+1

EXPORT OBJECT newtextattr PUBLIC
  ta_name:PTR TO CHAR
  ta_ysize:INT
  ta_style:CHAR
  ta_flags:CHAR
PRIVATE
  namearray[NTA_MaxNameLengthZero]:ARRAY OF CHAR
ENDOBJECT


/* call this to initialize the structure
** Returns the newtextattr.
*/
EXPORT PROC initNewTextAttr(nta:PTR TO newtextattr)
  nta.ta_name:=nta.namearray
ENDPROC nta


/* copy the contents of an TextAttr or newtextattr structure into
** an *initialized* newtextattr-structure.
** Returns the newtextattr.
*/
EXPORT PROC copyNewTextAttr(dst:PTR TO newtextattr,src:PTR TO textattr)

  /* ta-datas
  */
  CopyMem(src+4,dst+4,SIZEOF textattr-4)

  /* copy ta_name
  */
  ->CopyMem(src.name,dst.namearray,Min(StrLen(src.name),NTA_MaxNameLength)+1)
  AstrCopy(dst.namearray,src.name,NTA_MaxNameLengthZero)
ENDPROC dst

