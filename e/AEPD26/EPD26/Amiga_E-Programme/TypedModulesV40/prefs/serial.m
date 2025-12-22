3,
      LDF_VOLUMES=8,
      LDB_ASSIGNS=4,
      LDF_ASSIGNS=16,
      LDB_ENTRY=5,
      LDF_ENTRY=$20,
      LDB_DELETE=6,
      LDF_DELETE=$40,
      LDB_READ=0,
      LDF_READ=1,
      LDB_WRITE=1,
      LDF_WRITE=2,
      LDF_ALL=28

OBJECT filelock
  link:LONG
  key:LONG
  access:LONG
  task:PTR TO mp
  volume:LONG
ENDOBJECT     /* SIZEOF=20 */

CONST REPORT_STREAM=0,
      REPORT_TASK=1,
      REPORT_LOCK=2,
     