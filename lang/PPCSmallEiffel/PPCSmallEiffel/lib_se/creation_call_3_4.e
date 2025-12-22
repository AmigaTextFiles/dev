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
deferred class CREATION_CALL_3_4
   
inherit CREATION_CALL;
   
feature 
   
   call: PROC_CALL;

feature

   afd_check is
      do
	 if arg_count > 0 then
	    run_args.afd_check;
	 end;
      end;

feature {NONE}
   
   run_args: EFFECTIVE_ARG_LIST is
      do
	 Result := call.arguments;
      end;

   check_creation_clause(t: TYPE) is
      require
	 t.is_run_type;
      local
	 fn: FEATURE_NAME;
	 bottom, top: BASE_CLASS;
	 args: like run_args;
      do
	 fn := call.feature_name;
	 if t.is_like_current then
	    top := fn.start_position.base_class;
	    bottom := t.base_class;
	    check 
	       bottom = top or else bottom.is_subclass_of(top)
	    end;
	    fn := bottom.new_name_of(top,fn);
	    if fn = Void then
	       fn := call.feature_name;
	       eh.add_position(fn.start_position);
	       eh.append(fz_09);
	       eh.append(fn.to_string);
	       eh.append("%" not found for type %"");
	       eh.append(t.run_time_mark);
	       fatal_error(fz_03);
	    end;
	 end;
	 run_feature := t.run_class.get_feature(fn);
	 if run_feature = Void then
	    cp_not_found(fn);
	 end;
	 if small_eiffel.short_flag then
	 elseif not t.has_creation(fn) then
	    eh.add_position(call.feature_name.start_position);
	    eh.add_position(fn.start_position);
	    eh.append(fn.to_string);
	    eh.append(" is not in the creation list of ");
	    eh.add_type(t,fz_dot); 
	    eh.print_as_fatal_error;
	 end;
	 run_feature.add_client(run_compound.run_class);
	 if run_feature.result_type /= Void then
	    eh.add_position(run_feature.start_position);
	    eh.add_position(fn.start_position);
	    fatal_error("Feature found is not a procedure.");
	 end;
	 if arg_count = 0 and then run_feature.arguments /= Void then
	    eh.add_position(run_feature.start_position);
	    eh.add_position(start_position);
	    fatal_error("Procedure found has argument(s).");
	 end;
	 if arg_count > 0 then
	    args := call.arguments.to_runnable(current_type);
	    if args = Void then
	       error(call.arguments.start_position,fz_bad_arguments);
	    else
	       args.match_with(run_feature); 
	    end;
	 end;
	 call := call.make_runnable(run_compound,writable,args,run_feature);
      end;
   
   is_pre_computable: BOOLEAN is
	 -- *** AJOUTER C_ARRAY.calloc ??? ***
      local
	 rfct: TYPE;
	 rfn, rfctbcn: STRING;
      do
	 if writable.is_result then
	    if run_args = Void then
	       Result := true;
	    else
	       Result := run_args.is_pre_computable;
	    end;
	    if Result then
	       if run_feature.is_pre_computable then
		  Result := true;
	       else
		  rfct := run_feature.current_type;
		  rfctbcn := rfct.base_class.base_class_name.to_string;
		  rfn := run_feature.name.to_string;
		  if us_make= rfn then
		     Result := make_precomputable.has(rfctbcn);
		  elseif us_blank = rfn then
		     Result := us_string = rfctbcn;
		  elseif us_with_capacity = rfn then
		     if us_array = rfctbcn then
			Result := true;
		     elseif us_fixed_array = rfctbcn then
			Result := true;
		     elseif us_dictionary = rfctbcn then
			Result := true;
		     else
			Result := false;
		     end;
		  end;
	       end;
	    end;
	 end;
      end;

feature {NONE}

   make_precomputable: ARRAY[STRING] is
      once
	 Result := <<us_array,us_fixed_array,us_string,us_dictionary,
		     us_std_file_read>>;
      end;

feature {NONE}

   cp_not_found(fn: FEATURE_NAME) is
      do
	 eh.add_position(call.feature_name.start_position);
	 eh.add_position(fn.start_position);
	 fatal_error("Creation procedure not found.");
      end;

   c2c_expanded_initializer(t: TYPE) is
      local
	 rf3: RUN_FEATURE_3;
      do
	 rf3 := t.expanded_initializer;
	 if rf3 /= Void then
	    cpp.expanded_writable(rf3,writable);
	 end;
      end;

end -- CREATION_CALL_3_4


