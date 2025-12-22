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
class CECIL_POOL
   --
   -- Unique global object in charge of CECIL calls.
   --

inherit GLOBALS;

feature {NONE}
   
   -- Internal SmallEiffel entry points :
   se_cecil_list: FIXED_ARRAY[RUN_FEATURE];
   se_cecil_name: FIXED_ARRAY[STRING];

   -- User's entry points from cecil file :
   user_cecil_list: FIXED_ARRAY[RUN_FEATURE];
   user_cecil_name: FIXED_ARRAY[STRING];

   user_path_h: STRING;

feature {SMALL_EIFFEL}

   fill_up is
      local
	 t: TYPE;
	 rta: FIXED_ARRAY[TYPE];
	 fna: FIXED_ARRAY[FEATURE_NAME];
	 rf: RUN_FEATURE;
	 i: INTEGER;
      do
	 -- Internals :
	 if run_control.no_check then
	    !!se_cecil_list.with_capacity(1);
	    !!se_cecil_name.with_capacity(1);
	    -- To be sure that GENERAL.print is alive :
	    se_cecil_name.add_last("se_print");
	    rf := type_any.run_class.get_feature_with(us_print);
	    se_cecil_list.add_last(rf);
	    switch_collection.update_with(rf);
	 end;
	 -- For the user :
	 if run_control.cecil_path /= Void then
	    !!user_cecil_list.with_capacity(4);
	    !!user_cecil_name.with_capacity(4);
	    user_path_h := eiffel_parser.connect_to_cecil;
	    from
	       !!rta.with_capacity(4);
	       !!fna.with_capacity(4);
	    until
	       eiffel_parser.end_of_input
	    loop
	       user_cecil_name.add_last(eiffel_parser.parse_c_name);
	       rta.add_last(eiffel_parser.parse_run_type);
	       check
		  nb_errors = 0
	       end;
	       fna.add_last(eiffel_parser.parse_feature_name);
	       check
		  nb_errors = 0
	       end;
	    end;
	    eiffel_parser.disconnect;
	    echo.put_string("Loading cecil features.%N");
	    from
	       i := 0;
	    until
	       i > rta.upper
	    loop
	       t := rta.item(i).to_runnable(type_any);
	       rf := t.run_class.get_feature(fna.item(i));
	       user_cecil_list.add_last(rf);
	       switch_collection.update_with(rf);
	       i := i + 1;
	    end;
	 end;
      end;

feature {C_PRETTY_PRINTER}

   c_define_internals is
      do
	 if se_cecil_list /= Void then
	    echo.put_string("Cecil (internal use) :%N");
	    c_define_for_list(se_cecil_list,se_cecil_name);
	 end;
      end;

   c_define_users is
      do
	 if user_cecil_list /= Void then
	    echo.put_string("Cecil (for user) :%N");
	    cpp.connect_cecil_out_h(user_path_h);
	    c_define_for_list(user_cecil_list,user_cecil_name);
	    cpp.disconnect_cecil_out_h;
	 end;
      end;

feature {NONE}

   c_define_for_list(cecil_list: FIXED_ARRAY[RUN_FEATURE];
		     cecil_name: FIXED_ARRAY[STRING]) is
      require
	 cecil_name.count = cecil_list.count
      local
	 i: INTEGER;
      do
	 from
	    i := cecil_list.upper;
	 until
	    i < 0
	 loop
	    c_define_for(cecil_name.item(i),cecil_list.item(i));
	    i := i - 1;
	 end;
      end;

feature {NONE}
   
   c_define_for(c_name: STRING; rf: RUN_FEATURE) is
      require
	 not c_name.empty;
	 rf /= Void
      local
	 running: ARRAY[RUN_CLASS];
	 rfct, rfrt: TYPE;
	 rfname: FEATURE_NAME;
	 rfargs: FORMAL_ARG_LIST;
	 cecil_target: CECIL_TARGET;
	 cecil_arg_list: CECIL_ARG_LIST;
      do
	 rfct := rf.current_type;
	 rfrt := rf.result_type;
	 rfname := rf.name;
	 rfargs := rf.arguments; 
	 echo.put_string(rfct.run_time_mark);
	 echo.put_character('%T');
	 echo.put_character('.');
	 echo.put_string(rfname.to_string);
	 echo.put_character('%N');
	 -- (1) ------------------------- Define Cecil heading :
	 tmp_string.clear;
	 if rfrt /= Void then
	    rfrt.c_type_for_external_in(tmp_string);
	 else
	    tmp_string.append(fz_void);
	 end;
	 tmp_string.extend(' ');
	 tmp_string.append(c_name);
	 tmp_string.extend('(');
	 rfct.c_type_for_external_in(tmp_string);
	 tmp_string.extend(' ');
	 tmp_string.extend('C');
	 if rfargs /= Void then
	    tmp_string.extend(',');
	    rfargs.external_prototype(tmp_string);
	 end;
	 tmp_string.extend(')');
	 cpp.put_c_heading(tmp_string);
	 cpp.swap_on_c;
	 -- (2) ------------------------- Define body of Cecil :
	 running := rfct.run_class.running;
	 if running = Void then
	    eh.add_type(rfct," not created (type is not alive).");
	    eh.append("Empty Cecil function ");
	    eh.append(rfct.run_time_mark);
	    eh.append(rfname.to_key);
	    eh.append(".");
	    eh.print_as_warning;
	 end;
	 if rfrt /= Void then
	    cpp.put_string("return ");
	 end;
	 !!cecil_target.make(rf);
	 if rf.arg_count > 0 then
	    !!cecil_arg_list.make(rf);
	 end;
	 if rfct.is_expanded then
	    cpp.push_direct(rf,cecil_target,cecil_arg_list);
	    rf.mapping_c;
	    cpp.pop;
	 else
	    cpp.push_cpc(rf,running,cecil_target,cecil_arg_list);
	 end;
	 cpp.put_string(fz_00);
	 cpp.put_string(fz_12);
      end;

feature {NONE}
   
   tmp_string: STRING is
      once
	 !!Result.make(256);
      end;

end -- CECIL_POOL

