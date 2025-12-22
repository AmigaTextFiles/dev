/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * nfo_findgfxentry.h
 *
 * --- LICENSE --------------------------------------------------------
 *
 * Following  contents covered by the  BSIPM  license not to be used in
 * commercial products nor redistributed separately nor modified by the
 * 3-rd parties other than mentioned in the license and under the terms
 * prior to recipient status.
 *
 * A  copy  of  the  BSIPM  document  and/or  source  code  along  with
 * commented modifications and/or separate changelog should be included
 * in this archive.
 *
 * NO WARRANTY OF ANY KIND APPLIES. ALL THE RISK AS TO THE QUALITY  AND
 * PERFORMANCE  OF  THIS  SOFTWARE  IS  WITH  YOU. SEE THE 'BLACK SALLY
 * IMITABLE PACKAGE MARK' DOCUMENT FOR MORE DETAILS.
 *
 * --- VERSION --------------------------------------------------------
 *
 * $VER: a-nfo_findgfxentry.h 1.06 (30/01/2011)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___FINDGFXENTRY_H_INCLUDED___
#define ___FINDGFXENTRY_H_INCLUDED___

#define QDEV_NFO_PRV_DEFDEPTH   2
#define QDEV_NFO_PRV_RLOWSKIP  0xFFFF;
#define QDEV_NFO_PRV_ARGDELIM  ' '
#define QDEV_NFO_PRV_SUBDELIM  'x'
#define QDEV_NFO_PRV_ACTWORD   "ACTIVE"



struct qdev_ttv_skel
{
  UBYTE *ts_name;            /* Literal name of the flag                    */
  ULONG  ts_value;           /* Value that represents that flag             */
};

#ifdef ___QDEV_FLAGSENABLE
___QDEV_FLAGSENABLE struct qdev_ttv_skel qdev_nfo_prv_flags[] =
{
  { "LACE",                                DIPF_IS_LACE              },
  { "DUALPF",                              DIPF_IS_DUALPF            },
  { "PF2PRI",                              DIPF_IS_PF2PRI            },
  { "HAM",                                 DIPF_IS_HAM               },
  { "ECS",                                 DIPF_IS_ECS               },
  { "AA",                                  DIPF_IS_AA                },
  { "PAL",                                 DIPF_IS_PAL               },
  { "SPRITES",                             DIPF_IS_SPRITES           },
  { "GENLOCK",                             DIPF_IS_GENLOCK           },
  { "WB",                                  DIPF_IS_WB                },
  { "DRAGGABLE",                           DIPF_IS_DRAGGABLE         },
  { "PANELLED",                            DIPF_IS_PANELLED          },
  { "BEAMSYNC",                            DIPF_IS_BEAMSYNC          },
  { "EXTRAHALFBRITE",                      DIPF_IS_EXTRAHALFBRITE    },
  { "SPRITES_ATT",                         DIPF_IS_SPRITES_ATT       },
  { "SPRITES_CHNG_RES",                    DIPF_IS_SPRITES_CHNG_RES  },
  { "SPRITES_BORDER",                      DIPF_IS_SPRITES_BORDER    },
  { "SCANDBL",                             DIPF_IS_SCANDBL           },
  { "SPRITES_CHNG_BASE",                   DIPF_IS_SPRITES_CHNG_BASE },
  { "SPRITES_CHNG_PRI",                    DIPF_IS_SPRITES_CHNG_PRI  },
  { "DBUFFER",                             DIPF_IS_DBUFFER           },
  { "PROGBEAM",                            DIPF_IS_PROGBEAM          },
  { "FOREIGN",                             DIPF_IS_FOREIGN           },

  /*
   * These are new flags and they are not defined in NDK!
  */
  { "YCOFACT",                             DIPF_IS_YCOFACT           },
  { "SIMILAR",                             DIPF_IS_SIMILAR           },
  { NULL,                                  NULL                      }
};
#endif

#endif /* ___FINDGFXENTRY_H_INCLUDED___ */
