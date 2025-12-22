/* Generated automatically by the program 'build/genpreds'
   from the machine description file '/home/sba/amiga/adtools.git/gcc/repo/gcc/config/rs6000/rs6000.md'.  */

#ifndef GCC_TM_PREDS_H
#define GCC_TM_PREDS_H

#ifdef HAVE_MACHINE_MODES
extern int general_operand (rtx, machine_mode);
extern int address_operand (rtx, machine_mode);
extern int register_operand (rtx, machine_mode);
extern int pmode_register_operand (rtx, machine_mode);
extern int scratch_operand (rtx, machine_mode);
extern int immediate_operand (rtx, machine_mode);
extern int const_int_operand (rtx, machine_mode);
extern int const_scalar_int_operand (rtx, machine_mode);
extern int const_double_operand (rtx, machine_mode);
extern int nonimmediate_operand (rtx, machine_mode);
extern int nonmemory_operand (rtx, machine_mode);
extern int push_operand (rtx, machine_mode);
extern int pop_operand (rtx, machine_mode);
extern int memory_operand (rtx, machine_mode);
extern int indirect_operand (rtx, machine_mode);
extern int ordered_comparison_operator (rtx, machine_mode);
extern int comparison_operator (rtx, machine_mode);
extern int any_operand (rtx, machine_mode);
extern int any_parallel_operand (rtx, machine_mode);
extern int count_register_operand (rtx, machine_mode);
extern int altivec_register_operand (rtx, machine_mode);
extern int vsx_register_operand (rtx, machine_mode);
extern int vfloat_operand (rtx, machine_mode);
extern int vint_operand (rtx, machine_mode);
extern int vlogical_operand (rtx, machine_mode);
extern int ca_operand (rtx, machine_mode);
extern int s5bit_cint_operand (rtx, machine_mode);
extern int u3bit_cint_operand (rtx, machine_mode);
extern int u5bit_cint_operand (rtx, machine_mode);
extern int s8bit_cint_operand (rtx, machine_mode);
extern int u10bit_cint_operand (rtx, machine_mode);
extern int short_cint_operand (rtx, machine_mode);
extern int u_short_cint_operand (rtx, machine_mode);
extern int non_short_cint_operand (rtx, machine_mode);
extern int exact_log2_cint_operand (rtx, machine_mode);
extern int const_0_to_1_operand (rtx, machine_mode);
extern int const_0_to_3_operand (rtx, machine_mode);
extern int const_2_to_3_operand (rtx, machine_mode);
extern int const_0_to_15_operand (rtx, machine_mode);
extern int gpc_reg_operand (rtx, machine_mode);
extern int int_reg_operand (rtx, machine_mode);
extern int base_reg_operand (rtx, machine_mode);
extern int htm_spr_reg_operand (rtx, machine_mode);
extern int quad_int_reg_operand (rtx, machine_mode);
extern int cc_reg_operand (rtx, machine_mode);
extern int cc_reg_not_cr0_operand (rtx, machine_mode);
extern int cc_reg_not_micro_cr0_operand (rtx, machine_mode);
extern int reg_or_short_operand (rtx, machine_mode);
extern int reg_or_neg_short_operand (rtx, machine_mode);
extern int reg_or_aligned_short_operand (rtx, machine_mode);
extern int reg_or_u_short_operand (rtx, machine_mode);
extern int reg_or_cint_operand (rtx, machine_mode);
extern int add_cint_operand (rtx, machine_mode);
extern int reg_or_add_cint_operand (rtx, machine_mode);
extern int reg_or_sub_cint_operand (rtx, machine_mode);
extern int reg_or_logical_cint_operand (rtx, machine_mode);
extern int vsx_reg_or_cint_operand (rtx, machine_mode);
extern int easy_fp_constant (rtx, machine_mode);
extern int easy_vector_constant (rtx, machine_mode);
extern int easy_vector_constant_add_self (rtx, machine_mode);
extern int easy_vector_constant_msb (rtx, machine_mode);
extern int zero_constant (rtx, machine_mode);
extern int zero_fp_constant (rtx, machine_mode);
extern int volatile_mem_operand (rtx, machine_mode);
extern int offsettable_mem_operand (rtx, machine_mode);
extern int quad_memory_operand (rtx, machine_mode);
extern int indexed_or_indirect_operand (rtx, machine_mode);
extern int reg_or_indexed_operand (rtx, machine_mode);
extern int altivec_indexed_or_indirect_operand (rtx, machine_mode);
extern int indexed_or_indirect_address (rtx, machine_mode);
extern int indexed_address (rtx, machine_mode);
extern int update_address_mem (rtx, machine_mode);
extern int indexed_address_mem (rtx, machine_mode);
extern int fix_trunc_dest_operand (rtx, machine_mode);
extern int add_operand (rtx, machine_mode);
extern int adde_operand (rtx, machine_mode);
extern int non_add_cint_operand (rtx, machine_mode);
extern int logical_const_operand (rtx, machine_mode);
extern int logical_operand (rtx, machine_mode);
extern int non_logical_cint_operand (rtx, machine_mode);
extern int mask_operand (rtx, machine_mode);
extern int mask_operand_wrap (rtx, machine_mode);
extern int mask64_operand (rtx, machine_mode);
extern int mask64_2_operand (rtx, machine_mode);
extern int any_mask_operand (rtx, machine_mode);
extern int and64_2_operand (rtx, machine_mode);
extern int and_operand (rtx, machine_mode);
extern int and_2rld_operand (rtx, machine_mode);
extern int scc_eq_operand (rtx, machine_mode);
extern int reg_or_mem_operand (rtx, machine_mode);
extern int reg_or_none500mem_operand (rtx, machine_mode);
extern int zero_reg_mem_operand (rtx, machine_mode);
extern int vsx_scalar_64bit (rtx, machine_mode);
extern int lwa_operand (rtx, machine_mode);
extern int symbol_ref_operand (rtx, machine_mode);
extern int got_operand (rtx, machine_mode);
extern int got_no_const_operand (rtx, machine_mode);
extern int rs6000_tls_symbol_ref (rtx, machine_mode);
extern int call_operand (rtx, machine_mode);
extern int current_file_function_operand (rtx, machine_mode);
extern int input_operand (rtx, machine_mode);
extern int splat_input_operand (rtx, machine_mode);
extern int rs6000_nonimmediate_operand (rtx, machine_mode);
extern int boolean_operator (rtx, machine_mode);
extern int boolean_or_operator (rtx, machine_mode);
extern int equality_operator (rtx, machine_mode);
extern int min_max_operator (rtx, machine_mode);
extern int branch_comparison_operator (rtx, machine_mode);
extern int rs6000_cbranch_operator (rtx, machine_mode);
extern int unsigned_comparison_operator (rtx, machine_mode);
extern int signed_comparison_operator (rtx, machine_mode);
extern int scc_comparison_operator (rtx, machine_mode);
extern int scc_rev_comparison_operator (rtx, machine_mode);
extern int branch_positive_comparison_operator (rtx, machine_mode);
extern int load_multiple_operation (rtx, machine_mode);
extern int store_multiple_operation (rtx, machine_mode);
extern int save_world_operation (rtx, machine_mode);
extern int restore_world_operation (rtx, machine_mode);
extern int vrsave_operation (rtx, machine_mode);
extern int mfcr_operation (rtx, machine_mode);
extern int mtcrf_operation (rtx, machine_mode);
extern int crsave_operation (rtx, machine_mode);
extern int lmw_operation (rtx, machine_mode);
extern int stmw_operation (rtx, machine_mode);
extern int tie_operand (rtx, machine_mode);
extern int small_toc_ref (rtx, machine_mode);
extern int fusion_gpr_addis (rtx, machine_mode);
extern int fusion_gpr_mem_load (rtx, machine_mode);
extern int fusion_gpr_mem_combo (rtx, machine_mode);
#endif /* HAVE_MACHINE_MODES */

#define CONSTRAINT_NUM_DEFINED_P 1
enum constraint_num
{
  CONSTRAINT__UNKNOWN = 0,
  CONSTRAINT_r,
  CONSTRAINT_f,
  CONSTRAINT_d,
  CONSTRAINT_b,
  CONSTRAINT_h,
  CONSTRAINT_c,
  CONSTRAINT_l,
  CONSTRAINT_v,
  CONSTRAINT_x,
  CONSTRAINT_y,
  CONSTRAINT_z,
  CONSTRAINT_wa,
  CONSTRAINT_wd,
  CONSTRAINT_wf,
  CONSTRAINT_wg,
  CONSTRAINT_wh,
  CONSTRAINT_wi,
  CONSTRAINT_wj,
  CONSTRAINT_wk,
  CONSTRAINT_wl,
  CONSTRAINT_wm,
  CONSTRAINT_wn,
  CONSTRAINT_wr,
  CONSTRAINT_ws,
  CONSTRAINT_wt,
  CONSTRAINT_wu,
  CONSTRAINT_wv,
  CONSTRAINT_ww,
  CONSTRAINT_wx,
  CONSTRAINT_wy,
  CONSTRAINT_wz,
  CONSTRAINT_I,
  CONSTRAINT_J,
  CONSTRAINT_K,
  CONSTRAINT_L,
  CONSTRAINT_M,
  CONSTRAINT_N,
  CONSTRAINT_O,
  CONSTRAINT_P,
  CONSTRAINT_m,
  CONSTRAINT_o,
  CONSTRAINT_wQ,
  CONSTRAINT_wZ,
  CONSTRAINT_es,
  CONSTRAINT_Q,
  CONSTRAINT_Y,
  CONSTRAINT_Z,
  CONSTRAINT_p,
  CONSTRAINT_a,
  CONSTRAINT_V,
  CONSTRAINT__l,
  CONSTRAINT__g,
  CONSTRAINT_i,
  CONSTRAINT_s,
  CONSTRAINT_n,
  CONSTRAINT_E,
  CONSTRAINT_F,
  CONSTRAINT_X,
  CONSTRAINT_wD,
  CONSTRAINT_G,
  CONSTRAINT_H,
  CONSTRAINT_R,
  CONSTRAINT_S,
  CONSTRAINT_T,
  CONSTRAINT_U,
  CONSTRAINT_t,
  CONSTRAINT_W,
  CONSTRAINT_j,
  CONSTRAINT__LIMIT
};

extern enum constraint_num lookup_constraint_1 (const char *);
extern const unsigned char lookup_constraint_array[];

/* Return the constraint at the beginning of P, or CONSTRAINT__UNKNOWN if it
   isn't recognized.  */

static inline enum constraint_num
lookup_constraint (const char *p)
{
  unsigned int index = lookup_constraint_array[(unsigned char) *p];
  return (index == UCHAR_MAX
          ? lookup_constraint_1 (p)
          : (enum constraint_num) index);
}

extern bool (*constraint_satisfied_p_array[]) (rtx);

/* Return true if X satisfies constraint C.  */

static inline bool
constraint_satisfied_p (rtx x, enum constraint_num c)
{
  int i = (int) c - (int) CONSTRAINT_I;
  return i >= 0 && constraint_satisfied_p_array[i] (x);
}

static inline bool
insn_extra_register_constraint (enum constraint_num c)
{
  return c >= CONSTRAINT_r && c <= CONSTRAINT_wz;
}

static inline bool
insn_extra_memory_constraint (enum constraint_num c)
{
  return c >= CONSTRAINT_m && c <= CONSTRAINT_Z;
}

static inline bool
insn_extra_address_constraint (enum constraint_num c)
{
  return c >= CONSTRAINT_p && c <= CONSTRAINT_a;
}

static inline size_t
insn_constraint_len (char fc, const char *str ATTRIBUTE_UNUSED)
{
  switch (fc)
    {
    case 'e': return 2;
    case 'w': return 2;
    default: break;
    }
  return 1;
}

#define CONSTRAINT_LEN(c_,s_) insn_constraint_len (c_,s_)

extern enum reg_class reg_class_for_constraint_1 (enum constraint_num);

static inline enum reg_class
reg_class_for_constraint (enum constraint_num c)
{
  if (insn_extra_register_constraint (c))
    return reg_class_for_constraint_1 (c);
  return NO_REGS;
}

extern bool insn_const_int_ok_for_constraint (HOST_WIDE_INT, enum constraint_num);
#define CONST_OK_FOR_CONSTRAINT_P(v_,c_,s_) \
    insn_const_int_ok_for_constraint (v_, lookup_constraint (s_))

enum constraint_type
{
  CT_REGISTER,
  CT_CONST_INT,
  CT_MEMORY,
  CT_ADDRESS,
  CT_FIXED_FORM
};

static inline enum constraint_type
get_constraint_type (enum constraint_num c)
{
  if (c >= CONSTRAINT_p)
    {
      if (c >= CONSTRAINT_V)
        return CT_FIXED_FORM;
      return CT_ADDRESS;
    }
  if (c >= CONSTRAINT_m)
    return CT_MEMORY;
  if (c >= CONSTRAINT_I)
    return CT_CONST_INT;
  return CT_REGISTER;
}
#endif /* tm-preds.h */
