//-< JLINT.H >-------------------------------------------------------*--------*
// Jlint                      Version 1.09       (c) 1998  GARRET    *     ?  *
// (Java Lint)                                                       *   /\|  *
//                                                                   *  /  \  *
//                          Created:     28-Mar-98    K.A. Knizhnik  * / [] \ *
//                          Last update: 20-Aug-98    K.A. Knizhnik  * GARRET *
//-------------------------------------------------------------------*--------*
// Java verifier 
//-------------------------------------------------------------------*--------*

#ifndef __JLINT_H__
#define __JLINT_H__

#define VERSION 1.09

typedef int      int4;
typedef unsigned nat4;

#if defined(_WIN32)
#define INT8_DEFINED 1
typedef __int64 int8;
typedef unsigned __int64 nat8;
#else
#if defined(__osf__ )
#define INT8_DEFINED 1
typedef   signed long int8;
typedef unsigned long nat8;
#else
#if defined(__GNUC__)
#define INT8_DEFINED 1
typedef long long          int8;
typedef unsigned long long nat8;
#endif
#endif
#endif

#define bool  int
#define true  1
#define false 0

#define nobreak 

typedef unsigned char  byte;
typedef unsigned short word;

enum vbm_instruction_code { 
#define JAVA_INSN(code, mnem, len) mnem,
#include "jlint.d"
last_insn
};
    
#define   items(array) (sizeof(array)/sizeof*(array))

inline int unpack2(byte* s) { 
    return (s[0] << 8) + s[1]; 
}

inline int unpack4(byte* s) { 
    return (((((s[0] << 8) + s[1]) << 8) + s[2]) << 8) + s[3];
} 

inline int unpack2_le(byte* s) { 
    return (s[1] << 8) + s[0]; 
}

inline int unpack4_le(byte* s) { 
    return (((((s[3] << 8) + s[2]) << 8) + s[1]) << 8) + s[0];
} 

enum type_tag { 
    tp_bool,
    tp_byte,
    tp_char,
    tp_short,
    tp_int,
    tp_long,
    tp_float,
    tp_double,
    tp_void, 
    tp_self,
    tp_string,
    tp_object
};

#define IS_INT_TYPE(tp) (tp <= tp_int)
#define IS_ARRAY_TYPE(tp) ((tp & ~0xFF) != 0)

struct int_type_range { 
    int4 min;
    int4 max;
};


enum message_category { 
    cat_deadlock        = 0x00000001, 
    cat_race_condition  = 0x00000002,
    cat_wait_nosync     = 0x00000004,
    cat_synchronization = 0x0000000F,

    cat_super_finalize  = 0x00000010,
    cat_not_overridden  = 0x00000020,
    cat_field_redefined = 0x00000040,
    cat_shadow_local    = 0x00000080,
    cat_inheritance     = 0x000000F0,

    cat_zero_operand    = 0x00000100,
    cat_zero_result     = 0x00000200, 
    cat_redundant       = 0x00000400,
    cat_overflow        = 0x00000800, 
    cat_incomp_case     = 0x00001000,
    cat_short_char_cmp  = 0x00002000,
    cat_string_cmp      = 0x00004000,
    cat_weak_cmp        = 0x00008000,
    cat_domain          = 0x00010000,
    cat_null_reference  = 0x00020000,
    cat_truncation      = 0x00040000,
    cat_bounds          = 0x00080000,
    cat_data_flow       = 0x000FFF00,

    cat_done            = 0x10000000,

    cat_all             = 0xFFFFFFFF
};

struct message_descriptor {
    message_category category;
    const char*      format;
    const char*      name;
    bool             position_dependent;
    bool             enabled;
};

class message_node {
    static message_node* hash_table[];
  public:
    message_node* next;
    char*         text;

    static bool find(char* msg);
    static void add_to_hash(char* msg);

    message_node(char* msg) { 
	text = strdup(msg);
	next = NULL;
    }
    ~message_node() { delete[] text; }
};



enum message_code { 
#define MSG(category, code, pos, text) msg_##code,
#include "jlint.msg"
msg_last
};

#define MSG_LOCATION_PREFIX "%0s:%1d: " // Emacs style: "file:line_number: "

#define MAX_MSG_LENGTH      1024
#define MAX_MSG_PARAMETERS  16

struct msg_select_category_option { 
    message_category msg_cat;
    const char*      cat_name;
    const char*      cat_desc;
};

extern unsigned string_hash_function(byte* p);

class utf_string {
  protected:
    int   len;
    byte* data;

  public:
    bool operator == (utf_string const& str) const { 
	return len == str.len && memcmp(data, str.data, len) == 0; 
    }
    bool operator != (utf_string const& str) const { 
	return len != str.len || memcmp(data, str.data, len) != 0; 
    }
    bool operator == (const char* str) const { 
	return strcmp((char*)data, str) == 0; 
    }
    bool operator != (const char* str) const { 
	return strcmp((char*)data, str) != 0; 
    }
    unsigned hash() const { 
	return string_hash_function(data);
    }
    int  first_char() const { return data[0]; }

    void operator = (utf_string const& str) { 
	len = str.len;
	data = str.data;
    }

    utf_string operator + (const char* suffix) const { 
	utf_string str;
	str.len = len + strlen(suffix);
	str.data = new byte[str.len+1];
	memcpy(str.data, data, len);
	memcpy(str.data+len, suffix, str.len - len);
	str.data[str.len] = 0; // zero terminated string
	return str;
    }

    void append(int offs, utf_string const& suffix) { 
	assert(offs <= len);
	len = offs + suffix.len;
	byte* new_data = new byte[len+1];
	memcpy(new_data, data, offs);
	memcpy(new_data+offs, suffix.data, suffix.len);
	new_data[len] = 0; // zero terminated string
	delete[] data;
	data = new_data;
    }

    int rindex(byte ch) const { 
	byte* p = (byte*)strrchr((char*)data, ch);
	return p ? p - data : -1;
    }

    void set_size(int size) { len = size; }

    char* as_asciz() const { return (char*)data; }

    utf_string(int length, byte* str) { 
	len = length;
	data = new byte[length+1];
	memcpy(data, str, length);
	data[length] = 0;
    }
    utf_string(const char* str) { 
	len = strlen(str);
	data = (byte*)str;
    }

    utf_string(utf_string const& str) { 
	len = str.len;
	data = str.data;
    }
    utf_string() { len = 0; data = NULL; }
};

    
class method_desc;
class field_desc;
class class_desc;
class constant;

class callee_desc {
  public:
    class_desc*    self_class;
    method_desc*   method;
    callee_desc*   next;
    void*          backtrace;
    int            line;
    int            attr;
    enum { 
	i_self          = 0x01, // invoke method of self class
	i_synchronized  = 0x02, // method os invoked from synchronized(){} body
	i_wait_deadlock = 0x04  // invocation can cause deadlock in wait()
    };
    

    void message(int msg_code, ...); 
	
    callee_desc(class_desc* cls, method_desc* mth, callee_desc* chain, 
	       int lineno, int call_attr) 
    { 
        self_class = cls;  
	method = mth;
	next = chain;
	line = lineno;
	attr = call_attr;
	backtrace = NULL; 
    }
};

class access_desc { 
  public: 
    access_desc*   next;
    class_desc*    self_class;
    field_desc*    field;
    int            line;
    int            attr;
    enum { 
	a_self = 0x01, // access to the component of the same class
	a_new  = 0x02  // field of newly created object is accessed
    };

    void message(int msg_code, ...); 

    access_desc(field_desc* desc, class_desc* cls, 
		int lineno, access_desc* chain)
    { 
	field = desc;
	next = chain;
	self_class = cls;
	line = lineno;
	attr = 0;
    }	
};

class graph_vertex;

class graph_edge { 
  public:
    graph_edge*   next;
    callee_desc*  invocation;
    method_desc*  caller;
    graph_vertex* vertex;
    int           mask;

    void message(int loop_id);

    graph_edge(graph_vertex* node, method_desc* method, callee_desc* call) { 
	invocation = call;
	caller = method;
	vertex = node;
	mask = 0;
    }
};

class graph_vertex { 
  public:
    graph_edge*   edges;
    graph_vertex* next;
    class_desc*   cls;
    int           visited;
    int           marker;
    int           n_loops;
    enum { 
	flag_vertex_on_path    = 0x80000000,
	flag_vertex_not_marked = 0x7fffffff
    };
	


    static int    n_vertexes;

    static graph_vertex* graph;
    
    static void verify();

    void attach(graph_edge* edge) { 
	edge->next = edges;
	edges = edge;
    }

    graph_vertex(class_desc* vertex_class) { 
	cls = vertex_class;
	visited = 0;
	marker = flag_vertex_not_marked;
	next = graph;
	graph = this;
	edges = NULL;
	n_vertexes += 1;
    }
};

class var_desc { 
  public:
    utf_string     name;
    int            type;
    int            start_pc;
    
    int4           min;
    int4           max;
    int4           mask;

    enum object_var_state {
	vs_unknown  = 0x01, // state of variable is unknown
	vs_not_null = 0x03, // variable was checked for null
	vs_new      = 0x04  // variable points to object created by new
    };
};

class component_desc { 
  public:
    utf_string     name;
    class_desc*    cls;
    class_desc*    accessor;
    
    component_desc(utf_string const& component_name, class_desc* component_cls)
    : name(component_name), cls(component_cls), accessor(NULL) {}
};
	

class field_desc : public component_desc { 
  public:
    field_desc*    next;
    int            attr;
    enum { 
	f_static     = 0x0008, 
	f_final      = 0x0010,
	f_volatile   = 0x0040, 
	
	f_used       = 0x10000,
        f_serialized = 0x20000 // field is accessed only from methods 
	                       // of related classes

    };

    field_desc(utf_string const& field_name, class_desc* owner, 
	       field_desc* chain) 
    : component_desc(field_name, owner)
    {
	next = chain; 
	attr = f_serialized;
    }
};

struct vbm_operand { 
    int  type;  // type of expression/variable before it was pushed in stack
    int4 max;   // maximal value of operand
    int4 min;   // minimal value of operand
    int4 mask;  // mask of possible set bits and zero value indicator for 
                // object types
    int  index; // index of local veriable, which value was loaded in stack
};


class local_context { 
  public:
    enum context_cmd { 
	cmd_pop_var,    // start of local variable scope
	cmd_push_var,   // end of local variable scope
	cmd_merge_ctx,  // forward jump label
	cmd_reset_ctx,  // backward jump label
	cmd_enter_ctx,  // entry point
	cmd_case_ctx,   // switch case label
	cmd_update_ctx, // backward jump
	cmd_save_ctx    // forward jump
    } cmd;

    local_context* next;

    virtual vbm_operand* transfer(method_desc* method, vbm_operand* sp, 
				  byte cop, byte& prev_cop) = 0;

    local_context(context_cmd ctx_cmd, local_context** chain) { 
	cmd = ctx_cmd;
	while (*chain != NULL && (*chain)->cmd < ctx_cmd) { 
	    chain = &(*chain)->next;
	}
	next = *chain;
	*chain = this;
    }
};

class ctx_pop_var : public local_context { 
  public:
    int var_index;

    ctx_pop_var(local_context** chain, int index) 
    : local_context(cmd_pop_var, chain), var_index(index) {}

    virtual vbm_operand* transfer(method_desc* method, vbm_operand* sp, 
				  byte cop, byte& prev_cop);
};


class ctx_push_var : public local_context { 
  public:
    utf_string* var_name;
    int         var_type;
    int         var_index;
    int         var_start_pc;
    
    ctx_push_var(local_context** chain,
		 utf_string* name, int type, int index, int start_pc)
    : local_context(cmd_push_var, chain) {
	var_name = name; 
	var_type = type;
	var_index = index;
	var_start_pc = start_pc;
    }
	

    virtual vbm_operand* transfer(method_desc* method, vbm_operand* sp, 
				  byte cop, byte& prev_cop);
};
    

class ctx_split : public local_context { 
  public: 
    var_desc*    vars; 
    vbm_operand* stack_pointer;
    vbm_operand  stack_top[2];
    int          switch_var_index;
    int          n_branches;
    
    enum jmp_type { jmp_forward, jmp_backward };

    ctx_split(local_context** chain, jmp_type type = jmp_forward) 
    : local_context(type == jmp_forward ? cmd_save_ctx : cmd_update_ctx, chain)
    {
	n_branches = 1;
    }
    
    virtual vbm_operand* transfer(method_desc* method, vbm_operand* sp, 
				  byte cop, byte& prev_cop);
};
    
    
class ctx_merge : public local_context { 
  public:
    ctx_split* come_from;
    int        case_value;
    
    ctx_merge(local_context** chain, ctx_split* come_from_ctx) 
    : local_context(cmd_merge_ctx, chain) 
    { 
	come_from = come_from_ctx;
    }

    ctx_merge(local_context** chain, ctx_split* come_from_ctx, int value) 
    : local_context(cmd_case_ctx, chain) 
    {
	come_from = come_from_ctx;
	case_value = value;
    }
  
    virtual vbm_operand* transfer(method_desc* method, vbm_operand* sp, 
				  byte cop, byte& prev_cop);
};


class ctx_entry_point : public local_context { 
  public:
    ctx_entry_point(local_context** chain)
    : local_context(cmd_enter_ctx, chain) {}
    
    virtual vbm_operand* transfer(method_desc* method, 
				  vbm_operand* sp, byte cop, byte& prev_cop);
};

class ctx_reset : public local_context { 
  public:
    int* var_store_count;
    
    ctx_reset(local_context** chain, int* counts, int n_vars) 
    : local_context(cmd_reset_ctx, chain) 
    { 
	var_store_count = new int[n_vars];
	memcpy(var_store_count, counts, n_vars*sizeof(int));
    }
    
    virtual vbm_operand* transfer(method_desc* method, vbm_operand* sp, 
				  byte cop, byte& prev_cop);
};

class overridden_method { 
  public:
    overridden_method* next;
    method_desc*       method;

    overridden_method(method_desc* mth, overridden_method* chain) { 
	method = mth;
	next = chain;
    }
};

class method_desc : public component_desc { 
  public:
    utf_string     desc;
    method_desc*   next;

    int attr;
    enum { 
	m_static       = 0x0008,
	m_final        = 0x0010,
	m_synchronized = 0x0020,
	m_native       = 0x0100,
	m_abstract     = 0x0400,

	m_wait         = 0x010000, // invoke wait()
	m_serialized   = 0x020000, // method is called only from methods 
	                           // of related classes
	m_concurrent   = 0x040000, // Method is either run of Runanble protcol
	                           // or synchronized or called from them.
	m_visited      = 0x080000, // Used while recursive traversal of methods
	m_deadlock_free= 0x100000, // Doesn't call any synchronized methods
	m_override     = 0x200000  // Override method of base class
    };

    int            n_vars;
    var_desc*      vars;
    int*           var_store_count;

    bool           local_variable_table_present;

    callee_desc*   callees;
    access_desc*   accessors;
    
    graph_vertex*  vertex;

    //
    // Chain of methods from derived classes, overriding this method
    //
    overridden_method* overridden; 

    //
    // 1 bit in position 'i' of 'null_parameter_mask' means that NULL is 
    // passed as the value of parameter 'i'
    //
    unsigned       null_parameter_mask; 
    //
    // 1 bit in position 'i' of 'unchecked_use_mask' means that formal
    // parameter 'i' is used without check for NULL
    //
    unsigned       unchecked_use_mask;    

    int            code_length;
    byte*          code;

    local_context**context;

    int            first_line; // line corresponing to first method instruction
    int            wait_line;  // line of last wait() invocation in the method
    word*          line_table;

    int  demangle_method_name(char* buf);

    void calculate_attributes();

    void find_access_dependencies();

    void build_concurrent_closure();
    void add_to_concurrent_closure(callee_desc* caller, 
				   int call_attr, int depth);

    void build_call_graph();
    bool build_call_graph(method_desc* caller, callee_desc* callee,
			  int call_attr);

    int  print_call_path_to(callee_desc* target, int loop_id, int path_id, 
			    int call_attr = 0, callee_desc* prev = NULL);

    void check_synchronization();
    void check_invocations();

    bool is_special_method() { return name.first_char() == '<'; }

    int  get_line_number(int pc);
    void message(int msg_code, int pc, ...);

    void check_variable_for_null(int pc, vbm_operand* sp); 
    void check_array_index(int pc, vbm_operand* sp); 

    void basic_blocks_analysis();

    void parse_code(constant** constant_pool);

    method_desc(utf_string const& mth_name, utf_string const& mth_desc, 
		class_desc* cls_desc, method_desc* chain) 
    : component_desc(mth_name, cls_desc), desc(mth_desc)
    { 
	callees = NULL;
	accessors = NULL;
	attr = m_serialized;
	next = chain;
	first_line = 0;
	overridden = NULL;
	local_variable_table_present = false;
	null_parameter_mask = unchecked_use_mask = 0;
    }
};

class class_desc { 
  public:
    utf_string     name;
    utf_string     source_file;
    class_desc*    next;
    class_desc*    collision_chain; 

    method_desc*   methods;

    int            attr; 
    enum class_attrs { 
	cl_interface = 0x00200,

        cl_system    = 0x10000	    
    };

    int            n_bases;
    class_desc**   bases;

    field_desc*    fields;

    graph_vertex*  class_vertex;
    graph_vertex*  metaclass_vertex;

    static class_desc* get(utf_string const& str);

    method_desc* get_method(utf_string const& mth_name, 
			    utf_string const& mth_desc);

    field_desc* get_field(utf_string const& field_name);

    static class_desc* hash_table[];
    static int         n_classes;
    static class_desc* chain;

    bool isa(const char* cls_name);
    bool isa(class_desc* cls);
    bool implements(const char* interface_name);
    bool in_relationship_with(class_desc* cls);

    void verify();
    void calculate_attributes();
    void build_class_info();
    void build_call_graph();
    void build_concurrent_closure();
    void check_inheritance(class_desc* derived);

    static void global_analysis();

    class_desc(utf_string const& str);
};


enum const_types { 
    c_none,
    c_utf8,
    c_reserver,
    c_integer,
    c_float,
    c_long,
    c_double, 
    c_class,
    c_string,
    c_field_ref,
    c_method_ref,
    c_interface_method_ref,
    c_name_and_type
};

class constant { 
  public:
    byte tag;
    virtual int length() = 0;
    virtual type_tag type() { return tp_object; }
    constant(byte* p) { tag = *p; }
};


class const_utf8 : public constant, public utf_string { 
  public:
    const_utf8(byte* p) : constant(p), utf_string(unpack2(p+1), p+3) {}
    int length() { return 3 + len; }
};

class const_int : public constant {
  public:
    int value;
    const_int(byte* p) : constant(p) {
	value = unpack4(p+1);
    }
    int length() { return 5; }
    type_tag type() { return tp_int; }
};

class const_float : public constant {
  public:
    const_float(byte* p) : constant(p) {}
    int length() { return 5; }
    type_tag type() { return tp_float; }
};

class const_long : public constant {
  public:
    struct { 
	int4 high;
	int4 low;
    } value;
    const_long(byte* p) : constant(p) {
	value.high = unpack4(p+1);
	value.low  = unpack4(p+5);
    }
    int length() { return 9; }
    type_tag type() { return tp_long; }
};

class const_double : public constant {
  public:
    const_double(byte* p) : constant(p) {}
    int length() { return 9; }
    type_tag type() { return tp_double; }
};

class const_class : public constant {
   public:   
    int name;
    const_class(byte* p) : constant(p) {
	name = unpack2(p+1);
    }
    int length() { return 3; }
};

class const_string : public constant {
   public:   
    int str;
    const_string(byte* p) : constant(p) {
	str = unpack2(p+1);
    }
    int length() { return 3; }
    type_tag type() { return tp_string; }
};

class const_ref : public constant {
   public:   
    int cls;
    int name_and_type;
    const_ref(byte* p) : constant(p) {
	cls = unpack2(p+1);
	name_and_type = unpack2(p+3);
    }
    int length() { return 5; }
};


class const_name_and_type : public constant {
   public:   
    int name;
    int desc;
    const_name_and_type(byte* p) : constant(p) {
	name = unpack2(p+1);
	desc = unpack2(p+3);
    }
    int length() { return 5; }
};

//
// Constants for extracting zip file
//

#define LOCAL_HDR_SIG     "\113\003\004"   /*  bytes, sans "P" (so unzip */
#define LREC_SIZE     26    /* lengths of local file headers, central */
#define CREC_SIZE     42    /*  directory headers, and the end-of-    */
#define ECREC_SIZE    18    /*  central-dir record, respectively      */
#define TOTAL_ENTRIES_CENTRAL_DIR  10
#define SIZE_CENTRAL_DIRECTORY     12
#define C_UNCOMPRESSED_SIZE        20
#define C_FILENAME_LENGTH          24
#define C_EXTRA_FIELD_LENGTH       26
#define C_RELATIVE_OFFSET_LOCAL_HEADER    38
#define L_FILENAME_LENGTH                 22
#define L_EXTRA_FIELD_LENGTH              24

#endif


