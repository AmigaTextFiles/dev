
{
      A set of functions especialy created in order to help using strings
   under PCQ Pascal compiler. Those functions complete already existing
   functions of 'StringLib'.

      For noone of the functions you have to allocate memory for the returned
   string because memory is allocated by the functions themself.

      Note that the Str_Copy, Str_Delete and Str_Insert functions came
   from the Borland Turbo Pascal.

      Those functions have been compiled under the 1.2b version of february
   1993. It seems to be no problem using String.Lib with older or newer
   version.
}

{$I "include:utils/stringlib.i"}

type
   Str_List = record
      pos  : integer;
      next : ^Str_List;
   end;

   Str_ListPtr = ^Str_List;



Function Str_Lower(s : string) : string;
External;

{ return string in small letters }

Function Str_Upper(s : string) : string;
External;

{ Return string in capital letter }

Function Str_Copy(s : string;dep,long : integer) : string;
External;

{ Return a string which is a part of the beginning string }

Function Str_Delete(s : string;dep,long : integer) : string;
External;

{ Return a string which is cut }

Function Str_Insert(s,s1 : string;pos : integer) : string;
External;

{ Return a string where s1 is inserted in s }

Function Str_C_Pos(s : string;c : char) : Str_ListPtr;
External;

{ return a linked list whithe each position of c in s, or nil }

Procedure Str_FreeStr_List(p : Str_ListPtr);
External;

{ Free memory allocated by Str_C_Pos. Just give it the address of the first
 element of the list.

  See the Trial_Str_C_Pos prog to have more information to use Str_C_Pos. }