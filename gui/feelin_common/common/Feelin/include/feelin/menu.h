#ifndef FEELIN_MENU_H
#define FEELIN_MENU_H

/*
**  $VER: feelin/menu.h 1.0 (2004/12/19)
**
**  © 2001-2004 Olivier LAVIALE (gofromiel@gofromiel.com)
*/

#define FC_Menu                                "Menu"
#define MenuObject                              IFEELIN F_NewObj(FC_Menu

/*** types *****************************************************************/

typedef struct FeelinMenuRenderData
{
    FObject                         RootMenu;
    FObject                         MainMenu;   // Current Tree Menu (may be RootMenu)
    FObject                         OpenMenu;   // Currently opened menu
/*
    struct MsgPort                  MenuPort;
    FObject                         MenuOwner;  // Current owner of the opened menu
    FObject                         TD;
   layerinfo:PTR TO layer_info
   inputhandler:PTR TO is
   selected:feelinList
   selectedpool:PTR TO CHAR
*/
}
FMenuRenderData;

typedef struct FeelinXMLReference
{
    STRPTR                          Name;
    FObject                         Object;
}                                                           FXMLReference;

typedef struct FeelinXMLDefinition
{
    STRPTR                          Name;
    APTR                            Data;
}                                                           FXMLDefinition;

/*** messages **************************************************************/

struct  FS_XMLApplication_Find                  { STRPTR Name; };

#endif
