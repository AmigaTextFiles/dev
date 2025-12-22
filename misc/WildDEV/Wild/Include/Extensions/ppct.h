
#include <exec/types.h>
#include <utility/tagitem.h>

struct ppctnode
{
 UWORD			ppctn_splitatx;
 UWORD			ppctn_splitaty;
 UWORD			ppctn_splitatz;
 struct ppctnode	*ppctn_childs[8];
 UWORD			ppctn_numofcols;
 UWORD			*ppctn_colsarray;
};

struct ppctprek
{
 UWORD			ppctp_x;
 UWORD			ppctp_y;
 UWORD			ppctp_z;
};

struct ppct
{
 ULONG 			*ppct_pool;
 struct ppctnode	*ppct_root;
 UWORD			ppct_maxdepth;
 UWORD			ppct_maxpernode;
 ULONG			*ppct_truechunky;	/* used only during the costruction. you can free the chunky then. */
 struct	ppctprek	*ppct_prekchunky;
 UBYTE			ppct_flags;
 UBYTE			ppct_treelevel;
};

#define PPCTF_RGBMode	0x01
#define PPCTB_RGBMode	0

#define PPCT_TAGBASE		TAG_USER+0x0eeee000
#define PPCT_ChunkyArray	PPCT_TAGBASE+0	/* REQUIDED */
#define PPCT_MaxTreeDepth	PPCT_TAGBASE+1	/* default 24 */
#define PPCT_MaxColorsPerNode	PPCT_TAGBASE+2	/* default 1 */
#define PPCT_ChunkyPixelsNum	PPCT_TAGBASE+3	/* REQUIDED */
#define PPCT_RGBMode		PPCT_TAGBASE+4	/* defaulf FALSE (HSL mode!) */

