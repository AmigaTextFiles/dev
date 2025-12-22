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
class BIT_CONSTANT
--
-- For Manifest Constant BIT_N.
--   

inherit EXPRESSION;
   
creation {EIFFEL_PARSER} make
   
feature 
   
   start_position: POSITION;
   
   value: STRING;

   result_type: TYPE_BIT_1;

feature {NONE}

   id: INTEGER;

feature

   use_current: BOOLEAN is false;
   
   is_static: BOOLEAN is false;

   is_pre_computable: BOOLEAN is false;

   can_be_dropped: BOOLEAN is true;

   c_simple: BOOLEAN is true;

feature {NONE}
   
   make(sp: like start_position; s: STRING) is
      require
	 s /= Void
	 -- `s' contains only '0' and '1'.
      do
	 start_position := sp;
	 value := s;
      ensure
	 value.count = s.count
      end;
   
feature 

   isa_dca_inline_argument: INTEGER is
	 -- *** FAIRE ***
      do
      end;

   dca_inline_argument(formal_arg_type: TYPE) is
	 -- *** FAIRE ***
      do
      end;

   frozen afd_check is do end;

   frozen mapping_c_target(target_type: TYPE) is
      do
	 mapping_c_arg(target_type);
      end;

   frozen mapping_c_arg(formal_arg_type: TYPE) is
      do
	 compile_to_c;
      end;

   compile_to_c is 
      local
	 tb: TYPE_BIT;
	 nb: INTEGER;
	 ib: INTEGER;
      do
	 tb := result_type;
	 ib := Integer_bits
	 if tb.is_c_unsigned_ptr then
	    compute_c_to_bit;
	    cpp.put_character('(');
	    cpp.put_character('(');
	    cpp.put_string(fz_unsigned);
	    cpp.put_character('*');
	    cpp.put_character(')');
	    cpp.put_string_c(to_bit);
	    cpp.put_character(')');
	 else
	    to_bit.copy(value);
	    if tb.is_c_char then
	       nb := Character_bits;
	    else
	       nb := Integer_bits;
	    end;
	    from
	    until 
	       to_bit.count = nb
	    loop
	       to_bit.extend('0');
	    end;
	    cpp.put_integer(to_bit.binary_to_integer);
	 end;
      end;

   compile_to_c_old is do end;

   compile_to_jvm_old is do end;

   compile_target_to_jvm, compile_to_jvm is
      local
	 i, idx: INTEGER;
	 ca: like code_attribute;
	 cp: like constant_pool;
      do
	 ca := code_attribute;
	 cp := constant_pool;
	 idx := cp.idx_class2(fz_a0);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 ca.opcode_push_integer(value.count);
	 idx := cp.idx_methodref3(fz_a0,fz_35,fz_27);
	 ca.opcode_invokespecial(idx,0);
	 from
	    i := value.count;
	 until
	    i = 0
	 loop
	    if value.item(i) = '1' then
	       ca.opcode_dup;
	       ca.opcode_push_integer(i - 1);
	       idx := cp.idx_methodref3(fz_a0,fz_a4,fz_27);
	       ca.opcode_invokevirtual(idx,-2);
	    end;
	    i := i - 1;
	 end;
      end;
   
   compile_to_jvm_assignment(a: ASSIGNMENT) is
      do
      end;
   
   jvm_branch_if_false: INTEGER is
      do
      end;

   jvm_branch_if_true: INTEGER is
      do
      end;
   
   compile_to_jvm_into(dest: TYPE): INTEGER is
      do
	 Result := standard_compile_to_jvm_into(dest);
      end;

   to_runnable(ct: TYPE): like Current is
      local
	 ic: INTEGER_CONSTANT;
      do
	 if current_type = Void then
	    current_type := ct;
	    if result_type = Void then
	       !!ic.make(value.count,start_position);
	       !!result_type.make(start_position,ic);
	       result_type.run_class.set_at_run_time;
	    end;
	    Result := Current;
	 else
	    Result := twin;
	    Result.set_current_type(Void);
	    Result := Result.to_runnable(ct);
	 end;
      end;
   
   precedence: INTEGER is
      do
	 Result := atomic_precedence;
      end;

   to_string: STRING is
      do
	 Result := value.twin;
	 Result.extend('B');
      end;
   
   bracketed_pretty_print, pretty_print is
      do
	 fmt.put_string(value);
	 fmt.put_character('B');
      end;
   
   print_as_target is
      do
	 fmt.put_character('(');
	 pretty_print;
	 fmt.put_character(')');
	 fmt.put_character('.');
      end;

   short is
      local
	 i: INTEGER;
      do
	 from
	    i := 1;
	 until
	    i > value.count
	 loop
	    short_print.a_character(value.item(i));
	    i := i + 1;
	 end;
	 short_print.a_character('B');
      end;
   
   short_target is
      do
	 bracketed_short;
	 short_print.a_dot;
      end;

feature {NONE}

   compute_c_to_bit is
	 -- Compute in `to_bit' the C string view `value'.
      local
	 char_bit: STRING;
	 i_to_bit, i_value: INTEGER;
      do
	 from
	    i_to_bit := value.count // Integer_bits;
	    if (value.count \\ Integer_bits) /= 0 then
	       i_to_bit := i_to_bit + 1;
	    end;
	    i_to_bit := i_to_bit * (Integer_bits // Character_bits);
	    to_bit.clear;
	    char_bit := "01010101";
	    i_value := 1;
	 until
	    i_to_bit = 0
	 loop
	    from
	       char_bit.clear;
	    until
	       char_bit.count = Character_bits
	    loop
	       if i_value <= value.count then
		  char_bit.extend(value.item(i_value));
	       else
		  char_bit.extend('0');
	       end;
	       i_value := i_value + 1;
	    end;
	    to_bit.extend(char_bit.binary_to_integer.to_character);
	    i_to_bit := i_to_bit - 1;
	 end;
      end;

   to_bit: STRING is
      once
	 !!Result.make(16);
      end;

feature {CREATION_CALL,EXPRESSION_WITH_COMMENT}
      
   jvm_assign is
      do
      end;

end -- BIT_CONSTANT


