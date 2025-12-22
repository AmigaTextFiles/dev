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
class SIMPLE_FEATURE_NAME
--   
-- Is used for simple (not infix or prefix) names of feature in the
-- declaration part of a feature but is also used when writing an
--  attribute as a left hand side of an assignment.
--

inherit 
   FEATURE_NAME;
   EXPRESSION
      redefine is_writable
      end;


creation make

feature {NONE}

   run_feature_2: RUN_FEATURE_2;
	 -- Corresponding one when runnable.

feature

   is_writable: BOOLEAN is true;

   use_current: BOOLEAN is true;

   is_static: BOOLEAN is false;
      
   is_pre_computable: BOOLEAN is false;

   isa_dca_inline_argument: INTEGER is 0;

feature {BASE_CLASS}
   
   make(n: STRING; sp: like start_position) is
      require
	 n.count >= 1;
      do
	 to_string := unique_string.item(n);
	 start_position := sp;
      end;

feature

   to_key: STRING is
      do
	 Result := to_string;
      end;

   result_type: TYPE is
      do
	 Result := run_feature_2.result_type;
      end;

   can_be_dropped: BOOLEAN is
      do
	 eh.add_position(start_position);
	 fatal_error("FEATURE_NAME/Should never be called.");
      end;

   to_runnable(ct: TYPE): like Current is
      local
	 wbc: BASE_CLASS;
	 rf: RUN_FEATURE;
	 new_name:  FEATURE_NAME;
      do
	 if current_type = Void then
	    current_type := ct;
	    wbc := start_position.base_class;
	    new_name := ct.base_class.new_name_of(wbc,Current);
	    rf := current_type.run_class.get_feature(new_name);
	    if rf = Void then
	       error(start_position,"Feature not found.");
	    else
	       run_feature_2 ?= rf;
	       if run_feature_2 = Void then
		  eh.add_position(rf.start_position);
		  error(start_position,
			"Feature found is not writable.");
	       end;
	    end;
	    if nb_errors = 0 then
	       Result := Current;
	    else
	       error(start_position,"Bad feature name.");
	    end;
	 elseif ct = current_type then
	    Result := Current;
	 else
	    !!Result.make(to_string,start_position);
	    Result := Result.to_runnable(ct);
	 end;
      end;
   
   precedence: INTEGER is
      do
	 Result := atomic_precedence;
      end;
      
   run_feature(t: TYPE): RUN_FEATURE is
      -- **** VIRER ??? ***
	 -- Look for the corresponding runnable feature in `t';
      require
	 t.is_run_type
      do
	 Result := t.run_class.get_feature(Current);
	 -- *****************************
	 --                    get_rf_with ???
      end;

   dca_inline_argument(formal_arg_type: TYPE) is
      do
      end;

   mapping_c_target(target_type: TYPE) is
      local
	 flag: BOOLEAN;
      do
	 flag := cpp.call_invariant_start(target_type);
	 compile_to_c;
	 if flag then
	    cpp.call_invariant_end;
	 end;
      end;

   mapping_c_arg(formal_arg_type: TYPE) is
      do
	 compile_to_c;
      end;

   compile_to_c is
      do
	 cpp.put_string("C->_");
	 cpp.put_string(run_feature_2.name.to_string);
      end;

   compile_to_c_old is
      do 
      end;
      
   compile_to_jvm_old is
      do 
      end;
   
feature -- For pretty :

   print_as_target is
      do
	 fmt.put_string(to_string);
	 fmt.put_character('.');
      end;
   
   definition_pretty_print is
      do
	 fmt.put_string(to_string);
      end;

feature

   short is
      local
	 i: INTEGER;
	 c: CHARACTER;
      do
	 short_print.hook("Bsfn");
	 from
	    i := 1;
	 until
	    i > to_string.count
	 loop
	    c := to_string.item(i);
	    if c = '_' then
	       short_print.hook_or("Usfn","_");
	    else
	       short_print.a_character(c);
	    end;
	    i := i + 1;
	 end;
	 short_print.hook("Asfn");
      end;

   short_target is
      do
	 short;
	 short_print.a_dot;
      end;

feature

   cpp_put_infix_or_prefix is
      do
      end;

feature

   compile_target_to_jvm, compile_to_jvm is
      do
	 eh.add_position(start_position);
	 fatal_error(fz_jvm_error);
      end;
   
   compile_to_jvm_assignment(a: ASSIGNMENT) is
      local
	 space, idx: INTEGER;
	 rf: RUN_FEATURE;
	 rt: TYPE;
      do
	 rf := run_feature_2;
	 rt := rf.result_type.run_type;
	 code_attribute.opcode_aload_0;
	 space := a.right_side.compile_to_jvm_into(rt);
	 idx := constant_pool.idx_fieldref(rf);
	 space := -(space + 1);
	 code_attribute.opcode_putfield(idx,space);
      end;
   
   jvm_branch_if_false: INTEGER is
      do
	 compile_to_jvm;
	 Result := code_attribute.opcode_ifeq;
      end;

   jvm_branch_if_true: INTEGER is
      do
	 compile_to_jvm;
	 Result := code_attribute.opcode_ifne;
      end;

   compile_to_jvm_into(dest: TYPE): INTEGER is
      do
	 Result := standard_compile_to_jvm_into(dest);
      end;

feature {CREATION_CALL,EXPRESSION_WITH_COMMENT}
      
   jvm_assign is
      local
	 space, idx: INTEGER;
	 rf: RUN_FEATURE;
      do
	 code_attribute.opcode_aload_0;
	 code_attribute.opcode_swap;
	 rf := run_feature_2;
	 idx := constant_pool.idx_fieldref(rf);
	 space := -(rf.result_type.jvm_stack_space + 1);
	 code_attribute.opcode_putfield(idx,space);
      end;

end -- SIMPLE_FEATURE_NAME

