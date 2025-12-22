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
class INFIX_NAME
   --   
   -- To store an infix name of operator.
   --

inherit FEATURE_NAME;
   
creation make
   
feature    

   to_key: STRING;
   
feature {NONE}

   make(n: STRING; sp: like start_position) is
      do
	 to_string := unique_string.item(n);
	 start_position := sp;
	 to_key := unique_string.for_infix(to_string);
      end;

feature

   fill_tagged_out_memory is
      do
	 tagged_out_memory.append(to_key);
      end;

   cpp_put_infix_or_prefix is
      do
	 cpp.put_string(fz_infix);
	 cpp.put_character(' ');
      end;

feature -- For pretty :

   definition_pretty_print is
      do
	 fmt.keyword(fz_infix);
	 fmt.put_character('%"');
	 fmt.put_string(to_string);
	 fmt.put_character('%"');
      end;

feature

   short is
      do
	 short_print.a_infix_name("Bifn","infix %"",
				  "Aifn","%"",
				  Current);
      end;

end -- INFIX_NAME

