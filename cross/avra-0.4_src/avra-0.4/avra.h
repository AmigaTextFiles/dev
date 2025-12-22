/***********************************************************************
 *  avra - Assembler for the Atmel AVR microcontroller series
 *  Copyright (C) 1998-1999 Jon Anders Haugum
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; see the file COPYING.  If not, write to
 *  the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 *  Boston, MA 02111-1307, USA.
 *
 *
 *  Author of avra can be reached at:
 *     email: jonah@omegav.ntnu.no
 *     www: http://www.omegav.ntnu.no/~jonah/el/avra.html
 */

#include <stdio.h>

#define VERSION 0
#define REVISION 4
#define DATESTRING "24 March 1999"

#define IS_HOR_SPACE(x) ((x == ' ') || (x == 9))
#define IS_LABEL(x) (isalnum(x) || (x == '_'))
#define IS_END(x) ((x == ';') || (x == 10) || (x == 13)|| (x == '\0'))

#define LINEBUFFER_LENGTH 256

#define DSEG_START 0x60

/* Option enumeration */
enum
	{
	ARG_DEFINE = 0,       /* --define                */
	ARG_LISTMAC,          /* --listmac               */
	ARG_MAX_ERRORS,       /* --max_errors            */
	ARG_VER,              /* --version               */
	ARG_HELP,             /* --help, -h              */
	ARG_COUNT
	};

enum
	{
	MSGTYPE_ERROR = 0,
	MSGTYPE_WARNING,
	MSGTYPE_MESSAGE,
	MSGTYPE_OUT_OF_MEM
	};

enum
	{
	PASS_1 = 0,
	PASS_2
	};

enum
	{
	SEGMENT_CODE = 0,
	SEGMENT_DATA,
	SEGMENT_EEPROM
	};

enum
	{
	TERM_END = 0,
	TERM_SPACE,
	TERM_COMMA,
	TERM_EQUAL
	};

/* Structures */

struct prog_info
	{
	struct args *args;
	struct device *device;
	struct file_info *fi;
	struct macro_call *macro_call;
	struct macro_line *macro_line;
	FILE *list_file;
	int list_on;
	char *list_line;
	FILE *obj_file;
	struct hex_file_info *hfi;
	struct hex_file_info *eep_hfi;
	int segment;
	int cseg_addr;
	int dseg_addr;
	int eseg_addr;
	int cseg_count;
	int dseg_count;
	int eseg_count;
	int error_count;
	int max_errors;
	int warning_count;
	struct include_file *last_include_file;
	struct include_file *first_include_file;
	struct def *first_def;
	struct def *last_def;
	struct label *first_label;
	struct label *last_label;
	struct label *first_constant;
	struct label *last_constant;
	struct label *first_variable;
	struct label *last_variable;
	struct macro *first_macro;
	struct macro *last_macro;
	struct macro_call *first_macro_call;
	struct macro_call *last_macro_call;
	int conditional_depth;
	};

struct file_info
	{
	FILE *fp;
	struct include_file *include_file;
	char buff[LINEBUFFER_LENGTH];
	char scratch[LINEBUFFER_LENGTH];
	int line_number;
	int exit_file;
	struct label *label;
	};

struct hex_file_info
	{
	FILE *fp;
	int count;
	int linestart_addr;
	unsigned char hex_line[16];
	};

struct include_file
	{
	struct include_file *next;
	char *name;
	int num;
	};

struct def
	{
	struct def *next;
	char *name;
	int reg;
	};

struct label
	{
	struct label *next;
	char *name;
	int value;
	};

struct macro
	{
	struct macro *next;
	char *name;
	struct include_file *include_file;
	int first_line_number;
	struct macro_line *first_macro_line;
	};

struct macro_line
	{
	struct macro_line *next;
	char *line;
	};

struct macro_call
	{
	struct macro_call *next;
	int line_number;
	struct include_file *include_file;
	struct macro_call *prev_on_stack;
	struct macro *macro;
	int line_index;
	int prev_line_index;
	int nest_level;
	struct label *first_label;
	struct label *last_label;
	};

/* Prototypes */
/* avra.c */
void assemble(struct prog_info *pi);
int load_arg_defines(struct prog_info *pi);
struct prog_info *get_pi(struct args *args);
void free_pi(struct prog_info *pi);
void prepare_second_pass(struct prog_info *pi);
void print_msg(struct prog_info *pi, int type, char *fmt, ... );

/* parser.c */
int parse_file(struct prog_info *pi, char *filename, int pass);
int parse_line(struct prog_info *pi, char *line, int pass);
char *get_next_token(char *scratch, int term);

/* expr.c */
int get_expr(struct prog_info *pi, char *data, int *value);
int get_operator(char *op);
int test_operator_at_precedence(int operator, int precedence);
int calc(struct prog_info *pi, int left, int operator, int right);
int get_function(char *function);
int do_function(int function, int value);
int log2(int value);
int get_symbol(struct prog_info *pi, char *label_name, int *data);
int par_length(char *data);

/* mnemonic.c */
int parse_mnemonic(struct prog_info *pi, int pass);
int get_mnemonic_type(char *mnemonic);
int get_register(struct prog_info *pi, char *data);
int get_bitnum(struct prog_info *pi, char *data, int *ret);
int get_indirect(struct prog_info *pi, char *operand);

/* directiv.c */
int parse_directive(struct prog_info *pi, int pass);
int get_directive_type(char *directive);
char *term_string(struct prog_info *pi, char *string);
int parse_db(struct prog_info *pi, char *next, int pass);
void write_db(struct prog_info *pi, char byte, char *prev, int count, int pass);
int spool_conditional(struct prog_info *pi, int only_endif);
int check_conditional(struct prog_info *pi, char *buff, int *current_depth, int *do_next, int only_endif);

/* macro.c */
int read_macro(struct prog_info *pi, char *name, int pass);
struct macro *get_macro(struct prog_info *pi, char *name);
int expand_macro(struct prog_info *pi, struct macro *macro, char *rest_line, int pass);

/* file.c */
int open_out_files(struct prog_info *pi, char *filename);
void close_out_files(struct prog_info *pi);
struct hex_file_info *open_hex_file(char *filename);
void close_hex_file(struct hex_file_info *hfi);
void write_ee_byte(struct prog_info *pi, int address, unsigned char data);
void write_prog_word(struct prog_info *pi, int address, int data);
void do_hex_line(struct hex_file_info *hfi);
FILE *open_obj_file(struct prog_info *pi, char *filename);
void close_obj_file(struct prog_info *pi, FILE *fp);
void write_obj_record(struct prog_info *pi, int address, int data);

/* map.c */
void write_map_file(struct prog_info *pi);
char *Space(char *n);

/* stdextra.c */
char *nocase_strcmp(char *s, char *t);
char *nocase_strncmp(char *s, char *t, int n);
char *nocase_strstr(char *s, char *t);
int atox(char *s);
int atoi_n(char *s, int n);
int atox_n(char *s, int n);












