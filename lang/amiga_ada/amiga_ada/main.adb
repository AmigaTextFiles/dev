--with Ada.Text_Io; use Ada.Text_Io;
with amiga; use amiga;
with System; use System;
with Interfaces; use Interfaces;

with Incomplete_Type; use Incomplete_Type;

with intuition_Intuition; use intuition_Intuition;
with graphics_Graphics; use graphics_Graphics;
with graphics_Gfx; use graphics_Gfx;
with graphics_View; use graphics_View;
with exec_Exec; use exec_Exec;

procedure main is

--package int_io is new Ada.Text_Io.Integer_IO(integer); use int_io;
--package int_16_io is new Ada.Text_Io.Integer_IO(integer_16); use int_16_io;

x,y,oldX,oldY : integer;
temp : integer;
Write : Boolean := False;

A_Msg : IntuiMessage_Ptr;
A_NewWindow : NewWindow_Ptr;
A_Window : Window_Ptr;
B_Window : Window_Ptr;
Active_Window : Window_Ptr;

A_Screen : Screen_Ptr;
A_NewScreen : NewScreen_Ptr;

A_WaitMask : Integer;
B_WaitMask : Integer;
ReplyMask  : Integer;

A_Actual_Msg : IntuiMessage;

begin
   if OpenGraphicsLibrary(0) then
      if OpenIntuitionLibrary(0) then
         A_NewScreen := new NewScreen;
         A_NewScreen.LeftEdge  := 0;
         A_NewScreen.TopEdge  := 0;
         A_NewScreen.Width  := 640;
         A_NewScreen.Height := 400;
         A_NewScreen.Depth :=3;
         A_NewScreen.DetailPen :=1;
         A_NewScreen.BlockPen :=2;
         A_NewScreen.ViewModes := HIRES + LACE;
         A_NewScreen.Screen_Type :=CUSTOMSCREEN;
         A_NewScreen.DefaultTitle :=NullChar_Ptr;
         A_NewScreen.Gadgets := NullGadget_Ptr;

         A_Screen := OpenScreen(A_NewScreen);
         if A_Screen = NullScreen_Ptr then
            raise constraint_error;
         end if;

         A_NewWindow := new NewWindow;
         A_NewWindow.LeftEdge := 20;
         A_NewWindow.TopEdge := 20;
         A_NewWindow.Width := 200;
         A_NewWindow.Height := 200;
         A_NewWindow.DetailPen := -1;
         A_NewWindow.BlockPen := -1;
         A_NewWindow.IDCMPFlags := IDCMP_MouseMove + IDCMP_CloseWindow + IDCMP_ActiveWindow + IDCMP_InActiveWindow + IDCMP_MouseButtons + IDCMP_NEWSIZE;
         A_NewWindow.Flags := WFLG_DEPTHGADGET + WFLG_DRAGBAR + WFLG_SMART_REFRESH + WFLG_ACTIVATE + WFLG_CLOSEGADGET + WFLG_REPORTMOUSE + WFLG_SIZEGADGET;
         A_NewWindow.FirstGadget := NullGadget_Ptr;
         A_NewWindow.CheckMark := NullImage_Ptr;
         A_NewWindow.Owner_Screen := NullScreen_Ptr;
         A_NewWindow.Window_Bitmap := NullBitMap_Ptr;
         A_NewWindow.Title := NullChar_Ptr;
         A_NewWindow.MinWidth := 50;
         A_NewWindow.MinHeight := 50;
         A_NewWindow.MaxWidth := 400;
         A_NewWindow.MaxHeight := 400;
         A_NewWindow.Screen_Type := WBENCHSCREEN;

         A_Window := OpenWindow( A_NewWindow );

         A_NewWindow.Screen_Type := CUSTOMSCREEN;
         A_NewWindow.Owner_Screen := A_Screen;
         A_NewWindow.LeftEdge := 40;
         A_NewWindow.TopEdge := 40;


         B_Window := OpenWindow( A_NewWindow );

--         A_Window := Ada_OpenWindow(20,20,200,200, 
--            IDCMP_MouseMove + IDCMP_CloseWindow + IDCMP_ActiveWindow + IDCMP_InActiveWindow + IDCMP_MouseButtons + IDCMP_NEWSIZE,
--            WFLG_DEPTHGADGET + WFLG_DRAGBAR + WFLG_SMART_REFRESH + WFLG_ACTIVATE + WFLG_CLOSEGADGET + WFLG_REPORTMOUSE + WFLG_SIZEGADGET);
--         B_Window := Ada_OpenWindow(40,40,200,200, 
--            IDCMP_MouseMove + IDCMP_CloseWindow + IDCMP_ActiveWindow + IDCMP_InActiveWindow + IDCMP_MouseButtons + IDCMP_NEWSIZE,
--            WFLG_DEPTHGADGET + WFLG_DRAGBAR + WFLG_SMART_REFRESH + WFLG_ACTIVATE + WFLG_CLOSEGADGET + WFLG_REPORTMOUSE + WFLG_SIZEGADGET);

            A_WaitMask := 2**Integer(A_Window.all.UserPort.all.mp_SigBit);
            B_WaitMask := 2**Integer(B_Window.UserPort.mp_SigBit);
--            Active_Window := WaitForMessage(A_WaitMask + B_WaitMask,A_Window,B_Window);
            ReplyMask := Wait(A_WaitMask + B_WaitMask);
            if ReplyMask = A_WaitMask then
              Active_Window := A_Window;
            else
              Active_Window := B_Window;
            end if;

            A_Msg := GetMsg(Active_Window.UserPort);

            while A_Msg.Class /= IDCMP_CloseWindow loop
               if A_Msg.Class = IDCMP_ActiveWindow then
                  if Active_Window = A_Window then
                     NULL;
--                     put_line("A Active");
                  else
                     NULL;
--                     put_line("B Active");
                  end if;
               elsif A_Msg.Class = IDCMP_InActiveWindow then
                  if Active_Window = A_Window then
                       NULL;
--                     put_line("A InActive");
                  else
                       NULL;
--                     put_line("B InActive");
                 end if;
               elsif A_Msg.Class = IDCMP_MouseMove then
                  if Write then
                     if Active_Window = A_Window then
                        temp := WritePixel(Active_Window.RPort,Integer(A_Msg.MouseX),Integer(A_Msg.MouseY));
                     else
                        Move(Active_Window.RPort,oldX,oldY);
                        Draw(Active_Window.RPort,Integer(A_Msg.MouseX),Integer(A_Msg.MouseY));
                     end if;
                  end if;
               elsif A_Msg.Class = IDCMP_MouseButtons then
-- if A_Msg.Code = SelectUp then
                  if Write then
			Write := False;
                  else
                        Write := True;
			oldX := Integer(A_Msg.MouseX);
			oldY := Integer(A_Msg.MouseY);
                  end if;
               elsif A_Msg.Class = IDCMP_NewSize then
                  Null;
--		  put("NewSize X,Y =>");put(A_Msg.IDCMPWindow.Width);put(A_Msg.IDCMPWindow.Height);New_Line;
--		  put("NewSize X,Y =>");put(Active_Window.Width);put(Active_Window.Height);New_Line;
               else
                  NULL;
--                  Put_Line("Unhandled Message Type");
               end if;

--               put_line("Past Big if then else");
               ReplyMsg(A_Msg);
--               put_line("replied message");
               A_Msg := GetMsg(Active_Window.UserPort);
--               put_line("got a new message");

               if A_Msg = NullIntuiMessage_Ptr then
--                  put_line("before wait");
                  ReplyMask := Wait(A_WaitMask + B_WaitMask);
--                  put_line("after wait");
                  if ReplyMask = A_WaitMask then
                    Active_Window := A_Window;
                  else
                    Active_Window := B_Window;
                  end if;
                  A_Msg := GetMsg(Active_Window.UserPort);
                  while A_Msg = NullIntuiMessage_Ptr loop
                      A_Msg := GetMsg(A_Window.UserPort);
                      if A_Msg = NullIntuiMessage_Ptr then
                         A_Msg := GetMsg(B_Window.UserPort);
                         Active_Window := B_Window;
                      else
                         Active_Window := A_Window;
                      end if;
--put('.');
                  end loop;
               end if;
--put_line("after class /= 0 if then ..") ;
            end loop;   

            CloseWindow( A_Window );
            CloseWindow( B_Window );
            if CloseScreen( A_Screen ) then NULL; end if;
            CloseIntuitionLibrary;
      end if;
   CloseGraphicsLibrary;
   end if;
end main;


