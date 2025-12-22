with lists, Ada.Integer_Text_IO, Ada.Text_IO;
use Ada.Integer_Text_IO, Ada.Text_IO;


procedure listtest is
	package list_int is new lists(Integer); use list_int;
begin
	Put_Line("Hello");
end listtest;
