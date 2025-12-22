OPT MODULE
OPT EXPORT

MODULE 'utility/tagitem',
       'graphics/gfx',
       'graphics/rastport',
       'intuition/screens'

CONST   TAG_MCLV_BASE       = TAG_USER+2000

CONST   MCLV_COLUMNS        = TAG_MCLV_BASE+1,  /* I-G-U */
        MCLV_COLUMNWEIGHTS  = TAG_MCLV_BASE+2,  /* ISG-U */
        MCLV_DRAGCOLUMNS    = TAG_MCLV_BASE+3,  /* ISG-U */
        MCLV_TITLES         = TAG_MCLV_BASE+4,  /* ISG-U */
        MCLV_DISPLAYHOOK    = TAG_MCLV_BASE+5,  /* I-G-- */
        MCLV_TITLEHOOK      = TAG_MCLV_BASE+6   /* I-G-- */

OBJECT mclvrender
    rport:PTR TO rastport
    drawinfo:PTR TO drawinfo
    bounds:PTR TO rectangle
    entry:PTR TO LONG
    state:LONG
    flags:LONG
    column:LONG
ENDOBJECT
