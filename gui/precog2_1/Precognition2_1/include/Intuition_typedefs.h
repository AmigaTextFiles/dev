#ifndef INTUITION_TYPEDEFS_H
#define INTUITION_TYPEDEFS_H

/*
** This file 'typedef's all the major Intuition structures, cuz' I
** get tired of typing 'struct' all over the place.
**
**       Lee Willis
*/

#include <exec/types.h>
#include <intuition/intuition.h>
#include <graphics/gfx.h>
#include <graphics/text.h>

typedef struct Menu           Menu;
typedef struct MenuItem       MenuItem;
typedef struct Requester      Requester;
typedef struct Gadget         Gadget;
typedef struct PropInfo       PropInfo;
typedef struct StringInfo     StringInfo;
typedef struct IntuiText      IntuiText;
typedef struct Border         Border;
typedef struct Image          Image;
typedef struct IntuiMessage   IntuiMessage;
typedef struct Window         Window;
typedef struct NewWindow      NewWindow;
typedef struct RastPort       RastPort;
typedef struct tPoint         tPoint;
typedef struct Rectangle      Rectangle;
typedef struct TextAttr       TextAttr;
typedef struct TextFont       TextFont;
typedef struct Screen         Screen;
typedef struct MsgPort        MsgPort;

typedef SHORT  PIXELS;
typedef USHORT UPIXELS;

#endif
