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
class RUN_FEATURE_6
   
inherit RUN_FEATURE redefine base_feature end;

creation {ONCE_FUNCTION} make
   
feature 
   
   base_feature: ONCE_FUNCTION;
      
   local_vars: LOCAL_VAR_LIST;
   
   is_static: BOOLEAN is do end;
   
   static_value_mem: INTEGER is do end;

   afd_check is
      do
	 routine_afd_check;
      end;

   can_be_dropped: BOOLEAN is 
      do
	 if is_pre_computable then
	    Result := true;
	 end;
      end;
   
   mapping_c is
      local
	 tcbd: BOOLEAN;
      do
	 if is_pre_computable then
	    once_result;	    
	 elseif use_current then
	    default_mapping_function;
	 else
	    tcbd := cpp.target_cannot_be_dropped;
	    if tcbd then
	       cpp.put_character(',');
	    end;
	    mapping_name;
	    cpp.put_character('(');
	    if arg_count > 0 then
	       cpp.put_arguments;
	    end;
	    cpp.put_character(')');
	    if tcbd then
	       cpp.put_character(')');
	    end;
	 end;
      end;
   
   c_define is
      local
	 bfbc: BASE_CLASS;
      do
	 bfbc := base_feature.base_class;
	 if is_pre_computable then
	    if not bfbc.once_flag(once_mark) then
	       once_variable;
	    end;
	    cpp.incr_pre_computed_once_count(Current);
	 else
	    if not bfbc.once_flag(once_mark) then
	       once_boolean;
	       once_variable;
	    end;
	    define_prototype;
	    cpp.put_string("if (");
	    once_flag; 
	    cpp.put_string("==0){%N");
	    define_opening;
	    once_flag;
	    cpp.put_string("=1;%N");
	    if routine_body /= Void then
	       routine_body.compile_to_c;
	    end;
	    define_closing;
	    once_result;
	    cpp.put_string("=R;}%N");
	    cpp.put_string("return ");
	    once_result;
	    cpp.put_string(";}%N");
	 end;
      end;
   
feature {NONE}   

   is_pre_computable: BOOLEAN is
      do
	 if frozen_general.fast_has(name.to_string) then
	    Result := true;
	 elseif arguments = Void and then not use_current then 
	    if routine_body = Void then
	       Result := true;
	    elseif not run_control.invariant_check then
	       Result := routine_body.is_pre_computable;
	    end;
	 end;
      end;

feature {ONCE_ROUTINE_POOL}   

   once_result_in(str: STRING) is
	 -- Produce the C name of the once Result.
      do
	 str.extend('o');
	 base_feature.mapping_c_name_in(str);
      end;
   
feature {NONE}   

   once_result is
	 -- Produce the C name of the once Result.
      do
	 c_code.clear;
	 once_result_in(c_code);
	 cpp.put_string(c_code);
      end;
   
   once_variable is
      do
	 c_code.clear;
	 c_code.extend('T');
	 if result_type.is_expanded then
	    result_type.id.append_in(c_code);
	    c_code.extend(' ');
	 else
	    c_code.extend('0');
	    c_code.extend('*');
	 end;
	 once_result_in(c_code);
	 c_code2.clear;
	 result_type.c_initialize_in(c_code2);
	 cpp.put_extern5(c_code,c_code2);
      end;
   
   initialize is
      do
	 arguments := base_feature.arguments;
	 if arguments /= Void and then arguments.count > 0 then
	    arguments := arguments.to_runnable(current_type);
	 end;
	 result_type := base_feature.result_type;
	 if result_type.is_anchored then
	    eh.add_position(result_type.start_position);
	    fatal_error("Result type of a once function must %
			%not be anchored (VFFD.7).");
	 elseif result_type.is_formal_generic then
	    eh.add_position(result_type.start_position);
	    fatal_error("Result type of a once function must %
			%not be a formal generic argument (VFFD.7).");
	 end;
	 result_type := result_type.to_runnable(current_type);
	 local_vars := base_feature.local_vars;
	 if local_vars /= Void and then local_vars.count > 0 then
	    local_vars := local_vars.to_runnable(current_type);
	 end;
	 routine_body := base_feature.routine_body;
	 if routine_body /= Void then
	    routine_body := routine_body.to_runnable(current_type);
	 end;
	 if run_control.require_check then
	    require_assertion := base_feature.run_require(Current);
	 end;
	 if run_control.ensure_check then
	    ensure_assertion := base_feature.run_ensure(Current);
	 end;
	 once_routine_pool.add_function(Current);
      end;
   
   compute_use_current is
      do
	 std_compute_use_current;
      end;
   
feature {NONE}
   
   frozen_general: ARRAY[STRING] is
      once
	 Result := <<us_std_error, us_std_input, us_io, 
		     us_std_output>>;
      end;
   
feature {C_PRETTY_PRINTER}
   
   c_pre_computing is
      require
	 is_pre_computable;
	 cpp.on_c;
      local
	 bfbc: BASE_CLASS;
      do
	 bfbc := base_feature.base_class;
	 echo.put_character('%T');
	 echo.put_string(bfbc.base_class_name.to_string);
	 echo.put_character('.');
	 echo.put_string(name.to_string);
	 echo.put_character('%N');
	 if run_control.require_check then
	    if require_assertion /= Void then
	       require_assertion.compile_to_c;
	    end;
	 end;
	 tmp_string.clear;
	 tmp_string.extend('{');
	 result_type.c_type_for_result_in(tmp_string);
	 tmp_string.extend(' ');
	 tmp_string.extend('R');
	 tmp_string.extend('=');
	 cpp.put_string(tmp_string);
	 result_type.c_initialize;
	 cpp.put_string(fz_00);
	 if local_vars /= Void then
	    local_vars.compile_to_c;
	 end;
	 if routine_body /= Void then
	    routine_body.compile_to_c; 
	 end;
	 if run_control.ensure_check then
	    if ensure_assertion /= Void then
	       ensure_assertion.compile_to_c;
	    end;
	 end;
	 once_result;
	 cpp.put_string("=R;}/*PCO*/%N");
      end;

   tmp_string: STRING is
      once
	 !!Result.make(10);
      end;

feature {RUN_CLASS}

   jvm_field_or_method is
      do
	 jvm.add_method(Current);
      end;

feature

   mapping_jvm is
      do
	 routine_mapping_jvm;
      end;

feature {JVM}

   jvm_define is
      local
	 result_space, branch, idx_flag, idx_result: INTEGER;
      do
	 idx_result := once_routine_pool.idx_fieldref_for_result(Current);
	 idx_flag := once_routine_pool.idx_fieldref_for_flag(Current);
	 result_space := result_type.jvm_stack_space;
	 method_info_start;
	 code_attribute.opcode_getstatic(idx_flag,1);
	 branch := code_attribute.opcode_ifne;
	 code_attribute.opcode_iconst_1;
	 code_attribute.opcode_putstatic(idx_flag,-1);
	 jvm_define_opening;
	 if routine_body /= Void then
	    routine_body.compile_to_jvm;
	 end;
	 jvm_define_closing;
	 code_attribute.opcode_putstatic(idx_result,- result_space);
	 code_attribute.resolve_u2_branch(branch);
	 code_attribute.opcode_getstatic(idx_result,result_space);
	 result_type.run_type.jvm_return_code;
	 method_info.finish;
      end;
   
feature {NONE}

   update_tmp_jvm_descriptor is
      do
	 routine_update_tmp_jvm_descriptor;
      end;

end -- RUN_FEATURE_6

