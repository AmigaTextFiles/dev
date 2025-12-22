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
class RUN_FEATURE_5
   
inherit RUN_FEATURE redefine base_feature end;

creation {ONCE_PROCEDURE} make
   
feature 
   
   base_feature: ONCE_PROCEDURE;
      
   local_vars: LOCAL_VAR_LIST;      
         
   is_static: BOOLEAN is false;
   
   static_value_mem: INTEGER is do end;

   can_be_dropped: BOOLEAN is false;
   
   is_pre_computable: BOOLEAN is false;
   
   afd_check is
      do
	 routine_afd_check;
      end;

   mapping_c is
      do
	 if use_current then
	    default_mapping_procedure;
	 else
	    if cpp.target_cannot_be_dropped then
	       cpp.put_string(fz_14);
	    end;
	    mapping_name;
	    cpp.put_character('(');
	    if arg_count > 0 then
	       cpp.put_arguments;
	    end;
	    cpp.put_string(fz_14);
	 end;
      end;
   
   c_define is
      local
	 bfbc: BASE_CLASS;
      do
	 bfbc := base_feature.base_class;
	 if not bfbc.once_flag(once_mark) then
	    once_boolean;
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
	 cpp.put_string("}}%N");
      end;
   
feature {NONE}   
   
   initialize is
      do
	 arguments := base_feature.arguments;
	 if arguments /= Void and then arguments.count > 0 then
	    arguments := arguments.to_runnable(current_type);
	 end;
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
	 once_routine_pool.add_procedure(Current);
      end;
   
   compute_use_current is
      do
	 std_compute_use_current;
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
	 branch, idx_flag: INTEGER;
      do
	 idx_flag := once_routine_pool.idx_fieldref_for_flag(Current);
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
	 code_attribute.resolve_u2_branch(branch);
	 code_attribute.opcode_return;
	 method_info.finish;
      end;
   
feature {NONE}

   update_tmp_jvm_descriptor is
      do
	 routine_update_tmp_jvm_descriptor;
      end;

end -- RUN_FEATURE_5

