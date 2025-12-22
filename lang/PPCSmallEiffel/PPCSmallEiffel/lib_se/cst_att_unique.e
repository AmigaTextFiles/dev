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
class CST_ATT_UNIQUE
--   
-- For "unique" constant attribute.
--

inherit CST_ATT redefine pretty_tail end;
   
creation {ANY}
   make
   
feature {ANY} 
   
   value(i: INTEGER): INTEGER_CONSTANT is
      do
	 Result := values.item(i);
      end;
   
   values: ARRAY[INTEGER_CONSTANT];
   
   make(n: like names; t: like result_type) is
      require
	 n /= Void;
	 t.is_integer;
      local
	 i: INTEGER;
	 ic: INTEGER_CONSTANT;
      do
	 make_e_feature(n,t);
	 !!values.make(1,names.count);
	 from  
	    i := 1;
	 until
	    i > values.upper
	 loop
	    !!ic.make(small_eiffel.next_unique,Void);
	    values.put(ic,i);
	    i := i + 1;
	 end;
      end;
   
feature {NONE}
   
   pretty_tail is
      do
	 fmt.put_string(" is unique");
      end;      
   
end -- CST_ATT_UNIQUE

