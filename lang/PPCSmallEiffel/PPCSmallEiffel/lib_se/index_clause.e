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
class INDEX_CLAUSE
   --   
   --

inherit GLOBALS;

creation {EIFFEL_PARSER} make
         
feature 
   
   index: STRING;
   
feature {NONE}
   
   list: ARRAY[EXPRESSION];
   
feature {NONE}
   
   make(i: like index) is
      require
	 i /= Void;
      do
	 index := i;
      ensure
	 index = i;
      end;

feature
   
   isa_index_value(value: EXPRESSION): BOOLEAN is
      local
	 sfn: SIMPLE_FEATURE_NAME;
	 ms: MANIFEST_STRING;
	 btc: BASE_TYPE_CONSTANT;
      do
	 sfn ?= value;
	 ms ?= value;
	 btc ?= value;
	 Result := (sfn/= Void) or else (ms /= Void) or else (btc /= Void);
      end;

   pretty_print is
      local
	 i: INTEGER;
      do
	 if index /= void then
	    fmt.put_string(index);
	    fmt.put_string(": ");
	 end;
	 if list /= Void then
	    fmt.level_incr;
	    from  
	       i := list.lower;
	    until
	       i > list.upper
	    loop
	       list.item(i).pretty_print;
	       i := i + 1;
	       if i <= list.upper then
		  fmt.put_string(", ");
	       end;
	    end;
	    fmt.level_decr;
	 end;
      end;
   
feature {EIFFEL_PARSER}   
   
   add_index_value(value: EXPRESSION) is
      require
	 isa_index_value(value);
      do
	 if list = Void then
	    list := <<value>>;
	 else
	    list.add_last(value);
	 end;
      end;
   
invariant
   
   index /= Void;
   
end -- INDEX_CLAUSE

