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
class RUN_CONTROL
   --
   -- Selection of Eiffel run time options.
   --
   
inherit GLOBALS;
   
creation make
   
feature {NONE} -- Numbering of levels are those of E.T.L. (pp 133) :
   
   level: INTEGER;
	 -- Actual level of checking;
   
   level_no: INTEGER is -5;
	 -- No assertion checking of any kind.
   
   level_require: INTEGER is -4; 
	 -- Evaluate the preconditions.
   
   level_ensure: INTEGER is -3;
	 -- Also evaluate postconditions.
		 
   level_invariant: INTEGER is -2;
	 -- Also evaluate the class invariant on entry to and return from.
   
   level_loop: INTEGER is -1;
	 -- Also evaluate the loop variant and the loop invariant.
   
   level_check_all: INTEGER is 0;
	 -- Also evaluate the check instruction.
	 -- The default value.
		    
   level_check_debug: INTEGER is 1;
	 -- Also evaluate the debug instruction.
		    
   level_boost: INTEGER is -6;
	 -- BOOST :-). Very very speed level. 
	 -- Do not check for Void target.
	 -- Do not check system level validity.
		
   make is do end;
   
feature  -- Consultation :

   trace: BOOLEAN;
	 -- Flag for trace mode.

   boost: BOOLEAN is
      do
	 Result := level = level_boost;
      end;
   
   no_check: BOOLEAN is
      do
	 Result := level >= level_no;
      end;
   
   require_check: BOOLEAN is
      do
	 Result := level >= level_require;
      end;
   
   ensure_check: BOOLEAN is
      do
	 Result := level >= level_ensure;
      end;
   
   invariant_check: BOOLEAN is
      do
	 Result := level >= level_invariant;
      end;
   
   loop_check: BOOLEAN is
      do
	 Result := level >= level_loop;
      end;
   
   all_check: BOOLEAN is
      do
	 Result := level >= level_check_all;
      end;
   
   debug_check: BOOLEAN is
      do
	 Result := level = level_check_debug;
      end;
   
   root_class: STRING;
	 -- Name given in the system command line to find 
	 -- the root class.
   
feature -- Setting :
   
   set_boost is  
      do
	 level := level_boost;
      end;
   
   set_no_check is
      do
	 level := level_no;
      end;
   
   set_require_check is
      do
	 level := level_require;
      end;
   
   set_ensure_check is
      do
	 level := level_ensure;
      end;
   
   set_invariant_check is
      do
	 level := level_invariant;
      end;
   
   set_loop_check is
      do
	 level := level_loop;
      end;
   
   set_all_check is
      do
	 level := level_check_all;
      end;
   
   set_debug_check is
      do
	 level := level_check_debug;
      end;
   
   set_root_class(rc: STRING) is
      require
	 rc /= Void;
      do
	 root_class := rc;
      ensure
	 root_class = rc;
      end;

   set_trace is
      do
	 trace := true;
      end;

feature -- Other settings :

   set_cecil_path(path: STRING) is
      do
	 cecil_path := path;
      ensure
	 cecil_path = path
      end;

   cecil_path: STRING; 
	 -- Not Void when option -cecil used.

invariant
   
   level_boost <= level ;
   
   level <= level_check_debug;
   
end -- RUN_CONTROL

