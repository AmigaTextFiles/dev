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
deferred class FROZEN_STRING_LIST
   --   
   -- Shared Frozen String list.
   --

feature {NONE} -- Frozen list of some keywords :

   fz_alias:              STRING is "alias";
   fz_all:                STRING is "all";
   fz_as:                 STRING is "as";
   fz_check:              STRING is "check";
   fz_class:              STRING is "class";
   fz_creation:           STRING is "creation";
   fz_debug:              STRING is "debug";
   fz_deferred:           STRING is "deferred";
   fz_do:                 STRING is "do";
   fz_else:               STRING is "else";
   fz_elseif:             STRING is "elseif";
   fz_end:                STRING is "end";
   fz_ensure:             STRING is "ensure";
   fz_expanded:           STRING is "expanded";
   fz_export:             STRING is "export";
   fz_external:           STRING is "external";
   fz_false:              STRING is "false";
   fz_feature:            STRING is "feature";
   fz_from:               STRING is "from";
   fz_frozen:             STRING is "frozen";
   fz_if:                 STRING is "if";
   fz_indexing:           STRING is "indexing";
   fz_infix:              STRING is "infix";
   fz_inherit:            STRING is "inherit";
   fz_inspect:            STRING is "inspect";
   fz_invariant:          STRING is "invariant";
   fz_is:                 STRING is "is";
   fz_jvm_invokestatic:   STRING is "JVM_invokestatic";
   fz_jvm_invokevirtual:  STRING is "JVM_invokevirtual";
   fz_like:               STRING is "like";
   fz_local:              STRING is "local";
   fz_loop:               STRING is "loop";
   fz_obsolete:           STRING is "obsolete";
   fz_old:                STRING is "old";
   fz_once:               STRING is "once";
   fz_open:               STRING is "fopen";
   fz_prefix:             STRING is "prefix";
   fz_redefine:           STRING is "redefine";
   fz_rename:             STRING is "rename";
   fz_require:            STRING is "require";
   fz_rescue:             STRING is "rescue";
   fz_retry:              STRING is "retry";
   fz_select:             STRING is "select";
   fz_separate:           STRING is "separate";
   fz_strip:              STRING is "strip";
   fz_then:               STRING is "then";
   fz_true:               STRING is "true";
   fz_undefine:           STRING is "undefine";
   fz_unique:             STRING is "unique";
   fz_until:              STRING is "until";
   fz_variant:            STRING is "variant";
   fz_when:               STRING is "when";

feature {NONE} -- Frozen list of messages :

   fz_arrow_id:        STRING is "->id";
   fz_bad_anchor:      STRING is "Bad anchor.";
   fz_bad_argument:    STRING is "Bad argument.";
   fz_bad_arguments:   STRING is "Bad arguments.";
   fz_bad_assertion:   STRING is "Bad Assertion.";
   fz_bcv:             STRING is "Bad CHARACTER value.";
   fz_bga:             STRING is "Bad generic argument.";
   fz_biv:             STRING is "Bad INTEGER value.";
   fz_bnga:            STRING is "Bad number of generic arguments.";
   fz_blhsoa:          STRING is "Bad left hand side of assignment.";
   fz_brhsoa:          STRING is "Bad right hand side of assignment.";
   fz_cad:             STRING is "Cyclic anchored definition.";
   fz_cbe:             STRING is " cannot be expanded. ";
   fz_cnf:             STRING is "Class not found.";
   fz_dot:             STRING is ".";
   fz_desc:            STRING is "Deleted extra semi-colon.";
   fz_iinaiv:          STRING is "It is not an integer value.";
   fz_ich:             STRING is "Incompatible headings.";
   fz_inako:           STRING is " is not a kind of ";
   fz_is_invalid:      STRING is " is invalid.";
   fz_is_not_boolean:  STRING is " is not BOOLEAN.";
   fz_not_found:       STRING is " Not found.";
   fz_error_stars:     STRING is "****** ";
   fz_jvm_error:       STRING is "Incompatible with Java bytecode.";

feature {NONE} -- Frozen list of other names :

   fz_bin:                     STRING is "bin";
   fz_bit_foo:                 STRING is "BIT ";
   fz_char:                    STRING is "char";
   fz_clean:                   STRING is "clean";
   fz_close_c_comment:         STRING is "*/";
   fz_compile:                 STRING is "compile";
   fz_cast_gcfsh_star:         STRING is "(gcfsh*)";
   fz_cast_gcnah_star:         STRING is "(gcnah*)";
   fz_cast_t0_star:            STRING is "(T0*)";
   fz_cast_void_star:          STRING is "(void*)";
   fz_c_eq:                    STRING is "==";
   fz_c_if_neq_null:           STRING is "if(NULL!=";
   fz_c_if_eq_null:            STRING is "if(NULL==";
   fz_c_inlinewithcurrent:     STRING is "C_InlineWithCurrent";
   fz_c_inlinewithoutcurrent:  STRING is "C_InlineWithoutCurrent";
   fz_c_neq:                   STRING is "!=";
   fz_c_no_args_procedure:     STRING is "();%N";
   fz_c_no_args_function:      STRING is "()";
   fz_c_shift_left:            STRING is "<<";
   fz_c_shift_right:           STRING is ">>";
   fz_c_void_args:             STRING is "(void)";
   fz_c_withcurrent:           STRING is "C_WithCurrent";
   fz_c_withoutcurrent:        STRING is "C_WithoutCurrent";
   fz_define:                  STRING is "define";
   fz_double:                  STRING is "double";
   fz_exit:                    STRING is "exit";
   fz_extern:                  STRING is "extern ";
   fz_float:                   STRING is "float";
   fz_gc:                      STRING is "gc";
   fz_gc_info:                 STRING is "gc_info";
   fz_gc_mark:                 STRING is "gc_mark";
   fz_gc_sweep:                STRING is "gc_sweep";
   fz_gc_sweep_pool:           STRING is "gc_sweep_pool";
   fz_gcc:                     STRING is "gcc";
   fz_int:                     STRING is "int";
   fz_jvm_root:                STRING is "_any"
   fz_like_foo:                STRING is "like ";
   fz_main:                    STRING is "main";
   fz_new:                     STRING is "new";
   fz_new_pool:                STRING is "new_pool";
   fz_null:                    STRING is "NULL";
   fz_open_c_comment:          STRING is "/*";
   fz_printf:                  STRING is "printf";
   fz_return:                  STRING is "return";
   fz_se:                      STRING is "SmallEiffel";
   fz_se_cmpt:                 STRING is "se_cmpT";
   fz_sizeof:                  STRING is "sizeof";
   fz_static:                  STRING is "static ";
   fz_struct:                  STRING is "struct ";
   fz_sys:                     STRING is "sys";
   fz_system_se:               STRING is "system.se";
   fz_t0_star:                 STRING is "T0*";
   fz_t7_star:                 STRING is "T7*";
   fz_to_t:                    STRING is "toT";
   fz_typedef:                 STRING is "typedef ";
   fz_unsigned:                STRING is "unsigned";
   fz_void:                    STRING is "void";

feature {NONE} -- Frozen list numbered not in UNIQUE_STRING :

   fz_00: STRING is ";%N";
   fz_01: STRING is "File %"";
   fz_02: STRING is "Done.%N";
   fz_03: STRING is "%"."
   fz_04: STRING is "Pre-Computed Once Function";
   fz_05: STRING is "(s):%N";
   fz_06: STRING is " is concerned.";
   fz_07: STRING is " is ever created.";
   fz_08: STRING is "Unknown flag : ";
   fz_09: STRING is "Feature %"";
   fz_10: STRING is " : %%d\n%",";
   fz_11: STRING is "{%N";
   fz_12: STRING is "}%N";
   fz_13: STRING is "))";
   fz_14: STRING is ");%N";
   fz_15: STRING is "return R;%N}%N";
   fz_16: STRING is "));%N"
   fz_17: STRING is "((";
   fz_18: STRING is "%"%N";
   fz_19: STRING is ")V";
   fz_21: STRING is "Ljava/lang/Object;";
   fz_23: STRING is "([Ljava/lang/String;)V";
   fz_24: STRING is "string";
   fz_25: STRING is "java/io/PrintStream";
   fz_26: STRING is "java/lang/Float";
   fz_27: STRING is "(I)V";
   fz_28: STRING is "_initialize";
   fz_29: STRING is "()V";
   fz_30: STRING is "I";
   fz_31: STRING is "[B";
   fz_32: STRING is "java/lang/String";
   fz_33: STRING is "getBytes";
   fz_34: STRING is "()[B";
   fz_35: STRING is "<init>";
   fz_36: STRING is "java/lang/System";
   fz_37: STRING is "in";
   fz_38: STRING is "Ljava/io/InputStream;";
   fz_39: STRING is "out";
   fz_40: STRING is "Ljava/io/PrintStream;";
   fz_41: STRING is "B";
   fz_42: STRING is "close";
   fz_49: STRING is "err";
   fz_50: STRING is "Assertion failed.";
   fz_51: STRING is "println";
   fz_52: STRING is "traceInstructions";
   fz_53: STRING is "java/lang/Runtime";
   fz_54: STRING is "(Z)V";
   fz_55: STRING is "getRuntime";
   fz_56: STRING is "()Ljava/lang/Runtime;";
   fz_57: STRING is "(Ljava/lang/String;)V";
   fz_58: STRING is "check_flag";
   fz_59: STRING is "0.";
   fz_60: STRING is "valueOf0";
   fz_61: STRING is "(Ljava/lang/String;)D";
   fz_62: STRING is "java/lang/Double";
   fz_63: STRING is "toString";
   fz_64: STRING is "(D)Ljava/lang/String;";
   fz_65: STRING is "([BII)V";
   fz_66: STRING is "String";
   fz_67: STRING is "java/io/FileInputStream";
   fz_68: STRING is "(Ljava/lang/String;)V";
   fz_69: STRING is "java/io/InputStream";
   fz_70: STRING is "read";
   fz_71: STRING is "()I";
   fz_72: STRING is "java/io/FileOutputStream";
   fz_73: STRING is "Z";
   fz_74: STRING is "args";
   fz_75: STRING is "[Ljava/lang/String;";
   fz_76: STRING is "<clinit>";
   fz_77: STRING is "D";
   fz_78: STRING is "F";
   fz_79: STRING is "getProperty";
   fz_80: STRING is "(Ljava/lang/String;)Ljava/lang/String;";
   fz_81: STRING is "java/lang/Integer";
   fz_82: STRING is "parseInt";
   fz_83: STRING is "(Ljava/lang/String;)I";
   fz_84: STRING is "java/lang/Throwable";
   fz_85: STRING is "java/io/File";
   fz_86: STRING is "exists";
   fz_87: STRING is "()Z";
   fz_88: STRING is "(Ljava/io/File;)V";
   fz_89: STRING is "exec";
   fz_90: STRING is "(Ljava/lang/String;)Ljava/lang/Process;";
   fz_91: STRING is "waitFor";
   fz_92: STRING is "java/lang/Process";
   fz_93: STRING is "java/lang/Math";
   fz_94: STRING is "(D)D";
   fz_95: STRING is "MAX_VALUE";
   fz_96: STRING is "()D";
   fz_97: STRING is "()F";
   fz_98: STRING is "MIN_VALUE";
   fz_99: STRING is "(DD)D";
   fz_a0: STRING is "java/util/BitSet";
   fz_a1: STRING is "equals";
   fz_a2: STRING is "get";
   fz_a3: STRING is "(I)Z";
   fz_a4: STRING is "set";
   fz_a5: STRING is "clear";
   fz_a6: STRING is "clone";
   fz_a7: STRING is "()Ljava/lang/Object;";
   fz_a8: STRING is "(Ljava/lang/Object;)Z";
   fz_a9: STRING is "Ljava/util/BitSet;";
   fz_b1: STRING is "(Ljava/util/BitSet;)V";
   fz_b2: STRING is "delete";
   fz_b3: STRING is "renameTo";
   fz_b4: STRING is "(Ljava/io/File;)Z";
   fz_b5: STRING is ")->_";
   fz_b6: STRING is ".%N";
   fz_b0: STRING is "%".%N";

end -- FROZEN_STRING_LIST

