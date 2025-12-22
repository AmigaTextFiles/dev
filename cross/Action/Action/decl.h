#ifndef DECL__H
#define DECL__H

#ifdef __cplusplus
extern "C" {
#endif

extern struct link *new_class_spec (int first_char_of_lexeme);
extern void set_class_bit (int first_char_of_lexeme,struct link *p);
extern struct link *new_type_spec (char *lexeme);
extern void add_spec_to_decl (struct link *p_spec,struct symbol *decl_chain);
extern void add_symbols_to_table (struct symbol *sym);
extern void figure_osclass (struct symbol *sym);
extern void generate_defs_and_free_args (struct symbol *sym);
extern struct symbol *remove_duplicates (struct symbol *sym);
extern void print_bss_dcl (struct symbol *sym);
extern void var_dcl (int (*ofunct)(const char *,...),int c_code_sclass,struct symbol *sym,char *terminator);
extern int illegal_struct_def (struct structdef *cur_struct,struct symbol *fields);
extern int figure_struct_offsets (struct symbol *p,int is_struct);
extern int get_alignment (struct link *p);
extern void do_enum (struct symbol *sym,int val);
extern int conv_sym_to_int_const (struct symbol *sym,int val);
extern void fix_types_and_discard_syms (struct symbol *sym);
extern int figure_param_offsets (struct symbol *sym);
extern void print_offset_comment (struct symbol *sym,char *label);
extern void RemoveSymbols(symbol *sym);

#ifdef __cplusplus
}
#endif

#endif
