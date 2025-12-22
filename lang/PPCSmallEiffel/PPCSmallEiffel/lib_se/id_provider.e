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
class ID_PROVIDER
   --
   -- Unique object in charge of some id providing.
   --

inherit GLOBALS;

creation make

feature {NONE}

   mem_id: FIXED_ARRAY[INTEGER];

   mem_str: FIXED_ARRAY[STRING];

   modulus: INTEGER;

feature {NONE}

   make is
      do
	 !!mem_id.with_capacity(1024);
	 !!mem_str.with_capacity(1024);
	 modulus := 1000;
	 add2(Void,0); -- (T0)
	 add2(us_general,1);
	 add2(us_integer,2);
	 add2(us_character,3);
	 add2(us_real,4);
	 add2(us_double,5);
	 add2(us_boolean,6);
	 add2(us_string,7);
	 add2(us_pointer,8);
	 add2(us_native_array_character,9);
	 --  Free ID for internal indicators :
	 add2(Void,10);
	 add2(Void,11);
	 add2(Void,12);
	 add2(Void,13);
	 add2(Void,14);
	 add2(Void,15);
	 add2(Void,16);
	 add2(Void,17);
	 add2(Void,18);
	 add2(Void,19);
	 add2(Void,20);
      end;

feature {SMALL_EIFFEL}

   max_id: INTEGER is
      local
	 i: INTEGER;
      do
	 from
	    i := mem_id.upper;
	 until
	    i < 0
	 loop
	    if mem_id.item(i) > Result then
	       Result := mem_id.item(i);
	    end;
	    i := i - 1;
	 end;
      end;
   
feature {BASE_CLASS,RUN_CLASS}

   item(str: STRING): INTEGER is
      require
	 str = unique_string.item(str)
      local
	 index: INTEGER;
      do
	 index := mem_str.fast_index_of(str);
	 if index <= mem_str.upper then
	    Result := mem_id.item(index);
--***	 elseif run_control.boost then
--***	    Result := mem_id.last + 1;
--***	    add2(str,Result);
	 else
	    if mem_str.upper * 2 > modulus then
	       modulus := modulus * 2;
	    end;
	    Result := str.hash_code \\ modulus;
	    if mem_id.fast_has(Result) then
	       from
	       until
		  not mem_id.fast_has(Result)
	       loop
		  Result := (Result + 13) \\ modulus;
	       end;
	       add2(str,Result);
	    else
	       add2(str,Result);
	    end;
	 end;
      end;

feature {NONE}

   add2(str: STRING; id: INTEGER) is
      do
	 mem_str.add_last(str);
	 mem_id.add_last(id);
      end;
   
end -- ID_PROVIDER

