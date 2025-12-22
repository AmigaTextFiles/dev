with Ada.Text_IO; use Ada.Text_IO;

package body Matrix is

--package Float_IO is new Ada.Text_IO.Float_IO(float); use Float_IO;
--package Int_IO is new Ada.Text_IO.Integer_IO(integer); use Int_IO;


function "+"(left : matrix_type; right : matrix_type) return matrix_type is

return_matrix : matrix_type(left.h,left.v);

begin

if left.v /= right.v and left.h /= right.h then
   raise constraint_error;
end if;

for i in 1 .. left.v loop
   for j in 1 .. left.h loop
      return_matrix.data(i,j) := left.data(i,j) + right.data(i,j);
   end loop;
end loop;

return_matrix.h := left.h;
return_matrix.v := left.v;

return return_matrix;

end "+";

function "-"(left : matrix_type) return matrix_type is
return_matrix : matrix_type(left.h,left.v);
begin

for i in 1 .. left.v loop
   for j in 1 .. left.h loop
      return_matrix.data(i,j) := -left.data(i,j);
   end loop;
end loop;

return_matrix.h := left.h;
return_matrix.v := left.v;

return return_matrix;
end "-";

function "-"(left : matrix_type; right : matrix_type) return matrix_type is
begin
return left + (-right);

end "-";

function "*"(left : matrix_type; right : matrix_type) return matrix_type is

return_matrix : matrix_type(left.h,right.v);
begin

--put_line("in timess");
--put(left);put(right);
if left.v /= right.h then
   raise constraint_error;
end if;

--put_line("after my ce");

for i in 1 .. left.h loop
   for j in 1 .. right.v loop
      return_matrix.data(i,j) := 0.0;
      for k in 1 .. left.v loop
         return_matrix.data(i,j) := return_matrix.data(i,j) + left.data(i,k) * right.data(k,j);
      end loop;
   end loop;
end loop;

return_matrix.h := left.h;
return_matrix.v := right.v;

return return_matrix;

end "*";

function "*"(left : Element_Type; right : matrix_type) return matrix_type is

return_matrix : matrix_type(right.h,right.v);
begin

for i in 1 .. right.v loop
   for j in 1 .. right.h loop
      return_matrix.data(j,i) := left * right.data(j,i);
   end loop;
end loop;

return_matrix.h := right.h;
return_matrix.v := right.v;

return return_matrix;

end "*";


function "*"(left : matrix_type; right : Element_Type) return matrix_type is

return_matrix : matrix_type(left.h,left.v);
begin
for i in 1 .. left.v loop
   for j in 1 .. left.h loop
      return_matrix.data(j,i) := right * left.data(j,i);
   end loop;
end loop;

return_matrix.h := left.h;
return_matrix.v := left.v;

return return_matrix;

end "*";

function "="(left : matrix_type; right : matrix_type ) return boolean is
begin
if left.v /= right.v and then left.h /= right.h then
   return FALSE;
end if;

for i in 1 .. left.v loop
   for j in 1 .. right.h loop
      if left.data(i,j) /= right.data(j,i) then
         return FALSE;
      end if;
   end loop;
end loop;

return TRUE;

end "=";

procedure Assign(left : in out matrix_type; right : in matrix_type ) is
begin
if left.v /= right.v and then left.h /= right.h then
   raise constraint_error;
end if;

for i in 1 .. left.v loop
   for j in 1 .. right.h loop
      left.data(j,i) := right.data(j,i);
   end loop;
end loop;

left.h := right.h;
left.v := right.h;

end Assign;

procedure SetMember ( left : in out matrix_type; h,v : in Integer; right : in Element_Type ) is
begin
   left.data(h,v) := right;
end SetMember;

function GetMember ( left : in matrix_type; h,v : in Integer) return Element_Type is
begin
   return left.data(h,v);
end GetMember;

function Get_Horizontal ( left : in matrix_type) return Integer is
begin
   return left.h;
end Get_Horizontal;


function Get_Vertical ( left : in matrix_type) return Integer is
begin
   return left.v;
end Get_Vertical;


function NewMatrix(h,v : Integer; data : data_type) return matrix_type is

return_matrix : matrix_type(h,v);

begin
return_matrix.h := h;
return_matrix.v := v;

for i in 1 .. h loop
   for j in 1 .. v loop
      SetMember(return_matrix,i,j,data(i,j));
   end loop;
end loop;

return return_matrix;

end NewMatrix;

--procedure put(left : in matrix_type) is
--begin
--for i in 1 .. left.v loop
--   for j in 1 .. left.h loop
--      put(GetMember(left,j,i));
--   end loop;
--   new_line;
--end loop;
--
--end put;

end matrix;