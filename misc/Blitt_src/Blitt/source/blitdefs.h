#ifndef BLITDEFS_H
#define BLITDEFS_H         1

#include    <dos.h>
#include    <libraries/dos.h>         /* This will pull in exec/types.h   */
#include    <libraries/dosextens.h>
#include    <exec/exec.h>
#include    <exec/io.h>
#include    <exec/devices.h>
#include    <graphics/gfx.h>
#include    <graphics/gfxbase.h>
#include    <graphics/gfxmacros.h>
#include    <graphics/text.h>
#include    <graphics/view.h>
#include    <intuition/intuitionbase.h>
#include    <workbench/workbench.h>
#include    <workbench/startup.h>
#include    <hardware/cia.h>
#include    <hardware/blit.h>
#include    <stdio.h>
#include    <math.h>
#include    <stdlib.h>
#include    <string.h>

#define WIDTH            640          /* 640 high resolution              */
#define HEIGHT           256          /* 256 lines non interlaced PAL     */
#define HWIT             320          /*    half-width                    */
#define HHGT             128          /*    half-height                   */
#define NOTALL           200          /* NOT THE WHOLE SCREEN             */
#define DEPTH              4          /*   BitPlanes for the colours      */
#define DXOFFSET           0          /*        DxOffset 0 pixels         */
#define DYOFFSET           0          /*        DyOffset 0 lines          */

#define BLK                0
#define VIN                1
#define DPR                2
#define PNK                3
#define PRP                4
#define MVE                5
#define VIO                6
#define DRD                7
#define BRD                8
#define LRD                9
#define ORA               10
#define YEL               11
#define DBN               12
#define GLD               13
#define TAN               14
#define TRQ               15

#define TRP               16
#define DGY               17
#define MGY               18
#define LGY               19
#define WHT               20
#define OWT               21
#define LGN               22
#define MGN               23
#define GRN               24
#define C25               25
#define LBR               26
#define BGE               27
#define DBL               28
#define MBL               29
#define BLU               30
#define LBL               31

#define CIA_CHIP    0xbfe001

#define BRSH_ON       0x0001  /*    these are the brush modes   */
#define MSE_MOVE      0x0002
#define MASK_DEF      0x0010
#define MASK_END      0x0020
#define BRSH_DEF      0x0100
#define BRSH_FLO      0x0200
#define PROG_END      0xff00

#define MAIN_HELP          1
#define MASK_HELP          2
#define MINT_HELP          3

struct  BlitVar     {
            UWORD               mpx, mpy, ppy, brusw, brx, bry, msx, msy,
                                brw, brh;
            WORD                ofx, ofy, LIMX, LIMY, CMISE;
        };

#endif /* BLITDEFS_H */

extern   WORD  blitt( VOID );
extern   BYTE  do_wheels( BYTE value, WORD qrtr, WORD gy );
extern   VOID  do_about( BOOL what );
extern   VOID  do_undo( BOOL undo );
extern   WORD  put_screen( WORD width, WORD height, UBYTE *outname );
extern   WORD  get_screen( struct WBArg  *wa );
extern   VOID  box_tool( struct BlitVar  *bv, UWORD bsw );
extern   UWORD readIDCMP( struct Window *win, struct BlitVar *bv );
extern   VOID  do_blit( BOOL btyp, UBYTE pmask, UBYTE minterm );
extern   VOID  coords( struct BlitVar *bv );
extern   WORD  filereq( VOID );
extern   VOID  roll_em( WORD old, WORD new, WORD lft, WORD cnt, BOOL up );
extern   WORD  alloc_res( VOID );
extern   long  OpenArg( struct WBArg *wa, int openmode );
extern   VOID  put_pnl( struct RastPort *rap );
extern   VOID  free_res( WORD end );


