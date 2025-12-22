@database libraries/xref.h
@master libraries/xref.h
@node main "libraries/xref.h"
@toc xref.library_xreffile@main
#ifndef @{"LIBRARIES_XREF_H" link "main" 2}
#define @{b}LIBRARIES_XREF_H@{ub}
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

#ifndef @{"UTILITY_TAGITEM_H" link "AG:SysInc/utility/tagitem.h/main" 2}
#include <@{"utility/tagitem.h" link "AG:SysInc/utility/tagitem.h/main"}>
#endif

struct @{b}XRefFileNode@{ub}
{
   /* node to link all xreffile into a list !
    * Note ln_Name and ln_Pri are valid for now, but please use the
    * appropriate set/get calls to read or manipulate it. But you can
    * use this node to display the name in a gadtools listview.
    */
   struct @{"Node" link "AG:SysInc/exec/nodes.h/main" 22} xrfn_Node;

   /* data beyond this point are strictly private !!! */
};

/* handle for xreffile creation functions !!! */

struct @{b}XRefFileHandle@{ub}
{
   void *xrfh_PRIVATE;
};

/* ------------------------- type of a given @{"XRef" link "AG:SysInc/libraries/amigaguide.h/main" 146} ------------------------- */

/* Note : the following defines are compatible with the amigaguide xref 
 *        defines. For future it is planed to make a tool , that converts
 *        amigaguide xref files to xref.library xref files !
 */

/* cross reference types */

#define @{b}XREFT_GENERIC@{ub}          0     /* a amigaguide node name */
#define @{b}XREFT_FUNCTION@{ub}         1     /* a library function name */
#define @{b}XREFT_COMMAND@{ub}          2     /* a device command name */
#define @{b}XREFT_INCLUDE@{ub}          3     /* a include file name */
#define @{b}XREFT_MACRO@{ub}            4     /* a macro defiiniton name */
#define @{b}XREFT_STRUCT@{ub}           5     /* a structure definition name */
#define @{b}XREFT_FIELD@{ub}            6     /* a structure field name */
#define @{b}XREFT_TYPEDEF@{ub}          7     /* a type definition name */
#define @{b}XREFT_DEFINE@{ub}           8     /* a simple define name */

#define @{b}XREFT_MAXTYPES@{ub}         9     /* max number of types internal use */

#define @{b}XREFT_USER@{ub}             63    /* indicate, that this is a user defined
                                      * xrefentry ! This can only be parsed
                                      * with a @{"XREFA_CustomHook" link "main" 95} !
                                      */

/* ------------------- tags for all xref.library calls -------------------- */

/* the letters in the parenthesis have the following meaning :
 *
 * C - can be used by a call to @{"CreateXRefFileA()" link "xref/CreateXRefFileA()"}
 * L - can be used by a call to @{"XR_LoadXRef()" link "xref/XR_LoadXRef()"}
 * @{"E" link "AG:SysInc/libraries/mathffp.h/main" 20} - can be used by a call to @{"XR_ExpungeXRef()" link "xref/XR_ExpungeXRef()"}
 * G - can be used by a call to @{"GetXRefFileAttrsA()" link "xref/GetXRefFileAttrsA()"}
 * S - can be used by a call to @{"SetXRefFileAttrsA()" link "xref/SetXRefFileAttrsA()"}
 * P - can be used by a call to @{"ParseXRef()" link "xref/ParseXRef()"}
 * M - can be in the PM_XREF message attribute list
 */

#define @{b}XREFA_Base@{ub}      (@{"TAG_USER" link "AG:SysInc/utility/tagitem.h/main" 48} + 0x11000)

#define @{b}XREFA_Lock@{ub}      (@{"XREFA_Base" link "main" 78} + 0x01)
                        /* (LEGS) (ULONG)
                         * one of two possible values
                         * @{"XREF_LOCK" link "main" 234} : locks this xref this isn't free'd
                         *     during a memory flush
                         *
                         * @{"XREF_UNLOCK" link "main" 229} : unlocks a locked xref file
                         */

#define @{b}XREFA_Category@{ub}  (@{"XREFA_Base" link "main" 78} + 0x02)
                        /* (CLEGP) (STRPTR) category for a xref file */

#define @{b}XREFA_Priority@{ub}  (@{"XREFA_Base" link "main" 78} + 0x03)
                        /* (CLGS) (BYTE) priority of a xref memory node */

#define @{b}XREFA_CustomHook@{ub} (@{"XREFA_Base" link "main" 78} + 0x04)
                        /* (LS) (struct @{"Hook" link "AG:SysInc/utility/hooks.h/main" 28} *) callback function to handle
                         * @{"XREFT_USER" link "main" 60} xrefentries !
                         * Not implemented yet !
                         */

#define @{b}XREFA_XRefHook@{ub}  (@{"XREFA_Base" link "main" 78} + 0x05)
                        /* (LEP) (struct @{"Hook" link "AG:SysInc/utility/hooks.h/main" 28} *) hook function, which is called,
                         * for expunging or loading a xreffile. Or if a xrefentry
                         * matches the given pattern in @{"ParseXRef()" link "xref/ParseXRef()"}.
                         * This tag is @{fg highlight}REQUIRED@{fg text} for the @{"ParseXRef()" link "xref/ParseXRef()"} call.
                         */

#define @{b}XREFA_Matching@{ub}  (@{"XREFA_Base" link "main" 78} + 0x06)
                        /* (P) (ULONG) matching mode for @{"ParseXRef()" link "xref/ParseXRef()"} see
                         * XREFMATCH_#? below
                         */

#define @{b}XREFA_Limit@{ub}     (@{"XREFA_Base" link "main" 78} + 0x07)
                        /* (P) (ULONG) maximale number of matching xref 
                         * entries
                         */

#define @{b}XREFA_File@{ub}      (@{"XREFA_Base" link "main" 78} + 0x08)
                        /* (CLEP) (STRPTR) complete filename for the xref file
                         * to load or change attributes (comparison with @{"Lock()" link "dos/Lock()"})
                         */

#define @{b}XREFA_Name@{ub}      (@{"XREFA_Base" link "main" 78} + 0x09)
                        /* (CLEGM) (STRPTR) name of the xref file, use this name
                         * instead of the filename
                         */

#define @{b}XREFA_VersTag@{ub}   (@{"XREFA_Base" link "main" 78} + 0x0A)
                        /* (CG) (ULONG) AmigaDOS version string for the
                         * xreffile
                         */

#define @{b}XREFA_Author@{ub}    (@{"XREFA_Base" link "main" 78} + 0x0B)
                        /* (CG) Author of xref file */

#define @{b}XREFA_Path@{ub}      (@{"XREFA_Base" link "main" 78} + 0x0C)
                        /* (CGM) global path of xref file */

#define @{b}XREFA_Index@{ub}     (@{"XREFA_Base" link "main" 78} + 0x0D)
                        /* (LGS) (BOOL) if @{"TRUE" link "AG:SysInc/exec/types.h/main" 73}, tries to create an index
                         * array to get fast access to all entries. Otherwise
                         * it removes all memory used by the array.
                         * If the array is successfully allocated each
                         * @{"ParseXRef()" link "xref/ParseXRef()"} uses a binary search algorithm !!!
                         */

#define @{b}XREFA_Length@{ub}    (@{"XREFA_Base" link "main" 78} + 0x0E)
                        /* (G) (ULONG) returns the number of bytes allocated
                         * for this xreffile !
                         */

#define @{b}XREFA_RejectTypes@{ub} (@{"XREFA_Base" link "main" 78} + 0x0F)
                        /* (P) (ULONG *) ~0 terminated array of types, which
                         * should not be used. Thus you can exclude some xref-
                         * types (such as @{"XREFT_TYPEDEF" link "main" 55} perhaps).
                         */

#define @{b}XREFA_AcceptTypes@{ub} (@{"XREFA_Base" link "main" 78} + 0x10)
                        /* (P) (ULONG *) ~0 terminated array of types, which
                         * should be used explicitly. If this tag isn't set
                         * all types are used !
                         */

#define @{b}XREFA_CategoryParsed@{ub} (@{"XREFA_Base" link "main" 78} + 0x11)
                        /* (P) (STRPTR) pointer to an tokenized pattern
                         * string after using @{"ParsePattern()" link "dos/ParsePattern()"}. If you call
                         * the @{"ParseXRef()" link "xref/ParseXRef()"} function a lot with the same
                         * pattern you can @{"ParsePattern()" link "dos/ParsePattern()"} before and call
                         * with this tag. This will speed up the parsing !
                         */

#define @{b}XREFA_AutoLoad@{ub}     (@{"XREFA_Base" link "main" 78} + 0x12)
                        /* (P) (BOOL) enables (@{"TRUE" link "AG:SysInc/exec/types.h/main" 73}) , disables (@{"FALSE" link "AG:SysInc/exec/types.h/main" 76}) 
                         * the autoload mechanism
                         */

/* tags for the @{"WriteXRefFileEntry()" link "xref/WriteXRefFileEntryA()"} function and in the PM_XREF
 * attribute list
 */

#define @{b}ENTRYA_Base@{ub}     (@{"TAG_USER" link "AG:SysInc/utility/tagitem.h/main" 48} + 0x12000)

#define @{b}ENTRYA_Type@{ub}     (@{"ENTRYA_Base" link "main" 181} + 0x01)
                        /* (ULONG) type of the entry */

#define @{b}ENTRYA_File@{ub}     (@{"ENTRYA_Base" link "main" 181} + 0x02)
                        /* (STRPTR) file, in which the entry resides */

#define @{b}ENTRYA_Name@{ub}     (@{"ENTRYA_Base" link "main" 181} + 0x03)
                        /* (STRPTR) name of the entry */

#define @{b}ENTRYA_Line@{ub}     (@{"ENTRYA_Base" link "main" 181} + 0x04)
                        /* line of the entry */

#define @{b}ENTRYA_NodeName@{ub} (@{"ENTRYA_Base" link "main" 181} + 0x05)
                        /* name of the amigaguide node in the @{"ENTRYA_File" link "main" 186} */

#define @{b}ENTRYA_CheckMode@{ub} (@{"ENTRYA_Base" link "main" 181} + 0x06)
                        /* one of the ENTRYCHECK_#? modes
                         * default is : @{"ENTRYCHECK_NAME" link "main" 204} 
                         */

#define @{b}ENTRYCHECK_NONE@{ub} 0
#define @{b}ENTRYCHECK_NAME@{ub} 1
#define @{b}ENTRYCHECK_FILE@{ub} 2

/* --------- modes for the XRefParse function (@{"XREFA_Matching" link "main" 108} tag)--------- */

#define @{b}XREFMATCH_PATTERN_CASE@{ub}       0 
                        /* matching done with
                         * @{"ParsePattern()" link "dos/ParsePattern()"}/@{"MatchPattern()" link "dos/MatchPattern()"}
                         */
#define @{b}XREFMATCH_PATTERN_NOCASE@{ub}     1
                        /* matching done with
                         * @{"ParsePatternNoCase()" link "dos/ParsePatternNoCase()"}/@{"MatchPatternNoCase()" link "dos/MatchPatternNoCase()"}
                         */
#define @{b}XREFMATCH_COMPARE_CASE@{ub}       2
                        /* compare with strcmp() */
#define @{b}XREFMATCH_COMPARE_NOCASE@{ub}     3
                        /* compare with @{"Stricmp()" link "utility/Stricmp()"} */
#define @{b}XREFMATCH_COMPARE_NUM_CASE@{ub}   4
                        /* compare with strncmp(string,xrefentry,strlen(string)) */
#define @{b}XREFMATCH_COMPARE_NUM_NOCASE@{ub} 5
                        /* compare with @{"Strnicmp" link "utility/Strnicmp()"}(string,xrefentry,strlen(string)) */


/* ------------------------ values for @{"XREFA_Lock" link "main" 80} ------------------------- */

#define @{b}XREF_UNLOCK@{ub}                  0
                        /* a xref is unlocked, if a memory flush occurs
                         * all xref nodes with @{"XREF_UNLOCK" link "main" 229} set are flushed
                         */

#define @{b}XREF_LOCK@{ub}                    1
                        /* a xref is locked, can't be free'd during memory
                         * flush or a normal XRefExpunge. It must be free'd
                         * with XRefExpunge set the @{"XREFA_Lock" link "main" 80} attribute to
                         * @{"XREF_UNLOCK" link "main" 229} !
                         */

/* -------------------- global xref.library attributes -------------------- */

/* tags for the @{"GetXRefBaseAttrsA()" link "xref/GetXRefBaseAttrsA()"} and @{"SetXRefBaseAttrsA()" link "xref/SetXRefBaseAttrsA()"} call
 * the letters in the parenthesis means :
 * G - available for the @{"GetXRefBaseAttrsA()" link "xref/GetXRefBaseAttrsA()"} call
 * S - availbale for the @{"SetXRefBaseAttrsA()" link "xref/SetXRefBaseAttrsA()"} call
 *
 */

#define @{b}XREFBA_Base@{ub}               (@{"TAG_USER" link "AG:SysInc/utility/tagitem.h/main" 48} + 0x12000)

#define @{b}XREFBA_List@{ub}               (@{"XREFBA_Base" link "main" 250} + 0x01)
                        /* (G) (struct @{"List" link "AG:SysInc/exec/lists.h/main" 20} *)
                         * returns a pointer of the global xreffiles list.
                         * Ths list contains all xreffiles in memory with
                         * (struct @{"XRefFileNode" link "main" 20} *) declared above.
                         * Note you must lock the base if you step through
                         * the list !! The entries in the list are private !!
                         * You can get information about the Nodes with the
                         * @{"GetXRefFileAttrsA()" link "xref/GetXRefFileAttrsA()"} call.
                         * Only the name and pri field of the @{"Node" link "AG:SysInc/exec/nodes.h/main" 22} are valid.
                         */

#define @{b}XREFBA_LineLength@{ub}         (@{"XREFBA_Base" link "main" 250} + 0x02)
                        /* (GS) (UWORD)
                         * number of characters for a line in the dynamic
                         * node.
                         */

#define @{b}XREFBA_Columns@{ub}            (@{"XREFBA_Base" link "main" 250} + 0x03)
                        /* (GS) (UWORD)
                         * number of columns for the dynamic node to use
                         */

#define @{b}XREFBA_DefaultLimit@{ub}       (@{"XREFBA_Base" link "main" 250} + 0x04)
                        /* (GS) (ULONG)
                         * default maximal number of xref entries for the
                         * @{"ParseXRef()" link "xref/ParseXRef()"} function. This value will be over-
                         * written, if the tag @{"XREFA_Limit" link "main" 113} is specified
                         * for the @{"ParseXRef()" link "xref/ParseXRef()"} call.
                         */

#define @{b}XREFBA_XRefDir@{ub}            (@{"XREFBA_Base" link "main" 250} + 0x05)
                        /* (GS) (STRPTR)
                         * the dir to hold all xref files. This dir is used to
                         * create or open a xref file.If a xref file should be
                         * created via the @{"CreateXRefFileA()" link "xref/CreateXRefFileA()"} call,this call
                         * tries to create the file in <@{"XREFBA_XRefDir" link "main" 283}> by
                         * using this directory as the current directory. Thus
                         * you have to specify only the filename!
                         */

/* ------------------------------- ParseMsg ------------------------------- */

#define @{b}XRM_XREF@{ub}           1
#define @{b}XRM_CUSTOMXREF@{ub}     2
#define @{b}XRM_EXPUNGE@{ub}        3
#define @{b}XRM_LOAD@{ub}           4

/* the hook is called in the standard AmigaOS 2.0 way.See utility/hook.h
 * for more detail !
 *
 * For all Messages the object is a pointer to an @{"XRefFileNode" link "main" 20} structure :
 * (struct @{"XRefFileNode" link "main" 20} *) !
 */

/* @{"XRM_XREF" link "main" 295} */
struct @{b}xrmXRef@{ub}
{
   ULONG Msg;                 /* message for the CallBack @{"Hook" link "AG:SysInc/utility/hooks.h/main" 28} , only XRM_#?
                               * are defined at the moment
                               */

   struct @{"TagItem" link "AG:SysInc/utility/tagitem.h/main" 32} *xref_Attrs; /* attributes of the xref entry */
};

/* @{"XRM_CUSTOMXREF" link "main" 296} */
struct @{b}xrmCustomXRef@{ub}
{
   ULONG Msg;
   APTR  XRefEntry;           /* pointer to the custom xrefentry, if you return
                               * from the hook with @{"TRUE" link "AG:SysInc/exec/types.h/main" 73}, you must provide here
                               * the pointer to the next entry !
                               * If you return with @{"FALSE" link "AG:SysInc/exec/types.h/main" 76}, the parsing is
                               * aborted !
                               */
};

/* @{"XRM_EXPUNGE" link "main" 297} */
struct @{b}xrmExpunge@{ub}
{
   ULONG Msg;

   struct @{"TagItem" link "AG:SysInc/utility/tagitem.h/main" 32} *exp_Attrs;
};

/* @{"XRM_LOAD" link "main" 298} */
struct @{b}xrmLoad@{ub}
{
   ULONG Msg;

   struct @{"TagItem" link "AG:SysInc/utility/tagitem.h/main" 32} *l_Attrs;
};

#endif /* @{"LIBRARIES_XREF_H" link "main" 2} */


@endnode
