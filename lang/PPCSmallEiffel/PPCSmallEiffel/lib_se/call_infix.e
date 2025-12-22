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
deferred class CALL_INFIX
--   
-- For all sort of infix operators.
-- Root of all CALL_INFIX_*.
--

inherit
   CALL_1
      rename make as make_call_1
      undefine precedence
      redefine feature_name, precedence, print_as_target
      end;
   
feature 
   
   feature_name: INFIX_NAME;
   
   precedence: INTEGER is
      deferred
      end;
   
   operator: STRING is
      deferred
      ensure	 
	 Result.count >= 1
      end;
   
feature {NONE}   
   
   frozen make(lp: like target; operator_position: POSITION; rp: like arg1) is
      require
	 operator_position /= Void;
      local
	 eal: EFFECTIVE_ARG_LIST;
      do
	 if lp = Void or else rp = Void then
	    eh.add_position(operator_position);
	    fatal_error("Syntax Error.");
	 end;
	 !!feature_name.make(operator,operator_position);
	 !!eal.make(<<rp>>);
	 make_call_1(lp,feature_name,eal);
      ensure
	 target /= Void;
      end;
   
feature 

   frozen short is
      do
	 if target.precedence = atomic_precedence then
	    target.short;
	    short_print_feature_name;
	    if arg1.precedence = atomic_precedence then
	       arg1.short;
	    elseif precedence >= arg1.precedence then
	       arg1.bracketed_short;
	    else
	       arg1.short;
	    end;
	 elseif target.precedence < precedence then
	    target.bracketed_short;
	    short_print_feature_name;
	    arg1.short;
	 else
	    target.short;
	    short_print_feature_name;
	    arg1.short;
	 end;	    
      end;
   
   frozen short_target is
      do
	 bracketed_short;
	 short_print.a_dot;
      end;

   frozen print_as_target is
      do
	 fmt.put_character('(');
	 pretty_print;
	 fmt.put_character(')');
	 fmt.put_character('.');
      end;

   frozen bracketed_pretty_print is
      do
	 fmt.put_character('(');
	 pretty_print;
	 fmt.put_character(')');
      end;
   
   pretty_print is
	 -- *** Should be frozen ***
	 -- *** Because the bug with priority of infix "^", this 
	 -- *** feature is NOT frozen.
	 -- *** The only one redefinition is in CALL_INFIX_POWER.
      do
	 if target.precedence = atomic_precedence then
	    target.pretty_print;
	    print_op;
	    if arg1.precedence = atomic_precedence then
	       arg1.pretty_print;
	    elseif precedence >= arg1.precedence then
	       arg1.bracketed_pretty_print;
	    else
	       arg1.pretty_print;
	    end;
	 elseif arg1.precedence = atomic_precedence then
	    if target.precedence >= precedence then
	       target.bracketed_pretty_print;
	    else
	       target.pretty_print;
	    end;
	    print_op;
	    arg1.pretty_print;
	 elseif precedence <= target.precedence then
	    target.bracketed_pretty_print;
	    print_op;
	    if precedence <= arg1.precedence then
	       arg1.bracketed_pretty_print;
	    else
	       arg1.pretty_print;
	    end;
	 else
	    target.pretty_print;
	    print_op;	      
	    arg1.pretty_print;
	 end;	    
      end;
      
feature {NONE}
   
   print_op is
      do
	 fmt.put_character(' ');
	 feature_name.pretty_print;
	 fmt.put_character(' ');
      end;

feature {NONE}

   frozen short_print_feature_name is
      do
	 short_print.a_infix_name("Binfix"," ","Ainfix"," ",feature_name);
      end;
   
   frozen c2c_cast_op(cast, op: STRING) is
      do
	 cpp.put_character('(');
	 cpp.put_character('(');
	 cpp.put_character('(');
	 cpp.put_string(cast);
	 cpp.put_character(')');
	 cpp.put_character('(');
	 target.compile_to_c;
	 cpp.put_character(')');
	 cpp.put_character(')');
	 cpp.put_string(op);
	 cpp.put_character('(');
	 cpp.put_character('(');
	 cpp.put_string(cast);
	 cpp.put_character(')');
	 cpp.put_character('(');
	 arg1.compile_to_c;
	 cpp.put_character(')');
	 cpp.put_character(')');
	 cpp.put_character(')');
      end;

end -- CALL_INFIX

