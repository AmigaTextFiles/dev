#ifndef FEELIN_PDRDOCUMENT_H
#define FEELIN_PDRDOCUMENT_H

#include <feelin/document.h>

/*
**  feelin/pdrdocument.h
**
**  © 2001-2005 Olivier LAVIALE (gofromiel@gofromiel.com)
**
*************************************************************************************************

$VER: 01.00 (2006/03/14)

*/

#define FC_PDRDocument                          "PDRDocument"
#define PDRDocumentObject                       IFEELIN F_NewObj(FC_PDRDocument

/************************************************************************************************
*** Types ***************************************************************************************
************************************************************************************************/

typedef struct FeelinPDRAttribute
{
    struct FeelinPDRAttribute      *Next;
    FAtom                          *Atom;
    STRPTR                          Value;
    uint32                          NumericValue;
    uint32                          NumericType;
}
FPDRAttribute;

typedef struct FeelinPDRHandle
{
    APTR                            Pool;
    FPDRAttribute                  *Attributes;
}
FPDRHandle;

/************************************************************************************************
*** Messages ************************************************************************************
************************************************************************************************/

struct  FS_PDRDocument_FindHandle               { STRPTR ID; STRPTR Persist; };
struct  FS_PDRDocument_CreateHandle             { STRPTR ID; STRPTR Persist; };

/************************************************************************************************
*** Macros **************************************************************************************
************************************************************************************************/

#define F_PDRDOCUMENT_ROOT                      "feelin:persist"
#define F_PDRDOCUMENT_SPACE                     "space"
#define F_PDRDOCUMENT_ITEM                      "item"
#define F_PDRDOCUMENT_ID                        "id"
#define F_PDRDOCUMENT_EXT                       "prd"

#define F_PDRDOCUMENT_SET(attr, value)              attr->Value = value;
#define F_PDRDOCUMENT_SET_TYPED(attr, value, type)  attr->NumericValue = value; attr->NumericType = type
#define F_PDRDOCUMENT_GET(attr)                     attr->Value
#define F_PDRDOCUMENT_GET_NUMERIC(attr)             attr->NumericValue

#endif
