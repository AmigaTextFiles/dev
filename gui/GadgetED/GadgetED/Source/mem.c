/*----------------------------------------------------------------------*
  mem.c Version 2.3 -  © Copyright 1990-91 Jaba Development

  Author : Jan van den Baard
  Purpose: Freeing the alocated memory the gadgets take up
 *----------------------------------------------------------------------*/

extern struct Window      *MainWindow;
extern struct GadgetList   Gadgets;
extern struct MemoryChain  Memory;
extern struct Gadget       TextGadget;
extern USHORT              GadgetCount, id;
extern BOOL                Saved;

/*
 * Free the memory of any type off gadget rendering attached to the gadget.
 */
VOID FreeRender(gadget)
    struct Gadget *gadget;
{
    struct Image  *image;
    struct Border *border, *border1;
    ULONG         ps;

    if(TestBits((ULONG)gadget->GadgetType,PROPGADGET))
    {   image = (struct Image *)gadget->GadgetRender;
        if(TestBits((ULONG)gadget->Flags,GADGIMAGE))
        {    ps = RASSIZE(image->Width,image->Height);
             FreeMem(image->ImageData,ps * image->Depth);
        }
        FreeItem(&Memory,image,(long)sizeof(struct Image));
    }
    else if(TestBits((ULONG)gadget->Flags,GADGIMAGE))
    {   image = (struct Image *)gadget->GadgetRender;
        ps = RASSIZE(image->Width,image->Height);
        FreeMem(image->ImageData,ps * image->Depth);
        FreeItem(&Memory,image,(long)sizeof(struct Image));
    }
    else
    {   border = (struct Border *)gadget->GadgetRender;
        while(1)
        {   border1 = border->NextBorder;
            FreeItem(&Memory,border->XY,(border->Count << 2));
            FreeItem(&Memory,border,(long)sizeof(struct Border));
            if(NOT(border = border1)) break;
        }
    }
    if((TestBits((ULONG)gadget->Flags,GADGHIMAGE)) AND
       (NOT TestBits((ULONG)gadget->Flags,GADGHBOX)))
    {   image = (struct Image *)gadget->SelectRender;
        ps = RASSIZE(image->Width,image->Height);
        FreeMem(image->ImageData,ps * image->Depth);
        FreeItem(&Memory,image,(long)sizeof(struct Image));
    }
}

/*
 * Free the memory a gadget takes up.
 */
VOID FreeGadget(gadget)
    struct MyGadget *gadget;
{
    struct IntuiText  *itext,*tmp;
    struct StringInfo *sinfo;

    if(TestBits((ULONG)gadget->Gadget.GadgetType,PROPGADGET))
    {   if(gadget->Gadget.SpecialInfo)
            FreeItem(&Memory,gadget->Gadget.SpecialInfo,(long)sizeof(struct PropInfo));
    }
    FreeRender(&gadget->Gadget);
    itext = gadget->Gadget.GadgetText;
    if(itext)
    {   while(1)
        {    tmp = itext->NextText;
             if(itext->IText) FreeItem(&Memory,itext->IText,80L);
             FreeItem(&Memory,itext,(long)sizeof(struct IntuiText));
             if(!tmp) break;
             itext = tmp;
        }
    }
    if(TestBits((ULONG)gadget->Gadget.GadgetType,STRGADGET))
    {   sinfo = (struct StringInfo *)gadget->Gadget.SpecialInfo;
        if(sinfo->Buffer)
        {   FreeItem(&Memory,sinfo->Buffer,sinfo->MaxChars);
        }
        if(sinfo->UndoBuffer)
        {   FreeItem(&Memory,sinfo->UndoBuffer,sinfo->MaxChars);
        }
        FreeItem(&Memory,sinfo,(long)sizeof(struct StringInfo));
    }
    FreeItem(&Memory,gadget,(long)sizeof(struct MyGadget));
}

/*
 * Free the complete list of gadgets.
 */

struct MemoryBlock *b;

VOID FreeGList()
{
   struct MyGadget *gadget, *tmp;
   struct IntuiText *t, *t1;

   while(gadget = (struct MyGadget *)RemHead((void *)&Gadgets))
   {     un_grel(MainWindow,&gadget->Gadget);
         RemoveGadget(MainWindow,&gadget->Gadget);
         FreeGadget(gadget);
   }
   NewList((void *)&Gadgets);
   GadgetCount = id = 0;

   if((t = TextGadget.GadgetText))
   {   while(1)
       {   t1 = t->NextText;
           if(t->IText) FreeItem(&Memory,t->IText,80L);
           FreeItem(&Memory,t,(long)sizeof(struct IntuiText));
           if(NOT t1) break;
           t = t1;
       }
       TextGadget.GadgetText = NULL;
   }
   Saved = TRUE;
}
