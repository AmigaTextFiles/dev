--          This file is part of SmallEiffel The GNU Eiffel Compiler.
--          Copyright (C) 1994-98 LORIA - UHP - CRIN - INRIA - FRANCE
--            Dominique COLNET and Suzanne COLLIN - colnet@loria.fr 
--                       http://www.loria.fr/SmallEiffel
-- SmallEiffel is  free  software;  you can  redistribute it and/or modify it 
-- under the terms of the GNU General Public License as published by the Free
-- Software  Foundation;  either  version  2, or (at your option)  any  later 
-- version. SmallEiffel is distributed in the hope that it will be useful,but
-- WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
-- or  FITNESS FOR A PARTICULAR PURPOSE.   See the GNU General Public License 
-- for  more  details.  You  should  have  received a copy of the GNU General 
-- Public  License  along  with  SmallEiffel;  see the file COPYING.  If not,
-- write to the  Free Software Foundation, Inc., 59 Temple Place - Suite 330,
-- Boston, MA 02111-1307, USA.
--
class CLASS_NAME_LIST
   
inherit GLOBALS;
   
creation {CLIENT_LIST} merge, make
   
feature {CLASS_NAME_LIST}
   
   list: ARRAY[CLASS_NAME];
   
feature {NONE}
   
   make(l: like list) is
	 -- Note: also check for multiple occurrences of the 
	 -- same name.
      require   
	 l /= Void;
	 not l.empty;
      local
	 i, i2: INTEGER;
      do
	 list := l;
	 from  
	    i := list.upper;
	 until
	    i = 0
	 loop
	    i2 := index_of(list.item(i));
	    check
	       list.item(i2) /= Void 
	    end;
	    if i2 /= i then
	       eh.add_position(list.item(i2).start_position)
	       warning(list.item(i).start_position,
		     "Same Class Name appears twice.");
	    end;
	    i := i - 1;
	 end;
      ensure
	 list = l;
      end;

   merge(l1, l2: like Current) is
      require
	 l1 /= Void;
	 l2 /= Void
      local
	 i: INTEGER;
	 cn: CLASS_NAME;
	 a: ARRAY[CLASS_NAME];
      do
	 list := l1.list.twin;
	 from
	    a := l2.list;
	    i := a.upper;
	 until
	    i = 0
	 loop
	    cn := a.item(i);
	    if not gives_permission_to(cn) then
	       list.add_last(cn);
	    end;
	    i := i - 1;
	 end;
      end;

feature {CLIENT_LIST}

   pretty_print is
      local
	 i: INTEGER;
      do
	 from  
	    i := 1;
	 until
	    i > list.upper
	 loop
	    list.item(i).pretty_print;
	    i := i + 1;
	    if i <= list.upper then
	       fmt.put_string(", ");
	    end;
	 end;
      end;
   
   gives_permission_to(cn: CLASS_NAME): BOOLEAN is
      local
	 i: INTEGER;
      do
	 if index_of(cn) > 0 then
	    Result := true;
	 else
	    from  
	       i := list.upper;
	    until
	       Result or else i = 0
	    loop
	       Result := cn.is_subclass_of(list.item(i));
	       i := i - 1;	       
	    end;
	 end;
      end;

   gives_permission_to_any: BOOLEAN is
      local
	 i: INTEGER;
      do
	 from  
	    i := list.upper;
	 until
	    Result or else i = 0
	 loop
	    Result := list.item(i).to_string = us_any;
	    i := i - 1;	       
	 end;
      end;

feature {NONE}

   index_of(n: CLASS_NAME): INTEGER is
      -- Use `to_string' for comparison.
      -- Gives 0 when `n' is not in the `list'.
      require
	 n /= Void;
      local
	 to_string: STRING;
      do
	 from  
	    to_string := n.to_string;
	    Result := list.upper;
	 until
	    (Result = 0) or else 
	    (to_string = list.item(Result).to_string)
	 loop
	    Result := Result - 1;
	 end;
      ensure
	 0 <= Result;
	 Result <= list.upper;
      end;
   
invariant
   
   list.lower = 1;
   
   not list.empty;
   
end -- CLASS_NAME_LIST

