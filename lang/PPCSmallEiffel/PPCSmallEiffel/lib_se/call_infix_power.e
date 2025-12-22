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
class CALL_INFIX_POWER
--   
--   Infix operator : "^".
--         

inherit 
   CALL_INFIX 
      redefine pretty_print 
      end;
   
creation make
   
feature 
   
   precedence: INTEGER is 9;
   
   operator: STRING is 
      do
	 Result := us_pow;
      end;
   
   pretty_print is
	 -- Because : `foo ^ foo ^ foo' means : `foo ^ (foo ^ foo)'
      do
	 if target.precedence = atomic_precedence then
	    target.pretty_print;
	    print_op;
	    if arg1.precedence = atomic_precedence then
	       arg1.pretty_print;
	    elseif precedence > arg1.precedence then
	       arg1.bracketed_pretty_print;
	    else
	       arg1.pretty_print;
	    end;
	 elseif target.precedence <= precedence then
	    target.bracketed_pretty_print;
	    print_op;	       
	    arg1.pretty_print;
	 else
	    target.pretty_print;
	    print_op;	      
	    arg1.pretty_print;
	 end;	    
      end;
   
   isa_dca_inline_argument: INTEGER is
	 -- *** FAIRE ***
      do
      end;

   dca_inline_argument(formal_arg_type: TYPE) is
	 -- *** FAIRE ***
      do
      end;

   is_static: BOOLEAN is
      do
	 if result_type.is_integer then
	    if target.is_static and then arg1.is_static then
	       Result := true;
	       static_value_mem := target.static_value ^ arg1.static_value;
	    end;
	 end;
      end;
   
   compile_to_jvm is
      do
	 call_proc_call_c2jvm;
      end;
   
   jvm_branch_if_false: INTEGER is
      do
	 Result := jvm_standard_branch_if_false;
      end;

   jvm_branch_if_true: INTEGER is
      do
	 Result := jvm_standard_branch_if_true;
      end;
   
end -- CALL_INFIX_POWER

