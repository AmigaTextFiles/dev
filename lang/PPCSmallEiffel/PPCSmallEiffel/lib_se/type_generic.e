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
class TYPE_GENERIC
--
-- For all generic declarations (except ARRAY) :
--        x : FOO[BAR];
--

inherit  TYPE;
      
creation make
   
creation {TYPE_GENERIC} make_runnable
   
feature 
   
   base_class_name: CLASS_NAME;
   
   generic_list: ARRAY[TYPE];
   
   written_mark: STRING;

feature {NONE}
   
   run_type_memory: like Current;
	 -- The final corresponding type when runnable.

feature 
   
   is_generic: BOOLEAN is true;

   is_basic_eiffel_expanded: BOOLEAN is false;

feature {NONE}

   make(bcn: like base_class_name; gl: like generic_list) is
      require
	 bcn /= Void;
	 gl.lower = 1;
	 not gl.empty
      local
	 i: INTEGER;
	 t: TYPE;
      do
	 base_class_name := bcn;
	 generic_list := gl;
	 from
	    tmp_mark.copy(bcn.to_string);
	    tmp_mark.extend('[');
	    i := 1;
	 until
	    i > gl.upper
	 loop
	    t := gl.item(i);
	    tmp_mark.append(t.written_mark);
	    i := i + 1;
	    if i <= gl.upper then
	       tmp_mark.extend(',');
	    end;
	 end;
	 tmp_mark.extend(']');
	 written_mark := unique_string.item(tmp_mark);
      ensure
	 base_class_name = bcn;
	 generic_list = gl;
	 written_mark /= Void
      end;

   make_runnable(model: like Current; gl: like generic_list) is
      local
	 i: INTEGER;
	 t: TYPE;
      do
	 base_class_name := model.base_class_name;
	 generic_list := gl;
	 from
	    tmp_mark.copy(base_class_name.to_string);
	    tmp_mark.extend('[');
	    i := 1;
	 until
	    i > gl.upper
	 loop
	    t := gl.item(i);
	    tmp_mark.append(t.run_time_mark);
	    i := i + 1;
	    if i <= gl.upper then
	       tmp_mark.extend(',');
	    end;
	 end;
	 tmp_mark.extend(']');
	 written_mark := unique_string.item(tmp_mark);
	 run_type_memory := Current;
      ensure
	 is_run_type;
	 written_mark = run_time_mark
      end;

feature

   is_written_runnable: BOOLEAN is
      local
	 i: INTEGER;
	 t: TYPE;
      do
	 from
	    Result := true;
	    i := generic_list.upper;
	 until
	    not Result or else i = 0
	 loop
	    t := generic_list.item(i);
	    if t.is_run_type then
	       if t.run_type = t then
	       else
		  Result := false;
	       end;
	    else
	       Result := false;
	    end;
	    i := i - 1;
	 end;
      end;

   is_run_type: BOOLEAN is
      do
	 if run_type_memory /= Void then
	    Result := true;
	 elseif is_written_runnable then
	    run_type_memory := Current;
	    basic_checks;
	    Result := true;
	 end;
      end;

   run_type: like Current is
      do
	 if is_run_type then
	    Result := run_type_memory;
	 end;
      end;

   run_class: RUN_CLASS is
      do
	 if is_run_type then
	    Result := small_eiffel.run_class(run_type_memory);
	 end;
      end;

   to_runnable(ct: TYPE): like Current is
      local
	 i: INTEGER;
	 rgl: like generic_list;
	 t1, t2: TYPE;
	 rt: like Current;
	 rc: RUN_CLASS;
      do
	 if run_type_memory = Void then
	    if is_written_runnable then
	       run_type_memory := Current;
	       basic_checks;
	       Result := Current;
	    else
	       from  
		  rgl := generic_list.twin;
		  i := rgl.upper;
	       until
		  i = 0
	       loop
		  t1 := rgl.item(i);
		  t2 := t1.to_runnable(ct);
		  if t2 = Void or else not t2.is_run_type then
		     eh.add_type(t1,fz_is_invalid);
		     eh.print_as_error;
		     i := 0;
		  else
		     rgl.put(t2,i);
		  end;
		  t2 := t2.run_type;
		  if t2.is_expanded then
		     t2.run_class.set_at_run_time;
		  end;
		  i := i - 1;
	       end;
	       !!rt.make_runnable(Current,rgl);
	       if run_type_memory = Void then
		  run_type_memory := rt;
		  Result := Current;
	       else
		  Result := twin;
		  Result.set_run_type_memory(rt);
	       end;
	    end;
	 elseif is_written_runnable then
	    Result := Current;
	 else
	    from  
	       rgl := generic_list.twin;
	       i := rgl.upper;
	    until
	       i = 0
	    loop
	       t1 := rgl.item(i);
	       t2 := t1.to_runnable(ct);
	       if t2 = Void or else not t2.is_run_type then
		  eh.add_type(t1,fz_is_invalid);
		  eh.print_as_error;
		  i := 0;
	       else
		  rgl.put(t2,i);
	       end;
	       t2 := t2.run_type;
	       if t2.is_expanded then
		  t2.run_class.set_at_run_time;
	       end;
	       i := i - 1;
	    end;
	    !!rt.make_runnable(Current,rgl);
	    Result := twin;
	    Result.set_run_type_memory(rt);
	 end;
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
	 
   expanded_initializer: RUN_FEATURE_3 is
      do
	 if is_expanded then
	    Result := base_class.expanded_initializer(Current);
	 end;
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
	 Result := base_class.is_expanded;
      end;

   is_dummy_expanded: BOOLEAN is
      do
	 if is_user_expanded then
	    Result := run_class.writable_attributes = Void;
	 end;
      end;

   id: INTEGER is
      do
	 Result := run_class.id;
      end;
   
   run_time_mark: STRING is
      do
	 if is_run_type then
	    Result := run_type_memory.written_mark;
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
	 if is_expanded then
	    run_class.jvm_expanded_push_default;
	 else
	    code_attribute.opcode_aconst_null;
	 end;
      end;

   jvm_initialize_local(offset: INTEGER) is
      do
	 if is_expanded then
	    run_class.jvm_expanded_push_default;
	 else
	    code_attribute.opcode_aconst_null;
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
	 Result := 1;
      end;

   jvm_convert_to(destination: TYPE): INTEGER is
      do
	 Result := 1;
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
	       standard_c_object_model;
	    end;
	 end;
      end;

   c_header_pass4 is
      do
	 if is_reference then
	    if need_c_struct then
	       standard_c_struct;
	       standard_c_object_model;
	    end;
	 end;
      end;

   c_initialize is
      do
	 if run_type_memory.is_expanded then
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
   
   smallest_ancestor(other: TYPE): TYPE is
      local
	 rto: TYPE;
      do
	 rto := other.run_type;
	 if other.is_none then
	    Result := Current;
	 elseif rto.is_any then
	    Result := rto;
	 elseif rto.is_a(run_type) then
	    Result := run_type_memory;
	 else
	    eh.cancel;
	    if run_type.is_a(rto) then
	       Result := rto;
	    else
	       eh.cancel;
	       if rto.is_generic then
		  Result := type_any;
		  -- *** PAS FIN DU TOUT ;-)
		  -- *** FAIRE COMME DANS TYPE_CLASS.
	       else
		  Result := rto.smallest_ancestor(Current);
	       end;
	    end;
	 end;
      end;
   
   is_a(other: TYPE): BOOLEAN is
      local
	 i: INTEGER;
	 t1, t2: TYPE;
      do
	 if other.is_none then
	 elseif run_class = other.run_class then
	    Result := true;
	 elseif other.is_generic then
	    if base_class = other.base_class then
	       from
		  Result := true;
		  i := generic_list.upper
	       until
		  not Result or else i = 0
	       loop
		  t1 := generic_list.item(i).run_type;
		  t2 := other.generic_list.item(i).run_type;
		  if t1.is_a(t2) then
		     i := i - 1;
		  else
		     Result := false;
		     eh.append(fz_bga);
		  end;
	       end;
	    elseif base_class.is_subclass_of(other.base_class) then
	       Result := base_class.is_a_vncg(Current,other);
	    end;
	 else
	    check
	       not other.is_generic;
	    end;
	    if base_class.is_subclass_of(other.base_class) then
	       Result := true;
	    end;
	 end;
	 if not Result then
	    eh.add_type(Current,fz_inako);
	    eh.add_type(other," (TYPE_GENERIC).");
	 end;
      end;
   
   start_position: POSITION is
      do
	 Result := base_class_name.start_position;
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

   has_creation(fn: FEATURE_NAME): BOOLEAN is
      do
	 Result := base_class.has_creation(fn);
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

feature {NONE}

   basic_checks is
      local
	 bc: BASE_CLASS;
	 fgl: FORMAL_GENERIC_LIST;
      do
	 bc := base_class;
	 fgl := bc.formal_generic_list;
	 if fgl = Void then
	    eh.add_position(start_position);
	    eh.append(bc.base_class_name.to_string);
	    fatal_error(" is not a generic class.");
	 elseif fgl.count /= generic_list.count then
	    eh.add_position(start_position);
	    eh.add_position(fgl.start_position);
	    fatal_error(fz_bnga);
	 end;
      end;

feature {TYPE_GENERIC}

   set_run_type_memory(rt: like Current) is
      require
	 rt /= Void
      do
	 run_type_memory := rt;
      ensure
	 run_type_memory = rt
      end;

feature {NONE}

   tmp_mark: STRING is
      once
	 !!Result.make(16);
      end;

feature {TYPE}

   frozen short_hook is
      local
	 i: INTEGER;
      do
	 short_print.a_class_name(base_class_name);
	 short_print.hook_or("open_sb","[");
	 from
	    i := 1;
	 until
	    i > generic_list.count
	 loop
	    generic_list.item(i).short_hook;
	    if i < generic_list.count then
	       short_print.hook_or("tm_sep",",");
	    end;
	    i := i + 1;
	 end;
	 short_print.hook_or("close_sb","]");
      end;
        
end -- TYPE_GENERIC

