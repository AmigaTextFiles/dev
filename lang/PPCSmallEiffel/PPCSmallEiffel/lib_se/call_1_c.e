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
class CALL_1_C
   -- Other call with only one argument.

inherit CALL_1;

creation make

feature

   short is
      do
	 target.short_target;
	 feature_name.short;
	 arg1.bracketed_short;
      end;
	 
   short_target is
      do
	 short;
	 short_print.a_dot;
      end;

   bracketed_pretty_print, pretty_print is
      do
	 target.print_as_target;
	 fmt.put_string(feature_name.to_string);
	 fmt.put_character('(');
	 arg1.pretty_print;
	 fmt.put_character(')');
      end;

   is_static: BOOLEAN is
      do
	 Result := call_is_static;
      end;

   isa_dca_inline_argument: INTEGER is
      -- *** A FAIRE ??? ***
      do
      end;

   dca_inline_argument(formal_arg_type: TYPE) is
	 -- *** FAIRE ***
      do
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
   
end -- CALL_1_C

