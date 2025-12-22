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
class RUN_CLASS
   --
   -- Only for class with objects at execution time.
   --
   
inherit 
   GLOBALS
      redefine fill_tagged_out_memory
      end;
   
creation {SMALL_EIFFEL} make
   
feature
   
   current_type: TYPE;
	 -- Runnable corresponding one.
   
   id: INTEGER;
	 -- Id of the receiver to produce C code. 
   
   at_run_time: BOOLEAN;
	 -- True if `current_type' is really created (only when 
	 -- direct instances of `current_type' exists at run time).
   
   running: ARRAY[RUN_CLASS];
	 -- Void or the set of all `at_run_time' directly compatible 
	 -- run classes. A run class is directly compatible with one
	 -- another only when it can be directly substitute with 
	 -- current run class.
	 -- Thus, if current run class is reference, `running' are all 
	 -- reference run classes. If current run class is expanded, 
	 -- `running' has only one element (the current class itself).
   
   invariant_assertion: CLASS_INVARIANT;
	 -- Collected Runnable invariant if any.

   compile_to_c_done: BOOLEAN;
         -- True if `compile_to_c' has already be called.

feature {RUN_CLASS,RUN_FEATURE}
   
   feature_dictionary: DICTIONARY[RUN_FEATURE,STRING];
	 -- Access to the runnable version of a feature.
	 -- To avoid clash between infix and prefix names, 
	 -- `to_key' of class NAME is used as entry.
   
feature {NONE}

   tagged_mem: INTEGER;
	 -- 0 when not computed, 1 when tagged or -1

feature {NONE}
   
   make(t: like current_type) is
      require
	 t.run_type = t;
	 not small_eiffel.is_ready
      local
	 run_string: STRING;
	 rcd: DICTIONARY[RUN_CLASS,STRING];
	 rc: RUN_CLASS;
	 r: like runnable;
	 i: INTEGER;
      do
	 compile_to_c_done := true;
	 current_type := t;
	 !!actuals_clients.with_capacity(16);
	 run_string := t.run_time_mark;
	 id := id_provider.item(run_string);
	 check
	    not small_eiffel.run_class_dictionary.has(run_string);
	 end;
	 if small_eiffel.is_ready then
	    warning(Void,"Internal Warning #1 in RUN_CLASS.");
	 end;
	 if small_eiffel.run_class_dictionary.has(run_string) then
	    warning(Void,"Internal Warning #2 in RUN_CLASS.");
	 end;
	 small_eiffel.run_class_dictionary.put(Current,run_string);
	 !!feature_dictionary.with_capacity(64);
	 small_eiffel.incr_magic_count;
	 if t.is_expanded then
	    set_at_run_time;
	    t.base_class.check_expanded_with(t);
	 else
	    from
	       rcd := small_eiffel.run_class_dictionary;
	       i := 1;
	    until
	       i > rcd.count
	    loop
	       rc := rcd.item(i);
	       if rc.at_run_time and then 
		  rc.current_type.is_reference and then
		  rc.is_a(Current)
		then
		  add_running(rc);
	       end;
	       i := i + 1;
	    end;
	 end;
	 if run_control.invariant_check then
	    ci_collector.clear;
	    base_class.collect_invariant(Current);
	    r := runnable(ci_collector,current_type,Void);
	    if r /= Void then
	       !!invariant_assertion.from_runnable(r); 
	    end;
	 end;
      ensure
	 current_type = t;
      end;
   
feature

   is_tagged: BOOLEAN is
      require
	 small_eiffel.is_ready
      do
	 if tagged_mem = 0 then
	    if current_type.is_expanded then
	       tagged_mem := -1;
	    elseif at_run_time then 
	       if run_control.boost then
		  if small_eiffel.is_tagged(Current) then
		     tagged_mem := 1;
		  else
		     tagged_mem := -1;
		  end;
	       else
		  tagged_mem := 1;
	       end;
	    end;
	 end;
	 Result := tagged_mem = 1;
      ensure
	 tagged_mem /= 0
      end;
   
   is_expanded: BOOLEAN is
      do
	 Result := current_type.is_expanded;
      end;
   
   writable_attributes: ARRAY[RUN_FEATURE_2] is
	 -- Computed and ordered array of writable attributes.
	 -- Storage in C struct is to be done in reverse 
	 -- order (from `upper' to `lower').
	 -- Order is done according to the level of attribute 
	 -- definition in the inheritance graph to allow more 
	 -- stupid switch to be removed.
      require
	 small_eiffel.is_ready;
	 at_run_time
      local
	 rf2: RUN_FEATURE_2;
	 i: INTEGER;
      do
	 if writable_attributes_mem = Void then
	    from
	       i := 1;
	    until
	       i > feature_dictionary.count
	    loop
	       rf2 ?= feature_dictionary.item(i);
	       if rf2 /= Void then
		  if writable_attributes_mem = Void then
		     writable_attributes_mem := <<rf2>>;
		  else
		     writable_attributes_mem.add_last(rf2);
		  end;
	       end;
	       i := i + 1;
	    end;
	    if writable_attributes_mem /= Void then
	       sort_wam(writable_attributes_mem);
	    end;
	 end;
	 Result := writable_attributes_mem;
      ensure
	 Result /= Void implies Result.lower = 1
      end;
   
feature 
   
   get_rf(cpc: CALL_PROC_CALL): RUN_FEATURE is
	 -- Compute or simply fetch the corresponding RUN_FEATURE.
	 -- Exporting rules are automatically checked and possible
	 -- rename are also done using `start_position' of
	 -- `cpc.feature_name'.
	 -- No return when an error occurs because `fatal_error'
	 -- is called.
      require
	 cpc.target.is_checked;
	 cpc.target.result_type.run_class = Current;
      local
         target: EXPRESSION;
	 is_current: BOOLEAN;
	 fn1, fn2: FEATURE_NAME;
	 wbc, wbc2: BASE_CLASS;
	 trt, constraint: TYPE;
	 tfg: TYPE_FORMAL_GENERIC;
      do
	 target := cpc.target;
	 trt := target.result_type;
	 is_current := target.is_current;
	 fn1 := cpc.feature_name;
	 wbc := fn1.start_position.base_class;
	 if is_current or else trt.is_like_current then
	    fn2 := trt.base_class.new_name_of(wbc,fn1);
	    if fn2 /= fn1 then
	       eh.add_position(fn1.start_position);
	       Result := get_or_fatal_error(fn2);
	       eh.cancel;
	    else
	       Result := get_or_fatal_error(fn1);
	    end;
	 elseif trt.is_formal_generic then
	    tfg ?= trt;
	    check
	       tfg /= Void
	    end;
	    constraint := tfg.constraint;
	    if constraint = Void then
	       Result := get_or_fatal_error(fn1);
	    elseif not trt.is_a(constraint) then
	       eh.print_as_error;
	       eh.add_position(cpc.feature_name.start_position);
	       eh.append("Constraint genericity violation.");
	       eh.print_as_fatal_error;
	    else
	       wbc2 := constraint.start_position.base_class;
	       if wbc2 = wbc or else wbc.is_subclass_of(wbc2) then
		  fn2 := trt.base_class.new_name_of(constraint.base_class,fn1);
		  Result := get_or_fatal_error(fn2);
	       else
		  Result := get_or_fatal_error(fn1);
	       end;
	    end;
	 else
	    Result := get_or_fatal_error(fn1);
	 end;
	 Result.add_client(Current);
	 if nb_errors = 0 and then 
	    not is_current and then
	    not Result.is_exported_in(wbc.base_class_name) then
	    eh.add_position(Result.start_position);
	    eh.append(" Cannot use feature %"");
	    eh.append(fn1.to_string);
	    error(cpc.feature_name.start_position,"%" here.");
	 end;
      ensure
	 Result /= Void
      end;

   get_rf_with(fn: FEATURE_NAME): RUN_FEATURE is
	 -- Compute or simply fetch the corresponding RUN_FEATURE.
	 -- Possible rename are also done using `start_position' of
	 -- `fn'. No return when an error occurs because `fatal_error'
	 -- is called.
      require
	 base_class = fn.start_position.base_class or else
	 base_class.is_subclass_of(fn.start_position.base_class)
      local
	 fn2: FEATURE_NAME;
	 wbc: BASE_CLASS;
      do
	 wbc := fn.start_position.base_class;
	 fn2 := base_class.new_name_of(wbc,fn);
	 if fn2 /= fn then
	    eh.add_position(fn.start_position);
	    Result := get_or_fatal_error(fn2);
	    eh.cancel;
	 else
	    Result := get_or_fatal_error(fn2);
	 end;
      ensure
	 Result /= Void
      end;

   dynamic(up_rf: RUN_FEATURE): RUN_FEATURE is
	 -- Assume the current type of `up_rf' is a kind of 
	 -- `current_type'. The result is the concrete one
	 -- according to dynamic dispatch rules.
      require
	 up_rf /= Void;
	 Current.is_a(up_rf.run_class)
      local
	 fn, up_fn: FEATURE_NAME;
	 up_type: TYPE;
      do
	 up_type := up_rf.current_type;
	 if Current = up_type.run_class then
	    Result := up_rf;
	 else
	    up_fn := up_rf.name;
	    fn := base_class.new_name_of(up_type.base_class,up_fn);
	    Result := get_or_fatal_error(fn);
	 end;
      ensure
	 Result /= Void;
	 Result.run_class = Current;
      end;

feature
   
   base_class: BASE_CLASS is
	 -- Corresponding base class.
      do
	 Result := current_type.base_class;
      ensure
	 Result /= Void
      end;
   
   base_class_name: CLASS_NAME is
	 -- Corresponding base class name.
      do
	 Result := current_type.base_class_name;
      ensure
	 Result /= Void
      end;

feature 
   
   set_at_run_time is
	 -- Set Current `at_run_time' and do needed update of others 
	 -- instances of RUN_CLASS.
      require
	 not base_class.is_deferred;
	 empty_eh_check
      local
	 rcd: DICTIONARY[RUN_CLASS,STRING];
	 rc: RUN_CLASS;
	 i: INTEGER;
      do
	 if not at_run_time  then
	    at_run_time := true;
	    compile_to_c_done := false;
	    add_running(Current);
	    small_eiffel.incr_magic_count;
	    if current_type.is_reference then
	       from
		  rcd := small_eiffel.run_class_dictionary;
		  i := 1;
	       until
		  i > rcd.count
	       loop
		  rc := rcd.item(i);
		  if Current.is_a(rc) then
		     rc.add_running(Current);
		  end;
		  i := i + 1;
	       end;
	    end;
	 end;
      ensure
	 at_run_time;
	 running.has(Current);
	 empty_eh_check;
      end;
   
feature {TYPE}

   gc_mark_to_follow: BOOLEAN is
      require
	 at_run_time
      local
	 i: INTEGER;
	 r: like running;
	 rc: like Current;
      do
	 from
	    r := running;
	    i := r.upper;
	 until
	    Result or else i = 0
	 loop
	    rc := r.item(i);
	    if rc.at_run_time then
	       Result := rc.need_gc_mark;
	    end;
	    i := i - 1;
	 end;
      end;

   gc_mark_in(str: STRING) is
      require
	 gc_mark_to_follow
      local
	 i: INTEGER;
	 wa: ARRAY[RUN_FEATURE_2];
	 rf2: RUN_FEATURE_2;
      do
	 wa := writable_attributes;
	 if wa /= Void then
	    from
	       i := wa.upper;
	    until
	       i = 0
	    loop
	       rf2 := wa.item(i);
	       if rf2.result_type.run_class.at_run_time then
		  gc_handler.call_gc_mark(str,rf2);
	       end;
	       i := i - 1;
	    end;
	 end;
      end;
   
feature {TYPE}

   c_object_model_in(str: STRING) is
      local
	 wa: like writable_attributes;
	 i: INTEGER;
	 rf2: RUN_FEATURE_2;
	 t: TYPE;
      do
	 wa := writable_attributes;
	 if wa = Void then
	    if is_tagged then
	       str.extend('{');
	       id.append_in(str);
	       str.extend('}');
	    else
	       current_type.c_initialize_in(str);
	    end;
	 else
	    str.extend('{');
	    if is_tagged then
	       id.append_in(str);
	       str.extend(',');
	    end;
	    from
	       i := wa.upper;
	    until
	       i = 0
	    loop
	       rf2 := wa.item(i);
	       t := rf2.result_type;
	       t.c_initialize_in(str);
	       i := i - 1;
	       if i > 0 then
		  str.extend(',');
	       end;
	    end;
	    str.extend('}');
	 end;
      end;

feature {SMALL_EIFFEL}
   
   falling_down is
      -- Falling down of Current `feature_dictionary' in `running'.
      local
	 rf: RUN_FEATURE;
	 i: INTEGER;
      do
	 from
	    i := 1;
	 until
	    i > feature_dictionary.count
	 loop
	    rf := feature_dictionary.item(i);
	    rf.fall_down;
	    i := i + 1;
	 end;
      end;

   afd_check is
	 -- After Falling Down Check.
      local
	 rf: RUN_FEATURE;
	 i: INTEGER;
      do
	 from
	    i := 1;
	 until
	    i > feature_dictionary.count
	 loop
	    rf := feature_dictionary.item(i);
	    rf.afd_check;
	    i := i + 1;
	 end;
      end;

feature {SMALL_EIFFEL}

   c_header_pass1 is
      require
	 cpp.on_h
      do
	 if at_run_time then
	    current_type.c_header_pass1;
	 end;
      ensure
	 cpp.on_h
      end;
   
   c_header_pass2 is
      require
	 cpp.on_h
      do
	 if at_run_time then
	    current_type.c_header_pass2;
	 end;
      ensure
	 cpp.on_h
      end;
   
   c_header_pass3 is
      require
	 cpp.on_h
      do
	 if at_run_time then
	    current_type.c_header_pass3;
	 end;
      ensure
	 cpp.on_h
      end;
   
   c_header_pass4 is
      require
	 cpp.on_h
      do
	 if at_run_time then
	    current_type.c_header_pass4;
	 end;
      ensure
	 cpp.on_h
      end;
   
feature {GC_HANDLER}

   gc_define1 is
      require
	 gc_handler.is_on
      do
	 if at_run_time then
	    current_type.gc_define1;
	 end;
      end;
   
   gc_define2 is
      require
	 gc_handler.is_on
      do
	 if at_run_time then
	    current_type.gc_define2;
	 end;
      end;
   
   gc_info_in(str: STRING) is
	 -- Produce C code to print GC information.
      require
	 gc_handler.is_on;
	 gc_handler.info_flag
      do
	 if at_run_time then
	    current_type.gc_info_in(str);
	 end;
      end;

   call_gc_sweep_in(body: STRING) is
      require
	 gc_handler.is_on
      do
	 if at_run_time then
	    current_type.call_gc_sweep_in(body);
	 end;
      end;

   gc_initialize is
	 -- Produce code to initialize GC in the main C function.
      require
	 gc_handler.is_on
      do
	 if at_run_time then
	    current_type.gc_initialize;
	 end;
      end;

feature {RUN_CLASS}
   
   fill_up_with(rc: RUN_CLASS; fd: like feature_dictionary) is
	 -- Fill up `feature_dictionary' with all features coming from
	 -- `rc' X `fd'.
      require
	 rc /= Current;
	 is_a(rc);
	 fd /= Void;
      local
	 bc1, bc2: BASE_CLASS;
	 fn1, fn2: FEATURE_NAME;
	 rf: RUN_FEATURE;
	 i: INTEGER;
      do
	 from
	    i := 1;
	    bc1 := rc.base_class;
	    bc2 := base_class;
	 until
	    i > fd.count
	 loop
	    rf := fd.item(i);
	    if rf.fall_in(Current) then
	       fn1 := rf.name;
	       fn2 := bc2.name_of(bc1,fn1);
	       rf := get_feature(fn2);
	    end;
	    i := i + 1;
	 end;
      end;
   
   add_running(rc: RUN_CLASS) is
      require
	 rc /= Void;
      do
	 if running = Void then
	    running := <<rc>>;
	 else
	    if not running.fast_has(rc) then
	       running.add_last(rc);
	    end;
	 end;
      end;
   
   is_a(other: like Current): BOOLEAN is
	 -- Does not print an error message wathever the result can be.
      require
	 other /= Void;
	 empty_eh_check
      local
	 t1, t2: TYPE;
      do
	 if other = Current then
	    Result := true;
	 else
	    t1 := current_type;
	    t2 := other.current_type;
	    if t1.is_basic_eiffel_expanded and then 
	       t2.is_basic_eiffel_expanded then
	    else
	       Result := t1.is_a(t2);
	       if not Result then
		  eh.cancel;
	       end;
	    end;
	 end;
      ensure
	 empty_eh_check;
	 nb_errors = old nb_errors
      end;
   
feature 

   fill_tagged_out_memory is
      do
	 tagged_out_memory.append(current_type.run_time_mark);
      end;

feature {E_FEATURE}
   
   at(fn: FEATURE_NAME): RUN_FEATURE is
	 -- Simple look in the dictionary to see if the feature
	 -- is already computed.
      require
	 fn /= Void;
      local
	 to_key: STRING;
      do
	 to_key := fn.to_key;
	 if feature_dictionary.has(to_key) then
	    Result := feature_dictionary.at(to_key);
	 end;
      end;
   
feature 
   
   get_feature_with(n: STRING): RUN_FEATURE is
	 -- Assume that `fn' is really the final name in current 
	 -- RUN_CLASS. Don't look for rename.
	 -- Also assume that `n' is a SIMPLE_NAME.
      require
	 n /= Void;
      local
	 sfn: SIMPLE_FEATURE_NAME;
      do
	 if feature_dictionary.has(n) then
	    Result := feature_dictionary.at(n);
	 else
	    !!sfn.make(n,Void);
	    Result := get_feature(sfn);
	 end;
      end;

feature
   
   get_copy: RUN_FEATURE is
      do
	 Result := get_rf_with(class_general.get_copy.first_name);
      end;

feature 

   get_feature(fn: FEATURE_NAME): RUN_FEATURE is
	 -- Assume that `fn' is really the final name in current 
	 -- RUN_CLASS. Don't look for rename.
      require
	 fn /= Void
      local
	 f: E_FEATURE;
	 fn_key: STRING;
	 bc: BASE_CLASS;
      do
	 fn_key := fn.to_key;
	 if feature_dictionary.has(fn_key) then
	    Result := feature_dictionary.at(fn_key);
	 else
	    check 
	       not small_eiffel.is_ready;
	    end;
	    bc := base_class;
	    f := bc.look_up_for(Current,fn);
	    if f = Void then
	       efnf(bc,fn);
	    else
	       Result := f.to_run_feature(current_type,fn);
	       if Result /= Void  then
		  store_feature(Result);
	       else
		  efnf(bc,fn);
	       end;
	    end;
	 end;
      end;

feature {NONE}

   get_or_fatal_error(fn: FEATURE_NAME): RUN_FEATURE is
      do
	 Result := get_feature(fn);
	 if Result = Void then
	    eh.add_position(fn.start_position);
	    eh.append("Feature ");
	    eh.append(fn.to_string);
	    eh.append(" not found when starting look up from ");
	    eh.add_type(current_type,fz_dot);
	    eh.print_as_fatal_error;
	 end;
      end;
   
feature {NONE}
   
   store_feature(rf: like get_feature) is
	 -- To update the dictionary from outside.
	 -- Note : this routine is necessary because of recursive call.
      require
	 rf.run_class = Current
      local
	 rf_key: STRING;
      do
	 rf_key := rf.name.to_key;
	 if feature_dictionary.has(rf_key) then
	    check
	       feature_dictionary.at(rf_key) = rf
	    end;
	 else
	    feature_dictionary.put(rf,rf_key);
	    small_eiffel.incr_magic_count;
	 end;
      ensure
	 get_feature(rf.name) = rf
      end;

feature {JVM}

   jvm_define_class_invariant is
	 -- If needed, call the invariant for the pushed value.
      local
	 ia: like invariant_assertion;
      do
	 if run_control.invariant_check then
	    ia := invariant_assertion;
	    if ia /= Void then
	       jvm.define_class_invariant_method(ia);
	    end;
	 end;
      end;

feature {JVM,TYPE} 

   jvm_check_class_invariant is
	 -- If needed, call the invariant for the pushed value.
      local
	 ia: like invariant_assertion;
	 idx: INTEGER;
	 ca: like code_attribute;
	 cp: like constant_pool;
      do
	 if run_control.invariant_check then
	    ia := invariant_assertion;
	    if ia /= Void then
	       ca := code_attribute;
	       cp := constant_pool;
	       ca.opcode_dup;
	       idx := cp.idx_methodref3(fully_qualified_name,fz_invariant,fz_29);
	       ca.opcode_invokevirtual(idx,-1);
	    end;
	 end;
      end;

feature {SMALL_EIFFEL}

   compile_to_jvm is
      require
	 at_run_time
      local
	 i: INTEGER;
	 rf: RUN_FEATURE;
      do
	 echo.put_character('%T');
	 echo.put_string(current_type.run_time_mark);
	 echo.put_character('%N');
	 jvm.start_new_class(Current);
	 from
	    i := 1;
	 until
	    i > feature_dictionary.count
	 loop
	    rf := feature_dictionary.item(i);
	    jvm.set_current_frame(rf);
	    rf.jvm_field_or_method;
	    i := i + 1;
	 end;
	 jvm.prepare_fields;
	 jvm.prepare_methods;
	 jvm.finish_class;
      end;

feature {MANIFEST_ARRAY}

   fully_qualified_name: STRING is
      do
	 tmp_string.copy(jvm.output_name);
	 tmp_string.extend('/');
	 tmp_string.append(unqualified_name);
	 Result := tmp_string;
      end;

feature {RUN_FEATURE}

   jvm_invoke(idx, stack_level: INTEGER) is
      local
	 ct: like current_type;
      do
	 ct := current_type;
	 if ct.is_reference then
	    code_attribute.opcode_invokevirtual(idx,stack_level);
	 elseif ct.is_basic_eiffel_expanded then
	    code_attribute.opcode_invokestatic(idx,stack_level);
	 elseif writable_attributes = Void then
	    code_attribute.opcode_invokestatic(idx,stack_level);
	 else
	    code_attribute.opcode_invokevirtual(idx,stack_level);
	 end;
      end;

feature {TYPE}

   jvm_expanded_return_code is
      require
	 is_expanded
      do
	 if writable_attributes = Void then
	    code_attribute.opcode_ireturn;
	 else
	    code_attribute.opcode_areturn;
	 end;
      end;

   jvm_expanded_push_local(offset: INTEGER) is
      require
	 is_expanded
      do
	 if writable_attributes = Void then
	    code_attribute.opcode_iload(offset);
	 else
	    code_attribute.opcode_aload(offset);
	 end;
      end;
   
   jvm_expanded_write_local(offset: INTEGER) is
      require
	 is_expanded
      do
	 if writable_attributes = Void then
	    code_attribute.opcode_istore(offset);
	 else
	    code_attribute.opcode_astore(offset);
	 end;
      end;

   jvm_expanded_xastore is
      require
	 is_expanded
      do
	 if writable_attributes = Void then
	    code_attribute.opcode_bastore;
	 else
	    code_attribute.opcode_aastore;
	 end;
      end;
   
   jvm_expanded_xaload is
      require
	 is_expanded
      do
	 if writable_attributes = Void then
	    code_attribute.opcode_baload;
	 else
	    code_attribute.opcode_aaload;
	 end;
      end;
   
   jvm_expanded_if_x_eq: INTEGER is
      require
	 is_expanded
      do
	 if writable_attributes = Void then
	    Result := code_attribute.opcode_if_icmpeq;
	 else
	    Result := code_attribute.opcode_if_acmpeq;
	 end;
      end;
   
   jvm_expanded_if_x_ne: INTEGER is
      require
	 is_expanded
      do
	 if writable_attributes = Void then
	    Result := code_attribute.opcode_if_icmpne;
	 else
	    Result := code_attribute.opcode_if_acmpne;
	 end;
      end;
   
feature

   jvm_expanded_descriptor_in(str: STRING) is
	 -- Append the good descriptor in `str' when `current_type'
	 -- `is_expanded'.
      require
	 current_type.is_expanded;
	 str /= Void
      local
	 ct: TYPE;
      do
	 ct := current_type;
	 if ct.is_user_expanded then
	    if writable_attributes = Void then
	       str.extend('B');
	    else
	       str.append(jvm_root_descriptor);
	    end;
	 else
	    ct.jvm_descriptor_in(str);
	 end;
      end;

feature

   jvm_push_default is
	 -- Poduce bytecode to push the default value.
      require
	 current_type.is_reference
      local
	 i, idx: INTEGER;
	 wa: ARRAY[RUN_FEATURE_2];
	 rf2: RUN_FEATURE_2;
	 t2: TYPE;
	 ca: like code_attribute;
	 cp: like constant_pool;
      do
	 ca := code_attribute;
	 idx := fully_qualified_constant_pool_index;
	 ca.opcode_new(idx);
	 wa := writable_attributes;
	 if wa /= Void then
	    from
	       i := wa.upper;
	       cp := constant_pool;
	    until
	       i = 0
	    loop
	       rf2 := wa.item(i);
	       t2 := rf2.result_type.run_type;
	       if t2.is_user_expanded then
		  ca.opcode_dup;
		  t2.run_class.jvm_expanded_push_default;
		  idx := cp.idx_fieldref(rf2);
		  ca.opcode_putfield(idx,-2);
	       elseif t2.is_bit then
		  ca.opcode_dup;
		  idx := t2.jvm_push_default;
		  idx := cp.idx_fieldref(rf2);
		  ca.opcode_putfield(idx,-2);
	       end;
	       i := i - 1;
	    end;
	 end;
      end;

   jvm_expanded_push_default is
	 -- Push the corresponding new user's expanded (either dummy 
	 -- or not, initializer is automatically applied).
      require
	 current_type.is_user_expanded
      local
	 ca: like code_attribute;
	 rf: RUN_FEATURE;
	 wa: ARRAY[RUN_FEATURE_2];
	 rf2: RUN_FEATURE_2;
	 idx, i: INTEGER;
	 t: TYPE;
      do
	 ca := code_attribute;
	 wa := writable_attributes;
	 if wa = Void then
	    ca.opcode_iconst_0;
	 else
	    idx := fully_qualified_constant_pool_index;
	    code_attribute.opcode_new(idx);
	    from
	       i := wa.upper;
	    until
	       i = 0
	    loop
	       rf2 := wa.item(i);
	       t := rf2.result_type;
	       if t.is_user_expanded then
		  ca.opcode_dup;
		  t.run_class.jvm_expanded_push_default;
		  idx := constant_pool.idx_fieldref(rf2);
		  ca.opcode_putfield(idx,-2);
	       end;
	       i := i - 1;
	    end;
	 end;
	 rf := base_class.expanded_initializer(current_type);
	 if rf /= Void then
	    jvm.push_expanded_initialize(rf);
	    rf.mapping_jvm;
	    jvm.pop;
	 end;
      end;

feature {JVM}

   unqualified_name: STRING is
      local
	 ct: TYPE;
	 type_bit: TYPE_BIT;
      do
	 -- *** DISPATCHER DANS TYPE_* ???
	 ct := current_type;
	 if ct.is_generic then
	    ucpn.clear;
	    ucpn.extend('_');
	    ucpn.append(ct.base_class_name.to_string);
	    ucpn.to_lower;
	    id.append_in(ucpn);
	 elseif ct.is_bit then
	    type_bit ?= ct;
	    ucpn.copy(us_bit);
	    type_bit.nb.append_in(ucpn);
	    ucpn.to_lower;
	 else
	    ucpn.copy(ct.base_class_name.to_string);
	    ucpn.to_lower;
	 end;
	 Result := ucpn;
      end;

feature

   fully_qualified_constant_pool_index: INTEGER is
      do
	 Result := constant_pool.idx_class2(fully_qualified_name);
      end;

feature {SMALL_EIFFEL,TYPE}

   demangling is
      require
	 cpp.on_h
      local
	 str: STRING;
	 r: like running;
	 i: INTEGER;
      do
	 str := "";
	 str.clear;
	 if at_run_time then
	    str.extend('A');
	    if current_type.is_reference and then not is_tagged then
	       str.extend('*');
	    else
	       str.extend(' ');
	    end;
	 else
	    str.extend('D');
	    str.extend(' ');
	 end;
	 r := running;
	 if r /= Void then
	    r.count.append_in(str);
	 end;
	 from
	 until
	    str.count > 4
	 loop
	    str.extend(' ');
	 end;
	 str.extend('T');
	 id.append_in(str);
	 from
	 until
	    str.count > 10
	 loop
	    str.extend(' ');
	 end;
	 current_type.demangling_in(str);
	 if r /= Void then
	    from
	       str.extend(' ');
	       i := r.upper;
	    until
	       i = 0
	    loop
	       r.item(i).id.append_in(str);
	       i := i - 1;
	       if i > 0 then
		  str.extend(',');
	       end;
	    end;
	 end;
	 str.extend('%N');
	 cpp.put_string(str);
      ensure
	 cpp.on_h
      end;

feature {SMALL_EIFFEL,RUN_CLASS}

   compile_to_c(deep: INTEGER) is
	 -- Produce C code for features of Current. The `deep'
	 -- indicator is used to sort the C output in the best order 
	 -- (more C  inlinings are possible when basic functions are 
	 -- produced first). As there is not always a total order 
	 -- between clients, the `deep' avoid infinite track.
	 -- When `deep' is greater than 0, C code writting 
         -- is produced whatever the real client relation is.
      require
	 cpp.on_c;
	 deep >= 0
      local
	 i: INTEGER;
	 rc1, rc2: like Current;
	 cc1, cc2: INTEGER;
      do
	 if compile_to_c_done then
	 elseif not at_run_time then
	    compile_to_c_done := true;
	 elseif deep = 0 then
	    really_compile_to_c;
	 else
	    i := actuals_clients.upper;
	    if i >= 0 then
	       from
		  rc1 := Current;
		  cc1 := i + 1;
	       until
		  i = 0
	       loop
		  rc2 := actuals_clients.item(i);
		  if not rc2.compile_to_c_done then
		     cc2 := rc2.actuals_clients.count;
		     if cc2 > cc1 then
			rc1 := rc2;
			cc1 := cc2;
		     end;
		  end;
		  i := i - 1;
	       end;
	       if rc1 = Current then
		  really_compile_to_c;
	       else
		  rc1.compile_to_c(deep - 1);
	       end;
	    end;
	 end;
      ensure
	 cpp.on_c
      end;

feature {NONE}

   really_compile_to_c is
      require
	 at_run_time
      local
	 i: INTEGER;
	 rf: RUN_FEATURE;
      do
	 compile_to_c_done := true;
	 cpp.split_c_start_run_class;
	 echo.put_character('%T');
	 echo.put_string(current_type.run_time_mark);
	 echo.put_character('%N');
	 from
	    i := 1;
	 until
	    i > feature_dictionary.count
	 loop
	    rf := feature_dictionary.item(i);
	    rf.c_define;
	    i := i + 1;
	 end;
	 if run_control.invariant_check then
	    if invariant_assertion /= Void then
	       invariant_assertion.c_define;
	    end;
	 end;
      ensure
	 compile_to_c_done
      end;

feature {RUN_CLASS}

   actuals_clients: FIXED_ARRAY[RUN_CLASS];

feature {RUN_FEATURE}

   add_client(rc: RUN_CLASS) is
      require
	 rc /= Void
      local
	 i: INTEGER;
      do
	 i := actuals_clients.fast_index_of(rc);
	 if i > actuals_clients.upper then
	    actuals_clients.add_last(rc);
	 end;
      end;
   
feature {BASE_CLASS}
   
   collect_invariant(ia: like invariant_assertion) is
      require
	 ia /= Void;
      do
	 ia.add_into(ci_collector);
      end;

feature {NONE}   
   
   writable_attributes_mem: like writable_attributes;
   
   ci_collector: ARRAY[ASSERTION] is
	 -- The Class Invariant Collector.
      once
	 !!Result.make(1,10);
      end;

feature 

   offset_of(rf2: RUN_FEATURE_2): INTEGER is
	 -- Compute the displacement to access `rf2' in the corresponding 
	 -- C struct to remove a possible stupid switch.
	 -- Result is in number of bytes.
      require
	 at_run_time;
	 writable_attributes.fast_has(rf2);
	 small_eiffel.is_ready
      local
	 wa: like writable_attributes;
	 t: TYPE;
	 i: INTEGER;
      do
	 if is_tagged then
	    Result := (1).object_size;
	 end;
	 from
	    wa := writable_attributes;
	    i := wa.upper;
	 invariant
	    i > 0
	 until
	    wa.item(i) = rf2
	 loop
	    t := wa.item(i).result_type;
	    Result := Result + t.space_for_variable;
	    i := i - 1;
	 end;
      end;

feature {NONE}

   sort_wam(wam: like writable_attributes) is
	 -- Sort `wam' to common attribute at the end.
      require
	 wam.lower = 1
      local
	 min, max, buble: INTEGER;
	 moved: BOOLEAN;
      do
	 from  
	    max := wam.upper;
	    min := 1;
	    moved := true;
	 until
	    not moved
	 loop
	    moved := false;
	    if max - min > 0 then
	       from  
		  buble := min + 1;
	       until
		  buble > max
	       loop
		  if gt(wam.item(buble - 1),wam.item(buble)) then
		     wam.swap(buble - 1,buble);
		     moved := true;
		  end;
		  buble := buble + 1;
	       end;
	       max := max - 1;
	    end;
	    if moved and then max - min > 0 then
	       from  
		  moved := false;
		  buble := max - 1;
	       until
		  buble < min
	       loop
		  if gt(wam.item(buble),wam.item(buble + 1)) then
		     wam.swap(buble,buble + 1);
		     moved := true;
		  end;
		  buble := buble - 1;
	       end;
	       min := min + 1;
	    end;
	 end;
      end;

   gt(rf1, rf2: RUN_FEATURE_2): BOOLEAN is
	 -- True if it is better to set attribute `rf1' before
	 -- attribute `rf2'.
      local
	 bc1, bc2: BASE_CLASS;
	 bf1, bf2: E_FEATURE;
	 bcn1, bcn2: CLASS_NAME;
      do
	 bf1 := rf1.base_feature;
	 bf2 := rf2.base_feature;
	 bc1 := bf1.base_class;
	 bc2 := bf2.base_class;
	 bcn1 := bc1.base_class_name;
	 bcn2 := bc2.base_class_name;
	 if bcn1.to_string = bcn2.to_string then
	    Result := bf1.start_position.before(bf2.start_position);
	 elseif bcn2.is_subclass_of(bcn1) then
	    Result := true;
	 elseif bcn1.is_subclass_of(bcn2) then
	 elseif bc1.parent_list = Void then
	    if bc2.parent_list = Void then
	       Result := bcn1.to_string < bcn2.to_string;
	    else
	       Result := true;
	    end;
	 elseif bc2.parent_list = Void then
	 else
	    Result := bc2.parent_list.count < bc1.parent_list.count 
	 end;
      end;

feature {NONE}

   efnf(bc: BASE_CLASS; fn: FEATURE_NAME) is
      require
	 bc /= Void;
	 fn /= Void
      do
	 eh.append("Current type is ");
	 eh.append(current_type.run_time_mark);
	 eh.append(". There is no feature ");
	 eh.append(fn.to_string);
	 eh.append(" in class ");
	 eh.append(bc.base_class_name.to_string);
	 error(fn.start_position,fz_dot);
      end;

feature {NONE}

   tmp_string: STRING is
      once
	 !!Result.make(32);
      end;

feature {NONE}

   ucpn: STRING is
      once
	 !!Result.make(32);
      end;

feature {RUN_CLASS}

   need_gc_mark: BOOLEAN is
      require
	 at_run_time
      local
	 i: INTEGER;
	 wa: like writable_attributes;
	 rf2: RUN_FEATURE_2;
	 t: TYPE;
	 rc: RUN_CLASS;
      do
	 wa := writable_attributes;
	 if wa /= Void then
	    from
	       i := wa.upper;
	    until
	       Result or else i = 0
	    loop
	       rf2 := wa.item(i);
	       t := rf2.result_type;
	       Result := t.need_gc_mark_function;
	       i := i - 1;
	    end;
	 end;
      end;

invariant
   
   current_type.run_type = current_type;
   
   current_type.is_expanded implies running.is_equal(<<Current>>)

end -- RUN_CLASS

