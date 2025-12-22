with System;
with Unchecked_Conversion;

with incomplete_type; use incomplete_type;

package body intuition_classusr is

function NewMsg return Msg is

return_Msg : Msg;

begin
   return_Msg.MsgData := new MsgData_Type(1..10);
   return_Msg.MsgAddress := return_Msg.MsgData(1)'Address;
   return_Msg.Size := 10;
   for i in 1 .. return_Msg.Size loop
      return_Msg.MsgData(i) := 0;
   end loop;

return return_Msg;
end NewMsg;

procedure NewAddMsg ( A_Msg : in out Msg; data : in MsgDataType ) is
begin
   AddMsg( A_Msg, to_Unsigned_32(data));
end NewAddMsg;

procedure AddMsg( A_Msg : in out Msg; data : Unsigned_32) is

i : Integer := 1;
temp : MsgData_Ptr;

begin

while A_Msg.MsgData(i) /= 0 and i < A_Msg.Size loop
    i := i+ 1;
end loop;

if i=A_Msg.Size then
   temp := new MsgData_Type(1..A_Msg.Size * 2);
   for j in 1 .. A_Msg.Size - 1 loop
      temp(j) := A_Msg.MsgData(j);
   end loop;
   for j in A_Msg.Size  .. A_Msg.Size * 2 loop
      A_Msg.MsgData(j) := 0;
   end loop;

   A_Msg.Size := A_Msg.Size * 2;
   A_Msg.MsgData := temp;
   A_Msg.MsgAddress := A_Msg.MsgData(1)'Address;
end if;

A_Msg.MsgData(i) := data;

end AddMsg;

procedure AddMsg( A_Msg : in out Msg; data : System.Address) is
function to_Unsigned_32 is new Unchecked_Conversion(System.Address,Unsigned_32);
begin

   AddMsg(A_Msg, to_Unsigned_32(data));
end AddMsg;

procedure AddMsg( A_Msg : in out Msg; data : Boolean) is
begin
   if data then
      AddMsg(A_Msg, Unsigned_32(1));
   else
      AddMsg(A_Msg, Unsigned_32(0));
   end if;
end AddMsg;

procedure AddMsg( A_Msg : in out Msg; data : Unsigned_32_Ptr) is
function to_Unsigned_32 is new Unchecked_Conversion(Unsigned_32_Ptr,Unsigned_32);
begin
   AddMsg(A_Msg, to_Unsigned_32(data));
end AddMsg;

procedure AddMsg( A_Msg : in out Msg; data : Chars_Ptr) is
function to_Unsigned_32 is new Unchecked_Conversion(Chars_Ptr,Unsigned_32);
begin
   AddMsg(A_Msg, to_Unsigned_32(data));
end AddMsg;

procedure AddMsg( A_Msg : in out Msg; data : Character) is
begin
   AddMsg(A_Msg, Unsigned_32(Character'POS(data)));
end AddMsg;

procedure AddMsg( A_Msg : in out Msg; data : Integer) is
begin
   AddMsg(A_Msg, Unsigned_32(data));
end AddMsg;

procedure ClearMsg( A_Msg : in out Msg ) is
begin
   for i in 1 .. A_Msg.Size loop
      A_Msg.MsgData(i) := 0;
   end loop;
end ClearMsg;

end intuition_classusr;
