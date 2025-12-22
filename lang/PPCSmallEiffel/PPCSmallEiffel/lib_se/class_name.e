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
class CLASS_NAME
   --   
   -- To store the base class name of a class.
   --

inherit 
   NAME
      redefine fill_tagged_out_memory
      end;
   
creation make
   
creation {BASE_CLASS}
   make_unknown
   
feature 
   
   start_position: POSITION;
   
feature {NONE}
   
   make_unknown is
      do
	 !!start_position.with(1,1,Current);
	 to_string := unknown_name;
      end;
   
feature 
   
   make(n: STRING; sp: like start_position) is
      require
	 n /= Void;
      do
	 start_position := sp;
	 to_string := unique_string.item(n);
      ensure
	 start_position = sp;
	 to_string = unique_string.item(n)
      end;
   
feature 
   
   to_key: STRING is
      do
	 Result := to_string;
      end;

   fill_tagged_out_memory is
      do
	 tagged_out_memory.append(to_string);
      end;

   is_unknown: BOOLEAN is
      do
	 Result := to_string = unknown_name;
      end;
   
   is_subclass_of(other: CLASS_NAME): BOOLEAN is
      require
	 to_string /= other.to_string;
	 eh.empty;
      do
	 if us_any = other.to_string then
	    Result := true;
	 elseif us_none = other.to_string then
	 else
	    Result := base_class.is_subclass_of(other.base_class);
	 end;
      ensure
	 eh.empty;
      end;
   
feature 
   
   predefined: BOOLEAN is
	 -- All following classes are handled in a special way
	 -- by the TYPE_* corresponding class.
      do
	 Result := (us_any = to_string or else
		    us_array = to_string or else
		    us_boolean = to_string or else
		    us_character = to_string or else
		    us_double = to_string or else
		    us_integer = to_string or else
		    us_none = to_string or else
		    us_pointer = to_string or else
		    us_real = to_string or else
		    us_string = to_string);
      end;
   
   to_runnable: TYPE is
	 -- Return the corresponding simple (not generic) run type.
      do
	 if us_any = to_string then
	    !TYPE_ANY!Result.make(start_position);
	 elseif us_boolean = to_string then
	    !TYPE_BOOLEAN!Result.make(start_position);
	 elseif us_character = to_string then
	    !TYPE_CHARACTER!Result.make(start_position);
	 elseif us_double = to_string then
	    !TYPE_DOUBLE!Result.make(start_position);
	 elseif us_integer = to_string then
	    !TYPE_INTEGER!Result.make(start_position);
	 elseif us_none = to_string then
	    !TYPE_NONE!Result.make(start_position);
	 elseif us_pointer = to_string then
	    !TYPE_POINTER!Result.make(start_position);
	 elseif us_real = to_string then
	    !TYPE_REAL!Result.make(start_position);
	 elseif us_string = to_string then
	    !TYPE_STRING!Result.make(start_position);
	 else	    
	    !TYPE_CLASS!Result.make(Current);
	 end;
      end;
   
   base_class: BASE_CLASS is
      do
	 Result := small_eiffel.base_class(Current);
      end;
   
   is_a(other: like Current): BOOLEAN is
      require
	 other /= Void;
	 eh.empty;
      local
	 to_string2: STRING;
	 bc1, bc2: like base_class;
      do
	 to_string2 := other.to_string;
	 if us_any = to_string2 then
	    Result := true;
	 elseif to_string = to_string2 then
	    Result := true;
	 elseif us_none = to_string2 then
	 else
	    bc1 := base_class;
	    bc2 := other.base_class;
	    if bc1 = Void then
	       eh.append("Unable to load ");
	       eh.append(to_string);
	       error(start_position,fz_dot);
	    elseif bc2 = Void then
	       eh.append("Unable to load ");
	       eh.append(to_string2);
	       error(start_position,fz_dot);
	    else
	       Result := bc1.is_subclass_of(bc2); 
	    end;
	 end;
      end;

feature {EIFFEL_PARSER}
   
   identify(s: STRING) is
      require
	 is_unknown
      do
	 to_string := unique_string.item(s);
      ensure
	 to_string = unique_string.item(s)
      end;

feature {NONE}
      
   unknown_name: STRING is "FOO";
   
end -- CLASS_NAME

