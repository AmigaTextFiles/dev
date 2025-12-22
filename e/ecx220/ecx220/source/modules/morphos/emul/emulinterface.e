OPT MODULE, EXPORT, PREPROCESS

-> emul/emulinterface.e

CONST   TRAP_MASK =    $00ff
CONST   TRAP_AREA_START =     $ff00   /* $ff00 .. $ffff area */
CONST   TRAP_LIB =     $ff00
CONST   TRAP_LIB_QUICK =     $ff01
CONST   TRAP_LIBNR =     $ff05
CONST   TRAP_LIBNR_QUICK =  $ff06
CONST   TRAP_ISYNC =     $ff0f
CONST   TRAP_SYNC =     $ff10
CONST   TRAP_EIEIO =     $ff11
CONST   TRAP_LIBSR =     $ff12
CONST   TRAP_LIBSRNR =     $ff13
CONST   TRAP_LIBD0_D1 =     $ff14
CONST   TRAP_LIBRESTORE =     $ff15
CONST   TRAP_LIBD0D1SR =          $ff17
CONST   TRAP_LIBD0D1A0A1SR =  $ff18

CONST   EMULTAG_NAME =     $0   /* Gives back a Name Ptr */
CONST   EMULTAG_VERSION =      $1   /* Gives back a Version */
CONST   EMULTAG_REVISION =  $2   /* Gives back a Revision */
CONST   EMULTAG_OPCODETABLE =  $3   /* Gives back the 16 Bit Opcodetable Ptr or NULL */
CONST   EMULTAG_TYPE =     $4   /* Gives back the emulation type */
CONST   EMULTAG_EMULHANDLE =  $5   /* Gives back the EmulHandle Ptr */
CONST   EMULTAG_EMULHANDLESIZE =  $6   /* Gives back the EmulHandle Size */
CONST   EMULTAG_SUPERHANDLE =  $7   /* Gives back the SuperHandle Ptr */
CONST   EMULTAG_SUPERHANDLESIZE =  $8   /* Gives back the SuperHandle Size */


OBJECT emulcaos
   function:LONG
   reg_d0:LONG
   reg_d1:LONG
   reg_d2:LONG
   reg_d3:LONG
   reg_d4:LONG
   reg_d5:LONG
   reg_d6:LONG
   reg_d7:LONG
   reg_a0:LONG
   reg_a1:LONG
   reg_a2:LONG
   reg_a3:LONG
   reg_a4:LONG
   reg_a5:LONG
/*
 * here you have to put the LibBasePtr if you want
 * to call a Library.
 */
   reg_a6:LONG
/* ECX union */
   offset:INT @ function   
ENDOBJECT

OBJECT emullibentry
   trap:INT
   extension:INT      /* MUST be set to 0 if you create it by hand */
   func:LONG
ENDOBJECT

OBJECT emulfunc
   trap:INT         /* TRAP_FUNC */
   extension:INT
   address:LONG
   /* Size 0 for no new Stack */
   stacksize:LONG
   arg1:LONG
   arg2:LONG
   arg3:LONG
   arg4:LONG
   arg5:LONG
   arg6:LONG
   arg7:LONG
   arg8:LONG
ENDOBJECT

#define GETEMULHANDLE R2

OBJECT   superhandle
   usp:LONG               /* Userstack */
   ssp:LONG               /* Supervisor Stack */
   vbr:LONG               /* Exception Base Register */
   sfc:LONG               /* SFC Register ...not really used */
   dfc:LONG               /* DFC Register ...not really used */
   cacr:LONG              /* Cache Control Register ...not really used */
   tc:LONG
   itt0:LONG
   itt1:LONG
   dtt0:LONG
   dtt1:LONG
   urp:LONG
   srp:LONG
   buscr:LONG
   pcr:LONG
   type:LONG              /* SuperHandle Type..not used yet */

/********************************************************************************************
 * Private
 * Don`t touch
 */
   private00:LONG
   private01:LONG
   private02:LONG
   private03:LONG
   private04:LONG
   private05:LONG
   private06:LONG
   private07:LONG
   private08:LONG
   private09:INT -> or LONG ?
   private0A:INT -> or LONG ?
   private0B:INT -> or LONG ?
   private0C:LONG
   privateXX[1024-29]:ARRAY OF LONG

/********************************************************************************************
 * Public
 * Read only
 */
   globalsysbase:LONG         /* Global SysBase pointer */
   roprivateXX[1024-1]:ARRAY OF LONG
ENDOBJECT

OBJECT   float96
   data[3]:ARRAY OF LONG
ENDOBJECT

OBJECT emulhandle
   dn[8]:ARRAY OF LONG                     /* $00 */
   an[8]:ARRAY OF LONG                     /* $20 */
   pc:PTR TO LONG                     /* $40 Current PC */
   sr:LONG                     /* $44 Statusregister */
   superhandle:PTR TO superhandle           /* $48 Ptr to SuperHandle */
   type:LONG                     /* $4c EmulHandle Type */
   flags:LONG                     /* $50 Flags */
   emulfunc:LONG               /* $54 Here is the direct Emulation Jump..you have to setup the regframes*/
   emulcallos:PTR TO emulcaos         /* $58 Here is the Emulation Jump for a 68k OSLib Function*/
   emulcall68k:PTR TO emulcaos         /* $5c Here is the Emulation Jump for a 68k Function*/
   emulcallquick68k:PTR TO emulcaos         /* $60 Here is the Emulation Quick Jump for a 68k Function..r13..r31 are not saved!*/
   emulcalldirectos:PTR TO LONG            /* $64 Here is the Emulation Direct Jump for a 68k OSLib Function*/
   emulcalldirect68k:PTR TO LONG            /* $68 Here is the Emulation Direct Jump for a 68k Function*/
   oldemulhandle:PTR TO emulhandle                  /* $6c Here we record the previous EmulHandle*/
   fpu[8]:ARRAY OF float96                     /* $70 Not yet used...*/
   fpcr:LONG                     /* $d0 Not yet used...*/
   fpsr:LONG                     /* $d4 Not yet used...*/
   fpiar:LONG                     /* $d8 Not yet used...*/
   hashentry:LONG                 /* $dc */
/********************************************************************************************
 * Private
 * Don`t touch
 * $e0
 */

ENDOBJECT        

CONST   EMULFLAGSF_PPC =     $1   /* Set when the emulation runs in full native code */
CONST   EMULFLAGSF_QUICK =  $2   /* Set when the emulation runs quick native code..
                                         * which is basicly still the emul reg layout
                                         */
CONST   EMULFLAGSF_INTERRUPT =  $4   /* Set when the emulation runs in interrupt mode */




