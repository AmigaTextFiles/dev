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
class RUN_REQUIRE
   -- 
   -- A RUN_REQUIRE is composed with all inherited E_REQUIRE.
   --
   
inherit GLOBALS;
   
creation make
   
feature {NONE}
   
   list: ARRAY[E_REQUIRE];
	 -- From bottom to the top of the inheritance graph.
	 -- Order is important because one at least must be true 
	 -- following bottom up order.
	 
feature

   make(l: like list) is
      require
	 l.lower = 1;
	 l.upper >= 1;
      do
	 list := l;
      ensure
	 list = l;
      end;

feature

   short is
      local
	 i: INTEGER;
      do
	 from
	    list.item(1).short("hook401","      require%N");
	    i := 2;
	 until
	    i > list.upper
	 loop
	    list.item(i).short("hook402","      require else %N");
	    i := i + 1;
	 end;
	 short_print.hook("hook403");
      end;

   use_current: BOOLEAN is
      local
	 i: INTEGER;
      do
	 from  
	    i := 1;
	 until
	    Result or else i > list.upper
	 loop
	    Result := list.item(i).use_current;
	    i := i + 1;
	 end;
      end;
   
   afd_check is
      local
	 i: INTEGER;
      do
	 from
	    i := list.upper;
	 until
	    i = 0
	 loop
	    list.item(i).afd_check;
	    i := i - 1;
	 end;
      end;

   compile_to_c is
      local
	 i: INTEGER;
      do
	 if run_control.require_check then
	    if list.upper = 1 then
	       cpp.put_string("se_af_rlc=1;%N")
	       list.first.compile_to_c;
	    else
	       cpp.put_string("se_af_rlc=0;%N")
	       cpp.put_string("se_af_rlr=1;%N")
	       list.first.compile_to_c; -- ****** 2 fois de suite ??? ****
	       from  
		  i := 1;
	       until
		  i > list.upper
	       loop
		  cpp.put_string("if(!se_af_rlr){se_af_rlr=1;%N")
		  list.item(i).compile_to_c;
		  cpp.put_string(fz_12)
		  i := i + 1;
		  if i = list.upper then
		     cpp.put_string("se_af_rlc=1;%N")
		  end;
	       end;
	    end;
	 end;
      end;

   compile_to_jvm is
      local
	 i: INTEGER;
	 ca: like code_attribute;
      do
	 if run_control.require_check then
	    ca := code_attribute;
	    if list.upper = 1 then
	       list.first.compile_to_jvm(true);
	    else
	       points1.clear;
	       from  
		  i := 1;
	       until
		  i > (list.upper - 1)
	       loop
		  list.item(i).compile_to_jvm(false);
		  points1.add_last(ca.opcode_ifne);
		  i := i + 1;
	       end;
	       list.item(i).compile_to_jvm(true);
	       ca.resolve_with(points1);
	    end;
	 end;
      end;

feature {NONE}

   points1: FIXED_ARRAY[INTEGER] is
	 -- To reach the sucessful code.
      once
	 !!Result.with_capacity(4);
      end;
   
invariant
   
   list.lower = 1;
   
   not list.empty;
   
end -- RUN_REQUIRE

