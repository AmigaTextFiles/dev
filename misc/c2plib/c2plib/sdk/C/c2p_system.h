
#ifndef C2P_SYSTEM_H
#define C2P_SYSTEM_H





/*----------------
    PARAMETERS
----------------*/

#define C2P_SYSTEM_PARAMETER_LIBVERSION     1
#define C2P_SYSTEM_PARAMETER_LIBREVISION    2
#define C2P_SYSTEM_PARAMETER_CPU            3
#define C2P_SYSTEM_PARAMETER_AKIKO_DETECTED 4
#define C2P_SYSTEM_PARAMETER_AKIKP_C2P_PTR  5





/*------------
    VALUES
------------*/

#define C2P_SYSTEM_CPU_68000    0
#define C2P_SYSTEM_CPU_68010    1
#define C2P_SYSTEM_CPU_68020    2
#define C2P_SYSTEM_CPU_68030    3
#define C2P_SYSTEM_CPU_68040    4
#define C2P_SYSTEM_CPU_68060    5
#define C2P_SYSTEM_CPU_68080    6





/*-----------------
    ERROR CODES
-----------------*/

#define ERR_NONE                    0   // all done, no errors occured
#define ERR_UNALLOCATED             1   // the object is not allocated
#define ERR_UNIMPLEMENTED           2   // the requested functionality is not yet implemented
#define ERR_CANNOT_ALLOCATE_MEMORY  3   // unable to allocate system memory
#define ERR_ALREADY_INITIALIZED     4   // the object has already initialized


#endif  /* C2P_SYSTEM_H */
