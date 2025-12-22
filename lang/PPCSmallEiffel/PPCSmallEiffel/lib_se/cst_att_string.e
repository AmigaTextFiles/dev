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
class CST_ATT_STRING
   
inherit CST_ATT redefine value end;
   
creation {ANY}
   make
   
feature {ANY}
   
   value(i: INTEGER): MANIFEST_STRING is
      do
	 Result := values.item(i);
      end;
   
   values: ARRAY[MANIFEST_STRING];
   
   make(n: like names; t: like result_type; v: like value) is
      require
	 n /= Void;
	 t /= Void;
	 v.current_type = Void;
      local
	 i: INTEGER;
	 ms: MANIFEST_STRING;
      do
	 make_e_feature(n,t);
	 !!values.make(1,names.count);
	 values.put(v,1);
	 from  
	    i := 2;
	 until
	    i > values.upper
	 loop
	    !!ms.from_manifest_string(v,i);
	    values.put(ms,i);
	    i := i + 1;
	 end;
      ensure
	 names = n;
	 result_type = t;
      end;

end -- CST_ATT_STRING

