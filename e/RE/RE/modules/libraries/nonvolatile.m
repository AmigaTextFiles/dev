#ifndef LIBRARIES_NONVOLATILE_H
#define LIBRARIES_NONVOLATILE_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef EXEC_NODES_H
MODULE  'exec/nodes'
#endif

OBJECT NVInfo

    MaxStorage:LONG
    FreeStorage:LONG
ENDOBJECT


OBJECT NVEntry

      Node:MinNode
    Name:PTR TO CHAR
    Size:LONG
    Protection:LONG
ENDOBJECT


#define NVEB_DELETE  0
#define NVEB_APPNAME 31
#define NVEF_DELETE  (1<<NVEB_DELETE)
#define NVEF_APPNAME (1<<NVEB_APPNAME)


#define NVERR_BADNAME	1
#define NVERR_WRITEPROT 2
#define NVERR_FAIL	3
#define NVERR_FATAL	4


#define SizeNVData(DataPtr) (((  *) DataPtr)[-1]) - 4)

#endif 
