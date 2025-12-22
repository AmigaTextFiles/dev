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
class EXPRESSION_WITH_COMMENT
--
-- To store one expression with a following comment.
-- 

inherit EXPRESSION;
   
creation make
   
feature 
   
   expression : EXPRESSION;
   
   comment : COMMENT;
   
feature 
   
   make(i: like expression; c: like comment) is
      require
	 i /= Void;
	 really_a_comment: c.count > 0
      do
	 expression := i;
	 comment := c;
      end;
   
   is_static: BOOLEAN is 
      do 
	 Result := expression.is_static; 
	 if Result then
	    static_value_mem := expression.static_value_mem;
	 end;      
      end;
      
   is_pre_computable: BOOLEAN is 
      do
	 Result := expression.is_pre_computable;
      end;

   isa_dca_inline_argument: INTEGER is
      do
	 Result := expression.isa_dca_inline_argument;
      end;
   
   dca_inline_argument(formal_arg_type: TYPE) is
      do
	 expression.dca_inline_argument(formal_arg_type);
      end;
   
   frozen mapping_c_target(target_type: TYPE) is
      do
	 expression.mapping_c_target(target_type);
      end;

   frozen mapping_c_arg(formal_arg_type: TYPE) is
      do
	 expression.mapping_c_arg(formal_arg_type);
      end;

   afd_check is
      do
	 expression.afd_check;
      end;
   
   compile_to_c is
      do
	 expression.compile_to_c;
      end;
   
   compile_to_c_old is 
      do
	 expression.compile_to_c_old;
      end;
      
   compile_to_jvm_old is 
      do
	 expression.compile_to_jvm_old;
      end;
      
   compile_to_jvm is
      do
	 expression.compile_to_jvm;
      end;

   compile_target_to_jvm is
      do
	 expression.compile_target_to_jvm
      end;
   
   compile_to_jvm_assignment(a: ASSIGNMENT) is
      do
	 expression.compile_to_jvm_assignment(a);
      end;
   
   jvm_branch_if_false: INTEGER is
      do
	 Result := expression.jvm_branch_if_false;
      end;

   jvm_branch_if_true: INTEGER is
      do
	 Result := expression.jvm_branch_if_true;
      end;

   compile_to_jvm_into(dest: TYPE): INTEGER is
      do
	 Result := expression.compile_to_jvm_into(dest);
      end;

   use_current: BOOLEAN is
      do
	 Result := expression.use_current;
      end;
   
   c_simple: BOOLEAN is
      do
	 Result := expression.c_simple;
      end;
   
   can_be_dropped: BOOLEAN is
      do
	 Result := expression.can_be_dropped;
      end;
   
   to_runnable(ct: TYPE): like Current is
      do
	 if current_type = Void then
	    current_type := ct;
	    expression := expression.to_runnable(ct);
	    Result := Current;
	 else
	    Result := twin;
	    Result.set_current_type(Void);
	    Result := Result.to_runnable(ct);
	 end;
      end;
   
   start_position: POSITION is
      do
	 Result := expression.start_position;
      end;
   
   bracketed_pretty_print, pretty_print is
      do
	 expression.pretty_print;
	 comment.pretty_print;
      end;
   
   print_as_target is
      do
	 expression.print_as_target;
      end;
   
   short is
      do
	 expression.short;
      end;
   
   short_target is
      do
	 expression.short_target;
      end;
   
   result_type: TYPE is
      do
	 Result := expression.result_type;
      end;
   
feature
   
   precedence: INTEGER is
      do
	 Result := expression.precedence;
      end;
   
feature {CREATION_CALL,EXPRESSION_WITH_COMMENT}
      
   jvm_assign is
      do
	 expression.jvm_assign;
      end;

end -- EXPRESSION_WITH_COMMENT

