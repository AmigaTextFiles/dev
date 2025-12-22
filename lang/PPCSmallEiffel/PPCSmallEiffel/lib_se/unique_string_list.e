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
deferred class UNIQUE_STRING_LIST
   -- 
   -- The initial set of STRING in UNIQUE_STRING.
   --

feature {NONE} -- Class names :

   us_any:              STRING is "ANY";
   us_array:            STRING is "ARRAY";
   us_bit:              STRING is "BIT";
   us_bit_n:            STRING is "BIT_N";
   us_bit_n_ref:        STRING is "BIT_N_REF";
   us_boolean:          STRING is "BOOLEAN";
   us_boolean_ref:      STRING is "BOOLEAN_REF";
   us_character:        STRING is "CHARACTER";
   us_character_ref:    STRING is "CHARACTER_REF";
   us_dictionary:       STRING is "DICTIONARY";
   us_double:           STRING is "DOUBLE";
   us_double_ref:       STRING is "DOUBLE_REF";
   us_fixed_array:      STRING is "FIXED_ARRAY";
   us_general:          STRING is "GENERAL";
   us_integer:          STRING is "INTEGER";
   us_integer_ref:      STRING is "INTEGER_REF";
   us_memory:           STRING is "MEMORY";
   us_native_array:     STRING is "NATIVE_ARRAY";
   us_none:             STRING is "NONE";
   us_platform:         STRING is "PLATFORM";
   us_pointer:          STRING is "POINTER";
   us_pointer_ref:      STRING is "POINTER_REF";
   us_real:             STRING is "REAL";
   us_real_ref:         STRING is "REAL_REF";
   us_string:           STRING is "STRING";
   us_std_file_read:    STRING is "STD_FILE_READ";

feature {NONE} -- Operator/Infix/Prefix list :

   us_and:                   STRING is "and";
   us_and_then:              STRING is "and then";
   us_at:                    STRING is "@";
   us_backslash_backslash:   STRING is "\\";
   us_eq:                    STRING is "=";
   us_ge:                    STRING is ">=";
   us_gt:                    STRING is ">";
   us_implies:               STRING is "implies";
   us_le:                    STRING is "<=";
   us_lt:                    STRING is "<";
   us_minus:                 STRING is "-";
   us_muls:                  STRING is "*";
   us_neq:                   STRING is "/=";
   us_not:                     STRING is "not";
   us_or:                    STRING is "or";
   us_or_else:               STRING is "or else";
   us_plus:                  STRING is "+";
   us_pow:                   STRING is "^";
   us_shift_left:            STRING is "@<<";
   us_shift_right:           STRING is "@>>";
   us_slash:                 STRING is "/";
   us_slash_slash:           STRING is "//";
   us_std_neq:               STRING is "#";
   us_xor:                   STRING is "xor"; 

feature {NONE} -- Feature names :

   us_blank:                    STRING is "blank";
   us_bitn:                     STRING is "bit_n";
   us_boolean_bits:             STRING is "Boolean_bits";
   us_calloc:                   STRING is "calloc";
   us_capacity:                 STRING is "capacity";
   us_character_bits:           STRING is "Character_bits";
   us_clear_all:                STRING is "clear_all";
   us_compile_to_c:             STRING is "compile_to_c";
   us_compile_to_jvm:           STRING is "compile_to_jvm";
   us_count:                    STRING is "count";
   us_crash:                    STRING is "crash";
   us_code:                     STRING is "code";
   us_conforms_to:              STRING is "conforms_to";
   us_copy:                     STRING is "copy";
   us_c_inline_c:               STRING is "c_inline_c";
   us_c_inline_h:               STRING is "c_inline_h";
   us_double_bits:              STRING is "Double_bits";
   us_double_floor:             STRING is "double_floor";
   us_die_with_code:            STRING is "die_with_code";
   us_element_sizeof:           STRING is "element_sizeof";
   us_eof_code:                 STRING is "eof_code";
   us_fclose:                   STRING is "fclose";
   us_feof:                     STRING is "feof";
   us_floor:                    STRING is "floor";
   us_flush_stream:             STRING is "flush_stream";
   us_free:                     STRING is "free";
   us_from_pointer:             STRING is "from_pointer";
   us_generating_type:          STRING is "generating_type";
   us_generator:                STRING is "generator";
   us_io:                       STRING is "io";
   us_integer_bits:             STRING is "Integer_bits";
   us_is_basic_expanded_type:   STRING is "is_basic_expanded_type";
   us_is_expanded_type:         STRING is "is_expanded_type";
   us_is_equal:                 STRING is "is_equal";
   us_is_not_void:              STRING is "is_not_void";
   us_item:                     STRING is "item";
   us_lower:                    STRING is "lower";
   us_malloc:                   STRING is "malloc";
   us_make:                     STRING is "make";
   us_minimum_character_code:   STRING is "Minimum_character_code";
   us_minimum_double:           STRING is "Minimum_double";
   us_minimum_integer:          STRING is "Minimum_integer";
   us_minimum_real:             STRING is "Minimum_real";
   us_maximum_character_code:   STRING is "Maximum_character_code";
   us_maximum_double:           STRING is "Maximum_double";
   us_maximum_integer:          STRING is "Maximum_integer";
   us_maximum_real:             STRING is "Maximum_real";
   us_object_size:              STRING is "object_size";
   us_pointer_bits:             STRING is "Pointer_bits";
   us_pointer_size:             STRING is "pointer_size";
   us_print:                    STRING is "print";
   us_print_on:                 STRING is "print_on";
   us_print_run_time_stack:     STRING is "print_run_time_stack";
   us_put:                      STRING is "put";
   us_put_0:                    STRING is "put_0";
   us_put_1:                    STRING is "put_1";
   us_read_byte:                STRING is "read_byte";
   us_real_bits:                STRING is "Real_bits";
   us_realloc:                  STRING is "realloc";
   us_se_argc:                  STRING is "se_argc";
   us_se_argv:                  STRING is "se_argv";
   us_se_getenv:                STRING is "se_getenv";
   us_se_remove:                STRING is "se_remove";
   us_se_rename:                STRING is "se_rename";
   us_se_string2double:         STRING is "se_string2double";
   us_se_system:                STRING is "se_system";
   us_sfr_open:                 STRING is "sfr_open";
   us_sfw_open:                 STRING is "sfw_open";
   us_sprintf_double:           STRING is "sprintf_double";
   us_sprintf_pointer:          STRING is "sprintf_pointer";
   us_standard_copy:            STRING is "standard_copy";
   us_standard_is_equal:        STRING is "standard_is_equal";
   us_standard_twin:            STRING is "standard_twin";
   us_stderr:                   STRING is "stderr";
   us_stdin:                    STRING is "stdin";
   us_stdout:                   STRING is "stdout";
   us_std_error:                STRING is "std_error";
   us_std_input:                STRING is "std_input";
   us_std_output:               STRING is "std_output";
   us_storage:                  STRING is "storage";
   us_to_bit:                   STRING is "to_bit";
   us_to_character:             STRING is "to_character";
   us_to_double:                STRING is "to_double";
   us_to_integer:               STRING is "to_integer";
   us_to_pointer:               STRING is "to_pointer";
   us_to_real:                  STRING is "to_real";
   us_trace_switch:             STRING is "trace_switch";
   us_truncated_to_integer:     STRING is "truncated_to_integer";
   us_twin:                     STRING is "twin";
   us_upper:                    STRING is "upper";
   us_with_capacity:            STRING is "with_capacity";
   us_write_byte:               STRING is "write_byte";

feature {NONE} -- Other names :

   us_current:                 STRING is "Current";
   us_native_array_character:  STRING is "NATIVE_ARRAY[CHARACTER]";
   us_like_current:            STRING is "like Current";
   us_result:                  STRING is "Result";
   us_void:                    STRING is "Void";

end -- UNIQUE_STRING_LIST

