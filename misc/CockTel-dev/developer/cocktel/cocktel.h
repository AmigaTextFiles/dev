#ifndef __INC_COCKTEL_COCKTEL_H
#define __INC_COCKTEL_COCKTEL_H
/*******************************************************************
 $CRT 30 Jul 1996 : hb

 $AUT Holger Burkarth
 $DAT >>cocktel.h<<   30 Jul 1996    09:35:02 - (C) ProDAD
*******************************************************************/
#include <exec/types.h>
#include <exec/errors.h>
#include <exec/io.h>



/*\
*** VIDEO
\*/


/*----------------------------------
-----------------------------------*/
struct COCKTEL_VDigiIO
{
  struct  Message  io_Message;
  struct  Device  *io_Device;
  struct  Unit    *io_Unit;
  UWORD   io_Command;
  UBYTE   io_Flags;
   BYTE   io_Error;
  ULONG   io_Actual;
  ULONG   io_Length;
  APTR    io_Data;

  UWORD io_DigiType;
  UWORD io_Width,io_Height;

  union {
    struct { /** VDIGI_GRAY **/
      UBYTE *iobw_L;
    } io_Gray;

    struct { /** VDIGI_RGB **/
      UBYTE *iorl_R;
      UBYTE *iorl_G;
      UBYTE *iorl_B;
    } io_RGB;

    struct { /** VDIGI_YUV411 **/
      UBYTE *ioyv_Y;
      UBYTE *ioyv_U;
      UBYTE *ioyv_V;
    } io_YUV;

  };
  UBYTE   io_Reserved[16];
};

/** io_Error **/
#define IOERR_NoVideoSignal 1
#define IOERR_UnknownDType  2

/** io_Command **/
#define CMDVDIGI_ASK  9

/** io_DigiType **/
#define VDIGI_GRAY    0
#define VDIGI_RGB     1
#define VDIGI_YUV411  2










/*----------------------------------
-----------------------------------*/
struct COCKTEL_VideoTransHeader
{
  UWORD vth_DigiType;

  UWORD vth_Width,vth_Height;

  union {
    struct {  /** VTH_GRAY **/
      UBYTE *vtbw_Gary;
    } vth_BW;

    struct {  /** VTH_RGB **/
      UBYTE *vtrl_R;
      UBYTE *vtrl_G;
      UBYTE *vtrl_B;
    } vth_RGB;

  };

  UBYTE vth_Reserved1[8];
  UWORD vth_Flags;
  UBYTE vth_Reserved2[8];
};



/** vth_Flags **/
#define VTHF_BigPic  0x0001  /* groﬂes Bild */

/** vth_DigiType **/
#define VTH_GRAY VDIGI_GRAY
#define VTH_RGB  VDIGI_RGB
//#define VTH_YUV


#define VTHTAG_MODE (TAG_USER +999) // Specify type of compression object.
#define VTHTMD_PACK	0  /* ti_Data for VTHTAG_MODE */
#define VTHTMD_UNPACK	1  /* ti_Data for VTHTAG_MODE */


#define VTHPKMD_FULL  0  /* Full-Frame/Key-Frame */
#define VTHPKMD_DELTA 1  /* Delta-Frame possible */






/*\
*** AUDIO
\*/

/*----------------------------------
-----------------------------------*/
struct COCKTEL_SDigiIO
{
  struct  Message  io_Message;
  struct  Device  *io_Device;
  struct  Unit    *io_Unit;
  UWORD   io_Command;
  UBYTE   io_Flags;
   BYTE   io_Error;
  ULONG   io_Actual;
  ULONG   io_Length;
  APTR    io_Data;

  ULONG   io_Frquence;     // Tr‰gerfrequenz cia == ca. 701000 (wird vom Device gesetzt)
  UWORD   io_MicroDelay;   // =  io_Frquence / BytesPerSec
  UWORD   io_MinBPS;       /* min. Bytes/Sec. Rate (wird vom Device gesetzt) */
  UWORD   io_MaxBPS;       /* max. Bytes/Sec. Rate (wird vom Device gesetzt) */

  UBYTE   io_Reserved[12];
};



/*----------------------------------
-----------------------------------*/
struct COCKTEL_AudioTransHeader
{
  UWORD ath_TransLength; /* Transfer-L‰nge  */
  UWORD ath_RealLength;  /* entpackte L‰nge */
  UWORD ath_Rate;        /* Bytes / Sec */
  UBYTE ath_Volume;      /* Lautst‰rke 0-255 */
  UBYTE ath_Reserved[5];
};



#define ATHTAG_MODE (TAG_USER +999) // Specify type of compression object.
#define ATHTMD_PACK	0  /* ti_Data for ATHTAG_MODE */
#define ATHTMD_UNPACK	1  /* ti_Data for ATHTAG_MODE */



#endif
