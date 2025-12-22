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
deferred class CALL_PREFIX
--   
-- For all sort of prefix operators.
-- Root of all CALL_PREFIX_*.
--   

inherit
   CALL_0
      rename make as make_call0
      undefine precedence
      redefine precedence, feature_name, print_as_target
      end;
   
feature {ANY}
   
   feature_name: PREFIX_NAME;
   
   operator: STRING is
      deferred
      end;
   
   precedence: INTEGER is
      deferred
      end;
   
   make(operator_position: POSITION; rp: like target) is
      do
	 !!feature_name.make(operator,operator_position);
	 make_call0(rp,feature_name);
      end;

   is_pre_computable: BOOLEAN is false;
   
   frozen bracketed_pretty_print is
      do
	 fmt.put_character('(');
	 pretty_print;
	 fmt.put_character(')');
      end;

   frozen pretty_print is
      do
	 feature_name.pretty_print;
	 fmt.put_character(' ');
	 if target.precedence < precedence then
	    fmt.put_character('(');
	    target.pretty_print;
	    fmt.put_character(')');
	 else
	    target.pretty_print;
	 end;
      end;
   
   print_as_target is
      do
	 fmt.put_character('(');
	 pretty_print;
	 fmt.put_character(')');
	 fmt.put_character('.');
      end;

   frozen short is
      do
	 short_print.a_prefix_name(feature_name);
	 if target.precedence < precedence then
	    target.bracketed_short;
	 else
	    target.short;
	 end;
      end;
   
   frozen short_target is
      do
	 bracketed_short;
	 short_print.a_dot;
      end;

end -- CALL_PREFIX


