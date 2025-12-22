program gttest;

{

    This is just a small test of gtlayout.library.
    It's from gtlayout.doc.

    No problems so far.
    16 Jul 2000.

    Added MessageBox for report.
    31 Jul 2000.

    nils.sjoholm@mailbox.swipnet.se

}

uses intuition, exec, gadtools, utility, gtlayout, vartags,msgbox;


var
    handle : pLayoutHandle;
    win : pWindow;
    msg : pIntuiMessage;
    msgQuali : ulong;
    msgclass : ulong;
    msgcode : word;
    msggadget : pGadget;
    done : boolean;

procedure CleanUp(why : string; rc : integer);
begin
    LT_DeleteHandle(handle);
    if why <> '' then MessageBox('GTLayout Report',why,'OK');
    halt(rc);
end;

begin
    done := false;
    handle := LT_CreateHandleTagList(nil,TAGS(
                    LAHN_AutoActivate, lfalse,
                    TAG_DONE));
    
    if handle = nil then CleanUp('Could''t create a handle',20);
    
    LT_NewA(handle,TAGS(LA_Type,VERTICAL_KIND,       { A vertical group. }
                        LA_LabelText,longstr('Main Group'),
                        TAG_DONE));

    LT_NewA(handle,TAGS(LA_Type,BUTTON_KIND,         { A plain button. } 
                        LA_LabelText,longstr('A button'),
                        LA_ID,11,
                        TAG_DONE));
    
    LT_NewA(handle,TAGS(LA_Type,XBAR_KIND,TAG_DONE)); { A separator bar. }

    LT_NewA(handle,TAGS(LA_Type,BUTTON_KIND,          { A plain button. }
                        LA_LabelText,longstr('Another button'),
                        LA_ID,22,
                        TAG_DONE));
 
    LT_NewA(handle,TAGS(La_Type,END_KIND,TAG_DONE));  { This ends the current group. } 

    win := LT_BuildA(handle,TAGS(LAWN_Title,longstr('Window title'),
                                 LAWN_IDCMP, IDCMP_CLOSEWINDOW,
                                 WA_CloseGadget, ltrue,
                                 TAG_DONE));

    if win = nil then CleanUp('Can''t open the window',20);
    
    repeat
        msg := pIntuiMessage(WaitPort(win^.UserPort));
        msg := GT_GetIMsg(win^.UserPort);
        while msg <> nil do begin
            msgclass := msg^.IClass;
            msgcode := msg^.Code;
            msgQuali := msg^.Qualifier;
            msggadget := msg^.IAddress;
            GT_ReplyIMsg(msg);
            LT_HandleInput(handle,msgQuali,msgclass,msgcode,msggadget);
            case msgclass of
                 IDCMP_CLOSEWINDOW : done := true;
                 IDCMP_GADGETUP: begin
                                 case msggadget^.GadgetId of
                                      11 : writeln('First gadget');
                                      22 : writeln('Second gadget');
                                 end;
                                 end;
            end;
            msg := GT_GetIMsg(win^.UserPort);
         end;
     until done;
     CleanUp('all ok',0);
end.


