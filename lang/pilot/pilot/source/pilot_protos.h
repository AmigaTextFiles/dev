/* Prototypes for functions defined in
pilot.c
 */

extern char * errmsg[21];

extern struct a_label * label_list;

extern struct a_label * last;

extern struct symbol_entry * symbol_table;

extern struct symbol_entry * symbol_node;

extern int subroutine_stack[10];

extern FILE * fileid;

extern char def_string[256];

extern int current_line;

extern int line_loc;

extern int last_line_loc;

extern int boolean;

extern int boolean_cont;

extern int nesting_level;

extern int error;

extern int furthest_into_file;

extern int debug;

int main(int argc,
         char ** argv);

int init(char * fname);

int wrapup(int);

int parse(char * line);

int type(char * line);

int typehang(char * line);

int accept(char * line);

int match(char * line);

int jump(char * line);

int pause(char * line);

int ink(char * line);

int endit(char * line);

int use(char * line);

int compute(char * line);

int label(char * line,
          int loc);

int raise_error(int errno,
                int errtype,
                char * arg);

int in_string(char * buffer,
              char * pattern);

int check_condition(char * line);

int remove_past_colon(char * line);

int break_string(char * line,
                 char * lhs,
                 char * op,
                 char * rhs);

int add_label(char * name);

int find_label(char * name);

int get_to_label(int loc,
                 char * labelname);

struct symbol_entry * add_symbol(struct symbol_entry * node,
                                 char * symbol);

int print_symbol_table(struct symbol_entry * node);

struct symbol_entry * find_symbol(struct symbol_entry * node,
                                  char * symbol);

int substitute_vars(char * line);

int relation(char * exp);

int evaluate(char * exp);

int expression(char * exp);

int term(char * exp);

int factor(char * string);

char * get_token(char * line);

