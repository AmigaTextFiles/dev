#ifndef	WILDTDCORE_TYPEA1_H
#define WILDTDCORE_TYPEA1_H

#include <wild/tdcore.h>

/* Type 1: Uses colors for point, not intensity. */

#define	ENRTF_Absolute		1<<0		/* done the absolute ref. */
#define	ENRTF_FullBSP		1<<1		/* that object must be inserted face by face, not like a block. */
	
struct	PointTmp
{
 struct	Vek	tpn_Cam;
 WORD		tpn_OutX;
 WORD		tpn_OutY;	
 WORD		tpn_OutZ;
 WORD		tpn_XOS;
 WORD		tpn_YOS;
 UBYTE		tpn_Light[12];
};
		
#define PNRTF_Used	1<<0

struct EdgeTmp
{
 UBYTE		ted_Broker[32];
};

#define EDRTF_Out	1<<0
#define EDRTF_Hidden	1<<1
#define EDRTF_Calc	1<<2

struct BspTmp
{
 LONG			tbs_i,tbs_j,tbs_k;
 struct WildBSPEntry	*tbs_bspsave[2];
 LONG			tbs_NormalNorma,tbs_NormalModulo;
 LONG			tbs_TDMORE;
 UBYTE			tbs_Light[12];
 UBYTE			tbs_Broker[96];
 UBYTE			tbs_Draw[32];
};

struct BspTmpLite	/* for non-displayed faces: only bsp-related calcs */
{
 LONG			tbs_i,tbs_j,tbs_k;
 struct WildBSPEntry	*tbs_bspsave[2];
 LONG			tbs_NormalNorma,tbs_NormalModulo;
 LONG			tbs_TDMORE;
};

#define BSRTF_Hidden	0x01
#define	BSRTF_Minus	0x02
#define	BSRTF_BspChange	0x04

/*		STRUCTURE	BspTmp1,0
			LONG	t1bs_i			
			LONG	t1bs_j
			LONG	t1bs_k			; used to bsp-select and backface culling (and light!?)
			STRUCT	t1bs_bspsave,8		; when bsp-linking, must save them? here !!
			LONG	t1bs_NormalNorma	; =i^2+j^2+k^2
			LONG	t1bs_NormalModulo	; =(i^2+j^2+k^2)^.5
			STRUCT	t1bs_TDMORE,4		; more for future?
			STRUCT	t1bs_Light,12		; 12 bytes for light
			STRUCT	t1bs_Broker,96		; 96 bytes for broker
			STRUCT	t1bs_Draw,32		; 32 bytes for draw
			LABEL	t1bs_SIZE			
	
	BITDEF	BSRT1,Hidden,0				; The face is out,hidden,back, simply not visualized. (has 3 edges HIDDEN (not only out))
	BITDEF	BSRT1,Minus,1				; The observer is in the POSITIVE SEMISPACE (divided by the face), so DRAW FIRST THE NEGATIVE PART! (if cleared, viceversa)
	BITDEF	BSRT1,BspChange,2			; The bsp entry have been joined, so restore the bspplus & minus.

;NB: All non-DOT entries (and non-custom) have the t1bs_i,j,k,bspsave.
;NB2: All BSP Entries are the same for TDCore: then, broker and more will use their specific structs.

; Notes about the tmpbuffers: The TDCore must allocate them.
; The TDCore fills only the fields defined here. Other buffers MAY be used
; for tmp calculations, and then destroyed by other modules calls.
; The render pipeline works like that:
; 1) The TDCore calcs all he needs, allocates tmp buffers, creates the displayed 
;    entities list.
;    Then the TDCore calls:
; 2) The LightModule. Is passed the TDCoreData, containing all is needed to calc
;    lights. After have calced all the lights, the lightsmodule returns.
; 3) The Broker. This prepares the faces to be displayed. Then returns.
; 4) The Drawer. This draws the faces.
; 5) The PostFX. This may apply some SpecialFX to the finished frame.
; 6) Now, the TDCore frees the TMP memory.
; 7) The Display. This shows the frame, does c2p if needed,...

; As you can see, all the parts of the module are called 1 time.
; So, if you really need, you can use not only your reserved tmpdata space, but
; also the tmpdata space of the modules called After.
; So, if you are writing a Light module, you can use also the Broker space, the
; Drawer space, the PostFX space, and so. Obviosly, this data will be destroyed
; after you return, but they are not your businness. More obvious, when you write
; a module, you must fill all the spaces your Type of tmpdata requires: the
; modules called after you will need this data.

	ENDC*/
	
#endif

