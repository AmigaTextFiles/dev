//-< JLINT.CPP >-----------------------------------------------------*--------*
// Jlint                      Version 1.09       (c) 1998  GARRET    *     ?  *
// (Java Lint)                                                       *   /\|  *
//                                                                   *  /  \  *
//                          Created:     28-Mar-98    K.A. Knizhnik  * / [] \ *
//                          Last update: 10-Sep-98    K.A. Knizhnik  * GARRET *
//-------------------------------------------------------------------*--------*
// Java verifier 
//-------------------------------------------------------------------*--------*

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <stdarg.h>
#include <ctype.h>
#ifdef _WIN32
#include <windows.h>
#define FILE_SEP '\\'
#else
#include <dirent.h>
#define FILE_SEP '/'
#endif

#ifndef MAX_PATH
#define MAX_PATH 1024
#endif

#include "jlint.h"

#ifdef INT8_DEFINED
#define TO_INT8(high, low)        ((nat8(high) << 32) | unsigned(low))
#define LOW_PART(x)               int4(x)
#define HIGH_PART(x)              int4(nat8(x) >> 32)

#define LOAD_INT8(src,field)      TO_INT8((src)[0].field, (src)[1].field)
#define STORE_INT8(dst,field,src) (dst)[0].field = HIGH_PART(src),\
				  (dst)[1].field = LOW_PART(src) 

#define INT8_MAX      ((int8)((nat8)-1 >> 1))
#define INT8_MIN      ((int8)(((nat8)-1 >> 1) + 1))
#define INT8_ZERO     ((int8)0)
#define INT8_ALL_BITS ((int8)-1)
#endif

#define MAX_ARRAY_LENGTH 0x7fffffff

#define ALL_BITS 0xffffffff
#define SIGN_BIT 0x80000000

int   verbose = false;
int   max_shown_paths = 4;

//
// All messages are reported by this function
// 

int   n_messages;

char* source_file_path;
int   source_file_path_len;
bool  source_path_redefined = false;
int   reported_message_mask = cat_all;
FILE* history; 

message_descriptor msg_table[] = {
#define MSG(category, code, position_dependent, format) \
{cat_##category, MSG_LOCATION_PREFIX##format, #code, position_dependent, true},
#include "jlint.msg"
{cat_all}
};

unsigned string_hash_function(byte* p) { 
    unsigned h = 0, g;
    while(*p) { 
	h = (h << 4) + *p++;
	if ((g = h & 0xF0000000) != 0) { 
	    h ^= g >> 24;
	}
	h &= ~g;
    }
    return h;
}


message_node* message_node::hash_table[1023];

bool message_node::find(char* msg_text) 
{
    unsigned h = string_hash_function((byte*)msg_text) % items(hash_table);
    for (message_node* msg = hash_table[h]; msg != NULL; msg = msg->next) { 
	if (strcmp(msg->text, msg_text) == 0) { 
	    return true;
	}
    }
    return false;
}

void message_node::add_to_hash(char* msg_text)
{
    unsigned h = string_hash_function((byte*)msg_text) % items(hash_table);
    message_node* msg = new message_node(msg_text);
    msg->next = hash_table[h];
    hash_table[h] = msg;
} 
			
void format_message(int code, utf_string const& file, int line, va_list ap)
{
    static int loop_id;
    static message_node *first, *last;
    static char* compound_message;
    void* parameter[MAX_MSG_PARAMETERS];
    int   n_parameters = 2;
	
    if (code == msg_loop || code == msg_sync_loop) { // extract loop identifier
	parameter[n_parameters++] = va_arg(ap, void*);
    }
    if (history != NULL) { 
	if (compound_message != NULL
	    && ((loop_id != 0 
		 && ((code != msg_loop && code != msg_sync_loop)
		     || (int)parameter[2] != loop_id))
		|| (loop_id == 0 && code != msg_wait_path)))
	{
	    if (!message_node::find(compound_message)) { 
		message_node *msg = first, *next;
		do { 
		    next = msg->next;
		    fprintf(stdout, "%s\n", msg->text);
		    delete msg;
		    n_messages += 1;
		} while ((msg = next) != NULL);
		fprintf(history, "%s\n", compound_message);	
	    }
	    delete[] compound_message;
	    compound_message = NULL;
	}
    }
    if ((reported_message_mask & msg_table[code].category) 
	&& msg_table[code].enabled)
    {
	static int prev_line = 0;
	
	char  msg_buf[MAX_MSG_LENGTH];
	char  his_buf[MAX_MSG_LENGTH];
	char* hp = his_buf;
	
	if (line == 0) { 
	    line = ++prev_line; // avoid several messages with 0 line number
	} else { 
	    prev_line = 0;
	}
	parameter[0] = file.as_asciz();
	parameter[1] = (void*)line;

	if (history) { 
	    hp += sprintf(hp, "%s", msg_table[code].name);
	}
	    
	char const* src = msg_table[code].format;
	char* dst = msg_buf;

	if (code == msg_done) { 
	    // do not output location prefix for termination message
	    src += strlen(MSG_LOCATION_PREFIX);
	    parameter[0] = (void*)n_messages;
	}
	while (*src != 0) { 
	    if (*src == '%') { 
		int index;
		int pos;
		int n = sscanf(++src, "%d%n", &index, &pos); 
		assert(n == 1);
		assert(index < MAX_MSG_PARAMETERS);
		while (index >= n_parameters) { 
		    parameter[n_parameters++] = va_arg(ap, void*);
		}
		src += pos;
		char* save_dst = dst;
		switch (*src++) {
		  case 's': // zero terminated string
		    dst += sprintf(dst, "%s", (char*)parameter[index]);  
		    break;
		  case 'm': // method descriptor
		    dst += ((method_desc*)parameter[index])->
			demangle_method_name(dst);
		    break;
		  case 'u': // utf8 string
		    dst += sprintf(dst, "%s", 
				 ((utf_string*)parameter[index])->as_asciz()); 
		    break;
		  case 'c': // class descriptor
		    dst += sprintf(dst, "%s", ((class_desc*)parameter[index])->
				   name.as_asciz()); 
		    break;
		  case 'd': // integer
		    dst += sprintf(dst, "%d", (int)parameter[index]);  
		    break;
		  default:
		    assert(false/*bad message parameter format*/);
		}
		if (history) { 
		    // append parameeter to history buffer
		    if ((index >= 2 || msg_table[code].position_dependent)
			&& (code != msg_sync_loop || index > 2) 
			&& (code != msg_loop || index > 3))
		    {
			// Do not inlude loop number in history message
			hp += sprintf(hp, ":%.*s", dst - save_dst, save_dst);
		    }
		}
	    } else { 
		*dst++ = *src++;
	    }
	}
	*dst = 0;
	if (history != NULL) { 
	    if (compound_message != NULL) { 
		char* new_msg = new char[strlen(compound_message)
					+strlen(his_buf)+2];
		sprintf(new_msg, "%s;%s", compound_message, his_buf);
		last = last->next = new message_node(msg_buf);
		delete[] compound_message;
		compound_message = new_msg;
	    } else { 
		if (code == msg_loop || code == msg_sync_loop 
		    || code == msg_wait) 
                { 
		    compound_message = strdup(his_buf);
		    first = last = new message_node(msg_buf);
		    if (code != msg_wait) { 
			loop_id = (int)parameter[2];
		    }
		} else if (!message_node::find(his_buf)) { 
		    fprintf(stdout, "%s\n", msg_buf);
		    if (code != msg_done) { 
			fprintf(history, "%s\n", his_buf);
			n_messages += 1;
		    }
		}
	    }
	} else { 
	    fprintf(stdout, "%s\n", msg_buf);
	    if (code != msg_done) { 
		n_messages += 1;
	    }
	}
    } 
}

void message_at(int code, utf_string const& file, int line, ...)
{
    va_list ap;
    va_start(ap, line);
    format_message(code, file, line, ap);
    va_end(ap);
}


//
// Some bit support functions
//

inline int first_set_bit(int4 val)
{
    if (val == 0) { 
	return 32;
    } 
    int n = 0;
    while (!(val & 1)) { 
	n += 1;
	val >>= 1;
    }
    return n;
}

inline int last_set_bit(nat4 val)
{
    int n = 0;
    if (val == 0) {
	return -1;
    }
    while ((val >>= 1) != 0) { 
	n += 1;
    }
    return n;
}

inline int minimum(int4 x, int4 y) { return x < y ? x : y; }
inline int maximum(int4 x, int4 y) { return x > y ? x : y; }


//
// Functions for extracting information from type descriptors
//

int get_number_of_parameters(utf_string const& str)
{
    char* p = str.as_asciz();
    assert(*p++ =='(');
    int n_params = 0;
    while (*p != ')') { 
	switch (*p++) { 
	  case '[':
	    while (*p == '[') p += 1;
	    if (*p++ == 'L') { 
		while (*p++ != ';');
	    }
	    n_params += 1;
	    break;
	  case 'D':
	  case 'J':
	    n_params += 2;
	    break;
	  case 'L':
	    while (*p++ != ';');
	    nobreak;
	  default:
	    n_params += 1;
	}
    }
    return n_params;
} 


int get_type(utf_string const& str) 
{ 
    char* p = str.as_asciz();
    if (*p == '(') { 
	while (*++p != ')'); 
	p += 1;
    }
    int indirect = 0;
    while (*p == '[') { 
	p += 1;
	indirect += 1;
    }
    type_tag tag = tp_object;
    switch (*p) { 
      case 'I': tag = tp_int; break;
      case 'S': tag = tp_short; break;
      case 'D': tag = tp_double; break;
      case 'J': tag = tp_long; break;
      case 'F': tag = tp_float; break;
      case 'V': tag = tp_void; break;
      case 'B': tag = tp_byte; break;
      case 'C': tag = tp_char; break;
      case 'Z': tag = tp_bool; break;
      default:
	if (strcmp(p, "Ljava/lang/String;") == 0) tag = tp_string;
    }
    return int(tag) + (indirect << 8);
}

//
// Methods of callee_desc class
//

void callee_desc::message(int code, ...)
{
    va_list ap;
    va_start(ap, code);
    format_message(code, self_class->source_file, line, ap);
    va_end(ap);
}

//
// Methods of access_desc class
//

void access_desc::message(int code, ...)
{
    va_list ap;
    va_start(ap, code);
    format_message(code, self_class->source_file, line, ap);
    va_end(ap);
}

//
// Methods of graph_edge class
//

void graph_edge::message(int loop_id)
{
    caller->print_call_path_to(invocation, loop_id, 0);
    class_desc* abstract_class = invocation->method->cls; 
    invocation->method->cls = vertex->cls;
    invocation->message(msg_sync_loop, (void*)loop_id, invocation->method);
    invocation->method->cls = abstract_class;
    mask |= (1 << (loop_id & 31));
}
    
void print_call_sequence(callee_desc* callee, int loop_id, int path_id)
{
    if (callee != NULL) { 
	print_call_sequence((callee_desc*)callee->backtrace, loop_id, path_id);
	callee->message(msg_loop, (void*)loop_id, (void*)path_id, 
			callee->method);
    }
}

//
// Methods of graph_vertex class
//

graph_vertex* graph_vertex::graph;
int graph_vertex::n_vertexes;

void graph_vertex::verify()
{
    graph_edge** stack = new graph_edge*[n_vertexes];
    int marker = 0;
    int n_loops = 0;
    
    for (graph_vertex* root = graph; root != NULL; root = root->next) { 
	if (root->marker <= marker || root->visited >= max_shown_paths) { 
	    continue;
	}
	int sp = 0;
	int i;
	
	graph_edge* edge = root->edges; 
	root->visited |= flag_vertex_on_path;
	root->marker = ++marker;

	while (edge != NULL) { 
	    while (edge->vertex->marker >= marker || 
		   edge->vertex->visited < max_shown_paths) 
            {
		graph_vertex* vertex = edge->vertex;
		stack[sp++] = edge;

		if (vertex->visited & flag_vertex_on_path) { 
		    // we found loop in the graph
		    unsigned mask = edge->mask;
		    for (i = sp-1; --i >= 0 && stack[i]->vertex != vertex;) { 
			mask &= stack[i]->mask;
		    }
		    if (mask == 0) { 
			n_loops += 1;
			while (++i < sp) { 
			    stack[i]->message(n_loops);
			}
		    }
		} else { 
		    // Pass through the graph in depth first order
		    if (vertex->edges != NULL) { 
			vertex->visited = 
			    (vertex->visited + 1) | flag_vertex_on_path;
			vertex->marker = marker;
			vertex->n_loops = n_loops;
			edge = vertex->edges;
			continue;
		    }
		}
		sp -= 1;
		break;
	    } // end of depth-first loop

	    while (edge->next == NULL) { 
		if (--sp < 0) break;
		edge = stack[sp];
		edge->vertex->visited &= ~flag_vertex_on_path;
		if (edge->vertex->n_loops == n_loops) { 
		    // This path doesn't lead to deadlock: avoid future
		    // visits of this vertex
		    edge->vertex->marker = 0;
		}
	    }
	    edge = edge->next;
	}
	root->visited &= ~flag_vertex_on_path;
    }
}

//
// Methods of local_context class
//

static int_type_range const ranges[] = { 
    //   min         max
    {0x00000000, 0x00000001}, // tp_bool
    {0xffffff80, 0x0000007f}, // tp_byte 
    {0x00000000, 0x0000ffff}, // tp_char
    {0xffff8000, 0x00007fff}, // tp_short
    {0x80000000, 0x7fffffff}  // tp_int
};


vbm_operand* ctx_push_var::transfer(method_desc* method, vbm_operand* sp, 
				    byte, byte&)
{
    var_desc* var = &method->vars[var_index];
    if (var->type == tp_void) { 
	if (IS_INT_TYPE(var_type)) { 
	    var->min  = ranges[var_type].min;
	    var->max  = ranges[var_type].max;
	    var->mask = var->min|var->max;
	} else if (var_type == tp_long) { 
	    var[0].min  = 0x80000000;
	    var[0].max  = 0x7fffffff;
	    var[0].mask = 0xffffffff;
	    var[1].min  = 0;
	    var[1].max  = 0xffffffff;
	    var[1].mask = 0xffffffff;	    
	} else { 
	    var->mask = (var->type == tp_self) 
		? var_desc::vs_not_null : var_desc::vs_unknown;
	    var->min = 0;
	    var->max = MAX_ARRAY_LENGTH;
	}
    }
    var->type = var_type;
    var->name = *var_name;
    var->start_pc = var_start_pc;
    return sp;
}

vbm_operand* ctx_pop_var::transfer(method_desc* method, vbm_operand* sp, 
				   byte, byte&)
{
    var_desc* var = &method->vars[var_index];
    for (field_desc* field = method->cls->fields; 
	 field != NULL; 
	 field = field->next)
    { 
	// Do not produce message about shadowing of class camponent by local
	// variable in case when local variable is formal parameter of the
	// method and programmer explicitly refer class object component
	// by "this": this.x = x;
	if (field->name == var->name 
	    && (!(field->attr & field_desc::f_used) 
		|| var->start_pc != 0 /* not formal parameter*/))
	{
	    method->message(msg_shadow_local, var->start_pc, 
			    &var->name, method->cls);
	    break;
	}
    }
    var->type = tp_void;
    var->name = utf_string("???");
    return sp;
}


vbm_operand* ctx_split::transfer(method_desc* method, vbm_operand* sp, 
				 byte cop, byte& prev_cop)
{
    if (n_branches > 0 && cmd == cmd_save_ctx) { 
	vars = new var_desc[method->n_vars];
	memcpy(vars, method->vars, method->n_vars*sizeof(var_desc));
    } else { 
	vars = NULL;
    }
    switch_var_index = -1;

    vbm_operand* left_op = sp-2;
    vbm_operand* right_op = sp-1;
    
    switch (cop) { 
      case jsr:
      case jsr_w:	
	sp->type = tp_object;
	sp->mask = var_desc::vs_not_null;
	sp->min = 0;
	sp->max = MAX_ARRAY_LENGTH;
	stack_pointer = sp+1;
	break;
      case tableswitch:
      case lookupswitch:
	stack_pointer = right_op;
	switch_var_index = right_op->index;
	break;
      case ifeq:
	if (vars != NULL && right_op->index >= 0) { 
	    // state at the branch address
	    var_desc* var = &vars[right_op->index];
	    if (prev_cop == iand) { 
		// Operation of form (x & const) == 0
		if (IS_INT_TYPE(var->type)) { 
		    var->mask &= ~right_op->mask;
		}
	    } else { 
		var->max = var->min = 0;
		if (IS_INT_TYPE(var->type)) { 
		    var->mask = 0;
		}
	    } 
	}
	stack_pointer = right_op;
	break;
      case ifne:
	if (right_op->index >= 0) { // value of local var. was pushed on stack 
	    // state after if
	    var_desc* var = &method->vars[right_op->index];
	    if (prev_cop == iand) { 
		// Operation of form (x & const) != 0
		if (IS_INT_TYPE(var->type)) { 
		    var->mask &= ~right_op->mask;
		}
	    } else { 
		var->max = var->min = 0;
		if (IS_INT_TYPE(var->type)) { 
		    var->mask = 0;
		}
	    }
	}
	stack_pointer = right_op;
	break;
      case iflt:
	if (right_op->index >= 0) { 
	    // state after if
	    var_desc* var = &method->vars[right_op->index];
	    if (var->min < 0) var->min = 0;
	    if (var->max < 0) var->max = 0;
	    if (IS_INT_TYPE(var->type)) { 
		var->mask &= ~SIGN_BIT;
	    }
	    if (vars != NULL) { // forward branch
		// state at the branch address
		var = &vars[right_op->index];
		if (var->min >= 0) var->min = -1;
		if (var->max >= 0) var->max = -1;
	    }
	}
	stack_pointer = right_op;
	break;	    
      case ifge:
	if (right_op->index >= 0) { 
	    // state after if
	    var_desc* var = &method->vars[right_op->index];
	    if (var->min >= 0) var->min = -1;
	    if (var->max >= 0) var->max = -1;
	    if (vars != NULL) { // forward branch
		// state at the branch address
		var = &vars[right_op->index];
		if (var->min < 0) var->min = 0;
		if (var->max < 0) var->max = 0;
		if (IS_INT_TYPE(var->type)) { 
		    var->mask &= ~SIGN_BIT;
		}
	    }
	}
	stack_pointer = right_op;
	break;	    
      case ifgt:
	if (right_op->index >= 0) { 
	    // state after if
	    var_desc* var = &method->vars[right_op->index];
	    if (var->min > 0) var->min = 0;
	    if (var->max > 0) var->max = 0;
	    if (vars != NULL) { // forward branch
		// state at the branch address
		var = &vars[right_op->index];
		if (var->min <= 0) var->min = 1;
		if (var->max <= 0) var->max = 1;
		if (IS_INT_TYPE(var->type)) { 
		    var->mask &= ~SIGN_BIT;
		}
	    }
	}
	stack_pointer = right_op;
	break;	    
      case ifle:
	if (right_op->index >= 0) { 
	    // state after if
	    var_desc* var = &method->vars[right_op->index];
	    if (var->min <= 0) var->min = 1;
	    if (var->max <= 0) var->max = 1;
	    if (IS_INT_TYPE(var->type)) { 
		var->mask &= ~SIGN_BIT;
	    }
	    if (vars != NULL) { // forward branch
		// state at the branch address
		var = &vars[right_op->index];
		if (var->min > 0) var->min = 0;
		if (var->max > 0) var->max = 0;
	    }
	}
	stack_pointer = right_op;
	break;	    
      case if_icmpeq:
	if (vars != NULL) { 
	    // state at the branch address
	    if (right_op->index >= 0) { 
		var_desc* var = &vars[right_op->index];
		if (var->min < left_op->min) var->min = left_op->min;
		if (var->max > left_op->max) var->max = left_op->max;
		if (var->min > var->max) var->min = var->max; // recovery
		if (IS_INT_TYPE(var->type)) { 
		    var->mask &= left_op->mask;
		}
	    }
	    if (left_op->index >= 0) { 
		var_desc* var = &vars[left_op->index];
		if (var->min < right_op->min) var->min = right_op->min;
		if (var->max > right_op->max) var->max = right_op->max;
		if (var->min > var->max) var->min = var->max; // recovery
		if (IS_INT_TYPE(var->type)) { 
		    var->mask &= right_op->mask;
		}
	    }
	}
	stack_pointer = left_op;
	break;	    
      case if_icmpne:
	if (right_op->index >= 0) { 
	    // state after if
	    var_desc* var = &method->vars[right_op->index];
	    if (var->min < left_op->min) var->min = left_op->min;
	    if (var->max > left_op->max) var->max = left_op->max;
	    if (var->min > var->max) var->min = var->max; // recovery
	    if (IS_INT_TYPE(var->type)) { 
		var->mask &= left_op->mask;
	    }
	}
	if (left_op->index >= 0) { 
	    var_desc* var = &method->vars[left_op->index];
	    if (var->min < right_op->min) var->min = right_op->min;
	    if (var->max > right_op->max) var->max = right_op->max;
	    if (var->min > var->max) var->min = var->max; // recovery
	    if (IS_INT_TYPE(var->type)) { 
		var->mask &= right_op->mask;
	    }
	}
	stack_pointer = left_op;
	break;	    
      case if_icmplt:
	if (right_op->index >= 0) { 	
	    // left >= right
	    var_desc* var = &method->vars[right_op->index];
	    if (var->max > left_op->max) { 
		var->max = left_op->max;
		if (var->min > var->max) var->min = var->max;
	    }
	    if (vars != NULL) { 
		// left < right
		var = &vars[right_op->index];
		if (var->min <= left_op->min) { 
		    var->min = left_op->min == ranges[tp_int].max 
			? left_op->min : left_op->min+1;
		    if (var->min > var->max) var->max = var->min;
		}
	    }
	}
	if (left_op->index >= 0) { 
	    // left >= right
	    var_desc* var = &method->vars[left_op->index];
	    if (var->min < right_op->min) { 
		var->min = right_op->min;
		if (var->min > var->max) var->max = var->min;
	    }
	    if (vars != NULL) { 
		// left < right
		var = &vars[left_op->index];
		if (var->max >= right_op->max) { 
		    var->max = right_op->max == ranges[tp_int].min 
			? right_op->max : right_op->max-1;
		    if (var->min > var->max) var->min = var->max;
		}
	    }
	}
	stack_pointer = left_op;	
	break;
      case if_icmple:
	if (right_op->index >= 0) { 	
	    // left > right
	    var_desc* var = &method->vars[right_op->index];
	    if (var->max >= left_op->max) { 
		var->max = left_op->max == ranges[tp_int].min
		    ? left_op->max : left_op->max-1;
		if (var->min > var->max) var->min = var->max;
	    }
	    if (vars != NULL) { 
		// left <= right
		var = &vars[right_op->index];
		if (var->min < left_op->min) { 
		    var->min = left_op->min;
		    if (var->min > var->max) var->max = var->min;
		}
	    }
	}
	if (left_op->index >= 0) { 
	    // left > right
	    var_desc* var = &method->vars[left_op->index];
	    if (var->min <= right_op->min) { 
		var->min = right_op->min == ranges[tp_int].max
		    ? right_op->min : right_op->min+1;
		if (var->min > var->max) var->max = var->min;
	    }
	    if (vars != NULL) { 
		// left <= right
		var = &vars[left_op->index];
		if (var->max > right_op->max) { 
		    var->max = right_op->max;
		    if (var->min > var->max) var->min = var->max;
		}
	    }
	}
	stack_pointer = left_op;	
	break;
      case if_icmpgt:
	if (right_op->index >= 0) { 	
	    // left <= right
	    var_desc* var = &method->vars[right_op->index];
	    if (var->min < left_op->min) { 
		var->min = left_op->min;
		if (var->min > var->max) var->max = var->min;
	    }
	    if (vars != NULL) { 
		// left > right
		var = &vars[right_op->index];
		if (var->max >= left_op->max) { 
		    var->max = left_op->max == ranges[tp_int].min 
			? left_op->max : left_op->max-1;
		    if (var->min > var->max) var->min = var->max;
		}
	    }
	}
	if (left_op->index >= 0) { 
	    // left <= right
	    var_desc* var = &method->vars[left_op->index];
	    if (var->max > right_op->max) { 
		var->max = right_op->max;
		if (var->min > var->max) var->min = var->max;
	    }
	    if (vars != NULL) { 
		// left > right
		var = &vars[left_op->index];
		if (var->min <= right_op->min) { 
		    var->min = right_op->min == ranges[tp_int].max 
			? right_op->min : right_op->min+1;
		    if (var->min > var->max) var->max = var->min;
		}
	    }
	}
	stack_pointer = left_op;	
	break;
      case if_icmpge:
	if (right_op->index >= 0) { 	
	    // left < right
	    var_desc* var = &method->vars[right_op->index];
	    if (var->min <= left_op->min) { 
		var->min = left_op->min == ranges[tp_int].max
		    ? left_op->min : left_op->min+1;
		if (var->min > var->max) var->max = var->min;
	    }
	    if (vars != NULL) { 
		// left >= right
		var = &vars[right_op->index];
		if (var->max > left_op->max) { 
		    var->max = left_op->max;
		    if (var->min > var->max) var->min = var->max;
		}
	    }
	}
	if (left_op->index >= 0) { 
	    // left < right
	    var_desc* var = &method->vars[left_op->index];
	    if (var->max >= right_op->max) { 
		var->max = right_op->max == ranges[tp_int].min
		    ? right_op->max : right_op->max-1;
		if (var->min > var->max) var->min = var->max;
	    }
	    if (vars != NULL) { 
		// left >= right
		var = &vars[left_op->index];
		if (var->min < right_op->min) { 
		    var->min = right_op->min;
		    if (var->min > var->max) var->max = var->min;
		}
	    }
	}
	stack_pointer = left_op;	
	break;
      case if_acmpeq:
	if (vars != NULL) { 
	    if (right_op->index >= 0) { 
		vars[right_op->index].mask &= left_op->mask;
	    } 
	    if (left_op->index >= 0) { 
		vars[left_op->index].mask &= right_op->mask;
	    } 
	}
	stack_pointer = left_op;
	break;
      case if_acmpne:
	if (right_op->index >= 0) { 
	    method->vars[right_op->index].mask &= left_op->mask;
	} 
	if (left_op->index >= 0) { 
	    method->vars[left_op->index].mask &= right_op->mask;
	} 
	stack_pointer = left_op;
	break;
      case ifnull:
	if (right_op->index >= 0) { 
	    method->vars[right_op->index].mask |= var_desc::vs_not_null;
	    if (vars != NULL) { 
		vars[right_op->index].mask &= ~var_desc::vs_not_null;
	    }
	}
	stack_pointer = right_op;
	break;
      case ifnonnull:
	if (right_op->index >= 0) { 
	    method->vars[right_op->index].mask &= ~var_desc::vs_not_null;
	    if (vars != NULL) { 
		vars[right_op->index].mask |= var_desc::vs_not_null;
	    }
	}
	stack_pointer = right_op;
	break;
      default:
	stack_pointer = sp;
    }
    stack_top[1] = stack_pointer[-1];
    stack_top[0] = stack_pointer[-2];
    return sp;
}

 

vbm_operand* ctx_merge::transfer(method_desc* method, vbm_operand* sp, 
				 byte, byte& prev_cop)
{
    var_desc save_var;
    if (cmd == cmd_case_ctx && come_from->switch_var_index >= 0) { 
	// If branch is part of switch and switch expression is local variable,
	// then we know value of this variable if this branch takes place
	var_desc* var = &come_from->vars[come_from->switch_var_index];
	save_var = *var;
	var->max = var->min = var->mask = case_value;
    }
    var_desc* v0 = method->vars;
    var_desc* v1 = come_from->vars;
    if (prev_cop == goto_near || prev_cop == goto_w 
	|| prev_cop == ret || prev_cop == athrow 
	|| prev_cop == lookupswitch || prev_cop == tableswitch
	|| unsigned(prev_cop - ireturn) <= unsigned(vreturn-ireturn))
    {
	// Control can be passed to this point only by branch: 
	// no need to merge states
	for (int i = method->n_vars; --i >= 0; v0++, v1++) { 
	    if (v0->type == v1->type) { 
		v0->min = v1->min;
		v0->max = v1->max;
		v0->mask = v1->mask;
	    } else if (v1->type == tp_void) { 
		v0->type = tp_void;
	    }
	}
	sp = come_from->stack_pointer;
	sp[-1] = come_from->stack_top[1];
	sp[-2] = come_from->stack_top[0];
	// all successive ctx_merge::transfer should merge variables properties
	prev_cop = nop; 
    } else { 
	// merge states
	for (int i = method->n_vars; --i >= 0; v0++, v1++) { 
	    if (v0->type == v1->type) { 
		if (IS_INT_TYPE(v0->type)) { 
		    if (v0->min > v1->min) v0->min = v1->min;
		    if (v0->max < v1->max) v0->max = v1->max;
		    v0->mask |= v1->mask;
#ifdef INT8_DEFINED
		} else if (v0->type == tp_long) { 
		    int8 min0  = LOAD_INT8(v0,min); 
		    int8 max0  = LOAD_INT8(v0,max); 
		    int8 mask0 = LOAD_INT8(v0,mask); 
		    int8 min1  = LOAD_INT8(v1,min); 
		    int8 max1  = LOAD_INT8(v1,max); 
		    int8 mask1 = LOAD_INT8(v1,mask); 
		    if (min0 > min1) { 
			STORE_INT8(v0, min, min1);
		    } 
		    if (max0 < max1) { 
			STORE_INT8(v0, max, max1); 
		    }
		    mask0 |= mask1;
		    STORE_INT8(v0, mask, mask0);
		    v0 += 1; 
		    v1 += 1; 
		    i -= 1; 
		    assert(i >= 0);
#endif
		} else { 
		    if (v0->min > v1->min) v0->min = v1->min;
		    if (v0->max < v1->max) v0->max = v1->max;
		    v0->mask &= v1->mask;
		}
	    } else if (v0->type != tp_void && v1->type == tp_void) { 
		if (IS_INT_TYPE(v0->type)) { 
		    v0->min = ranges[tp_int].min;
		    v0->max = ranges[tp_int].max;
		    v0->mask = ALL_BITS;
		} else if (v0->type == tp_long) { 
		    v0[0].min  = 0x80000000;
		    v0[0].max  = 0x7fffffff;
		    v0[0].mask = 0xffffffff;
		    v0[1].min  = 0x00000000;
		    v0[1].max  = 0xffffffff;
		    v0[1].mask = 0xffffffff;
		} else { 
		    v0->min = 0;
		    v0->max = MAX_ARRAY_LENGTH;
		}
	    }
	}
	assert(sp == come_from->stack_pointer);
	if (IS_INT_TYPE(come_from->stack_top[1].type)) { 
	    if (sp[-1].min > come_from->stack_top[1].min) { 
		sp[-1].min = come_from->stack_top[1].min;
	    } 
	    if (sp[-1].max < come_from->stack_top[1].max) { 
		sp[-1].max = come_from->stack_top[1].max;
	    }
	    sp[-1].mask |= come_from->stack_top[1].mask;
#ifdef INT8_DEFINED
	} else if (come_from->stack_top[1].type == tp_long) { 
	    int8 min0  = LOAD_INT8(sp-2,min); 
	    int8 max0  = LOAD_INT8(sp-2,max); 
	    int8 mask0 = LOAD_INT8(sp-2,mask); 
	    int8 min1  = LOAD_INT8(come_from->stack_top,min); 
	    int8 max1  = LOAD_INT8(come_from->stack_top,max); 
	    int8 mask1 = LOAD_INT8(come_from->stack_top,mask); 
	    if (min0 > min1) {
		STORE_INT8(sp-2, min, min1);
	    } 
	    if (max0 < max1) { 
		STORE_INT8(sp-2, max, max1); 
	    }
	    mask0 |= mask1;
	    STORE_INT8(sp-2, mask, mask0);	    
#endif
	} else { 
	    if (sp[-1].min > come_from->stack_top[1].min) { 
		sp[-1].min = come_from->stack_top[1].min;
	    } 
	    if (sp[-1].max < come_from->stack_top[1].max) { 
		sp[-1].max = come_from->stack_top[1].max;
	    }
	    sp[-1].mask &= come_from->stack_top[1].mask;
	}
    }
    if (--come_from->n_branches == 0) { 
	delete[] come_from->vars;
    } else if (cmd == cmd_case_ctx && come_from->switch_var_index >= 0) { 
	// restore state of switch expression varaible, 
	// because it can be used in other branches
	come_from->vars[come_from->switch_var_index] = save_var;
    }
    return sp;
}

vbm_operand* ctx_entry_point::transfer(method_desc* method, vbm_operand* sp, 
				       byte, byte&)
{
#if 1
    //
    // As far as state of variable is not followed correctly in case of 
    // subroutine execution or catching exception, the obviouse approach is
    // to reset state of all local variables. But in this case we will loose
    // useful information, so I decide to keep variables state, 
    // hopping that it will not cause confusing Jlint messages.
    //
    var_desc* var = method->vars;
    for (int i = method->n_vars; --i >= 0; var++) { 
	int type = var->type;
	if (IS_INT_TYPE(type)) { 
	    var->min  = ranges[type].min;
	    var->max  = ranges[type].max;
	    var->mask = var->min | var->max;
	} else if (type == tp_long) { 
	    var->min  = 0x80000000;
	    var->max  = 0x7fffffff;
	    var->mask = 0xffffffff;
	    var += 1;
	    var->min  = 0x00000000;
	    var->max  = 0xffffffff;
	    var->mask = 0xffffffff;
	    i -= 1;
	    assert(i >= 0);
	} else { 
	    var->min  = 0;
	    var->max  = MAX_ARRAY_LENGTH;
	    var->mask = var_desc::vs_unknown;
	}
    }
#endif
    sp->type = tp_object;
    sp->mask = var_desc::vs_not_null;
    sp->min = 0;
    sp->max = MAX_ARRAY_LENGTH;
    return sp+1; // execption object is pushed on stack
}
   

vbm_operand* ctx_reset::transfer(method_desc* method, vbm_operand* sp, 
				 byte, byte&)
{
    var_desc* var = method->vars;
    for (int n = method->n_vars, i = 0; i < n; i++, var++) { 
	//
	// Reset vaules of local variables which were modified in region of
	// code between backward jump label and backward jump intruction
	//
	if (method->var_store_count[i] != var_store_count[i]) { 
	    int type = var->type;
	    if (IS_INT_TYPE(type)) { 
		var->min  = ranges[type].min;
		var->max  = ranges[type].max;
		var->mask = var->min | var->max;
	    } else if (type == tp_long) { 
		var->min  = 0x80000000;
		var->max  = 0x7fffffff;
		var->mask = 0xffffffff;
		var += 1;
		var->min  = 0x00000000;
		var->max  = 0xffffffff;
		var->mask = 0xffffffff;
		i += 1;
		assert(i < n);
	    } else { 
		var->mask = var_desc::vs_unknown;
		var->min  = 0;
		var->max  = MAX_ARRAY_LENGTH;
	    }
	}
    }
    delete[] var_store_count;
    return sp;
} 	


//
// Methods of class_desc class
//

const unsigned class_hash_table_size = 1987;
class_desc* class_desc::hash_table[class_hash_table_size];
class_desc* class_desc::chain;
int class_desc::n_classes;


class_desc::class_desc(utf_string const& str) 
: name(str), source_file(str+".java") 
{ 
    fields = NULL;
    methods = NULL;
    n_bases = 0;
    attr = cl_system;
    class_vertex = NULL;
    metaclass_vertex = NULL;
    class_vertex = new graph_vertex(this);
    metaclass_vertex = new graph_vertex(this);
    next = chain;
    chain = this;

    if (FILE_SEP != '/') { 
	// Produce valid operationg system dependent file name
	for (char* p = source_file.as_asciz(); *p != '\0'; p++) { 
	    if (*p == '/') { 
		*p = FILE_SEP;
	    } 
	}
    }
}


class_desc* class_desc::get(utf_string const& str)
{
    unsigned h = str.hash() % class_hash_table_size;
    class_desc* cls;
    for (cls = hash_table[h]; cls != NULL; cls = cls->collision_chain) { 
	if (str == cls->name) { 
	    return cls;
	}
    }
    cls = new class_desc(str);
    cls->collision_chain = hash_table[h];
    hash_table[h] = cls;
    n_classes += 1;
    return cls;
}
	

method_desc* class_desc::get_method(utf_string const& mth_name,
				    utf_string const& mth_desc) 
{ 
    for (method_desc* method = methods; method != NULL; method = method->next){
	if (method->name == mth_name && method->desc == mth_desc) { 
	    return method;
	}
    }
    return methods = new method_desc(mth_name, mth_desc, this, methods);
}

field_desc* class_desc::get_field(utf_string const& field_name)
{ 
    for (field_desc* field = fields; field != NULL; field = field->next) { 
	if (field->name == field_name) return field;
    }
    return fields = new field_desc(field_name, this, fields);
}

bool class_desc::isa(const char* cls_name)
{
    for (class_desc* cls = this; cls->n_bases != 0; cls = *cls->bases) { 
	if (cls->name == cls_name) return true;
    }
    return false;
}

bool class_desc::isa(class_desc* base_class)
{
    for (class_desc* cls = this; cls->n_bases != 0; cls = *cls->bases) { 
	if (cls == base_class) return true;
    }
    return false;
}

bool class_desc::implements(const char* interface_name)
{
    if (name == interface_name) { 
	return true;
    }
    for (int i = n_bases; --i >= 0;) { 
	if (bases[i]->implements(interface_name)) {  
	    return true;
	}
    }
    return false;    
}

bool class_desc::in_relationship_with(class_desc* cls)
{
    return isa(cls) || cls->isa(this);
}


void class_desc::check_inheritance(class_desc* derived)
{
    for (field_desc* bf = fields; bf != NULL; bf = bf->next) {
	for (field_desc* df = derived->fields; df != NULL; df = df->next) {
	    if (bf->name == df->name) { 
		message_at(msg_field_redefined, derived->source_file, 0, 
			   &bf->name, derived, this);
		break;
	    }
	}
    }
    for (method_desc* bm = methods; bm != NULL; bm = bm->next) { 
	if (bm->is_special_method() || (bm->attr & method_desc::m_static)) { 
	    continue;
	}
	bool overridden = false;
	method_desc* match = NULL;
	for (method_desc* dm=derived->methods; dm != NULL; dm=dm->next) {
	    if (bm->name == dm->name) { 
		match = dm;
		if (bm->desc == dm->desc) { 
		    overridden = true;
		    if (!(dm->attr & method_desc::m_override)) { 
			bm->overridden = 
			    new overridden_method(dm, bm->overridden);
			if ((bm->attr & method_desc::m_synchronized) &&
			    !(dm->attr & method_desc::m_synchronized))
			{
			    message_at(msg_nosync, derived->source_file, 
				       dm->first_line, bm, derived);
			}
			if (!(attr & cl_interface)) { 
			    dm->attr |= method_desc::m_override;
			}
		    }
		    break;
		}
	    } 		    
	}
	if (match != NULL && !overridden) { 
	    message_at(msg_not_overridden, derived->source_file, 
		       match->first_line, bm, derived);
	}
    }
    for (int n = 0; n < n_bases; n++) { 
	bases[n]->check_inheritance(derived);
    }
}

void class_desc::calculate_attributes()
{
    for (method_desc* method = methods; method != NULL; method = method->next){
	method->calculate_attributes();
    }
}

void class_desc::build_concurrent_closure()
{
    for (method_desc* method = methods; method != NULL; method = method->next){
	method->build_concurrent_closure();
    }
}


void class_desc::verify()
{
    for (method_desc* method = methods; method != NULL; method=method->next) {
	method->check_synchronization();
	method->check_invocations();
    }
}

void class_desc::build_class_info()
{
    for (int i = 0; i < n_bases; i++) { 
	bases[i]->check_inheritance(this);
    }
    for (method_desc* method = methods; method != NULL; method = method->next){
	method->find_access_dependencies();
    }
}

void class_desc::build_call_graph()
{
    for (method_desc* method = methods; method != NULL; method = method->next){
	method->build_call_graph();
    }
}

void class_desc::global_analysis()
{
    class_desc* cls;

    //
    // Set attributes which depends on inheritance hierarchy. 
    //
    for (cls = chain; cls != NULL; cls = cls->next) { 
	cls->calculate_attributes();
    } 

    //
    // Set m_concurrent attribute for all synchronized methods and methods
    // called from them. Detect invocation of wait() method with multiple
    // monitors locked.
    //
    for (cls = chain; cls != NULL; cls = cls->next) { 
	cls->build_concurrent_closure();
    } 
    
    for (cls = chain; cls != NULL; cls = cls->next) { 
	cls->build_class_info();
    }
    
    for (cls = chain; cls != NULL; cls = cls->next) { 
	cls->build_call_graph();
    }
    
    //
    // Check non-synchrnized access to variables by concurrent methods
    // (race condition) and detect unchecked accessed to formal parameters
    // of method which can be passed "null" value in some invocation of 
    // this method
    //
    for (cls = chain; cls != NULL; cls = cls->next) { 
	cls->verify();
    }
    
    //
    // Explore class dependency grpah to detect possible sources of 
    // deadlocks
    //
    graph_vertex::verify();
}


//
// Methods of method_desc class
//

int method_desc::demangle_method_name(char* buf)
{
    char* dst = buf;
    char* src = desc.as_asciz();
    assert(*src++ == '(');
    dst += sprintf(dst, "%s.%s(", cls->name.as_asciz(), name.as_asciz());
    int first_parameter = true;
    while (*src != ')') { 
	if (!first_parameter) { 
	    *dst++ = ',';
	    *dst++ = ' ';
	}
	first_parameter = false;
	int indirect = 0;
	while (*src == '[') { 
	    indirect += 1;
	    src += 1;
	}
	switch (*src++) { 
	  case 'I': 
	    dst += sprintf(dst, "int");
	    break;
	  case 'S':
	    dst += sprintf(dst, "short");
	    break;
	  case 'D': 
	    dst += sprintf(dst, "double");
	    break;
	  case 'J': 
	    dst += sprintf(dst, "long");
	    break;
	  case 'F': 
	    dst += sprintf(dst, "float");
	    break;
	  case 'B': 
	    dst += sprintf(dst, "byte");
	    break;
	  case 'C': 
	    dst += sprintf(dst, "char");
	    break;
	  case 'Z': 
	    dst += sprintf(dst, "boolean");
	    break;
	  case 'L':
	    while (*src != ';') { 
		if (*src == '/') *dst++ = '.';
		else *dst++ = *src;
		src += 1;
	    }
	    src += 1;
	}
	while (indirect != 0) { 
	    *dst++ = '[';
	    *dst++ = ']';
	    indirect -= 1;
	}
    }
    *dst++ = ')';
    *dst = 0;
    return dst - buf;
}


void method_desc::check_invocations()
{
    for (int i = 0; i < 32; i++) { 
	if (null_parameter_mask & unchecked_use_mask & (1 << i)) {
	    message_at(msg_null_param, cls->source_file, first_line, this, i);
	}
    }
}


bool method_desc::build_call_graph(method_desc* caller, callee_desc* callee, 
				   int caller_attr)
{
    callee->backtrace = caller;
    for (overridden_method* ovr = overridden; ovr != NULL; ovr = ovr->next) { 
	ovr->method->build_call_graph(caller, callee, caller_attr);
    }
    if (attr & m_synchronized) { 
	if (!(caller_attr & callee_desc::i_self)) { 
#ifdef DUMP_EDGES
	    char buf[2][MAX_MSG_LENGTH];
	    caller->demangle_method_name(buf[0]);
	    demangle_method_name(buf[1]);
	    printf("Call graph edge %s %d-> %s\n", buf[0], buf[1]);
#endif
	    graph_edge* edge = new graph_edge(vertex, caller, callee);
	    caller->vertex->attach(edge);
	}
	return true;
    } else if (!(attr & m_deadlock_free)) { 
	bool can_cause_deadlock = false;
	for (callee = callees; callee != NULL; callee = callee->next) {
	    if (callee->backtrace != caller) { 
		can_cause_deadlock |= 
		    callee->method->build_call_graph(caller, callee, 
						     caller_attr&callee->attr);
	    } 
	}
	if (!can_cause_deadlock) { 
	    attr |= m_deadlock_free;
	}
	return can_cause_deadlock;
    }
    return false;
}

void method_desc::check_synchronization()
{
    if (attr & m_concurrent) {
	for (callee_desc* callee = callees; callee != NULL; 
	     callee = callee->next)
        {
	    if (!(callee->method->attr & (m_serialized|m_synchronized)) &&
		!(callee->method->cls->attr & class_desc::cl_system) &&
		!(callee->attr & (callee_desc::i_self
				  |callee_desc::i_synchronized)))
	    {
		callee->message(msg_concurrent_call, callee->method);
	    }
	}

	for (access_desc* accessor = accessors; accessor != NULL; 
	     accessor = accessor->next)
        {
	    if (!(accessor->field->attr 
		  & (field_desc::f_volatile|field_desc::f_final
		     |field_desc::f_serialized)) 
		&& !(accessor->field->cls->attr & class_desc::cl_system) 
		&& !(accessor->attr&(access_desc::a_new|access_desc::a_self)))
	    {
		accessor->message(msg_concurrent_access, 
				  &accessor->field->name,accessor->field->cls);
	    }
	}
    }
}

void method_desc::find_access_dependencies()
{
    for (callee_desc* callee = callees; callee != NULL; callee = callee->next){
	class_desc* caller_class = callee->method->accessor;
	if (caller_class == NULL) { 
	    callee->method->accessor = cls;
	} else if (!cls->in_relationship_with(caller_class)) { 
	    // Method is called from two unrelated classes, so if this
	    // two methods are exeuted concurretly we will have access conflict
	    callee->method->attr &= ~m_serialized;
	}
	if ((!(attr & m_static) && (callee->method->attr & m_static))
	    || !(attr & m_concurrent))
	{
	    //
	    // If caller is instance method and callee - static method 
	    // of the class, or caller is not included in concurrent closure
	    // (and so it can be exeuted in main thread of control), then
	    // any invocation of callee method from concurrent thread can
	    // cause concurrent execution of this method. If no method
	    // from concurrent closure invoke this method, then 
	    // "m_serialized" attribute will not checked at all, otherwise
	    // message about concurrent invocation of non-synchronized method
	    // will be reported. 
            //
	    callee->method->attr &= ~m_serialized;
	}
    }

    for (access_desc* accessor = accessors; accessor != NULL; 
	 accessor = accessor->next)
    {
	class_desc* accessor_class = accessor->field->accessor;
	if (accessor_class == NULL) { 
	    accessor->field->accessor = cls;
	} else if (!cls->in_relationship_with(accessor_class)) { 
	    accessor->field->attr &= ~field_desc::f_serialized;
	}
	if ((attr & m_static) && (accessor->field->attr & field_desc::f_static)
	    && cls->isa(accessor->field->cls))
        { 
	    accessor->attr |= access_desc::a_self;
	}
	if ((!(attr & m_static) 
	     && (accessor->field->attr & field_desc::f_static))
	    || !(attr & m_concurrent))
	{
	    accessor->field->attr &= ~field_desc::f_serialized;
	}
    }
}

void method_desc::build_call_graph()
{
    if (attr & m_synchronized) { 
	for (callee_desc* callee=callees; callee != NULL; callee=callee->next){
	    callee->method->build_call_graph(this, callee, callee->attr);
	}
    }
}

int method_desc::print_call_path_to(callee_desc* target, 
				    int loop_id, int path_id, int caller_attr, 
				    callee_desc* prev)
{
    if (attr & (m_deadlock_free|m_visited)) { 
	return path_id;
    }
    attr |= m_visited;
    if (prev != NULL) { 
	for (overridden_method* ovr = overridden; 
	     ovr != NULL && path_id < max_shown_paths; 
	     ovr = ovr->next) 
	{ 
	    path_id = ovr->method->print_call_path_to(target, loop_id, path_id,
						      caller_attr, prev);
	}
    }
    for (callee_desc* callee = callees; 
	 callee != NULL && path_id < max_shown_paths; 
	 callee = callee->next)
    {
	int callee_attr = callee->attr & caller_attr;
	if (callee->method->attr & m_synchronized) { 
	    if (callee == target && !(callee_attr & callee_desc::i_self)) { 
		print_call_sequence(prev, loop_id, ++path_id);
	    }
	} else { 
	    callee->backtrace = prev;
	    path_id = callee->method->print_call_path_to(target, loop_id, 
							 path_id, callee_attr, 
							 callee);
	}
    }
    attr &= ~m_visited;
    return path_id;
}


void method_desc::add_to_concurrent_closure(callee_desc* caller, 
					    int caller_attr, int depth)
{
    for (overridden_method* ovr=overridden; ovr != NULL; ovr=ovr->next) { 
	add_to_concurrent_closure(caller, caller_attr, depth);
    }
    if (attr & m_synchronized) { 
	if ((caller_attr & (callee_desc::i_synchronized|callee_desc::i_self)) 
	    == callee_desc::i_synchronized && (attr & m_wait)) 
        {
	    int callee_attr = callee_desc::i_self|callee_desc::i_wait_deadlock;
	    callee_desc* up = caller; 
	    while (true) { 
		callee_attr &= up->attr;
		if (!(callee_attr & callee_desc::i_self) &&
		    ((up->attr & callee_desc::i_synchronized)
		     || up->backtrace == NULL
		     || (((callee_desc*)up->backtrace)->method->attr 
			 & m_synchronized))) 
		{
		    break;
		}
		up = (callee_desc*)up->backtrace;
	    }
	    // Check if this pass was already found
	    if (!(callee_attr & callee_desc::i_wait_deadlock)) { 
		message_at(msg_wait, cls->source_file, wait_line, this);   
		callee_desc* bt = caller; 
		while (true) {
		    bt->message(msg_wait_path, bt->method);
		    bt->attr |= callee_desc::i_wait_deadlock;
		    if (bt == up) break;
		    bt = (callee_desc*)bt->backtrace;
		}
	    }
	}
	attr |= m_concurrent;
	if ((caller_attr & (callee_desc::i_synchronized|callee_desc::i_self))
	    == callee_desc::i_synchronized && !(attr & m_visited)) 
        { 
	    attr |= m_visited;
	    for (callee_desc* callee = callees; 
		 callee != NULL; 
		 callee = callee->next)
	    {
		if (callee->attr & callee_desc::i_self) {
		    callee->backtrace = caller;
		    callee->method->add_to_concurrent_closure
			(callee, callee_desc::i_synchronized, 0);
		}
	    }
	    attr &= ~m_visited;
	}
    } 
    else if (!(attr & m_visited) 
	     && !((depth != 0 || (caller_attr & callee_desc::i_self)) 
		  && (attr & m_concurrent))) 
    { 
	if (attr & m_concurrent) { 
	    depth += 1;
	}
	attr |= m_visited|m_concurrent;
	for (callee_desc* callee=callees; callee != NULL; callee=callee->next){
	    int callee_attr = caller_attr; 
	    if (callee->attr & callee_desc::i_synchronized) { 
		callee_attr = callee_desc::i_synchronized;
	    } else { 
		callee_attr &= callee->attr|~callee_desc::i_self;
	    }
	    callee->backtrace = caller;
	    callee->method->add_to_concurrent_closure(callee, callee_attr, 
						      depth);
	}
	attr &= ~m_visited;
    }
}


void method_desc::build_concurrent_closure()
{
    //
    // Check if "run" method of class implemented Runnable interface
    // is sycnhronized and mark this method as concurrent.
    //
    int caller_attr = 0;
    attr |= m_visited;
    if (attr & m_synchronized) { 
	caller_attr = callee_desc::i_synchronized;
    } 
    else if (name == "run" && (cls->implements("java/lang/Runnable")
			       || cls->isa("java/lang/Thread")))
    {
	if (cls->implements("java/lang/Runnable")) {
	    message_at(msg_run_nosync, cls->source_file, first_line, this);
	}
    } else { 
	for (callee_desc* callee=callees; callee != NULL; callee=callee->next){
	    if (callee->attr & callee_desc::i_synchronized) { 
		callee->backtrace = NULL;
		callee->method->
		    add_to_concurrent_closure(callee, 
					      callee_desc::i_synchronized, 0);
	    }
	}
	attr &= ~m_visited;
	return;
    } 
    for (callee_desc* callee=callees; callee != NULL; callee=callee->next) {
	int callee_attr = callee->attr;
	if (callee_attr & callee_desc::i_synchronized) { 
	    // Synchronized construction was used. Clear "i_self" bit,
	    // because two monitors are already locked
	    callee_attr &= ~callee_desc::i_self; 
	}
	callee->backtrace = NULL;
	callee->method->add_to_concurrent_closure(callee, 
						  callee_attr|caller_attr, 0);
    }
    attr &= ~m_visited;
}

    
void method_desc::calculate_attributes()
{
    vertex = (attr & m_static) ? cls->metaclass_vertex : cls->class_vertex; 
    //
    // Find out all "self" static invocations
    //
    for (callee_desc* callee = callees; callee != NULL; callee=callee->next) {
	if ((attr & callee->method->attr & m_static)
	    && cls->isa(callee->method->cls)) 
	{ 
	    callee->attr |= callee_desc::i_self;
	}
    }
}

int method_desc::get_line_number(int pc)
{
    while (line_table[pc] == 0 && pc > 0) { 
	pc -= 1;
    }
    return line_table[pc];
}

void method_desc::message(int code, int pc, ...)
{
    va_list ap;
    va_start(ap, pc);
#ifdef PRINT_PC
    printf("In %s.%s pc=%d\n", cls->name.as_asciz(), name.as_asciz(), pc);
#endif
    format_message(code, cls->source_file, get_line_number(pc), ap);
    va_end(ap);
}

static int const array_type[] = { 
    0,
    0,
    0,
    0,
    tp_bool,
    tp_char,
    tp_float,
    tp_double,
    tp_byte,
    tp_short,
    tp_int,
    tp_long
};

static int const vbm_instruction_length[] = {
#define JAVA_INSN(code, mnem, len) len,
#include "jlint.d"
0
};

static char const* const vbm_instruction_mnemonic[] = {
#define JAVA_INSN(code, mnem, len) #mnem,
#include "jlint.d"
NULL
};

inline int4 make_mask(int shift) { 
    return shift < 0 ? ALL_BITS : shift >= 32 ? 0 : ALL_BITS << shift;
}

inline int4 make_mask(int high_bit, int low_bit) 
{
    int4 mask = (high_bit >= 31) ? ALL_BITS : ((1 << (high_bit+1)) - 1);
    if (low_bit < 32) mask &= ~((1 << low_bit) - 1);
    return mask;
}

inline int4 make_lshift_mask(int4 mask, int min_shift, int max_shift) {  
    if (unsigned(max_shift - min_shift) >= 32) { 
	return ALL_BITS;
    }
    int4 result = 0;
    while (min_shift <= max_shift) {
	result |= mask << (min_shift & 31);
	min_shift += 1;
    }
    return result;
}

inline int4 make_rshift_mask(int4 mask, int min_shift, int max_shift) {  
    if (unsigned(max_shift - min_shift) >= 32) { 
	return ALL_BITS;
    }
    int4 result = 0;
    while (min_shift <= max_shift) {
	result |= mask >> (min_shift & 31);
	min_shift += 1;
    }
    return result;
}

inline int4 make_rushift_mask(nat4 mask, int min_shift, int max_shift) {  
    if (unsigned(max_shift - min_shift) >= 32) { 
	return ALL_BITS;
    }
    int4 result = 0;
    while (min_shift <= max_shift) {
	result |= mask >> (min_shift & 31);
	min_shift += 1;
    }
    return result;
}

inline bool calculate_multiply_range(vbm_operand& z, 
				     vbm_operand& x, vbm_operand& y)
{
    // z = x*y
    if (x.max < 0 && y.max < 0) { 
	z.min = x.max*y.max;
	z.max = x.min*y.min;
	return (z.max > 0 && z.max/x.min == y.min);// no overflow
    } else if (x.max < 0 && y.min < 0 && y.max >= 0) { 
	z.min = x.min*y.max;
	z.max = x.min*y.min;
	return (z.max > 0 && z.min/x.min == y.max && z.max/x.min == y.min);
    } else if (x.max < 0 && y.min >= 0) { 
	z.min = x.min*y.max;
	z.max = x.max*y.min;
	return (z.min/x.min == y.max && z.max/x.max == y.min); // no overflow
    } else if (x.min < 0 && x.max >= 0 && y.max < 0) { 
	z.min = x.max*y.min;
	z.max = x.min*y.min;
	return (z.max > 0 && z.min/y.min == x.max && z.max/y.min == x.min); 
    } else if (x.min < 0 && x.max >= 0 && y.min < 0 && y.max >= 0) { 
	int4 m1, m2;
	m1 = x.min*y.max; 
	m2 = x.max*y.min;
	if (m1/x.min != y.max || m2/y.min != x.max) return false;
	z.min = minimum(m1, m2);
	m1 = x.max*y.max; 
	m2 = x.min*y.min;
	if (m2 <= 0 || (x.max != 0 && m1/x.max != y.max) || m2/y.min != x.min) 
	    return false;
	z.max = maximum(m1, m2);
	return true;
    } else if (x.min < 0 && x.max >= 0 && y.min >= 0) { 
	z.min = x.min*y.max;
	z.max = x.max*y.max;
	return z.min/x.min == y.max && (x.max == 0 || z.max/x.max == y.max);
    } else if (x.min >= 0 && y.max < 0) { 
	z.min = x.max*y.min;
	z.max = x.min*y.max;
	return z.min/y.min == x.max && z.max/y.max == x.min;
    } else if (x.min >= 0 && y.min < 0 && y.max >= 0) {
	z.min = x.max*y.min;
	z.max = x.max*y.max;
	return z.min/y.min == x.max && (x.max == 0 || z.max/x.max == y.max);
    } else { 
	assert(x.min >= 0 && y.min >= 0);
	z.min = x.min*y.min;
	z.max = x.max*y.max;
	return x.max == 0 || z.max/x.max == y.max;
    }
}


#ifdef INT8_DEFINED
inline int first_set_bit(int8 val)
{
    if (val == 0) { 
	return 64;
    } 
    int n = 0;
    while (!(val & 1)) { 
	n += 1;
	val >>= 1;
    }
    return n;
}

inline int8 make_int8_mask(int shift) { 
    return shift < 0 ? INT8_ALL_BITS : shift >= 64 
	                               ? INT8_ZERO : INT8_ALL_BITS << shift;
}

inline int8 make_int8_lshift_mask(int8 mask, int min_shift, int max_shift) {  
    if (unsigned(max_shift - min_shift) >= 64) { 
	return INT8_ALL_BITS;
    }
    int8 result = 0;
    while (min_shift <= max_shift) {
	result |= mask << (min_shift & 63);
	min_shift += 1;
    }
    return result;
}

inline int8 make_int8_rshift_mask(int8 mask, int min_shift, int max_shift) {  
    if (unsigned(max_shift - min_shift) >= 64) { 
	return INT8_ALL_BITS;
    }
    int8 result = 0;
    while (min_shift <= max_shift) {
	result |= mask >> (min_shift & 63);
	min_shift += 1;
    }
    return result;
}

inline int8 make_int8_rushift_mask(nat8 mask, int min_shift, int max_shift) {  
    if (unsigned(max_shift - min_shift) >= 64) { 
	return INT8_ALL_BITS;
    }
    int8 result = 0;
    while (min_shift <= max_shift) {
	result |= mask >> (min_shift & 63);
	min_shift += 1;
    }
    return result;
}

inline bool calculate_int8_multiply_range(vbm_operand* x, vbm_operand* y)
{
    // x *= y
    int8 x_min = LOAD_INT8(x, min);
    int8 x_max = LOAD_INT8(x, max);
    int8 y_min = LOAD_INT8(y, min);
    int8 y_max = LOAD_INT8(y, max);
    int8 z_min, z_max;
    if (x_max < 0 && y_max < 0) { 
        z_min = x_max*y_max;
	z_max = x_min*y_min;
	STORE_INT8(x, min, z_min);
	STORE_INT8(x, max, z_max);
	return (z_min > 0 && z_max/x_min == y_min); // no overflow
    } else if (x_max < 0 && y_min < 0 && y_max >= 0) { 
	z_min = x_min*y_max;
	z_max = x_min*y_min;
	STORE_INT8(x, min, z_min);
	STORE_INT8(x, max, z_max);
	return (z_max > 0 && z_min/x_min == y_max && z_max/x_min == y_min);
    } else if (x_max < 0 && y_min >= 0) { 
	z_min = x_min*y_max;
	z_max = x_max*y_min;
	STORE_INT8(x, min, z_min);
	STORE_INT8(x, max, z_max);
	return (z_min/x_min == y_max && z_max/x_max == y_min); // no overflow
    } else if (x_min < 0 && x_max >= 0 && y_max < 0) { 
	z_min = x_max*y_min;
	z_max = x_min*y_min;
	STORE_INT8(x, min, z_min);
	STORE_INT8(x, max, z_max);
	return (z_max > 0 && z_min/y_min == x_max && z_max/y_min == x_min); 
    } else if (x_min < 0 && x_max >= 0 && y_min < 0 && y_max >= 0) { 
	int8 m1, m2;
	m1 = x_min*y_max; 
	m2 = x_max*y_min;
	if (m1/x_min != y_max || m2/y_min != x_max) return false;
	z_min = m1 < m2 ? m1 : m2;
	m1 = x_max*y_max; 
	m2 = x_min*y_min;
	if (m2 <= 0 || (x_max != 0 && m1/x_max != y_max) || m2/y_min != x_min) 
	    return false;
	z_max = m1 > m2 ? m1 : m2;
	STORE_INT8(x, min, z_min);
	STORE_INT8(x, max, z_max);
	return true;
    } else if (x_min < 0 && x_max >= 0 && y_min >= 0) { 
	z_min = x_min*y_max;
	z_max = x_max*y_max;
	STORE_INT8(x, min, z_min);
	STORE_INT8(x, max, z_max);
	return z_min/x_min == y_max && (x_max == 0 || z_max/x_max == y_max);
    } else if (x_min >= 0 && y_max < 0) { 
	z_min = x_max*y_min;
	z_max = x_min*y_max;
	STORE_INT8(x, min, z_min);
	STORE_INT8(x, max, z_max);
	return z_min/y_min == x_max && z_max/y_max == x_min;
    } else if (x_min >= 0 && y_min < 0 && y_max >= 0) {
	z_min = x_max*y_min;
	z_max = x_max*y_max;
	STORE_INT8(x, min, z_min);
	STORE_INT8(x, max, z_max);
	return z_min/y_min == x_max && (x_max == 0 || z_max/x_max == y_max);
    } else { 
	assert(x_min >= 0 && y_min >= 0);
	z_min = x_min*y_min;
	z_max = x_max*y_max;
	STORE_INT8(x, min, z_min);
	STORE_INT8(x, max, z_max);
	return x_max == 0 || z_max/x_max == y_max;
    }
}
#endif

void method_desc::check_variable_for_null(int pc, vbm_operand* sp)
{
    if (!(sp->mask & var_desc::vs_not_null)) { 
	if (sp->index >= 0) { 
	    message(msg_null_var, pc, &vars[sp->index].name);
	} else { 
	    message(msg_null_ptr, pc);
	} 
    } 
    else if ((unsigned)sp->index < 32 
	     && (sp->mask & var_desc::vs_not_null) != var_desc::vs_not_null)
    {
	// formal parameter was not assigned value 
	// and was not checked for NULL
	if (null_parameter_mask & (1 << sp->index)) { 
	    message(msg_null_param, pc, this, sp->index);
	} else { 
	    unchecked_use_mask |= 1 << sp->index;
	}
    } 
}

void method_desc::check_array_index(int pc, vbm_operand* sp)
{
    check_variable_for_null(pc, sp);
    if (sp[1].min < 0) { 
	if (sp[1].max < 0) { 
	    message(msg_bad_index, pc, sp[1].min, sp[1].max);
	} else if (sp[1].min > -128) { 
	    message(msg_maybe_bad_index, pc, sp[1].min, sp[1].max);
	} 
    }
    if (sp[1].max >= sp->max && sp->max != MAX_ARRAY_LENGTH) {  
	if (sp[1].min >= sp->max) { 
	    message(msg_bad_index, pc, sp[1].min, sp[1].max);
	} else if (sp[1].max - sp->max < 127) { 
	    message(msg_maybe_bad_index, pc, sp[1].min, sp[1].max);
	}
    }
}

void method_desc::basic_blocks_analysis()
{
    byte* pc = code;
    byte* end = pc + code_length;
    int   i;
    var_store_count = new int[n_vars];

    for (i = n_vars; --i >= 0;) { 
	vars[i].type = tp_void;
	vars[i].name = utf_string("???");
	vars[i].min  = 0;
	vars[i].max  = MAX_ARRAY_LENGTH;
	var_store_count[i] = 0;
    }

    while (pc != end) { 
	int addr = pc - code;
	int offs;
	switch (*pc) { 
	  case jsr:
	  case ifeq:
	  case ifne:
	  case iflt:
	  case ifge:
	  case ifgt:
	  case ifle:
	  case if_icmpeq:
	  case if_icmpne:
	  case if_icmplt:
	  case if_icmpge:
	  case if_icmpgt:
	  case if_icmple:
	  case if_acmpeq:
	  case if_acmpne:
	  case ifnull:
	  case ifnonnull:
	  case goto_near:
	    offs = (short)unpack2(pc+1);
	    if (offs < 0) { // backward jump 
		new ctx_reset(&context[addr+offs], var_store_count, n_vars);
		new ctx_split(&context[addr], ctx_split::jmp_backward);
	    } else if (offs > 0) { // forward jump
		new ctx_merge(&context[addr+offs],
		    new ctx_split(&context[addr], ctx_split::jmp_forward));
	    }
	    pc += 3;
	    break;
	  case jsr_w:
	  case goto_w:
	    offs = unpack4(pc+1);
	    if (offs < 0) {  // backward jump 
		new ctx_reset(&context[addr+offs], var_store_count, n_vars);
	    } else if (offs > 0) { // forward jump
		new ctx_merge(&context[addr+offs],
		    new ctx_split(&context[addr], ctx_split::jmp_forward));
	    }
	    pc += 5;
	    break;
	  case tableswitch:
	    {
	      pc += 4 - (addr & 3);
	      offs = unpack4(pc); // default label
	      int low = unpack4(pc+4);
	      int high = unpack4(pc+8);
	      int n_forward_jumps = 0;
	      pc += 12;
	      ctx_split* select = new ctx_split(&context[addr]);
	      if (offs < 0) { 
		  new ctx_reset(&context[addr+offs], var_store_count, n_vars);
	      } else if (offs > 0) { 
		  new ctx_merge(&context[addr+offs], select);
		  n_forward_jumps += 1;
	      }
	      while (low <= high) { 
		  offs = unpack4(pc);
		  if (offs < 0) { 
		      new ctx_reset(&context[addr+offs], 
				    var_store_count, n_vars);
		  } else if (offs > 0) { 
		      new ctx_merge(&context[addr+offs], select, low);
		      n_forward_jumps += 1;
		  }
		  pc += 4;
		  low += 1;
	      }
	      select->n_branches = n_forward_jumps;
	    }
	    break;
	  case lookupswitch:
	    {
	      pc += 4 - (addr & 3);
	      offs = unpack4(pc); // default label
	      int n_pairs = unpack4(pc+4);
	      int n_forward_jumps = 0;
	      pc += 8;
	      ctx_split* select = new ctx_split(&context[addr]);
	      if (offs < 0) { 
		  new ctx_reset(&context[addr+offs], var_store_count, n_vars);
	      } else if (offs > 0) { 
		  new ctx_merge(&context[addr+offs], select);
		  n_forward_jumps += 1;
	      }
	      while (--n_pairs >= 0) {
		  offs = unpack4(pc+4);
		  if (offs < 0) { 
		      new ctx_reset(&context[addr+offs], 
				    var_store_count, n_vars);
		  } else if (offs > 0) { 
		      new ctx_merge(&context[addr+offs], select, unpack4(pc));
		      n_forward_jumps += 1;
		  }
		  pc += 8;
	      }
	      select->n_branches = n_forward_jumps;
	    }
	    break;
	  case istore:
	  case lstore:
	  case astore:
	    pc += 1;
	    var_store_count[*pc++] += 1;
	    break;
	  case istore_0:
	  case istore_1:
	  case istore_2:
	  case istore_3:
	    var_store_count[*pc++ - istore_0] += 1;
	    break;	    
	  case lstore_0:
	  case lstore_1:
	  case lstore_2:
	  case lstore_3:
	    var_store_count[*pc++ - lstore_0] += 1;
	    break;	    
	  case astore_0:
	  case astore_1:
	  case astore_2:
	  case astore_3:
	    var_store_count[*pc++ - astore_0] += 1;
	    break;	    
	  case iinc:
	    var_store_count[pc[1]] += 1;
	    pc += 3;
	    break;
	  case wide:
	    pc += 1;
	    switch (*pc++) { 
	      case istore:
	      case lstore:
	      case astore:
		var_store_count[unpack2(pc)] += 1;
		break;	    
	      case iinc:
		var_store_count[unpack2(pc)] += 1;
		pc += 2;
	    }
	    pc += 2;
	    break;
	  default:
	    pc += vbm_instruction_length[*pc];
	}
    }
    for (i = n_vars; --i >= 0;) { 
	var_store_count[i] = 0;
    }
}

#define NO_ASSOC_VAR -1

void method_desc::parse_code(constant** constant_pool)
{
    const int indirect = 0x100;
    byte* pc = code;
    byte* end = pc + code_length;
    const int max_stack_size = 256;
    vbm_operand stack[max_stack_size+2];
    vbm_operand* stack_bottom = stack+2; // avoid checks for non-empty stack
    vbm_operand* sp = stack_bottom;
    int in_monitor = false;
    local_context* ctx;
    byte prev_cop = nop;
    bool super_finalize = false;
    int i;
#ifdef INT8_DEFINED
    int8 left_min;
    int8 left_max;
    int8 left_mask;
    int8 right_min;
    int8 right_max;
    int8 right_mask;
#define LOAD_INT8_OPERANDS() \
    left_min = LOAD_INT8(sp-4, min);\
    left_max = LOAD_INT8(sp-4, max);\
    left_mask = LOAD_INT8(sp-4, mask);\
    right_min = LOAD_INT8(sp-2, min);\
    right_max = LOAD_INT8(sp-2, max);\
    right_mask = LOAD_INT8(sp-2, mask)
#define LOAD_INT8_OPERAND() \
    left_min = LOAD_INT8(sp-2, min);\
    left_max = LOAD_INT8(sp-2, max);\
    left_mask = LOAD_INT8(sp-2, mask)    
#endif

    stack[0].type =  stack[1].type = tp_void;
    basic_blocks_analysis();

    for (i = 0; i < 32; i++) { 
	if (null_parameter_mask & (1 << i)) { 
	    assert(i < n_vars);
	    vars[i].mask = 0;
	    vars[i].min = 0;
	    vars[i].max = MAX_ARRAY_LENGTH;
	    if (vars[i].type == tp_void) { 
		vars[i].type = tp_object;
	    }
	}
    }
    if (!(attr & m_static)) { 
	vars[0].type = tp_self;
	vars[0].mask = var_desc::vs_not_null;
	vars[0].min = 0;
	vars[0].max = MAX_ARRAY_LENGTH;
    }

    while (pc < end) { 
	int addr = pc - code;
	byte cop = *pc++; 
#ifdef DUMP_BYTE_CODES
	printf("%s: min=%d, max=%d, mask=0x%x\n", 
	       vbm_instruction_mnemonic[cop], 
	       sp[-1].min, sp[-1].max, sp[-1].mask);
#endif
	for (ctx = context[addr]; ctx != NULL; ctx = ctx->next) {
	    sp = ctx->transfer(this, sp, cop, prev_cop);
	}
	switch (cop) { 
	  case nop:
	    break;
	  case aconst_null:
	    sp->type = tp_object;
	    sp->mask = 0;
	    sp->min = sp->max = 0;
	    sp->index = NO_ASSOC_VAR;
	    sp += 1;
	    break;
	  case iconst_m1:
	  case iconst_0:
	  case iconst_1:
	  case iconst_2:
	  case iconst_3:
	  case iconst_4:
	  case iconst_5:
	    sp->type = tp_byte;
	    sp->mask = sp->min = sp->max = cop - iconst_0;
	    sp->index = NO_ASSOC_VAR;
	    sp += 1;
	    break;
	  case fconst_0:
	  case fconst_1:
	  case fconst_2:
	    sp->type = tp_float;
	    sp->index = NO_ASSOC_VAR;
	    sp += 1;
	    break;
	  case lconst_0:
	  case lconst_1:
	    sp[0].type = sp[1].type = tp_long; 
	    sp[0].min = sp[0].max = sp[0].mask = 0;
	    sp[1].min = sp[1].max = sp[1].mask = cop - lconst_0;
	    sp[0].index = sp[1].index = NO_ASSOC_VAR;
	    sp += 2;
	    break;
	  case dconst_0:
	  case dconst_1:
	    sp[0].type = sp[1].type = tp_double; 
	    sp[0].index = sp[1].index = NO_ASSOC_VAR;
	    sp += 2;
	    break;
	  case bipush:
	    sp->type = tp_int;
	    sp->mask = sp->min = sp->max = (signed char)*pc++;
	    sp->index = NO_ASSOC_VAR;
	    sp += 1;
	    break;
	  case sipush:
	    sp->type = tp_int;
	    sp->mask = sp->min = sp->max = (short)unpack2(pc);	
	    sp->index = NO_ASSOC_VAR;
	    pc += 2;
	    sp += 1;
	    break;
	  case ldc:
	    {
	      constant* cp = constant_pool[*pc++];
	      sp->type = cp->type();
	      if (sp->type == tp_int) {
		  sp->mask = sp->min = sp->max = ((const_int*)cp)->value;
	      } else { 
		  if (sp->type == tp_string) { 
		      sp->min = sp->max = ((const_string*)cp)->length();
		  } else { 
		      sp->min = 0;
		      sp->max = MAX_ARRAY_LENGTH;
		  }
		  sp->mask = var_desc::vs_not_null;
	      }
	      sp->index = NO_ASSOC_VAR;
	      sp += 1;
	    }
	    break;
	  case ldc_w:
	    {
	      constant* cp = constant_pool[unpack2(pc)];
	      sp->type = cp->type();
	      if (sp->type == tp_int) {
		  sp->mask = sp->min = sp->max = ((const_int*)cp)->value;
	      } else { 
		  if (sp->type == tp_string) { 
		      sp->min = sp->max = ((const_string*)cp)->length();
		  } else { 
		      sp->min = 0;
		      sp->max = MAX_ARRAY_LENGTH;
		  }
		  sp->mask = var_desc::vs_not_null;
	      }
	      sp->index = NO_ASSOC_VAR;
	      pc += 2;
	      sp += 1;
	    }
	    break;
	  case ldc2_w:
	    { 
	      const_long* cp = (const_long*)constant_pool[unpack2(pc)];
	      sp->type = tp_long; 
	      sp->index = NO_ASSOC_VAR;
	      sp->mask = sp->min = sp->max = cp->value.high;
	      sp += 1;
	      sp->type = tp_long; 
	      sp->index = NO_ASSOC_VAR;
	      sp->mask = sp->min = sp->max = cp->value.low;
	      sp += 1; 
	      pc += 2;
	    }
	    break;
	  case iload:
	    if (vars[*pc].type == tp_void) { 
		vars[*pc].type = tp_int;
		vars[*pc].min = ranges[tp_int].min;
		vars[*pc].max = ranges[tp_int].max;
		vars[*pc].mask = ALL_BITS;
	    }
	    sp->type = vars[*pc].type;
	    sp->min  = vars[*pc].min;
	    sp->max  = vars[*pc].max;
	    sp->mask = vars[*pc].mask;
	    sp->index = *pc++;
	    sp += 1;
	    break;
	  case aload:
	    if (vars[*pc].type == tp_void) { 
		vars[*pc].type = tp_object;
		vars[*pc].min = 0;
		vars[*pc].max = MAX_ARRAY_LENGTH;
		vars[*pc].mask = var_desc::vs_unknown;
	    }
	    sp->type = vars[*pc].type;
	    sp->mask = vars[*pc].mask;
	    sp->min  = vars[*pc].min;
	    sp->max  = vars[*pc].max;
	    sp->index = *pc++;
	    sp += 1;
	    break;
	  case lload:
	    { 
	      int index = *pc++; 
	      if (vars[index].type == tp_void) { 
		  vars[index].type = tp_long;
		  vars[index].min = 0x80000000;
		  vars[index].max = 0x7fffffff;
		  vars[index].mask = 0xffffffff;
		  vars[index+1].min = 0x00000000;
		  vars[index+1].max = 0xffffffff;
		  vars[index+1].mask = 0xffffffff;
	      }
	      sp->type = tp_long;
	      sp->min  = vars[index].min;
	      sp->max  = vars[index].max;
	      sp->mask = vars[index].mask;
	      sp->index = index;
	      sp += 1;
	      index += 1;
	      sp->type = tp_long;
	      sp->min  = vars[index].min;
	      sp->max  = vars[index].max;
	      sp->mask = vars[index].mask;
	      sp += 1;
	    }
	    break;
	  case dload:
	    sp[0].type = sp[1].type = tp_double; 
	    sp[0].index = sp[1].index = NO_ASSOC_VAR;
	    sp += 2; pc += 1;
	    break;
	  case fload:
	    sp->type = tp_float; 
	    sp->index = NO_ASSOC_VAR;
	    sp += 1;
	    pc += 1;
	    break;
	  case iload_0:
	  case iload_1:
	  case iload_2:
	  case iload_3:
	    { 
	      var_desc* var = &vars[cop - iload_0];
	      if (var->type == tp_void) { 
		  var->type = tp_int;
		  var->min = ranges[tp_int].min;
		  var->max = ranges[tp_int].max;
		  var->mask = ALL_BITS;
	      }
	      sp->type = var->type;
	      sp->min  = var->min;
	      sp->max  = var->max;
	      sp->mask = var->mask;
	      sp->index = cop - iload_0;
	      sp += 1;
	    }
	    break;
	  case lload_0:
	  case lload_1:
	  case lload_2:
	  case lload_3:
	    { 
		int index = cop - lload_0; 
		if (vars[index].type == tp_void) { 
		    vars[index].type = tp_long;
		    vars[index].min = 0x80000000;
		    vars[index].max = 0x7fffffff;
		    vars[index].mask = 0xffffffff;
		    vars[index+1].min = 0x00000000;
		    vars[index+1].max = 0xffffffff;
		    vars[index+1].mask = 0xffffffff;
		}
		sp->type = tp_long;
		sp->min  = vars[index].min;
		sp->max  = vars[index].max;
		sp->mask = vars[index].mask;
		sp->index = index;
		sp += 1;
		index += 1;
		sp->type = tp_long;
		sp->min  = vars[index].min;
		sp->max  = vars[index].max;
		sp->mask = vars[index].mask;
		sp += 1;
	    }
	    break;
	  case dload_0:
	  case dload_1:
	  case dload_2:
	  case dload_3:
	    sp[0].type = sp[1].type = tp_double; 
	    sp[0].index = sp[1].index = NO_ASSOC_VAR;
	    sp += 2;
	    break;
	  case fload_0:
	  case fload_1:
	  case fload_2:
	  case fload_3:
	    sp->type = tp_float;
	    sp->index = NO_ASSOC_VAR;
	    sp += 1;
	    break;
	  case aload_0:
	  case aload_1:
	  case aload_2:
	  case aload_3:
	    { 
	      var_desc* var = &vars[cop - aload_0];
	      if (var->type == tp_void) { 
		  if (cop == aload_0 && !(attr & m_static)) { 
		      var->type = tp_self;
		      var->mask = var_desc::vs_not_null;
		  } else { 
		      var->type = tp_object;
		      var->mask = var_desc::vs_unknown;
		  }
		  sp->min  = 0;
		  sp->max  = MAX_ARRAY_LENGTH;
	      }
	      sp->type = var->type;
	      sp->mask = var->mask;
	      sp->min  = var->min;
	      sp->max  = var->max;
	      sp->index = cop - aload_0;
	      sp += 1;
	    }
	    break;
	  case iaload:
	  case faload:
	  case aaload:
	  case baload:
	  case caload:
	  case saload:
	    sp -= 2; 
	    check_array_index(addr, sp);
	    if (IS_ARRAY_TYPE(sp->type)) { 
		sp->type -= indirect;
	    } else { 
		sp->type = 
		    (cop == aaload) ? tp_object : 
		    (cop == baload) ? tp_byte : 
		    (cop == caload) ? tp_char : 
		    (cop == iaload) ? tp_int  : 
		    (cop == saload) ? tp_short : tp_float;
	    }
	    if (IS_INT_TYPE(sp->type)) { 
		sp->min = ranges[sp->type].min;
		sp->max = ranges[sp->type].max;	    
		sp->mask = sp->min|sp->max;
	    } else { 
		sp->min  = 0;
		sp->max  = MAX_ARRAY_LENGTH;
		sp->mask = var_desc::vs_unknown;
	    }
	    sp->index = NO_ASSOC_VAR;
	    sp += 1;
	    break;
	  case laload:
	    check_array_index(addr, sp-2);
	    sp[-1].type = sp[-2].type = tp_long;
	    sp[-1].index = sp[-2].index = NO_ASSOC_VAR;
	    sp[-2].min  = 0x80000000;
	    sp[-2].max  = 0x7fffffff;
	    sp[-2].mask = 0xffffffff;
	    sp[-1].min  = 0x00000000;
	    sp[-1].max  = 0xffffffff;
	    sp[-1].mask = 0xffffffff;
	    break; 
	  case daload:
	    check_array_index(addr, sp-2);
	    sp[-1].type = sp[-2].type = tp_double;
	    sp[-1].index = sp[-2].index = NO_ASSOC_VAR;
	    break; 
	  case istore:
	    {
	      var_desc* var = &vars[*pc];
	      sp -= 1;
	      var->max = sp->max;
	      var->min = sp->min;
	      var->mask = sp->mask;
	      var_store_count[*pc] += 1;
	      if (var->type == tp_void) { 
		  var->type = tp_int;
	      }
	      pc += 1;
	    }
	    break;
	  case astore:
	    sp -= 1;
	    vars[*pc].mask = sp->mask;
	    vars[*pc].min = sp->min;
	    vars[*pc].max = sp->max;
	    var_store_count[*pc] += 1;
	    if (vars[*pc].type == tp_void) { 
		vars[*pc].type = tp_object;
	    }
	    pc += 1;
	    break;
	  case fstore:
	    pc += 1; sp -= 1;
	    break;
	  case lstore:
	    {
		int index = *pc++;
		sp -= 2;
		vars[index].type = tp_long;
		vars[index].max  = sp[0].max;
		vars[index].min  = sp[0].min;
		vars[index].mask = sp[0].mask;
		vars[index+1].max  = sp[1].max;
		vars[index+1].min  = sp[1].min;
		vars[index+1].mask = sp[1].mask;
		var_store_count[index] += 1;
	    }
	    break;
	  case dstore:
	    pc += 1; sp -= 2;
	    break;
	  case istore_0:
	  case istore_1:
	  case istore_2:
	  case istore_3:
	    { 
	      var_desc* var = &vars[cop - istore_0];
	      sp -= 1;
	      var->max = sp->max;
	      var->min = sp->min;
	      var->mask = sp->mask;
	      if (var->type == tp_void) { 
		  var->type = tp_int;
	      }
	      var_store_count[cop - istore_0] += 1;
	    }
	    break;
	  case astore_0:
	  case astore_1:
	  case astore_2:
	  case astore_3:
	    sp -= 1;
	    vars[cop - astore_0].mask = sp->mask;
	    vars[cop - astore_0].min = sp->min;
	    vars[cop - astore_0].max = sp->max;
	    if (vars[cop - astore_0].type == tp_void) { 
		vars[cop - astore_0].type = tp_object;
	    }
	    var_store_count[cop - astore_0] += 1;
	    break;
	  case fstore_0:
	  case fstore_1:
	  case fstore_2:
	  case fstore_3:
	    sp -= 1;
	    break;
	  case lstore_0:
	  case lstore_1:
	  case lstore_2:
	  case lstore_3:
	    {
		int index = cop - lstore_0;
		sp -= 2;
		vars[index].type = tp_long;
		vars[index].max  = sp[0].max;
		vars[index].min  = sp[0].min;
		vars[index].mask = sp[0].mask;
		vars[index+1].max  = sp[1].max;
		vars[index+1].min  = sp[1].min;
		vars[index+1].mask = sp[1].mask;
		var_store_count[index] += 1;
	    }
	    break;
	  case dstore_0:
	  case dstore_1:
	  case dstore_2:
	  case dstore_3:
	    sp -= 2;
	    break;
	  case iastore:
	  case fastore:
	  case aastore:
	  case bastore:
	  case castore:
	  case sastore:
	    sp -= 3;
	    check_array_index(addr, sp);
	    break;
	  case lastore:
	  case dastore:
	    sp -= 4;
	    check_array_index(addr, sp);
	    break;
	  case pop:
	    sp -= 1;
	    break;
	  case pop2:
	    sp -= 2;
	    break;
	  case dup_x0:
	    *sp = *(sp-1); sp += 1;
	    break;
	  case dup_x1:
	    sp[0]=sp[-1]; sp[-1]=sp[-2]; sp[-2]=sp[0]; sp++;
	    break;
	  case dup_x2:
	    sp[0]=sp[-1]; sp[-1]=sp[-2]; sp[-2]=sp[-3]; sp[-3]=sp[0]; sp++;
	    break;
	  case dup2_x0:
	    sp[0]=sp[-2]; sp[1] = sp[-1]; sp += 2;
	    break;
	  case dup2_x1:
	    sp[1]=sp[-1]; sp[0]=sp[-2]; sp[-1]=sp[-3]; sp[-2]=sp[1]; 
	    sp[-3]=sp[0]; sp += 2;
	    break;
	  case dup2_x2:
	    sp[1]=sp[-1]; sp[0]=sp[-2]; sp[-1]=sp[-3]; sp[-2] = sp[-4]; 
	    sp[-3]=sp[1]; sp[-4] = sp[0]; sp += 2;
	    break;
	  case swap:
	    { 
	      vbm_operand tmp = sp[-1]; 
	      sp[-1] = sp[-2]; 
	      sp[-2] = tmp;
	    }
	    break;
	  case iadd:
	    if ((sp[-1].min == 0 && sp[-1].max == 0) ||
		(sp[-2].min == 0 && sp[-2].max == 0))
	    {
		message(msg_zero_operand, addr, "+");
	    }
	    if (((sp[-1].max ^ sp[-2].max) < 0 
		 || ((sp[-1].max + sp[-2].max) ^ sp[-1].max) >= 0)
		&& ((sp[-1].min ^ sp[-2].min) < 0 
		    || ((sp[-1].min + sp[-2].min) ^ sp[-1].min) >= 0))
	    {
		sp[-2].max += sp[-1].max;
		sp[-2].min += sp[-1].min;
	    } else { 
		sp[-2].max = ranges[tp_int].max;
		sp[-2].min = ranges[tp_int].min;
	    }
	    sp[-2].mask = make_mask(minimum(first_set_bit(sp[-2].mask), 
					    first_set_bit(sp[-1].mask)));
	    sp[-2].type = tp_int;
	    sp[-2].index = NO_ASSOC_VAR;
	    sp -= 1;
	    break;
	  case isub:
	    if ((sp[-1].min == 0 && sp[-1].max == 0) ||
		(sp[-2].min == 0 && sp[-2].max == 0))
	    {
		message(msg_zero_operand, addr, "-");
	    }
	    if (((sp[-2].max ^ sp[-1].min) >= 0 
		 || ((sp[-2].max - sp[-1].min) ^ sp[-2].max) >= 0)
		&& ((sp[-2].min ^ sp[-1].max) >= 0 
		    || ((sp[-2].min - sp[-1].max) ^ sp[-2].min) >= 0))
	    {
		sp[-2].max -= sp[-1].min;
		sp[-2].min -= sp[-1].max;
	    } else { 
		sp[-2].max = ranges[tp_int].max;
		sp[-2].min = ranges[tp_int].min;
	    }
	    sp[-2].mask = make_mask(minimum(first_set_bit(sp[-2].mask), 
					    first_set_bit(sp[-1].mask)));
	    sp[-2].type = tp_int;
	    sp[-2].index = NO_ASSOC_VAR;
	    sp -= 1;
	    break;
	  case imul:
	    if ((sp[-1].min == 0 && sp[-1].max == 0) ||
		(sp[-2].min == 0 && sp[-2].max == 0))
	    {
		message(msg_zero_operand, addr, "*");
	    }
	    sp[-2].mask = make_mask(first_set_bit(sp[-2].mask) +  
				    first_set_bit(sp[-1].mask));
	    if (sp[-2].mask == 0) { 
		message(msg_zero_result, addr, "*");
		sp[-2].max = sp[-2].min = 0;
	    } else { 
		vbm_operand result;
		if (calculate_multiply_range(result, sp[-2], sp[-1])) { 
		    assert(result.min <= result.max);
		    sp[-2].max = result.max;
		    sp[-2].min = result.min;
		} else { // overflow
		    sp[-2].max = ranges[tp_int].max;
		    sp[-2].min = ranges[tp_int].min;
		}
	    }
	    sp[-2].type = tp_int;
	    sp[-2].index = NO_ASSOC_VAR;
	    sp -= 1;
	    break;
	  case idiv:
	    if ((sp[-1].min == 0 && sp[-1].max == 0) ||
		(sp[-2].min == 0 && sp[-2].max == 0))
	    {
		message(msg_zero_operand, addr, "/");
	    }
	    if ((sp[-1].min > 0 
		 && (sp[-2].max < sp[-1].min && sp[-2].min > -sp[-1].min))
		|| (sp[-1].max < 0
		    && (-sp[-2].max > sp[-1].max && sp[-2].min > sp[-1].max)))
	    {
		message(msg_zero_result, addr, "/");
		sp[-2].min = sp[-2].max = 0;
	    } else if (sp[-1].min > 0) { 
		if (sp[-2].max < 0) { 
		    sp[-2].min = sp[-2].min/sp[-1].min;
		    sp[-2].max = sp[-2].max/sp[-1].max;
		} else if (sp[-2].min < 0) { 
		    sp[-2].min = sp[-2].min/sp[-1].min;
		    sp[-2].max = sp[-2].max/sp[-1].min;
		} else { 
		    sp[-2].min = sp[-2].min/sp[-1].max;
		    sp[-2].max = sp[-2].max/sp[-1].min;
		}
	    } else { 
		sp[-2].min = ranges[tp_int].min;
		sp[-2].max = ranges[tp_int].max;
	    } 
	    sp[-2].mask = make_mask(first_set_bit(sp[-2].mask) -  
				    first_set_bit(sp[-1].mask));
	    sp[-2].type = tp_int;
	    sp[-2].index = NO_ASSOC_VAR;
	    sp -= 1;
	    break;
	  case irem:
	    if ((sp[-1].min == 0 && sp[-1].max == 0) ||
		(sp[-2].min == 0 && sp[-2].max == 0))
	    {
		message(msg_zero_operand, addr, "%");
	    }
	    if ((sp[-1].min > 0 
		 && (sp[-2].max < sp[-1].min && sp[-2].min > -sp[-1].min))
		|| (sp[-1].max < 0
		    && (-sp[-2].max > sp[-1].max && sp[-2].min > sp[-1].max)))
	    {
		message(msg_no_effect, addr);
	    } else if (sp[-1].min > 0) {    
		sp[-2].min = (sp[-2].min < 0) ? 1-sp[-1].max : 0;
		sp[-2].max = sp[-1].max-1;
	    } else { 
		sp[-2].min = ranges[tp_int].min;
		sp[-2].max = ranges[tp_int].max;
	    }
	    sp[-2].mask = ALL_BITS;
	    sp[-2].type = tp_int;
	    sp[-2].index = NO_ASSOC_VAR;
	    sp -= 1;
	    break;
	  case ishl:
	    if ((sp[-1].min == 0 && sp[-1].max == 0) ||
		(sp[-2].min == 0 && sp[-2].max == 0))
	    {
		message(msg_zero_operand, addr, "<<");
	    }
	    if (sp[-1].max < 0) {
		message(msg_shift_count, addr, "<<", "<=", (void*)sp[-1].max);
	    } else if(sp[-1].min >= 32) { 
		message(msg_shift_count, addr, "<<", ">=", (void*)sp[-1].min);
	    } 
	    else if ((unsigned(sp[-1].max - sp[-1].min) < 256) 
		     && (sp[-1].max >= 32 || sp[-1].min < 0))
	    { 
		//
		// Produce this message only if range of expression was 
		// restricted in comparence with domains of builtin types
		//
		message(msg_shift_range, addr, "<<",
			(void*)sp[-1].min, (void*)sp[-1].max);
	    }
	    sp[-2].mask = make_lshift_mask(sp[-2].mask, 
					   sp[-1].min, sp[-1].max);
	    if (sp[-2].mask == 0) { 
		message(msg_zero_result, addr, "<<");
	    }
	    if ((unsigned)sp[-1].max < 32 && (unsigned)sp[-1].min < 32) {  
		if (sp[-2].max >= 0) { 
		    if (sp[-2].max << sp[-1].max >> sp[-1].max == sp[-2].max){
			sp[-2].max = sp[-2].max << sp[-1].max;
		    } else { 
			sp[-2].max = ranges[tp_int].max;
			sp[-2].min = ranges[tp_int].min;
		    }
		} else { 
		    if (sp[-2].max << sp[-1].min >> sp[-1].min == sp[-2].max){
			sp[-2].max = sp[-2].max << sp[-1].min;
		    } else { 
			sp[-2].max = ranges[tp_int].max;
			sp[-2].min = ranges[tp_int].min;
		    }
		}
		if (sp[-2].min >= 0) { 
		    sp[-2].min <<= sp[-1].min;
		} else { 
		    if (sp[-2].min << sp[-1].max >> sp[-1].max == sp[-2].min){
			sp[-2].min = sp[-2].min << sp[-1].max;
		    } else { 
			sp[-2].max = ranges[tp_int].max;
			sp[-2].min = ranges[tp_int].min;
		    }
		}
	    } else {
		sp[-2].max = ranges[tp_int].max;
		sp[-2].min = ranges[tp_int].min;
	    }
	    sp[-2].type = tp_int;
	    sp[-2].index = NO_ASSOC_VAR;
	    sp -= 1;
	    break;
	  case ishr:
	    if ((sp[-1].min == 0 && sp[-1].max == 0) ||
		(sp[-2].min == 0 && sp[-2].max == 0))
	    {
		message(msg_zero_operand, addr, ">>");
	    }
	    if (sp[-1].max < 0) {
		message(msg_shift_count, addr, ">>", "<=", (void*)sp[-1].max);
	    } else if(sp[-1].min >= 32) { 
		message(msg_shift_count, addr, ">>", ">=", (void*)sp[-1].min);
	    } 
	    else if ((unsigned(sp[-1].max - sp[-1].min) < 256) 
		     && (sp[-1].max >= 32 || sp[-1].min < 0))
	    { 
		//
		// Produce this message only if range of expression was 
		// restricted in comparence with domains of builtin types
		//
		message(msg_shift_range, addr, ">>",
			(void*)sp[-1].min, (void*)sp[-1].max);
	    }
	    sp[-2].mask = make_rshift_mask(sp[-2].mask, 
					   sp[-1].min, sp[-1].max);
	    if (sp[-2].mask == 0) { 
		message(msg_zero_result, addr, ">>");
	    }
	    if ((unsigned)sp[-1].max < 32 && (unsigned)sp[-1].min < 32) { 
		sp[-2].max = (sp[-2].max >= 0) 
		    ? sp[-2].max >> sp[-1].min : sp[-2].max >> sp[-1].max;
		sp[-2].min = (sp[-2].min >= 0) 
		    ? sp[-2].min >> sp[-1].max : sp[-2].min >> sp[-1].min;
	    } else { 
		if (sp[-2].max < 0) sp[-2].max = -1;
		if (sp[-2].min > 0) sp[-2].min = 0;
	    }
	    sp[-2].type = tp_int;
	    sp[-2].index = NO_ASSOC_VAR;
	    sp -= 1;
	    break;
	  case iushr:
	    if ((sp[-1].min == 0 && sp[-1].max == 0) ||
		(sp[-2].min == 0 && sp[-2].max == 0))
	    {
		message(msg_zero_operand, addr, ">>>");
	    }
	    if (sp[-1].max < 0) {
		message(msg_shift_count, addr, ">>>", "<=", (void*)sp[-1].max);
	    } else if(sp[-1].min >= 32) { 
		message(msg_shift_count, addr, ">>>", ">=", (void*)sp[-1].min);
	    } 
	    else if ((unsigned(sp[-1].max - sp[-1].min) < 256) 
		     && (sp[-1].max >= 32 || sp[-1].min < 0))
	    { 
		//
		// Produce this message only if range of expression was 
		// restricted in comparence with domains of builtin types
		//
		message(msg_shift_range, addr, ">>>",
			(void*)sp[-1].min, (void*)sp[-1].max);
	    }
	    sp[-2].mask = make_rushift_mask(sp[-2].mask, 
					    sp[-1].min, sp[-1].max);
	    if (sp[-2].mask == 0) { 
		message(msg_zero_result, addr, ">>>");
	    }
	    if ((unsigned)sp[-1].max < 32 && (unsigned)sp[-1].min < 32
		&& sp[-2].min >= 0) 
            { 
		sp[-2].max >>= sp[-1].min;
		sp[-2].min >>= sp[-1].max;
	    } else { 
		sp[-2].max = ranges[tp_int].max;
		sp[-2].min = ranges[tp_int].min;
	    }
	    sp[-2].type = tp_int;
	    sp[-2].index = NO_ASSOC_VAR;
	    sp -= 1;
	    break;
	  case iand:
	    if ((sp[-1].min == 0 && sp[-1].max == 0) ||
		(sp[-2].min == 0 && sp[-2].max == 0))
	    {
		message(msg_zero_operand, addr, "&");
	    }
	    if (*pc == ifeq || *pc == ifne) { 
		if (sp[-1].index >= 0 && 
		    sp[-2].min == sp[-2].mask && sp[-2].max == sp[-2].mask) 
		{
		    sp[-2].index = sp[-1].index; 
		} 
		else if (sp[-2].index < 0 || 
		    sp[-1].min != sp[-1].mask || sp[-1].max != sp[-1].mask) 
		{
		    sp[-2].index = NO_ASSOC_VAR;
		}
	    } else { 
		sp[-2].index = NO_ASSOC_VAR;
	    }
	    if ((sp[-2].mask &= sp[-1].mask) == 0) { 
		message(msg_zero_result, addr, "&");
	    }
	    sp[-2].min = sp[-2].mask < 0 ? ranges[tp_int].min : 0;
	    sp[-2].max = (sp[-1].max & sp[-2].max) >= 0
		? sp[-2].mask & ranges[tp_int].max : 0;
	    sp[-2].type = tp_int;
	    sp -= 1;
	    break;
	  case ior:
	    if ((sp[-1].min == 0 && sp[-1].max == 0) ||
		(sp[-2].min == 0 && sp[-2].max == 0))
	    {
		message(msg_zero_operand, addr, "|");
	    }
	    sp[-2].mask |= sp[-1].mask;
	    sp[-2].min = minimum(sp[-1].min, sp[-2].min);
	    sp[-2].max = sp[-2].mask & ranges[tp_int].max;
	    if (sp[-2].min > sp[-2].max) { 
		sp[-2].max = sp[-2].min;
	    }
	    sp[-2].type = tp_int;
	    sp[-2].index = NO_ASSOC_VAR;
	    sp -= 1;
	    break;
	  case ixor:
	    if ((sp[-1].min == 0 && sp[-1].max == 0) ||
		(sp[-2].min == 0 && sp[-2].max == 0))
	    {
		message(msg_zero_operand, addr, "^");
	    }
	    sp[-2].mask |= sp[-1].mask;
	    sp[-2].min = sp[-2].mask < 0 ? ranges[tp_int].min : 0;
	    sp[-2].max = sp[-2].mask & ranges[tp_int].max;
	    sp[-2].type = tp_int;
	    sp[-2].index = NO_ASSOC_VAR;
	    sp -= 1;
	    break;
#ifdef INT8_DEFINED
	  case ladd:
	    LOAD_INT8_OPERANDS();
	    if ((right_min == 0 && right_max == 0) ||
		(left_min == 0 && left_max == 0))
	    {
		message(msg_zero_operand, addr, "+");
	    }
	    if (((right_max ^ left_max) < 0 
		 || ((right_max + left_max) ^ right_max) >= 0)
		&& ((right_min ^ left_min) < 0 
		    || ((right_min + left_min) ^ right_min) >= 0))
	    {
		left_max += right_max;
		left_min += right_min;
	    } else { 
		left_min = INT8_MIN;
		left_max = INT8_MAX;
	    }
	    left_mask = make_int8_mask(minimum(first_set_bit(right_mask), 
					       first_set_bit(left_mask)));
	    STORE_INT8(sp-4, min, left_min);
	    STORE_INT8(sp-4, max, left_max);
	    STORE_INT8(sp-4, mask, left_mask);
	    sp[-4].index = NO_ASSOC_VAR;
	    sp -= 2;
	    break;
	  case lsub:
	    LOAD_INT8_OPERANDS();
	    if ((right_min == 0 && right_max == 0) ||
		(left_min == 0 && left_max == 0))
	    {
		message(msg_zero_operand, addr, "-");
	    }
	    if (((left_max ^ right_min) >= 0 
		 || ((left_max - right_min) ^ left_max) >= 0)
		&& ((left_min ^ right_max) >= 0 
		    || ((left_min - right_max) ^ left_min) >= 0))
	    {
		left_max -= right_min;
		left_min -= right_max;
	    } else { 
		left_max = INT8_MAX;
		left_min = INT8_MIN;
	    }
	    left_mask = make_int8_mask(minimum(first_set_bit(left_mask), 
					       first_set_bit(right_mask)));
	    STORE_INT8(sp-4, min, left_min);
	    STORE_INT8(sp-4, max, left_max);
	    STORE_INT8(sp-4, mask, left_mask);
	    sp[-4].index = NO_ASSOC_VAR;
	    sp -= 2;
	    break;
	  case lmul:
	    LOAD_INT8_OPERANDS();
	    if ((right_min == 0 && right_max == 0) ||
		(left_min == 0 && left_max == 0))
	    {
		message(msg_zero_operand, addr, "*");
	    }
	    left_mask = make_int8_mask(first_set_bit(left_mask) +  
				       first_set_bit(right_mask));
	    if (left_mask == 0) { 
		message(msg_zero_result, addr, "*");
		STORE_INT8(sp-4, min, 0);
		STORE_INT8(sp-4, max, 0);
	    } else { 
		if (!calculate_int8_multiply_range(sp-4, sp-2)) { 
		    STORE_INT8(sp-4, min, INT8_MIN);
		    STORE_INT8(sp-4, max, INT8_MAX);
		}
	    }
	    sp[-4].index = NO_ASSOC_VAR;
	    sp -= 2;
	    break;
	  case lidiv:
	    LOAD_INT8_OPERANDS();
	    if ((right_min == 0 && right_max == 0) ||
		(left_min == 0 && left_max == 0))
	    {
		message(msg_zero_operand, addr, "/");
	    }
	    if ((right_min > 0 
		 && (left_max < right_min && left_min > -right_min))
		|| (right_max < 0
		    && (-left_max > right_max && left_min > right_max)))
	    {
		message(msg_zero_result, addr, "/");
		left_min = left_max = 0;
	    } else if (right_min > 0) { 
		if (left_max < 0) { 
		    left_min = left_min/right_min;
		    left_max = left_max/right_max;
		} else if (left_min < 0) { 
		    left_min = left_min/right_min;
		    left_max = left_max/right_min;
		} else { 
		    left_min = left_min/right_max;
		    left_max = left_max/right_min;
		}
	    } else { 
		left_min = INT8_MIN;
		left_max = INT8_MAX;
	    } 
	    left_mask = make_int8_mask(first_set_bit(left_mask) -  
				       first_set_bit(right_mask));
	    STORE_INT8(sp-4, min, left_min);
	    STORE_INT8(sp-4, max, left_max);
	    STORE_INT8(sp-4, mask, left_mask);
	    sp[-4].index = NO_ASSOC_VAR;
	    sp -= 2;
	    break;
	  case lrem:
	    LOAD_INT8_OPERANDS();
	    if ((right_min == 0 && right_max == 0) ||
		(left_min == 0 && left_max == 0))
	    {
		message(msg_zero_operand, addr, "%");
	    }
	    if ((right_min > 0 
		 && (left_max < right_min && left_min > -right_min))
		|| (right_max < 0
		    && (-left_max > right_max && left_min > right_max)))
	    {
		message(msg_no_effect, addr);
	    } else if (right_min > 0) {    
		left_min = (left_min < 0) ? 1-right_max : 0;
		left_max = right_max-1;
	    } else { 
		left_min = INT8_MIN;
		left_max = INT8_MAX;
	    }
	    STORE_INT8(sp-4, min, left_min);
	    STORE_INT8(sp-4, max, left_max);
	    STORE_INT8(sp-4, mask, INT8_ALL_BITS);
	    sp[-4].index = NO_ASSOC_VAR;
	    sp -= 2;
	    break;
	  case lshl:
	    sp -= 1;
	    LOAD_INT8_OPERAND();
	    if ((sp->min == 0 && sp->max == 0) ||
		(left_min == 0 && left_max == 0))
	    {
		message(msg_zero_operand, addr, "<<");
	    }
	    if (sp->max < 0) {
		message(msg_shift_count, addr, "<<", "<=", (void*)sp->max);
	    } else if(sp->min >= 64) { 
		message(msg_shift_count, addr, "<<", ">=", (void*)sp->min);
	    } 
	    else if ((unsigned(sp->max - sp->min) < 256) 
		     && (sp->max >= 64 || sp->min < 0))
	    { 
		//
		// Produce this message only if range of expression was 
		// restricted in comparence with domains of builtin types
		//
		message(msg_shift_range, addr, "<<",
			(void*)sp->min, (void*)sp->max);
	    }
	    left_mask = make_int8_lshift_mask(left_mask, 
					      sp->min, sp->max);
	    if (left_mask == 0) { 
		message(msg_zero_result, addr, "<<");
	    }
	    if ((unsigned)sp->max < 64 && (unsigned)sp->min < 64) {  
		if (left_max >= 0) { 
		    if (left_max << sp->max >> sp->max == left_max){
			left_max = left_max << sp->max;
		    } else { 
			left_max = INT8_MAX;
			left_min = INT8_MIN;
		    }
		} else { 
		    if (left_max << sp->min >> sp->min == left_max){
			left_max = left_max << sp->min;
		    } else { 
			left_max = INT8_MAX;
			left_min = INT8_MIN;
		    }
		}
		if (left_min >= 0) { 
		    left_min <<= sp->min;
		} else { 
		    if (left_min << sp->max >> sp->max == left_min){
			left_min = left_min << sp->max;
		    } else { 
			left_max = INT8_MAX;
			left_min = INT8_MIN;
		    }
		}
	    } else {
		left_max = INT8_MAX;
		left_min = INT8_MIN;
	    }
	    STORE_INT8(sp-2, min, left_min);
	    STORE_INT8(sp-2, max, left_max);
	    STORE_INT8(sp-2, mask, left_mask);
	    sp[-2].index = NO_ASSOC_VAR;
	    break;
	  case lshr:
	    sp -= 1;
	    LOAD_INT8_OPERAND();
	    if ((sp->min == 0 && sp->max == 0) ||
		(left_min == 0 && left_max == 0))
	    {
		message(msg_zero_operand, addr, ">>");
	    }
	    if (sp->max < 0) {
		message(msg_shift_count, addr, ">>", "<=", (void*)sp->max);
	    } else if(sp->min >= 64) { 
		message(msg_shift_count, addr, ">>", ">=", (void*)sp->min);
	    } 
	    else if ((unsigned(sp->max - sp->min) < 256) 
		     && (sp->max >= 64 || sp->min < 0))
	    { 
		//
		// Produce this message only if range of expression was 
		// restricted in comparence with domains of builtin types
		//
		message(msg_shift_range, addr, ">>",
			(void*)sp->min, (void*)sp->max);
	    }
	    left_mask = make_int8_rshift_mask(left_mask, 
					      sp->min, sp->max);
	    if (left_mask == 0) { 
		message(msg_zero_result, addr, ">>");
	    }
	    if ((unsigned)sp->max < 64 && (unsigned)sp->min < 64) { 
		left_max = (left_max >= 0) 
		    ? left_max >> sp->min : left_max >> sp->max;
		left_min = (left_min >= 0) 
		    ? left_min >> sp->max : left_min >> sp->min;
	    } else { 
		if (left_max < 0) left_max = -1;
		if (left_min > 0) left_min = 0;
	    }
	    STORE_INT8(sp-2, min, left_min);
	    STORE_INT8(sp-2, max, left_max);
	    STORE_INT8(sp-2, mask, left_mask);
	    sp[-2].index = NO_ASSOC_VAR;
	    break;
	  case lushr:
	    sp -= 1;
	    LOAD_INT8_OPERAND();
	    if ((sp->min == 0 && sp->max == 0) ||
		(left_min == 0 && left_max == 0))
	    {
		message(msg_zero_operand, addr, ">>>");
	    }
	    if (sp->max < 0) {
		message(msg_shift_count, addr, ">>>", "<=", (void*)sp->max);
	    } else if(sp->min >= 64) { 
		message(msg_shift_count, addr, ">>>", ">=", (void*)sp->min);
	    } 
	    else if ((unsigned(sp->max - sp->min) < 256) 
		     && (sp->max >= 64 || sp->min < 0))
	    { 
		//
		// Produce this message only if range of expression was 
		// restricted in comparence with domains of builtin types
		//
		message(msg_shift_range, addr, ">>>",
			(void*)sp->min, (void*)sp->max);
	    }
	    left_mask = make_int8_rushift_mask(left_mask, sp->min, sp->max);
	    if (left_mask == 0) { 
		message(msg_zero_result, addr, ">>>");
	    }
	    if ((unsigned)sp->max < 64 && (unsigned)sp->min < 64 
		&& left_min >= 0) 
            { 
		left_max >>= sp->min;
		left_min >>= sp->max;
	    } else { 
		left_max = INT8_MAX;
		left_min = INT8_MIN;
	    }
	    STORE_INT8(sp-2, min, left_min);
	    STORE_INT8(sp-2, max, left_max);
	    STORE_INT8(sp-2, mask, left_mask);
	    sp[-2].index = NO_ASSOC_VAR;
	    break;
	  case land:
	    LOAD_INT8_OPERANDS();
	    if ((right_min == 0 && right_max == 0) ||
		(left_min == 0 && left_max == 0))
	    {
		message(msg_zero_operand, addr, "&");
	    }
	    if ((left_mask &= right_mask) == 0) { 
		message(msg_zero_result, addr, "&");
	    }
	    left_min = left_mask < 0 ? INT8_MIN : 0;
	    left_max = (right_max & left_max) >= 0
		? left_mask & INT8_MAX : 0;
	    STORE_INT8(sp-4, min, left_min);
	    STORE_INT8(sp-4, max, left_max);
	    STORE_INT8(sp-4, mask, left_mask);
	    sp[-4].index = NO_ASSOC_VAR;
	    sp -= 2;
	    break;
	  case lor:
	    LOAD_INT8_OPERANDS();
	    if ((right_min == 0 && right_max == 0) ||
		(left_min == 0 && left_max == 0))
	    {
		message(msg_zero_operand, addr, "|");
	    }
	    left_mask |= right_mask;
	    if (right_min < left_min) { 
		left_min = right_min;
	    }
	    left_max = left_mask & INT8_MAX;
	    if (left_max < left_min) { 
		left_max = left_min;
	    }
	    STORE_INT8(sp-4, min, left_min);
	    STORE_INT8(sp-4, max, left_max);
	    STORE_INT8(sp-4, mask, left_mask);
	    sp[-4].index = NO_ASSOC_VAR;
	    sp -= 2;
	    break;
	  case lxor:
	    LOAD_INT8_OPERANDS();
	    if ((right_min == 0 && right_max == 0) ||
		(left_min == 0 && left_max == 0))
	    {
		message(msg_zero_operand, addr, "^");
	    }
	    left_mask |= right_mask;
	    left_min = left_mask < 0 ? INT8_MIN : 0;
	    left_max = left_mask & INT8_MAX;
	    STORE_INT8(sp-4, min, left_min);
	    STORE_INT8(sp-4, max, left_max);
	    STORE_INT8(sp-4, mask, left_mask);
	    sp[-4].index = NO_ASSOC_VAR;
	    sp -= 2;
	    break;
          case lneg:
	    LOAD_INT8_OPERAND();
	    if (left_min == left_max) {
		left_min = left_max = left_mask = -left_max;
	    } else { 
		int8 min = left_min; 
		left_min = (left_max == INT8_MAX)? INT8_MIN : -left_max;
		left_max = (min == INT8_MIN) ? INT8_MAX : -min;
		left_mask = make_mask(first_set_bit(left_mask));
	    }
	    STORE_INT8(sp-2, min, left_min);
	    STORE_INT8(sp-2, max, left_max);
	    STORE_INT8(sp-2, mask, left_mask);
	    sp[-2].index = NO_ASSOC_VAR;
	    break;
#else
	  case ladd:
	  case lsub:
	  case lmul:
	  case lidiv:
	  case lrem:
	  case lor:
	  case lxor:
	  case land:
	    sp -= 2;
	    break;
	  case lshl:
	  case lshr:
	  case lushr: 
	    sp -= 1;
	    break;
          case lneg:
	    break;
#endif
	  case fadd:	    
	  case fsub:
	  case fmul:
	  case fdiv:
	  case frem:
	    sp -= 1;
	    break;
	  case dadd:
	  case dsub:
	  case dmul:
	  case ddiv:
	  case drem:
	    sp -= 2;
	    break;
	  case ineg:
	    if (sp[-1].min == sp[-1].max) {
		sp[-1].mask = sp[-1].min = sp[-1].max = -sp[-1].max; 
	    } else { 
		int min = sp[-1].min; 
		sp[-1].min = (sp[-1].max == ranges[tp_int].max)
		    ? ranges[tp_int].min : -sp[-1].max;
		sp[-1].max = (min == ranges[tp_int].min)
		    ? ranges[tp_int].max : -min;
		sp[-1].mask = make_mask(first_set_bit(sp[-1].mask));
	    }
	    sp[-1].type = tp_int;
	    sp[-1].index = NO_ASSOC_VAR;
	    break;
	  case fneg:
	  case dneg:
	    break;
	  case iinc:
	    {
	      var_desc* var = &vars[*pc];
	      var_store_count[*pc++] += 1;
	      int add = (signed char)*pc++;
	      if (((var->max^add) < 0 || ((var->max+add) ^ add) >= 0)
		  && ((var->min^add) < 0  || ((var->min+add) ^ add) >= 0))
	      {
		  var->max += add;
		  var->min += add;
	      } else { 
		  var->max = ranges[tp_int].max;
		  var->min = ranges[tp_int].min;
	      }
	      var->mask = make_mask(maximum(last_set_bit(var->mask),
					    last_set_bit(add))+1, 
				    minimum(first_set_bit(var->mask), 
					    first_set_bit(add)));
	    }
	    break;
	  case i2l:
	    if (prev_cop == imul || prev_cop == ishl) { 
		message(msg_overflow, addr);
	    }
	    sp->min = sp[-1].min;
	    sp->max = sp[-1].max;
	    sp->mask = sp[-1].mask;
	    sp->type = tp_long;
	    sp[-1].max >>= 31; // extend sign
	    sp[-1].min >>= 31; 
	    sp[-1].mask >>= 31;
	    sp[-1].type = tp_long;
	    sp[-1].index = NO_ASSOC_VAR;
	    sp += 1;
	    break;
	  case f2l:
	    sp += 1;
	    nobreak;
	  case d2l:
	    sp[-2].type = tp_long; 
	    sp[-2].index= NO_ASSOC_VAR; 
	    sp[-2].min  = 0x80000000;
	    sp[-2].max  = 0x7fffffff;
	    sp[-2].mask = 0xffffffff;
	    sp[-1].type = tp_long;
	    sp[-1].min  = 0x00000000;
	    sp[-1].max  = 0xffffffff;
	    sp[-1].mask = 0xffffffff;
	    break;
	  case i2d:
	  case f2d:
	    sp[-1].type = sp[0].type = tp_double;
	    sp[-1].index = sp[0].index = NO_ASSOC_VAR; 
	    sp += 1;
	    break;
	  case i2b:
	    if (sp[-1].max < ranges[tp_byte].min || 
		sp[-1].min > ranges[tp_byte].max)
	    {
		message(msg_conversion, addr, "byte");
	    } 
	    else if ((sp[-1].mask << 24 >> 23) != (sp[-1].mask << 1)
		     && sp[-1].mask != 0xffff  // char to byte 
		     && sp[-1].mask != 0xff)   // int & 0xFF to byte 
            {
		message(msg_truncation, addr, "byte");
	    }
	    if (sp[-1].max > ranges[tp_byte].max ||
		sp[-1].min < ranges[tp_byte].min) 
            { 
		sp[-1].max = ranges[tp_byte].max;
		sp[-1].min = ranges[tp_byte].min;
	    } 
	    sp[-1].mask = sp[-1].mask << 24 >> 24;
	    sp[-1].type = tp_byte;
	    sp[-1].index = NO_ASSOC_VAR;
	    break;
	  case i2f:
	    sp[-1].type = tp_float;
	    sp[-1].index = NO_ASSOC_VAR;
	    break;
	  case l2i:
#ifdef INT8_DEFINED
	    LOAD_INT8_OPERAND();
	    if (left_max < ranges[tp_int].min || left_min > ranges[tp_int].max)
	    {
		message(msg_conversion, addr, "int");
	    } else if (sp[-2].mask != 0 && sp[-2].mask != ~0) {
		message(msg_truncation, addr, "int");
	    }
	    if (left_min >= ranges[tp_int].min &&
		left_max <= ranges[tp_int].max)
	    { 
		sp[-2].min = sp[-1].min;
		sp[-2].max = sp[-1].max;
	    } else { 
		sp[-2].min = ranges[tp_int].min;
		sp[-2].max = ranges[tp_int].max;
	    }
#else
	    sp[-2].min = ranges[tp_int].min;
	    sp[-2].max = ranges[tp_int].max;
#endif	    
	    sp[-2].type = tp_int;
	    sp[-2].mask = sp[-1].mask;
	    sp[-2].index = NO_ASSOC_VAR;
	    sp -= 1;
	    break;
	  case d2i:
	    sp -= 1;
	    sp[-1].type = tp_int;
	    sp[-1].min = ranges[tp_int].min;
	    sp[-1].max = ranges[tp_int].max;
	    sp[-1].mask = ALL_BITS;
	    sp[-1].index = NO_ASSOC_VAR;
	    break;
	  case l2f:
	  case d2f:
	    sp -= 1;
	    sp[-1].type = tp_float;
	    sp[-1].index = NO_ASSOC_VAR;
	    break;
	  case l2d:
	    sp[-1].type = sp[-2].type = tp_double;
	    sp[-1].index = sp[-2].index = NO_ASSOC_VAR;
	    break;
	  case f2i:
	    sp[-1].type = tp_int;
	    sp[-1].min = ranges[tp_int].min;
	    sp[-1].max = ranges[tp_int].max;
	    sp[-1].mask = ALL_BITS;
	    sp[-1].index = NO_ASSOC_VAR;
	    break;	    
	  case i2c:
	    if (sp[-1].max < ranges[tp_char].min || 
		sp[-1].min > ranges[tp_char].max)
	    {
		message(msg_conversion, addr, "char");
	    } 
	    else if ((sp[-1].mask & 0x7fff0000) != 0 &&
		     (sp[-1].mask & 0x7fff0000) != 0x7fff0000)
	    {
		message(msg_truncation, addr, "char");
	    }
	    if (sp[-1].max > ranges[tp_char].max ||
		sp[-1].min < ranges[tp_char].min) 
	    { 
		sp[-1].min = ranges[tp_char].min;
		sp[-1].max = ranges[tp_char].max;
	    } 
	    sp[-1].mask &= 0xFFFF;
	    sp[-1].type = tp_char;
	    sp[-1].index = NO_ASSOC_VAR;	    
	    break;
	  case i2s:
	    if (sp[-1].max < ranges[tp_short].min || 
		sp[-1].min > ranges[tp_short].max)
	    {
		message(msg_conversion, addr, "short");
	    } else if ((sp[-1].mask << 16 >> 15) != (sp[-1].mask << 1)) {
		message(msg_truncation, addr, "short");
	    }
	    if (sp[-1].max > ranges[tp_short].max ||
		sp[-1].min < ranges[tp_short].min) 
	    { 
		sp[-1].max = ranges[tp_short].max;
		sp[-1].min = ranges[tp_short].min;
	    } 
	    sp[-1].mask = sp[-1].mask << 16 >> 16;
	    sp[-1].type = tp_short;
	    sp[-1].index = NO_ASSOC_VAR;	    
	    break;
	  case lcmp:
#ifdef INT8_DEFINED
	    LOAD_INT8_OPERANDS();
	    if (*pc == ifeq || *pc == ifne) { 
		if ((left_mask & right_mask) == 0 
		    && !((left_min == 0 && left_max == 0) ||
			 (right_min == 0 && right_max == 0)))
		{ 
		    message(msg_disjoint_mask, addr);
		}
	    }
	    if (left_min > right_max || left_max < right_min
		|| ((*pc == ifge || *pc == iflt) && left_min >= right_max)
		|| ((*pc == ifle || *pc == ifgt) && left_max <= right_min))
	    {
		message(msg_same_result, addr);
	    } 
	    else if (((*pc == ifgt || *pc == ifle) && left_min == right_max) ||
		     ((*pc == iflt || *pc == ifge) && left_max == right_min))
	    {
		message(msg_weak_cmp, addr);
	    }
#endif
	    sp -= 4;
	    sp->type = tp_int;
	    sp->min = -1;
	    sp->max = 1;
	    sp->mask = ALL_BITS;
	    sp->index = NO_ASSOC_VAR;	    
	    sp += 1;
	    break;
	  case dcmpl:
	  case dcmpg:
	    sp -= 2; 
	    nobreak;
	  case fcmpl:
	  case fcmpg:
	    sp -= 2;
	    sp->type = tp_int;
	    sp->min = -1;
	    sp->max = 1;
	    sp->mask = ALL_BITS;
	    sp->index = NO_ASSOC_VAR;	    
	    sp += 1;
	    break;
	  case ifeq:
	  case ifne:
	  case iflt:
	  case ifge:
	  case ifgt:
	  case ifle:
	    sp -= 1; 
	    if (sp->min > 0 || sp->max < 0 || sp->min == sp->max
		|| (sp->min == 0 && (cop == iflt || cop == ifge)) 
		|| (sp->max == 0 && (cop == ifgt || cop == ifle))) 
            {
		message(msg_same_result, addr);
	    } 
	    else if ((sp->min == 0 && (cop == ifle || cop == ifgt)) || 
		     (sp->max == 0 && (cop == ifge || cop == iflt)))
	    {
		message(msg_weak_cmp, addr);
	    }
	    pc += 2; 
	    break;
	  case if_icmpeq:
	  case if_icmpne:
	    if (sp[-2].min == sp[-2].max && sp[-1].min == sp[-1].max) { 
		message(msg_same_result, addr);
	    } else if ((sp[-2].mask & sp[-1].mask) == 0 
		&& sp[-2].type != tp_bool && sp[-1].type != tp_bool) 
            { 
		message(msg_disjoint_mask, addr);
	    }
	    nobreak;
	  case if_icmplt:
	  case if_icmpge:
	  case if_icmpgt:
	  case if_icmple:
	    if (sp[-2].min > sp[-1].max || sp[-2].max < sp[-1].min
		|| ((cop == if_icmpge || cop == if_icmplt) 
		    && sp[-2].min >= sp[-1].max)
		|| ((cop == if_icmple || cop == if_icmpgt)
		    && sp[-2].max <= sp[-1].min))
	    {
		message(msg_same_result, addr);
	    } 
	    else if (((cop == if_icmpgt || cop == if_icmple) 
		      && sp[-2].min == sp[-1].max) ||
		     ((cop == if_icmplt || cop == if_icmpge)
		      && sp[-2].max == sp[-1].min))
	    {
		message(msg_weak_cmp, addr);
	    }
	    if ((sp[-1].type == tp_short && sp[-2].type == tp_char) 
		|| (sp[-2].type == tp_short && sp[-1].type == tp_char))
	    {
		message(msg_short_char_cmp, addr);
	    }
	    sp -= 2;
	    pc += 2;
	    break;
	  case if_acmpeq:
	  case if_acmpne:
	    if (sp[-1].type == tp_string && sp[-2].type == tp_string) { 
		message(msg_string_cmp, addr);
	    }
	    sp -= 2;
	    pc += 2;
	    break;
	  case jsr:
	  case goto_near:
	    pc += 2;
	    break;
	  case ret:
	    pc += 1;
	    break;
	  case tableswitch:
	    { 
	      pc += 7 - (addr & 3);
	      int low = unpack4(pc);
	      int high = unpack4(pc+4);
	      sp -= 1;
	      if (low < sp->min) { 
		  message(msg_incomp_case, addr, low);
	      } 
	      if (high > sp->max) {
		  message(msg_incomp_case, addr,  high);
	      } 
	      pc += (high - low + 1)*4 + 8;
	    }
	    break;
	  case lookupswitch:
	    { 
	      pc += 7 - (addr & 3);
	      int n_pairs = unpack4(pc);
	      pc += 4;
	      sp -= 1;
	      while (--n_pairs >= 0) { 
		  int val = unpack4(pc);
		  int label = unpack4(pc+4);
		  pc += 8;
		  if (val < sp->min || val > sp->max || (val & ~sp->mask)) { 
		      message(msg_incomp_case, addr+label, val);
		  } 
	      }
	    } 
	    break;
	  case ireturn:
	  case freturn:
	  case areturn:
	    sp -= 1;
	    break;
	  case dreturn:
	  case lreturn:
	    sp -= 2;
	    break;
	  case vreturn:
	    break;
	  case getfield:
	    sp -= 1;
	    nobreak;
	  case getstatic:
	    {
	      const_ref* field_ref = (const_ref*)constant_pool[unpack2(pc)];
	      const_name_and_type* nt = 
		(const_name_and_type*)constant_pool[field_ref->name_and_type];
    	      const_utf8* field_name= (const_utf8*)constant_pool[nt->name];
	      const_utf8* desc = (const_utf8*)constant_pool[nt->desc];
	      const_class*cls_info=(const_class*)constant_pool[field_ref->cls];
	      const_utf8* cls_name=(const_utf8*)constant_pool[cls_info->name];
	      class_desc* obj_cls = class_desc::get(*cls_name);
	      field_desc* field = obj_cls->get_field(*field_name);

	      if (cop == getfield) { 
		  check_variable_for_null(addr, sp);
	      }
	      if (cls->name == *cls_name) { 
		  field->attr |= field_desc::f_used;
	      }	      
	      if (!in_monitor) { 
		  accessors = new access_desc(field, cls, 
					      get_line_number(addr), 
					      accessors);
		  if (cop == getfield) { 
		      if (sp->type == tp_self) { 
			  accessors->attr |= access_desc::a_self;
		      } 
		      if (sp->mask & var_desc::vs_new) { 
			  accessors->attr |= access_desc::a_new;
		      } 
		  }
	      }
	      int type = get_type(*desc);
	      sp->type = type;
	      if (IS_INT_TYPE(type)) { 
		  sp->min = ranges[type].min;
		  sp->max = ranges[type].max;
		  sp->mask = sp->min|sp->max;
	      } else { 
		  sp->mask = var_desc::vs_unknown;
		  sp->min = 0;
		  sp->max = MAX_ARRAY_LENGTH;
	      }
	      sp->index = NO_ASSOC_VAR;
	      sp += 1;
	      if (type == tp_long || type == tp_double) { 
		  sp->type = type;
		  sp->max = 0xffffffff;
		  sp->min = 0;
		  sp->mask = 0xffffffff;
		  sp[-1].max = 0x7fffffff;
		  sp[-1].min = 0x80000000;
		  sp[-1].mask = 0xffffffff;
		  sp += 1;
	      }
	      pc += 2;
	    }
	    break;
	  case putfield:
	  case putstatic:
	    {
	      const_ref* field_ref = (const_ref*)constant_pool[unpack2(pc)];
	      const_name_and_type* nt = 
		(const_name_and_type*)constant_pool[field_ref->name_and_type];
	      const_utf8* desc = (const_utf8*)constant_pool[nt->desc];
	      const_class*cls_info=(const_class*)constant_pool[field_ref->cls];
	      const_utf8* cls_name=(const_utf8*)constant_pool[cls_info->name];
    	      const_utf8* field_name= (const_utf8*)constant_pool[nt->name];
	      class_desc* obj_cls = class_desc::get(*cls_name);
	      field_desc* field = obj_cls->get_field(*field_name);

	      if (cls->name == *cls_name) { 
		  field->attr |= field_desc::f_used;
	      }	      
	      if (!in_monitor) { 
		  accessors = new access_desc(field, cls, 
					      get_line_number(addr), 
					      accessors);
	      }
	      int type = get_type(*desc);
	      sp -= (type == tp_long || type == tp_double) ? 2 : 1;
	      if (cop == putfield) { 
		  sp -= 1;
		  if (!in_monitor) { 
		      if (sp->type == tp_self) { 
			  accessors->attr |= access_desc::a_self;
		      }
		      if (sp->mask & var_desc::vs_new) { 
			  accessors->attr |= access_desc::a_new;
		      }
		  }
		  check_variable_for_null(addr, sp);
	      }
	      pc += 2;
	    }
	    break;	    
	  case invokespecial:	
	  case invokevirtual:	
	  case invokestatic:
	  case invokeinterface:
	    {
	      const_ref* method_ref = (const_ref*)constant_pool[unpack2(pc)];
	      const_class* cls_info = 
		  (const_class*)constant_pool[method_ref->cls];
	      utf_string cls_name(*(const_utf8*)constant_pool[cls_info->name]);
	      class_desc* obj_cls = class_desc::get(cls_name);
	      const_name_and_type* nt = 
	       (const_name_and_type*)constant_pool[method_ref->name_and_type];
	      utf_string mth_name(*(const_utf8*)constant_pool[nt->name]);
	      utf_string mth_desc(*(const_utf8*)constant_pool[nt->desc]);
	      if (cls_name == "java/lang/Object") { 
		  if (!(attr & m_synchronized) &&
		      (mth_name == "notify" 
		       || mth_name == "notify_all" 
		       || mth_name == "wait"))
		  {
		      message(msg_wait_nosync, addr, &mth_name);
		  }
		  if (mth_name == "wait") { 
		      wait_line = get_line_number(addr);
		      attr |= m_wait;
		  }
	      }
	      int n_params = get_number_of_parameters(mth_desc);
	      int fp = n_params;
	      if (cop != invokestatic) { 
		  fp += 1;
		  check_variable_for_null(addr, sp-fp);
	      }  
	      if (cop == invokespecial) { 
		  if (mth_name == "finalize") { 
		      super_finalize = true;
		  }
	      } else { 
		  method_desc* method = obj_cls->get_method(mth_name,mth_desc);
		  int call_attr = 0;
		  if (cop != invokestatic && sp[-fp].type == tp_self) { 
		      call_attr |= callee_desc::i_self;
		  } 
		  if (in_monitor) { 
		      call_attr |= callee_desc::i_synchronized;
		  }
		  callees = new callee_desc(cls, method, callees,
					    get_line_number(addr), call_attr);
		  if (n_params < 32) { 
		      int mask = 0;
		      for (i = 0; i < n_params; i++) { 
			  if ((sp[i-n_params].type == tp_object 
			       || sp[i-n_params].type == tp_string)
			      && sp[i-n_params].mask == 0) 
                          { 
			      mask |= 1 << i;
			  }
		      }
		      if (cop != invokestatic) { 
			  // Reference to target object i passed as 0 parameter
			  mask <<= 1;
		      }
		      method->null_parameter_mask |= mask;
		  }
	      }
	      int type = get_type(mth_desc);	    
	      sp -= fp;
	      if (type != tp_void) { 
		  if (IS_INT_TYPE(type)) { 
		      sp->min = ranges[type].min;
		      sp->max = ranges[type].max;
		      sp->mask = sp->min|sp->max;
		  } else { 
		      sp->min = 0;
		      sp->max = MAX_ARRAY_LENGTH;
		      sp->mask = var_desc::vs_unknown;
		  }
		  sp->index = NO_ASSOC_VAR;
		  sp->type = type;
		  sp += 1;
		  if (type == tp_long || type == tp_double) { 
		      sp->type = type;
		      sp->max = 0xffffffff;
		      sp->min = 0;
		      sp->mask = 0xffffffff;
		      sp[-1].max = 0x7fffffff;
		      sp[-1].min = 0x80000000;
		      sp[-1].mask = 0xffffffff;
		      sp += 1;
		  }
	      }
	      pc += (cop == invokeinterface) ? 4 : 2; 
	    }
	    break;
	  case anew:
	    sp->type = tp_object;
	    sp->mask = var_desc::vs_new|var_desc::vs_not_null;
	    sp->min = 0;
	    sp->max = MAX_ARRAY_LENGTH;
	    sp->index = NO_ASSOC_VAR;
	    sp += 1;
	    pc += 2;
	    break;
	  case newarray:
	    sp[-1].type = array_type[*pc++] + indirect;
	    sp[-1].mask = var_desc::vs_new|var_desc::vs_not_null;
	    sp[-1].index = NO_ASSOC_VAR;
	    if (sp[-1].min < 0) {
		if (sp[-1].max < 0) { 
		    message(msg_neg_len, addr, sp[-1].min, sp[-1].max);
		} else if (sp[-1].min > -128) { 
		    message(msg_maybe_neg_len, addr, sp[-1].min, sp[-1].max);
		} 
	    }
	    if (sp[-1].min < 0) { 
		sp[-1].min = 0;
		if (sp[-1].max < 0) { 
		    sp[-1].max = 0;
		}
	    }
	    break;
	  case anewarray:
	    sp[-1].type = tp_object + indirect;
	    sp[-1].mask = var_desc::vs_new|var_desc::vs_not_null;
	    sp[-1].index = NO_ASSOC_VAR;
	    if (sp[-1].min < 0) {
		if (sp[-1].max < 0) { 
		    message(msg_neg_len, addr, sp[-1].min, sp[-1].max);
		} else if (sp[-1].min > -128) { 
		    message(msg_maybe_neg_len, addr, sp[-1].min, sp[-1].max);
		} 
	    }
	    if (sp[-1].min < 0) { 
		sp[-1].min = 0;
		if (sp[-1].max < 0) { 
		    sp[-1].max = 0;
		}
	    }
	    pc += 2;
	    break;
	  case arraylength:
	    sp[-1].type = tp_int;
	    sp[-1].mask = make_mask(last_set_bit(sp[-1].max), 0);
	    break;
	  case athrow:
	    sp -= 1;
	    break;
	  case checkcast:
	    pc += 2;
	    break;
	  case instanceof:
	    sp[-1].type = tp_bool;
	    sp[-1].min = 0;
	    sp[-1].max = 1;
	    sp[-1].mask = 1;
	    sp[-1].index = NO_ASSOC_VAR;
	    pc += 2;
	    break;
	  case monitorenter:
	    in_monitor += 1;
	    sp -= 1;
	    break;
	  case monitorexit:
	    in_monitor -= 1;
	    sp -= 1;
	    break;
	  case wide:
	    switch (*pc++) { 
	      case aload:
		{ 
		  var_desc* var = &vars[unpack2(pc)];
		  if (var->type == tp_void) { 
		      var->type = tp_object;
		      var->min = 0;
		      var->max = MAX_ARRAY_LENGTH;
		      var->mask = var_desc::vs_unknown;
		  }
		  sp->type = var->type;
		  sp->min =  var->min; 
		  sp->max =  var->max; 
		  sp->mask = var->mask; 
		  sp->index = var - vars;
		  sp += 1;
		}
		break;
	      case iload:
		{ 
		  var_desc* var = &vars[unpack2(pc)];
		  if (var->type == tp_void) { 
		      var->type = tp_int;
		      var->min = ranges[tp_int].min;
		      var->max = ranges[tp_int].max;
		      var->mask = ALL_BITS;
		  }
		  sp->type = var->type;
		  sp->min =  var->min; 
		  sp->max =  var->max; 
		  sp->mask = var->mask; 
		  sp->index = var - vars;
		  sp += 1;
		}
		break;
	      case dload:
		sp[0].type = sp[1].type = tp_double; 
		sp[0].index = sp[1].index = NO_ASSOC_VAR; 
		sp += 2;
		break;
	      case lload:
		{ 
		  int index = unpack2(pc);
		  if (vars[index].type == tp_void) { 
		      vars[index].type = tp_long;
		      vars[index].min = 0x80000000;
		      vars[index].max = 0x7fffffff;
		      vars[index].mask = 0xffffffff;
		      vars[index+1].min = 0x00000000;
		      vars[index+1].max = 0xffffffff;
		      vars[index+1].mask = 0xffffffff;
		  }
		  sp->type = tp_long;
		  sp->min  = vars[index].min;
		  sp->max  = vars[index].max;
		  sp->mask = vars[index].mask;
		  sp->index = index;
		  sp += 1;
		  index += 1;
		  sp->type = tp_long;
		  sp->min  = vars[index].min;
		  sp->max  = vars[index].max;
		  sp->mask = vars[index].mask;
		  sp += 1;
		}
	        break;
	      case fload:
		sp->type = tp_float; 
		sp->index = NO_ASSOC_VAR;
		sp += 1;
		break;
	      case istore:
		{ 
		  int index = unpack2(pc);
		  var_store_count[index] += 1;
		  var_desc* var = &vars[index];
		  sp -= 1;	
		  var->min = sp->min; 
		  var->max = sp->max; 
		  var->mask = sp->mask; 
		  if (var->type == tp_void) { 
		      var->type = tp_int;
		  }
		}
		break;
	      case astore:
		{ 
		  int index = unpack2(pc);
		  var_store_count[index] += 1;
		  sp -= 1;	
		  vars[index].min = sp->min; 
		  vars[index].max = sp->max; 
		  vars[index].mask = sp->mask; 
		  if (vars[index].type == tp_void) { 
		      vars[index].type = tp_object;
		  }
		}
		break;
	      case fstore:
		sp -= 1;
		break;
	      case lstore:
		{
		  int index = unpack2(pc);
		  sp -= 2;
		  vars[index].type = tp_long;
		  vars[index].max  = sp[0].max;
		  vars[index].min  = sp[0].min;
		  vars[index].mask = sp[0].mask;
		  vars[index+1].max  = sp[1].max;
		  vars[index+1].min  = sp[1].min;
		  vars[index+1].mask = sp[1].mask;
		  var_store_count[index] += 1;
		}
	        break;
	      case dstore:
		sp -= 2;
		break;	    
	      case ret:
		break;
	      case iinc:		
		{ 
		  int index = unpack2(pc);
		  var_store_count[index] += 1;
		  var_desc* var = &vars[index];
		  int add = (short)unpack2(pc+2);
		  if (((var->max^add) < 0 || ((var->max+add) ^ add) >= 0)
		      && ((var->min^add) < 0  || ((var->min+add) ^ add) >= 0))
		  {
		      var->max += add;
		      var->min += add;
		  } else { 
		      var->max = ranges[tp_int].max;
		      var->min = ranges[tp_int].min;
		  }
		  var->mask = make_mask(maximum(last_set_bit(var->mask),
						last_set_bit(add))+1, 
					minimum(first_set_bit(var->mask), 
						first_set_bit(add)));
		  pc += 2;		
		}
	    }
	    pc += 2;
	    break;
	  case multianewarray:
	    {
	      int dimensions = pc[2];
	      sp -= dimensions;
	      sp->type = tp_int + indirect*dimensions;
	      sp->index = NO_ASSOC_VAR;
	      sp->mask = var_desc::vs_new|var_desc::vs_not_null;
	      for (int j = 0; j < dimensions; j++) { 
		  if (sp[j].min < 0) {
		      if (sp[j].max < 0) { 
			  message(msg_neg_len, addr, sp[j].min, sp[j].max);
		      } else if (sp[j].min > -128) { 
			  message(msg_maybe_neg_len, addr, 
				  sp[j].min, sp[j].max);
		      } 
		  }
	      }
	      if (sp->min < 0) { 
		  sp->min = 0;
		  if (sp->max < 0) { 
		      sp->max = 0;
		  }
	      }
	      sp += 1;
	      pc += 3;
	      break;
	    }
	  case ifnull:
	  case ifnonnull:
	    pc += 2;
	    sp -= 1;
	    break;
	  case jsr_w:
	  case goto_w:
	    pc += 4;
	    break;
	  default:
	    assert(false/*Illegal byte code*/);
	}
	prev_cop = cop;
    }
    assert(sp == stack_bottom);

    // pop-up local variables
    for (ctx = context[code_length]; ctx != NULL; ctx = ctx->next) {
	sp = ctx->transfer(this, sp, unused, prev_cop);
    }
    // reset class fields attributes
    for (field_desc* field = cls->fields; field != NULL; field = field->next){ 
	field->attr &= ~field_desc::f_used;
    }
    if (name == "finalize" && !super_finalize) { 
	message(msg_super_finalize, 0);
    }
    // cleanup
    for (i = code_length; i >= 0; i--) { 
	local_context* next;
	for (ctx = context[i]; ctx != NULL; ctx = next) {
	    next = ctx->next;
	    delete ctx;
	}
    }
    delete[] var_store_count;
    delete[] line_table;
    delete[] context;
}

//
// Parse java class file
//

void set_class_source_path(class_desc* cls)
{
    if (source_file_path_len != 0) { 
	char* class_file_name = cls->source_file.as_asciz();
	if (!source_path_redefined) { 
	    char* dirend = strrchr(class_file_name, '/');
	    if (dirend != NULL) { 
		int dirlen = dirend - class_file_name;
		if (dirlen <= source_file_path_len
		    && memcmp(class_file_name, 
			      source_file_path + source_file_path_len - dirlen,
			      dirlen) == 0)
		{
		    class_file_name = dirend+1;
		}
	    }
	}
	char file_name_buf[MAX_MSG_LENGTH];
	int len = sprintf(file_name_buf, "%.*s%c%s", 
			  source_file_path_len, source_file_path, 
			  FILE_SEP, class_file_name);
	cls->source_file = utf_string(len, (byte*)file_name_buf);
    } 
}

bool parse_class_file(byte* fp)
{
    int i;
    unsigned magic = unpack4(fp); 
    fp += 4;
    if (magic != 0xCAFEBABE) return false;
    int minor_version = unpack2(fp);
    fp += 2;
    int major_version = unpack2(fp);
    fp += 2;
    int constant_pool_count = unpack2(fp);
    fp += 2;
    constant** constant_pool = new constant*[constant_pool_count];
    memset(constant_pool, 0, sizeof(constant*)*constant_pool_count);
    for (i = 1; i < constant_pool_count; i++) { 
	constant* cp = NULL;
	int n_extra_cells = 0;
	switch (*fp) { 
	  case c_utf8:
	    cp = new const_utf8(fp);
	    break;
	  case c_integer:
	    cp = new const_int(fp);
	    break;
	  case c_float:
	    cp = new const_float(fp);
	    break;
	  case c_long:
	    cp = new const_long(fp);
	    n_extra_cells += 1;
	    break;
	  case c_double:
	    cp = new const_double(fp);
	    n_extra_cells += 1;
	    break;
	  case c_class:
	    cp = new const_class(fp);
	    break;
	  case c_string:
	    cp = new const_string(fp);
	    break;
	  case c_field_ref:
	  case c_method_ref:
	  case c_interface_method_ref:
	    cp = new const_ref(fp);
	    break;
	  case c_name_and_type:
	    cp = new const_name_and_type(fp);
	    break;
	}
	assert(cp != NULL);
	fp += cp->length();
	constant_pool[i] = cp;
	i += n_extra_cells;
    }	    
    int access_flags = unpack2(fp);
    fp += 2;
    int this_class_name = unpack2(fp);
    fp += 2;
    int super_class_name = unpack2(fp);
    fp += 2;
    int interfaces_count = unpack2(fp);
    fp += 2;
    
    class_desc* this_class = 
	class_desc::get(*(const_utf8*)constant_pool
		       [((const_class*)constant_pool[this_class_name])->name]);

    set_class_source_path(this_class);

    this_class->attr = access_flags;
    if (super_class_name == 0) { // Object class
	assert(interfaces_count == 0); 
	this_class->n_bases = 0;
    } else { 
	this_class->n_bases = interfaces_count + 1;
	this_class->bases = new class_desc*[interfaces_count + 1];
	this_class->bases[0] =
	    class_desc::get(*(const_utf8*)constant_pool
		 [((const_class*)constant_pool[super_class_name])->name]);
    
	for (i = 1; i <= interfaces_count; i++) { 
	    int interface_name = unpack2(fp);
	    fp += 2;
	    this_class->bases[i] = 
		class_desc::get(*(const_utf8*)constant_pool
		     [((const_class*)constant_pool[interface_name])->name]);
	}
    }
    int fields_count = unpack2(fp);
    fp += 2;
    
    while (--fields_count >= 0) {
	int access_flags = unpack2(fp); fp += 2;
	int name_index = unpack2(fp); fp += 2;
	int desc_index = unpack2(fp); fp += 2;
	int attr_count = unpack2(fp); fp += 2;
	field_desc* field = 
	    this_class->get_field(*(const_utf8*)constant_pool[name_index]);
	field->attr |= access_flags;
	while (--attr_count >= 0) { 
	    int attr_len = unpack4(fp+2); 
	    fp += 6 + attr_len;
	}
    }
   
    int methods_count = unpack2(fp);
    fp += 2;
    
    //
    // We need "SourceFile" attribute first, so remember position and 
    // skip methods definitions
    //
    byte* method_part = fp;
    for (i = 0; i < methods_count; i++) { 
	int attr_count = unpack2(fp+6); 
	fp += 8;
	while (--attr_count >= 0) { 
	    int attr_len = unpack4(fp+2); 
	    fp += 6 + attr_len;
	}
    }
    int attr_count = unpack2(fp); fp += 2;
    while (--attr_count >= 0) { 
	int attr_name = unpack2(fp); fp += 2; 
	int attr_len = unpack4(fp); fp += 4;
	utf_string attr(*(const_utf8*)constant_pool[attr_name]);
	if (attr == "SourceFile") { 
	    int source_name = unpack2(fp); fp += 2;
	    int file_name_idx = this_class->source_file.rindex(FILE_SEP);
	    utf_string* file_name = (const_utf8*)constant_pool[source_name];
	    if (file_name_idx >= 0) { 
		this_class->source_file.append(file_name_idx+1, *file_name);
	    } else { 
		this_class->source_file = *file_name;
	    }
	} else { 
	    fp += attr_len;
	}
    }
    fp = method_part;

    while (--methods_count >= 0) { 
	int access_flags = unpack2(fp); fp += 2;
	int name_index = unpack2(fp); fp += 2;
	int desc_index = unpack2(fp); fp += 2;
	int attr_count = unpack2(fp); fp += 2;
	
	const_utf8* mth_name = (const_utf8*)constant_pool[name_index];
	const_utf8* mth_desc = (const_utf8*)constant_pool[desc_index];

	method_desc* method = this_class->get_method(*mth_name, *mth_desc);
	method->attr |= access_flags;
	method->vars = NULL;
	
	while (--attr_count >= 0) { 
	    int attr_name = unpack2(fp); fp += 2;
	    int attr_len = unpack4(fp); fp += 4;
	    utf_string attr(*(const_utf8*)constant_pool[attr_name]);
	    if (attr == "Code") { 
		int max_stack = unpack2(fp); fp += 2;
		int max_locals = unpack2(fp); fp += 2;
		int code_length = unpack4(fp); fp += 4;
		method->code = fp;
		method->code_length = code_length;
		fp += code_length;

		method->n_vars = max_locals;
		method->vars = new var_desc[max_locals];

		method->line_table = new word[code_length];
		memset(method->line_table, 0, sizeof(word)*code_length);

		method->context = new local_context*[code_length+1];
		memset(method->context, 0, 
		       sizeof(local_context*)*(code_length+1));

		int exception_table_length = unpack2(fp); fp += 2;
		while (--exception_table_length >= 0) { 
		    int handler_pc = unpack2(fp+4);
		    new ctx_entry_point(&method->context[handler_pc]); 
		    fp += 8;
		}

		int method_attr_count = unpack2(fp); fp += 2;
		bool line_table_present = false;
		bool local_var_table_present = false;
		while (--method_attr_count >= 0) { 
		    int mth_attr_name = unpack2(fp); fp += 2;
		    int mth_attr_len = unpack4(fp); fp += 4;
		    utf_string* attr = 
			(const_utf8*)constant_pool[mth_attr_name];
		    if (*attr == "LineNumberTable") {
			int table_length = unpack2(fp); fp += 2;
			while (--table_length >= 0) { 
			    int start_pc = unpack2(fp); fp += 2;
			    int line_no = unpack2(fp); fp += 2;
			    method->line_table[start_pc] = line_no;
			}
			method->first_line = method->line_table[0];
			if (method->first_line != 0) method->first_line -= 1;
			line_table_present = true;
		    } else if (*attr == "LocalVariableTable") { 
			method->local_variable_table_present = true;
			int table_length = unpack2(fp); fp += 2;
			while (--table_length >= 0) { 
			    int start_pc = unpack2(fp); fp += 2;
			    int length = unpack2(fp); fp += 2;
			    int name  = unpack2(fp); fp += 2;
			    int desc  = unpack2(fp); fp += 2;
			    int index = unpack2(fp); fp += 2;
			    int type = (index == 0 && 
				       !(access_flags & method_desc::m_static))
				? tp_self 
				: get_type(*(const_utf8*)constant_pool[desc]);
			    new ctx_push_var(&method->context[start_pc], 
					     (const_utf8*)constant_pool[name],
					     type, index, start_pc);
			    new ctx_pop_var(&method->context[start_pc+length],
					    index);
			}
			local_var_table_present = true;
		    } else {
			fp += mth_attr_len;
		    }
		}
		if (verbose && !(access_flags & method_desc::m_native)) { 
		    char buf[MAX_MSG_LENGTH];
		    method->demangle_method_name(buf);
		    if (!line_table_present) { 
			fprintf(stderr, "No line table present "
				"for method %s\n", buf);
		    }
		    if (!local_var_table_present) { 
			fprintf(stderr, "No local variable table present "
				"for method %s\n", buf);
		    }
		} 
		method->parse_code(constant_pool);
	    } else { 
		fp += attr_len;
	    }
	}
    }
    for (i = 0; i < constant_pool_count; i++) { 
	delete constant_pool[i];
    }
    delete[] constant_pool;
    return true;
}

//
// Determine type of file and extract Java class description from the file
//

inline int stricmp(const char* p, const char* q) 
{
    do { 
	while (*p == '_') p += 1; // ignore '_'
	while (*q == '_') q += 1; // ignore '_'
	int diff = toupper(*(byte*)p) - toupper(*(byte*)q);
	if (diff != 0) {
	    return diff;
	}
	q += 1;
    } while (*p++ != 0);
    return 0;
}

void proceed_file(char* file_name, bool recursive = false)
{
#ifdef _WIN32
    HANDLE dir;
    char dir_path[MAX_PATH];
    WIN32_FIND_DATA file_data;
    if (recursive != 0) { 
	sprintf(dir_path, "%s\\*", file_name);
	if ((dir=FindFirstFile(dir_path, &file_data)) != INVALID_HANDLE_VALUE) 
	{ 
	    file_name = dir_path; 
	}
    } else { 
	if (strcmp(file_name, "..") == 0 || strcmp(file_name, ".") == 0) { 
	    proceed_file(file_name, 1);
	    return;
	}
	if ((dir=FindFirstFile(file_name, &file_data)) == INVALID_HANDLE_VALUE)
	{ 
	    fprintf(stderr, "Failed to open file '%s'\n", file_name);
	    return;
	}
    }
    if (dir != INVALID_HANDLE_VALUE) {
	do {
	    if (!recursive || *file_data.cFileName != '.') { 
		char file_path[MAX_PATH];
		char* file_dir = strrchr(file_name, '\\');
		char* file_name_with_path;
		if (file_dir != NULL) { 
		    int dir_len = file_dir - file_name + 1;
		    memcpy(file_path, file_name, dir_len);
		    strcpy(file_path+dir_len, file_data.cFileName);
		    file_name_with_path = file_path;
		} else { 
		    file_name_with_path = file_data.cFileName;
		}
		proceed_file(file_name_with_path, recursive+1);
	    } 
	} while (FindNextFile(dir, &file_data));
	CloseHandle(dir);
	return;
    }
#else
    DIR* dir = opendir(file_name);
    if (dir != NULL) { 
	struct dirent* entry;
	while ((entry = readdir(dir)) != NULL) { 
	    if (*entry->d_name != '.') { 
		char full_name[MAX_PATH];
		sprintf(full_name, "%s/%s", file_name, entry->d_name);
		proceed_file(full_name, 2);
	    }
	} 
	closedir(dir);
	return;
    }
#endif
    if (recursive >= 2) { 
	int len = strlen(file_name); 
	if (len < 6 || stricmp(file_name + len - 6, ".class") != 0) {
	    return;
	}
    }
		
    FILE* f = fopen(file_name, "rb");
    if (f == NULL) { 
	fprintf(stderr, "Failed to open file '%s'\n", file_name);
	return;
    }
    char* suf = file_name + strlen(file_name) - 4;
    if (suf > file_name && (stricmp(suf,".zip")==0 || stricmp(suf,".jar")==0)){
	// extract files from ZIP archive
	byte hdr[ECREC_SIZE+4];
	if (fseek(f, 0, SEEK_END) != 0
	    || ftell(f) < ECREC_SIZE+4 
	    || fseek(f, -(ECREC_SIZE+4), SEEK_CUR) != 0
	    || fread(hdr, ECREC_SIZE+4, 1, f) != 1) 
        { 
	    fprintf(stderr, "Bad format of ZIP file '%s'\n", file_name);
	    return;
	}
	int count = unpack2_le(&hdr[TOTAL_ENTRIES_CENTRAL_DIR]);
	int dir_size = unpack4_le(&hdr[SIZE_CENTRAL_DIRECTORY]);
	byte* directory = new byte[dir_size];
	if (fseek(f, -(dir_size+ECREC_SIZE+4), SEEK_CUR) != 0
	    || fread(directory, dir_size, 1, f) != 1)
	{
	    fprintf(stderr, "Bad format of ZIP file '%s'\n", file_name);
	    delete[] directory;
	    return;
	}
	byte* dp = directory;

	while (--count >= 0) {
	    int uncompressed_size = unpack4_le(&dp[4+C_UNCOMPRESSED_SIZE]);
	    int filename_length = unpack2_le(&dp[4+C_FILENAME_LENGTH]);
	    int cextra_length = unpack2_le(&dp[4+C_EXTRA_FIELD_LENGTH]);

	    if ((dp-directory)+filename_length+CREC_SIZE+4 > dir_size) { 
		fprintf(stderr, "Bad format of ZIP file '%s'\n", file_name);
		break;
	    }
		
	    byte local_rec_buffer[LREC_SIZE+4];
	    int local_header_offset = 
		unpack4_le(&dp[4+C_RELATIVE_OFFSET_LOCAL_HEADER]);

	    if (fseek(f, local_header_offset, SEEK_SET) != 0
		|| fread(local_rec_buffer, sizeof local_rec_buffer, 1, f) != 1
		|| memcmp(&local_rec_buffer[1], LOCAL_HDR_SIG, 3) != 0)
	    {
		fprintf(stderr, "Bad format of ZIP file '%s'\n", file_name);
		break;
	    }
		
	    int file_start = local_header_offset + (LREC_SIZE+4) +
	        unpack2_le(&local_rec_buffer[4+L_FILENAME_LENGTH]) +
		unpack2_le(&local_rec_buffer[4+L_EXTRA_FIELD_LENGTH]);

	    int filename_offset = CREC_SIZE+4;

	    if (uncompressed_size != 0) { 
		byte* buffer = new byte[uncompressed_size];
		if (fseek(f, file_start, SEEK_SET) != 0 
		    || fread(buffer, uncompressed_size, 1, f) != 1) 
		{ 
		    fprintf(stderr, "Failed to read ZIP file '%s'\n", 
			    file_name);
		    return;
		} else { 
		    if (verbose) { 
			fprintf(stderr, "Verify file '%.*s'\n", 
				filename_length, dp + filename_offset); 
		    }
		    if (!parse_class_file(buffer)) { 
			fprintf(stderr, "File '%.*s' isn't correct Java class "
				"file\n", filename_length, dp+filename_offset);
		    }
		}
		delete[] buffer;
	    }
	    dp += filename_offset + filename_length + cextra_length; 
	}
	delete[] directory;
    } else { 
	fseek(f, 0, SEEK_END);
	size_t file_size = ftell(f);
	fseek(f, 0, SEEK_SET);
	byte* buffer = new byte[file_size];
	if (fread(buffer, file_size, 1, f) != 1) { 
	    fprintf(stderr, "Failed to read file '%s'\n", file_name);
	} else { 
	    if (verbose) { 
		fprintf(stderr, "Verify file '%s'\n", file_name); 
	    }
	    if (!parse_class_file(buffer)) { 
		fprintf(stderr, "File '%s' isn't correct Java class file\n", 
			file_name);
	    }
	}
	delete[] buffer;
    }
    fclose(f);
}
    
//
// Main function: parse command line 
//


msg_select_category_option msg_category_option[] = {
    {cat_synchronization, "synchronization",
     "detect synchronizational problems"},
    {cat_deadlock, "deadlock", 
     "possible deadlock detection"},
    {cat_race_condition, "race_condition", 
     "possible race condition detection"},
    {cat_wait_nosync, "wait_nosync", 
     "wait or notify is called from non-synchroize method"},
    
    {cat_inheritance, "inheritance",
     "detect problems with class/interface inheritance"},
    {cat_super_finalize, "super_finalize", 
     "super.finalize() is not called from finalize method"},
    {cat_not_overridden, "not_overridden",
     "methods with the same names and diffent profiles"},
    {cat_field_redefined, "field_redefined",
     "instance or static variable is redifined in derived class"},
    {cat_shadow_local, "shadow_local",
     "local variable shadow one in exterior scope"},
    
    {cat_data_flow, "data_flow",
     "perform data flow analysis to detect suspicious operations"},
    {cat_null_reference, "null_reference",
     "detect access to variables with possible NULL value"},
    {cat_zero_operand, "zero_operand",
     "one of operands of binary integer operation is zero"},
    {cat_zero_result, "zero_result",
     "result of operation is always zero"},
    {cat_redundant, "redundant",
     "operations always produce the same result"},
    {cat_overflow, "overflow", 
     "detect incorrect handling of operation overflow"},
    {cat_incomp_case, "incomp_case",
     "switch case label can't be produced by switch expression"},
    {cat_short_char_cmp, "short_char_cmp",
     "expresion of char type is compared with one of short type"},
    {cat_string_cmp, "string_cmp", 
     "two strings are compared as object references"},
    {cat_weak_cmp, "weak_cmp", 
     "using of inequality comparison where equality can be checked"},
    {cat_domain, "domain",
     "operands doesn't belong to the domain of operator"},
    {cat_truncation, "truncation",
     "data can be lost as a result of type conversion"},
    {cat_bounds, "bounds",
     "array index or length is out of range"},

    {cat_done, "done", 
     "notification about verification completion"},

    {cat_all, "all",
     "produce messages of all categories"}
};

void usage()
{
    fprintf(stderr, "\
Usage: jlint {option|java_class_file}\n\
Options:\n\
  -help : print this text\n\
  -source <source_path> : path to directory with .java files\n\
  -history <file_name> : use history file to avoid repeated messages\n\
  -max_shown_paths <number> : max. shown paths between two sync. methods\n\
  (+|-)verbose : output more/less information about program activity\n\
  (+|-)message_category : select categories of messages to be reported\n\
  (+|-)message_code : enable/disable concrete message\n\
Message categories:\n");
    message_category group = msg_category_option[0].msg_cat;
    for (unsigned i = 0; i < items(msg_category_option); i++) { 
	message_category msg_cat = msg_category_option[i].msg_cat;
	if ((msg_cat & ~group) != 0) { 
	    group = msg_cat;
	    fprintf(stderr, "\n");
	}
	fprintf(stderr, "  %s : %s\n", 
		msg_category_option[i].cat_name, 
		msg_category_option[i].cat_desc);
    }
    if (verbose) { 
	fprintf(stderr, "\nMessages: (category:code: \"text\")\n");
	for (int i = 0; i < msg_last; i++) { 
	    for (unsigned j = 0; j < items(msg_category_option); j++) { 
		if (msg_table[i].category == msg_category_option[j].msg_cat) {
		    fprintf(stderr, "  %s:%s: \"%s\"\n", 
			    msg_category_option[j].cat_name,
			    msg_table[i].name, msg_table[i].format);
		    break;
		}
	    }
	}
    }
}

int main(int argc, char* argv[])
{
    int i, j;   

    if (argc == 1) { 
	usage();
	return EXIT_FAILURE;
    }

    for (i = 1; i < argc; i++) { 
	if (*argv[i] == '-' || *argv[i] == '+') { 
	    bool enabled = *argv[i] == '+';
	    char* option = &argv[i][1];
	    int n_cat = items(msg_category_option);
	    msg_select_category_option* msg = msg_category_option;  

	    if (stricmp(option, "source") == 0 && i+1 < argc) {
		source_file_path = argv[++i];
		source_file_path_len = strlen(source_file_path);
		if (source_file_path[source_file_path_len] == FILE_SEP) {
		    source_file_path_len -= 1;
		}
		source_path_redefined = true;
		continue;
	    } 
	    if (stricmp(option, "history") == 0 && i+1 < argc) {
		history = fopen(argv[++i], "a+");
		if (history != NULL) { 
		    char his_buf[MAX_MSG_LENGTH];
		    fseek(history, 0, SEEK_SET);
		    while (fgets(his_buf, sizeof his_buf, history)) { 
			int len = strlen(his_buf); 
			if (len > 0) { 
			    his_buf[len-1] = '\0';
			    message_node::add_to_hash(his_buf);
			}
		    }
		    fseek(history, 0, SEEK_END);
		} else { 
		    fprintf(stderr, "Failed to open history file '%s'\n",
			    argv[i]);
		}
		continue;
	    }
	    if (stricmp(option, "max_shown_paths") == 0 && i+1 < argc) {
		if (sscanf(argv[++i], "%d", &max_shown_paths) != 1) { 
		    fprintf(stderr, "Bad parameter value for -max_shown_paths "
			    "option: '%s'\n", argv[i]);
		}
		continue;
	    } 
	    if (stricmp(option, "verbose") == 0) { 
		verbose = enabled;
		if (verbose) { 
		    fprintf(stderr, 
			    "Jlint - program correctness verifier for Java"
			    "        version %3.2f ("__DATE__")\n", VERSION);  
		}
		continue;
	    }
	    if (stricmp(option, "help") == 0) { 
		usage();
		return EXIT_SUCCESS;
	    }
	    for (j = 0; j < n_cat; j++) { 
		if (stricmp(msg[j].cat_name, option) == 0) { 
		    if (enabled) { 
			reported_message_mask |= msg[j].msg_cat;
		    } else { 
			reported_message_mask &= ~msg[j].msg_cat;
		    }
		    break;
		}
	    }
	    if (j == n_cat) { 
		for (j = 0; j < msg_last; j++) { 
		    if (stricmp(msg_table[j].name, option) == 0) { 
			msg_table[j].enabled = enabled;
			break;
		    }
		}
		if (j == msg_last) { 
		    fprintf(stderr, "Unrecognized option %s\n", argv[i]);
		    usage();
		}
		return EXIT_FAILURE;
	    }		 
	} else { 
	    char* file_name = argv[i];
	    if (!source_path_redefined) { 
		source_file_path = file_name;
		char* dirend = strrchr(source_file_path, FILE_SEP);
		source_file_path_len = (dirend != NULL)
		    ? dirend - source_file_path : 0; 
	    }
	    proceed_file(file_name);
	}
    }
    class_desc::global_analysis();
    message_at(msg_done, utf_string(""), 0, (void*)n_messages);
    return EXIT_SUCCESS;
}	


