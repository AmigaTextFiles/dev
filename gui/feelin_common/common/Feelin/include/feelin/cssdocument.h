#ifndef FEELIN_CSSDOCUMENT_H
#define FEELIN_CSSDOCUMENT_H

/*
**  feelin/cssdocument.h
**
**  © 2001-2005 Olivier LAVIALE (gofromiel@gofromiel.com)
**
*************************************************************************************************

$VER: 02.00 (2006/03/06)

	Use atoms.

$VER: 01.00 (2005/12/22)

************************************************************************************************/

#define FC_CSSDocument                      "CSSDocument"
#define CSSDocumentObject                   IFEELIN F_NewObj(FC_CSSDocument

/************************************************************************************************
*** Types ***************************************************************************************
************************************************************************************************/

typedef struct FeelinCSSProperty
{
	FNode					        Node;

	FAtom                          *Atom;

	STRPTR                          Value;
	uint32                          NumericValue;
	bits32                          NumericType;
}
FCSSProperty;

typedef struct FeelinCSSDeclaration
{
	struct FeelinCSSDeclaration    *Next;

	FAtom                          *Atom;

	FList 							PropertiesList;
	struct FeelinCSSDeclaration    *Pseudos;
}
FCSSDeclaration;

/************************************************************************************************
*** Messages ************************************************************************************
************************************************************************************************/

struct  FS_CSSDocument_AddProperty              { STRPTR DeclarationName; STRPTR PropertyName; APTR Data; bits32 DataType; };
struct  FS_CSSDocument_GetProperty              { STRPTR DeclarationName; STRPTR PropertyName; };

#endif
