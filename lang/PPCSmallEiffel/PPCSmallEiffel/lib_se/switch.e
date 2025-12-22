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
expanded class SWITCH
   --
   -- Set of tools (no attributes) to handle one switching site.
   --

inherit GLOBALS;

feature {NONE}

   running: ARRAY[RUN_CLASS] is
	 -- The global one.
      once
	 !!Result.with_capacity(256,1);
      end;
   
feature 
   
   c_define(up_rf: RUN_FEATURE) is
	 -- Define the switching C function for `up_rf'.
      require
	 cpp.on_c
      local
	 boost: BOOLEAN;
	 arguments:  FORMAL_ARG_LIST;
	 t: TYPE;
	 i: INTEGER;
      do
	 boost := run_control.boost;
	 arguments := up_rf.arguments;
	 t := up_rf.result_type;
	 ts.clear;
	 if t = Void then
	    ts.append(fz_void);
	 else
	    t := t.run_type;
	    t.c_type_for_result_in(ts);
	 end;
	 ts.extend(' ');
	 ts.extend('X');
	 up_rf.current_type.id.append_in(ts);
	 up_rf.name.mapping_c_in(ts);
	 if boost then
	    ts.append("(void *C");
	 else
	    ts.append("(int l,int c,int f, void *C");
	 end;
	 if arguments /= Void then
	    from  
	       i := 1;
	    until
	       i > arguments.count
	    loop
	       ts.extend(',');
	       t := arguments.type(i).run_type;
	       t.c_type_for_argument_in(ts);
	       ts.append(" a");
	       i.append_in(ts);
	       i := i + 1;
	    end;
	 end;
	 ts.extend(')');
	 cpp.put_c_heading(ts);
	 cpp.swap_on_c;
	 cpp.put_string("int id=");
	 running.copy(up_rf.current_type.run_class.running);
	 sort_running(running);
	 if boost then
	    cpp.put_string("((T0*)C)->id;%N");
	 else
	    cpp.put_string("vc(C,l,c,f)->id;%N");
	 end;
	 if run_control.all_check then
	    c_switch(up_rf);
	 else
	    c_dicho(up_rf,1,running.upper);
	 end;
	 cpp.put_string(fz_12);
      ensure	 
	 cpp.on_c
      end;

feature {C_PRETTY_PRINTER}

   put_arguments(up_rf: RUN_FEATURE; fal: FORMAL_ARG_LIST) is
	 -- Produce C code for arguments of `fal' used
	 -- inside the switching C function.
      require
	 cpp.on_c;
	 fal.count = up_rf.arguments.count
      local
	 i, up: INTEGER;
      do
	 from  
	    i := 1;
	    up := fal.count;
	 until
	    i > up
	 loop
	    if i > 1 then
	       cpp.put_character(',');
	    end;
	    put_ith_argument(up_rf,fal,i);
	    i := i + 1;
	 end;
      ensure
	 cpp.on_c
      end;
   
   put_ith_argument(up_rf: RUN_FEATURE; fal: FORMAL_ARG_LIST; index: INTEGER) is
	 -- Produce C code for argument `index' of `fal' used
	 -- inside the switching C function.
      require
	 cpp.on_c;
	 fal.count = up_rf.arguments.count;
	 1 <= index;
	 index <= fal.count
      local
	 eal: like fal;
	 at, ft: TYPE;
      do
	 eal := up_rf.arguments;
	 at := eal.type(index).run_type;
	 ft := fal.type(index).run_type;
	 if at.is_reference and then ft.is_basic_eiffel_expanded then
	    cpp.put_character('(');
	    ft.cast_to_ref;
	    cpp.put_character('a');
	    cpp.put_integer(index);
	    cpp.put_string(")->_item");
	 else
	    cpp.put_character('a');
	    cpp.put_integer(index);
	 end;
      ensure
	 cpp.on_c
      end;
   
feature {NONE}
   
   c_dicho(up_rf: RUN_FEATURE; bi, bs: INTEGER) is
	 -- Produce dichotomic inspection code for Current id.
      require
	 bi <= bs
      local
	 m: INTEGER;
	 dyn_rc: RUN_CLASS;
	 dyn_rf: RUN_FEATURE;
      do
	 if bi = bs then
	    dyn_rc := running.item(bi);
	    dyn_rf := dyn_rc.dynamic(up_rf);
	    tail_opening(up_rf.result_type,dyn_rf.result_type);
	    cpp.push_switch(dyn_rf,up_rf);
	    dyn_rf.mapping_c;
	    cpp.pop;
	    tail_closing(up_rf.result_type,dyn_rf.result_type);
	 else	    
	    m := (bi + bs) // 2;
	    dyn_rc := running.item(m);
	    cpp.put_string("if (id <= ");
	    cpp.put_integer(dyn_rc.id);
	    cpp.put_string(") {%N");
	    c_dicho(up_rf,bi,m);
	    cpp.put_string("} else {%N");
	    c_dicho(up_rf,m + 1,bs);
	    cpp.put_character('}');
	 end;
      end;

   c_switch(up_rf: RUN_FEATURE) is
	 -- Produce C switch inspection code for Current id.
      local
	 i: INTEGER;
	 dyn_rc: RUN_CLASS;
	 dyn_rf: RUN_FEATURE;
      do
	 cpp.put_string("switch(id){%N"); 
	 from
	    i := 1;
	 until
	    i > running.upper
	 loop
	    dyn_rc := running.item(i);
	    dyn_rf := dyn_rc.dynamic(up_rf);
	    cpp.put_string("case "); 
	    cpp.put_integer(dyn_rc.id);
	    cpp.put_character(':');
	    tail_opening(up_rf.result_type,dyn_rf.result_type);
	    cpp.push_switch(dyn_rf,up_rf);
	    dyn_rf.mapping_c;
	    cpp.pop;
	    tail_closing(up_rf.result_type,dyn_rf.result_type);
	    cpp.put_string("%Nbreak;%N"); 
	    i := i + 1;
	 end;
	 if run_control.no_check then
	    cpp.put_string("default: error2(C,l,c,f);%N");
	 end;
	 cpp.put_string(fz_12);
      end;

feature {C_PRETTY_PRINTER,SWITCH}

   name(up_rf: RUN_FEATURE): STRING is
      do
	 tmp_name.clear;
	 tmp_name.extend('X');
	 up_rf.current_type.id.append_in(tmp_name);
	 tmp_name.append(up_rf.name.to_key);
	 Result := tmp_name;
      end;

feature {NONE}

   tmp_name: STRING is
      once
	 !!Result.make(32);
      end;

feature

   jvm_descriptor(up_rf: RUN_FEATURE): STRING is
      local
	 arguments:  FORMAL_ARG_LIST;
	 rt: TYPE;
      do
	 arguments := up_rf.arguments;
	 tmp_jvmd.clear;
	 tmp_jvmd.extend('(');
	 tmp_jvmd.append(jvm_root_descriptor);
	 if arguments /= Void then
	    arguments.jvm_descriptor_in(tmp_jvmd);
	 end;
	 rt := up_rf.result_type;
	 if rt = Void then
	    tmp_jvmd.append(fz_19);
	 else
	    rt := rt.run_type;
	    tmp_jvmd.extend(')');
	    if rt.is_reference then
	       tmp_jvmd.append(jvm_root_descriptor);
	    else
	       rt.jvm_descriptor_in(tmp_jvmd);
	    end;
	 end;
	 Result := tmp_jvmd;
      end;

feature {NONE}

   tmp_string: STRING is
      once
	 !!Result.make(32);
      end;

   tmp_jvmd: STRING is
      once
	 !!Result.make(32);
      end;

feature 

   idx_methodref(up_rf: RUN_FEATURE): INTEGER is
      require
	 up_rf /= Void
      do
	 Result := constant_pool.idx_methodref3(jvm_root_class,
						name(up_rf),
						jvm_descriptor(up_rf));
      end;
   
feature {JVM}

   jvm_mapping(cpc: CALL_PROC_CALL) is
      require
	 cpc /= Void
      local
	 idx, stack_level: INTEGER;
	 up_rf: RUN_FEATURE;
	 target: EXPRESSION;
	 eal: EFFECTIVE_ARG_LIST;
	 fal: FORMAL_ARG_LIST;
	 switch: SWITCH;
      do
	 target := cpc.target;
	 up_rf := cpc.run_feature;
	 eal := cpc.arguments;
	 target.compile_to_jvm;
	 stack_level := 1;
	 if eal /= Void then
	    fal := up_rf.arguments;
	    stack_level := stack_level + eal.compile_to_jvm(fal);
	 end;
	 idx := switch.idx_methodref(up_rf);
	 code_attribute.opcode_invokestatic(idx,-stack_level);
      end;

feature {SWITCH_COLLECTION}

   jvm_define(up_rf: RUN_FEATURE) is
      local
	 rt: TYPE;
      do
	 -- Define the Java switching static method for `up_rf'.
	 method_info.start(9,name(up_rf),jvm_descriptor(up_rf));
	 running.copy(up_rf.current_type.run_class.running);
	 rt := up_rf.result_type;
	 if rt /= Void then
	    rt := rt.run_type;
	 end;
	 jvm_switch(up_rf,rt);
	 method_info.finish;
      end;

feature {NONE}

   ts: STRING is
      once
	 !!Result.make(256);
      end;

   tail_opening(x_type, r_type: TYPE) is
      do
	 if x_type /= Void then
	    tmp_string.copy(fz_return);
	    tmp_string.extend('(');
	    tmp_string.extend('(');
	    x_type.c_type_for_result_in(tmp_string);
	    tmp_string.extend(')');
	    tmp_string.extend('(');
	    cpp.put_string(tmp_string);
	    if r_type.is_expanded and then x_type.is_reference then
	       r_type.to_reference;
	       cpp.put_character('(');
	    end;
	 end;
      end;

   tail_closing(x_type, r_type: TYPE) is
      do
	 if x_type /= Void then
	    if r_type.is_expanded and then x_type.is_reference then
	       cpp.put_character(')');
	    end;
	    cpp.put_string(fz_16);
	 end;
      end;

feature {NONE}

   jvm_switch(up_rf: RUN_FEATURE; rt: TYPE) is
	 -- Produce Java sequential switch code.
      require
	 rt /= Void implies rt.run_type = rt
      local
	 space, point, idx, i: INTEGER;
	 dyn_rc: RUN_CLASS;
	 dyn_rf: RUN_FEATURE;
	 boost: BOOLEAN;
	 ca: like code_attribute;
      do
	 ca := code_attribute;
	 from
	    boost := run_control.boost;
	    i := running.upper;
	 until
	    i = 0
	 loop
	    dyn_rc := running.item(i);
	    dyn_rf := dyn_rc.dynamic(up_rf);
	    if i = 1 and then boost then
	    else
	       ca.opcode_aload_0;
	       idx := dyn_rf.run_class.fully_qualified_constant_pool_index;
	       ca.opcode_instanceof(idx);
	       point := ca.opcode_ifeq;
	    end;
	    jvm.push_switch(dyn_rf,up_rf);
	    dyn_rf.mapping_jvm;
	    jvm.pop;
	    if rt = Void then
	       ca.opcode_return;
	    else
	       space := dyn_rf.result_type.jvm_convert_to(rt);
	       rt.jvm_return_code;
	    end;
	    if i = 1 and then boost then
	    else
	       ca.resolve_u2_branch(point);
	    end;
	    i := i - 1;
	 end;
	 if boost then
	 else
	    ca.opcode_system_err_println(idx_error01);
	    ca.opcode_iconst_1;
	    ca.opcode_system_exit
	 end;
      end;

   idx_error01: INTEGER is
      do
	 Result := constant_pool.idx_string("Bad target for dynamic dispatch.");
      end;

end
