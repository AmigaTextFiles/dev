/* $VER: listbrowser.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/gadgetclass'
MODULE 'target/utility/tagitem', 'target/exec/types', 'target/intuition/cghooks', 'target/exec/nodes', 'target/utility/hooks', 'target/graphics/rastport', 'target/intuition/screens', 'target/graphics/gfx'
{#include <gadgets/listbrowser.h>}
NATIVE {GADGETS_LISTBROWSER_H} CONST

/* LBM_ADDNODE creates a listbrowser node and inserts it to the currently
 * attached list. The number of columns is automatically set according to the
 * object's column number. If the node would become visible, it is automatically
 * rendered. This method returns the address of the new node. (V41)
 */
NATIVE {LBM_ADDNODE} CONST LBM_ADDNODE = ($580001)

NATIVE {lbAddNode} OBJECT addnode
    {MethodID}	methodid	:ULONG      /* LBM_ADDNODE */
    {lba_GInfo}	ginfo	:PTR TO gadgetinfo     /* to provide rendering info */
    {lba_Node}	node	:PTR TO ln      /* Insert() after this node */
    {lba_NodeAttrs}	nodeattrs	:PTR TO tagitem /* LBNA tag list */
ENDOBJECT


/* LBM_REMNODE removes and frees the chosen node. If the node was visible, the
 * display is updated. The method returns 1 if the operation was successful.
 * (V41)
 */
NATIVE {LBM_REMNODE} CONST LBM_REMNODE = ($580002)

NATIVE {lbRemNode} OBJECT remnode
    {MethodID}	methodid	:ULONG  /* LBM_REMNODE */
    {lbr_GInfo}	ginfo	:PTR TO gadgetinfo /* to provide rendering info */
    {lbr_Node}	node	:PTR TO ln  /* Remove() this node */
ENDOBJECT


/* LBM_EDITNODE changes the chosen node's attributes and renders the
 * changes. The method returns 1 if the operation was successful. (V41)
 */
NATIVE {LBM_EDITNODE} CONST LBM_EDITNODE = ($580003)

NATIVE {lbEditNode} OBJECT editnode
    {MethodID}	methodid	:ULONG      /* LBM_EDITNODE */
    {lbe_GInfo}	ginfo	:PTR TO gadgetinfo     /* to provide rendering info */
    {lbe_Node}	node	:PTR TO ln      /* modify this node */
    {lbe_NodeAttrs}	nodeattrs	:PTR TO tagitem /* according to this tag list */
ENDOBJECT


/* LBM_SORT */
NATIVE {LBM_SORT} CONST LBM_SORT = ($580004)

NATIVE {lbSort} OBJECT lbsort
	{MethodID}	methodid	:ULONG        /* LBM_SORT */
	{lbs_GInfo}	ginfo	:PTR TO gadgetinfo       /* to provide rendering info */
	{lbs_Column}	column	:ULONG      /* Column to sort by */
	{lbs_Direction}	direction	:ULONG   /* Sort direction (see below) */
->	{lbs_Direction }	reverse	:ULONG	->for backwards compatibility
    {lbs_CompareHook}	comparehook	:PTR TO hook /* Optional hook to compare items */
ENDOBJECT

-> For compatibility only; do not use in new code.
NATIVE {lbs_Reverse} CONST

NATIVE {LBMSORT_FORWARD}  CONST LBMSORT_FORWARD  = 0  -> Forward sort (down sort arrow)
NATIVE {LBMSORT_REVERSE}  CONST LBMSORT_REVERSE  = 1  -> Reverse sort (up sort arrow)

/* LBM_SHOWCHILDREN */
NATIVE {LBM_SHOWCHILDREN} CONST LBM_SHOWCHILDREN = ($580005)

NATIVE {lbShowChildren} OBJECT lbshowchildren
    {MethodID}	methodid	:ULONG   /* LBM_SHOWCHILDREN */
    {lbsc_GInfo}	ginfo	:PTR TO gadgetinfo /* to provide rendering info */
    {lbsc_Node}	node	:PTR TO ln  /* Starting ParentNode,
                                       NULL means start at root. */
    {lbsc_Depth}	depth	:INT /* Depth to Show */
ENDOBJECT


/* LBM_HIDECHILDREN
 */
NATIVE {LBM_HIDECHILDREN} CONST LBM_HIDECHILDREN = ($580006)

NATIVE {lbHideChildren} OBJECT lbhidechildren
    {MethodID}	methodid	:ULONG   /* LBM_HIDECHILDREN */
    {lbhc_GInfo}	ginfo	:PTR TO gadgetinfo /* to provide rendering info */
    {lbhc_Node}	node	:PTR TO ln  /* Starting ParentNode,
                                       NULL means start at root. */
    {lbhc_Depth}	depth	:INT /* Depth to Hide */
ENDOBJECT

/*****************************************************************************/

/* ListBrowser Node attributes. */
NATIVE {LBNA_Dummy}                CONST LBNA_DUMMY                = (TAG_USER+$5003500)

NATIVE {LBNA_Selected}             CONST LBNA_SELECTED             = (LBNA_DUMMY+1)
    /* (BOOL) If the node is to be selected.  Defaults to FALSE. */

NATIVE {LBNA_Flags}                CONST LBNA_FLAGS                = (LBNA_DUMMY+2)
    /* (uint32) Flags for the node.  Defaults to 0. */

NATIVE {LBNA_UserData}             CONST LBNA_USERDATA             = (LBNA_DUMMY+3)
    /* (uint32) User data.  Defaults to NULL. */

NATIVE {LBNA_Column}               CONST LBNA_COLUMN               = (LBNA_DUMMY+4)
    /* (int16) Column in the node that the attributes below affect.
       Defaults to 0. */

NATIVE {LBNCA_Text}                CONST LBNCA_TEXT                = (LBNA_DUMMY+5)
    /* (CONST_STRPTR) Text to display in the column. Defaults to NULL. */

NATIVE {LBNCA_Integer}             CONST LBNCA_INTEGER             = (LBNA_DUMMY+6)
    /* (int32 *) Pointer to an integer to display in the column.
       Defaults to NULL. */

NATIVE {LBNCA_FGPen}               CONST LBNCA_FGPEN               = (LBNA_DUMMY+7)
    /* (int16) Column foreground pen. */

NATIVE {LBNCA_BGPen}               CONST LBNCA_BGPEN               = (LBNA_DUMMY+8)
    /* (int16) Column background pen. */

NATIVE {LBNCA_Image}               CONST LBNCA_IMAGE               = (LBNA_DUMMY+9)
    /* (struct Image *) Image to display in the column.  Defaults to NULL. */

NATIVE {LBNCA_SelImage}            CONST LBNCA_SELIMAGE            = (LBNA_DUMMY+10)
    /* (struct Image *) Image to display in column when selected.
       Defaults to NULL. */

NATIVE {LBNCA_HorizJustify}        CONST LBNCA_HORIZJUSTIFY        = (LBNA_DUMMY+11)
NATIVE {LBNCA_Justification}       CONST LBNCA_JUSTIFICATION       = LBNCA_HORIZJUSTIFY
    /* (uint32) Column justification.  Defaults to LCJ_LEFT. */

NATIVE {LBNA_Generation}           CONST LBNA_GENERATION           = (LBNA_DUMMY+12)
    /* (uint32) Node generation (1..N).  Defaults to 0 (no generation). */

NATIVE {LBNCA_Editable}            CONST LBNCA_EDITABLE            = (LBNA_DUMMY+13)
    /* (BOOL) If this column is editable.  Requires LBNCA_CopyText.
       Defaults to FALSE. */

NATIVE {LBNCA_MaxChars}            CONST LBNCA_MAXCHARS            = (LBNA_DUMMY+14)
    /* (int16) Maximum characters in an editable entry.  Required when using
       LBNCA_Editable. */

NATIVE {LBNCA_CopyText}            CONST LBNCA_COPYTEXT            = (LBNA_DUMMY+15)
    /* (BOOL) Copy the LBNCA_Text contents to an internal buffer. */

NATIVE {LBNA_CheckBox}             CONST LBNA_CHECKBOX             = (LBNA_DUMMY+16)
    /* (BOOL) This is a checkbox node. */

NATIVE {LBNA_Checked}              CONST LBNA_CHECKED              = (LBNA_DUMMY+17)
    /* (BOOL) If true, this checkbox node is checked. */

NATIVE {LBNA_NodeSize}             CONST LBNA_NODESIZE             = (LBNA_DUMMY+18)
    /* (uint32) Size of custom node (and optimize mempool puddles). */

NATIVE {LBNCA_EditTags}            CONST LBNCA_EDITTAGS            = (LBNA_DUMMY+19)
    /* (struct TagItem *) Tag list for string gadget used to edit column. */

NATIVE {LBNCA_RenderHook}          CONST LBNCA_RENDERHOOK          = (LBNA_DUMMY+20)
    /* (struct Hook *) Effectively the same as GadTools listview hook. */

NATIVE {LBNCA_HookHeight}          CONST LBNCA_HOOKHEIGHT          = (LBNA_DUMMY+22)
    /* (int16) Height in pixels of the hook function rendering. */

NATIVE {LBNA_MemPool}              CONST LBNA_MEMPOOL              = (LBNA_DUMMY+23)
    /* (APTR) Exec memory pool to use for this node's allocations. */

NATIVE {LBNA_NumColumns}           CONST LBNA_NUMCOLUMNS           = (LBNA_DUMMY+24)
    /* (int16) For GetListBrowserNodeAttrs() only! */

NATIVE {LBNA_Priority}             CONST LBNA_PRIORITY             = (LBNA_DUMMY+25)
    /* (int8) Sets the Exec node->ln_Pri. */

NATIVE {LBNCA_CopyInteger}         CONST LBNCA_COPYINTEGER         = (LBNA_DUMMY+26)
    /* (BOOL) AllocListBrowserNodeAttrs() or SetListBrowserNodeAttrs()
       only! */

NATIVE {LBNCA_WordWrap}            CONST LBNCA_WORDWRAP            = (LBNA_DUMMY+27)
    /* (BOOL) Word wrap this node's LBNCA_Text data. */

NATIVE {LBNCA_VertJustify}         CONST LBNCA_VERTJUSTIFY         = (LBNA_DUMMY+28)
    /* (uint32) Row justification.  Defaults to LRJ_BOTTOM. */

NATIVE {LBNCA_FillPen}             CONST LBNCA_FILLPEN             = (LBNA_DUMMY+29)
    /* (int16) Column fill pen. (V51) */


/* ListBrowser ColumnInfo attributes. */
NATIVE {LBCIA_MemPool}             CONST LBCIA_MEMPOOL             = (LBNA_DUMMY+50)
    /* (APTR) MemPool for ColumnInfo (V45) */

NATIVE {LBCIA_Column}              CONST LBCIA_COLUMN              = (LBNA_DUMMY+51)
    /* (int16) Column number (0..N) (V45) */

NATIVE {LBCIA_Title}               CONST LBCIA_TITLE               = (LBNA_DUMMY+52)
    /* (CONST_STRPTR) Column text label. (V45) */

NATIVE {LBCIA_Weight}              CONST LBCIA_WEIGHT              = (LBNA_DUMMY+53)
    /* (int16) Column weight (implies ~CIF_FIXED) (V45) */

NATIVE {LBCIA_Width}               CONST LBCIA_WIDTH               = (LBNA_DUMMY+54)
    /* (int16) Column width in pixels (implies CIF_FIXED) (V45) */

NATIVE {LBCIA_Flags}               CONST LBCIA_FLAGS               = (LBNA_DUMMY+55)
    /* (uint32) Column flags (defined below) (V45) */

NATIVE {LBNCA_SoftStyle}           CONST LBNCA_SOFTSTYLE           = (LBNA_DUMMY+56)
    /* (uint8) Text font style (V52.14) */

NATIVE {LBCIA_UserData}            CONST LBCIA_USERDATA            = (LBNA_DUMMY+57)
    /* (APTR) User data (V53.16) */

NATIVE {LBCIA_AutoSort}            CONST LBCIA_AUTOSORT            = (LBNA_DUMMY+58)
    /* (BOOL) Automatically sort this column (V53.17) */

NATIVE {LBCIA_SortDirection}       CONST LBCIA_SORTDIRECTION       = (LBNA_DUMMY+59)
    /* (uint32) Direction of the sort (V53.17) */

NATIVE {LBCIA_CompareHook}         CONST LBCIA_COMPAREHOOK         = (LBNA_DUMMY+60)
    /* (struct Hook *) Sort comparison hook (V53.17) */

NATIVE {LBCIA_Sortable}            CONST LBCIA_SORTABLE            = (LBNA_DUMMY+61)
    /* (BOOL) Column is sortable (V53.17) */

NATIVE {LBCIA_DraggableSeparator}  CONST LBCIA_DRAGGABLESEPARATOR  = (LBNA_DUMMY+62)
    /* (BOOL) Column separator is draggable (V53.17) */

NATIVE {LBCIA_Separator}           CONST LBCIA_SEPARATOR           = (LBNA_DUMMY+63)
    /* (BOOL) Column has separators (V53.17) */

NATIVE {LBCIA_SortArrow}           CONST LBCIA_SORTARROW           = (LBNA_DUMMY+64)
    /* (BOOL) Column has a sort arrow (V53.17) */


/* Flags for the LBNA_Flags node attribute. */
NATIVE {LBFLG_READONLY}      CONST LBFLG_READONLY      = 1
NATIVE {LBFLG_CUSTOMPENS}    CONST LBFLG_CUSTOMPENS    = 2
NATIVE {LBFLG_HASCHILDREN}   CONST LBFLG_HASCHILDREN   = 4
NATIVE {LBFLG_SHOWCHILDREN}  CONST LBFLG_SHOWCHILDREN  = 8
NATIVE {LBFLG_HIDDEN}       CONST LBFLG_HIDDEN       = 16


/* Justification modes for the LBNA_HorizJustify node column attribute. */
NATIVE {LCJ_LEFT}   CONST LCJ_LEFT   = 0
NATIVE {LCJ_CENTER} CONST LCJ_CENTER = 1
NATIVE {LCJ_RIGHT}  CONST LCJ_RIGHT  = 2
NATIVE {LCJ_CENTRE} CONST LCJ_CENTRE = LCJ_CENTER

/* Justification modes for the LBNA_VertJustify node column attribute. */
NATIVE {LRJ_BOTTOM} CONST LRJ_BOTTOM = 0
NATIVE {LRJ_CENTER} CONST LRJ_CENTER = 1
NATIVE {LRJ_TOP}    CONST LRJ_TOP    = 2
NATIVE {LRJ_CENTRE} CONST LRJ_CENTRE = LRJ_CENTER

/* These definitions are for the LBNCA_RenderHook tag. */

/* The different types of messages that a listview callback hook can see.
 */
NATIVE {LB_DRAW} CONST LB_DRAW = $202 /* Draw yourself, with state */

/* Possible return values from a render hook.
 */
NATIVE {LBCB_OK}      CONST LBCB_OK      = 0 /* callback understands this message type */
NATIVE {LBCB_UNKNOWN} CONST LBCB_UNKNOWN = 1 /* callback does not understand this message */

/* States for LBDrawMsg.lbdm_State.
 */
NATIVE {LBR_NORMAL}   CONST LBR_NORMAL   = 0 /* The usual */
NATIVE {LBR_SELECTED} CONST LBR_SELECTED = 1 /* For selected gadgets    */

/* Structure of LB_DRAW messages, object is a (struct Node *). */
NATIVE {LBDrawMsg} OBJECT lbdrawmsg
    {lbdm_MethodID}	methodid	:ULONG /* LV_DRAW */
    {lbdm_RastPort}	rastport	:PTR TO rastport /* Where to render to */
    {lbdm_DrawInfo}	drawinfo	:PTR TO drawinfo /* Useful to have around */
    {lbdm_Bounds}	bounds	:rectangle   /* Limits of where to render */
    {lbdm_State}	state	:ULONG    /* How to render */
ENDOBJECT


/* Sort Hook Data Structure.
 */
NATIVE {LBSortMsg} OBJECT lbsortmsg
    -> Data for Node A.
    {lbsm_TypeA}	typea	:ULONG

    {lbsm_DataA.Integer}	dataa_integer	:VALUE
    {lbsm_DataA.Text}	dataa_text	:CONST_STRPTR

    {lbsm_UserDataA}	userdataa	:APTR


    -> Data for Node B.
    {lbsm_TypeB}	typeb	:ULONG
    {lbsm_DataB.Integer}	datab_integer	:VALUE
    {lbsm_DataB.Text}	datab_text	:CONST_STRPTR

    {lbsm_UserDataB}	userdatab	:APTR

    {lbsm_Column}	column	:INT     -> Column number  (V53.18)
    {lbsm_Direction}	direction	:ULONG  -> Sort direction (V53.18)

	{lbsm_CheckedA}	checkeda	:INT   -> Checkbox state (V53.41)
	{lbsm_CheckedB}	checkedb	:INT   -> Checkbox state (V53.41)
ENDOBJECT


/*****************************************************************************/

/* Information for columns of the list browser.
 *
 * NOTE:
 * Since V53.16 this structure is retained for backwards compatibility only.
 * Use the AllocLBColumnInfoA() family of functions to safely manipulate
 * and retrieve all column information. This structure has been extended
 * and will continue to be extended in the future. Do not depend on any
 * of the fields in this structure for any purpose.
 */
NATIVE {ColumnInfo} OBJECT columninfo
    {ci_Width}	width	:INT
    {ci_Title}	title	:CONST_STRPTR
    {ci_Flags}	flags	:ULONG
ENDOBJECT

/* Possible ColumnInfo flags (deprecated: use equivalent tags instead) */
NATIVE {CIF_WEIGHTED}      CONST CIF_WEIGHTED      = 0  -> weighted width column (default)
NATIVE {CIF_FIXED}         CONST CIF_FIXED         = 1  -> fixed pixel width specified in ci_Width
NATIVE {CIF_DRAGGABLE}     CONST CIF_DRAGGABLE     = 2  -> separator is user draggable
NATIVE {CIF_NOSEPARATORS}  CONST CIF_NOSEPARATORS  = 4  -> no separator on this column
NATIVE {CIF_SORTABLE}      CONST CIF_SORTABLE      = 8  -> column is sortable (see LBM_SORT)


/*****************************************************************************/

/* Additional attributes defined by the List Browser class
 */
NATIVE {LISTBROWSER_Dummy}             CONST LISTBROWSER_DUMMY             = (REACTION_DUMMY+$0003000)

NATIVE {LISTBROWSER_Top}               CONST LISTBROWSER_TOP               = (LISTBROWSER_DUMMY+1)
    /* (int32) Top position node. Defaults to 0. */

NATIVE {LISTBROWSER_Reserved1}         CONST LISTBROWSER_RESERVED1         = (LISTBROWSER_DUMMY+2)
    /* RESERVED */

NATIVE {LISTBROWSER_Labels}            CONST LISTBROWSER_LABELS            = (LISTBROWSER_DUMMY+3)
    /* (struct List *) Defaults to ~0. */

NATIVE {LISTBROWSER_Selected}          CONST LISTBROWSER_SELECTED          = (LISTBROWSER_DUMMY+4)
    /* (int32) Numeric index of node currently selected; defaults to -1. */

NATIVE {LISTBROWSER_SelectedNode}      CONST LISTBROWSER_SELECTEDNODE      = (LISTBROWSER_DUMMY+5)
    /* (struct Node *) Node currently selected. */

NATIVE {LISTBROWSER_MultiSelect}       CONST LISTBROWSER_MULTISELECT       = (LISTBROWSER_DUMMY+6)
    /* (BOOL) Allow multiple selection. Defaults to FALSE. */

NATIVE {LISTBROWSER_VertSeparators}    CONST LISTBROWSER_VERTSEPARATORS    = (LISTBROWSER_DUMMY+7)
NATIVE {LISTBROWSER_Separators}        CONST LISTBROWSER_SEPARATORS        = LISTBROWSER_VERTSEPARATORS
    /* (BOOL) Render column separators. Defaults to TRUE. */

NATIVE {LISTBROWSER_ColumnInfo}        CONST LISTBROWSER_COLUMNINFO        = (LISTBROWSER_DUMMY+8)
    /* (struct ColumnInfo *) Column information. Defaults to NULL. */

NATIVE {LISTBROWSER_MakeVisible}       CONST LISTBROWSER_MAKEVISIBLE       = (LISTBROWSER_DUMMY+9)
    /* (int32) Move this node into view. Defaults to 0. */

NATIVE {LISTBROWSER_VirtualWidth}      CONST LISTBROWSER_VIRTUALWIDTH      = (LISTBROWSER_DUMMY+10)
    /* (int16) Virtual width of the item list. Defaults to 0. */

NATIVE {LISTBROWSER_Borderless}        CONST LISTBROWSER_BORDERLESS        = (LISTBROWSER_DUMMY+11)
    /* (BOOL) Don't render a frame around the list. Defaults to FALSE. */

NATIVE {LISTBROWSER_VerticalProp}      CONST LISTBROWSER_VERTICALPROP      = (LISTBROWSER_DUMMY+12)
    /* (BOOL) The listbrowser has a vertical scroller. Defaults to TRUE. */

NATIVE {LISTBROWSER_HorizontalProp}    CONST LISTBROWSER_HORIZONTALPROP    = (LISTBROWSER_DUMMY+13)
    /* (BOOL) The listbrowser has a horizontal scroller. Defaults to FALSE. */

NATIVE {LISTBROWSER_Left}              CONST LISTBROWSER_LEFT              = (LISTBROWSER_DUMMY+14)
    /* (int16) First visible pixel column. Defaults to 0. */

NATIVE {LISTBROWSER_Reserved2}         CONST LISTBROWSER_RESERVED2         = (LISTBROWSER_DUMMY+15)
    /* RESERVED */

NATIVE {LISTBROWSER_AutoFit}           CONST LISTBROWSER_AUTOFIT           = (LISTBROWSER_DUMMY+16)
    /* (BOOL) Compute width of columns automatically. Defaults to FALSE. */

NATIVE {LISTBROWSER_ColumnTitles}      CONST LISTBROWSER_COLUMNTITLES      = (LISTBROWSER_DUMMY+17)
    /* (BOOL) Display titles of columns. Defaults to FALSE. */

NATIVE {LISTBROWSER_ShowSelected}      CONST LISTBROWSER_SHOWSELECTED      = (LISTBROWSER_DUMMY+18)
    /* (BOOL) The selected item stays highlighted. Defaults to FALSE. */

NATIVE {LISTBROWSER_VPropTotal}        CONST LISTBROWSER_VPROPTOTAL        = (LISTBROWSER_DUMMY+19)
NATIVE {LISTBROWSER_VPropTop}          CONST LISTBROWSER_VPROPTOP          = (LISTBROWSER_DUMMY+20)
NATIVE {LISTBROWSER_VPropVisible}      CONST LISTBROWSER_VPROPVISIBLE      = (LISTBROWSER_DUMMY+21)
    /* (uint32) State of the vertical prop gadget (if any). */

NATIVE {LISTBROWSER_HPropTotal}        CONST LISTBROWSER_HPROPTOTAL        = (LISTBROWSER_DUMMY+22)
NATIVE {LISTBROWSER_HPropTop}          CONST LISTBROWSER_HPROPTOP          = (LISTBROWSER_DUMMY+23)
NATIVE {LISTBROWSER_HPropVisible}      CONST LISTBROWSER_HPROPVISIBLE      = (LISTBROWSER_DUMMY+24)
    /* (uint32) State of the horizontal prop gadget (if any). */

NATIVE {LISTBROWSER_MouseX}            CONST LISTBROWSER_MOUSEX            = (LISTBROWSER_DUMMY+25)
NATIVE {LISTBROWSER_MouseY}            CONST LISTBROWSER_MOUSEY            = (LISTBROWSER_DUMMY+26)
    /* (int16) Returns position of mouse release. */

NATIVE {LISTBROWSER_Hierarchical}      CONST LISTBROWSER_HIERARCHICAL      = (LISTBROWSER_DUMMY+27)
    /* (BOOL) Enables ListTree mode. Defaults to FALSE. */

NATIVE {LISTBROWSER_ShowImage}         CONST LISTBROWSER_SHOWIMAGE         = (LISTBROWSER_DUMMY+28)
    /* (struct Image *) ListTree expanded branch custom image.
       Defaults to NULL. */

NATIVE {LISTBROWSER_HideImage}         CONST LISTBROWSER_HIDEIMAGE         = (LISTBROWSER_DUMMY+29)
    /* (struct Image *) ListTree collapsed branch custom image.
       Defaults to NULL. */

NATIVE {LISTBROWSER_LeafImage}         CONST LISTBROWSER_LEAFIMAGE         = (LISTBROWSER_DUMMY+30)
    /* (struct Image *) ListTree branch item custom image.
       Defaults to NULL. */

NATIVE {LISTBROWSER_ScrollRaster}      CONST LISTBROWSER_SCROLLRASTER      = (LISTBROWSER_DUMMY+31)
    /* (BOOL) See autodocs for Intuition V37 bug.  Defaults to TRUE. */

NATIVE {LISTBROWSER_Spacing}           CONST LISTBROWSER_SPACING           = (LISTBROWSER_DUMMY+32)
    /* (int16) Additional vertical spacing for nodes. Defaults to 0. */

NATIVE {LISTBROWSER_Editable}          CONST LISTBROWSER_EDITABLE          = (LISTBROWSER_DUMMY+33)
    /* (int16) Allow inline editing of node text. Defaults to FALSE. */

NATIVE {LISTBROWSER_EditNode}          CONST LISTBROWSER_EDITNODE          = (LISTBROWSER_DUMMY+35)
    /* (int32) Specify a node to edit. */

NATIVE {LISTBROWSER_EditColumn}        CONST LISTBROWSER_EDITCOLUMN        = (LISTBROWSER_DUMMY+36)
    /* (int16) Specify a column to edit. */

NATIVE {LISTBROWSER_EditTags}          CONST LISTBROWSER_EDITTAGS          = (LISTBROWSER_DUMMY+39)
    /* (struct TagItem *) Tag list passed to editable node string gadget.
       Defaults to NULL. */

NATIVE {LISTBROWSER_Position}          CONST LISTBROWSER_POSITION          = (LISTBROWSER_DUMMY+34)
    /* (uint32) Change the view position. See possible values below. */

NATIVE {LISTBROWSER_RelEvent}          CONST LISTBROWSER_RELEVENT          = (LISTBROWSER_DUMMY+37)
    /* (uint32) Event that caused the last message from the listbrowser.
       See possible values below. */

NATIVE {LISTBROWSER_NumSelected}       CONST LISTBROWSER_NUMSELECTED       = (LISTBROWSER_DUMMY+38)
    /* (int32) Number of selected nodes. */

NATIVE {LISTBROWSER_RelColumn}         CONST LISTBROWSER_RELCOLUMN         = (LISTBROWSER_DUMMY+40)
    /* (int16) Column number clicked on, or edited inline. */

NATIVE {LISTBROWSER_HorizSeparators}   CONST LISTBROWSER_HORIZSEPARATORS   = (LISTBROWSER_DUMMY+41)
    /* (BOOL) Show horizontal node separators. */

NATIVE {LISTBROWSER_CheckImage}        CONST LISTBROWSER_CHECKIMAGE        = (LISTBROWSER_DUMMY+42)
    /* (struct Image *) Custom checkbox image for checked state. */

NATIVE {LISTBROWSER_UncheckedImage}    CONST LISTBROWSER_UNCHECKEDIMAGE    = (LISTBROWSER_DUMMY+43)
    /* (struct Image *) Custom checkbox image for unchecked state. */

NATIVE {LISTBROWSER_TotalNodes}        CONST LISTBROWSER_TOTALNODES        = (LISTBROWSER_DUMMY+44)
    /* (int32) Total node count. */

NATIVE {LISTBROWSER_MinNodeSize}       CONST LISTBROWSER_MINNODESIZE       = (LISTBROWSER_DUMMY+45)
    /* (int32) Minimum Node size for custom node MemPool optimization. */

NATIVE {LISTBROWSER_TitleClickable}    CONST LISTBROWSER_TITLECLICKABLE    = (LISTBROWSER_DUMMY+46)
    /* (BOOL) Allow column title bar clicking. */

NATIVE {LISTBROWSER_MinVisible}        CONST LISTBROWSER_MINVISIBLE        = (LISTBROWSER_DUMMY+47)
    /* (int32) Minimum visible node count. This causes the minimum
       domain to be large enough to hold the specified number of nodes
       using the estimated average node height. Note, ESTIMATED, this
       is not a guaranteed result. The result may be slightly more or
       less than specified, and potentially a lot greater if other objects
       within the layout group cause the listbrowser to layout larger
       than its minimum domain. */

NATIVE {LISTBROWSER_Reserved6}         CONST LISTBROWSER_RESERVED6         = (LISTBROWSER_DUMMY+48)
    /* RESERVED */

NATIVE {LISTBROWSER_Reserved7}         CONST LISTBROWSER_RESERVED7         = (LISTBROWSER_DUMMY+49)
    /* RESERVED */

NATIVE {LISTBROWSER_PersistSelect}     CONST LISTBROWSER_PERSISTSELECT     = (LISTBROWSER_DUMMY+50)
    /* (int32) When set to TRUE, SHIFT key is NOT required for multi-select. */

NATIVE {LISTBROWSER_CursorSelect}      CONST LISTBROWSER_CURSORSELECT      = (LISTBROWSER_DUMMY+51)
    /* (int32) Keyboard cursor selected node number. */

NATIVE {LISTBROWSER_CursorNode}        CONST LISTBROWSER_CURSORNODE        = (LISTBROWSER_DUMMY+52)
    /* (struct Node *) Keyboard cursor selected node. */

NATIVE {LISTBROWSER_FastRender}        CONST LISTBROWSER_FASTRENDER        = (LISTBROWSER_DUMMY+53)
    /* Obsolete */

NATIVE {LISTBROWSER_TotalVisibleNodes} CONST LISTBROWSER_TOTALVISIBLENODES = (LISTBROWSER_DUMMY+54)
    /* (int32) Total visible node count. */

NATIVE {LISTBROWSER_WrapText}          CONST LISTBROWSER_WRAPTEXT          = (LISTBROWSER_DUMMY+55)
    /* (BOOL) Enable word wrap of text nodes. */

NATIVE {LISTBROWSER_MemPool}           CONST LISTBROWSER_MEMPOOL           = (LISTBROWSER_DUMMY+56)
    /* (APTR) Exec memory pool to use for this object's allocations. (V51) */

NATIVE {LISTBROWSER_Bottom}            CONST LISTBROWSER_BOTTOM            = (LISTBROWSER_DUMMY+57)
    /* (int32) Bottom position node. Defaults to 0. (V52.7) */

NATIVE {LISTBROWSER_MakeNodeVisible}   CONST LISTBROWSER_MAKENODEVISIBLE   = (LISTBROWSER_DUMMY+58)
    /* (struct Node *) Causes the specified node to be brought into view (V52.11) */

NATIVE {LISTBROWSER_AutoVirtualWidth}  CONST LISTBROWSER_AUTOVIRTUALWIDTH  = (LISTBROWSER_DUMMY+59)
    /* let the gadget set the virtual width for us */

NATIVE {LISTBROWSER_HintInfoHook}      CONST LISTBROWSER_HINTINFOHOOK      = (LISTBROWSER_DUMMY+60)
    /* (struct Hook *) Hook to be called when the GM_QUERY method is invoked (V53.11) */

NATIVE {LISTBROWSER_SortColumn}        CONST LISTBROWSER_SORTCOLUMN        = (LISTBROWSER_DUMMY+61)
    /* (int16) Column number to sort (V53.17) */

NATIVE {LISTBROWSER_Striping}          CONST LISTBROWSER_STRIPING          = (LISTBROWSER_DUMMY+62)
    /* (uint32) Striping effects. See below for defines. (V53.18) */

NATIVE {LISTBROWSER_AllowNoSelection}  CONST LISTBROWSER_ALLOWNOSELECTION  = (LISTBROWSER_DUMMY+63)
    /* (BOOL)  Allow notification if no item is selected */


/* Possible values for LISTBROWSER_Position.
 */
NATIVE {LBP_LINEUP}      CONST LBP_LINEUP      = 1
NATIVE {LBP_LINEDOWN}    CONST LBP_LINEDOWN    = 2
NATIVE {LBP_PAGEUP}      CONST LBP_PAGEUP      = 3
NATIVE {LBP_PAGEDOWN}    CONST LBP_PAGEDOWN    = 4
NATIVE {LBP_TOP}         CONST LBP_TOP         = 5
NATIVE {LBP_BOTTOM}      CONST LBP_BOTTOM      = 6
NATIVE {LBP_SHIFTLEFT}  CONST LBP_SHIFTLEFT  = 10
NATIVE {LBP_SHIFTRIGHT} CONST LBP_SHIFTRIGHT = 11
NATIVE {LBP_LEFTEDGE}   CONST LBP_LEFTEDGE   = 12
NATIVE {LBP_RIGHTEDGE}  CONST LBP_RIGHTEDGE  = 13
NATIVE {LBP_PAGELEFT}   CONST LBP_PAGELEFT   = 14  /* New for V51 */
NATIVE {LBP_PAGERIGHT}  CONST LBP_PAGERIGHT  = 15  /* New for V51 */

/* Possible values for LISTBROWSER_RelEvent.
 */
NATIVE {LBRE_NORMAL}          CONST LBRE_NORMAL          = 1
NATIVE {LBRE_HIDECHILDREN}    CONST LBRE_HIDECHILDREN    = 2
NATIVE {LBRE_SHOWCHILDREN}    CONST LBRE_SHOWCHILDREN    = 4
NATIVE {LBRE_EDIT}            CONST LBRE_EDIT            = 8
NATIVE {LBRE_DOUBLECLICK}    CONST LBRE_DOUBLECLICK    = 16
NATIVE {LBRE_CHECKED}        CONST LBRE_CHECKED        = 32
NATIVE {LBRE_UNCHECKED}      CONST LBRE_UNCHECKED      = 64
NATIVE {LBRE_TITLECLICK}    CONST LBRE_TITLECLICK    = 128
NATIVE {LBRE_COLUMNADJUST}  CONST LBRE_COLUMNADJUST  = 256
NATIVE {LBRE_EDITTABNEXT}   CONST LBRE_EDITTABNEXT   = 512  /* New for V51 */
NATIVE {LBRE_EDITTABPREV}  CONST LBRE_EDITTABPREV  = 1024  /* New for V51 */

/* Possible values for LISTBROWSER_Striping.
 */
NATIVE {LBS_NONE}     CONST LBS_NONE     = 0
NATIVE {LBS_ROWS}     CONST LBS_ROWS     = 1
NATIVE {LBS_COLUMNS}  CONST LBS_COLUMNS  = 2  /* Not yet implemented */
NATIVE {LBS_BOTH}     CONST LBS_BOTH     = 3  /* Not yet implemented */
