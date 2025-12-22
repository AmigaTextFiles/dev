MODULE 'exec/libraries'
/*
 * Unit number definitions.  Ownership of a resource grants low-level
 * bit access to the hardware registers.  You are still obligated to follow
 * the rules for shared access of the interrupt system (see
 * exec.library/SetIntVector or cia.resource as appropriate).
 */
CONST MR_SERIALPORT=0,  /* Amiga custom chip serial port registers
    (SERDAT,SERDATR,SERPER,ADKCON, and interrupts) */
 MR_SERIALBITS=1,  /* Serial control bits (DTR,CTS, etc.) */
 MR_PARALLELPORT=2,  /* The 8 bit parallel data port
    (CIAAPRA & CIAADDRA only!) */
 MR_PARALLELBITS=3  /* All other parallel bits & interrupts
           (BUSY,ACK,etc.) */
/*
 * Library vector offset definitions
 */
CONST MR_ALLOCMISCRESOURCE=LIB_BASE,     /* -6 */
 MR_FREEMISCRESOURCE=LIB_BASE-LIB_VECTSIZE  /* -12 */
#define MISCNAME  'misc.resource'
