with System; use System;
with Text_IO; use Text_IO;
with Interfaces; use Interfaces;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

with Incomplete_Type; use Incomplete_Type;

with amiga; use amiga;
with intuition_Intuition; use intuition_Intuition;
with graphics_Graphics; use graphics_Graphics;
with graphics_Gfx; use graphics_Gfx;
with graphics_View; use graphics_View;
with exec_Exec; use exec_Exec;
with utility_TagItem; use utility_TagItem;

with matrix;

procedure cube2 is

--package int_io is new Ada.Text_Io.Integer_IO(integer); use int_io;
--package int_16_io is new Ada.Text_Io.Integer_IO(integer_16); use int_16_io;

package new_matrix is new matrix(Float); use new_matrix;

x,y,oldX,oldY : integer;
temp : integer;
Write : Boolean := False;

A_Msg : IntuiMessage_Ptr;
A_NewWindow : NewWindow_Ptr;
A_Window : Window_Ptr;
B_Window : Window_Ptr;
Active_Window : Window_Ptr;

A_Screen_Ptr : Screen_Ptr;
A_NewScreen_Ptr : NewScreen_Ptr;

Screen_Title : constant String := "An Ada Screen" & ASCII.NUL;

A_Screen_Tags : constant TagItem_Array := (
                                            1 =>(ti_Tag => SA_Left, ti_Data =>0),
                                            2 =>(ti_Tag => SA_Top, ti_Data =>0),
                                            3 =>(ti_Tag => SA_Width, ti_Data =>640),
                                            4 =>(ti_Tag => SA_Height, ti_Data =>400),
                                            5 =>(ti_Tag => SA_Depth, ti_Data =>3),
                                            6 =>(ti_Tag => SA_DetailPen, ti_Data =>1),
                                            7 =>(ti_Tag => SA_BlockPen, ti_Data =>2),
                                            8 =>(ti_Tag => SA_DisplayID, ti_Data =>Unsigned_32(HIRES + LACE)),
                                            9 =>(ti_Tag => SA_type, ti_Data =>Unsigned_32(CUSTOMSCREEN)),
                                            10 =>(ti_Tag => SA_Title, ti_Data =>to_Unsigned_32(Screen_Title'Address)),
                                            11 =>(ti_Tag => SA_ShowTitle, ti_Data => 1 ),
                                            12 =>(ti_Tag => TAG_DONE, ti_Data =>0)
                                          );
A_Screen_Tags_Ptr : TagItem_Ptr := to_TagItem_Ptr(A_Screen_Tags(1)'Address);

A_Window_Title : constant String := "An Ada Window" & ASCII.NUL;

A_Window_Tags : TagItem_Array(1..12) := (
                                    1 => ( ti_Tag => WA_Left , ti_Data => 20),
                                    2 => ( ti_Tag => WA_Top , ti_Data => 20),
                                    3 => ( ti_Tag => WA_Width , ti_Data => 300),
                                    4 => ( ti_Tag => WA_Height , ti_Data => 300),
                                    5 => ( ti_Tag => WA_IDCMP , ti_Data => 
                                              IDCMP_MouseMove + IDCMP_CloseWindow + 
                                              IDCMP_ActiveWindow + IDCMP_InActiveWindow + 
                                              IDCMP_MouseButtons + IDCMP_NEWSIZE + IDCMP_IntuiTicks),
                                    6 => ( ti_Tag => WA_Flags , ti_Data => 
                                              WFLG_DEPTHGADGET + WFLG_DRAGBAR + WFLG_SMART_REFRESH + 
                                              WFLG_ACTIVATE + WFLG_CLOSEGADGET + WFLG_REPORTMOUSE + 
                                              WFLG_SIZEGADGET),
                                    7 => ( ti_Tag => WA_Title  , ti_Data => to_Unsigned_32(A_Window_Title'Address)),
                                    8 => ( ti_Tag => WA_MinWidth , ti_Data => 50),
                                    9 => ( ti_Tag => WA_MinHeight , ti_Data => 50),
                                    10 => ( ti_Tag => WA_WBenchWindow , ti_Data => 1),
                                    11 => ( ti_Tag => TAG_SKIP, ti_Data => 0),
                                    12 => ( ti_Tag => TAG_DONE , ti_Data => 0));

A_Window_Tags_Ptr : TagItem_Ptr := to_TagItem_Ptr(A_Window_Tags(1)'Address);

B_Window_Title : constant String := "An Ada Window, part 2" & ASCII.NUL;

B_Window_Tags : TagItem_Array(1..12) := (
                                    1 => ( ti_Tag => WA_Left , ti_Data => 20),
                                    2 => ( ti_Tag => WA_Top , ti_Data => 20),
                                    3 => ( ti_Tag => WA_Width , ti_Data => 300),
                                    4 => ( ti_Tag => WA_Height , ti_Data => 300),
                                    5 => ( ti_Tag => WA_IDCMP , ti_Data => 
                                              IDCMP_MouseMove + IDCMP_CloseWindow + 
                                              IDCMP_ActiveWindow + IDCMP_InActiveWindow + 
                                              IDCMP_MouseButtons + IDCMP_NEWSIZE + IDCMP_IntuiTicks),
                                    6 => ( ti_Tag => WA_Flags , ti_Data => 
                                              WFLG_DEPTHGADGET + WFLG_DRAGBAR + WFLG_SMART_REFRESH + 
                                              WFLG_ACTIVATE + WFLG_CLOSEGADGET + WFLG_REPORTMOUSE + 
                                              WFLG_SIZEGADGET),
                                    7 => ( ti_Tag => WA_Title  , ti_Data => to_Unsigned_32(B_Window_Title'Address)),
                                    8 => ( ti_Tag => WA_MinWidth , ti_Data => 50),
                                    9 => ( ti_Tag => WA_MinHeight , ti_Data => 50),
                                    10 => ( ti_Tag => TAG_SKIP, ti_Data => 0),
                                    11 => ( ti_Tag => TAG_SKIP, ti_Data => 0),
                                    12 => ( ti_Tag => TAG_DONE , ti_Data => 0));

B_Window_Tags_Ptr : TagItem_Ptr := to_TagItem_Ptr(B_Window_Tags(1)'Address);

A_WaitMask : Integer;
B_WaitMask : Integer;
ReplyMask  : Integer;


tran_3d_to_2d : matrix_type(4,4);
scale : matrix_type(4,4);
rot_x : matrix_type(4,4);
rot_y : matrix_type(4,4);
rot_z : matrix_type(4,4);
trans_matrix : matrix_type(4,4);

result_matrix_1 : matrix_type(4,4);
result_matrix_2 : matrix_type(4,4);

subtype point is matrix_type(1,4);

temp_a : point;
temp_b : point;

type line is record
   start : point;
   finish   : point;
end record;

temp_line : line;

the_cube : array(1..18) of line;

cube_temp : constant array(1..108) of float :=
 (0.0,0.0,0.0, 0.0,0.0,1.0, 0.0,0.0,0.0, 0.0,1.0,1.0, 0.0,0.0,0.0, 0.0,1.0,0.0, 0.0,0.0,1.0, 0.0,1.0,1.0, 0.0,1.0,1.0, 0.0,1.0,0.0,
  1.0,0.0,0.0, 1.0,0.0,1.0, 1.0,0.0,0.0, 1.0,1.0,1.0, 1.0,0.0,0.0, 1.0,1.0,0.0, 1.0,0.0,1.0, 1.0,1.0,1.0, 1.0,1.0,1.0, 1.0,1.0,0.0,
  0.0,0.0,0.0, 1.0,0.0,0.0, 0.0,1.0,0.0, 1.0,1.0,0.0, 0.0,1.0,1.0, 1.0,1.0,1.0, 0.0,0.0,1.0, 1.0,0.0,1.0, 0.0,0.0,0.0, 1.0,1.0,0.0,
  1.0,1.0,0.0, 0.0,1.0,1.0, 0.0,1.0,1.0, 1.0,0.0,1.0, 1.0,0.0,1.0, 0.0,0.0,0.0 );

rotx : float := 0.0;
roty : float := 0.0;
rotz : float := 0.0;
scale_x : float := 45.0;
scale_y : float := 45.0;
scale_z : float := 45.0;
distance : float := 45.0;

A_Actual_Msg : IntuiMessage;

procedure clear_matrix(a_matrix : in out matrix_type ) is
begin

for i in 1 .. get_horizontal(a_matrix) loop
   for j in 1 .. get_vertical(a_matrix) loop
      setmember(a_matrix,i,j,0.0);
   end loop;
end loop;
end clear_matrix;

procedure draw_line(a_window : Window_Ptr;  start : matrix_type; finish : matrix_type ) is

temp_a : matrix_type(1,4);
temp_b : matrix_type(1,4);

begin

--put_line("start/finish");
--put(start);put(finish);

temp_a := start * ((getmember(start,1,3)+distance)/distance);
temp_b := finish * ((getmember(finish,1,3)+distance)/distance);

--put_line("temps");
--put(temp_a);put(temp_b);

Move(a_window.RPort,integer(getmember(temp_a,1,1))+integer(a_window.width/2),integer(getmember(temp_a,1,2))+integer(a_window.height/2));
Draw(a_window.RPort,integer(getmember(temp_b,1,1))+integer(a_window.width/2),integer(getmember(temp_b,1,2))+integer(a_window.height/2));

end draw_line;


begin

for i in 0..108/6-1 loop
   setmember(temp_a,1,1,cube_temp(i*6+1));
   setmember(temp_a,1,2,cube_temp(i*6+2));
   setmember(temp_a,1,3,cube_temp(i*6+3));
   setmember(temp_a,1,4,1.0);
   setmember(temp_b,1,1,cube_temp(i*6+4));
   setmember(temp_b,1,2,cube_temp(i*6+5));
   setmember(temp_b,1,3,cube_temp(i*6+6));
   setmember(temp_b,1,4,1.0);
   temp_line.start := temp_a;
   temp_line.finish := temp_b;
   the_cube(i+1) := temp_line;
end loop;

clear_matrix(tran_3d_to_2d);
setmember(tran_3d_to_2d,1,1,1.0);
setmember(tran_3d_to_2d,2,2,1.0);
setmember(tran_3d_to_2d,3,3,1.0);
setmember(tran_3d_to_2d,3,4,1.0/distance);

   if OpenGraphicsLibrary(0) then
      if OpenIntuitionLibrary(0) then
          A_Screen_Ptr := OpenScreenTagList(A_NewScreen_Ptr,A_Screen_Tags_Ptr);
         if A_Screen_Ptr = NullScreen_Ptr then
            raise constraint_error;
         end if;

         A_Window := OpenWindowTagList( A_NewWindow, A_Window_Tags_Ptr );

         B_Window_Tags(10) := ( ti_Tag => WA_CustomScreen, ti_Data => to_Unsigned_32(A_Screen_Ptr));
         B_Window := OpenWindowTagList( A_NewWindow, B_Window_Tags_Ptr );

         A_WaitMask := 2**Integer(A_Window.all.UserPort.all.mp_SigBit);
         B_WaitMask := 2**Integer(B_Window.UserPort.mp_SigBit);
         ReplyMask := Wait(A_WaitMask + B_WaitMask);
         if ReplyMask = A_WaitMask then
            Active_Window := A_Window;
         else
              Active_Window := B_Window;
         end if;

            A_Msg := GetMsg(Active_Window.UserPort);

            while A_Msg.Class /= IDCMP_CloseWindow loop
               rotx := rotx + 0.04;
               roty := roty + 0.04;
               rotz := rotz + 0.04;

               clear_matrix(scale);
               clear_matrix(rot_x);
               clear_matrix(rot_y);
               clear_matrix(rot_z);

               setmember(scale,1,1,scale_x);
               setmember(scale,2,2,scale_y);
               setmember(scale,3,3,scale_z);
               setmember(scale,4,4,1.0);

               setmember(rot_x,2,2,cos(rotx));
               setmember(rot_x,2,3,-sin(rotx));
               setmember(rot_x,3,2,sin(rotx));
               setmember(rot_x,3,3,cos(rotx));
               setmember(rot_x,4,4,1.0);
               setmember(rot_x,1,1,1.0);

               setmember(rot_y,1,1,cos(roty));
               setmember(rot_y,1,3,sin(roty));
               setmember(rot_y,3,1,-sin(roty));
               setmember(rot_y,3,3,cos(roty));
               setmember(rot_y,2,2,1.0);
               setmember(rot_y,4,4,1.0);

               setmember(rot_z,1,1,cos(rotz));
               setmember(rot_z,1,2,-sin(rotz));
               setmember(rot_z,2,1,sin(rotz));
               setmember(rot_z,2,2,cos(rotz));
               setmember(rot_z,3,3,1.0);
               setmember(rot_z,4,4,1.0);

               trans_matrix := (scale * (rot_x * rot_y * rot_z));

               for i in 1..18 loop
                  result_matrix_1 := the_cube(i).start * trans_matrix;
                  result_matrix_2 := the_cube(i).finish * trans_matrix;
                  draw_line( active_window, result_matrix_1, result_matrix_2);
               end loop;

               SetAPen(a_window.RPort,0);
               SetAPen(b_window.RPort,0);

               for i in 1..18 loop
                  result_matrix_1 := the_cube(i).start * trans_matrix;
                  result_matrix_2 := the_cube(i).finish * trans_matrix;
                  draw_line( active_window, result_matrix_1, result_matrix_2);
               end loop;


               SetAPen(a_window.RPort,1);
               SetAPen(b_window.RPort,1);

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
                  NULL;
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

               ReplyMsg(A_Msg);
               A_Msg := GetMsg(Active_Window.UserPort);

               if A_Msg = NullIntuiMessage_Ptr then
                  ReplyMask := Wait(A_WaitMask + B_WaitMask);
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
            if CloseScreen( A_Screen_Ptr ) then NULL; end if;
            CloseIntuitionLibrary;
      end if;
   CloseGraphicsLibrary;
   end if;
end cube2;
