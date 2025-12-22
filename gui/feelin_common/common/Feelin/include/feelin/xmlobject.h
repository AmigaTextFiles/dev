#ifndef FEELIN_XMLOBJECT_H
#define FEELIN_XMLOBJECT_H

#include <feelin/xmldocument.h>

/*
**  feelin/xmlobject.h
**
**  © 2001-2005 Olivier LAVIALE (gofromiel@gofromiel.com)
**
*************************************************************************************************

$VER: 03.00 (2006/02/26)

	Added FV_XMLOBJECT_ID_STYLE F_XMLOBJECT_ID_ID F_XMLOBJECT_ID_ID_LEN
	F_XMLOBJECT_ID_OBJECTS F_XMLOBJECT_ID_OBJECTS_LEN F_XMLOBJECT_ID_STYLE
	F_XMLOBJECT_ID_STYLE_LEN macros.

$VER: 02.00 (2005/12/01)

	Added macros F_MSG_XMLOBJECT_FIND, F_MSG_XMLOBJECT_CREATE and F_XMLSOURCES_PATH

	'name' markup has been renamed to 'id',  thus  FV_XMLOBJECT_ID_NAME  has
	been renamed as FV_XMLOBJECT_ID_ID.

************************************************************************************************/

#define FC_XMLObject                            "XMLObject"
#define XMLObjectObject                         IFEELIN F_NewObj(FC_XMLObject

/*** types *************************************************************************************/

typedef struct FeelinXMLReference
{
	STRPTR                          Name;
	FObject                        *ObjectPtr;
}
FXMLReference;

/*** messages **********************************************************************************/

struct  FS_XMLObject_Find                       { STRPTR Name; };
struct  FS_XMLObject_Create                     { FXMLMarkup *Markup; APTR Pool; };

#define F_MSG_XMLOBJECT_FIND(name)              name
#define F_MSG_XMLOBJECT_CREATE(markup,pool)     markup,pool

/*** macros ************************************************************************************/

#define F_XMLOBJECT_ID                          "id"
#define F_XMLOBJECT_OBJECTS                     "feelin:objects"
#define F_XMLOBJECT_STYLE                       "style"
#define F_XMLOBJECT_CLASS                       "class"

#define F_XML_REFS                              feelin_auto_xml_refs
#define F_XML_REFS_INIT(num)                    FXMLReference feelin_auto_xml_refs[num + 1]; uint32 feelin_auto_xml_refs_count=0
#define F_XML_REFS_ADD(name,ptr)                feelin_auto_xml_refs[feelin_auto_xml_refs_count].Name = name; feelin_auto_xml_refs[feelin_auto_xml_refs_count++].ObjectPtr = ptr
#define F_XML_REFS_DONE                         feelin_auto_xml_refs[feelin_auto_xml_refs_count].Name = NULL

#define F_XMLREFERENCES_ARRAY                   F_ARRAY_NEW(FXMLReference, xmlreferences)
#define F_XMLREFERENCES_ADD(name)               { name, NULL }
#define F_XMLREFERENCES_SET(id, ptr)            F_ARRAY_PTR(xmlreferences)[id].ObjectPtr = ptr
#define F_XMLREFERENCES_PTR                     F_ARRAY_PTR(xmlreferences)

#define F_XMLSOURCES_PATH                       "feelin:resources/xml"

#endif
