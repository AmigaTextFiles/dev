#ifndef NEWGADS_H
#define NEWGADS_H

#include "ui.h"

Object *NewGadgets(struct EData *edata);

#define TEXTLINE(STRING)   ButtonObject, BUTTON_BevelStyle, BVS_NONE, BUTTON_Transparent, TRUE, GA_ReadOnly, TRUE, GA_Text, (STRING)

#endif /* NEWGADS_H */
