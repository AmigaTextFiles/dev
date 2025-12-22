#ifndef FEELIN_HTMLDOCUMENT_H
#define FEELIN_HTMLDOCUMENT_H

#include <feelin/document.h>

#if (defined(__MORPHOS__) || defined(__amigaos4__)) && defined(__GNUC__) && defined(__PPC__)
# pragma pack(2)
#endif

/*
**
**  $VER: feelin/HTMLdocument.h 1.0 (2005/05/02)
**
**  © 2001-2005 Olivier LAVIALE (gofromiel@gofromiel.com)
************************************************************************************************/


#define FC_HTMLDocument                          "HTMLDocument"
#define HTMLDocumentObject                       IFEELIN F_NewObj(FC_HTMLDocument

/************************************************************************************************
*** Types ***************************************************************************************
************************************************************************************************/

enum    {

        FV_HTMLDocument_Node_Text,
        FV_HTMLDocument_Node_Markup

        };

typedef struct FeelinHTMLNode
{
    struct FeelinHTMLNode          *Next;
    struct FeelinHTMLNode          *Prev;

    uint8                           Type;
}
FHTMLNode;
       
/***************************************************************************/

typedef struct FeelinHTMLText
{
    FHTMLNode                       Node;

    STRPTR                          Data;
    uint32                          DataLength;
}
FHTMLText;

typedef struct FeelinHTMLMarkup
{
    FHTMLNode                       Node;

    uint8                           Terminator;
    uint16                          Line;

    FAtom                          *Atom;

    FList                           AttributesList;
    FList                           ChildrenList;
}
FHTMLMarkup;

typedef struct FeelinHTMLAttribute
{
    struct FeelinHTMLAttribute     *Next;
    struct FeelinHTMLAttribute     *Prev;

    uint32                          Line;

    FAtom                          *Atom;
    STRPTR                          Data;
}
FHTMLAttribute;

#if (defined(__MORPHOS__) || defined(__amigaos4__)) && defined(__GNUC__) && defined(__PPC__)
# pragma pack()
#endif

#endif
