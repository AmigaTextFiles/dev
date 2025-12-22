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
deferred class NAME
   -- 
   -- Handling of all sort of names you can find in an Eiffel
   -- source file :
   --
   --   CLASS_NAME : a base class name.
   --   FEATURE_NAME : ordinary feature name.
   --      INFIX_NAME : infix feature name.
   --      PREFIX_NAME : prefix feature name.
   --      SIMPLE_FEATURE_NAME : ordinary name.
   --   LOCAL_ARGUMENT (deferred)
   --      LOCAL_NAME : using a local variable.
   --      ARGUMENT_NAME : using an argument.
   --   E_RESULT : using pseudo Result.
   --   E_CURRENT : using pseudo Current.
   --   E_VOID : using Void.
   --   TAG_NAME : a tag name.
   --

inherit 
   GLOBALS
      undefine fill_tagged_out_memory
      end;
   
feature
   
   to_string: STRING;
	 -- The corresponding name (alone in a STRING).
   
   c_simple: BOOLEAN is true;

   start_position: POSITION is
	 -- The position of the first character of `to_string' in
	 -- the text source.
      deferred
      end;
   
   to_key: STRING is
	 -- To avoid clash between different kinds of names (for
	 -- example when using same infix/prefix operator).
	 -- Also used to compute the C name or the JVM name.
      deferred
      ensure
	 not Result.empty;
	 Result = unique_string.item(Result)
      end;
   
   pretty_print, bracketed_pretty_print is
      do
	 fmt.put_string(to_string);
      end;
   
   line: INTEGER is
      require
	 start_position /= Void
      do
	 Result := start_position.line;
      end;
   
   column: INTEGER is
      require
	 start_position /= Void
      do
	 Result := start_position.column;
      end;
   
   frozen afd_check is do end;

end -- NAME

