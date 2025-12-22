
/*________________________________________________________________________
 |                                                                        |
 |    blitgds.c v1.0  - (c) 1992  Paul Juhasz                             |
 |                                                                        |
 |      All the data for the panel gadgets                                |
 |________________________________________________________________________*/


#include    "blitdefs.h"

extern  UWORD           g_abouta[],     g_aboutb[],
                        g_bltmpa[],     g_bltmpb[],
                        g_brusha[],     g_brushb[],
                        g_closea[],     g_closeb[],
                        g_deptha[],     g_depthb[],
                        g_filea[],      g_fileb[],
                        g_maska[],      g_maskb[],
                        g_mintrma[],    g_mintrmb[],
                        g_resoa[],      g_resob[],
                        g_undoa[],      g_undob[],
                        g_wheela[],     g_wheelb[],
                        g_okaya[],      g_okayb[],
                        g_cancela[],    g_cancelb[],
                        g_savtxt[];

struct Image    a_close = {
                    0,      /* X Offset from LeftEdge */
                    0,      /* Y Offset from TopEdge */
                    32,     /* Image Width */
                    11,     /* Image Height */
                    DEPTH,  /* Image Depth */
                    &g_closea[0], /* pointer to Image BitPlanes */
                    0x0F,   /* PlanePick */
                    0x00,   /* PlaneOnOff */
                    NULL }, /* next Image structure */

                b_close = {
                    0, 0, 32, 11, DEPTH, &g_closeb[0], 0x0F, 0x00, NULL },

                a_file = {
                    0, 0, 50, 25, DEPTH, &g_filea[0], 0x0F, 0x00, NULL },

                b_file = {
                    0, 0, 50, 25, DEPTH, &g_fileb[0], 0x0F, 0x00, NULL },

                a_brush = {
                    0, 0, 50, 25, DEPTH, &g_brusha[0], 0x0F, 0x00, NULL },

                b_brush = {
                    0, 0, 50, 25, DEPTH, &g_brushb[0], 0x0F, 0x00, NULL },

                a_bmode = {
                    0, 0, 50, 25, DEPTH, &g_bltmpa[0], 0x0F, 0x00, NULL },

                b_bmode = {
                    0, 0, 50, 25, DEPTH, &g_bltmpb[0], 0x0F, 0x00, NULL },

                a_undo = {
                    0, 0, 50, 25, DEPTH, &g_undoa[0], 0x0F, 0x00, NULL },

                b_undo = {
                    0, 0, 50, 25, DEPTH, &g_undob[0], 0x0F, 0x00, NULL },

                a_resol = {
                    0, 0, 56, 24, DEPTH, &g_resoa[0], 0x0F, 0x00, NULL },

                b_resol = {
                    0, 0, 56, 24, DEPTH, &g_resob[0], 0x0F, 0x00, NULL },

                a_blitt = {
                    0, 0, 236, 14, DEPTH, &g_abouta[0], 0x0F, 0x00, NULL },

                b_blitt = {
                    0, 0, 236, 14, DEPTH, &g_aboutb[0], 0x0F, 0x00, NULL },

                a_maskh = {
                    0, 0, 64, 14, DEPTH, &g_maska[0], 0x0F, 0x00, NULL },

                b_maskh = {
                    0, 0, 64, 14, DEPTH, &g_maskb[0], 0x0F, 0x00, NULL },

                a_minth = {
                    0, 0, 96, 14, DEPTH, &g_mintrma[0], 0x0F, 0x00, NULL },

                b_minth = {
                    0, 0, 96, 14, DEPTH, &g_mintrmb[0], 0x0F, 0x00, NULL },

                a_whlmv = {
                    0, 0, 11, 14, DEPTH, &g_wheela[0], 0x0F, 0x00, NULL },

                b_whlmv = {
                    0, 0, 11, 14, DEPTH, &g_wheelb[0], 0x0F, 0x00, NULL },

                a_depth = {
                    0, 0, 32, 11, DEPTH, &g_deptha[0], 0x0F, 0x00, NULL },

                b_depth = {
                    0, 0, 32, 11, DEPTH, &g_depthb[0], 0x0F, 0x00, NULL },

                a_okay  = {
                    0, 0, 48, 11, DEPTH, &g_okaya[0], 0x0F, 0x00, NULL },

                b_okay  = {
                    0, 0, 48, 11, DEPTH, &g_okayb[0], 0x0F, 0x00, NULL },

                a_cancel = {
                    0, 0, 64, 11, DEPTH, &g_cancela[0], 0x0F, 0x00, NULL },

                b_cancel = {
                    0, 0, 64, 11, DEPTH, &g_cancelb[0], 0x0F, 0x00, NULL },

                a_savas = {
                    0, 0, 96, 11, DEPTH, &g_savtxt[0], 0x0F, 0x00, NULL };


struct  Gadget  depth       = {
                    NULL,           /* *NextGadget  */
                    592,            /* LeftEdge     */
                    7,              /* TopEdge      */
                    31,             /* Width        */
                    11,             /* Height       */
                    GADGIMAGE|
                    GADGHIMAGE,     /* Flags        */
                    RELVERIFY,      /* Activation   */
                    BOOLGADGET,     /* GadgetType   */
                    (APTR)&a_depth, /* GadgetRender */
                    (APTR)&b_depth, /* SelectRender */
                    NULL,           /* *GadgetText  */
                    NULL,           /* MutualExclude*/
                    NULL,           /* SpecialInfo  */
                    13,             /* GadgetID     */
                    NULL },         /* UserData     */

                mint_rt     = {
                    &depth, 562, 36, 11, 14,
                    GADGIMAGE|GADGHIMAGE, FOLLOWMOUSE|RELVERIFY,
                    BOOLGADGET,
                    (APTR)&a_whlmv, (APTR)&b_whlmv,
                    NULL, NULL, NULL, 12, NULL },

                mint_lf     = {
                    &mint_rt, 499, 36, 11, 14,
                    GADGIMAGE|GADGHIMAGE, FOLLOWMOUSE|RELVERIFY,
                    BOOLGADGET,
                    (APTR)&a_whlmv, (APTR)&b_whlmv,
                    NULL, NULL, NULL, 11, NULL },

                minthlp     = {
                    &mint_lf, 393, 36, 95, 14, GADGIMAGE|GADGHIMAGE,
                    RELVERIFY, BOOLGADGET,
                    (APTR)&a_minth, (APTR)&b_minth,
                    NULL, NULL, NULL, 10, NULL },

                msk_rt      = {
                    &minthlp, 562, 11, 11, 14, GADGIMAGE|GADGHIMAGE,
                    FOLLOWMOUSE|RELVERIFY, BOOLGADGET,
                    (APTR)&a_whlmv, (APTR)&b_whlmv,
                    NULL, NULL, NULL, 9, NULL },

                msk_lf      = {
                    &msk_rt, 499, 11, 11, 14, GADGIMAGE|GADGHIMAGE,
                    FOLLOWMOUSE|RELVERIFY, BOOLGADGET,
                    (APTR)&a_whlmv, (APTR)&b_whlmv,
                    NULL, NULL, NULL, 8, NULL },

                mskhlp      = {
                    &msk_lf, 424, 11, 64, 14, GADGIMAGE|GADGHIMAGE,
                    RELVERIFY, BOOLGADGET,
                    (APTR)&a_maskh, (APTR)&b_maskh,
                    NULL, NULL, NULL, 7, NULL },

                about       = {
                    &mskhlp, 87, 38, 236, 14, GADGIMAGE|GADGHIMAGE,
                    RELVERIFY, BOOLGADGET,
                    (APTR)&a_blitt, (APTR)&b_blitt,
                    NULL, NULL, NULL, 6, NULL },

                reso        = {
                    &about, 15, 28, 56, 24, GADGIMAGE|GADGHIMAGE,
                    TOGGLESELECT|GADGIMMEDIATE, BOOLGADGET,
                    (APTR)&a_resol, (APTR)&b_resol,
                    NULL, NULL, NULL, 5, NULL },

                undo        = {
                    &reso, 273, 7, 50, 25, GADGIMAGE|GADGHIMAGE,
                    RELVERIFY, BOOLGADGET,
                    (APTR)&a_undo, (APTR)&b_undo,
                    NULL, NULL, NULL, 4, NULL },

                bltmode     = {
                    &undo, 211, 7, 50, 25, GADGIMAGE|GADGHIMAGE,
                    GADGIMMEDIATE|TOGGLESELECT, BOOLGADGET,
                    (APTR)&a_bmode, (APTR)&b_bmode,
                    NULL, NULL, NULL, 3, NULL },

                brush       = {
                    &bltmode, 149, 7, 50, 25, GADGIMAGE|GADGHIMAGE,
                    GADGIMMEDIATE|TOGGLESELECT, BOOLGADGET,
                    (APTR)&a_brush, (APTR)&b_brush,
                    NULL, NULL, NULL, 2, NULL },

                filerq      = {
                    &brush, 87, 7, 50, 25, GADGIMAGE|GADGHIMAGE,
                    RELVERIFY, BOOLGADGET,
                    (APTR)&a_file, (APTR)&b_file,
                    NULL, NULL, NULL, 1, NULL },

                pan_close   = {
                    &filerq, 15, 7, 31, 11, GADGIMAGE|GADGHIMAGE,
                    RELVERIFY, BOOLGADGET,
                    (APTR)&a_close, (APTR)&b_close,
                    NULL, NULL, NULL, 99, NULL },

                /*      These gadgets are connected to the requester      */

                dummy_gad   = {
                    NULL, 17, 3, 96, 11, GADGIMAGE|GADGHIMAGE,
                    NULL, BOOLGADGET|REQGADGET,
                    (APTR)&a_savas, (APTR)&a_savas,
                    NULL, NULL, NULL, 23, NULL },

                yes_gadget  = {
                    &dummy_gad, 17, 31, 48, 11, GADGIMAGE|GADGHIMAGE,
                    RELVERIFY|ENDGADGET, BOOLGADGET|REQGADGET,
                    (APTR)&a_okay, (APTR)&b_okay,
                    NULL, NULL, NULL, 21, NULL },

                no_gadget   = {
                    &yes_gadget, 166, 31, 64, 11, GADGIMAGE|GADGHIMAGE,
                    RELVERIFY|ENDGADGET, BOOLGADGET|REQGADGET,
                    (APTR)&a_cancel, (APTR)&b_cancel,
                    NULL, NULL, NULL, 22, NULL },

                string_gad  = {
                    &no_gadget, 15, 19, 210, 8, GADGHCOMP,
                    GADGIMMEDIATE|RELVERIFY|ENDGADGET,STRGADGET|REQGADGET,
                    NULL, NULL, NULL, NULL, NULL, 20, NULL };



/*                  E N D   O F   B L I T G D S . C                       */


