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
class E_STRIP
--   
-- To store a instruction strip :
--                                 strip(foo, bar)
--

inherit EXPRESSION;
      
creation make
   
feature {NONE}
   
   list: FEATURE_NAME_LIST;
   
feature {ANY}
   
   make(sp: like start_position; l: ARRAY[FEATURE_NAME]) is
      do
	 if l /= Void then
	    !!list.make(l);
	 end;
      end;
   
   use_current: BOOLEAN is true;
      
   can_be_dropped, c_simple: BOOLEAN is false;
   
feature

   is_static: BOOLEAN is false;

   is_pre_computable: BOOLEAN is false;

   isa_dca_inline_argument: INTEGER is
      -- *** A FAIRE ??? ***
      do
      end;

   dca_inline_argument(formal_arg_type: TYPE) is
	 -- *** FAIRE ***
      do
      end;

   frozen mapping_c_target(target_type: TYPE) is
      do
	 compile_to_c;
      end;

   frozen mapping_c_arg(formal_arg_type: TYPE) is
      do
	 compile_to_c;
      end;

   afd_check, compile_to_c is
      do
	 error(start_position,"strip is not yet implemented.");
      end;
   
   compile_to_c_old is 
      do 
      end;

   compile_to_jvm_old is 
      do 
      end;

   compile_to_jvm is 
      do 
      end;
   
   compile_target_to_jvm is 
      do 
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
	 Result := 1;
	 compile_to_jvm;
      end;

   result_type: TYPE_ARRAY is
      once
	 !!Result.make(Void,type_any);
      end;
   
   to_runnable(rt: TYPE): like Current is
      do
	 error(start_position,"strip is not yet implemented.");
      end;
   
   pretty_print is
      do
	 fmt.put_string("strip (");
	 fmt.level_incr;
	 if list /= Void then
	    list.pretty_print;
	 end;
	 fmt.put_string(")");
	 fmt.level_decr;
      end;
   
   print_as_target is
      do
	 pretty_print;
	 fmt.put_character('.');
      end;
   
   bracketed_pretty_print is
      do
	 fmt.put_character('(');
	 pretty_print;
	 fmt.put_character(')');
      end;

   short is
      do
	 short_print.hook_or("op_strip","strip (");
	 if list /= Void then
	    list.short;
	 end;
	 short_print.hook_or("cl_strip",")");
      end;
   
   short_target is
      do
	 short;
	 short_print.a_dot;
      end;
   
   start_position: POSITION is
      do
	 if list /= Void then
	    Result := list.item(1).start_position;
	 end;
      end;
   
   precedence: INTEGER is
      do
	 Result := 11;
      end;
   
feature {CREATION_CALL,EXPRESSION_WITH_COMMENT}
      
   jvm_assign is
      do
      end;

end -- E_STRIP


