#ifndef FEELIN_XMLDOCUMENT_H
#define FEELIN_XMLDOCUMENT_H

#include <feelin/document.h>

/*
**  feelin/xmldocument.h
**
**  © 2001-2005 Olivier LAVIALE (gofromiel@gofromiel.com)
**
*************************************************************************************************

$VER: 03.00 (2006/04/25)

	Atoms support.

$VER: 02.00 (2005/05/01)

*/

#define FC_XMLDocument                          "XMLDocument"
#define XMLDocumentObject                       IFEELIN F_NewObj(FC_XMLDocument

/************************************************************************************************
*** Types ***************************************************************************************
************************************************************************************************/

typedef struct FeelinXMLPI
{
	struct FeelinXMLPI			   *Next;
	struct FeelinXMLPI			   *Prev;

	FAtom 						   *Atom;
	uint32                          Line;

	FList                           AttributesList;
}
FXMLPI;

typedef struct FeelinXMLEntity
{
	STRPTR                          Name;
	bits32                          Type;
	STRPTR                          Definition;
}
FXMLEntity;

typedef struct FeelinXMLAttribute
{
	struct FeelinXMLAttribute      *Next;
	struct FeelinXMLAttribute      *Prev;

	FAtom                          *Atom;

	STRPTR                          Value;
	uint32                          NumericValue;
	bits32                          NumericType;
	
	uint32                          Line;
}
FXMLAttribute;

typedef struct FeelinXMLMarkup
{
	struct FeelinXMLMarkup         *Next;
	struct FeelinXMLMarkup         *Prev;

	FAtom                          *Atom;
	STRPTR                          Body;

	uint32                          Line;

	FList                           AttributesList;
	FList                           ChildrenList;

	struct FeelinXMLMarkup         *Parent;
}
FXMLMarkup;

/************************************************************************************************
*** Messages ************************************************************************************
************************************************************************************************/

struct  FS_XMLDocument_Push                     { STRPTR Name; STRPTR Body; };
struct  FS_XMLDocument_Add                      { STRPTR Name; STRPTR Value; };
struct  FS_XMLDocument_AddInt                   { STRPTR Name; uint32 Value; bits32 Type; };
struct  FS_XMLDocument_Write                    { APTR Source; uint32 SourceType; };
struct  FS_XMLDocument_AddEntity                { STRPTR Name; STRPTR Definition; };
struct  FS_XMLDocument_AddEntities              { FXMLEntity *Entities; };
struct  FS_XMLDocument_FindEntity               { STRPTR Name; };

/************************************************************************************************
*** Macros **************************************************************************************
************************************************************************************************/

#define F_XMLDOCUMENT_VERSION                   "version"

#define F_ENTITIES_ARRAY                        F_ARRAY_NEW(FXMLEntity,entities_array)
#define F_ENTITIES_ADD(name,data)               { name, FV_TYPE_STRING, (APTR) data }
#define F_ENTITIES_ADD_TYPED(name,type,data)    { name, type, (APTR) data }
#define F_ENTITIES_ADD_EMPTY(name)              { name, FV_TYPE_STRING, NULL }
#define F_ENTITIES_ADD_EMPTY_TYPED(name,type)   { name, type, NULL }
#define F_ENTITIES_SET(id,data)                 F_ARRAY_PTR(entities_array)[id].Definition = (APTR) data
#define F_ENTITIES_PTR                          F_ARRAY_PTR(entities_array)

#endif
