MODULE TalkToBoopsi;

(*  Simple boopsi program by Marcel Timmermans written in 
 *  Cyclone Modula-2 V0.80 (C) Marcel Timmermans
 *  This program is converted from a 'C' program in the RKRM Manuals.
 *)

FROM SYSTEM IMPORT ADDRESS,ADR;
IMPORT id:IntuitionD,il:IntuitionL,ud:UtilityD,ed:ExecD,el:ExecL;

CONST
 LTRUE=1;

VAR
 w    : id.WindowPtr;
 prop : id.GadgetPtr;
 int  : id.GadgetPtr;
 done : BOOLEAN;
 msg  : id.IntuiMessagePtr;

BEGIN
 w:=il.OpenWindowTagList(NIL,[id.waTitle,ADR("TalkToBoopsi"),
                              id.waFlags,id.WindowFlagSet{id.activate,id.simpleRefresh,
                                           id.rmbTrap,id.windowDrag,id.windowDepth,id.windowClose},
                              id.waIDCMP,id.IDCMPFlagSet{id.closeWindow},
                              id.waWidth, 160,
                              id.waHeight,150,
                              ud.tagDone]);
 IF w#NIL THEN
   prop:=il.NewObjectA(NIL,ADR("propgclass"),[id.gaID,1,id.gaTop,w^.borderTop+5,
                                              id.gaLeft,w^.borderLeft+5,id.gaWidth,10,
                                              id.gaHeight,80,id.icaMap,[id.pgaTop,id.stringaLongVal,0],
                                              id.pgaTotal,100,id.pgaTop,25,id.pgaVisible,10,id.pgaNewLook,LTRUE,0]);
                                              
   IF prop#NIL THEN
     int:=il.NewObjectA(NIL,ADR("strgclass"),[id.gaID,2,id.gaTop,w^.borderTop+5,
                                           id.gaLeft,w^.borderLeft+30,id.gaWidth,40,
                                           id.gaHeight,18,id.icaMap,[id.stringaLongVal,id.pgaTop,0],
                                           id.icaTarget,prop,id.gaPrevious,prop,id.stringaLongVal,25,
                                           id.stringaMaxChars,0]);
     IF int#NIL THEN
        IGNORE il.SetGadgetAttrsA(prop,w,NIL,[id.icaTarget,int,0]);
        IGNORE il.AddGList(w,prop,-1,-1,NIL);
        il.RefreshGList(prop,w,NIL,-1);
        done:=FALSE;
        WHILE ~done DO
          el.WaitPort(w^.userPort);
          msg:=el.GetMsg(w^.userPort);
          WHILE msg#NIL DO
           IF id.closeWindow IN msg^.class THEN done:=TRUE END;
            el.ReplyMsg(msg);
            msg:=el.GetMsg(w^.userPort);
          END;
        END;
        IGNORE il.RemoveGList(w,prop,-1);
        il.DisposeObject(int);
     END;
     il.DisposeObject(prop);
   END;                     
   il.CloseWindow(w);                        
 END;
END TalkToBoopsi.
