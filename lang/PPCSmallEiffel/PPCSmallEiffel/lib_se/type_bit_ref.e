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
class TYPE_BIT_REF

inherit TYPE redefine to_reference end;

creation make

feature 

   type_bit: TYPE_BIT;

   written_mark: STRING;

   run_time_mark: STRING;

feature
   
   make(tb: TYPE_BIT) is
      require
	 tb.is_run_type
      do
	 type_bit := tb;
	 run_time_mark := "BIT ";
	 type_bit.nb.append_in(run_time_mark);
	 run_time_mark.append(" REF");
	 run_time_mark := unique_string.item(run_time_mark);
	 written_mark := run_time_mark;
      ensure
	 type_bit = tb
      end;

feature
   
   is_run_type: BOOLEAN is true;

   is_expanded: BOOLEAN is false;

   is_basic_eiffel_expanded: BOOLEAN is false;

   is_reference: BOOLEAN is true;

   is_user_expanded: BOOLEAN is false;

   is_dummy_expanded: BOOLEAN is false;

   is_generic: BOOLEAN is false;

feature

   space_for_variable: INTEGER is
      do
	 Result := space_for_pointer;
      end;

   space_for_object: INTEGER is
      do
	 Result := standard_space_for_object;
      end;

   run_class: RUN_CLASS is
      do
	 Result := small_eiffel.run_class(run_type);
      end;

   generic_list: ARRAY[TYPE] is
      do
	 fatal_error_generic_list;
      end;

   expanded_initializer: RUN_FEATURE_3 is
      do
      end;

   c_header_pass1 is
      do
	 standard_c_typedef;
	 tmp_string.copy(fz_struct);
	 tmp_string.extend('S');
	 id.append_in(tmp_string);
	 tmp_string.append("{int id;T");
	 type_bit.id.append_in(tmp_string);
	 tmp_string.append(" bit_n;};%N");
	 cpp.put_string(tmp_string);
	 -- Creation function :
	 tmp_string.copy("void*toT");
	 id.append_in(tmp_string);
	 tmp_string.extend('(');
	 tmp_string.extend('T');
	 type_bit.id.append_in(tmp_string);
	 tmp_string.append(" bit)");
	 cpp.put_c_heading(tmp_string);
	 cpp.swap_on_c;
	 tmp_string.clear;
	 tmp_string.extend('T');
	 id.append_in(tmp_string);
	 tmp_string.append("*R=malloc(sizeof(T");
	 id.append_in(tmp_string);
	 tmp_string.append("));%NR->id=");
	 id.append_in(tmp_string);
	 tmp_string.append(";%NR->bit_n=bit;%Nreturn R;}%N");
	 cpp.put_string(tmp_string);
	 cpp.swap_on_h;
      end;

   c_header_pass2 is
      do
      end;

   c_header_pass3 is
      do
      end;

   c_header_pass4 is
      do
      end;

   c_initialize is
      do
	 cpp.put_string(fz_null);
      end;

   c_initialize_in(str: STRING) is
      do
	 str.append(fz_null);
      end;

   c_type_for_argument_in(str: STRING) is
      do 
	 str.append(fz_t0_star);
      end;

   c_type_for_target_in(str: STRING) is
      do
	 str.extend('T');
	 id.append_in(str);
	 str.extend('*');
      end;

   c_type_for_result_in(str: STRING) is
      do
	 str.append(fz_t0_star);
      end;

   run_type: TYPE_BIT_REF is
      do
	 Result := Current;
      end;

   jvm_method_flags: INTEGER is 17;

   jvm_descriptor_in(str: STRING) is
      do
	 str.append(jvm_root_descriptor);
      end;

   jvm_target_descriptor_in(str: STRING) is
      do
      end;

   jvm_return_code is
      do
      end;

   jvm_check_class_invariant is
      do
      end;

   jvm_push_local(offset: INTEGER) is
      do
	 code_attribute.opcode_aload(offset);
      end;

   jvm_push_default: INTEGER is
      do
      end;

   jvm_initialize_local(offset: INTEGER) is
      do
      end;

   jvm_write_local(offset: INTEGER) is
      do
	 code_attribute.opcode_astore(offset);
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
	 code_attribute.opcode_aastore;
      end;

   jvm_xaload is
      do
	 code_attribute.opcode_aaload;
      end;

   jvm_if_x_eq: INTEGER is
      do
	 Result := code_attribute.opcode_if_acmpeq;
      end;

   jvm_if_x_ne: INTEGER is
      do
	 Result := code_attribute.opcode_if_acmpne;
      end;

   jvm_to_reference is
      do
      end;

   jvm_to_expanded: INTEGER is
      do
      end;

   jvm_convert_to(destination: TYPE): INTEGER is
      do
	 if destination.is_expanded then
	    Result := jvm_to_expanded;
	 else
	    Result := 1;
	 end;
      end;

   to_runnable(rt: TYPE): like Current is
      do
	 Result := Current;
      end;

   base_class_name: CLASS_NAME is
      once
	 !!Result.make(us_bit_n_ref,Void);
      end;

   id: INTEGER is
      do
	 Result := run_class.id;
      end;

   smallest_ancestor(other: TYPE): TYPE is
      do
	 if run_time_mark = other.run_time_mark then
	    Result := Current;
	 else
	    Result := type_any;
	 end;
      end;

   is_a(other: TYPE): BOOLEAN is
      do
	 if run_time_mark = other.run_time_mark then
	    Result := true;
	 else
	    Result := base_class.is_subclass_of(other.base_class);
	    if not Result then
	       eh.add_type(Current,fz_inako);
	       eh.add_type(other,fz_dot);
	    end;
	 end;
      end;

   start_position: POSITION is do end;

   has_creation(fn: FEATURE_NAME): BOOLEAN is do end;

   to_reference is
      do
	 cpp.put_string(fz_to_t);
	 cpp.put_integer(id);
      end;

   need_c_struct: BOOLEAN is true;

feature {RUN_CLASS,TYPE}

   need_gc_mark_function: BOOLEAN is true;

   call_gc_sweep_in(str: STRING) is
      do
	 standard_call_gc_sweep_in(str);
      end;

   gc_info_in(str: STRING) is
      do
	 standard_gc_info_in(str);
      end;

   gc_define1 is
      do
	 standard_gc_define1;
      end;

   gc_define2 is
      do
	 standard_gc_define2;
      end;

   gc_initialize is
      do
	 standard_gc_initialize;
      end;

feature {TYPE}

   frozen short_hook is
      do
	 short_print.a_class_name(base_class_name);
      end;

invariant
   
   type_bit /= Void

end -- TYPE_BIT_REF

