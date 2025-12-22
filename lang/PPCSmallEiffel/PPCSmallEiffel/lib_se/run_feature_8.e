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
class RUN_FEATURE_8
   
inherit RUN_FEATURE redefine base_feature end;
   
creation {EXTERNAL_FUNCTION} make
   
feature 
   
   static_value_mem: INTEGER;

   base_feature: EXTERNAL_FUNCTION;
   
feature 

   is_pre_computable: BOOLEAN is false;
   
   can_be_dropped: BOOLEAN is false;
   
   local_vars: LOCAL_VAR_LIST is do end;
   
   afd_check is
      do
	 routine_afd_check;
      end;

   is_static: BOOLEAN is 
      local
	 n: STRING;
	 type_bit: TYPE_BIT;
      do 
	 n := name.to_string;
	 if us_is_expanded_type = n then
	    Result := true;
	    if current_type.is_expanded then
	       static_value_mem := 1;
	    end;
	 elseif us_is_basic_expanded_type = n then
	    Result := true;
	    if current_type.is_basic_eiffel_expanded then
	       static_value_mem := 1;
	    end;
         elseif us_count = n and then current_type.is_bit then
	    Result := true;
	    type_bit ?= current_type;
	    static_value_mem := type_bit.nb;
	 end;
      end;
   
   mapping_c is
      local
	 bf: like base_feature;
	 native: NATIVE;
	 bcn: STRING;
      do
	 bf := base_feature;
	 native := bf.native;
	 bcn := bf.base_class.base_class_name.to_string;
	 native.c_mapping_function(Current,bcn,bf.first_name.to_string);
      end;
   
   c_define is 
      local
	 bf: like base_feature;
	 native: NATIVE;
	 bcn: STRING;
      do
	 bf := base_feature;
	 native := bf.native;
	 bcn := bf.base_class.base_class_name.to_string;
	 native.c_define_function(Current,bcn,bf.first_name.to_string);
      end;

feature {TYPE_BIT_2}

   integer_value(p: POSITION): INTEGER is
      local
	 n: STRING;
      do
	 n := name.to_string;
	 if us_integer_bits = n then
	    Result := Integer_bits;
	 elseif us_character_bits = n then
	    Result := Character_bits;
	 else
	    eh.add_position(p);
	    eh.add_position(start_position);
	    fatal_error(fz_iinaiv);
	 end;
      end;
   
feature {RUN_CLASS}

   jvm_field_or_method is
      local
	 native: NATIVE;
	 n, bcn: STRING;
      do
	 n := name.to_string;
	 if us_bitn = n then
	    jvm.add_field(Current);
	 else
	    native := base_feature.native;
	    bcn := base_feature.base_class.base_class_name.to_string;
	    native.jvm_add_method_for_function(Current,bcn,n);
	 end;
      end;

feature

   mapping_jvm is
      local
	 bf: like base_feature;
	 native: NATIVE;
	 bcn: STRING;
      do
	 bf := base_feature;
	 native := bf.native;
	 bcn := bf.base_class.base_class_name.to_string;
	 native.jvm_mapping_function(Current,bcn,bf.first_name.to_string);
      end;

feature {JVM}

   jvm_define is
      local
	 bf: like base_feature;
	 native: NATIVE;
	 n, bcn: STRING;
	 cp: like constant_pool;
      do
	 bf := base_feature;
	 n := bf.first_name.to_string;
	 if us_bitn = n then
	    cp := constant_pool;
	    field_info.add(1,cp.idx_uft8(n),cp.idx_uft8(fz_a9));
	 else
	    native := bf.native;
	    bcn := bf.base_class.base_class_name.to_string;
	    native.jvm_define_function(Current,bcn,n);
	 end;
      end;
   
feature {NATIVE}
   
   c_prototype is
      do
	 external_prototype(base_feature);
      end;
   
   c_define_with_body(body: STRING) is
      require
	 body /= Void
      do
	 c_opening;
	 cpp.put_string(body);
	 c_closing;
      end;

   c_opening is
      do
	 define_prototype;
	 define_opening;
      end;

   c_closing is
      do
	 define_closing;
	 cpp.put_string(fz_15);
      end;

   jvm_opening is
      do
	 method_info_start;
	 jvm_define_opening;
      end;

   jvm_closing is
      do
	 jvm_define_closing;
	 result_type.run_type.jvm_return_code;
	 method_info.finish;
      end;

   jvm_closing_fast is
	 -- Skip ensure and assume the result is already pushed.
      do
	 result_type.run_type.jvm_return_code;
	 method_info.finish;
      end;

feature {NONE}   
   
   tmp_string: STRING is
      once
	 !!Result.make(80);
      end;

feature {NONE}   
   
   initialize is
      local
	 n: STRING;
	 rf: RUN_FEATURE;
         type_bit_ref: TYPE_BIT_REF;
      do
	 n := name.to_string;
	 arguments := base_feature.arguments;
	 if arguments /= Void and then arguments.count > 0 then
	    arguments := arguments.to_runnable(current_type);
	 end;
	 if us_bitn = n then
            type_bit_ref ?= current_type;
	    result_type := type_bit_ref.type_bit;
	 else
	    result_type := base_feature.result_type.to_runnable(current_type);
         end;
	 if run_control.require_check then
	    require_assertion := base_feature.run_require(Current);
	 end;
	 if run_control.ensure_check then
	    ensure_assertion := base_feature.run_ensure(Current);
	 end;
	 if us_twin = n then
	    rf := run_class.get_copy;
	 elseif us_se_argc = n then
	    type_string.run_class.set_at_run_time;
	 elseif us_generating_type = n then
	    type_string.run_class.set_at_run_time;
	 elseif us_generator = n then
	    type_string.run_class.set_at_run_time;
	 end;
      end;
   
   compute_use_current is
      do
	 if base_feature.use_current then
	    use_current_state := ucs_true;
	 else
	    std_compute_use_current;
	 end;
      end;

feature {NONE}

   update_tmp_jvm_descriptor is
      do
	 routine_update_tmp_jvm_descriptor;
      end;

invariant
   
   result_type /= Void;
   
   routine_body = Void;
   
end -- RUN_FEATURE_8

