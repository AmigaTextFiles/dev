#ifndef LIBRARIES_XREF_H
#define LIBRARIES_XREF_H
/* xref.library
**
** $VER: xref.h 1.10 (22.09.94) 
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
*/

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

struct XRefFileNode
{
   /* node to link all xreffile into a list !
    * Note ln_Name and ln_Pri are valid for now, but please use the
    * appropriate set/get calls to read or manipulate it. But you can
    * use this node to display the name in a gadtools listview.
    */
   struct Node xrfn_Node;

   /* data beyond this point are strictly private !!! */
};

/* handle for xreffile creation functions !!! */

struct XRefFileHandle
{
   void *xrfh_PRIVATE;
};

/* ------------------------- type of a given XRef ------------------------- */

/* Note : the following defines are compatible with the amigaguide xref 
 *        defines. For future it is planed to make a tool , that converts
 *        amigaguide xref files to xref.library xref files !
 */

/* cross reference types */

#define XREFT_GENERIC          0     /* a amigaguide node name */
#define XREFT_FUNCTION         1     /* a library function name */
#define XREFT_COMMAND          2     /* a device command name */
#define XREFT_INCLUDE          3     /* a include file name */
#define XREFT_MACRO            4     /* a macro defiiniton name */
#define XREFT_STRUCT           5     /* a structure definition name */
#define XREFT_FIELD            6     /* a structure field name */
#define XREFT_TYPEDEF          7     /* a type definition name */
#define XREFT_DEFINE           8     /* a simple define name */

#define XREFT_MAXTYPES         9     /* max number of types internal use */

#define XREFT_USER             63    /* indicate, that this is a user defined
                                      * xrefentry ! This can only be parsed
                                      * with a XREFA_CustomHook !
                                      */

/* ------------------- tags for all xref.library calls -------------------- */

/* the letters in the parenthesis have the following meaning :
 *
 * C - can be used by a call to CreateXRefFileA()
 * L - can be used by a call to XR_LoadXRef()
 * E - can be used by a call to XR_ExpungeXRef()
 * G - can be used by a call to GetXRefFileAttrsA()
 * S - can be used by a call to SetXRefFileAttrsA()
 * P - can be used by a call to ParseXRef()
 * M - can be in the PM_XREF message attribute list
 */

#define XREFA_Base      (TAG_USER + 0x11000)

#define XREFA_Lock      (XREFA_Base + 0x01)
                        /* (LEGS) (ULONG)
                         * one of two possible values
                         * XREF_LOCK : locks this xref this isn't free'd
                         *     during a memory flush
                         *
                         * XREF_UNLOCK : unlocks a locked xref file
                         */

#define XREFA_Category  (XREFA_Base + 0x02)
                        /* (CLEGP) (STRPTR) category for a xref file */

#define XREFA_Priority  (XREFA_Base + 0x03)
                        /* (CLGS) (BYTE) priority of a xref memory node */

#define XREFA_CustomHook (XREFA_Base + 0x04)
                        /* (LS) (struct Hook *) callback function to handle
                         * XREFT_USER xrefentries !
                         * Not implemented yet !
                         */

#define XREFA_XRefHook  (XREFA_Base + 0x05)
                        /* (LEP) (struct Hook *) hook function, which is called,
                         * for expunging or loading a xreffile. Or if a xrefentry
                         * matches the given pattern in ParseXRef().
                         * This tag is REQUIRED for the ParseXRef() call.
                         */

#define XREFA_Matching  (XREFA_Base + 0x06)
                        /* (P) (ULONG) matching mode for ParseXRef() see
                         * XREFMATCH_#? below
                         */

#define XREFA_Limit     (XREFA_Base + 0x07)
                        /* (P) (ULONG) maximale number of matching xref 
                         * entries
                         */

#define XREFA_File      (XREFA_Base + 0x08)
                        /* (CLEP) (STRPTR) complete filename for the xref file
                         * to load or change attributes (comparison with Lock())
                         */

#define XREFA_Name      (XREFA_Base + 0x09)
                        /* (CLEGM) (STRPTR) name of the xref file, use this name
                         * instead of the filename
                         */

#define XREFA_VersTag   (XREFA_Base + 0x0A)
                        /* (CG) (ULONG) AmigaDOS version string for the
                         * xreffile
                         */

#define XREFA_Author    (XREFA_Base + 0x0B)
                        /* (CG) Author of xref file */

#define XREFA_Path      (XREFA_Base + 0x0C)
                        /* (CGM) global path of xref file */

#define XREFA_Index     (XREFA_Base + 0x0D)
                        /* (LGS) (BOOL) if TRUE, tries to create an index
                         * array to get fast access to all entries. Otherwise
                         * it removes all memory used by the array.
                         * If the array is successfully allocated each
                         * ParseXRef() uses a binary search algorithm !!!
                         */

#define XREFA_Length    (XREFA_Base + 0x0E)
                        /* (G) (ULONG) returns the number of bytes allocated
                         * for this xreffile !
                         */

#define XREFA_RejectTypes (XREFA_Base + 0x0F)
                        /* (P) (ULONG *) ~0 terminated array of types, which
                         * should not be used. Thus you can exclude some xref-
                         * types (such as XREFT_TYPEDEF perhaps).
                         */

#define XREFA_AcceptTypes (XREFA_Base + 0x10)
                        /* (P) (ULONG *) ~0 terminated array of types, which
                         * should be used explicitly. If this tag isn't set
                         * all types are used !
                         */

#define XREFA_CategoryParsed (XREFA_Base + 0x11)
                        /* (P) (STRPTR) pointer to an tokenized pattern
                         * string after using ParsePattern(). If you call
                         * the ParseXRef() function a lot with the same
                         * pattern you can ParsePattern() before and call
                         * with this tag. This will speed up the parsing !
                         */

#define XREFA_AutoLoad     (XREFA_Base + 0x12)
                        /* (P) (BOOL) enables (TRUE) , disables (FALSE) 
                         * the autoload mechanism
                         */

/* tags for the WriteXRefFileEntry() function and in the PM_XREF
 * attribute list
 */

#define ENTRYA_Base     (TAG_USER + 0x12000)

#define ENTRYA_Type     (ENTRYA_Base + 0x01)
                        /* (ULONG) type of the entry */

#define ENTRYA_File     (ENTRYA_Base + 0x02)
                        /* (STRPTR) file, in which the entry resides */

#define ENTRYA_Name     (ENTRYA_Base + 0x03)
                        /* (STRPTR) name of the entry */

#define ENTRYA_Line     (ENTRYA_Base + 0x04)
                        /* line of the entry */

#define ENTRYA_NodeName (ENTRYA_Base + 0x05)
                        /* name of the amigaguide node in the ENTRYA_File */

#define ENTRYA_CheckMode (ENTRYA_Base + 0x06)
                        /* one of the ENTRYCHECK_#? modes
                         * default is : ENTRYCHECK_NAME 
                         */

#define ENTRYCHECK_NONE 0
#define ENTRYCHECK_NAME 1
#define ENTRYCHECK_FILE 2

/* --------- modes for the XRefParse function (XREFA_Matching tag)--------- */

#define XREFMATCH_PATTERN_CASE       0 
                        /* matching done with
                         * ParsePattern()/MatchPattern()
                         */
#define XREFMATCH_PATTERN_NOCASE     1
                        /* matching done with
                         * ParsePatternNoCase()/MatchPatternNoCase()
                         */
#define XREFMATCH_COMPARE_CASE       2
                        /* compare with strcmp() */
#define XREFMATCH_COMPARE_NOCASE     3
                        /* compare with Stricmp() */
#define XREFMATCH_COMPARE_NUM_CASE   4
                        /* compare with strncmp(string,xrefentry,strlen(string)) */
#define XREFMATCH_COMPARE_NUM_NOCASE 5
                        /* compare with Strnicmp(string,xrefentry,strlen(string)) */


/* ------------------------ values for XREFA_Lock ------------------------- */

#define XREF_UNLOCK                  0
                        /* a xref is unlocked, if a memory flush occurs
                         * all xref nodes with XREF_UNLOCK set are flushed
                         */

#define XREF_LOCK                    1
                        /* a xref is locked, can't be free'd during memory
                         * flush or a normal XRefExpunge. It must be free'd
                         * with XRefExpunge set the XREFA_Lock attribute to
                         * XREF_UNLOCK !
                         */

/* -------------------- global xref.library attributes -------------------- */

/* tags for the GetXRefBaseAttrsA() and SetXRefBaseAttrsA() call
 * the letters in the parenthesis means :
 * G - available for the GetXRefBaseAttrsA() call
 * S - availbale for the SetXRefBaseAttrsA() call
 *
 */

#define XREFBA_Base               (TAG_USER + 0x12000)

#define XREFBA_List               (XREFBA_Base + 0x01)
                        /* (G) (struct List *)
                         * returns a pointer of the global xreffiles list.
                         * Ths list contains all xreffiles in memory with
                         * (struct XRefFileNode *) declared above.
                         * Note you must lock the base if you step through
                         * the list !! The entries in the list are private !!
                         * You can get information about the Nodes with the
                         * GetXRefFileAttrsA() call.
                         * Only the name and pri field of the Node are valid.
                         */

#define XREFBA_LineLength         (XREFBA_Base + 0x02)
                        /* (GS) (UWORD)
                         * number of characters for a line in the dynamic
                         * node.
                         */

#define XREFBA_Columns            (XREFBA_Base + 0x03)
                        /* (GS) (UWORD)
                         * number of columns for the dynamic node to use
                         */

#define XREFBA_DefaultLimit       (XREFBA_Base + 0x04)
                        /* (GS) (ULONG)
                         * default maximal number of xref entries for the
                         * ParseXRef() function. This value will be over-
                         * written, if the tag XREFA_Limit is specified
                         * for the ParseXRef() call.
                         */

#define XREFBA_XRefDir            (XREFBA_Base + 0x05)
                        /* (GS) (STRPTR)
                         * the dir to hold all xref files. This dir is used to
                         * create or open a xref file.If a xref file should be
                         * created via the CreateXRefFileA() call,this call
                         * tries to create the file in <XREFBA_XRefDir> by
                         * using this directory as the current directory. Thus
                         * you have to specify only the filename!
                         */

/* ------------------------------- ParseMsg ------------------------------- */

#define XRM_XREF           1
#define XRM_CUSTOMXREF     2
#define XRM_EXPUNGE        3
#define XRM_LOAD           4

/* the hook is called in the standard AmigaOS 2.0 way.See utility/hook.h
 * for more detail !
 *
 * For all Messages the object is a pointer to an XRefFileNode structure :
 * (struct XRefFileNode *) !
 */

/* XRM_XREF */
struct xrmXRef
{
   ULONG Msg;                 /* message for the CallBack Hook , only XRM_#?
                               * are defined at the moment
                               */

   struct TagItem *xref_Attrs; /* attributes of the xref entry */
};

/* XRM_CUSTOMXREF */
struct xrmCustomXRef
{
   ULONG Msg;
   APTR  XRefEntry;           /* pointer to the custom xrefentry, if you return
                               * from the hook with TRUE, you must provide here
                               * the pointer to the next entry !
                               * If you return with FALSE, the parsing is
                               * aborted !
                               */
};

/* XRM_EXPUNGE */
struct xrmExpunge
{
   ULONG Msg;

   struct TagItem *exp_Attrs;
};

/* XRM_LOAD */
struct xrmLoad
{
   ULONG Msg;

   struct TagItem *l_Attrs;
};

#endif /* LIBRARIES_XREF_H */

