/*----------------------------------------------------------------------*
  func1.c Version 2.3 -  © Copyright 1990-91 Jaba Development

  Author : Jan van den Baard
  Purpose: Some subroutines for the program
 *----------------------------------------------------------------------*/

extern ULONG  Class;
extern USHORT Code, Qualifier;
extern struct Gadget *Gadget;
extern struct GadgetList Gadgets;
extern struct Window *MainWindow;
extern SHORT  MainX, MainY;

/*
 * read the mouse coordinates
 */
VOID get_xy(x,y)
    SHORT *x, *y;
{
    if(TestBits(MainWindow->Flags,GIMMEZEROZERO))
    { *x = MainWindow->GZZMouseX;
      *y = MainWindow->GZZMouseY;
    }
    else
    { *x = MainWindow->MouseX;
      *y = MainWindow->MouseY;
    }
}

/*
 * read a message from the window 'w' user port
 */
LONG read_msg(w)
    struct Window *w;
{
    struct IntuiMessage *msg;

    if((msg = (struct IntuiMessage *)GetMsg(w->UserPort)))
    {   Class     = msg->Class;
        Code      = msg->Code;
        Qualifier = msg->Qualifier;
        Gadget    = (struct Gadget *)msg->IAddress;
        ReplyMsg((struct Message *)msg);
        return(TRUE);
    }
    return(FALSE);
}

/*
 * wait for the user to select a gadget or
 * press the 'ESC' key
 */
struct Gadget *wait_for_gadget(w)
    struct Window *w;
{
    struct Gadget *g;

    while((Class != GADGETUP) AND (Class != GADGETDOWN))
    {   Wait(1 << w->UserPort->mp_SigBit);
        while(read_msg(w))
        {   g = Gadget;
            if((Class == RAWKEY) && (Code == ESC))
            {   while(read_msg(w));
                return(NULL);
            }
            get_xy(&MainX,&MainY);
        }
    }
    if(Class == GADGETDOWN)
    {   Wait(1 << w->UserPort->mp_SigBit);
        while(read_msg(w))
        {  if((Code == SELECTUP) AND (Class == GADGETUP)) break;
        }
    }
    while(read_msg(w));
    return(g);
}

/*
 * draw a box
 */
VOID draw_box(w,x,y,x1,y1)
    struct Window  *w;
    register SHORT x,y,x1,y1;
{
    register SHORT tmp;
    struct RastPort *rp;

    if(x > x1) { tmp = x; x = x1; x1 = tmp; }
    if(y > y1) { tmp = y; y = y1; y1 = tmp; }
    rp = w->RPort;
    SetDrMd(rp,JAM1+COMPLEMENT);
    Move(rp,x+1,y);
    Draw(rp,x1,y);
    Draw(rp,x1,y1);
    Draw(rp,x,y1);
    Draw(rp,x,y);
}
