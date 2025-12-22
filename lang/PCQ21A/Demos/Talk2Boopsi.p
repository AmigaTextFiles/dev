PROGRAM Talk2Boopsi;

{ This example creates a Boopsi prop gadget and integer string gadget, connecting them so they }
{ update each other when the user changes their value.  The example program only initializes   }
{ the gadgets and puts them on the window; it doesn't have to interact with them to make them  }
{ talk to each other.                                                                          }

{$I "Include:exec/types.i"}
{$I "Include:utility/tagitem.i"}
{$I "Include:intuition/intuition.i"}
{$I "Include:intuition/gadgetclass.i"}
{$I "Include:intuition/icclass.i"}

VAR
   w    : WindowPtr;
   mymsg  : IntuiMessagePtr;
   prop,
   int  : GadgetPtr;
   done : BOOLEAN;
   dummy : Short;
   temp : integer;

CONST

   vers = "$VER: Talk2boopsi 37.1";

   prop2intmap : ARRAY [0..1] OF TagItem = (
                           (PGA_Top,   STRINGA_LongVal),
                           (TAG_END,0));

   int2propmap : ARRAY [0..1] OF TagItem = (
                           (STRINGA_LongVal,   PGA_Top),
                           (TAG_END,0));

   PROPGADGET_ID       = 1;
   INTGADGET_ID        = 2;
   PROPGADGETWIDTH     = 10;
   PROPGADGETHEIGHT    = 80;
   INTGADGETHEIGHT     = 18;
   VISIBLE             = 10;
   TOTAL               = 100;
   INITIALVAL          = 25;
   MINWINDOWWIDTH      = 80;
   MINWINDOWHEIGHT     = (PROPGADGETHEIGHT + 70);
   MAXCHARS            = 3;

PROCEDURE CleanUp(Why : STRING; err: INTEGER);
BEGIN
    IF prop <> NIL THEN DisposeObject(prop);
    IF int <> NIL THEN DisposeObject(int);
    IF w <> NIL THEN CloseWindow(w);
    IF Why <> NIL THEN WriteLN(Why);
    Exit(err);
END;

BEGIN

    done := FALSE;

    w := OpenWindowTags(NIL,
                 WA_Flags,     WFLG_DEPTHGADGET + WFLG_DRAGBAR +
                               WFLG_CLOSEGADGET + WFLG_SIZEGADGET + WFLG_ACTIVATE,
                 WA_IDCMP,     IDCMP_CLOSEWINDOW,
                 WA_Width,     MINWINDOWWIDTH,
                 WA_Height,    MINWINDOWHEIGHT,
                 WA_MinWidth,  MINWINDOWWIDTH,
                 WA_MinHeight, MINWINDOWHEIGHT,
                 WA_MaxWidth,  100,
                 WA_MaxWidth,  100,
                 TAG_END);
    IF w=NIL THEN CleanUp("No window",20);

    prop := NewObject(NIL, "propgclass",
                 GA_ID,       PROPGADGET_ID,
                 GA_Top,      (w^.BorderTop) + 5,
                 GA_Left,     (w^.BorderLeft) + 5,
                 GA_Width,    PROPGADGETWIDTH,
                 GA_Height,   PROPGADGETHEIGHT,
                 ICA_MAP,     @prop2intmap,
                 PGA_Total,   TOTAL,
                 PGA_Top,     INITIALVAL,
                 PGA_Visible, VISIBLE,
                 PGA_NewLook, True,
                 TAG_END);
    IF prop = NIL THEN CleanUp("No propgadget",20);


    int := NewObject(NIL, "strgclass",
                    GA_ID,      INTGADGET_ID,         
                    GA_Top,     (w^.BorderTop) + 5,
                    GA_Left,    (w^.BorderLeft) + PROPGADGETWIDTH + 10,
                    GA_Width,   MINWINDOWWIDTH -
                                  (w^.BorderLeft + w^.BorderRight +
                                  PROPGADGETWIDTH + 15),
                    GA_Height,  INTGADGETHEIGHT,

                    ICA_MAP,    @int2propmap,
                    ICA_TARGET, prop,                  
                    GA_Previous, prop,  

                    STRINGA_LongVal,  INITIALVAL, 
                    STRINGA_MaxChars, MAXCHARS,   
                    TAG_END);
                                                  
    temp := SetGadgetAttrs(prop, w, NIL,
                        ICA_TARGET, int,
                        TAG_END);
    IF int = NIL THEN CleanUp("No INTEGER gadget",20);

    dummy := AddGList(w, prop, -1, -1, NIL);
    RefreshGList(prop, w, NIL, -1);

    WHILE (NOT done) DO BEGIN
        mymsg := IntuiMessagePtr(WaitPort(W^.UserPort));
        mymsg := IntuiMessagePtr(GetMsg(W^.UserPort));
        IF mymsg^.Class = IDCMP_CLOSEWINDOW THEN done := True;
        ReplyMsg(MessagePtr(mymsg));
    END;

    dummy := RemoveGList(w, prop, -1);
    CleanUp(NIL,0);
END.





