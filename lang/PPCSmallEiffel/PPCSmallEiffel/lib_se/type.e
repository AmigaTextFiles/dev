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
deferred class TYPE
--
-- Handling of an Eiffel type mark.
--
-- Handling of Eiffel kernel classes :
--   
--      Type Mark         |         Handle by Class
--      -------------------------------------------
--      BOOLEAN           |            TYPE_BOOLEAN 
--      CHARACTER         |          TYPE_CHARACTER 
--      INTEGER           |            TYPE_INTEGER 
--      REAL              |               TYPE_REAL 
--      DOUBLE            |             TYPE_DOUBLE 
--      POINTER           |            TYPE_POINTER
--      NONE              |               TYPE_NONE
--      ANY               |                TYPE_ANY
--      STRING            |             TYPE_STRING
--      ARRAY[FOO]        |              TYPE_ARRAY
--      NATIVE_ARRAY[BAR] |       TYPE_NATIVE_ARRAY
--      BIT 45            |              TYPE_BIT_1
--      BIT Foo           |              TYPE_BIT_2 
--   
-- Handling of other classes :
--
--      TYPE_CLASS : when original type mark is not generic, 
--            not outside expanded and it is not a formal 
--            generic argument. Thus, this is the most common 
--            case.
--
--      TYPE_FORMAL_GENERIC : when original declaration type mark
--            is a formal generic argument.
--
--      TYPE_LIKE_CURRENT : when written `like Current'
--
--      TYPE_LIKE_FEATURE : `like' <feature_name>
--
--      TYPE_LIKE_ARGUMENT : `like' <argument>
--
--      TYPE_EXPANDED : when original type is outside expanded (for
--            example when written   `foo : expanded BAR').
--
--      TYPE_GENERIC : when original type is generic, is not ARRAY,
--            not NATIVE_ARRAY and is not outside expanded.
--
--      TYPE_BIT_REF : corresponding reference type for TYPE_BIT.
--
   
inherit GLOBALS redefine fill_tagged_out_memory end; 
   
feature
   
   written_mark: STRING is
	 -- The original written type mark (what's in the source code).
      deferred
      ensure
	 Result = unique_string.item(Result)
      end;
   
   start_position: POSITION is
      -- Of the written mark.
      deferred
      end;
   
   frozen written_in: CLASS_NAME is
      do
	 if start_position /= Void then
	    Result := start_position.base_class_name;
	 end;
      end;
      
   frozen pretty_print is
      do
	 fmt.put_string(written_mark);
      end;

   frozen short is
      do
	 short_print.hook("Btm");
	 short_hook;
	 short_print.hook("Atm");
      end;
   
   is_anchored: BOOLEAN is
	 -- Is it written "like ..." ?
      do
      end;
   
   is_like_feature: BOOLEAN is
	 -- Is it written "like <feature>" ?
      do
      ensure
	 Result implies is_anchored
      end;
   
   is_like_current: BOOLEAN is
	 -- Is it written "like Current" ?
      do
      ensure
	 Result implies is_anchored
      end;
   
   is_generic: BOOLEAN is
	 -- Is the written type a generic type ?
      deferred
      ensure
	 is_array implies Result
      end;

   is_formal_generic: BOOLEAN is      
	 -- Is it a formal generic argument ?
      do
      end;
	 
feature 
   
   is_run_type: BOOLEAN is
	 -- True when the running type is known (ie, when anchors 
	 -- are computed and when formal generic names are 
	 -- substitutes with real class names.
      deferred
      ensure
	 Result implies run_type /= Void
      end;
   
feature  -- Working with the run TYPE :
   
   run_type: TYPE is
	 -- Corresponding running type mark. 
      require
	 is_run_type;
      deferred
      ensure
	 Result.run_type = Current;
      end;
   
   is_expanded: BOOLEAN is
      require
	 is_run_type
      deferred
      ensure
	 Result implies not is_reference
      end;
   
   is_reference: BOOLEAN is
      require
	 is_run_type
      deferred
      ensure
	 Result implies not is_expanded
      end;
   
   like_feature: FEATURE_NAME is
      require
	 is_like_feature
      do
      ensure
	 Result /= Void
      end;
   
   generic_list: ARRAY[TYPE] is
	 -- Assume this is really a generic type, otherwise, print
	 -- a fatal error message with `fatal_error_generic_list'.
      deferred
      ensure
	 Result.lower = 1;
	 not Result.empty
      end;

   run_time_mark: STRING is
	 -- The corresponding type mark at execution time.
      require
	 is_run_type
      deferred
      ensure
	 Result = unique_string.item(Result)
      end;
   
   is_boolean: BOOLEAN is 
      require
	 is_run_type;
      do 
      end;
   
   is_character: BOOLEAN is
      require
	 is_run_type;
      do
      end;
   
   is_integer: BOOLEAN is
      require
	 is_run_type;
      do
      end;
   
   is_real: BOOLEAN is
      require
	 is_run_type;
      do
      end;
   
   is_double: BOOLEAN is
      require
	 is_run_type;
      do
      end;

   is_string: BOOLEAN is
      require
	 is_run_type;
      do
      end;
   
   is_array: BOOLEAN is
      require
	 is_run_type;
      do
      ensure
	 Result implies generic_list.count = 1
      end;

   is_bit: BOOLEAN is
      require
	 is_run_type;
      do
      end;

   is_any: BOOLEAN is
      require
	 is_run_type;
      do
      end;
   
   is_none: BOOLEAN is
      require
	 is_run_type;
      do
      end;
   
   is_pointer: BOOLEAN is
      require
	 is_run_type;
      do
      end;
   
   is_basic_eiffel_expanded: BOOLEAN is
	 -- True for BOOLEAN, CHARACTER, INTEGER, REAL, DOUBLE
	 -- and POINTER. 
	 -- Note : all those type have the corresponding foo_REF 
	 -- class with the `item' attribute.
      require
	 is_run_type
      deferred
      end;

feature  
   
   base_class_name: CLASS_NAME is
      require
	 is_run_type;
      deferred
      ensure
	 Result /= Void
      end;
   
   to_runnable(ct: TYPE): like Current is
	 -- Compute the run time mark when the receiver is 
	 -- written in `ct'.  
	 -- Example : INTEGER always gives INTEGER. 
	 --           `like Current' gives `ct'.
	 --           ...
      require
	 ct.run_type = ct
      deferred
      ensure
	 no_errors implies written_mark = Result.written_mark;
	 no_errors implies start_position = Result.start_position;
	 no_errors implies Result.run_type = Result.run_type.run_type
      end;
   
   frozen base_class: BASE_CLASS is
      local
	 bcn: CLASS_NAME;
      do
	 bcn := base_class_name;
	 if bcn /= Void then
	    Result := bcn.base_class;
	 else
	    eh.append("Cannot find Base Class for ");
	    eh.add_type(Current,fz_dot);
	    eh.print_as_fatal_error;
	 end;
      end;
   
   frozen path: STRING is
      -- Of the corresponding `base_class'.
      do
	 Result := base_class.path;
      end;
   
feature
   
   is_a(other: TYPE): BOOLEAN is
	 -- Type conformance checking. 
	 -- Is the receiver a kind of `other' ?
	 --
	 -- When false, `eh' is filled if needed with the corresponding 
	 -- bad types, but the error report is not printed for the caller 
	 -- to add some comments or for the caller to cancel `eh'.
	 --
      require
	 is_run_type;
	 other.is_run_type;
	 nb_errors = 0 implies empty_eh_check
      deferred
      ensure
	 nb_errors = old nb_errors;
	 not Result implies not eh.empty;
	 Result implies empty_eh_check
      end;
   
   frozen is_a_in(other: TYPE; rc: RUN_CLASS): BOOLEAN is
	 -- Is the written type mark `other' interpreted in `rc' 
	 -- is a kind of Current written type mark interpreted in `rc' ?
      require
	 other /= Void;
	 rc /= Void;
	 nb_errors = 0 implies empty_eh_check
      local
	 t1, t2, ct: TYPE;
      do
	 if written_mark = other.written_mark then
	    Result := true;
	 else
	    ct := rc.current_type;
	    t1 := to_runnable(ct); -- ** Memory LEAKS 
	    t2 := other.to_runnable(ct); -- ** Memory LEAKS 
	    if t1.run_time_mark = t2.run_time_mark then
	       Result := true;
	    else
	       Result := t1.is_a(t2);
	    end;
	 end;
      end;
      
   has_creation(fn: FEATURE_NAME): BOOLEAN is
	 -- Is `fn' the name of procedure of creation.
      require
	 fn.start_position /= Void;
	 is_run_type;
      deferred
      end;
   
   smallest_ancestor(other: TYPE): TYPE is
	 -- Return the smallest common ancestor.
      require
	 is_run_type;
	 other.is_run_type;
	 nb_errors = 0 implies empty_eh_check
      deferred
      ensure
	 Result.run_type = Result;
	 Current.is_a(Result);
	 other.is_a(Result);
	 nb_errors = 0 implies empty_eh_check
      end;
   
   run_class: RUN_CLASS is
      require
	 is_run_type
      deferred
      end;
   
   frozen at_run_time: BOOLEAN is
      require
	 is_run_type
      do
	 Result := run_type.run_class.at_run_time;
      end;

   expanded_initializer: RUN_FEATURE_3 is
	 -- Non Void when it is an `is_user_expanded' with a user
	 -- creation procedure.
      require
	 is_run_type
      deferred
      end;
   
feature 

   c_header_pass1 is
      require
	 cpp.on_h;
	 run_class.at_run_time
      deferred
      ensure
	 cpp.on_h
      end;

   c_header_pass2 is
      require
	 cpp.on_h;
	 run_class.at_run_time
      deferred
      ensure
	 cpp.on_h
      end;

   c_header_pass3 is
      require
	 cpp.on_h;
	 run_class.at_run_time
      deferred
      ensure
	 cpp.on_h
      end;

   c_header_pass4 is
      require
	 cpp.on_h;
	 run_class.at_run_time
      deferred
      ensure
	 cpp.on_h
      end;

feature {NONE}

   frozen standard_c_typedef is
      require
	 cpp.on_h;
	 run_class.at_run_time
      local 
	 mem_id: INTEGER;
      do
	 mem_id := id;
	 tmp_string.clear;
	 if need_c_struct then
	    tmp_string.append(fz_typedef);
	    tmp_string.append(fz_struct);
	    tmp_string.extend('S');
	    mem_id.append_in(tmp_string);
	    tmp_string.extend(' ');
	    tmp_string.extend('T');
	    mem_id.append_in(tmp_string);
	    tmp_string.append(fz_00);
	 elseif is_dummy_expanded then
	    tmp_string.append(fz_typedef);
	    tmp_string.append(fz_int);
	    tmp_string.extend(' ');
	    tmp_string.extend('T');
	    mem_id.append_in(tmp_string);
	    tmp_string.append(fz_00);
	 elseif is_reference then
	    tmp_string.append(fz_typedef);
	    tmp_string.append(fz_void);
	    tmp_string.extend('*');
	    tmp_string.extend('T');
	    mem_id.append_in(tmp_string);
	    tmp_string.append(fz_00);
	 end;
	 cpp.put_string(tmp_string);
      ensure
	 cpp.on_h
      end;

feature {NONE}
   
   frozen standard_c_struct is
	 -- Produce C code for the standard C struct (for user's
	 -- expanded or reference as well).
      require
	 run_type = Current;
	 need_c_struct;
	 cpp.on_h
      local
	 wa: ARRAY[RUN_FEATURE_2];
	 i, mem_id: INTEGER;
	 a: RUN_FEATURE_2;
	 t: TYPE;
      do
	 mem_id := id;
	 wa := run_class.writable_attributes;
	 tmp_string.copy(fz_struct);
	 tmp_string.extend('S');
	 mem_id.append_in(tmp_string);
	 tmp_string.extend('{');
	 if is_reference then
	    if run_class.is_tagged then
	       tmp_string.append("int id;");
	    end;
	 end;
	 if wa /= Void then
	    from
	       i := wa.upper;
	    until
	       i = 0
	    loop
	       a := wa.item(i);
	       t := a.result_type.run_type;
	       t.c_type_for_result_in(tmp_string);
	       tmp_string.extend(' ');
	       tmp_string.extend('_');
	       tmp_string.append(a.name.to_string);
	       tmp_string.extend(';');
	       i := i - 1;
	    end;
	 end;
	 tmp_string.extend('}');
	 tmp_string.append(fz_00);
	 cpp.put_string(tmp_string);
	 if is_expanded then
	    -- For expanded comparison :
	    tmp_string.copy(fz_int);
	    tmp_string.extend(' ');
	    tmp_string.append(fz_se_cmpt);
	    mem_id.append_in(tmp_string);
	    tmp_string.append("(T");
	    mem_id.append_in(tmp_string);
	    tmp_string.append(" o1,T");
	    mem_id.append_in(tmp_string);
	    tmp_string.append(" o2)");
	    cpp.put_c_function(tmp_string,
	    "return memcmp(&o1,&o2,sizeof(o1));");
	 end;
      ensure	 
	 cpp.on_h
      end;

   frozen standard_c_object_model is
	 -- Produce C code to define the model object.
      require
	 run_type = Current;
	 need_c_struct;
	 cpp.on_h
      local
	 wa: ARRAY[RUN_FEATURE_2];
	 i, mem_id: INTEGER;
	 rc: RUN_CLASS;
      do
	 rc := run_class;
	 mem_id := rc.id;
	 wa := rc.writable_attributes;
	 tmp_string.copy(fz_extern);
	 tmp_string.extend('T');
	 mem_id.append_in(tmp_string);
	 tmp_string.extend(' ');
	 tmp_string.extend('M');
	 mem_id.append_in(tmp_string);
	 tmp_string.append(fz_00);
	 cpp.put_string(tmp_string);
	 cpp.swap_on_c;
	 tmp_string.clear;
	 tmp_string.extend('T');
	 mem_id.append_in(tmp_string);
	 tmp_string.extend(' ');
	 tmp_string.extend('M');
	 mem_id.append_in(tmp_string);
	 tmp_string.extend('=');
	 rc.c_object_model_in(tmp_string);
	 tmp_string.append(fz_00);
	 cpp.put_string(tmp_string);
	 cpp.swap_on_h;
      ensure	 
	 cpp.on_h
      end;

feature
      
   id: INTEGER is
	 -- All `at_run_time' has a Tid C type.
      require
	 is_run_type;
      deferred
      ensure
	 Result > 0
      end;

   is_dummy_expanded: BOOLEAN is
	 -- True when is it a user's expanded type with no attribute.
      require
	 is_run_type;
	 small_eiffel.is_ready
      deferred
      end;

   is_user_expanded: BOOLEAN is
	 -- Is it really a user expanded type ?
      require
	 is_run_type
      deferred
      end;

   c_type_for_argument_in(str: STRING) is
	 -- Append in `str' the C type to use when current 
	 -- Eiffel type is used for an argument of a feature.
      require
	 small_eiffel.is_ready;
	 str /= Void
      deferred
      end;

   c_type_for_target_in(str: STRING) is
	 -- Append in `str' the C type to use when current 
	 -- Eiffel type is used for an argument of a feature.
      require
	 small_eiffel.is_ready;
	 str /= Void
      deferred
      end;

   c_type_for_result_in(str: STRING) is
	 -- Append in `str' the C type to use when current Eiffel 
	 -- type is used as a result type of a C function.
      require
	 small_eiffel.is_ready;
	 str /= Void
      deferred
      end;

   frozen c_type_for_external_in(str: STRING) is
      do
	 if is_reference then
	    str.append(fz_void);
	    str.extend('*');
	 else
	    c_type_for_result_in(str);
	 end;
      end;

   frozen mapping_cast is
	 -- Produce a C cast for conversion into current C type.
      require
	 is_run_type;
	 run_type.run_class.at_run_time
      do
	 tmp_string.clear;
	 tmp_string.extend('(');
	 c_type_for_target_in(tmp_string);
	 tmp_string.extend(')');
	 cpp.put_string(tmp_string);
      end;
   
   cast_to_ref is
	 -- Produce the good C cast to use INTEGER_REF, BOOLEAN_REF,
	 -- CHARACTER_REF, REAL_REF or DOUBLE_REF.
      require
	 is_run_type;
	 is_basic_eiffel_expanded
      do
	 run_type.cast_to_ref;
      end;
   
   used_as_reference is
	 -- Do what's to be done when current expanded type 
	 -- is used as a reference.
      require
	 run_type = Current;
	 is_expanded
      do
      end;
   
   to_reference is
	 -- Print the C name of the automatic conversion function. 
      require
	 is_run_type;
	 is_expanded;
	 small_eiffel.is_ready
      do
      end;
   
   to_expanded is
	 -- Print the C name of the automatic conversion function. 
      require
	 is_run_type;
	 is_reference;
	 small_eiffel.is_ready
      do
      end;

   need_c_struct: BOOLEAN is
	 -- Is it necessary to define a C struct ?
      require
	 small_eiffel.is_ready
      deferred
      end;

   space_for_variable: INTEGER is
	 -- In number of bytes.
      require
	 is_run_type
      deferred
      ensure
	 Result >= 1
      end;

   space_for_object: INTEGER is
	 -- In number of bytes.
      require
	 is_run_type
      deferred
      ensure
	 Result >= 0
      end;

   c_initialize is
	 -- *** VIRER POUR PASSER en `c_initialize_in' ???????
	 -- Produce C code for initialisation of local variables
	 -- or attributes.
      require
	 is_run_type;
	 small_eiffel.is_ready
      deferred
      end;

   c_initialize_in(str: STRING) is
	 -- In order to initialize local variables or attributes
	 -- with the default simple value (0, NULL, 0.0, etc.).
      require
	 is_run_type;
	 small_eiffel.is_ready
      deferred
      end;

feature {NONE}

   frozen space_for_pointer: INTEGER is
      require
	 is_run_type
      local
	 p: POINTER;
      do
	 Result := p.object_size;
      end;

   frozen space_for_integer: INTEGER is
      require
	 is_run_type
      do
	 Result := (1).object_size;
      end;

   frozen standard_space_for_object: INTEGER is
	 -- In number of bytes.
      require
	 is_run_type
      local
	 rc: RUN_CLASS;
	 wa: ARRAY[RUN_FEATURE_2];
	 a: RUN_FEATURE_2;
	 i: INTEGER;
      do
	 rc := run_class;
	 if rc.is_tagged then
	    Result := space_for_integer;
	 end;
	 wa := rc.writable_attributes;
	 if wa /= Void then
	    from
	       i := wa.upper;
	    until
	       i = 0
	    loop
	       a := wa.item(i);
	       Result := Result + a.result_type.space_for_variable;
	       i := i - 1;
	    end;
	 end;
      end;

feature 

   need_gc_mark_function: BOOLEAN is
      deferred
      end;
   
feature {RUN_CLASS,TYPE}

   gc_define1 is
	 -- Define prototypes and C struct for the Garbage Collector
      require
	 gc_handler.is_on;
	 cpp.on_h;
	 run_class.at_run_time
      deferred
      end;

   gc_define2 is
	 -- Define C functions for the Garbage Collector
      require
	 gc_handler.is_on;
	 cpp.on_c;
	 run_class.at_run_time
      deferred
      end;

   gc_initialize is
	 -- Produce code to initialize GC in the main C function.
      require
	 gc_handler.is_on;
	 run_class.at_run_time
      deferred
      end;

   gc_info_in(str: STRING) is
	 -- Produce C code to print GC information.
      require
	 gc_handler.is_on;
	 gc_handler.info_flag;
	 run_class.at_run_time
      deferred
      end;

   call_gc_sweep_in(str: STRING) is
      require
	 gc_handler.is_on;
	 run_class.at_run_time
      deferred
      end;

feature {NONE}

   standard_call_gc_sweep_in(str: STRING) is
      require
	 gc_handler.is_on;
	 run_class.at_run_time
      do
	 str.append(fz_gc_sweep);
	 id.append_in(str);
	 str.extend('(');
	 str.extend(')');
	 str.append(fz_00);
      end;

feature {NATIVE_SMALL_EIFFEL,MANIFEST_STRING_POOL}

   gc_call_new_in(str: STRING) is
      do
	 str.append(fz_new);
	 id.append_in(str);
	 str.extend('(');
	 str.extend(')');
      end;
   
feature

   jvm_method_flags: INTEGER is
	 -- Return the appropriate flag (static/virtual) when the
	 -- receiver has this type.
      deferred
      end;

   frozen jvm_stack_space: INTEGER is
      require
	 is_run_type
      do
	 if is_double then -- *** LONG *** virer frozen ****
	    Result := 2;
	 else
	    Result := 1;
	 end;
      ensure
	 Result >= 1
      end;

   jvm_descriptor_in(str: STRING) is
	 -- Append the JVM type descriptor in `str'.
	 -- For arguments and Result only.
      require
	 str /= Void;
	 run_class.at_run_time
      deferred
      end;

   jvm_target_descriptor_in(str: STRING) is
	 -- Append the JVM type descriptor in `str'.
	 -- For target only.
      require
	 str /= Void;
	 run_class.at_run_time
      deferred
      end;

   jvm_return_code is
	 -- Add the good JVM opcode to return Result. 
      require
	 run_type = Current
      deferred
      end;

   jvm_push_local(offset: INTEGER) is
	 -- Push value of the local variable at `offset'.
      deferred
      end;

   jvm_push_default: INTEGER is
	 -- Push the default value for the Current type.
	 -- Result gives the space in the JVM stack;
      deferred
      end;

   jvm_initialize_local(offset: INTEGER) is
	 -- Initialize the local variable at `offset'.
      deferred
      end;

   jvm_write_local(offset: INTEGER) is
	 -- Write the local variable at `offset' using the stack top.
      deferred
      end;

   jvm_check_class_invariant is
	 -- If needed, add some byte code to check the class invariant 
	 -- of the pushed object.
      deferred
      end;

   jvm_xnewarray is
      deferred
      end;

   jvm_xastore is
      deferred
      end;

   jvm_xaload is
      deferred
      end;

   jvm_if_x_eq: INTEGER is
	 -- Assume two operands of the same type are pushed.
      deferred
      end;

   jvm_if_x_ne: INTEGER is
	 -- Assume two operands of the same type are pushed.
      deferred
      end;

   jvm_convert_to(destination: TYPE): INTEGER is
	 -- Convert the pushed value (which is an object of 
	 -- the current type) into an object of `destination'
	 -- type. 
	 -- Assume current type is conform to `destination'.
      require
	 conversion_check(destination)
      deferred
      ensure
	 Result >= 1
      end;

feature {NONE} 

   frozen standard_jvm_check_class_invariant is
      do
	 if run_control.invariant_check then
	    run_class.jvm_check_class_invariant;
	 end;
      end;

   conversion_check(other: TYPE): BOOLEAN is
      do
	 if is_a(other) then
	    Result := true;
	 else
	    eh.cancel;
	    if other.is_a(Current) then
	       Result := true;
	    end;
	 end;
      end;

feature {TYPE}
   
   jvm_to_reference is
	 -- If needed, convert the pushed value into the 
	 -- corresponding reference type.
      deferred
      end;

   jvm_to_expanded: INTEGER is
	 -- If needed, convert the pushed value into the
	 -- corresponding expanded type;
      deferred
      ensure
	 Result >= 1
      end;

feature {NONE} 
   
   c_initialize_expanded is
      require
	 is_user_expanded or is_dummy_expanded
      local
	 wa: ARRAY[RUN_FEATURE_2];
	 i: INTEGER;
	 rf: RUN_FEATURE_2;
      do
	 if is_dummy_expanded then
	    cpp.put_character('0');
	 else
	    cpp.put_character('{');
	    wa := run_class.writable_attributes;
	    from  
	       i := wa.upper;
	    until
	       i = 0
	    loop
	       rf := wa.item(i);
	       rf.result_type.c_initialize;
	       i := i - 1;
	       if i > 0 then
		  cpp.put_character(',');
	       end;
	    end;
	    cpp.put_character('}');
	 end;
      end;

feature {PARENT,TYPE}
      
   frozen look_up_for(rc: RUN_CLASS; fn: FEATURE_NAME): E_FEATURE is
      -- Look for the good one to compute `rc' X `fn'.
      require
	 rc /= Void;
	 fn /= Void;
	 not is_anchored;
	 not is_formal_generic;
      do
	 Result := base_class.look_up_for(rc,fn);
      end;
   
feature  -- Object Printing :

   frozen fill_tagged_out_memory is
      local
	 p: POSITION;
	 wm, rtm: STRING;
      do
	 p := start_position;
	 if p /= Void then
	    p.fill_tagged_out_memory;
	 end;
	 tagged_out_memory.append(" wm=");
	 wm := written_mark;
	 if wm /= Void then
	    tagged_out_memory.append(wm);
	 else
	    tagged_out_memory.append("??");
	 end;
	 if is_run_type then
	    rtm := run_time_mark;
	    if rtm /= Void then
	       tagged_out_memory.append(" rtm=");
	       tagged_out_memory.append(rtm);
	    end;
	 end;
      end;

feature {RUN_CLASS}

   frozen demangling_in(str: STRING) is
      do 
	 if is_reference then
	    str.extend('R');
	 else 
	    str.extend('E');
	 end;
	 str.extend(' ');
	 str.append(run_time_mark);
      end;

feature {NONE}

   tmp_string: STRING is
      once
	 !!Result.make(256);
      end;

   header: STRING is
      once
	 !!Result.make(256);
      end;

   body: STRING is
      once
	 !!Result.make(256);
      end;

feature {NONE}

   rtjvmdm: STRING is
      once
	 !!Result.make(32);
      end;

feature {TYPE}

   short_hook is
      deferred
      end;

feature {NONE}

   fatal_error_generic_list is
      do
	 check
	    not is_generic; 
	 end;
	 eh.add_type(Current," is (not) generic ?");
	 eh.print_as_fatal_error;
      end;

feature {NONE}

   frozen standard_gc_info_in(str: STRING) is
      do
	 -- Print gc_info_nbXXX :
	 str.append(fz_printf);
	 str.extend('(');
	 str.extend('%"');
	 str.append(run_time_mark);
	 str.append(fz_10);
	 gc_info_nb_in(str);
	 str.append(fz_14);
	 -- Print gcmt_usedXXX :
	 str.append(fz_printf);
	 str.extend('(');
	 str.extend('%"');
	 gcmt_used_in(str);
	 str.append(fz_10);
	 gcmt_used_in(str);
	 str.append(fz_14);
	 -- Print gcmt_maxXXX :
	 str.append(fz_printf);
	 str.extend('(');
	 str.extend('%"');
	 gcmt_max_in(str);
	 str.append(fz_10);
	 gcmt_max_in(str);
	 str.append(fz_14);
      end;

   frozen standard_gc_define1 is
	 -- For Fixed Size Objects.
      require
	 gc_handler.is_on;
	 cpp.on_h;
	 run_class.at_run_time
      local
	 rc: RUN_CLASS;
	 rcid: INTEGER;
      do
	 rc := run_class;
	 rcid := rc.id;
	 -- --------------- Define struct BXXX and typedef gcXXX :
	 tmp_string.copy(fz_typedef);
	 tmp_string.append(fz_struct);
	 tmp_string.extend('B');
	 rcid.append_in(tmp_string);
	 tmp_string.extend(' ');
	 tmp_string.append(fz_gc);
	 rcid.append_in(tmp_string);
	 tmp_string.append(fz_00);
	 tmp_string.append(fz_struct);
	 tmp_string.extend('B');
	 rcid.append_in(tmp_string);
	 tmp_string.append("{gcfsh header;T");
	 rcid.append_in(tmp_string);
	 tmp_string.append(" object;};%N");
	 cpp.put_string(tmp_string);
	 -- -------------------------------------- Declare gcmtXXX :
	 tmp_string.copy(fz_gc);
	 rcid.append_in(tmp_string);
	 tmp_string.extend('*');
	 tmp_string.extend('*');
	 gcmt_in(tmp_string);
	 cpp.put_extern1(tmp_string);
	 -- --------------------------------- Declare gcmt_usedXXX :
	 tmp_string.copy(fz_int);
	 tmp_string.extend(' ');
	 gcmt_used_in(tmp_string);
	 cpp.put_extern2(tmp_string,'0');
	 -- ---------------------------------- Declare gcmt_maxXXX :
	 tmp_string.copy(fz_int);
	 tmp_string.extend(' ');
	 gcmt_max_in(tmp_string);
	 cpp.put_extern2(tmp_string,'8');
	 -- ----------------------------------- Declare gc_freeXXX :
	 tmp_string.copy(fz_gc);
	 rcid.append_in(tmp_string);
	 tmp_string.extend('*');
	 gc_free_in(tmp_string);
	 cpp.put_extern5(tmp_string,fz_null);
	 -- -------------------------------- Declare gc_info_nbXXX :
	 if gc_handler.info_flag then
	    tmp_string.copy(fz_int);
	    tmp_string.extend(' ');
	    gc_info_nb_in(tmp_string);
	    cpp.put_extern2(tmp_string,'0');
	 end;
      end;

   frozen standard_gc_define2 is
      require
	 gc_handler.is_on;
	 cpp.on_c;
	 run_class.at_run_time
      local
	 rc: RUN_CLASS;
	 rcid: INTEGER;
      do
	 rc := run_class;
	 rcid := rc.id;
	 -- ------------------------------------- gc_sweep_poolXXX :
	 header.copy(fz_void);
	 header.extend(' ');
	 header.append(fz_gc_sweep_pool);
	 rcid.append_in(header);
	 header.extend('(');
	 header.append(fz_gc);
	 rcid.append_in(header);
	 header.extend('*');
	 header.extend('b');
	 header.extend(',');
	 header.append(fz_gc);
	 rcid.append_in(header);
	 header.extend('*');
	 header.extend('h');
	 header.extend(')');
	 body.copy("for(;b<=h;h--){%N");
	 gc_if_marked_in(body);
	 gc_set_unmarked_in(body);
	 body.extend('}');
         body.append(fz_else);
	 body.extend('%N');
	 gc_if_unmarked_in(body);
	 body.append(
	    "(h->header.next)=((gcfsh*)");
	 gc_free_in(body);
	 body.append(");%N");
	 gc_free_in(body);
	 body.append("=h;%N");
	 if need_c_struct then
	    body.append("h->object=M");
	    rcid.append_in(body);
	    body.append(fz_00);
	 end;
	 body.append("}}");
	 cpp.put_c_function(header,body);
	 -- ---------------------------- Definiton for gc_sweepXXX :
	 header.copy(fz_void);
	 header.extend(' ');
	 header.append(fz_gc_sweep);
	 rcid.append_in(header);
	 header.append(fz_c_void_args);
	 body.copy("int s;%Ngc");
	 rcid.append_in(body);
	 body.append("**p=");
	 gcmt_in(body);
	 body.extend('+');
	 gcmt_used_in(body);
	 body.append("-1;%Nfor(s=(1<<(");
	 gcmt_used_in(body);
	 body.append("-1));s>0");
	 body.append(";p--,s>>=1)%Ngc_sweep_pool");
	 rcid.append_in(body);
	 body.append("(*p,((*p)+s-1));%N");
	 cpp.put_c_function(header,body);
	 -- ----------------------------- Definiton for gc_markXXX :
	 header.copy(fz_void);
	 header.extend(' ');
	 gc_mark_in(header);
	 header.extend('(');
	 header.extend('T');
	 rcid.append_in(header);
	 header.extend('*');
	 header.extend('o');
	 header.extend(')');
	 body.clear;
	 gc_declare_h_in(body);
	 gc_if_unmarked_in(body);
	 gc_set_marked_in(body);
	 if rc.gc_mark_to_follow then
	    rc.gc_mark_in(body);
	 end;
	 body.extend('}');
	 cpp.put_c_function(header,body);
	 -- ----------------------- Definiton for gc_align_markXXX :
	 header.copy(fz_void);
	 header.extend(' ');
	 gc_align_mark_in(header);
	 header.extend('(');
	 header.extend('T');
	 rcid.append_in(header);
	 header.extend('*');
	 header.extend('o');
	 header.extend(',');
	 header.append(fz_gc);
	 rcid.append_in(header);
	 header.extend('*');
	 header.extend('B');
	 header.extend(')');
	 body.clear;
	 gc_declare_h_in(body);
	 body.append(
           "if(((((char*)h)-((char*)B))%%sizeof(*B))==0){%N%
	   %if(h->header.flag==GCFLAG_UNMARKED){%N");
	 gc_mark_in(body);
	 body.append("(o);%N}%N}%N");
	 cpp.put_c_function(header,body);
	 -- --------------------------- Definition for new_poolXXX :
	 header.copy(fz_void);
	 header.extend(' ');
	 header.append(fz_new_pool);
	 rcid.append_in(header);
	 header.append(fz_c_void_args);
	 body.copy("int u, s, i;%Ngc");
	 rcid.append_in(body);
	 body.append("*p,*h;%Nu=");
	 gcmt_used_in(body);
	 body.append(
            "++;%Ns=(1<<u);%N%
	    %p=calloc(s,sizeof(*p));%N%
	    %for(h=p+s-2;h>=p;h--)%N%
	    %(h->header.next)=((gcfsh*)(h+1));%N");
	 if rc.is_tagged then
	    body.append(
            "for(h=p+s-1;h>=p;h--)%N%
	    %(h->object.id)=");
	    rcid.append_in(body);
	    body.append(fz_00);
	 end;
	 body.append("if(u==");
	 gcmt_max_in(body);
	 body.append("){%N");
	 gcmt_max_in(body);
	 body.append("<<=1;%N");
	 gcmt_in(body);
	 body.append("=realloc(");
	 gcmt_in(body);
	 body.append(",(");
	 gcmt_max_in(body);
	 body.append("+1)*sizeof(void*));%N}%N");
	 gcmt_in(body);
	 body.append("[u]=p;%N");
	 gc_free_in(body);
	 body.append("=p;%N");
	 body.append(
            "if(gcmt_fs_used==gcmt_fs_max){%N%
	    %gcmt_fs_max<<=1;%N%
	    %gcmt_fs1=realloc(gcmt_fs1,(gcmt_fs_max+1)*sizeof(void*));%N%
	    %gcmt_fs2=realloc(gcmt_fs2,(gcmt_fs_max+1)*sizeof(void*));%N%
	    %gcmt_fsf=realloc(gcmt_fsf,(gcmt_fs_max+1)*sizeof(void*));%N%
	    %}%N%
	    %gcmt_fs1[gcmt_fs_used]=p;%N%
	    %gcmt_fs2[gcmt_fs_used]=(p+s);%N%
	    %gcmt_fsf[gcmt_fs_used]=((void*)");
         gc_align_mark_in(body);
	 body.append(
	    ");%N%
	    %for(i=(gcmt_fs_used++)-1;%
	    %(i>=0)&&(gcmt_fs1[i]>gcmt_fs1[i+1]);%
	    %i--){%N%
	    %h=gcmt_fs1[i];%N%
	    %gcmt_fs1[i]=gcmt_fs1[i+1];%N%
	    %gcmt_fs1[i+1]=h;%N%
	    %h=gcmt_fs2[i];%N%
	    %gcmt_fs2[i]=gcmt_fs2[i+1];%N%
	    %gcmt_fs2[i+1]=h;%N%
	    %h=((void*)gcmt_fsf[i]);%N%
	    %gcmt_fsf[i]=gcmt_fsf[i+1];%N%
	    %gcmt_fsf[i+1]=((void*)h);%N%
	    %}%N");
	 cpp.put_c_function(header,body);
	 -- --------------------------------- Definiton for newXXX :
	 header.clear;
	 header.extend('T');
	 rcid.append_in(header);
	 header.extend('*');
	 header.append(fz_new);
	 rcid.append_in(header);
	 header.append(fz_c_void_args);
	 body.copy(fz_gc);
	 rcid.append_in(body);
	 body.append("*h;%N");
	 if gc_handler.info_flag then
            gc_info_nb_in(body);
            body.append("++;%N");
         end;
         --
	 body.append("if((NULL==");
	 gc_free_in(body);
	 body.append(")&&(");
         gc_handler.threshold_start(rcid).append_in(body);
	 body.extend('<');
	 gcmt_used_in(body)
	 body.append(")) gc_start();%N");
         --
         body.append(fz_c_if_eq_null);
	 gc_free_in(body);
	 body.append(")new_pool");
	 rcid.append_in(body);
	 body.append("();%N%
		     %h=");
	 gc_free_in(body);
         body.append(";%N");
	 gc_free_in(body);
	 body.append("=((void*)(h->header.next));%N")
	 gc_set_unmarked_in(body);
	 body.append("return &(h->object);%N");
	 cpp.put_c_function(header,body);
      end;

   frozen standard_gc_initialize is
	 -- For Fixed Size objects.
      require
	 gc_handler.is_on;
	 cpp.on_c;
	 run_class.at_run_time
      do
	 tmp_string.clear;
	 -- Allocate gcmtXXX table:
	 gcmt_in(tmp_string);
	 tmp_string.append("=malloc(sizeof(void*)*(1+");
	 gcmt_max_in(tmp_string);
	 tmp_string.append(fz_16);
	 --
	 cpp.put_string(tmp_string);
      end;

   frozen gcmt_in(str: STRING) is
      do
	 str.append("gcmt");
	 id.append_in(str);
      end;

   frozen gcmt_max_in(str: STRING) is
      do
	 str.append("gcmt_max");
	 id.append_in(str);
      end;

   frozen gcmt_used_in(str: STRING) is
      do
	 str.append("gcmt_used");
	 id.append_in(str);
      end;

   frozen gc_free_in(str: STRING) is
      do
	 str.append("gc_free");
	 id.append_in(str);
      end;

   frozen gc_align_mark_in(str: STRING) is
      do
	 str.append("gc_align_mark");
	 id.append_in(str);
      end;

   frozen gc_info_nb_in(str: STRING) is
      do
	 str.append("gc_info_nb");
	 id.append_in(str);
      end;

feature {TYPE, GC_HANDLER}

   frozen gc_mark_in(str: STRING) is
      do
	 str.append(fz_gc_mark);
	 id.append_in(str);
      end;

feature {NONE}

   frozen gc_declare_h_in(str: STRING) is
      do
	 str.append(fz_gc);
	 id.append_in(str);
	 str.append("*h=((gc");
	 id.append_in(str);
	 str.append("*)(((gcfsh*)o)-1));%N");
      end;

   frozen gc_set_marked_in(str: STRING) is
      do
         str.append(
         "h->header.flag=GCFLAG_MARKED;%N");
      end;

   frozen gc_set_unmarked_in(str: STRING) is
      do
         str.append(
         "h->header.flag=GCFLAG_UNMARKED;%N");
      end;

   frozen gc_if_marked_in(str: STRING) is
      do
	 str.append(
         "if((h->header.flag)==GCFLAG_MARKED){%N");
      end;

   frozen gc_if_unmarked_in(str: STRING) is
      do
	 str.append(
         "if((h->header.flag)==GCFLAG_UNMARKED){%N");
      end;

invariant
   
   written_mark = unique_string.item(written_mark)
   
end -- TYPE

