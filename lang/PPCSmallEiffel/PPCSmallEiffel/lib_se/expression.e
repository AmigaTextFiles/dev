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
deferred class EXPRESSION
--
-- An Eiffel expression.
--
   
inherit 
   GLOBALS 
      redefine fill_tagged_out_memory 
      end; 
   
feature {EXPRESSION}
   
   static_value_mem: INTEGER;
   
feature 
   
   fill_tagged_out_memory is
      local
	 p: POSITION;
	 ct, rt: TYPE;
	 rtm: STRING;
      do
	 p := start_position;
	 if p /= Void then
	    p.fill_tagged_out_memory;
	 end;
	 if is_checked then
	    ct := current_type;
	    if ct /= Void then
	       rtm := ct.run_time_mark;
	       if rtm /= Void then
		  tagged_out_memory.append(" ct=");
		  tagged_out_memory.append(rtm);
	       end;
	    end;
	    rt := result_type;
	    if rt /= Void then
	       rtm := rt.run_time_mark;
	       if rtm /= Void then
		  tagged_out_memory.append(" rt=");
		  tagged_out_memory.append(rtm);
	       end;
	    end;
	 end;
      end;

   current_type: TYPE; 
	 -- Not Void when checked in.
   
   frozen is_checked: BOOLEAN is
	 -- True when expression is checked.
      do
	 Result := current_type /= Void;
	 if not Result then
	    warning(start_position,"EXPRESSION: Is not checked.");
	 end;
      end;
   
   result_type: TYPE is
	 -- When checked, the type of the expression;
      require
	 is_checked;
      deferred
      ensure
	 Result.is_run_type
      end;
   
   use_current: BOOLEAN is
      require
	 is_checked;
	 small_eiffel.is_ready;
      deferred
      end;
   
   to_runnable(ct: TYPE): like Current is
      -- Gives the corresponding expression checked for `ct'.
      require
	 ct.run_type = ct;
	 ct.run_class /= Void;
	 nb_errors = 0 implies empty_eh_check	
      deferred
      ensure
	 nb_errors = 0 implies Result /= Void;
	 Result = Void implies nb_errors > 0;
	 Result /= Void implies Result.current_type = ct; 
	 nb_errors = 0 implies empty_eh_check	
      end;

feature 

   isa_dca_inline_argument: INTEGER is
    ---*** GENERALISABLE POUR LES DCALLS (CHARACTER.is_digit par exemple).
	 -- Interpretation of Result :
	 -- -1 : yes and no ARGUMENT_NAME used
	 --  0 : not inlinable
         -- >0 : inlinable and ARGUMENT_NAME rank is used.
      require
	 run_control.boost and small_eiffel.is_ready
      deferred
      end;

   dca_inline_argument(formal_arg_type: TYPE) is
      require
	 formal_arg_type /= Void;
	 isa_dca_inline_argument /= 0
      deferred
      end;

feature  -- Handling of precedence (priority of expressions) :
   
   precedence: INTEGER is
	 -- of the receiver.
      deferred
      ensure
	 1 <= Result and Result <= atomic_precedence
      end;
      
feature  
   
   add_comment(c: COMMENT): EXPRESSION is
	 -- Attach `c' to the receiver.
      do
	 if c = Void or else c.count = 0 then
	    Result := Current;
	 else
	    !EXPRESSION_WITH_COMMENT!Result.make(Current,c);
	 end;
      end;
   
   start_position: POSITION is
      -- Of the expression if any.
      deferred
      end;
   
   base_class_written: BASE_CLASS is
      do
	 Result := written_in.base_class;
      end;
   
   written_in: CLASS_NAME is
	 -- The name of the base class where the expression is 
	 -- written if any.
      local
	 sp: like start_position;
      do
	 sp := start_position;
	 if sp /= Void then
	    Result := sp.base_class_name;
	 end;
      end;
   
   run_class: RUN_CLASS is
      do
	 if current_type /= Void then
	    Result := current_type.run_class;
	 end;
      end;

   is_current, is_void, is_result, is_writable,
   is_manifest_string: BOOLEAN is 
      do 
      end;
      
   is_a(other: EXPRESSION): BOOLEAN is
      require
	 result_type.is_run_type;
	 other.result_type.is_run_type
      do
	 Result := result_type.run_type.is_a(other.result_type.run_type);
	 if not Result then
	    eh.add_position(start_position);
	    error(other.start_position," Type mismatch.");
	 end;
      end;

   afd_check is
	 -- After Falling Down Check.
      require
	 is_checked;
      deferred
      end;

feature -- To produce C code :

   compile_to_c is
	 -- Produce C code to access the value of the Current 
	 -- expression : user's expanded are no longuer pointer.
      require
	 is_checked;
	 cpp.on_c;
      deferred
      ensure	 
	 cpp.on_c
      end;

   mapping_c_target(formal_type: TYPE) is
	 -- Produce C code in order to pass Current expression as 
	 -- the target of a feature call.
	 -- When it is needed, C code to check invariant is 
	 -- automatically added as well as a C cast according to 
	 -- the destination `formal_type'.
      require
	 small_eiffel.is_ready;
	 formal_type.at_run_time
      deferred
      end;

   mapping_c_arg(formal_arg_type: TYPE) is
	 -- Produce C code in order to pass Current expression as an 
	 -- argument of the feature called.
	 -- Thus, it is the same jobs as `mapping_c_target' without
	 -- the invariant call.
      require
	 small_eiffel.is_ready
      deferred
      end;
   
   compile_to_c_old is
	 -- Produce C code to memorize `old' expression values.
      require
	 is_checked;
	 cpp.on_c;
      deferred
      ensure	 
	 cpp.on_c
      end;

feature  -- To produce C code :
   
   c_simple: BOOLEAN is
	 -- True when the C code of `compile_c' has no side effect at 
	 -- and `compile_to_c' on the corresponding simple expression 
	 -- can be called more than once without any problem. 
      require
	 is_checked;
      deferred
      end;
   
   can_be_dropped: BOOLEAN is
	 -- True if evaluation of current expression has NO possible 
	 -- side effects. Thus, in such a case, an unused expression 
	 -- can be dropped (for example target of real procedure or 
	 -- real function).
      require
	 is_checked;
	 small_eiffel.is_ready;
      deferred
      end;
   
   is_pre_computable: BOOLEAN is
	 -- Can the current expression be pre-computed in main 
	 -- function to speed up a once function ?
	 -- When `is_static' may be true it must be called in order
	 -- to prepare `static_value_mem'.
      require
	 is_checked;
	 small_eiffel.is_ready
      deferred
      end;

feature -- For `compile_to_jvm' :
   
   compile_to_jvm is
	 -- Produce Java byte code in order to push expression value 
	 -- on the jvm stack.
      require
	 is_checked
      deferred
      end;

   compile_target_to_jvm is
	 -- Same as `compile_to_jvm', but add class invariant check
	 -- when needed.
      require
	 is_checked
      deferred
      end;

   compile_to_jvm_old is
	 -- Produce Java byte code to memorize `old' expression values.
      require
	 is_checked;
      deferred
      end;
   
   compile_to_jvm_into(dest: TYPE): INTEGER is
	 -- Assume `result_type' conforms to `dest'.
	 -- Produce Java byte code in order to convert the expression 
	 -- into `dest' (comparisons = and /=, argument passing and 
	 -- assignment).
	 -- Result gives the space in the JVM stack.
      require
	 conversion_check(dest,result_type)
      deferred
      ensure
	 Result >= 1
      end;

feature {NONE}

   frozen standard_compile_target_to_jvm is
      local
	 rt: TYPE;
      do
	 compile_to_jvm;
	 result_type.jvm_check_class_invariant;
      end;

   frozen standard_compile_to_jvm_into(dest: TYPE): INTEGER is
      require
	 conversion_check(dest,result_type)
      do
	 compile_to_jvm;
	 Result := result_type.run_type.jvm_convert_to(dest);
      ensure
	 Result >= 1
      end;

   conversion_check(dest, rt: TYPE): BOOLEAN is
      do
	 Result := true;
	 if rt.is_a(dest) then
	 else
	    eh.cancel;
	    if dest.is_a(rt) then
	    else
	       warning(start_position,
		       ". Impossible conversion (EXPRESSION).");
	    end;
	 end;
      end;

feature

   compile_to_jvm_assignment(a: ASSIGNMENT) is
	 -- Current is the writable which is the left-hand-side
	 -- of `a'.
      require
	 Current = a.left_side
      deferred
      end;
   
   jvm_branch_if_false: INTEGER is
	 -- Gives the `program_counter' to be resolved.
      require
	 result_type.is_boolean
      deferred
      end;

   jvm_branch_if_true: INTEGER is
	 -- Gives the `program_counter' to be resolved.
      require
	 result_type.is_boolean
      deferred
      end;
   
   jvm_assign is
	 -- Very basic assignment.
	 -- Assume that a JVM reference is on top of the stack and
	 -- that Current is the writable to assign with.
      require
	 result_type.is_reference
      deferred
      end;

feature {NONE}

   frozen jvm_standard_branch_if_false: INTEGER is
	 -- Gives the `program_counter' to be resolved.
      require
	 result_type.is_boolean
      do
	 compile_to_jvm;
	 Result := code_attribute.opcode_ifeq;
      end;
   
   frozen jvm_standard_branch_if_true: INTEGER is
	 -- Gives the `program_counter' to be resolved.
      require
	 result_type.is_boolean
      do
	 compile_to_jvm;
	 Result := code_attribute.opcode_ifne
      end;
   
feature  -- Finding `int' Constant C expression :
   
   is_static: BOOLEAN is
	 -- True if expression has always the same static
	 -- value: INTEGER or BOOLEAN value is always the same 
	 -- or when reference is always the same (Void or the 
	 -- same manifest string for example).
      require
	 is_checked;
	 small_eiffel.is_ready
      deferred   
      end;
   
   static_value: INTEGER is
      require
	 is_static;
	 small_eiffel.is_ready
      do
	 Result := static_value_mem;
      end;
   
   to_integer: INTEGER is
      require
	 is_checked;
      do
	 error(start_position,fz_iinaiv);
      end;

feature -- Pretty printing :
   
   pretty_print is
	 -- Start the `pretty_print' process.
      require
	 fmt.indent_level >= 1;
      deferred
      ensure
	 fmt.indent_level = old fmt.indent_level;
      end;
   
   print_as_target is
	 -- Print the expression viewed as a target plus the 
	 -- corresponding dot when it is necessary.
      deferred
      end;
   
   bracketed_pretty_print is
	 -- Add bracket only when it is necessary.
      deferred
      end;
      
feature -- For `short' :
   
   short is
      deferred
      end;

   short_target is
	 -- A target with the following dot if needed.
      deferred
      end;

   frozen bracketed_short is
      do
	 short_print.hook_or("open_b","(");
	 short;
	 short_print.hook_or("close_b",")");
      end;
   
feature {EXPRESSION,DECLARATION_LIST}
   
   set_current_type(ct: TYPE) is
      do
	 current_type := ct;
      ensure 
	 current_type = ct;
      end;
   
end -- EXPRESSION

