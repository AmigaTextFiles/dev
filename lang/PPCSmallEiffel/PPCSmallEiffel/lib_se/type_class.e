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
class TYPE_CLASS
   
inherit TYPE;
   
creation make
   
feature 
   
   base_class_name: CLASS_NAME;
   
feature

   is_generic: BOOLEAN is false;

   is_run_type: BOOLEAN is true;
   
   is_basic_eiffel_expanded: BOOLEAN is false;

feature 
   
   make(bcn: like base_class_name) is
      require
	 not bcn.predefined;
      do
	 base_class_name := bcn;
      ensure
	 base_class_name = bcn
      end;
   
   is_expanded: BOOLEAN is
      do
	 Result := base_class.is_expanded;
      end;

   is_reference: BOOLEAN is
      do
	 Result := not base_class.is_expanded;
      end;

   is_user_expanded: BOOLEAN is 
      do
	 Result := is_expanded;
      end;

   is_dummy_expanded: BOOLEAN is
      do
	 if is_expanded then
	    Result := run_class.writable_attributes = Void;
	 end;
      end;

   generic_list: ARRAY[TYPE] is
      do
	 fatal_error_generic_list;
      end;

   expanded_initializer: RUN_FEATURE_3 is
      do
	 if is_expanded then
	    Result := base_class.expanded_initializer(Current);
	 end;
      end;

   id: INTEGER is
      do
	 Result := base_class.id;
      end;
   
   space_for_variable: INTEGER is
      do
	 if is_reference then
	    Result := space_for_pointer;
	 else
	    Result := standard_space_for_object;
	 end;
      end;

   space_for_object: INTEGER is
      do
	 Result := standard_space_for_object;
      end;
	 
   has_creation(fn: FEATURE_NAME): BOOLEAN is
      do
	 Result := base_class.has_creation(fn);
      end;
   
   smallest_ancestor(other: TYPE): TYPE is
      local
	 rto: TYPE;
	 pl1, pl2: PARENT_LIST;
	 rto_bc, bc: BASE_CLASS;
      do
	 rto := other.run_type;
	 if other.is_none then
	    Result := Current;
	 elseif rto.is_any then
	    Result := rto;
	 else
	    rto_bc := rto.base_class;
	    bc := base_class;
	    if rto_bc = bc then
	       Result := Current;
	    elseif rto_bc.is_subclass_of(bc) then
	       Result := Current;
	    elseif bc.is_subclass_of(rto_bc) then
	       Result := rto;
	    elseif rto.is_expanded and then not is_expanded then
	       Result := rto.smallest_ancestor(Current);
	    else
	       pl1 := bc.parent_list;
	       pl2 := rto_bc.parent_list;
	       if pl1 = Void or else pl2 = Void then
		  Result := type_any;
	       elseif pl2.count = 1 then
		  Result := pl2.super.type.smallest_ancestor(Current);
	       elseif pl1.count = 1 then
		  Result := pl1.super.type.smallest_ancestor(other);
	       else
		  Result := pl1.smallest_ancestor(Current);
		  Result := Result.smallest_ancestor(other);
	       end;
	    end;
	 end;
      end;
   
   jvm_method_flags: INTEGER is 
      do
	 if is_reference then
	    Result := 17;
	 elseif run_class.writable_attributes = Void then
	    Result := 9;
	 else
	    Result := 17;
	 end;
      end;

   jvm_descriptor_in(str: STRING) is
      do
	 if is_expanded then
	    run_class.jvm_expanded_descriptor_in(str);
	 else 
	    str.append(jvm_root_descriptor);
	 end;
      end;

   jvm_target_descriptor_in(str: STRING) is
      do
	 if is_dummy_expanded then
	    str.extend('B');
	 end;
      end;

   jvm_return_code is
      do
	 if is_expanded then
	    run_class.jvm_expanded_return_code;
	 else
	    code_attribute.opcode_areturn;
	 end;
      end;

   jvm_check_class_invariant is
      do
	 standard_jvm_check_class_invariant;
      end;

   jvm_push_local(offset: INTEGER) is
      do
	 if is_expanded then
	    run_class.jvm_expanded_push_local(offset);
	 else
	    code_attribute.opcode_aload(offset);
	 end;
      end;

   jvm_push_default: INTEGER is
      do
	 Result := 1;
	 if is_reference then
	    code_attribute.opcode_aconst_null;
	 else
	    run_class.jvm_expanded_push_default;
	 end;
      end;

   jvm_initialize_local(offset: INTEGER) is
      do
	 if is_reference then
	    code_attribute.opcode_aconst_null;
	 else
	    run_class.jvm_expanded_push_default;
	 end;
	 jvm_write_local(offset);
      end;

   jvm_write_local(offset: INTEGER) is
      do
	 if is_expanded then
	    run_class.jvm_expanded_write_local(offset);
	 else
	    code_attribute.opcode_astore(offset);
	 end;
      end;

   jvm_xnewarray is
      local
	 idx: INTEGER;
      do
	 idx := constant_pool.idx_jvm_root_class;
	 code_attribute.opcode_anewarray(idx);
      end;

   jvm_xastore is
      do
	 if is_expanded then
	    run_class.jvm_expanded_xastore;
	 else
	    code_attribute.opcode_aastore;
	 end;
      end;

   jvm_xaload is
      do
	 if is_expanded then
	    run_class.jvm_expanded_xaload;
	 else
	    code_attribute.opcode_aaload;
	 end;
      end;

   jvm_if_x_eq: INTEGER is
      do
	 if is_expanded then
	    Result := run_class.jvm_expanded_if_x_eq;
	 else
	    Result := code_attribute.opcode_if_acmpeq;
	 end;
      end;

   jvm_if_x_ne: INTEGER is
      do
	 if is_expanded then
	    Result := run_class.jvm_expanded_if_x_ne;
	 else
	    Result := code_attribute.opcode_if_acmpne;
	 end;
      end;

   jvm_to_reference is
      do
      end;

   jvm_to_expanded: INTEGER is
      do
	 Result := 1;
      end;

   jvm_convert_to(destination: TYPE): INTEGER is
      do
	 Result := 1;
      end;

   is_a(other: TYPE): BOOLEAN is
      local
	 bcn, obcn: CLASS_NAME;
      do
	 bcn := base_class_name;
	 obcn := other.base_class_name;
	 if bcn.to_string = obcn.to_string then
	    Result := true;
	 elseif bcn.is_subclass_of(obcn) then
	    if other.is_generic then
	       Result := bcn.base_class.is_a_vncg(Current,other);
	    else
	       Result := true;
	    end;
	 end;
	 if not Result then
	    eh.add_type(Current,fz_inako);
	    eh.add_type(other,fz_dot);
	 end;
      end;

   run_type: TYPE is 
      do
	 Result := Current;
      end;

   run_class: RUN_CLASS is
      do
	 Result := small_eiffel.run_class(Current);
      end;

   c_header_pass1 is
      do
	 standard_c_typedef;
      end;

   c_header_pass2 is
      do
      end;

   c_header_pass3 is
      do
	 if is_expanded then
	    if need_c_struct then
	       standard_c_struct;
	    end;
	 end;
      end;

   c_header_pass4 is
      do
	 if is_reference then
	    if need_c_struct then
	       standard_c_struct;
	    end;
	 end;
	 standard_c_object_model;
      end;

   c_type_for_argument_in(str: STRING) is
      do 
	 if is_reference then
	    str.append(fz_t0_star);
	 elseif is_dummy_expanded then
	    str.append(fz_int);
	 else
	    str.extend('T');
	    id.append_in(str);
	    str.extend('*');
	 end;
      end;

   c_type_for_target_in(str: STRING) is
      do
	 if is_dummy_expanded then
	    str.append(fz_int);
	 else
	    str.extend('T');
	    id.append_in(str);
	    str.extend('*');
	 end;
      end;

   c_type_for_result_in(str: STRING) is
      do
	 if is_reference then
	    str.append(fz_t0_star);
	 elseif is_dummy_expanded then
	    str.append(fz_int);
	 else
	    str.extend('T');
	    id.append_in(str);
	 end;
      end;

   need_c_struct: BOOLEAN is
      do
	 if is_dummy_expanded then
	 elseif is_expanded then
	    Result := true;
	 elseif run_class.is_tagged then
	    Result := true;
	 else
	    Result := run_class.writable_attributes /= Void;
	 end;
      end;

feature {RUN_CLASS,TYPE}

   need_gc_mark_function: BOOLEAN is
      do
	 if is_reference then
	    Result := true;
	 else
	    Result := run_class.gc_mark_to_follow;
	 end;
      end;

   call_gc_sweep_in(str: STRING) is
      do
	 if is_reference then
	    standard_call_gc_sweep_in(str);
	 end;
      end;

   gc_info_in(str: STRING) is
      do
	 if is_reference then
	    standard_gc_info_in(str);
	 end;
      end;

   gc_define1 is
      do
	 if is_reference then
	    standard_gc_define1;
	 end;
      end;

   gc_define2 is
      do
	 if is_reference then
	    standard_gc_define2;
	 end;
      end;

   gc_initialize is
      do
	 if is_reference then
	    standard_gc_initialize;
	 end;
      end;

feature 
   
   start_position: POSITION is
      do
	 Result := base_class_name.start_position;
      end;
   
   to_runnable(ct: TYPE): like Current is
      local 
	 bc: BASE_CLASS;
      do
	 bc := base_class_name.base_class;
	 if bc.is_expanded then
	    if not check_memory.fast_has(bc) then
	       run_class.set_at_run_time;
	       check_memory.add_last(bc);
	    end;
	 end;
	 Result := Current;
      end;
   
   written_mark, run_time_mark: STRING is
      do
	 Result := base_class_name.to_string;
      end;
   
   c_initialize is
      do
	 if is_expanded then
	    c_initialize_expanded;
	 else
	    cpp.put_string(fz_null);
	 end;
      end;
   
   c_initialize_in(str: STRING) is
      do
	 if is_expanded then
	    if need_c_struct then
	       run_class.c_object_model_in(str);
	    else
	       str.extend('0');
	    end;
	 else
	    str.append(fz_null);
	 end;
      end;
   
feature {NONE}
   
   check_memory: ARRAY[BASE_CLASS] is
      once
	 !!Result.make(1,0);
      end;
   
feature {TYPE}

   frozen short_hook is
      do
	 short_print.a_class_name(base_class_name);
      end;
        
end -- TYPE_CLASS

