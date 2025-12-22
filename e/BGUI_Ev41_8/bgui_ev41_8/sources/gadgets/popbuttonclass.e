OPT MODULE
OPT EXPORT

MODULE 'utility/tagitem'

/*
**  An array of these objects define
**  the menu labels.
**/
OBJECT popMenu
    label:PTR TO CHAR   /* Menu text, NIL terminates array. */
    flags:INT           /* See below. */
    mutualExclude:LONG  /* Mutual-exclusion. */
ENDOBJECT

/* Flags */
CONST PMF_CHECKIT     = 1          /* Checkable (toggle) item. */
CONST PMF_CHECKED     = 2          /* The item is checked. */
CONST PMF_DISABLED    = 4          /* The item is disabled. (NMC:Added) */

/*
**  Special menu entry.
**/
CONST PMB_BARLABEL    = -1

/* Tags */
/*
**  All labelclass attributes are usable at create time (I).
**  The vectorclass attributes are usable at create time and
**  with OM_SET (IS).
**/
CONST PMB_Image                 = TAG_USER+$70021    /* IS--- */
CONST PMB_MenuEntries           = TAG_USER+$70022    /* IS--- */
CONST PMB_MenuNumber            = TAG_USER+$70023    /* --GN- */
CONST PMB_PopPosition           = TAG_USER+$70024    /* I---- */

/* TAG_USER+0x70025 through TAG_USER+0x70040 reserved. */

/* Methods */
CONST PMBM_CHECK_STATUS   = $70000
CONST PMBM_CHECK_MENU     = $70001
CONST PMBM_UNCHECK_MENU   = $70002
CONST PMBM_ENABLE_ITEM    = $70003         /* NMC:Added */
CONST PMBM_DISABLE_ITEM   = $70004         /* NMC:Added */
CONST PMBM_ENABLE_STATUS  = $70005         /* NMC:Added */

OBJECT pmbmCommand
    methodID:LONG
    menuNumber:LONG    /* Menu to do it on. */
ENDOBJECT
