
#ifndef C2P_CONTEXT_H
#define C2P_CONTEXT_H



#include "c2p_system.h"





/*----------------
    PARAMETERS
----------------*/

#define C2P_CONTEXT_PARAMETER_TYPE                      1
#define C2P_CONTEXT_PARAMETER_WIDTH                     2
#define C2P_CONTEXT_PARAMETER_HEIGHT                    3
#define C2P_CONTEXT_PARAMETER_CHUNKY                    4
#define C2P_CONTEXT_PARAMETER_BITMAP                    5
#define C2P_CONTEXT_PARAMETER_SCRAMBLED_OFFSETS_COUNT   6   // readonly
#define C2P_CONTEXT_PARAMETER_SCRAMBLED_OFFSET          7   // readonly
#define C2P_CONTEXT_PARAMETER_FORCE_SCRAMBLED           8
#define C2P_CONTEXT_PARAMETER_PLANAR_FORMAT             9
#define C2P_CONTEXT_PARAMETER_SOURCE_OFFSET             10
#define C2P_CONTEXT_PARAMETER_TARGET_OFFSET             11
#define C2P_CONTEXT_PARAMETER_CONVERT_COUNT             12
#define C2P_CONTEXT_PARAMETER_INTERLEAVED_BITMAP        13
#define C2P_CONTEXT_PARAMETER_REFERENCE                 14
#define C2P_CONTEXT_PARAMETER_REFERENCE_WRITEBACK       15





/*------------
    VALUES
------------*/

#define C2P_CONTEXT_TYPE_UNDEFINED      0
#define C2P_CONTEXT_TYPE_BITMAP         1
#define C2P_CONTEXT_TYPE_FAST_BITMAP    2
#define C2P_CONTEXT_TYPE_CUSTOM_BITMAP  3

#define C2P_CONTEXT_PLANAR_FORMAT_DEFAULT   0
#define C2P_CONTEXT_PLANAR_FORMAT_1_BIT     1
#define C2P_CONTEXT_PLANAR_FORMAT_2_BIT     2
#define C2P_CONTEXT_PLANAR_FORMAT_3_BIT     3
#define C2P_CONTEXT_PLANAR_FORMAT_4_BIT     4
#define C2P_CONTEXT_PLANAR_FORMAT_5_BIT     5
#define C2P_CONTEXT_PLANAR_FORMAT_6_BIT     6
#define C2P_CONTEXT_PLANAR_FORMAT_7_BIT     7
#define C2P_CONTEXT_PLANAR_FORMAT_8_BIT     8





/*-----------------
    ERROR CODES
-----------------*/

#define ERR_CONTEXT_UNALLOCATED                 32  // the context is not allocated
#define ERR_CONTEXT_NOT_INITIALIZED             33  // the context is not been initialized
#define ERR_CONTEXT_ALREADY_INITIALIZED         34  // the context has already initialized
#define ERR_CONTEXT_UNKNOWN_PARAMETER           35  // unknown context parameter
#define ERR_CONTEXT_READONLY_PARAMETER          36  // cannot modify a readonly parameter
#define ERR_CONTEXT_INVALID_PARAMETER_VALUE     37  // invalid value for a parameter
#define ERR_CONTEXT_MISSING_CUSTOM_BITMAP       38  // missing external custom Bitmap
#define ERR_CONTEXT_INCOMPATIBLE_CUSTOM_BITMAP  39  // the external custom Bitmap is incompatible with the current Context


#endif  /* C2P_CONTEXT_H */
