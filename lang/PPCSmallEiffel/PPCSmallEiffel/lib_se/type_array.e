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
class TYPE_ARRAY
   -- 
   -- For ARRAY declaration :    ARRAY[INTEGER];
   --                            ARRAY[POINT];
   --                            ARRAY[G];
   --                            ARRAY[ARRAY[ANY]];
   --
   -- Note : can be implicit when used for the type of manifest
   --        arrays. 
   --

inherit TYPE redefine is_array end;
   
creation make

creation {TYPE_ARRAY} make_runnable
   
feature 
   
   base_class_name: CLASS_NAME;
	 -- Is always "ARRAY" but with the good `start_position'.
   
   generic_list: ARRAY[TYPE];
	 -- With exactely one element.
   
   written_mark: STRING;

   run_type: like Current;

   need_c_struct: BOOLEAN is true;

feature {NONE}
      
   make(sp: like start_position; of_what: TYPE) is
      require
	 of_what /= Void
      local
	 owwm: STRING;
      do
	 !!base_class_name.make(us_array,sp);
	 generic_list := <<of_what>>;
	 owwm := of_what.written_mark;
	 tmp_written_mark.copy(us_array);
	 tmp_written_mark.extend('[');
	 tmp_written_mark.append(owwm);
	 tmp_written_mark.extend(']');
	 written_mark := unique_string.item(tmp_written_mark);
      ensure
	 start_position = sp;
	 array_of = of_what
      end;
   
   make_runnable(sp: like start_position; of_what: TYPE) is
      require
	 of_what.run_type = of_what
      do
	 make(sp,of_what);
	 run_type := Current;
      ensure
	 is_run_type;
	 written_mark = run_time_mark
      end;

feature 
   
   is_generic: BOOLEAN is true;
   
   is_array: BOOLEAN is true;
   
   is_expanded: BOOLEAN is false;
   
   is_basic_eiffel_expanded: BOOLEAN is false;

   is_reference: BOOLEAN is true;
   
   is_dummy_expanded: BOOLEAN is false;

   is_user_expanded: BOOLEAN is false;

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
	 if is_run_type then
	    Result := small_eiffel.run_class(run_type);
	 end;
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
      end;

   c_header_pass4 is
      do
	 standard_c_struct;
	 standard_c_object_model;
      end;

   c_initialize is
      do
	 cpp.put_string(fz_null);
      end;

   c_initialize_in(str: STRING) is
      do
	 str.append(fz_null);
      end;

   array_of: TYPE is
      do
	 Result := generic_list.item(1);
      end;
   
   expanded_initializer: RUN_FEATURE_3 is
      do
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

   has_creation(fn: FEATURE_NAME): BOOLEAN is
      do
	 if Current = run_type then
	    Result := base_class.has_creation(fn);
	 else	    
	    Result := run_type.has_creation(fn);
	 end;
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
	 code_attribute.opcode_areturn;
      end;

   jvm_check_class_invariant is
      do
	 standard_jvm_check_class_invariant;
      end;

   jvm_push_local(offset: INTEGER) is
      do
	 code_attribute.opcode_aload(offset);
      end;

   jvm_push_default: INTEGER is
      do
	 code_attribute.opcode_aconst_null;
	 Result := 1;
      end;

   jvm_initialize_local(offset: INTEGER) is
      do
	 code_attribute.opcode_aconst_null;
	 jvm_write_local(offset);
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
	 Result := 1;
      end;

   jvm_convert_to(destination: TYPE): INTEGER is
      do
	 Result := 1;
      end;

   start_position: POSITION is
      do
	 Result := base_class_name.start_position;
      end;
   
   run_time_mark: STRING is
      do
	 if is_run_type then
	    Result := run_type.written_mark;
	 end;
      end;
   
   smallest_ancestor(other: TYPE): TYPE is
      local
	 rto, array_of1, array_of2, array_of3: TYPE;
      do
	 rto := other.run_type;
	 if rto.is_array then
	    array_of1 := array_of.run_type;
	    array_of2 := rto.generic_list.item(1);
	    array_of3 := array_of1.smallest_ancestor(array_of2);
	    if array_of3 = array_of1 then
	       Result := Current;
	    elseif array_of3 = array_of2 then
	       Result := other;
	    else
	       !TYPE_ARRAY!Result.make(Void,array_of3);
	    end;
	 else
	    Result := rto.smallest_ancestor(Current);
	 end;
      end;
   
   is_a(other: TYPE): BOOLEAN is
      do
	 if run_class = other.run_class then
	    Result := true;
	 elseif other.is_array then
	    Result := array_of.is_a(other.generic_list.item(1));
	    if not Result then
	       eh.extend(' ');
	       eh.add_type(Current,fz_inako);
	       eh.add_type(other,fz_dot);
	    end;
	 elseif base_class.is_subclass_of(other.base_class) then
	    if other.is_generic then
	       Result := base_class.is_a_vncg(Current,other);
	    else
	       Result := true;
	    end;
	 end;
	 if not Result then
	    eh.add_type(Current,fz_inako);
	    eh.add_type(other,fz_dot);
	 end;
      end;
   
   is_run_type: BOOLEAN is
      local
	 t: TYPE;
      do
	 if run_type /= Void then
	    Result := true;
	 else
	    t := generic_list.item(1);
	    if t.is_run_type and then t.run_type = t then
	       run_type := Current;
	       Result := true;
	    end;
	 end;
      end;
   
   to_runnable(ct: TYPE): like Current is 
      local
	 elt1, elt2: TYPE;
	 rt: like Current;
	 rc: RUN_CLASS;
      do
	 if run_type = Current then
	    Result := Current;
	 else
	    elt1 := generic_list.item(1);
	    elt2 := elt1.to_runnable(ct);
	    if elt2 = Void or else not elt2.is_run_type then
	       if elt2 /= Void then
		  eh.add_position(elt2.start_position);
	       end;
	       error(elt1.start_position,fz_bga);
	    end;
	    if nb_errors = 0 then
	       elt2 := elt2.run_type;
	       if run_type = Void then
		  Result := Current;
		  if elt2 = elt1 then
		     run_type := Current;
		     load_basic_features;	 
		  else
		     !!run_type.make_runnable(start_position,elt2);
		     run_type.load_basic_features;
		  end;
	       else
		  Result := twin;
		  !!rt.make_runnable(start_position,elt2);
		  Result.set_run_type(rt);
		  rt.load_basic_features;
	       end;	       
	    end;
	 end;
	 -- Access `run_class' :
	 rc := Result.generic_list.item(1).run_class;
	 rc := Result.run_class;
      end;
   
   id: INTEGER is
      do
	 Result := run_class.id;
      end;
   
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

feature {TYPE_ARRAY}
   
   set_run_type(t: like run_type) is
      do
	 run_type := t;
      end;

   load_basic_features is
	 -- Force some basic feature to be loaded.
      require
	 run_type = Current
      local
	 elt_type: TYPE;
	 rf: RUN_FEATURE;
	 rc: RUN_CLASS;
      do
	 elt_type := generic_list.item(1);
	 if elt_type.is_expanded then
	    elt_type.run_class.set_at_run_time;
	 end;
	 rc := run_class;
	 rf := rc.get_feature_with(us_capacity);
	 rf := rc.get_feature_with(us_lower);
	 rf := rc.get_feature_with(us_upper);
	 rf := rc.get_feature_with(us_storage);
      end;

feature {NONE}
   
   tmp_written_mark: STRING is
      once
	 !!Result.make(128);
      end;
   
feature {TYPE}

   frozen short_hook is
      do
	 short_print.a_class_name(base_class_name);
	 short_print.hook_or("open_sb","[");
	 generic_list.first.short_hook;
	 short_print.hook_or("close_sb","]");
      end;
        
invariant
   
   generic_list.count = 1;
   
   generic_list.lower = 1;
   
end -- TYPE_ARRAY


