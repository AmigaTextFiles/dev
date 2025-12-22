#ifndef UTILITY_UTILITY_H
#define UTILITY_UTILITY_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif

#define UTILITYNAME 'utility.library'
OBJECT UtilityBase

      LibNode:Library
    Language:UBYTE
    Reserved:UBYTE
ENDOBJECT


#endif 
