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
deferred class FEATURE_NAME
--   
-- Root of INFIX_NAME, PREFIX_NAME and SIMPLE_NAME.
--

inherit NAME;
   
feature 
   
   start_position: POSITION;
   
   is_frozen: BOOLEAN;
   
feature {FEATURE_NAME}

   make(n: STRING; sp: like start_position) is
      require
	 n.count >= 1;
	 sp /= Void
      deferred
      ensure
	 to_string = unique_string.item(n);
	 start_position = sp;
	 to_key = unique_string.item(to_key)
      end;

feature

   origin_base_class: BASE_CLASS is
	 -- Void or the BASE_CLASS where Current is written in.
      local
	 sp: like start_position;
      do
	 sp := start_position;
	 if sp /= Void then
	    Result := sp.base_class;
	 end;
      end;

feature 

   mapping_c_in(str: STRING) is
      do
	 str.append(to_key);
      end;

feature 
   
   cpp_put_infix_or_prefix is
      deferred
      end;

   name_in(sc: BASE_CLASS): FEATURE_NAME is
	 --                 ************
	 -- ***             like Current
	 --                 ************
	 -- Using the `start_position', compute possible renaming
	 -- when starting look_up from `sc'.
      require
	 origin_base_class = sc or else 
	 sc.is_subclass_of(origin_base_class)
      local
	 bc: BASE_CLASS;
      do
	 bc := origin_base_class
	 if bc = sc then
	    Result := Current;
	 else
	    Result := sc.new_name_of(bc,Current);
	 end;
      ensure
	 Result /= Void
      end;
   
   is_freeop: BOOLEAN is
      do
	 inspect 
	    to_string @ 1
	 when '@', '#', '|', '&' then
	    Result := true;
	 else
	 end;
      end;

feature -- For pretty :   

   definition_pretty_print is
      deferred
      end;

feature

   short is
      deferred
      end;

feature {EIFFEL_PARSER}
   
   set_is_frozen(value: BOOLEAN) is
      do
	 is_frozen := value;
      ensure
	 is_frozen = value;
      end;

feature {E_FEATURE}

   undefine_in(bc: BASE_CLASS) is
      require
	 bc /= Void
      do
	 if is_frozen then
	    error(start_position,
		  "A frozen feature must not be undefined (VDUS).");
	    bc.fatal_undefine(Current);
	 end;
      end;

end -- FEATURE_NAME


