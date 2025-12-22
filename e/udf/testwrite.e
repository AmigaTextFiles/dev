/***************************************************************************
**                                                                        **
**  Simple example of a UDF archive                                       **
**  ©2000 M&F Software Corporation                                        **
**  All Right Reserved                                                    **
**                                                                        **
**  AmigaE 3.3                                                            **
**                                                                        **
**  $VER: UDF example 1.0.0 (27.01.00)                                    **
**                                                                        **
***************************************************************************/

/*

We are going to create this tree of chunks:

+------------+
|'level 1'   |
|2 metachunks|
+------------+
+------------+
+------------+
      |
      |
+------------+   +------------+   +------------+   +------------+
|'level 2a'  |   |'level 2b'  |   |'level 2c'  |   |'level 2d'  |
|0 metachunks|-- |0 metachunks|---|1 metachunk |---|0 metachunks|
+------------+   +------------+   +------------+   +------------+
      |                           +------------+          |
      |                                                   | 
+------------+                                     +------------+   +------------+
|'level 3a1' |                                     |'level 3d1  |   |'level 3d2' |
|0 metachunks|                                     |2 metachunks|---|0 metachunks|
+------------+                                     +------------+   +------------+
                                                   +------------+
                                                   +------------+

More complex trees can be easily created.

No error checking is done.

*/

OPT OSVERSION=37
OPT PREPROCESS
OPT REG=3

MODULE  'M&F/udf'

#define filename 'RAM:archive1.udf'

PROC main() HANDLE
  
  DEF lib=NIL:PTR TO udf, len=0, err=0
  DEF ck=NIL:PTR TO ck
  
  NEW lib.new(filename)

  IF lib=NIL THEN Raise("ERR")

  /* First chunk of the tree. You cannot add other chunks 
     on this level as they won't be reacheable. */
     
  ck:= lib.pushlevel([
    CK_ID, ID_TEXT,
    CK_SIZE, SIZE_UNKNOWN,
    ->CK_MASK, XPK_COMPRESSION_MODE,
    CK_XPK_METHOD, 'FEAL',
    CK_XPK_MODE, 60,
    CK_XPK_PASSWORD, TRUE,
    0])
  len, err := ck.store('level 1')
  
  /* Some optional metachunks for the first chunk */
  ck.addmeta([
    CK_ID, ID_TEXT,
    CK_NUMBER, 1,
    CK_SIZE, 12,
    CK_BUFFER, 'A metachunk',
    0])
  
  ck.addmeta([
    CK_ID, ID_TEXT,
    CK_NUMBER, 2,
    CK_SIZE, 17,
    CK_BUFFER, 'Another metachunk',
    0])

  /* Creating second level */
  ck := lib.pushlevel([
    CK_ID, ID_TEXT,0])
  ck.store('Level 2a')

  /* Creating thrird level */
  ck := lib.pushlevel([
    CK_ID, ID_TEXT,0])
  ck.store('Level 3')

  lib.poplevel()
  
  /* Adding new chunks to the second level again */
  ck := lib.pushchunk([
    CK_ID, ID_TEXT,
    0])
  ck.store('Level 2b')

  ck := lib.pushchunk([
    CK_ID, ID_TEXT,0])
  ck.store('Level 2c')
  
  ck.addmeta([
    CK_ID, ID_TEXT,
    CK_NUMBER, 1,
    CK_BUFFER, 'A metachunk for chunk 2c',
    CK_SIZE, STRLEN+1,
    0])

  ck := lib.pushchunk([
    CK_ID, ID_TEXT,0])
  ck.store('Level 2d')

  /* Adding a sub level to 'level 2d' chunk */
  ck := lib.pushlevel([
    CK_ID, ID_TEXT,0])
  ck.store('Level 3d1')
  
  ck.addmeta([
    CK_ID, ID_TEXT,
    CK_NUMBER, 1,
    CK_BUFFER, 'Metachunk 3d1-1',
    CK_SIZE, STRLEN+1,
    0])

  ck.addmeta([
    CK_ID, ID_TEXT,
    CK_NUMBER, 2,
    CK_BUFFER, 'Metachunk 3d1-2',
    CK_SIZE, STRLEN+1,
    0])

  ck := lib.pushchunk([
    CK_ID, ID_TEXT, 0])
  ck.store('Level 3d2')

  lib.poplevel()

  lib.poplevel()
  lib.poplevel()
  
  lib.save()
  
  END lib

EXCEPT DO

  IF exception
    PrintF('An error occured\n')
  ENDIF

ENDPROC
