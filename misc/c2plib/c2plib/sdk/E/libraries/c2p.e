
OPT MODULE
OPT EXPORT



/* System */

CONST C2P_SYSTEM_PARAMETER_LIBVERSION     = 1,
      C2P_SYSTEM_PARAMETER_LIBREVISION    = 2,
      C2P_SYSTEM_PARAMETER_CPU            = 3,
      C2P_SYSTEM_PARAMETER_AKIKO_DETECTED = 4,
      C2P_SYSTEM_PARAMETER_AKIKP_C2P_PTR  = 5

CONST C2P_SYSTEM_CPU_68000 = 0,
      C2P_SYSTEM_CPU_68010 = 1,
      C2P_SYSTEM_CPU_68020 = 2,
      C2P_SYSTEM_CPU_68030 = 3,
      C2P_SYSTEM_CPU_68040 = 4,
      C2P_SYSTEM_CPU_68060 = 5,
      C2P_SYSTEM_CPU_68080 = 6

CONST ERR_NONE                   = 0,	-> all done, no errors occured
      ERR_UNALLOCATED            = 1,	-> the object is not allocated
      ERR_UNIMPLEMENTED          = 2,	-> the requested functionality is not yet implemented
      ERR_CANNOT_ALLOCATE_MEMORY = 3,	-> unable to allocate system memory
      ERR_ALREADY_INITIALIZED    = 4	-> the object has already initialized



/* Context */

CONST C2P_CONTEXT_PARAMETER_TYPE                    = 1,
      C2P_CONTEXT_PARAMETER_WIDTH                   = 2,
      C2P_CONTEXT_PARAMETER_HEIGHT                  = 3,
      C2P_CONTEXT_PARAMETER_CHUNKY                  = 4,
      C2P_CONTEXT_PARAMETER_BITMAP                  = 5,
      C2P_CONTEXT_PARAMETER_SCRAMBLED_OFFSETS_COUNT = 6,	-> readonly
      C2P_CONTEXT_PARAMETER_SCRAMBLED_OFFSET        = 7,	-> readonly
      C2P_CONTEXT_PARAMETER_FORCE_SCRAMBLED         = 8,
      C2P_CONTEXT_PARAMETER_PLANAR_FORMAT           = 9,
      C2P_CONTEXT_PARAMETER_SOURCE_OFFSET           = 10,
      C2P_CONTEXT_PARAMETER_TARGET_OFFSET           = 11,
      C2P_CONTEXT_PARAMETER_CONVERT_COUNT           = 12,
      C2P_CONTEXT_PARAMETER_INTERLEAVED_BITMAP      = 13,
      C2P_CONTEXT_PARAMETER_REFERENCE               = 14,
      C2P_CONTEXT_PARAMETER_REFERENCE_WRITEBACK     = 15

CONST C2P_CONTEXT_TYPE_UNDEFINED     = 0,
      C2P_CONTEXT_TYPE_BITMAP        = 1,
      C2P_CONTEXT_TYPE_FAST_BITMAP   = 2,
      C2P_CONTEXT_TYPE_CUSTOM_BITMAP = 3

CONST C2P_CONTEXT_PLANAR_FORMAT_DEFAULT = 0,
      C2P_CONTEXT_PLANAR_FORMAT_1_BIT   = 1,
      C2P_CONTEXT_PLANAR_FORMAT_2_BIT   = 2,
      C2P_CONTEXT_PLANAR_FORMAT_3_BIT   = 3,
      C2P_CONTEXT_PLANAR_FORMAT_4_BIT   = 4,
      C2P_CONTEXT_PLANAR_FORMAT_5_BIT   = 5,
      C2P_CONTEXT_PLANAR_FORMAT_6_BIT   = 6,
      C2P_CONTEXT_PLANAR_FORMAT_7_BIT   = 7,
      C2P_CONTEXT_PLANAR_FORMAT_8_BIT   = 8

CONST ERR_CONTEXT_UNALLOCATED                = 32,		-> the context is not allocated
      ERR_CONTEXT_NOT_INITIALIZED            = 33,		-> the context is not been initialized
      ERR_CONTEXT_ALREADY_INITIALIZED        = 34,		-> the context has already initialized
      ERR_CONTEXT_UNKNOWN_PARAMETER          = 35,		-> unknown context parameter
      ERR_CONTEXT_READONLY_PARAMETER         = 36,		-> cannot modify a readonly parameter
      ERR_CONTEXT_INVALID_PARAMETER_VALUE    = 37,		-> invalid value for a parameter
      ERR_CONTEXT_MISSING_CUSTOM_BITMAP      = 38,		-> invalid value for a parameter
      ERR_CONTEXT_INCOMPATIBLE_CUSTOM_BITMAP = 39		-> invalid value for a parameter

