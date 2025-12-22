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
class TMP_NAME
   --
   -- Unique object for temprary storage of an unkown name
   -- during syntax analysis.
   --
   
inherit GLOBALS;
   
creation {EIFFEL_PARSER}
   make

feature {NONE}
   
   tmp_string: STRING is
      once
	 !!Result.make(256);
      end;

   unique_string_memory: STRING;

feature {EIFFEL_PARSER}
   
   li, co: INTEGER;
   
feature {NONE}

   make is 
      do 
      end;

feature {EIFFEL_PARSER}

   initialize(l, c: INTEGER) is
      do
	 li := l;
	 co := c;
	 tmp_string.clear;
	 unique_string_memory := Void;
      end;

feature {EIFFEL_PARSER}

   is_current: BOOLEAN is
      do
	 if tmp_string.count = 7 then
	    Result := us_current.same_as(tmp_string);
	 end;
      end;

   is_result: BOOLEAN is
      do
	 if tmp_string.count = 6 then
	    Result := us_result.same_as(tmp_string);
	 end;
      end;

   is_void: BOOLEAN is
      do
	 if tmp_string.count = 4 then
	    Result := us_void.same_as(tmp_string);
	 end;
      end;

   to_string: STRING is
      do
	 if unique_string_memory = Void then
	    Result := unique_string.item(tmp_string);
	    unique_string_memory := Result;
	 else
	    Result := unique_string_memory;
	 end;
      end;
   
   count: INTEGER is
      do
	 Result := tmp_string.count;
      end;

   start_position: POSITION is
      do
	 !!Result.make(li,co);
      end;
   
   extend(ch: CHARACTER) is
      do
	 tmp_string.extend(ch);
      end;
   
   isa_keyword: BOOLEAN is
      require
	 not tmp_string.empty
      local
	 c: CHARACTER;
      do
	 c := tmp_string.item(1).to_lower;
	 inspect
	    c
	 when 'a' then
	    Result := look_in(keyword_a);
	 when 'c' then
	    Result := look_in(keyword_c);
	 when 'd' then
	    Result := look_in(keyword_d);
	 when 'e' then
	    Result := look_in(keyword_e);
	 when 'f' then
	    Result := look_in(keyword_f);
	 when 'i' then
	    Result := look_in(keyword_i);
	 when 'l' then
	    Result := look_in(keyword_l);
	 when 'o' then
	    Result := look_in(keyword_o);
	 when 'p' then
	    Result := fz_prefix.same_as(tmp_string);
	 when 'r' then
	    Result := look_in(keyword_r);
	 when 's' then
	    Result := look_in(keyword_s);
	 when 't' then
	    Result := look_in(keyword_t);
	 when 'u' then
	    Result := look_in(keyword_u);
	 when 'v' then
	    Result := fz_variant.same_as(tmp_string);
	 when 'w' then
	    Result := fz_when.same_as(tmp_string);
	 when 'x' then
	    Result := us_xor.same_as(tmp_string);
	 else
	 end;
      end;

feature {EIFFEL_PARSER} -- Final Conversion Routines :
   
   to_argument_name1: ARGUMENT_NAME1 is
      do
	 !!Result.make(pos(li,co),tmp_string);
      end;

   to_argument_name2(fal: FORMAL_ARG_LIST; rank: INTEGER): ARGUMENT_NAME2 is
      do
	 !!Result.refer_to(pos(li,co),fal,rank);
      end;
   
   to_class_name: CLASS_NAME is
      do
	 !!Result.make(tmp_string,pos(li,co));
      end;
   
   to_e_current: E_CURRENT is
      require
	 is_current
      do
	 !!Result.make(pos(li,co),true);
      end;
   
   to_e_result: E_RESULT is
      require
	 is_result
      do
	 !!Result.make(pos(li,co));
      end;
   
   to_e_void: E_VOID is
      require
	 is_void
      do
	 !!Result.make(pos(li,co));
      end;
   
   to_simple_feature_name: SIMPLE_FEATURE_NAME is
      do
	 !!Result.make(tmp_string,pos(li,co));
      end;
   
   to_infix_name_use: INFIX_NAME is
      do
	 !!Result.make(tmp_string,pos(li,co));
      end;
   
   to_infix_name(sp: POSITION): INFIX_NAME is
      do
	 !!Result.make(tmp_string,sp);
      end;
   
   to_local_name1: LOCAL_NAME1 is
      do
	 !!Result.make(pos(li,co),tmp_string);
      end;

   to_local_name2(lvl: LOCAL_VAR_LIST; rank: INTEGER): LOCAL_NAME2 is
      do
	 !!Result.refer_to(pos(li,co),lvl,rank);
      end;
   
   to_prefix_name: PREFIX_NAME is
      do
	 !!Result.make(tmp_string,pos(li,co));
      end;
   
   to_tag_name: TAG_NAME is
      do
	 !!Result.make(tmp_string,pos(li,co));
      end;
   
feature {NONE}
   
   keyword_a: ARRAY[STRING] is
      once
	 Result := <<fz_alias,fz_all,us_and,fz_as>>;
      end;
   
   keyword_c: ARRAY[STRING] is
      once
	 Result := <<fz_check,fz_class,fz_creation>>;
      end;
   
   keyword_d: ARRAY[STRING] is
      once
	 Result := <<fz_debug,fz_deferred,fz_do>>;
      end;
   
   keyword_e: ARRAY[STRING] is
      once
	 Result := <<fz_else,fz_elseif,fz_end,fz_ensure,
		     fz_expanded,fz_export,fz_external>>;
      end;
   
   keyword_f: ARRAY[STRING] is
      once
	 Result := <<fz_false,fz_feature,fz_from,fz_frozen>>;
      end;
   
   keyword_i: ARRAY[STRING] is
      once
	 Result := <<fz_if,us_implies,fz_indexing,fz_infix,
		     fz_inherit,fz_inspect,fz_invariant,fz_is>>;
      end;
   
   keyword_l: ARRAY[STRING] is
      once
	 Result := <<fz_like,fz_local,fz_loop>>;
      end;
   
   keyword_o: ARRAY[STRING] is
      once
	 Result := <<fz_obsolete,fz_old,fz_once,us_or>>;
      end;
   
   keyword_r: ARRAY[STRING] is
      once
	 Result := <<fz_redefine,fz_rename,fz_require,fz_rescue,fz_retry>>;
      end;
   
   keyword_s: ARRAY[STRING] is
      once
	 Result := <<fz_select,fz_separate,fz_strip>>;
      end;
   
   keyword_t: ARRAY[STRING] is
      once
	 Result := <<fz_then,fz_true>>;
      end;
   
   keyword_u: ARRAY[STRING] is
      once
	 Result := <<fz_undefine,fz_unique,fz_until>>;
      end;
   
   look_in(kt: ARRAY[STRING]): BOOLEAN is
      require
	 not tmp_string.empty;
	 not kt.empty;
	 kt.lower = 1
      local
	 i: INTEGER;
      do
	 from  
	    i := kt.upper;
	 until
	    Result or else i = 0
	 loop
	    Result := kt.item(i).same_as(tmp_string);
	    i := i - 1;
	 end;
      end; 

end -- TMP_NAME

