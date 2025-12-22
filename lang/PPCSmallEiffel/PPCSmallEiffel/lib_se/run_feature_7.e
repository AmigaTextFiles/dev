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
class RUN_FEATURE_7
   
inherit RUN_FEATURE redefine base_feature end;
   
creation {EXTERNAL_PROCEDURE} make
   
feature 
   
   base_feature: EXTERNAL_PROCEDURE;
   
   is_pre_computable: BOOLEAN is false;
   
   is_static: BOOLEAN is false;
   
   static_value_mem: INTEGER is do end;

   local_vars: LOCAL_VAR_LIST is do end;
   
   can_be_dropped: BOOLEAN is false;
   
   afd_check is
      do
	 routine_afd_check;
      end;

   mapping_c is
      local
	 bf: like base_feature;
	 native: NATIVE;
	 bcn: STRING;
	 bfuc: BOOLEAN;
      do
	 bf := base_feature;
	 native := bf.native;
	 bcn := bf.base_class.base_class_name.to_string;
	 native.c_mapping_procedure(Current,bcn,bf.first_name.to_string);
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
	 native.c_define_procedure(Current,bcn,bf.first_name.to_string);
      end;

feature {NONE}   
   
   tmp_string: STRING is
      once
	 !!Result.make(80);
      end;

feature {NONE}   

   initialize is
      do
	 arguments := base_feature.arguments;
	 if arguments /= Void and then arguments.count > 0 then
	    arguments := arguments.to_runnable(current_type);
	 end;
	 if run_control.require_check then
	    if us_copy = name.to_string
	       and then current_type.is_expanded 
	     then
	    else
	       require_assertion := base_feature.run_require(Current);
	    end;
	 end;
	 if run_control.ensure_check then
	    ensure_assertion := base_feature.run_ensure(Current);
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

feature {NATIVE}

   c_define_with_body(body: STRING) is
      require
	 body /= Void
      do
	 define_prototype;
	 define_opening;
	 cpp.put_string(body);
	 define_closing;
	 cpp.put_string(fz_12);
      end;

feature {NATIVE}

   c_prototype is
      do
	 external_prototype(base_feature);
      end;

   jvm_opening is
      do
	 method_info_start;
	 jvm_define_opening;
      end;

   jvm_closing is
      do
	 jvm_define_closing;
	 code_attribute.opcode_return;
	 method_info.finish;
      end;

feature {RUN_CLASS}

   jvm_field_or_method is
      local
	 native: NATIVE;
	 bcn: STRING;
      do
	 native := base_feature.native;
	 bcn := base_feature.base_class.base_class_name.to_string;
	 native.jvm_add_method_for_procedure(Current,bcn,name.to_string);
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
	 native.jvm_mapping_procedure(Current,bcn,bf.first_name.to_string);
      end;

feature {JVM}

   jvm_define is
      local
	 bf: like base_feature;
	 native: NATIVE;
	 bcn: STRING;
      do
	 bf := base_feature;
	 native := bf.native;
	 bcn := bf.base_class.base_class_name.to_string;
	 native.jvm_define_procedure(Current,bcn,bf.first_name.to_string);
      end;
   
feature {NONE}

   update_tmp_jvm_descriptor is
      do
	 routine_update_tmp_jvm_descriptor;
      end;

invariant
   
   result_type = Void;
   
   routine_body = Void;

end -- RUN_FEATURE_7

