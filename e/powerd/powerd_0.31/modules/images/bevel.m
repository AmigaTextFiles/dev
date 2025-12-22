CONST BEVEL_Dummy=$85016000,
 BEVEL_Style=(BEVEL_Dummy+1),
 BEVEL_Label=(BEVEL_Dummy+3),
 BEVEL_LabelImage=(BEVEL_Dummy+4),
 BEVEL_LabelPlace=(BEVEL_Dummy+5),
 BEVEL_InnerTop=(BEVEL_Dummy+6),
 BEVEL_InnerLeft=(BEVEL_Dummy+7),
 BEVEL_InnerWidth=(BEVEL_Dummy+8),
 BEVEL_InnerHeight=(BEVEL_Dummy+9),
 BEVEL_HorizSize=(BEVEL_Dummy+10),
 BEVEL_HorzSize=BEVEL_HorizSize,
 BEVEL_VertSize=(BEVEL_Dummy+11),
 BEVEL_FillPen=(BEVEL_Dummy+12),
 BEVEL_FillPattern=(BEVEL_Dummy+13),
 BEVEL_TextPen=(BEVEL_Dummy+14),
 BEVEL_Transparent=(BEVEL_Dummy+15),
 BEVEL_SoftStyle=(BEVEL_Dummy+16),
 BEVEL_ColorMap=(BEVEL_Dummy+17),
 BEVEL_ColourMap=BEVEL_ColorMap,
 BEVEL_Flags=(BEVEL_Dummy+18),
 BVS_THIN=0, /* Thin (usually 1 pixel) bevel. */
 BVS_BUTTON=1, /* Standard button bevel. */
 BVS_GROUP=2, /* Group box bevel. */
 BVS_FIELD=3, /* String/integer/text field bevel. */
 BVS_NONE=4, /* No not render any bevel. */
 BVS_DROPBOX=5, /* Drop box area. */
/*
 * You may think it is very stupid to name the vertical bar BVS_SBAR_HORIZ
 * and the horizontal bar BVS_SBAR_VERT. The reason for this is:
 * The vertical bar is mostly used as a seperator in horizontal groups and the
 * horizontal bar is used as a seperator in vertical groups.
 *
 * Another explanation: It was simply a mistake when defining the names the
 * first time.
 */
 BVS_SBAR_HORIZ=6, /* Vertical bar. */
 BVS_SBAR_VERT=7, /* Horizontal bar. */
 BVS_BOX=8, /* Typically, thin black border. */
 BVS_STANDARD=11,  /* Same as BVS_BUTTON but will not support XEN */
 BVS_SBAR_HORZ=BVS_SBAR_HORIZ,  /* OBSOLETE SPELLING */
/* The following bevel types are not implemented yet
 */
 BVS_FOCUS=9, /* Typically, the border for drag&drop target. */
 BVS_RADIOBUTTON=10,   /* (not implemented) radiobutton bevel. */
/* BEVEL_Flags - CURRENTLY PRIVATE!!
 */
 BFLG_XENFILL=1,
 BFLG_TRANS=2,
/* Bevel Box Locations for BEVEL_LabelPlace.  Typically used to label a group
 * box, or to be utilized via a button or status gadgets.
 */
 BVJ_TOP_CENTER=0,
 BVJ_TOP_LEFT=1,
 BVJ_TOP_RIGHT=2,
 BVJ_IN_CENTER=3,
 BVJ_IN_LEFT=4,
 BVJ_IN_RIGHT=5,
 BVJ_BOT_CENTER=6,
 BVJ_BOT_LEFT=7,
 BVJ_BOT_RIGHT=8
