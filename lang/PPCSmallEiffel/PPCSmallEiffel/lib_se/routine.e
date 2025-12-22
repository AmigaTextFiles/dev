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
deferred class ROUTINE
--   
-- Root class for all sort of routines : function, procedure,
-- external function/procedure, deferred function/procedure and
-- once function/procedure.
--
--
   
inherit
   E_FEATURE
      redefine pretty_print_arguments, set_header_comment 
      end;

feature {ANY}

   arguments: FORMAL_ARG_LIST;
   
   obsolete_mark: MANIFEST_STRING;
      
   require_assertion: E_REQUIRE;
   
   ensure_assertion: E_ENSURE;
   
   rescue_compound: COMPOUND;
   
   end_comment: COMMENT;
   
   pretty_print is
      local
	 fn: FEATURE_NAME;
      do
	 fmt.set_indent_level(1);
	 fmt.indent;
	 pretty_print_profile;
	 fmt.keyword("is");
	 if obsolete_mark /= Void then
	    fmt.set_indent_level(2);
	    fmt.indent;
	    fmt.keyword("obsolete");
	    obsolete_mark.pretty_print;
	 end;
	 fmt.set_indent_level(2);
	 fmt.indent;
	 if header_comment /= Void then
	    header_comment.pretty_print;
	 end;
	 if require_assertion /= Void then
	    fmt.set_indent_level(2);
	    require_assertion.pretty_print;
	 end;
	 fmt.set_indent_level(2);
	 fmt.indent;
	 pretty_print_routine_body;
	 if ensure_assertion /= Void then
	    fmt.set_indent_level(2);
	    ensure_assertion.pretty_print;
	 end;
	 if rescue_compound /= Void then
	    fmt.set_indent_level(2);
	    fmt.indent;
	    fmt.keyword("rescue");
	    rescue_compound.pretty_print;
	 end;
	 fmt.set_indent_level(2);
	 fmt.indent;
	 fmt.keyword("end;");
	 if end_comment /= Void and then not end_comment.dummy then
	    end_comment.pretty_print;
	 elseif fmt.print_end_routine then
	    fmt.put_string("-- ");
	    fn := first_name;
	    fn.definition_pretty_print;
	 end;
	 fmt.put_character('%N');
      end;
   
   set_header_comment(hc: like header_comment) is
      -- Is the `end_comment' for routines.
      do
	 if hc /= Void and then hc.count > 1 then
	    end_comment := hc;
	 end;
      end;
   
feature {EIFFEL_PARSER}
   
   set_ensure_assertion(ea: like ensure_assertion) is
      do
	 ensure_assertion := ea;
      ensure
	 ensure_assertion = ea;
      end; 
   
   set_rescue_compound(rc: like rescue_compound) is
      do
	 if rc /= Void and then is_deferred then
	    error(start_position,
		  "Deferred feature must not have rescue compound.");
	 end;
	 rescue_compound := rc;
      ensure
	 rescue_compound = rc;
      end;

feature {NONE}
   
   pretty_print_arguments is
      do
	 if arguments /= Void then
	    arguments.pretty_print;
	 end;
      end;
   
   pretty_print_routine_body is
      require
	 fmt.indent_level = 2;
      deferred
      end;
   
feature {NONE}
   
   make_routine(n: like names;
		fa: like arguments; 
		om: like obsolete_mark;
		hc: like header_comment;
		ra: like require_assertion) is
      do
	 make_e_feature(n,void);
	 header_comment := hc;
	 arguments := fa;
	 obsolete_mark := om;
         require_assertion := ra;
      end;

feature {NONE}

   check_obsolete is
      do
	 if not small_eiffel.short_flag then
	    if obsolete_mark /= Void then
	       eh.append("This feature is obsolete :%N%"");
	       eh.append(obsolete_mark.to_string);
	       warning(start_position,fz_03);
	    end
	 end;
      end;

   
end -- ROUTINE

