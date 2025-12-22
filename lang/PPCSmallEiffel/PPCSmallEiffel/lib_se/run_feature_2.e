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
class RUN_FEATURE_2
   
inherit RUN_FEATURE redefine base_feature, address_of end;
   
creation {WRITABLE_ATTRIBUTE} make
   
feature 
   
   base_feature: WRITABLE_ATTRIBUTE;
   
   local_vars: LOCAL_VAR_LIST is do end;
   
   is_static: BOOLEAN is do end;
   
   static_value_mem: INTEGER is do end;

   can_be_dropped: BOOLEAN is true;
   
   is_pre_computable: BOOLEAN is false;

   afd_check is 
      local
	 rc: RUN_CLASS;
      do 
	 rc := result_type.run_type.run_class;
      end;
   
   mapping_c is
      local
	 ct: TYPE;
      do
	 ct := current_type;
	 if ct.is_basic_eiffel_expanded then
	    check
	       us_item = name.to_string 
	    end;
	    cpp.put_target_as_value;
	 else
	    cpp.put_character('(');
	    if ct.is_reference then
	       cpp.put_character('(');
	       ct.mapping_cast;
	       cpp.put_target_as_target;
	       cpp.put_character(')');
	       cpp.put_string(fz_b5);
	    else
	       cpp.put_target_as_value;
	       cpp.put_string(")._");
	    end;
	    cpp.put_string(name.to_string);
	    force_c_recompilation_comment;
	 end;
      end;

   address_of is
      do
	 cpp.put_string("&(C->_");
	 cpp.put_string(name.to_string);
	 cpp.put_character(')');
      end;
   
   c_define is 
      do
	 nothing_comment;
      end;
   
feature {NONE}   
   
   force_c_recompilation_comment is
      local
	 rc: RUN_CLASS;
      do
	 cpp.put_string(fz_open_c_comment);
	 rc := run_class;
	 cpp.put_integer(rc.offset_of(Current));
	 cpp.put_string(fz_close_c_comment);
      end;
   
   initialize is
      do
	 result_type := base_feature.result_type.to_runnable(current_type);
      end;
   
   compute_use_current is
      do
	 use_current_state := ucs_true;
      end;

feature {RUN_CLASS}

   jvm_field_or_method is
      do
	 jvm.add_field(Current);
      end;

feature

   mapping_jvm is
      local
	 idx: INTEGER;
	 stack_level: INTEGER;
      do
	 jvm.push_target_as_target;
	 stack_level := result_type.jvm_stack_space - 1;
	 idx := constant_pool.idx_fieldref(Current);
	 code_attribute.opcode_getfield(idx,stack_level);
      end;

feature {JVM}

   jvm_define is
      local
	 name_idx, descriptor: INTEGER;
	 cp: like constant_pool;
      do
	 cp := constant_pool;
	 name_idx := cp.idx_uft8(name.to_string);
	 descriptor := cp.idx_uft8(jvm_descriptor);
	 field_info.add(1,name_idx,descriptor);
      end;
   
feature {NONE}

   update_tmp_jvm_descriptor is
      local
	 rt: TYPE;
      do
	 rt := result_type.run_type;
	 if rt.is_reference then
	    tmp_jvm_descriptor.append(jvm_root_descriptor);
	 else
	    rt.jvm_descriptor_in(tmp_jvm_descriptor);
	 end;
      end;

invariant
   
   arguments = Void;
   
   result_type /= Void;
   
   require_assertion = Void;
   
   routine_body = Void;
   
   ensure_assertion = Void;
   
   rescue_compound = Void;
   
end -- RUN_FEATURE_2

