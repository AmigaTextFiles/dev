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
deferred class RUN_FEATURE
--
-- A feature at run time : assertions collected and only run types.
--
--   RUN_FEATURE_1 : constant attribute.
--   RUN_FEATURE_2 : attribute.
--   RUN_FEATURE_3 : procedure.
--   RUN_FEATURE_4 : function.
--   RUN_FEATURE_5 : once procedure.
--   RUN_FEATURE_6 : once function.
--   RUN_FEATURE_7 : external procedure.
--   RUN_FEATURE_8 : external function.
--   RUN_FEATURE_9 : deferred routine.
--
   
inherit GLOBALS redefine fill_tagged_out_memory end;
   
feature 
   
   current_type: TYPE;
	 -- The type of Current in the corresponding feature.

   clients_memory: CLIENT_LIST;

feature {NONE}
   
   actuals_clients: FIXED_ARRAY[RUN_CLASS];
	 -- Places of callers.
   
feature 
   
   name: FEATURE_NAME;
	 -- Final name (the only one really used) of the feature.
   
   base_feature: E_FEATURE;
	 -- Original base feature definition.
   
   arguments: FORMAL_ARG_LIST;
	 -- Runnable arguments list if any.

   result_type: TYPE;
	 -- Runnable Result type if any.
   
   require_assertion: RUN_REQUIRE;
	 -- Runnable collected require assertion if any.
   
   local_vars: LOCAL_VAR_LIST is
	 -- Runnable local var list if any.
      deferred
      end;
   
   routine_body: COMPOUND;
	 -- Runnable routine body if any.
		 
   ensure_assertion: E_ENSURE;
	 -- Runnable collected ensure assertion if any.
   
   rescue_compound: COMPOUND;
	 -- Runnable rescue compound if any.

feature {NONE}	    
   
   make(t: like current_type; n: like name; bf: like base_feature) is
      require
	 t.run_type = t;
	 n /= Void;
	 bf /= void;
	 not small_eiffel.is_ready
      do
	 current_type := t; 
	 name := n; 
	 base_feature := bf; 
	 run_class.feature_dictionary.put(Current,n.to_key);
	 small_eiffel.incr_magic_count;
	 use_current_state := ucs_not_computed;
	 small_eiffel.push(Current);
	 initialize;
	 small_eiffel.pop;
      ensure
	 run_class.get_feature(name) = Current
      end;
   
feature 
   
   is_pre_computable: BOOLEAN is
      deferred
      end;
   
   can_be_dropped: BOOLEAN is
      -- If calling has no side effect at all.
      require
	 small_eiffel.is_ready
      deferred
      end;
   
   frozen use_current: BOOLEAN is
      require
	 small_eiffel.is_ready
      do
	 inspect
	    use_current_state 
	 when ucs_true then
	    Result := true;
	 when ucs_false then
	 when ucs_not_computed then
	    use_current_state := ucs_in_computation;
	    compute_use_current;
	    Result := use_current; 
	 when ucs_in_computation then
	    Result := true;
	 end;
      end;

   fall_down is
      local
	 running: ARRAY[RUN_CLASS];
	 i: INTEGER;
	 current_rc, sub_rc: RUN_CLASS;
	 current_bc, sub_bc: BASE_CLASS;
	 sub_name: FEATURE_NAME;
	 rf: RUN_FEATURE;
      do
	 current_rc := current_type.run_class;
	 running := current_rc.running;
	 if running /= Void then
	    from  
	       current_bc := current_type.base_class;
	       i := running.lower;
	    until
	       i > running.upper
	    loop
	       sub_rc := running.item(i);
	       if sub_rc /= current_rc then
		  sub_bc := sub_rc.current_type.base_class;
		  sub_name := sub_bc.new_name_of(current_bc,name);
		  rf := sub_rc.get_feature(sub_name);
	       end;
	       i := i + 1;
	    end;
	 end;
      end;

   afd_check is
      deferred
      end;
         
   fill_tagged_out_memory is
      local
	 p: POSITION;
	 ctrtm: STRING;
      do
	 p := start_position;
	 if p /= Void then
	    p.fill_tagged_out_memory;
	    tagged_out_memory.extend(' ');
	    if current_type.is_run_type then
	       ctrtm := current_type.run_time_mark;
	       if ctrtm /= Void then
		  tagged_out_memory.append(ctrtm);
	       end;
	    end;
	 end;
      end;

   is_exported_in(cn: CLASS_NAME): BOOLEAN is
	 -- True if using of the receiver is legal when written in `cn'.
	 -- When false, `eh' is updated with the beginning of the 
	 -- error message.
      require
	 cn /= Void
      do
	 Result := clients.gives_permission_to(cn);
      end;
      
   frozen start_position: POSITION is
      do
	 Result := base_feature.start_position;
      end;
   
   run_class: RUN_CLASS is
      do
	 Result := current_type.run_class;
      end;
   
feature {NONE}

   clients: like clients_memory is 
	 -- Effective client list for the receiver. 
	 -- Note: consider "export" clauses.
      local
	 bc, bfbc: BASE_CLASS;
      do
	 if clients_memory = Void then
	    bc := current_type.base_class;
	    bfbc := base_feature.base_class;
	    if bc = bfbc then
	       Result := base_feature.clients;
	    else
	       check
		  bc.is_subclass_of(bfbc)
	       end;
	       Result := bc.clients_for(name);
	    end;
	    clients_memory := Result;
	 else
	    Result := clients_memory;
	 end;
      ensure
	 Result /= Void
      end;
   
feature {RUN_CLASS,CREATION_CALL}

   add_client(rc: RUN_CLASS) is
	 -- Add `rc' to `actual_clients'.
	 -- Note: DO NOT check that `rc' is allowed to use it.
      require
	 rc /= Void
      local
	 i: INTEGER;
      do
	 if actuals_clients = Void then
	    !!actuals_clients.with_capacity(4);
	    actuals_clients.add_last(rc);
	 else
	    i := actuals_clients.fast_index_of(rc);
	    if i > actuals_clients.upper then
	       actuals_clients.add_last(rc);
	    end;
	 end;
	 run_class.add_client(rc);
      end;
   

feature {NONE}
   
   initialize is
      deferred
      end;
   
feature 
   
   has_result: BOOLEAN is
      do
	 Result := result_type /= Void;
      end;
   
   arg_count: INTEGER is
      do
	 if arguments /= Void then
	    Result := arguments.count;
	 end;
      end;
   
   c_define is
	 -- Produce C code for definition.
      require
	 run_class.at_run_time;
	 cpp.on_c
      deferred
      ensure	 
	 cpp.on_c
      end;
   
   mapping_c is
	 -- Produce C code when current is called and when the
	 -- concrete type of target is unique (`cpp' is in charge
	 -- of the context).
      require
	 run_class.at_run_time;
	 cpp.on_c
      deferred
      ensure	 
	 cpp.on_c
      end;

   address_of is
	 -- Produce C code for operator $<feature_name>
      require
	 run_class.at_run_time;
	 cpp.on_c
      do
	 mapping_name;
      ensure	 
	 cpp.on_c
      end;

   frozen id: INTEGER is
      do
	 Result := current_type.id;
      end;
   
   mapping_name is
      do
	 cpp.put_character('r');
	 cpp.put_integer(id);
	 cpp.put_string(name.to_key);
      end;
   
feature {EXPRESSION} 
   
   is_static: BOOLEAN is 
      deferred
      end;

   static_value_mem: INTEGER is 
      require
	 is_static;
      deferred
      end;
   
feature {C_PRETTY_PRINTER}

   put_tag is
      require
	 run_control.no_check
      local
	 fn: FEATURE_NAME;
      do
	 cpp.put_character('%"');    
	 fn := base_feature.first_name;
	 fn.cpp_put_infix_or_prefix;
	 cpp.put_string(fn.to_string);
	 cpp.put_string(" of ");
	 cpp.put_string(base_feature.base_class_name.to_string);
	 cpp.put_character('%"');
      end;

feature {NONE} -- Tools for `compile_to_c' :
   
   define_prototype is
      require
	 run_class.at_run_time;
	 cpp.on_c
      local
	 mem_id: INTEGER;
      do
	 mem_id := id;
	 -- Define heading of corresponding C function.
	 c_code.clear;
	 if result_type = Void then
	    c_code.append(fz_void);
	 else
	    result_type.run_type.c_type_for_result_in(c_code);
	 end;
	 c_code.extend(' ');
	 c_code.extend('r');
	 mem_id.append_in(c_code);
	 name.mapping_c_in(c_code);
	 c_code.extend('(');
	 if use_current then
	    current_type.c_type_for_target_in(c_code);
	    c_code.extend(' ');
	    c_code.extend('C');
	    if arguments /= Void then
	       c_code.extend(',');
	    end;
	 end;
	 if arguments = Void then
	    if not use_current then
	       c_code.append(fz_void);
	    end;
	 else
	    arguments.compile_to_c_in(c_code);
	 end;
	 c_code.extend(')');
	 cpp.put_c_heading(c_code);
	 cpp.swap_on_c;
      ensure	 
	 cpp.on_c
      end;
   
   define_opening is
	 -- Define opening section in C function.
      local
	 i: INTEGER;
	 t: TYPE;
      do
	 -- (1) -------------------- Local variable for Result :
	 if result_type /= Void then
	    t := result_type.run_type;
	    c_code.clear;
	    t.c_type_for_result_in(c_code);
	    c_code.extend(' ');
	    c_code.extend('R');
	    c_code.extend('=');
	    t.c_initialize_in(c_code);
	    c_code.append(fz_00);
	    cpp.put_string(c_code);
	 end;
	 -- (2) ----------------------- User's local variables :
	 if local_vars /= Void then
	    local_vars.compile_to_c;
	 end;
	 -- (3) ---------------- Local variable for old/ensure :
	 if run_control.ensure_check then
	    if ensure_assertion /= Void then
	       ensure_assertion.compile_to_c_old;
	    end;
	 end;
	 -- (4) -------------------- Initialize local expanded :
	 if local_vars /= Void then
	    local_vars.initialize_expanded;
	 end;
	 -- (5) ------------------------------- Run Stack Push :
	 if run_control.no_check then
	    cpp.rs_link(Current);
	    if use_current then
	       cpp.rs_push_current(current_type);
	    end;
	    from
	       i := 1;
	    until
	       i > arg_count
	    loop
	       t := arguments.type(i).run_type;
	       cpp.rs_push_argument(arguments.name(i).to_string,i,t);
	       check
		  i = arguments.rank_of(arguments.name(i).to_string);
	       end;
	       i := i + 1;
	    end;
	    if result_type /= Void then
	       cpp.rs_push_result(result_type.run_type);
	    end;
	    if local_vars /= Void then
	       from
		  i := 1;
	       until
		  i > local_vars.count
	       loop
		  local_vars.name(i).c_trace;
		  i := i + 1;
	       end;
	    end;
	 end;
	 -- (6) ----------------------- Require assertion code :
	 if require_assertion /= Void then
	    require_assertion.compile_to_c;
	 end;
      end;
   
   define_closing is
	 -- Define closing section in C function :
	 --    - code for ensure checking.
	 --    - free memory of expanded.
	 --    - run stack pop.
      do
	 -- (0) ----------------------------- Class Invariant :
	 if use_current then
	    cpp.current_class_invariant(current_type);
	 end;
	 -- (1) --------------------------- Ensure Check Code :
	 if run_control.ensure_check then
	    if ensure_assertion /= Void then
	       ensure_assertion.compile_to_c;
	    end;
	 end;
	 -- (2) --------------------- Free for local expanded :
	 -- (3) ------------------------------- Run Stack Pop :
	 if run_control.no_check then
	    cpp.rs_unlink;
	 end;
      end;
   
feature {NONE}

   external_prototype(er: EXTERNAL_ROUTINE) is
	 -- Define prototype for an external routine.
      require
	 cpp.on_c;
	 er = base_feature
      local
	 t: TYPE;
      do
	 c_code.clear;
	 c_code.append("/*external*/");
	 -- Define heading of corresponding C function.
	 t := result_type;
	 if t = Void then
	    c_code.append(fz_void);
	 else
	    t.c_type_for_external_in(c_code);
	 end;
	 c_code.extend(' ');
	 c_code.append(er.external_c_name);
	 c_code.extend('(');
	 if er.use_current then
	    current_type.c_type_for_external_in(c_code);
	    c_code.extend(' ');
	    c_code.extend('C');
	    if arguments /= Void then
	       c_code.extend(',');
	    end;
	 end;
	 if arguments = Void then
	    if not er.use_current then
	       c_code.append(fz_void);
	    end;
	 else
	    arguments.external_prototype(c_code);
	 end;
	 c_code.append(");%N");
	 cpp.swap_on_h;
	 cpp.put_string(c_code);
	 cpp.swap_on_c;
      ensure	 
	 cpp.on_c
      end;

feature {NONE}

   once_mark: STRING is
      do
	 Result := base_feature.first_name.to_string;
      end;

   once_flag_in(str: STRING) is
	 -- Produce the C name of the once flag.
      do
	 str.extend('f');
	 base_feature.mapping_c_name_in(str);
      end;
   
   once_flag is
	 -- Produce the C name of the once flag.
      do
	 c_code.clear;
	 once_flag_in(c_code);
	 cpp.put_string(c_code);
      end;
   
   once_boolean is
	 -- Produce C code for the boolean flag definition
	 -- and initialisation.
      do
	 c_code.copy(fz_int);
	 c_code.extend(' ');
	 once_flag_in(c_code);
	 cpp.put_extern2(c_code,'0');
      end;
   
feature {NONE}

   use_current_state: INTEGER;
   
   ucs_false, 
   ucs_true, 
   ucs_not_computed, 
   ucs_in_computation: INTEGER is unique;
      
   std_compute_use_current is
      require
	 use_current_state = ucs_in_computation;
      do
	 if use_current_state = ucs_in_computation then
	    if require_assertion /= Void then
	       if require_assertion.use_current then
		  use_current_state := ucs_true;
	       end;
	    end;
	 end;
	 if use_current_state = ucs_in_computation then
	    if routine_body /= Void then
	       if routine_body.use_current then
		  use_current_state := ucs_true;
	       end;
	    end;	    
	 end;
	 if use_current_state = ucs_in_computation then
	    if ensure_assertion /= Void then
	       if ensure_assertion.use_current then
		  use_current_state := ucs_true;
	       end;
	    end;	    
	 end;
	 if use_current_state = ucs_in_computation then
	    use_current_state := ucs_false;
	 end;
      ensure
	 use_current_state = ucs_false or else
	 use_current_state = ucs_true;	 
      end;
   
   compute_use_current is 
      require
	 use_current_state = ucs_in_computation;
      deferred 
      ensure
	 use_current_state = ucs_true or else
	 use_current_state = ucs_false;
      end;

feature {NONE}

   c_code: STRING is
      once
	 !!Result.make(256);
      end;

   c_code2: STRING is
      once
	 !!Result.make(256);
      end;

feature {NATIVE}
   
   frozen default_mapping_procedure is
	 -- Default mapping for procedure calls with target.
      do
         mapping_name;
	 cpp.put_character('(');
	 cpp.put_target_as_target;
	 if arg_count > 0 then
	    cpp.put_character(',');
	    cpp.put_arguments;
	 end;
	 cpp.put_string(fz_14);
      end;

   frozen default_mapping_function is
	 -- Default mapping for function calls with target.
      do
	 mapping_name;
	 cpp.put_character('(');
	 cpp.put_target_as_target;
	 if arg_count > 0 then
	    cpp.put_character(',');
	    cpp.put_arguments;
	 end;
	 cpp.put_character(')');
      end;

feature {NONE}

   nothing_comment is
	 -- Useful for incremental recompilation.
      do
	 cpp.put_string(fz_open_c_comment);
	 cpp.put_string("No:");
	 cpp.put_string(current_type.run_time_mark);
	 cpp.put_character('.');
	 cpp.put_string(name.to_string);
	 cpp.put_string(fz_close_c_comment);
	 cpp.put_character('%N');
      end;

feature {NATIVE}

   routine_mapping_jvm is
      local
	 rt, ct: TYPE;
	 idx, stack_level: INTEGER;
      do
	 ct := current_type;
	 jvm.push_target_as_target;
	 stack_level := -(1 + jvm.push_arguments);
	 rt := result_type;
	 if rt /= Void then
	    stack_level := stack_level + rt.jvm_stack_space;
	 end
	 idx := constant_pool.idx_methodref(Current);
	 ct.run_class.jvm_invoke(idx,stack_level);
      end;
      
feature {RUN_CLASS}
   
   jvm_field_or_method is
	 -- Update jvm's `fields' or `methods' if needed.
      deferred
      end;

feature 

   mapping_jvm is
      require
	 run_class.at_run_time
      deferred
      end;

feature {JVM}

   jvm_define is
	 -- To compute the constant pool, the number of fields,
	 -- the number of methods, etc.
      require
	 small_eiffel.is_ready
      deferred
      end;

feature {CONSTANT_POOL,SWITCH_COLLECTION}

   frozen jvm_descriptor: STRING is
      do
	 tmp_jvm_descriptor.clear;
	 update_tmp_jvm_descriptor;
	 Result := tmp_jvm_descriptor;
      end;

feature {NONE}

   update_tmp_jvm_descriptor is
      deferred
      end;

   tmp_jvm_descriptor: STRING is
      once
	 !!Result.make(128);
      end;

   routine_update_tmp_jvm_descriptor is
	 -- For RUN_FEATURE_3/4/5/6 :
      local
	 ct, rt: TYPE;
	 rc: RUN_CLASS;
      do
	 tmp_jvm_descriptor.extend('(');
	 ct := current_type;
	 ct.jvm_target_descriptor_in(tmp_jvm_descriptor);
	 if arguments /= Void then
	    arguments.jvm_descriptor_in(tmp_jvm_descriptor);
	 end;
	 rt := result_type;
	 if rt = Void then
	    tmp_jvm_descriptor.append(fz_19);
	 else
	    rt := rt.run_type;
	    tmp_jvm_descriptor.extend(')');
	    rt.jvm_descriptor_in(tmp_jvm_descriptor);
	 end;
      end;

feature {NONE}

   method_info_start is
      local
	 flags: INTEGER;
      do
	 flags := current_type.jvm_method_flags;
	 method_info.start(flags,name.to_key,jvm_descriptor);
      end;

   jvm_define_opening is
      require
	 jvm.current_frame = Current
      local
	 t: TYPE;
      do
	 -- (1) -------------------- Local variable for Result :
	 if result_type /= Void then
	    t := result_type.run_type;
	    t.jvm_initialize_local(jvm_result_offset);
	 end;
	 -- (2) ----------------------- User's local variables :
	 if local_vars /= Void then
	    local_vars.jvm_initialize;
	 end;
	 -- (3) ---------------- Local variable for old/ensure :
	 if run_control.ensure_check then
	    if ensure_assertion /= Void then
	       ensure_assertion.compile_to_jvm_old;
	    end;
	 end;
	 -- (4) ----------------------- Require assertion code :
	 if require_assertion /= Void then
	    require_assertion.compile_to_jvm;
	 end;
      end;

   jvm_define_closing is
      require
	 jvm.current_frame = Current
      do
	 -- (0) ----------------------------- Class Invariant :
	 if use_current then
-- *** 	    cpp.current_class_invariant(current_type);
	 end;
	 -- (1) --------------------------- Ensure Check Code :
	 if run_control.ensure_check then
 	    if ensure_assertion /= Void then
	       ensure_assertion.compile_to_jvm(true);
 	    end;
	 end;
	 -- (2) --------------------- Free for local expanded :
	 -- (3) ------------------- Prepare result for return :
	 if result_type /= Void then
	    result_type.jvm_push_local(jvm_result_offset);
	 end;
      end;

feature {JVM}

   frozen jvm_result_offset: INTEGER is
      require
	 result_type /= Void
      do
	 Result := current_type.jvm_stack_space;
	 if arguments /= Void then
	    Result := Result + arguments.jvm_stack_space;
	 end;
	 if local_vars /= Void then
	    Result := Result + local_vars.jvm_stack_space;
	 end;
      end;

   frozen jvm_argument_offset(a: ARGUMENT_NAME): INTEGER is
      require
	 arguments /= Void
      do
	 Result := current_type.jvm_stack_space;
	 Result := Result + arguments.jvm_offset_of(a);
      ensure
	 Result >= a.rank - 1
      end;

   frozen jvm_local_variable_offset(ln: LOCAL_NAME): INTEGER is
      require
	 local_vars /= Void
      do
	 Result := current_type.jvm_stack_space;
	 if arguments /= Void then
	    Result := Result + arguments.jvm_stack_space;
	 end;
	 Result := Result + local_vars.jvm_offset_of(ln);
      ensure
	 Result >= ln.rank - 1
      end;

feature 

   frozen jvm_max_locals: INTEGER is
      do
	 Result := current_type.jvm_stack_space;
	 if arguments /= Void then
	    Result := Result + arguments.jvm_stack_space;
	 end;
	 if local_vars /= Void then
	    Result := Result + local_vars.jvm_stack_space;
	 end;
	 if result_type /= Void then
	    Result := Result + result_type.jvm_stack_space;
	 end;
      end;

feature {NONE}

   routine_afd_check is
      do
	 if require_assertion /= Void then
	    require_assertion.afd_check;
	 end;
	 if routine_body /= Void then
	    routine_body.afd_check;
	 end;
	 if ensure_assertion /= Void then
	    ensure_assertion.afd_check;
	 end;
      end;

invariant
   
   current_type /= Void;
   
   name /= Void;
   
   base_feature /= Void;
   
end -- RUN_FEATURE

