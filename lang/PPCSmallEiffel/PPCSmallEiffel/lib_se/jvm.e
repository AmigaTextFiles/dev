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
class JVM
   --
   -- Handling of Java Virtual Machine byte code generation.
   --

inherit CODE_PRINTER;

creation make 

feature

   output_name: STRING;
	 -- This name is used as the name of the main output class 
	 -- file and as the name of the directory used to store
	 -- auxilliary class files.
   
feature {NONE}

   b_put_u1_count: INTEGER;
	 -- To count printed bytes.

feature {NONE}

   make is do end;

feature {NONE}

   fields: FIXED_ARRAY[RUN_FEATURE] is
      once 
	 !!Result.with_capacity(4);
      end;

   methods: FIXED_ARRAY[RUN_FEATURE] is
      once 
	 !!Result.with_capacity(64);
      end;

feature {RUN_FEATURE}

   add_field(rf: RUN_FEATURE) is
      require
	 rf /= Void;
	 not fields.fast_has(rf)
      do
	 fields.add_last(rf);
      ensure
	 fields.fast_has(rf)
      end;

feature {RUN_FEATURE,NATIVE}

   add_method(rf: RUN_FEATURE) is
      require
	 rf /= Void;
	 not methods.fast_has(rf)
      do
	 methods.add_last(rf);
      ensure
	 methods.fast_has(rf)
      end;

feature 

   set_output_name(n: STRING) is
      do
	 output_name := n;
      end;

feature {SMALL_EIFFEL}

   mkdir(root: RUN_FEATURE) is
	 -- Create a new directory to store class files.
      require
	 root /= Void;
	 small_eiffel.is_ready
      do
	 if output_name = Void then
	    output_name := root.current_type.base_class_name.to_string;
	    output_name := output_name.twin;
	    output_name.to_lower;
	 end;
	 if output_name.has_suffix(class_suffix) then
	    output_name.remove_suffix(class_suffix);
	 end;
	 echo.put_string("Trying to prepare directory %"");
	 echo.put_string(output_name);
	 echo.put_string("%" to store Java byte code.%N");
	 file_tools.mkdir(output_name);
      end;

   write_jvm_root_class is
      local
	 idx: INTEGER;
	 cp: like constant_pool;
      do
	 cp := constant_pool;
         start_directory(out_file_path,output_name);
         out_file_path.append(fz_jvm_root);
	 out_file_path.append(class_suffix);
	 bfw_connect(out_file,out_file_path);
	 start_basic;
	 access_flags := 1025; -- (ACC_PUBLIC,ACC_ABSTRACT)
	 this_class_idx := cp.idx_class2(jvm_root_class);
	 super_class_idx := cp.idx_java_lang_object;
	 -- Fields :
	 args_field;
	 manifest_string_pool.jvm_define_fields;
	 once_routine_pool.jvm_define_fields;
	 if run_control.no_check then
	    field_info.add(9,cp.idx_uft8(fz_58),cp.idx_uft8(fz_41));
	 end;
	 -- Methods :
	 --    The initialize method :
	 current_frame := Void;
	 method_info.start(9,fz_28,fz_29);
	 manifest_string_pool.jvm_initialize_fields;
	 once_routine_pool.jvm_initialize_fields;
	 if run_control.no_check then
	    idx := cp.idx_fieldref3(jvm_root_class,fz_58,fz_41);
	    code_attribute.opcode_iconst_0;
	    code_attribute.opcode_putstatic(idx,-1);
	 end;
	 code_attribute.opcode_return;
	 method_info.finish;
	 --    For switches :
	 switch_collection.jvm_define;
	 finish_class;
      end;

   write_main_class(rf3: RUN_FEATURE_3) is
	 -- Write Java Byte Code for main class to call `rf3'.
      require
	 rf3 /= Void;
	 small_eiffel.is_ready
      local
	 idx: INTEGER;
	 cp: like constant_pool;
	 ca: like code_attribute;
      do
	 cp := constant_pool;
	 ca := code_attribute;
	 out_file_path.copy(output_name);
	 out_file_path.append(class_suffix);
	 bfw_connect(out_file,out_file_path);
	 start_basic;
	 access_flags := 16; -- (ACC_FINAL)
	 this_class_idx := cp.idx_class2(output_name);
	 super_class_idx := cp.idx_java_lang_object;
	 -- Methods :
	 --    The main method :
	 current_frame := Void;
	 method_info.start(9,fz_main,fz_23);
	 set_args_field;
	 idx := cp.idx_methodref3(jvm_root_class,fz_28,fz_29);
	 ca.opcode_invokestatic(idx,0);
	 rf3.run_class.jvm_push_default;
	 idx := cp.idx_methodref(rf3);
	 ca.opcode_invokevirtual(idx,-1);
	 ca.opcode_system_out;
	 idx := cp.idx_methodref3(fz_25,fz_42,fz_29);
	 ca.opcode_invokevirtual(idx,-1);
	 ca.opcode_system_err;
	 ca.opcode_invokevirtual(idx,-1);
	 ca.opcode_return;
	 method_info.finish;
	 finish_class;
      end;

feature {CODE_ATTRIBUTE}

   max_locals: INTEGER is
      do
	 if current_frame /= Void then
	    Result := current_frame.jvm_max_locals;
	 else
	    Result := 4;
	 end;
      end;

feature {NONE}
   
   access_flags: INTEGER;
	 -- of the class.

   this_class_idx: INTEGER;

   super_class_idx: INTEGER;

   start_basic is
      do
	 fields.clear;
	 methods.clear;
	 constant_pool.clear;
	 field_info.clear;
	 method_info.clear;
	 b_put_u1_count := 0;
      end;

feature {RUN_CLASS}

   start_new_class(rc: RUN_CLASS) is
      require
	 output_name /= Void
      local
	 name_idx, type_idx: INTEGER;
	 cp: like constant_pool;
      do
	 cp := constant_pool;
	 start_basic;
	 tmp_string.copy(rc.unqualified_name);
	 tmp_string.to_lower;
	 start_directory(out_file_path,output_name);
	 out_file_path.append(tmp_string);
	 out_file_path.append(class_suffix);
	 bfw_connect(out_file,out_file_path);
	 access_flags := 16;
	 this_class_idx := rc.fully_qualified_constant_pool_index;
	 super_class_idx := cp.idx_jvm_root_class;
	 -- <clinit> :
	 method_info.start(9,fz_76,fz_29);
	 -- generating_type :
	 name_idx := cp.idx_uft8(us_generating_type);
	 type_idx := cp.idx_eiffel_string_descriptor;
	 field_info.add(9,name_idx,type_idx);
	 name_idx := cp.idx_fieldref5(this_class_idx,name_idx,type_idx);
	 code_attribute.opcode_aconst_null;
	 code_attribute.opcode_putstatic(name_idx,-1);
	 -- generator :
	 name_idx := cp.idx_uft8(us_generator);
	 field_info.add(9,name_idx,type_idx);
	 name_idx := cp.idx_fieldref5(this_class_idx,name_idx,type_idx);
	 code_attribute.opcode_aconst_null;
	 code_attribute.opcode_putstatic(name_idx,-1);
	 code_attribute.opcode_return;
	 method_info.finish;
	 rc.jvm_define_class_invariant;
      end;

   finish_class is
	 -- Really print the class file.
      do
	 put_magic;
	 put_minor_version;
	 put_major_version;
	 constant_pool.write_bytes;
	 b_put_u2(access_flags);
	 b_put_u2(this_class_idx);
	 b_put_u2(super_class_idx);
	 -- interfaces_count :
	 b_put_u2(0);
	 field_info.write_bytes;
	 method_info.write_bytes;
	 -- attributes_count :
	 b_put_u2(0);
	 out_file.disconnect;
	 echo.print_count("byte",b_put_u1_count);
      end;

feature

   current_frame: RUN_FEATURE;
	 -- Current method or current field.

feature {RUN_CLASS,SWITCH_COLLECTION}

   set_current_frame(cf: like current_frame) is
      do
	 current_frame := cf;
      end;
   
feature

   argument_offset_of(an: ARGUMENT_NAME): INTEGER is
      require
	 an /= Void
      do
	 Result := current_frame.jvm_argument_offset(an);
      ensure
	 Result >= 0
      end;

   local_offset_of(ln: LOCAL_NAME): INTEGER is
      require
	 ln /= Void
      do
	 Result := current_frame.jvm_local_variable_offset(ln);
      ensure
	 Result >= 0
      end;

   result_offset: INTEGER is
      do
	 Result := current_frame.jvm_result_offset;
      end;

feature {CP_INFO}

   b_put_u1(byte: CHARACTER) is
      require
	 0 <= byte.code;
	 byte.code <= 255
      do
	 out_file.put_byte(byte);
	 b_put_u1_count := b_put_u1_count + 1;
      end;

feature {CONSTANT_POOL,FIELD_INFO,METHOD_INFO}

   b_put_u2(u2: INTEGER) is
      do
	 b_put_u1((u2 // 256).to_character);
	 b_put_u1((u2 \\ 256).to_character);
      ensure
	 b_put_u1_count = 2 + old b_put_u1_count
      end;

feature {CP_INFO,FIELD_INFO,METHOD_INFO}

   b_put_byte_string(str: STRING) is
      require
	 str /= Void
      local
	 i: INTEGER;
      do
	 from
	    i := 1;
	 until
	    i > str.count
	 loop
	    b_put_u1(str.item(i));
	    i := i + 1;
	 end;
      ensure
	 b_put_u1_count = str.count + old b_put_u1_count
      end;

feature {RUN_CLASS}

   prepare_fields is
      local
	 i: INTEGER;
	 rf: RUN_FEATURE;
      do
	 from
	    i := fields.upper;
	 until
	    i < 0
	 loop
	    rf := fields.item(i);
	    rf.jvm_define;
	    i := i - 1;
	 end;
      end;

   prepare_methods is
      local
	 i: INTEGER;
      do
	 from
	    i := methods.upper;
	 until
	    i < 0
	 loop
	    set_current_frame(methods.item(i));
	    current_frame.jvm_define;
	    i := i - 1;
	 end;
      end;

feature {NONE}

   put_magic is
	 -- CAFEBABE ;-)
      do
	 b_put_byte_string("%/202/%/254/%/186/%/190/");
      end;

   put_minor_version is
      do
	 b_put_u2(3);
      end;

   put_major_version is
      do
	 b_put_byte_string("%/0/%/45/");
      end;

feature {NONE}

   args_field is
	 -- Define `args' field to store command line arguments.
      local
	 args_idx, jaos_idx: INTEGER;
	 cp: like constant_pool;
      do
	 cp := constant_pool;
	 args_idx := cp.idx_uft8(fz_74);
	 jaos_idx := cp.idx_uft8(fz_75);
	 field_info.add(9,args_idx,jaos_idx);
      end;

   set_args_field is
	 -- Set `args' field to store command line arguments.
      local
	 ca: like code_attribute;
      do
	 ca := code_attribute;
	 ca.opcode_aload_0;
	 ca.opcode_putstatic(args_field_idx,-1);
      end;

   args_field_idx: INTEGER is
      local
	 cp: like constant_pool;
      do
	 cp := constant_pool;
	 Result := cp.idx_fieldref3(jvm_root_class,fz_74,fz_75);
      end;

feature {NATIVE_SMALL_EIFFEL}

   push_se_argc is
      local
	 ca: like code_attribute;
      do
	 ca := code_attribute;
	 ca.opcode_getstatic(args_field_idx,1);
	 ca.opcode_arraylength;
	 ca.opcode_iconst_1;
	 ca.opcode_iadd;
      end;

   push_se_argv is
      local
	 point1, point2, i: INTEGER;
	 ca: like code_attribute;
	 arg0: STRING;
      do
	 ca := code_attribute;
	 ca.opcode_getstatic(args_field_idx,1);
	 i := push_ith_argument(1)
	 ca.opcode_dup;
	 point1 := ca.opcode_ifeq;
	 ca.opcode_iconst_1;
	 ca.opcode_isub;
	 ca.opcode_aaload;
	 point2 := ca.opcode_goto;
	 ca.resolve_u2_branch(point1);
	 ca.opcode_pop;
	 if output_name /= Void then
	    arg0 := output_name;
	 else
	    arg0 := run_control.root_class;
	 end;
	 i := constant_pool.idx_string(arg0);
	 ca.opcode_ldc(i);
	 ca.resolve_u2_branch(point2);
	 ca.opcode_java_string2eiffel_string;
      end;


feature {NONE}

   out_file: BINARY_FILE_WRITE is 
	 -- Current output class file.
      once
	 !!Result.make;
      end;

   out_file_path: STRING is
      once
	 !!Result.make(32);
      end;

   tmp_string: STRING is
      once
	 !!Result.make(16);
      end;

feature {CALL_PROC_CALL}

   b_put_cpc(cpc: CALL_PROC_CALL) is
      local
	 target: EXPRESSION;
	 target_type: TYPE;
	 running: ARRAY[RUN_CLASS];
	 switch: SWITCH;
	 rf: RUN_FEATURE;
      do
	 target := cpc.target;
	 target_type := target.result_type.run_type;
	 if target_type.is_expanded then
	    push_direct(cpc);
	    cpc.run_feature.mapping_jvm;
	    pop
	 elseif target.is_current then
	    push_direct(cpc);
	    cpc.run_feature.mapping_jvm;
	    pop
	 elseif target.is_manifest_string then
	    push_direct(cpc);
	    cpc.run_feature.mapping_jvm;
	    pop
	 else
	    running := target_type.run_class.running;
	    check
	       running /= Void
	    end;
	    if running.count = 1 then
	       push_check(cpc);
	       rf := cpc.run_feature;
	       rf := running.first.dynamic(rf);
	       rf.mapping_jvm;
	       pop
	    else
	       switch_count := switch_count + 1;
	       switch.jvm_mapping(cpc);
	    end;
	 end;
      end;

feature {RUN_CLASS}

   push_expanded_initialize(rf: RUN_FEATURE) is
      do
	 stack_push(C_expanded_initialize);
	 stack_rf.put(rf,top);
      end;

   define_class_invariant_method(ci: CLASS_INVARIANT) is
      require
	 run_control.invariant_check;
	 ci /= Void
      local
	 ca: like code_attribute;
	 cp: like constant_pool;
      do
	 ca := code_attribute;
	 cp := constant_pool;
	 method_info.start(17,fz_invariant,fz_29);
	 stack_push(C_switch);
	 ci.compile_to_jvm(true);
	 pop;
	 ca.opcode_return;
	 method_info.finish;
      end;

feature {NATIVE}

   inside_twin(cpy: RUN_FEATURE) is
      do
	 stack_push(C_inside_twin);
	 stack_rf.put(cpy,top);
	 cpy.mapping_jvm;
	 pop;
      end;

feature {CREATION_CALL}

   inside_new(rf: RUN_FEATURE; cpc: CALL_PROC_CALL) is
      require
	 rf /= Void;
	 cpc /= Void
      do
	 stack_push(C_inside_new);
	 stack_rf.put(rf,top);
	 stack_cpc.put(cpc,top);
	 rf.mapping_jvm;
	 pop;
      end;

feature {NONE}

   push_direct(cpc: CALL_PROC_CALL) is
      require
	 cpc /= Void
      do
	 stack_push(C_direct_call);
	 stack_cpc.put(cpc,top);
	 direct_call_count := direct_call_count + 1;
      end;

   push_check(cpc: CALL_PROC_CALL) is
      require
	 cpc /= Void
      do
	 stack_push(C_check_id);
	 stack_cpc.put(cpc,top);
      end;

feature {RUN_FEATURE,NATIVE}

   target_position: POSITION is
      local
	 code: INTEGER;
      do
	 code := stack_code.item(top); 
	 inspect
	    code
	 when C_direct_call, C_check_id then 
	    Result := stack_cpc.item(top).start_position;
	 when C_inside_twin then
	 when C_switch then
	 when C_expanded_initialize then
	 when C_inside_new then
	    Result := stack_cpc.item(top).start_position;
	 else
	 end;
      end;

   push_target is
	 -- Produce java byte code in order to push target on the
	 -- jvm stack.
      local
	 code: INTEGER;
      do
	 code := stack_code.item(top); 
	 inspect
	    code
	 when C_direct_call then 
	    stack_cpc.item(top).target.compile_to_jvm;
	 when C_check_id then 
	    opcode_check_id_for(stack_cpc.item(top).target);
	 when C_switch then
	    code_attribute.opcode_aload_0;
	 when C_expanded_initialize then
	    code_attribute.opcode_dup;
	 when C_inside_new then
	    code_attribute.opcode_dup;
	 when C_inside_twin then
	    code_attribute.opcode_aload_1;
	 else
	    fatal_error("JVM NYI XXX #1");
	 end;
      end;

   push_target_as_target is
	 -- Same as `push_target' but with class invariant check.
      local
	 code: INTEGER;
      do
	 code := stack_code.item(top); 
	 inspect
	    code
	 when C_direct_call then 
	    stack_cpc.item(top).target.compile_target_to_jvm;
	 when C_check_id then 
	    opcode_check_id_for(stack_cpc.item(top).target);
	 when C_switch then
	    code_attribute.opcode_aload_0;
	 when C_expanded_initialize then
	    code_attribute.opcode_dup;
	 when C_inside_new then
	    code_attribute.opcode_dup;
	 when C_inside_twin then
	    code_attribute.opcode_aload_1;
	 else
	    fatal_error("JVM NYI XXX #1");
	 end;
      end;

   drop_target is
      local
	 code: INTEGER;
	 cpc: CALL_PROC_CALL;
	 e: EXPRESSION;
      do
	 code := stack_code.item(top); 
	 inspect
	    code
	 when C_direct_call, C_check_id then 
	    cpc := stack_cpc.item(top);
	    e ?= cpc;
	    if e = Void or else not e.can_be_dropped then
	       cpc.target.compile_to_jvm;
	       if cpc.run_feature.current_type.jvm_stack_space = 1 then
		  code_attribute.opcode_pop;
	       else
		  code_attribute.opcode_pop2;
	       end;
	    end;
	 when C_switch then
	 when C_expanded_initialize then
	 when C_inside_new then
	 when C_inside_twin then
	 else
	    fatal_error("JVM NYI XXX #812451");
	 end;
      end;

   drop_ith_argument(i: INTEGER) is
      local
	 space: INTEGER;
      do
	 from
	    space := push_ith_argument(i);
	 until
	    space = 0
	 loop
	    code_attribute.opcode_pop;
	    space := space - 1;
	 end;
      end;

   push_arguments: INTEGER is
      local
	 code: INTEGER;
	 cpc: CALL_PROC_CALL;
	 eal: EFFECTIVE_ARG_LIST;
	 rf, dyn_rf: RUN_FEATURE;
	 fal: FORMAL_ARG_LIST;
      do
	 code := stack_code.item(top); 
	 inspect
	    code
	 when C_direct_call, C_check_id then 
	    cpc := stack_cpc.item(top);
	    eal := cpc.arguments;
	    if eal /= Void then
	       rf := cpc.run_feature;
	       fal := rf.arguments;
	       Result := eal.compile_to_jvm(fal);
	    end;
	 when C_switch then
	    rf := stack_static_rf.item(top);
	    dyn_rf := stack_rf.item(top);
	    fal := rf.arguments;
	    if fal /= Void then
	       Result := fal.jvm_switch_push(dyn_rf.arguments);
	    end;
	 when C_expanded_initialize then
	    check
	       false
	    end;
	 when C_inside_new then
	    cpc := stack_cpc.item(top);
	    eal := cpc.arguments;
	    if eal /= Void then
	       rf := stack_rf.item(top);
	       fal := rf.arguments;
	       Result := eal.compile_to_jvm(fal);
	    end;
	 when C_inside_twin then
	    Result := push_ith_argument(1);
	 else
	    fatal_error("JVM NYI XXX #3");
	 end;
      end;

   push_ith_argument(i: INTEGER): INTEGER is
      local
	 code: INTEGER;
	 cpc: CALL_PROC_CALL;
	 eal: EFFECTIVE_ARG_LIST;
	 rf, dyn_rf: RUN_FEATURE;
	 fal: FORMAL_ARG_LIST;
      do
	 code := stack_code.item(top); 
	 inspect
	    code
	 when C_direct_call, C_check_id then 
	    cpc := stack_cpc.item(top);
	    eal := cpc.arguments;
	    if eal /= Void then
	       rf := cpc.run_feature;
	       fal := rf.arguments;
	       Result := eal.compile_to_jvm_ith(fal,i);
	    end;
	 when C_switch then
	    rf := stack_static_rf.item(top);
	    dyn_rf := stack_rf.item(top);
	    fal := rf.arguments;
	    if fal /= Void then
	       Result := fal.jvm_switch_push_ith(dyn_rf.arguments,i);
	    end;
	 when C_expanded_initialize then
	    check
	       false
	    end;
	 when C_inside_new then
	    cpc := stack_cpc.item(top);
	    eal := cpc.arguments;
	    if eal /= Void then
	       rf := stack_rf.item(top);
	       fal := rf.arguments;
	       Result := eal.compile_to_jvm_ith(fal,i);
	    end;
	 when C_inside_twin then
	    code_attribute.opcode_aload_0;
	    Result := 1;
	 else
	    fatal_error("JVM NYI XXX #5");
	 end;
      end;

feature {SWITCH}

   push_switch(rf, static_rf: RUN_FEATURE) is
      require
	 rf /= Void;
	 static_rf /= Void;
	 rf.run_class.dynamic(static_rf) = rf
      do
	 stack_push(C_switch);
	 stack_rf.put(rf,top);
	 stack_static_rf.put(static_rf,top);
      end;

feature {NONE}

   opcode_check_id_for(e: EXPRESSION) is
	 -- Produce code for `e' with non-void check and id check
      require
	 e.result_type.run_class.running.count = 1
      local
	 point1, point2, idx: INTEGER;
	 rc: RUN_CLASS;
	 ca: like code_attribute;
      do
	 e.compile_to_jvm;
	 if run_control.no_check then
	    ca := code_attribute;
	    ca.opcode_dup;
	    point1 := ca.opcode_ifnull;
	    ca.opcode_dup;
	    rc := e.result_type.run_class.running.first;
	    idx := rc.fully_qualified_constant_pool_index;
	    ca.opcode_instanceof(idx);
	    point2 := ca.opcode_ifne;
	    idx := idx_bad_target(e);
	    ca.opcode_system_err_println(idx);
	    ca.opcode_aconst_null;
	    ca.opcode_athrow;
	    ca.resolve_u2_branch(point1);
	    idx := idx_void_target(e);
	    ca.opcode_system_err_println(idx);
	    ca.opcode_aconst_null;
	    ca.opcode_athrow;
	    ca.resolve_u2_branch(point2);
	    rc.jvm_check_class_invariant;
	 end;
      end;

   idx_bad_target(e: EXPRESSION): INTEGER is
      local
	 sp: POSITION;
      do
	 tmp_string.copy("Bad target ");
	 sp := e.start_position;
	 if sp /= Void then
	    sp.append_in(tmp_string);
	 end;
	 Result := constant_pool.idx_string(tmp_string);
      end;

   idx_void_target(e: EXPRESSION): INTEGER is
      local
	 sp: POSITION;
      do
	 tmp_string.copy("Void target ");
	 sp := e.start_position;
	 if sp /= Void then
	    sp.append_in(tmp_string);
	 end;
	 Result := constant_pool.idx_string(tmp_string);
      end;

end -- JVM

