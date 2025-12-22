#ifndef IFFFUNCSLOCALE_H
#define IFFFUNCSLOCALE_H


/****************************************************************************/


/* This file was created automatically by CatComp.
 * Do NOT edit by hand!
 */


#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifdef CATCOMP_ARRAY
#undef CATCOMP_NUMBERS
#undef CATCOMP_STRINGS
#define CATCOMP_NUMBERS
#define CATCOMP_STRINGS
#endif

#ifdef CATCOMP_BLOCK
#undef CATCOMP_STRINGS
#define CATCOMP_STRINGS
#endif


/****************************************************************************/


#ifdef CATCOMP_NUMBERS

#define MSG_IFF_SYSTEMPROBLEM 0
#define MSG_USERPGM_ERROR 1
#define MSG_IFF_NULLPTR 2
#define MSG_IFF_NOMEM 3
#define MSG_FORMAT_LIB_OPEN 4
#define MSG_FORMAT_FILE_OPEN 5
#define MSG_IFF_ERR_RET2CLIENT 6
#define MSG_IFF_ERR_NOHOOK 7
#define MSG_IFF_ERR_NOTIFF 8
#define MSG_IFF_ERR_SYNTAX 9
#define MSG_IFF_ERR_MANGLED 10
#define MSG_IFF_ERR_SEEK 11
#define MSG_IFF_ERR_WRITE 12
#define MSG_IFF_ERR_READ 13
#define MSG_IFF_ERR_NOMEM 14
#define MSG_IFF_ERR_NOSCOPE 15
#define MSG_IFF_ERR_EOC 16
#define MSG_IFF_ERR_EOF 17
#define MSG_IFF_ERR_NONE 18
#define MSG_IFF_ERR_UNKNOWN 19
#define MSG_IFF_TRUNCATED 20
#define MSG_IFF_BAD_CLIPNUM 21
#define MSG_IFF_BAD_ID 22
#define MSG_IFF_BAD_ERRNUM 23
#define MSG_FORMAT_IFFERR 24
#define MSG_FORMAT_BARY_SMALL 25
#define MSG_FORMAT_INVALIDTYPE 26
#define MSG_FORMAT_INVALID_ID 27
#define MSG_IFF_PARSE_LIB 28
#define MSG_IFF_OPEN_IFF_FUNC 29
#define MSG_IFF_IFFHANDLE_FUNC 30
#define MSG_IFF_INITIFF_FUNC 31
#define MSG_IFF_INITDOS_FUNC 32
#define MSG_IFF_INITCLIP_FUNC 33
#define MSG_IFF_CLOSECLIP_FUNC 34
#define MSG_IFF_OPENCLIP_FUNC 35
#define MSG_IFF_PARSE_FUNC 36
#define MSG_IFF_READCHK_FUNC 37
#define MSG_IFF_READCHKR_FUNC 38
#define MSG_IFF_WRTCHK_FUNC 39
#define MSG_IFF_WRTCHKR_FUNC 40
#define MSG_IFF_STOPCHK_FUNC 41
#define MSG_IFF_CRNTCHK_FUNC 42
#define MSG_IFF_PROPCHK_FUNC 43
#define MSG_IFF_FINDPROP_FUNC 44
#define MSG_IFF_COLLCHK_FUNC 45
#define MSG_IFF_FINDCOLL_FUNC 46
#define MSG_IFF_STOPEXIT_FUNC 47
#define MSG_IFF_ENTRHAND_FUNC 48
#define MSG_IFF_EXITHAND_FUNC 49
#define MSG_IFF_STOPCHKS_FUNC 50
#define MSG_IFF_PROPCHKS_FUNC 51
#define MSG_IFF_COLLCHKS_FUNC 52
#define MSG_IFF_PUSHCHK_FUNC 53
#define MSG_IFF_POPCHK_FUNC 54
#define MSG_IFF_PARCHK_FUNC 55
#define MSG_IFF_ALLC_FUNC 56
#define MSG_IFF_LCLDATA_FUNC 57
#define MSG_IFF_STOLI_FUNC 58
#define MSG_IFF_STOIC_FUNC 59
#define MSG_IFF_FINDPROPC_FUNC 60
#define MSG_IFF_FINDLCLI_FUNC 61
#define MSG_IFF_FREELI_FUNC 62
#define MSG_IFF_SETPURG_FUNC 63

#endif /* CATCOMP_NUMBERS */


/****************************************************************************/


#ifdef CATCOMP_STRINGS

#define MSG_IFF_SYSTEMPROBLEM_STR "System Problem:"
#define MSG_USERPGM_ERROR_STR "User Program ERROR:"
#define MSG_IFF_NULLPTR_STR "Pointer was NULL:"
#define MSG_IFF_NOMEM_STR "Ran out of System Memory:"
#define MSG_FORMAT_LIB_OPEN_STR "iffparse.library Did NOT open (ERROR = %d)!"
#define MSG_FORMAT_FILE_OPEN_STR "IFF file Did NOT open (ERROR = %d)!"
#define MSG_IFF_ERR_RET2CLIENT_STR "Client handler normal return"
#define MSG_IFF_ERR_NOHOOK_STR "No call-back hook provided"
#define MSG_IFF_ERR_NOTIFF_STR "Not an IFF file"
#define MSG_IFF_ERR_SYNTAX_STR "IFF syntax error"
#define MSG_IFF_ERR_MANGLED_STR "Data in file is corrupt"
#define MSG_IFF_ERR_SEEK_STR "Stream seek error"
#define MSG_IFF_ERR_WRITE_STR "Stream write error"
#define MSG_IFF_ERR_READ_STR "Stream read error"
#define MSG_IFF_ERR_NOMEM_STR "Internal memory allocation failed"
#define MSG_IFF_ERR_NOSCOPE_STR "No valid scope for property"
#define MSG_IFF_ERR_EOC_STR "About to leave context"
#define MSG_IFF_ERR_EOF_STR "Reached logical end of file"
#define MSG_IFF_ERR_NONE_STR "NO IFF ERROR!"
#define MSG_IFF_ERR_UNKNOWN_STR "Unknown IFF Error Number!"
#define MSG_IFF_TRUNCATED_STR "IFF Chunk truncated (not enough room!)"
#define MSG_IFF_BAD_CLIPNUM_STR "Clipboard unit # out of range (using default of 0)"
#define MSG_IFF_BAD_ID_STR "BAD_ID"
#define MSG_IFF_BAD_ERRNUM_STR "IFF errorNumber passed was 0!"
#define MSG_FORMAT_IFFERR_STR "IFF ERROR: %s"
#define MSG_FORMAT_BARY_SMALL_STR "Given Buffer too small (%d < %d)!"
#define MSG_FORMAT_INVALIDTYPE_STR "Supplied IFF Type (0x%08lX) invalid!"
#define MSG_FORMAT_INVALID_ID_STR "Supplied IFF ID (0x%08lX) invalid!"
#define MSG_IFF_PARSE_LIB_STR "iffparse.library V37+"
#define MSG_IFF_OPEN_IFF_FUNC_STR "new IFF Object"
#define MSG_IFF_IFFHANDLE_FUNC_STR "iffHandle"
#define MSG_IFF_INITIFF_FUNC_STR "Init_IFF()"
#define MSG_IFF_INITDOS_FUNC_STR "Init_IFFAsDOS()"
#define MSG_IFF_INITCLIP_FUNC_STR "Init_IFFAsClip()"
#define MSG_IFF_CLOSECLIP_FUNC_STR "Close_Clipboard()"
#define MSG_IFF_OPENCLIP_FUNC_STR "Open_Clipboard()"
#define MSG_IFF_PARSE_FUNC_STR "Parse_IFF()"
#define MSG_IFF_READCHK_FUNC_STR "Read_Chunk_Bytes()"
#define MSG_IFF_READCHKR_FUNC_STR "Read_Chunk_Records()"
#define MSG_IFF_WRTCHK_FUNC_STR "Write_Chunk_Bytes()"
#define MSG_IFF_WRTCHKR_FUNC_STR "Write_Chunk_Records()"
#define MSG_IFF_STOPCHK_FUNC_STR "Stop_Chunk()"
#define MSG_IFF_CRNTCHK_FUNC_STR "Current_Chunk()"
#define MSG_IFF_PROPCHK_FUNC_STR "Prop_Chunk()"
#define MSG_IFF_FINDPROP_FUNC_STR "Find_Prop()"
#define MSG_IFF_COLLCHK_FUNC_STR "Collection_Chunk()"
#define MSG_IFF_FINDCOLL_FUNC_STR "Find_Collection()"
#define MSG_IFF_STOPEXIT_FUNC_STR "Stop_OnExit()"
#define MSG_IFF_ENTRHAND_FUNC_STR "Entry_Handler()"
#define MSG_IFF_EXITHAND_FUNC_STR "Exit_Handler()"
#define MSG_IFF_STOPCHKS_FUNC_STR "Stop_Chunks()"
#define MSG_IFF_PROPCHKS_FUNC_STR "Prop_Chunks()"
#define MSG_IFF_COLLCHKS_FUNC_STR "Collection_Chunks()"
#define MSG_IFF_PUSHCHK_FUNC_STR "Push_Chunk()"
#define MSG_IFF_POPCHK_FUNC_STR "Pop_Chunk()"
#define MSG_IFF_PARCHK_FUNC_STR "Parent_Chunk()"
#define MSG_IFF_ALLC_FUNC_STR "Alloc_LocalItem()"
#define MSG_IFF_LCLDATA_FUNC_STR "Local_ItemData()"
#define MSG_IFF_STOLI_FUNC_STR "Store_LocalItem()"
#define MSG_IFF_STOIC_FUNC_STR "Store_ItemInContext()"
#define MSG_IFF_FINDPROPC_FUNC_STR "Find_PropContext()"
#define MSG_IFF_FINDLCLI_FUNC_STR "Find_LocalItem()"
#define MSG_IFF_FREELI_FUNC_STR "Free_LocalItem()"
#define MSG_IFF_SETPURG_FUNC_STR "Set_LocalItem_Purge()"

#endif /* CATCOMP_STRINGS */


/****************************************************************************/


struct LocaleInfo
{
    APTR li_LocaleBase;
    APTR li_Catalog;
};



#endif /* IFFFUNCSLOCALE_H */
