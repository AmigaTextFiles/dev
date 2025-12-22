/*

		MCC_VLab © 1999 by Steve Quartly

		Registered class of the Magic User Interface.

		VLab_mcc.h

*/


/*** Include stuff ***/

/*** MUI Defines ***/

#define MUIC_VLab "VLab.mcc"
#define VLabObject MUI_NewObject(MUIC_VLab

#define MUISERIALNR_QUARTLY 31601
#define TAGBASE_QUARTLY ( TAG_USER | ( MUISERIALNR_QUARTLY << 16 ) )
#define TAGBASE_VLAB ( TAGBASE_QUARTLY + 1000 )


/*** Methods ***/
#define MUIM_VLab_MonitorOn 							( TAGBASE_VLAB + 2 )
#define MUIM_VLab_MonitorOff 							( TAGBASE_VLAB + 3 )
#define MUIM_VLab_Grab										( TAGBASE_VLAB + 4 )
#define MUIM_VLab_AllocYUVBuffer 					( TAGBASE_VLAB + 5 )
#define MUIM_VLab_AllocRGBBuffer 					( TAGBASE_VLAB + 6 )
#define MUIM_VLab_FreeYUVBuffer 					( TAGBASE_VLAB + 7 )
#define MUIM_VLab_FreeRGBBuffer 					( TAGBASE_VLAB + 8 )
#define MUIM_VLab_YUVtoRGB			 					( TAGBASE_VLAB + 9 )
#define MUIM_VLab_DeInterlace							( TAGBASE_VLAB + 10 )

#define MUIM_VLabImage_ObtainYUVPointer		( TAGBASE_VLAB + 11 )
#define MUIM_VLabImage_ReleaseYUVPointer	( TAGBASE_VLAB + 12 )
#define MUIM_VLabImage_ObtainRGBPointer		( TAGBASE_VLAB + 13 )
#define MUIM_VLabImage_ReleaseRGBPointer	( TAGBASE_VLAB + 14 )

#define MUIM_VLab_FindHardware	 					( TAGBASE_VLAB + 15 )

/*** Method structs ***/
struct MUIP_VLab_Grab
{
	ULONG id; // Method ID.

	Object **vlabImage; // Pointer to store the VLab Image Object data.
};

struct MUIP_VLab_AllocYUVBuffer
{
	ULONG id; // Method ID.

	ULONG **y; // Pointer to store the y data.
	ULONG **u; // Pointer to store the u data.
	ULONG **v; // Pointer to store the v data.

	LONG width, height;
};

struct MUIP_VLab_FreeYUVBuffer
{
	ULONG id; // Method ID.

	ULONG **y; // Pointer to store the y data.
	ULONG **u; // Pointer to store the u data.
	ULONG **v; // Pointer to store the v data.
};

struct MUIP_VLab_AllocRGBBuffer
{
	ULONG id; // Method ID.

	UBYTE **rgb; // Pointer to store the rgb data.

	LONG width, height;
};

struct MUIP_VLab_FreeRGBBuffer
{
	ULONG id; // Method ID.

	UBYTE **rgb; // Pointer to store the rgb data.
};

struct MUIP_VLab_YUVtoRGB
{
	ULONG id; // Method ID.

	ULONG *y; // Pointer to store the y data.
	ULONG *u; // Pointer to store the u data.
	ULONG *v; // Pointer to store the v data.

	UBYTE *rgb; // Pointer to store the rgb data.

	LONG width, height;
};

struct MUIP_VLabImage_ObtainYUVPointer
{
	ULONG id; // Method ID.

	ULONG **y; // Pointer to store the y data.
	ULONG **u; // Pointer to store the u data.
	ULONG **v; // Pointer to store the v data.
};

struct MUIP_VLabImage_ObtainRGBPointer
{
	ULONG id; // Method ID.

	ULONG **rgb; // Pointer to store the rgb data.
};

struct MUIP_VLab_DeInterlace
{
	ULONG id; // Method ID.

	UBYTE *rgb; // Pointer to store the rgb data.

	LONG width, height;

	LONG modulo;

	LONG pixinc;

	LONG mode;
};

/*** Special method values ***/


/*** Special method flags ***/


/*** Attributes ***/
#define MUIA_VLab_Top								( TAGBASE_VLAB + 25 )
#define MUIA_VLab_Left							( TAGBASE_VLAB + 26 )
#define MUIA_VLab_Width							( TAGBASE_VLAB + 27 )
#define MUIA_VLab_Height						( TAGBASE_VLAB + 28 )
#define MUIA_VLab_Monitor 					( TAGBASE_VLAB + 29 )
#define MUIA_VLab_MonitorObject 		( TAGBASE_VLAB + 30 )

#define MUIA_VLabImage_Width				( TAGBASE_VLAB + 31 )
#define MUIA_VLabImage_Height				( TAGBASE_VLAB + 32 )
#define MUIA_VLabImage_VMemName			( TAGBASE_VLAB + 33 )


/*** Special attribute values ***/
#define MUIV_VLab_MonitorStop 		0
#define MUIV_VLab_MonitorRun 			1


/*** Structures, Flags & Values ***/


/*** Configs ***/

/*** Errors ***/
#define VLABERR_OK						0			/* no error, everything OK */
#define VLABERR_ADDRESS				1			/* you passed an illegal buffer-address to VLab_Scan() */
#define VLABERR_NOHARD				2			/* hardware not found           (*) */
#define VLABERR_CLIP					3			/* you passed an illegal clip-definition to VLab_Scan() */
#define VLABERR_NOVIDEO				4			/* no video signal found        (*) */
#define VLABERR_SCAN					5			/* error during scan            (*) */
#define VLABERR_CUSTOM				6			/* illegal register or value */
#define VLABERR_INIT					7			/* error while sending the new value to the hardware */
#define VLABERR_NOMEM					8			/* not enough memory available  (*)  (v6) */
#define VLABERR_NOIMAGEOBJ		9			/* couldn't create the image object.*/
#define VLABERR_NOWINDOW			10		/* couldn't open the window.*/
#define VLABERR_VMEMFAILURE		11		/* couldn't open the window.*/

/* DeInterlace modes.*/
#define DIM_EVEN 0
#define DIM_ODD  1
#define DIM_MIX  2
#define DIM_SET  3

