/* scanner.c */

#include <exec/types.h>
#include <exec/memory.h>
#include <intuition/intuitionbase.h>
#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <string.h>
#include <stdio.h>

#include "scanner.h"

#define VERSION "1.0"

static struct structList structlist[MAXSTRUCTURE];


void main(argc, argv)
int argc;
BYTE *argv[];
{
  extern struct GfxBase *GfxBase;
  extern struct IntuitionBase *IntuitionBase;

  GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 1);
  IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 1);

  ScanScreens(IntuitionBase->FirstScreen);

  ListBitMaps();
  ListBoolInfos();
  ListBorders();
  ListGadgets();
  ListImages();
  ListIntuiMessages();
  ListIntuiTexts();
  ListKeyMaps();
  ListLayers();
  ListMenus();
  ListMsgPorts();
  ListPropInfos();
  ListRastPorts();
  ListRequesters();
  ListScreens();
  ListStringInfos();
  ListTextFonts();
  ListWindows();

  EraseStructList();

  CloseLibrary((struct Library *)IntuitionBase);
  CloseLibrary((struct Library *)GfxBase);
}


void ScanBitMaps(bitmap)
register struct BitMap *bitmap;
{
  WORD bitmapno;

  if (bitmap != NULL)
    bitmapno = BitMapNumber(bitmap);
}


void ScanBoolInfos(boolinfo)
register struct BoolInfo *boolinfo;
{
}


void ScanBorders(border)
register struct Border *border;
{
  WORD borderno;

  while (border != NULL)
  {
    borderno = BorderNumber(border);

    border = border->NextBorder;
  }
}


void ScanGadgets(gadget)
register struct Gadget *gadget;
{
  WORD gadgetno, gadgetrenderno, selectrenderno,
      gadgettextno, specialinfono, gadgettype;

  while (gadget != NULL)
  {
    gadgetno = GadgetNumber(gadget);

    if (gadget->Flags & GADGIMAGE)
    {
      gadgetrenderno = ImageNumber(gadget->GadgetRender);
      selectrenderno = ImageNumber(gadget->SelectRender);
    }
    else
    {
      gadgetrenderno = BorderNumber(gadget->GadgetRender);
      selectrenderno = BorderNumber(gadget->SelectRender);
    }
    gadgettextno = IntuiTextNumber(gadget->GadgetText);
    gadgettype = gadget->GadgetType & 0x0F;
    if (gadgettype == GADGET0002)
      specialinfono = BoolInfoNumber(gadget->SpecialInfo);
    else if (gadgettype == PROPGADGET)
      specialinfono = PropInfoNumber(gadget->SpecialInfo);
    else if (gadgettype == STRGADGET)
      specialinfono = StringInfoNumber(gadget->SpecialInfo);
    else
      specialinfono = 0;

    if (gadget->Flags & GADGIMAGE)
    {
      if (Fresh(gadgetrenderno)) ScanImages((struct Image *)gadget->GadgetRender);
      if (Fresh(selectrenderno)) ScanImages((struct Image *)gadget->SelectRender);
    }
    else
    {
      if (Fresh(gadgetrenderno)) ScanBorders((struct Border *)gadget->GadgetRender);
      if (Fresh(selectrenderno)) ScanBorders((struct Border *)gadget->SelectRender);
    }
    if (Fresh(gadgettextno)) ScanIntuiTexts(gadget->GadgetText);
    if (Fresh(specialinfono))
    {
      if (gadgettype == GADGET0002)
        ScanBoolInfos((struct BoolInfo *)gadget->SpecialInfo);
      else if (gadgettype == PROPGADGET)
        ScanPropInfos((struct PropInfo *)gadget->SpecialInfo);
      else if (gadgettype == STRGADGET)
        ScanStringInfos((struct StringInfo *)gadget->SpecialInfo);
    }

    gadget = gadget->NextGadget;
  }
}


void ScanImages(image)
register struct Image *image;
{
  WORD imageno;

  while (image != NULL)
  {
    imageno = ImageNumber(image);

    image = image->NextImage;
  }
}


void ScanIntuiMessages(intuimessage)
register struct IntuiMessage *intuimessage;
{
}


void ScanIntuiTexts(intuitext)
register struct IntuiText *intuitext;
{
  WORD intuitextno, itextfontno;

  while (intuitext != NULL)
  {
    intuitextno = IntuiTextNumber(intuitext);

    itextfontno = TextAttrNumber(intuitext->ITextFont);

    if (Fresh(itextfontno)) ScanTextAttrs(intuitext->ITextFont);

    intuitext = intuitext->NextText;
  }
}


void ScanKeyMaps(keymap)
register struct KeyMap *keymap;
{
}


void ScanLayers(layer)
register struct Layer *layer;
{
}


void ScanMenus(menu)
register struct Menu *menu;
{
}


void ScanMsgPorts(msgport)
register struct MsgPort *msgport;
{
}


void ScanPropInfos(propinfo)
register struct PropInfo *propinfo;
{
}


void ScanRastPorts(rastport)
register struct RastPort *rastport;
{
}


void ScanRequesters(requester)
register struct Requester *requester;
{
  WORD requesterno, olderrequestno, reqgadgetno, reqborderno, reqtextno,
      reqlayerno, imagebmapno, rwindowno;

  if (requester != NULL)
  {
    requesterno = RequesterNumber(requester);

    olderrequestno = RequesterNumber(requester->OlderRequest);
    reqgadgetno = GadgetNumber(requester->ReqGadget);
    reqborderno = BorderNumber(requester->ReqBorder);
    reqtextno = IntuiTextNumber(requester->ReqText);
    reqlayerno = LayerNumber(requester->ReqLayer);
    imagebmapno = BitMapNumber(requester->ImageBMap);
    rwindowno = WindowNumber(requester->RWindow);

    if (Fresh(olderrequestno)) ScanRequesters(requester->OlderRequest);
    if (Fresh(reqgadgetno)) ScanGadgets(requester->ReqGadget);
    if (Fresh(reqborderno)) ScanBorders(requester->ReqBorder);
    if (Fresh(reqtextno)) ScanIntuiTexts(requester->ReqText);
    if (Fresh(reqlayerno)) ScanLayers(requester->ReqLayer);
    if (Fresh(imagebmapno)) ScanBitMaps(requester->ImageBMap);
    if (Fresh(rwindowno)) ScanWindows(requester->RWindow);
  }
}


void ScanScreens(screen)
register struct Screen *screen;
{
  WORD screenno, windowno;

  while (screen != NULL)
  {
    screenno = ScreenNumber(screen);

    windowno = WindowNumber(screen->FirstWindow);

    if (Fresh(windowno)) ScanWindows(screen->FirstWindow);

    screen = screen->NextScreen;
  }
}


void ScanStringInfos(stringinfo)
register struct StringInfo *stringinfo;
{
  WORD stringinfono, layerptrno, altkeymapno;

  if (stringinfo != NULL)
  {
    stringinfono = StringInfoNumber(stringinfo);

    layerptrno = LayerNumber(stringinfo->LayerPtr);
    altkeymapno = KeyMapNumber(stringinfo->AltKeyMap);

    if (Fresh(layerptrno)) ScanLayers(stringinfo->LayerPtr);
    if (Fresh(altkeymapno)) ScanKeyMaps(stringinfo->AltKeyMap);
  }
}


void ScanTextAttrs(textattr)
register struct TextAttr *textattr;
{
}


void ScanTextFonts(textfont)
register struct TextFont *textfont;
{
}


void ScanWindows(window)
register struct Window *window;
{
  WORD windowno, menustripno, firstrequestno, dmrequestno, rportno,
      borderrportno, firstgadgetno, parentwindowno, descendantwindowno,
      userportno, windowportno, messagekeyno, checkmarkno, wlayerno,
      ifontno, wscreenno;

  while (window != NULL)
  {
    windowno = WindowNumber(window);

    menustripno = MenuNumber(window->MenuStrip);
    firstrequestno = RequesterNumber(window->FirstRequest);
    dmrequestno = RequesterNumber(window->DMRequest);
    wscreenno = ScreenNumber(window->WScreen);
    rportno = RastPortNumber(window->RPort);
    borderrportno = RastPortNumber(window->BorderRPort);
    firstgadgetno = GadgetNumber(window->FirstGadget);
    parentwindowno = WindowNumber(window->Parent);
    descendantwindowno = WindowNumber(window->Descendant);
    userportno = MsgPortNumber(window->UserPort);
    windowportno = MsgPortNumber(window->WindowPort);
    messagekeyno = IntuiMessageNumber(window->MessageKey);
    checkmarkno = ImageNumber(window->CheckMark);
    wlayerno = LayerNumber(window->WLayer);
    ifontno = TextFontNumber(window->IFont);

    if (Fresh(menustripno)) ScanMenus(window->MenuStrip);
    if (Fresh(firstrequestno)) ScanRequesters(window->FirstRequest);
    if (Fresh(dmrequestno)) ScanRequesters(window->DMRequest);
    if (Fresh(wscreenno)) ScanScreens(window->WScreen);
    if (Fresh(rportno)) ScanRastPorts(window->RPort);
    if (Fresh(borderrportno)) ScanRastPorts(window->BorderRPort);
    if (Fresh(firstgadgetno)) ScanGadgets(window->FirstGadget);
    if (Fresh(parentwindowno)) ScanWindows(window->Parent);
    if (Fresh(descendantwindowno)) ScanWindows(window->Descendant);
    if (Fresh(userportno)) ScanMsgPorts(window->UserPort);
    if (Fresh(windowportno)) ScanMsgPorts(window->WindowPort);
    if (Fresh(messagekeyno)) ScanIntuiMessages(window->MessageKey);
    if (Fresh(checkmarkno)) ScanImages(window->CheckMark);
    if (Fresh(wlayerno)) ScanLayers(window->WLayer);
    if (Fresh(ifontno)) ScanTextFonts(window->IFont);

    window = window->NextWindow;
  }
}


BYTE Fresh(number)
register WORD number;
{
  register BYTE fresh;

  fresh = (number != 0 && ((number & FOUND) == 0));

  return(fresh);
}


WORD structNumber(structure, structurekind)
register APTR structure;
register WORD structurekind;
{
  register WORD number;
  register BYTE found;
  register struct structList *structitem;
  struct structList *newstruct;
  extern struct structList structlist[MAXSTRUCTURE];

  if (structure == NULL)
    number = 0;
  else
  {
    structitem = structlist[structurekind].next;
    found = FALSE;
    while (structitem != NULL && !found)
    {
      if (structitem->structure == structure)
        found = TRUE;
      else
        structitem = structitem->next;
    }

    if (found)
      number = structitem->number | FOUND;
    else
    {
      number = ++(structlist[structurekind].number);

      newstruct = (struct structList *)AllocMem(
          sizeof(struct structList), MEMF_PUBLIC);
      newstruct->next = structlist[structurekind].next;
      newstruct->structure = (APTR)structure;
      newstruct->number = number;
      structlist[structurekind].next = newstruct;
    }
  }

  return(number);
}


void EraseStructList()
{
  register WORD structurekind;
  register struct structList *structitem, *nextstructitem;
  extern struct structList structlist[MAXSTRUCTURE];

  for (structurekind = 0; structurekind < MAXSTRUCTURE; structurekind++)
  {
    structitem = structlist[structurekind].next;
    while (structitem != NULL)
    {
      nextstructitem = structitem->next;
      FreeMem((BYTE *)structitem, sizeof(struct structList));
      structitem = nextstructitem;
    }
  }
}


UBYTE *APTRName(name)
register UBYTE *name;
{
  static UBYTE string[40];

  if (strcmp(name, "NULL") == 0)
    strcpy(string, name);
  else
  {
    strcpy(string, "(APTR)");
    strcat(string, name);
  }

  return(string);
}


UBYTE *structName(number, structurekind)
register WORD number, structurekind;
{
  static UBYTE string[40];
  static UBYTE *structname[MAXSTRUCTURE] =
  {
    "bitmap",
    "boolinfo",
    "border",
    "gadget",
    "image",
    "intuimessage",
    "intuitext",
    "keymap",
    "layer",
    "menu",
    "msgport",
    "propinfo",
    "rastport",
    "requester",
    "screen",
    "stringinfo",
    "textattr",
    "textfont",
    "window"
  };

  if (number == 0)
    strcpy(string, "NULL");
  else
    sprintf(string, "&%s%d", structname[structurekind], NUMBER(number));

  return(string);
}


UBYTE *TitleName(title)
register UBYTE *title;
{
  static UBYTE string[100];

  if (string == NULL)
    strcpy(string, "NULL");
  else
    sprintf(string, "\"%s\"", title);

  return(string);
}


UBYTE *MemoryName(memorypos)
register APTR memorypos;
{
  static UBYTE string[20];

  if (memorypos == NULL)
    strcpy(string, "NULL");
  else
    sprintf(string, "0x%X", memorypos);

  return(string);
}


void ListBitMaps()
{
  register struct BitMap *bitmap;
  register struct structList *structitem;
  register WORD plane;
  WORD bitmapno;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[BITMAP_KIND].next;

  while (structitem != NULL)
  {
    bitmap = (struct BitMap *)structitem->structure;
    bitmapno = structitem->number;

    printf("struct BitMap bitmap%d =\n", bitmapno);
    printf("{\n");
    printf("  %d,\011/* BytesPerRow */\n", bitmap->BytesPerRow);
    printf("  %d,\011/* Rows */\n", bitmap->Rows);
    printf("  0x%X,\011/* Flags */\n", bitmap->Flags);
    printf("  %d,\011/* Depth */\n", bitmap->Depth);
    printf("  %d,\011/* Pad */\n", bitmap->pad);
    printf("  {\011/* Planes */\n");
    for (plane = 0; plane < 7; plane++)
      printf("    %s,\n", MemoryName((APTR)(bitmap->Planes[plane])));
    printf("    %s\n", MemoryName((APTR)(bitmap->Planes[7])));
    printf("  }\n");
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListBoolInfos()
{
  register struct BoolInfo *boolinfo;
  register struct structList *structitem;
  WORD boolinfono;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[BOOLINFO_KIND].next;

  while (structitem != NULL)
  {
    boolinfo = (struct BoolInfo *)structitem->structure;
    boolinfono = structitem->number;

    printf("struct BoolInfo boolinfo%d =\n", boolinfono);
    printf("{\n");
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListBorders()
{
  register struct Border *border;
  register struct structList *structitem;
  WORD borderno, xyno, nextborderno;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[BORDER_KIND].next;

  while (structitem != NULL)
  {
    border = (struct Border *)structitem->structure;
    borderno = structitem->number;

    xyno = NUMBER(borderno);
    nextborderno = BorderNumber(border->NextBorder);

    if (border->XY != NULL)
    {
      printf("WORD xypair%d[%d] =\n", xyno, 2 * border->Count);
      PrintWords("%d", "  ", "{", border->XY, "};", (WORD)(2 * border->Count), 8);
    }

    printf("struct Border border%d =\n", borderno);
    printf("{\n");
    printf("  %d, %d,\011/* LeftEdge, TopEdge */\n", border->LeftEdge,
        border->TopEdge);
    printf("  %d, %d,\011/* FrontPen, BackPen */\n", border->FrontPen,
        border->BackPen);
    printf("  0x%X,\011/* DrawMode */\n", border->DrawMode);
    printf("  %d,\011/* Count */\n", border->Count);
    if (border->XY == NULL)
      printf("  NULL");
    else
      printf("  &xypair%d[0]", xyno);
    printf(",\011/* XY */\n");
    printf("  %s\011/* NextBorder */\n", BorderName(nextborderno));
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListGadgets()
{
  register struct Gadget *gadget;
  register struct structList *structitem;
  WORD gadgetno, nextgadgetno, gadgetrenderno, selectrenderno,
      gadgettextno, specialinfono, gadgettype;
  UBYTE *name;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[GADGET_KIND].next;

  while (structitem != NULL)
  {
    gadget = (struct Gadget *)structitem->structure;
    gadgetno = structitem->number;

    nextgadgetno = GadgetNumber(gadget->NextGadget);
    if (gadget->Flags & GADGIMAGE)
    {
      gadgetrenderno = ImageNumber(gadget->GadgetRender);
      selectrenderno = ImageNumber(gadget->SelectRender);
    }
    else
    {
      gadgetrenderno = BorderNumber(gadget->GadgetRender);
      selectrenderno = BorderNumber(gadget->SelectRender);
    }
    gadgettextno = IntuiTextNumber(gadget->GadgetText);
    gadgettype = gadget->GadgetType & 0x0F;
    if (gadgettype == GADGET0002)
      specialinfono = BoolInfoNumber(gadget->SpecialInfo);
    else if (gadgettype == PROPGADGET)
      specialinfono = PropInfoNumber(gadget->SpecialInfo);
    else if (gadgettype == STRGADGET)
      specialinfono = StringInfoNumber(gadget->SpecialInfo);
    else
      specialinfono = 0;

    printf("struct Gadget gadget%d =\n", gadgetno);
    printf("{\n");
    printf("  %s,\011/* NextGadget */\n", GadgetName(nextgadgetno));
    printf("  %d, %d,\011/* LeftEdge, TopEdge */\n", gadget->LeftEdge,
        gadget->TopEdge);
    printf("  %d, %d,\011/* Width, Height */\n",gadget->Width, gadget->Height);
    printf("  0x%X,\011/* Flags */\n", gadget->Flags);
    printf("  0x%X,\011/* Activation */\n", gadget->Activation);
    printf("  0x%X,\011/* GadgetType */\n", gadget->GadgetType);
    if (gadget->Flags & GADGIMAGE)
      name = ImageName(gadgetrenderno);
    else
      name = BorderName(gadgetrenderno);
    printf("  %s,\011/* GadgetRender */\n", APTRName(name));
    if (gadget->Flags & GADGIMAGE)
      name = ImageName(selectrenderno);
    else
      name = BorderName(selectrenderno);
    printf("  %s,\011/* SelectRender */\n", APTRName(name));
    printf("  %s,\011/* GadgetText */\n", IntuiTextName(gadgettextno));
    printf("  0x%X,\011/* MutualExclude */\n", gadget->MutualExclude);
    if (gadgettype == GADGET0002)
      name = BoolInfoName(specialinfono);
    else if (gadgettype == PROPGADGET)
      name = PropInfoName(specialinfono);
    else if (gadgettype == STRGADGET)
      name = StringInfoName(specialinfono);
    else
      name = MemoryName(gadget->SpecialInfo);
    printf("  %s,\011/* SpecialInfo */\n", APTRName(name));
    printf("  %d,\011/* GadgetID */\n", gadget->GadgetID);
    printf("  %s\011/* UserData */\n", MemoryName(gadget->UserData));
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListImages()
{
  register struct Image *image;
  register struct structList *structitem;
  register WORD count;
  WORD imageno, imagedatano, nextimageno;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[IMAGE_KIND].next;

  while (structitem != NULL)
  {
    image = (struct Image *)structitem->structure;
    imageno = structitem->number;

    imagedatano = NUMBER(imageno);
    nextimageno = ImageNumber(image->NextImage);

    if (image->ImageData != NULL)
    {
      count = image->Depth * image->Height * ((image->Width + 15) / 16);
      printf("UWORD imagedata%d[%d] =\n", imagedatano, count);
      PrintWords("0x%X", "  ", "{", image->ImageData, "};", count, 8);
    }

    printf("struct Image image%d =\n", imageno);
    printf("{\n");
    printf("  %d, %d,\011/* LeftEdge, TopEdge */\n", image->LeftEdge,
        image->TopEdge);
    printf("  %d, %d,\011/* Width, Height */\n", image->Width, image->Height);
    printf("  %d,\011/* Depth */\n", image->Depth);
    if (image->ImageData == NULL)
      printf("  NULL");
    else
      printf("  &imagedata%d[0]", imagedatano);
    printf("\011/* ImageData */\n");
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListIntuiMessages()
{
  register struct IntuiMessage *intuimessage;
  register struct structList *structitem;
  WORD intuimessageno;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[INTUIMESSAGE_KIND].next;

  while (structitem != NULL)
  {
    intuimessage = (struct IntuiMessage *)structitem->structure;
    intuimessageno = structitem->number;

    printf("struct IntuiMessage intuimessage%d =\n", intuimessageno);
    printf("{\n");
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListIntuiTexts()
{
  register struct IntuiText *intuitext;
  register struct structList *structitem;
  WORD intuitextno, itextfontno, nexttextno;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[INTUITEXT_KIND].next;

  while (structitem != NULL)
  {
    intuitext = (struct IntuiText *)structitem->structure;
    intuitextno = structitem->number;

    itextfontno = TextAttrNumber(intuitext->ITextFont);
    nexttextno = IntuiTextNumber(intuitext->NextText);

    printf("struct IntuiText intuitext%d =\n", intuitextno);
    printf("{\n");
    printf("  %d, %d,\011/* FrontPen, BackPen */\n", intuitext->FrontPen,
        intuitext->BackPen);
    printf("  0x%X,\011/* DrawMode */\n", intuitext->DrawMode);
    printf("  %d, %d,\011/* LeftEdge, TopEdge */\n", intuitext->LeftEdge,
        intuitext->TopEdge);
    printf("  %s,\011/* ITextFont */\n", TextAttrName(itextfontno));
    printf("  %s,\011/* IText */\n", TitleName(intuitext->IText));
    printf("  %s\011/* NextText */\n", IntuiTextName(nexttextno));
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListKeyMaps()
{
  register struct KeyMap *keymap;
  register struct structList *structitem;
  WORD keymapno;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[KEYMAP_KIND].next;

  while (structitem != NULL)
  {
    keymap = (struct KeyMap *)structitem->structure;
    keymapno = structitem->number;

    printf("struct KeyMap keymap%d =\n", keymapno);
    printf("{\n");
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListLayers()
{
  register struct Layer *layer;
  register struct structList *structitem;
  WORD layerno;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[LAYER_KIND].next;

  while (structitem != NULL)
  {
    layer = (struct Layer *)structitem->structure;
    layerno = structitem->number;

    printf("struct Layer layer%d =\n", layerno);
    printf("{\n");
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListMenus()
{
  register struct Menu *menu;
  register struct structList *structitem;
  WORD menuno;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[MENU_KIND].next;

  while (structitem != NULL)
  {
    menu = (struct Menu *)structitem->structure;
    menuno = structitem->number;

    printf("struct Menu menu%d =\n", menuno);
    printf("{\n");
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListMsgPorts()
{
  register struct MsgPort *msgport;
  register struct structList *structitem;
  WORD msgportno;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[MSGPORT_KIND].next;

  while (structitem != NULL)
  {
    msgport = (struct MsgPort *)structitem->structure;
    msgportno = structitem->number;

    printf("struct MsgPort msgport%d =\n", msgportno);
    printf("{\n");
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListPropInfos()
{
  register struct PropInfo *propinfo;
  register struct structList *structitem;
  WORD propinfono;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[PROPINFO_KIND].next;

  while (structitem != NULL)
  {
    propinfo = (struct PropInfo *)structitem->structure;
    propinfono = structitem->number;

    printf("struct PropInfo propinfo%d =\n", propinfono);
    printf("{\n");
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListRastPorts()
{
  register struct RastPort *rastport;
  register struct structList *structitem;
  WORD rastportno;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[RASTPORT_KIND].next;

  while (structitem != NULL)
  {
    rastport = (struct RastPort *)structitem->structure;
    rastportno = structitem->number;

    printf("struct RastPort rastport%d =\n", rastportno);
    printf("{\n");
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListRequesters()
{
  register struct Requester *requester;
  register struct structList *structitem;
  WORD requesterno, olderrequestno, reqgadgetno, reqborderno, reqtextno,
      reqlayerno, imagebmapno, rwindowno;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[REQUESTER_KIND].next;

  while (structitem != NULL)
  {
    requester = (struct Requester *)structitem->structure;
    requesterno = structitem->number;

    olderrequestno = RequesterNumber(requester->OlderRequest);
    reqgadgetno = GadgetNumber(requester->ReqGadget);
    reqborderno = BorderNumber(requester->ReqBorder);
    reqtextno = IntuiTextNumber(requester->ReqText);
    reqlayerno = LayerNumber(requester->ReqLayer);
    imagebmapno = BitMapNumber(requester->ImageBMap);
    rwindowno = WindowNumber(requester->RWindow);

    printf("struct Requester requester%d =\n", requesterno);
    printf("{\n");
    printf("  %s,\011/* OlderRequest */\n", RequesterName(requesterno));
    printf("  %d, %d,\011/* LeftEdge, TopEdge */\n", requester->LeftEdge,
        requester->TopEdge);
    printf("  %d, %d,\011/* Width, Height */\n", requester->Width,
        requester->Height);
    printf("  %d, %d,\011/* RelLeft, RelTop */\n", requester->RelLeft,
        requester->RelTop);
    printf("  %s,\011/* ReqGadget */\n", GadgetName(reqgadgetno));
    printf("  %s,\011/* ReqBorder */\n", BorderName(reqborderno));
    printf("  %s,\011/* ReqText */\n", IntuiTextName(reqtextno));
    printf("  0x%X,\011/* Flags */\n", requester->Flags);
    printf("  %d,\011/* BackFill */\n", requester->BackFill);
    printf("  %s,\011/* ReqLayer */\n", LayerName(reqlayerno));
    PrintBytes("    ", "  {\011/* ReqPad1 */", requester->ReqPad1, "  },",
        32, 8);
    printf("  %s,\011/* ImageBMap */\n", BitMapName(imagebmapno));
    printf("  %s,\011/* RWindow */\n", WindowName(rwindowno));
    PrintBytes("    ", "  {\011/* ReqPad2 */", requester->ReqPad2, "  }",
       36, 9);
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListScreens()
{
  register struct Screen *screen;
  register struct structList *structitem;
  WORD screenno;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[SCREEN_KIND].next;

  while (structitem != NULL)
  {
    screen = (struct Screen *)structitem->structure;
    screenno = structitem->number;

    printf("struct Screen screen%d =\n", screenno);
    printf("{\n");
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListStringInfos()
{
  register struct StringInfo *stringinfo;
  register struct structList *structitem;
  WORD stringinfono, layerptrno, altkeymapno;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[STRINGINFO_KIND].next;

  while (structitem != NULL)
  {
    stringinfo = (struct StringInfo *)structitem->structure;
    stringinfono = structitem->number;

    layerptrno = LayerNumber(stringinfo->LayerPtr);
    altkeymapno = KeyMapNumber(stringinfo->AltKeyMap);

    printf("struct StringInfo stringinfo%d =\n", stringinfono);
    printf("{\n");
    printf("  %s,\011/* Buffer */\n", TitleName(stringinfo->Buffer));
    printf("  %s,\011/* UndoBuffer */\n", TitleName(stringinfo->UndoBuffer));
    printf("  %d,\011/* BufferPos */\n", stringinfo->BufferPos);
    printf("  %d,\011/* MaxChars */\n", stringinfo->MaxChars);
    printf("  %d,\011/* DispPos */\n", stringinfo->DispPos);
    printf("  %d,\011/* UndoPos */\n", stringinfo->UndoPos);
    printf("  %d,\011/* NumChars */\n", stringinfo->NumChars);
    printf("  %d,\011/* DispCount */\n", stringinfo->DispCount);
    printf("  %d, %d,\011/* CLeft, CTop */\n", stringinfo->CLeft,
        stringinfo->CTop);
    printf("  %s,\011/* LayerPtr */\n", LayerName(layerptrno));
    printf("  %d,\011/* LongInt */\n", stringinfo->LongInt);
    printf("  %s\011/* AltKeyMap */\n", KeyMapName(altkeymapno));
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListTextAttrs()
{
  register struct TextAttr *textattr;
  register struct structList *structitem;
  WORD textattrno;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[TEXTATTR_KIND].next;

  while (structitem != NULL)
  {
    textattr = (struct TextAttr *)structitem->structure;
    textattrno = structitem->number;

    printf("struct TextAttr textattr%d =\n", textattrno);
    printf("{\n");
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListTextFonts()
{
  register struct TextFont *textfont;
  register struct structList *structitem;
  WORD textfontno;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[TEXTFONT_KIND].next;

  while (structitem != NULL)
  {
    textfont = (struct TextFont *)structitem->structure;
    textfontno = structitem->number;

    printf("struct TextFont textfont%d =\n", textfontno);
    printf("{\n");
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void ListWindows()
{
  register struct Window *window;
  register struct structList *structitem;
  WORD windowno, menustripno, firstrequestno, dmrequestno, rportno,
      borderrportno, firstgadgetno, parentwindowno, descendantwindowno,
      pointerno, userportno, windowportno, messagekeyno, checkmarkno,
      wlayerno, ifontno, wscreenno, nextwindowno, count;
  extern struct structList structlist[MAXSTRUCTURE];

  structitem = structlist[WINDOW_KIND].next;

  while (structitem != NULL)
  {
    window = (struct Window *)structitem->structure;
    windowno = structitem->number;

    nextwindowno = WindowNumber(window->NextWindow);
    menustripno = MenuNumber(window->MenuStrip);
    firstrequestno = RequesterNumber(window->FirstRequest);
    dmrequestno = RequesterNumber(window->DMRequest);
    wscreenno = ScreenNumber(window->WScreen);
    rportno = RastPortNumber(window->RPort);
    borderrportno = RastPortNumber(window->BorderRPort);
    firstgadgetno = GadgetNumber(window->FirstGadget);
    parentwindowno = WindowNumber(window->Parent);
    descendantwindowno = WindowNumber(window->Descendant);
    pointerno = NUMBER(windowno);
    userportno = MsgPortNumber(window->UserPort);
    windowportno = MsgPortNumber(window->WindowPort);
    messagekeyno = IntuiMessageNumber(window->MessageKey);
    checkmarkno = ImageNumber(window->CheckMark);
    wlayerno = LayerNumber(window->WLayer);
    ifontno = TextFontNumber(window->IFont);

    if (window->Pointer != NULL)
    {
      count = 2 * window->PtrHeight;
      printf("WORD pointer%d[%d] =\n", pointerno, count);
      PrintWords("0x%X", "  ", "{", window->Pointer, "};", count, 8);
    }

    printf("struct Window window%d =\n", windowno);
    printf("{\n");
    printf("  %s,\011/* NextWindow */\n", WindowName(nextwindowno));
    printf("  %d, %d,\011/* LeftEdge, TopEdge */\n", window->LeftEdge,
        window->TopEdge);
    printf("  %d, %d,\011/* Width, Height */\n", window->Width, window->Height);
    printf("  %d, %d,\011/* MouseY, MouseX */\n", window->MouseY, window->MouseX);
    printf("  %d, %d,\011/* MinWidth, MinHeight */\n", window->MinWidth,
        window->MinHeight);
    printf("  %d, %d,\011/* MaxWidth, MaxHeight */\n", window->MaxWidth,
        window->MaxHeight);
    printf("  0x%X,\011/* Flags */\n", window->Flags);
    printf("  %s,\011/* MenuStrip */\n", MenuName(menustripno));
    printf("  %s,\011/* Title */\n", TitleName(window->Title));
    printf("  %s,\011/* FirstRequest */\n", RequesterName(firstrequestno));
    printf("  %s,\011/* DMRequest */\n", RequesterName(dmrequestno));
    printf("  %d,\011/* ReqCount */\n", window->ReqCount);
    printf("  %s,\011/* WScreen */\n", ScreenName(wscreenno));
    printf("  %s,\011/* RPort */\n", RastPortName(rportno));
    printf("  %d, %d,\011/* BorderLeft, BorderTop */\n", window->BorderLeft,
        window->BorderTop);
    printf("  %d, %d,\011/* BorderRight, BorderBottom */\n", window->BorderRight,
        window->BorderBottom);
    printf("  %s,\011/* BorderRPort */\n", RastPortName(borderrportno));
    printf("  %s,\011/* FirstGadget */\n", GadgetName(firstgadgetno));
    printf("  %s,\011/* Parent */\n", WindowName(parentwindowno));
    printf("  %s,\011/* Descendant */\n", WindowName(descendantwindowno));
    if (window->Pointer == NULL)
      printf("  NULL");
    else
      printf("  &pointer%d", pointerno);
    printf(",\011/* Pointer */\n");
    printf("  %d, %d,\011/* PtrHeight, PtrWidth */\n", window->PtrHeight,
        window->PtrWidth);
    printf("  %d, %d,\011/* XOffset, YOffset */\n", window->XOffset,
        window->YOffset);
    printf("  0x%X,\011/* IDCMPFlags */\n", window->IDCMPFlags);
    printf("  %s,\011/* UserPort */\n", MsgPortName(userportno));
    printf("  %s,\011/* WindowPort */\n", MsgPortName(windowportno));
    printf("  %s,\011/* MessageKey */\n", IntuiMessageName(messagekeyno));
    printf("  %d, %d,\011/* DetailPen, BlockPen */\n", window->DetailPen,
        window->BlockPen);
    printf("  %s,\011/* CheckMark */\n", ImageName(checkmarkno));
    printf("  %s,\011/* ScreenTitle */\n", TitleName(window->ScreenTitle));
    printf("  %d, %d,\011/* GZZMouseX, GZZMouseY */\n", window->GZZMouseX,
        window->GZZMouseY);
    printf("  %d, %d,\011/* GZZWidth, GZZHeight */\n", window->GZZWidth,
        window->GZZHeight);
    printf("  %s,\011/* ExtData */\n", MemoryName((APTR)window->ExtData));
    printf("  %s,\011/* UserData */\n", MemoryName((APTR)window->UserData));
    printf("  %s,\011/* WLayer */\n", LayerName(wlayerno));
    printf("  %s\011/* IFont */\n", TextFontName(ifontno));
    printf("};\n\n");

    structitem = structitem->next;
  }
}


void PrintBytes(indenttext, text1, bytes, text2, length, rowlength)
register UBYTE *indenttext, *text1, *bytes, *text2;
register WORD length, rowlength;
{
  register WORD byte;

  printf("%s\n", text1);

  for (byte = 0; byte < length; byte++)
  {
    if (byte % rowlength == 0)
      printf("    ");
    printf("%d", bytes[byte]);

    if (byte != (length - 1))
      printf(", ");
    if ((byte + 1) % rowlength == 0 || byte == (length - 1))
      printf("\n");
  }

  printf("%s\n", text2);
}


void PrintWords(format, indenttext, text1, words, text2, length, rowlength)
register UBYTE *format, *indenttext, *text1, *text2;
register UWORD *words;
register WORD length, rowlength;
{
  register WORD word;

  printf("%s\n", text1);

  for (word = 0; word < length; word++)
  {
    if (word % rowlength == 0)
      printf("    ");
    printf(format, words[word]);

    if (word != (length - 1))
      printf(", ");
    if ((word + 1) % rowlength == 0 || word == (length - 1))
      printf("\n");
  }

  printf("%s\n", text2);
}
