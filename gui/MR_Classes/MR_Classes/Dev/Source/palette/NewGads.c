#include <classes/requesters/palette.h>
#include "ui.h"
#include "newgads.h"
#include "edata.h"
#include "apptags.h"
#include "gids.h"


#define CSLIDER(LabelStr, SliderGad, TextGad)\
    LAYOUT_AddChild,  HLayoutObject,\
                        LAYOUT_AddChild, SliderGad = SliderObject,  SLIDER_Max, 255,\
                                                                    SLIDER_Min, 0,\
                                                                    SLIDER_Orientation, SLIDER_HORIZONTAL,\
                                                                    End,\
                        LAYOUT_AddChild, TextGad = TextLine(""),\
                      End,\
    Label(LabelStr),\
    CHILD_WeightedHeight, 0

Object *NewGadgets(struct EData *edata)
{
  return(VLayoutObject,
        				LAYOUT_DeferLayout, TRUE,
                LAYOUT_SpaceOuter,1,
                LAYOUT_AddChild, edata->G_Palette = TCPaletteObject, TCPALETTE_NumColors,      edata->pr_Colors,
                                                  TCPALETTE_RGBPalette,     edata->pr_InitialPalette,
                                                  TCPALETTE_ShowSelected,   1,
                                                  End,

                LAYOUT_AddChild, SpaceObject, SPACE_MinHeight, 4, End,
                CHILD_WeightedHeight, 0,

                CSLIDER(GetString(MSG_G_RED),   edata->G_Red,       edata->G_RedText),
                CSLIDER(GetString(MSG_G_GREEN), edata->G_Green,     edata->G_GreenText),
                CSLIDER(GetString(MSG_G_BLUE),  edata->G_Blue,      edata->G_BlueText),

                LAYOUT_AddChild, SpaceObject, SPACE_MinHeight, 4, End,
                CHILD_WeightedHeight, 0,
                
                LAYOUT_AddChild,  HLayoutObject,
                                    LAYOUT_AddChild, edata->G_Copy   = PushButton(GetString(MSG_G_COPY),      GID_COPY),
                                    LAYOUT_AddChild, edata->G_Swap   = PushButton(GetString(MSG_G_SWAP),      GID_SWAP),
                                    LAYOUT_AddChild, edata->G_Spread = PushButton(GetString(MSG_G_SPREAD),    GID_SPREAD),
                                  End,
                CHILD_WeightedHeight, 0,
          
                LAYOUT_AddChild,  HLayoutObject,
                                    LAYOUT_AddChild, edata->G_Reset     = Button(GetString(MSG_G_RESET),     GID_RESET),
                                    LAYOUT_AddChild, edata->G_Undo      = Button(GetString(MSG_G_UNDO),      GID_UNDO),
                                  End,
                CHILD_WeightedHeight, 0,
                
                LAYOUT_AddChild, SpaceObject, SPACE_MinHeight, 8, End,
                CHILD_WeightedHeight, 0,
                
                LAYOUT_AddChild,  HLayoutObject,
                                    LAYOUT_AddChild, edata->G_OK     = Button(GetString(MSG_G_OK),             GID_OK),
                                    LAYOUT_AddChild, SpaceObject, SPACE_MinWidth, 8, End,
                                    LAYOUT_AddChild, edata->G_Cancel = Button(GetString(MSG_G_CANCEL),     GID_CANCEL),
                                  End,
                CHILD_WeightedHeight, 0,
                End
                );
}



