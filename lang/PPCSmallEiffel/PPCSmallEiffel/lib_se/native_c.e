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
class NATIVE_C

inherit NATIVE;

feature {NONE}

   c_mapping_function_non_small_eiffel(rf8: RUN_FEATURE_8; name: STRING) is
      local
	 bf: EXTERNAL_FUNCTION;
	 bfuc, tcbd: BOOLEAN;
      do
	 bf := rf8.base_feature;
	 bfuc := bf.use_current;
	 if not bfuc then
	    tcbd := cpp.target_cannot_be_dropped;
	    if tcbd then
	       cpp.put_character(',');
	    end;
	 end;
	 cpp.put_string(bf.external_c_name);
	 cpp.put_character('(');
	 if bfuc then
	    cpp.put_target_as_value;
	 end;
	 if rf8.arg_count > 0 then
	    if bfuc then
	       cpp.put_character(',');
	    end;
	    cpp.put_arguments;
	 end;
	 cpp.put_character(')');
	 if not bfuc and then tcbd then
	    cpp.put_character(')');
	 end;
      end;

   c_mapping_procedure_non_small_eiffel(rf7: RUN_FEATURE_7; name: STRING) is
      local
	 bf: EXTERNAL_PROCEDURE;
	 bfuc: BOOLEAN;
      do
	 bf := rf7.base_feature;
	 bfuc := bf.use_current;
	 if not bfuc and then cpp.target_cannot_be_dropped then
	    cpp.put_string(fz_14);
	 end;
	 cpp.put_string(bf.external_c_name);
	 cpp.put_character('(');
	 if bfuc then
	    cpp.put_target_as_value;
	 end;
	 if rf7.arg_count > 0 then
	    if bfuc then
	       cpp.put_character(',');
	    end;
	    cpp.put_arguments;
	 end;
	 cpp.put_string(fz_14);
      end;

end -- NATIVE_C

