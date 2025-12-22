#ifndef FEELIN_DOCUMENT_H
#define FEELIN_DOCUMENT_H

#ifndef FEELIN_CONF_H
#include <libraries/feelin_conf.h>
#endif

/*
**  feelin/document.h
**
**  © 2001-2005 Olivier LAVIALE (gofromiel@gofromiel.com)
**
*************************************************************************************************

$VER: 02.00 (2005/12/01)

	[NEW] FS_Document_Write, FS_Document_Merge, FS_Document_AddEntities,
	FS_Document_RemEntities, FM_Document_FindEntity, FDOCEntity.

************************************************************************************************/

#define FC_Document                          "Document"
#define DocumentObject                       IFEELIN F_NewObj(FC_Document

/************************************************************************************************
*** Values **************************************************************************************
************************************************************************************************/

enum    {

		FV_Document_SourceType_Unknown,
		FV_Document_SourceType_File,
		FV_Document_SourceType_Memory

		};

/************************************************************************************************
*** Types ***************************************************************************************
************************************************************************************************/

typedef struct FeelinDocumentValue
{
	STRPTR                          Name;
	uint32                          Value;
}
FDOCValue;

/************************************************************************************************
*** Messages ************************************************************************************
************************************************************************************************/

struct  FS_Document_Read                        { STRPTR Source; uint32 Type; APTR Pool; };
struct  FS_Document_Merge                       { STRPTR Source; uint32 Type; };
struct  FS_Document_Write                       { STRPTR File; };
struct  FS_Document_Parse                       { STRPTR Source; APTR Pool; };
struct  FS_Document_Resolve                     { STRPTR Data; uint32 Type; FDOCValue *Values; int32 *Done; };
#if F_CODE_DEPRECATED
struct  FS_Document_FindName                    { STRPTR Key; uint32 KeyLength; };
struct  FS_Document_ObtainName                  { STRPTR Key; uint32 KeyLength; };
#endif
struct  FS_Document_Log                         { uint32 Line; STRPTR Source; STRPTR Fmt; };
struct  FS_Document_Numerify                    { STRPTR Data; bits32 *TypePtr; };
struct  FS_Document_Stringify                   { uint32 Data; bits32 Type; };

#define F_MSG_DOCUMENT_READ(source,type,pool)               source,type,pool
#define F_MSG_DOCUMENT_MERGE(source,type)                   source,type
#define F_MSG_DOCUMENT_WRITE(file)                          file
#define F_MSG_DOCUMENT_PARSE(source,pool)                   source,pool
#define F_MSG_DOCUMENT_ADDIDS(table)                        table
#define F_MSG_DOCUMENT_RESOLVE(data,type,values,done)       data,type,values,done
#if F_CODE_DEPRECATED
#define F_MSG_DOCUMENT_FINDNAME(key,keylength)              key,keylength
#define F_MSG_DOCUMENT_OBTAINNAME(key,keylength)            key,keylength
#endif
#define F_MSG_DOCUMENT_LOG(line,source,fmt)                 line,source,fmt

#endif
