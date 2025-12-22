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
class CLASS_INVARIANT
   --
   -- To store a `class invariant'.
   --
   
inherit ASSERTION_LIST redefine pretty_print end;
         
creation {ANY}
   make, from_runnable

feature {ANY}
   
   name: STRING is
      do
	 Result := fz_invariant;
      end;
   
   pretty_print is
      local
	 i: INTEGER;
      do
	 fmt.set_indent_level(0);
	 if not fmt.zen_mode then
	    fmt.skip(1);
	 end;
	 fmt.keyword(name);
	 if header_comment /= Void then
	    header_comment.pretty_print;
	 end;
	 if list /= Void then
	    from  
	       i := 1;
	    until
	       i > list.upper		  
	    loop
	       fmt.set_indent_level(1);
	       fmt.indent;
	       if not fmt.zen_mode then
		  fmt.skip(1);
	       end;
	       fmt.set_semi_colon_flag(true);
	       list.item(i).pretty_print;
	       i := i + 1;
	    end;
	 end;
      end;

   short(bc: BASE_CLASS) is
      local
	 i: INTEGER;
      do
	 bc.header_comment_for(Current);
	 short_print.hook_or("hook811","invariant%N");
	 if header_comment = Void then
	    short_print.hook_or("hook812","");
	 else
	    short_print.hook_or("hook813","");
	    header_comment.short("hook814","   -- ","hook815","%N");
	    short_print.hook_or("hook816","");
	 end;
	 if list = Void then
	    short_print.hook_or("hook817","");
	 else
	    short_print.hook_or("hook818","");
	    from  
	       i := 1;
	    until
	       i = list.upper		  
	    loop
	       list.item(i).short("hook819","   ", -- before each assertion
				  "hook820","", -- no tag
				  "hook821","", -- before tag
				  "hook822",": ", -- after tag
				  "hook823","", -- no expression
				  "hook824","", -- before expression
				  "hook825",";", -- after expression except last
				  "hook826","%N", -- no comment
				  "hook827","", -- before comment
				  "hook828"," -- ", -- comment begin line
				  "hook829","%N", -- comment end of line
				  "hook830","", -- after comment
				  "hook831",""); -- end of each assertion

	       i := i + 1;
	    end;
	    list.item(i).short("hook819","   ", -- before each assertion
			       "hook820","", -- no tag
			       "hook821","", -- before tag
			       "hook822",": ", -- after tag
			       "hook823","", -- no expression
			       "hook824","", -- before expression
			       "hook832",";", -- after last expression
			       "hook826","%N", -- no comment
			       "hook827","", -- before comment
			       "hook828"," -- ", -- comment begin line
			       "hook829","%N", -- comment end of line
			       "hook830","", -- after comment
			       "hook831","");
	    short_print.hook_or("hook833","");
	 end;
	 short_print.hook_or("hook834","");
      ensure
	 fmt.indent_level = old fmt.indent_level;
      end;

feature {NONE}
   
   check_assertion_mode: STRING is
      do
	 Result := "inv";
      end;
      
feature {RUN_CLASS}
   
   c_define is
	 -- Define C function to check invariant.
      require
	 run_control.invariant_check;
	 current_type /= Void;
	 run_class.at_run_time;
	 small_eiffel.is_ready;
	 cpp.on_c
      local
	 id: INTEGER;
      do
	 id := current_type.id;
	 cdm.clear;
	 cdm.extend('T');
	 id.append_in(cdm);
	 cdm.extend('*');
	 cdm.extend('i');
	 id.append_in(cdm);
	 cdm.extend('(');
	 cdm.extend('T');
	 id.append_in(cdm);
	 cdm.extend('*');
	 cdm.extend('C');
	 cdm.extend(')');
	 cpp.put_c_heading(cdm);
	 cpp.swap_on_c;
	 cdm.copy("*((int*)rs++)=INVid;*((char**)rs++)=p[");
	 id.append_in(cdm);
	 cdm.extend(']');
	 cdm.append(fz_00);
	 cpp.put_string(cdm);
	 compile_to_c;
	 cpp.put_string("rs-=2;return C;}%N");
      ensure	 
	 cpp.on_c
      end;
   
feature {NONE}   

   cdm: STRING is
      once
	 !!Result.make(128);
      end;

end -- CLASS_INVARIANT

