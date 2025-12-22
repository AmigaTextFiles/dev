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
deferred class CP_INFO_TAGS
   --
   -- Common root for CONSTANT_POOL, CP_INFO and 
   -- PRINT_JVM_CLASS.
   --

inherit GLOBALS;

feature {NONE}

   empty_code:               CHARACTER is '%/0/';
   class_code:               CHARACTER is '%/7/';
   fieldref_code:            CHARACTER is '%/9/';
   methodref_code:           CHARACTER is '%/10/';
   interface_methodref_code: CHARACTER is '%/11/';
   string_code:              CHARACTER is '%/8/';
   integer_code:             CHARACTER is '%/3/';
   float_code:               CHARACTER is '%/4/';
   long_code:                CHARACTER is '%/5/';
   double_code:              CHARACTER is '%/6/';
   name_and_type_code:       CHARACTER is '%/12/';
   uft8_code:                CHARACTER is '%/1/';

feature {NONE}

   string_to_uft8(string, uft8: STRING) is
	 -- Source `string' is not affected.
      require
	 string /= Void;
	 uft8 /= Void;
	 uft8 /= string
      do
	 uft8.clear;
	 append_u2(uft8,string.count);
	 uft8.append(string);
      ensure
	 string.count = old string.count;
	 uft8.count = 2 + string.count
      end;

end -- CP_INFO_TAGS

