/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  basic.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_BASIC_H
#define LEDA_BASIC_H

#include <stdio.h>
#include <stdlib.h>


//------------------------------------------------------------------------------
// compiler/system dependent definitions and includes
//------------------------------------------------------------------------------

#if defined(_SGI_) || defined(__sgi)
/* random() declared in math.h */
#include <math.h>
#endif


#if defined(__GNUG__)
/* no random() function in libg++ (since version 2.5) */
#define __NO_RANDOM__
#if __GNUC_MINOR__ > 5
#define __BUILTIN_BOOL__
#endif
#endif


#if defined(__ZTC__)
#define __MSDOS__
#define __NO_RANDOM__
#define MAXINT          (int(0x7FFFFFFF))
#define MAXFLOAT	(float(3.37E+38))
#define MAXDOUBLE       (double(1.797693E+308))
#include <iostream.hpp>
#else
#include <values.h>
#include <iostream.h>
#endif


#if defined(__TURBOC__)
#define __NO_RANDOM__
#define FRIEND_INLINE friend
#else
#define _CLASSTYPE
#define FRIEND_INLINE friend inline
#endif



//------------------------------------------------------------------------------
// Global Types
//------------------------------------------------------------------------------

typedef void* GenPtr;    // generic pointer type

typedef int  (*CMP_PTR)(GenPtr&,GenPtr&);
typedef void (*APP_PTR)(GenPtr&);
typedef int  (*ORD_PTR)(GenPtr&);



//------------------------------------------------------------------------------
// Error Handling
//------------------------------------------------------------------------------

typedef void (*PEH)(int,const char*);   // Pointer to Error Handler

extern PEH  p_error_handler;
extern PEH  set_error_handler(PEH);
extern void default_error_handler(int,const char*);
inline void error_handler(int i, const char* s)  { p_error_handler(i,s); }


//------------------------------------------------------------------------------
// Templates
//------------------------------------------------------------------------------

#include <LEDA/template.h>


//------------------------------------------------------------------------------
// LEDA INIT
//------------------------------------------------------------------------------


struct LEDA {

 LEDA();
~LEDA();

char* init_list;
static const char* version_string;
static int loop_dummy;
};

extern LEDA L_E_D_A;


//------------------------------------------------------------------------------
// Memory Management
//------------------------------------------------------------------------------

struct  memory_elem_type { memory_elem_type* next; };
typedef memory_elem_type* memory_elem_ptr;

extern memory_elem_ptr memory_free_list[];

extern memory_elem_ptr memory_allocate_block(int);
extern memory_elem_ptr allocate_bytes(int);
extern memory_elem_ptr allocate_bytes_with_check(int);
extern memory_elem_ptr allocate_words(int);

extern void deallocate_bytes(void*,int);
extern void deallocate_bytes_with_check(void*,int);
extern void deallocate_words(void*,int);
extern void memory_clear();
extern void memory_kill();
extern void print_statistics();

extern int used_memory();

inline void deallocate_list(void* head,void* tail, int bytes)
{ memory_elem_ptr(tail)->next = memory_free_list[bytes];
  memory_free_list[bytes] = memory_elem_ptr(head);
 }

#define OPERATOR_NEW(bytes)\
void* operator new(size_t)\
{ memory_elem_ptr* q = memory_free_list+bytes;\
  if (*q==0) *q = memory_allocate_block(bytes);\
  memory_elem_ptr p = *q;\
  *q = p->next;\
  return p;\
 }

#define OPERATOR_DEL(bytes)\
void  operator delete(void* p)\
{ memory_elem_ptr* q = memory_free_list+bytes;\
  memory_elem_ptr(p)->next = *q;\
  *q = memory_elem_ptr(p);\
 }

#define OPERATOR_NEW_WITH_CHECK(bytes)\
void* operator new(size_t) { return allocate_bytes_with_check(bytes); }

#define OPERATOR_DEL_WITH_CHECK(bytes)\
void  operator delete(void* p) { deallocate_bytes_with_check(p,bytes); }


#define LEDA_MEMORY(type)\
OPERATOR_NEW(sizeof(type))\
OPERATOR_DEL(sizeof(type))

#define LEDA_MEMORY_WITH_CHECK(type)\
OPERATOR_NEW_WITH_CHECK(sizeof(type))\
OPERATOR_DEL_WITH_CHECK(sizeof(type))


//------------------------------------------------------------------------------
// handle_base/rep: base classes for handle types string, point, segment,...
//------------------------------------------------------------------------------


class handle_rep  {

friend class handle_base;
  
protected:

   int  count;
   
         handle_rep()  { count = 1; }
virtual ~handle_rep()  {}

LEDA_MEMORY(handle_rep);
  
};


class handle_base {

protected:

handle_rep* PTR;

public:

 handle_base()                     {}
 handle_base(const handle_base& x) { PTR = x.PTR;  PTR->count++; }

~handle_base()                     {}


handle_base& operator=(const handle_base& x)
{ x.PTR->count++;
  if (--PTR->count == 0)  delete PTR;
  PTR = x.PTR;
  return *this;
 }

public:

void clear()        { if (--(PTR->count)==0) delete PTR; }
GenPtr copy() const { PTR->count++; return PTR; }


FRIEND_INLINE int    compare(const handle_base&, const handle_base&);
FRIEND_INLINE void   Print(const handle_base&, ostream& = cout);
FRIEND_INLINE void   Read(handle_base&, istream& = cin);
FRIEND_INLINE void   Init(handle_base&);
FRIEND_INLINE void   Clear(handle_base&);
FRIEND_INLINE GenPtr Copy(handle_base&);
FRIEND_INLINE GenPtr Convert(const handle_base&);

};

inline int compare(const handle_base&, const handle_base&)
{ error_handler(1,"compare undefined"); 
  return 0; }

inline void Print(const handle_base&, ostream&)
{ error_handler(1,"Print undefined");  }

inline void Read(handle_base&, istream&)
{ error_handler(1,"Read undefined");  }


inline void   Init(handle_base&)            {}
inline void   Clear(handle_base& y)         { y.clear(); }
inline GenPtr Copy(handle_base& y)          { return y.copy();}
inline GenPtr Convert(const handle_base& y) { return y.PTR; }




#define LEDA_HANDLE_TYPE(type)\
inline void   Clear(type& y)  { y.clear(); }\
inline GenPtr Copy(type& y)   { return y.copy();}\
inline char*  Type_Name(const type*) { return STRINGIZE(type); }



//------------------------------------------------------------------------------
// compare, Print, Read, Init, Copy, Clear, Convert, ...  for built-in types
//------------------------------------------------------------------------------

// defining a linear order

inline int compare(const GenPtr& x, const GenPtr& y) 
{ return (char*)x-(char*)y; }

inline int compare(const char& x, const char& y)     { return x-y; }

inline int compare(const int& x, const int& y)
{ if (x < y)  return -1; 
  else if (x > y)  return  1; 
  else return 0;
}

inline int compare(const long& x, const long& y)
{ if (x < y)  return -1; 
  else if (x > y)  return  1; 
  else return 0;
}

inline int compare(const double& x, const double& y)
{ if (x < y)  return -1; 
  else if (x > y)  return  1; 
  else return 0;
}

inline int compare(const float& x, const float& y)
{ if (x < y)  return -1; 
  else if (x > y)  return  1; 
  else return 0;
}


// stream output

inline void Print(const GenPtr& x, ostream& out = cout) { out << x; }
inline void Print(const char& x, ostream& out = cout)   { out << x; }
inline void Print(const short& x, ostream& out = cout)  { out << x; }
inline void Print(const int& x, ostream& out = cout)    { out << x; }
inline void Print(const long& x, ostream& out = cout)   { out << x; }
inline void Print(const float& x, ostream& out = cout)  { out << x; }
inline void Print(const double& x, ostream& out = cout) { out << x; }

// stream input

inline istream& operator>>(istream& in, GenPtr)     { return in; }

inline void Read(GenPtr,   istream&)          {}
inline void Read(char& x,  istream& in = cin) { in >> x; }
inline void Read(short& x, istream& in = cin) { in >> x; }
inline void Read(int&  x,  istream& in = cin) { in >> x; }
inline void Read(long& x,  istream& in = cin) { in >> x; }
inline void Read(float& x, istream& in = cin) { in >> x;}
inline void Read(double& x,istream& in = cin) { in >> x;}


// initialization

inline void Init(const GenPtr&) {}
inline void Init(char&   x) { x=0; }
inline void Init(short&  x) { x=0; }
inline void Init(int&    x) { x=0; }
inline void Init(long&   x) { x=0; }
inline void Init(float&  x) { x=0; }
inline void Init(double& x) { x=0; }


// destruction

inline void Clear(const GenPtr&) {}
inline void Clear(char&  )    {}
inline void Clear(short& )    {}
inline void Clear(int&   )    {}
inline void Clear(long&  )    {}
inline void Clear(float& )    {}
inline void Clear(double& x) { deallocate_bytes(&x,sizeof(double)); }


// copying

inline GenPtr Copy(GenPtr x)  { return x; }
inline GenPtr Copy(char x)    { GenPtr p; *((char*)&p) =x; return p; }
inline GenPtr Copy(short x)   { GenPtr p; *((short*)&p)=x; return p; }
inline GenPtr Copy(int  x)    { return *(GenPtr*)&x; }
inline GenPtr Copy(long x)    { return *(GenPtr*)&x; }
inline GenPtr Copy(float x)   { return *(GenPtr*)&x; }
inline GenPtr Copy(double x)
{ double* p = (double*)allocate_bytes(sizeof(double));
  *p = x;
  return p;
 }


// converting to a generic pointer

inline GenPtr Convert(GenPtr x)     { return x; }
inline GenPtr Convert(char  x)      { GenPtr p; *((char*)&p) =x; return p; }
inline GenPtr Convert(short x)      { GenPtr p; *((short*)&p)=x; return p; }
inline GenPtr Convert(int   x)      { return GenPtr(x); }
inline GenPtr Convert(long  x)      { return GenPtr(x); }
inline GenPtr Convert(float x)      { return *(GenPtr*)&x; }
inline GenPtr Convert(double& x)    { return GenPtr(&x); }



#if !defined(__TEMPLATE_FUNCTIONS__)

// access through a generic pointer

inline const GenPtr& Access(const GenPtr, const GenPtr& p) { return p; }
inline double& Access(const double*, GenPtr p){ return *(double*)p;  }

#endif


// integer type or not ?

inline int Int_Type(GenPtr) { return 0; }
inline int Int_Type(const int*)   { return 1; }
inline int Int_Type(const long*)  { return 1; }


// name of types

inline char* Type_Name(const GenPtr)     { return "unknown"; }
inline char* Type_Name(const char*  )    { return "char"; }
inline char* Type_Name(const short* )    { return "short"; }
inline char* Type_Name(const int*   )    { return "int"; }
inline char* Type_Name(const long*  )    { return "long"; }
inline char* Type_Name(const float* )    { return "float"; }
inline char* Type_Name(const double*)    { return "double"; }


#if defined(__BUILTIN_BOOL__)
inline GenPtr Convert(bool  x)        { GenPtr p; *((bool*)&p)=x; return p; }
inline GenPtr Copy(bool  x)           { GenPtr p; *((bool*)&p)=x; return p; }
inline void   Clear(bool& x)          { x=false; }
inline bool&  Access(const bool*, const GenPtr& p) { return *(bool*)&p; }
inline void   Init(bool& x)           { x=false; }
inline char*  Type_Name(const bool*)  { return "bool"; }

inline int  compare(const bool& x, const bool& y) { return char(x)-char(y); }
inline void Print(const bool& x, ostream& out) { out << (x ? "true":"false"); }
inline void Read(bool&,  istream&) {}
#endif



// maximal and minimal values for some numerical types

inline int    Max_Value(int& x)     { return x =  MAXINT;   }
inline int    Min_Value(int& x)     { return x = -MAXINT;   }
inline float  Max_Value(float& x)   { return x =  MAXFLOAT; }
inline float  Min_Value(float& x)   { return x = -MAXFLOAT; }
inline double Max_Value(double& x)  { return x =  MAXDOUBLE;}
inline double Min_Value(double& x)  { return x = -MAXDOUBLE;}


/*
  type arguments for the LEDA_TYPE_PARAMETER macro must define:

  a constructor taking no arguments: type::type()
  a copy constructor:                type::type(const type&)
  a Read function:                   void Read(type&, istream&)
  a Print function:                  void Print(const type&, ostream&)
  a compare function:                int compare(const type&, const type&)

*/

#define LEDA_TYPE_PARAMETER(type)\
inline void   Init(type&)                        {}\
inline void   Clear(type& x)                     { delete (type*)&x; }\
inline GenPtr Copy(type& x)                      { return new type(x);}\
inline GenPtr Convert(type& x)                   { return GenPtr(&x);}\
inline type&  Access(const type*, GenPtr p)      { return *(type*)p; }\
inline char*  Type_Name(const type*)             { return STRINGIZE(type); }


#define DEFINE_LINEAR_ORDER(type,cmp,new_type)\
struct new_type : public type\
{ new_type(type s)            : type(s) {}\
  new_type(const new_type& s) : type(s) {}\
  new_type() {}\
 ~new_type() {}\
};\
inline int compare(const new_type& x, const new_type& y) { return cmp(x,y); }


//------------------------------------------------------------------------------
// Macros
//------------------------------------------------------------------------------

// nil pointer

#define nil 0


// ACCESS(T,x): access a reference of type T through a generic pointer p
// we have to create a dummy first argument of type T* for Access(T*,x)



#if defined(__TEMPLATE_FUNCTIONS__)
#define ACCESS(type,x)  Access((type*)0,x)
#else
#define ACCESS(type,x)  (type&)(Access((type*)0,x))
#endif


#define INT_TYPE(type)  Int_Type((type*)0)
#define TYPE_NAME(type) Type_Name((type*)0)


//turning a macro argument into a string

#if defined(__STDC__)  || defined(__MSDOS__)
#define STRINGIZE(x) #x
#else
#define STRINGIZE(x) "x"
#endif


// ITERATION MACROS

#define forall_items(x,S) for(x = (S).first_item(); x; x = (S).next_item(x) )




// To avoid multiple declarations of the "forall_loop_item" variable
// we use a dummy for-loop to create a new block for it.
// This, however, does not work with all compilers (ztc,lucid ...)
// and we have to use the old forall mechanism (no nesting).

#if defined(__ZTC__) || defined(__lucid)

#define forall(x,S)\
for((S).start_iteration(); (S).read_iterator(x); (S).move_to_succ())

#define Forall(x,S)\
for((S).Start_iteration(); (S).read_iterator(x); (S).move_to_pred())

#else

#define forall(x,S)\
for(LEDA::loop_dummy=0; LEDA::loop_dummy<1; LEDA::loop_dummy++)\
for(GenPtr forall_loop_item=(S).first_item();\
(S).forall_loop_test(forall_loop_item,x);\
(S).loop_to_succ(forall_loop_item))

#define Forall(x,S)\
for(LEDA::loop_dummy=0; LEDA::loop_dummy<1; LEDA::loop_dummy++)\
for(GenPtr forall_loop_item=(S).last_item();\
(S).forall_loop_test(forall_loop_item,x);\
(S).loop_to_pred(forall_loop_item))

#endif





// miscellaneous

#define Main            main(int argc, char** argv)
#define newline         cout << endl
#define forever         for(;;)
#define loop(a,b,c)     for (a=b;a<=c;a++)

#define Max(a,b) ( (a>b) ? a : b )
#define Min(a,b) ( (a>b) ? b : a )



//------------------------------------------------------------------------------
// enumerations
//------------------------------------------------------------------------------

enum rel_pos { before = 1, after = 0 };

enum direction { forward = 0, backward = 1 };


//------------------------------------------------------------------------------
// boolean
//------------------------------------------------------------------------------

#if !defined(__BUILTIN_BOOL__)

typedef char bool;

enum {false=0, true=1};

#endif



//------------------------------------------------------------------------------
// strings
//------------------------------------------------------------------------------

class string_rep : public handle_rep {

friend class string;

      char*   s;

int dummy;

 string_rep(const char*);
 string_rep(char);

~string_rep() { delete[] s; }

 LEDA_MEMORY(string_rep)

};


class format_string  // used in string constructor (see below)
{ friend class string;
  const char* str;
  public:
  format_string(const char* s) { str = s; }
};


class string  : public handle_base
{

 friend class string_rep;

 friend class panel;

 static char* str_dup(const char*);
 static char* str_cat(const char*,const char*);
 static char* str_ncat(int, char**);

 string_rep*  ptr() const { return (string_rep*)PTR; }

 char** access_ptr() { return &(ptr()->s); }   // used by panel::string_item

public:

 string()                { PTR = new string_rep(""); }
 string(char c)          { PTR = new string_rep(c);  }

//
// string(const char*);
// string(const char*, ...); // printf-like constructor
//
// That's what we want, but then (ARM page 326) a call string("xyz") is
// ambiguous. We use the dummy class "format_string" to resolve  the
// ambiguity:
//
// string(const char*);
// string(format_string, ...);
//
// However, cfront's stdarg (on sparcs) cannot handle the case correctly
// where the first argument is a class object (like format_string). In this
// case we define constructors for each possible second argument and
// we end up with :

 string(const char* s)       { PTR = new string_rep(s);}


#if defined(__GNUG__) || defined(__lucid) || !defined(sparc)
 string(format_string, ...);
#else
 string(const char*, int,   ...);
 string(const char*, long,  ...);
 string(const char*, float, ...);
 string(const char*, double,...);
 string(const char*, char*, ...);
 string(const char*, void*, ...);
#endif


 string(int argc, char** argv) { PTR = new string_rep(str_ncat(argc,argv)); }

 string(const string& x) : handle_base(x)  {}

~string() { clear(); }

string& operator=(const string& x) { handle_base::operator=(x); return *this; }

char*    operator~()   const { return str_dup(ptr()->s); }   // makes a copy !
char*    cstring()     const { return ptr()->s; }
operator const char*() const { return ptr()->s; }

int    length()          const;
string sub(int,int)      const;
int    pos(string,int=0) const;

string operator()(int i, int j)  const { return sub(i,j); }
string head(int i)               const { return sub(0,i-1); }
string tail(int i)               const { return sub(length()-i,length()-1); }

string insert(string, int=0)     const;
string insert(int, string)       const;

string replace(const string&, const string&, int=1) const;
string replace(int, int, const string&) const;

string del(const string&, int=1) const;
string del(int, int) const;

void   read(istream&, char delim=' ');
void   read(char delim=' ')           { read(cin,delim); }
void   read_line(istream& I = cin)    { read(I,'\n'); }

string replace_all(const string& s1, const string& s2)
                                         const  { return replace(s1,s2,0); }
string replace(int i, const string& s)   const  { return replace(i,i,s);  }

string del_all(const string& s)          const  { return del(s,0); }
string del(int i)                        const  { return del(i,i); } 

string format(string) const;

char  operator[](int) const;
char& operator[](int);

string  operator+(const string& x)  const;
string  operator+(const char* x)  const;
string& operator+=(const string& x);

friend int operator==(const string& x, const string& y);
friend int operator==(const string& x, const char* y);
friend int operator!=(const string& x, const string& y);
friend int operator!=(const string& x, const char* y);
friend int operator< (const string& x, const string& y);
friend int operator> (const string& x, const string& y);
friend int operator<=(const string& x, const string& y);
friend int operator>=(const string& x, const string& y);

friend istream& operator>>(istream&, string&);
friend ostream& operator<<(ostream&, const string&) ;

};

inline void Print(const string& x, ostream& out)      { out << x; }
inline void Read(string& x, istream& in)              { in  >> x; }
extern int compare(const string& x, const string& y);

LEDA_HANDLE_TYPE(string)



//------------------------------------------------------------------------------
// INT<cmp>: int with user defined linear order cmp
//------------------------------------------------------------------------------

typedef int   (*CMP_INT_TYPE)(int,int);


template<CMP_INT_TYPE cmp>

class _CLASSTYPE INT
{int p;

public:
 INT(const int i=0) { p = i;}
 operator int()     { return p; }

FRIEND_INLINE void Print(const INT<cmp>& x, ostream& out = cout) { out << x.p; }
FRIEND_INLINE void Read(INT<cmp>&  x, istream& in = cin)  { in  >> x.p; }
FRIEND_INLINE void Init(INT<cmp>&  x)            { x.p=0; }
FRIEND_INLINE GenPtr Copy(const INT<cmp>& x)     { return GenPtr(x); }
FRIEND_INLINE void Clear(INT<cmp>& x)            { x.p = 0; }
FRIEND_INLINE GenPtr Convert(const INT<cmp>& x)  { return GenPtr(x.p); }
FRIEND_INLINE INT<cmp>& Access(INT<cmp>*,const GenPtr& p) { return *(INT<cmp>*)&p; }

FRIEND_INLINE int compare(const INT<cmp>& x, const INT<cmp>& y) { return cmp(x.p,y.p);}
};



//------------------------------------------------------------------------------
// random numbers, timing, etc.
//------------------------------------------------------------------------------

#if defined(random)
// if random is a macro undefine it
#undef random
#endif


#if defined (__NO_RANDOM__)
// the following two functions are defined in basic/_random.c
extern int leda_random();
extern void leda_srandom(int);
inline int random()  { return leda_random(); }
inline void srandom(int s) { leda_srandom(s); }
#endif

inline int      random(int a, int b)  { return a + random()%(b-a+1); }
inline double   rrandom() { return double(random())/MAXINT; }
inline unsigned urandom(unsigned a, unsigned b) 
{ return a + (unsigned)(random())%(b-a+1); }

extern void init_random(int=0);

extern float used_time();
extern float used_time(float&);
extern void  print_time(string s);
inline void  print_time() { print_time(""); }
extern void  wait(unsigned int seconds);


typedef int (*LEDA_SIG_PF) (...);

extern LEDA_SIG_PF catch_interrupts(LEDA_SIG_PF handler = nil);


//------------------------------------------------------------------------------
// input/output
//------------------------------------------------------------------------------

extern int    Yes(string);
extern int    Yes();

extern int    read_int(string);
extern int    read_int();

extern char   read_char(string);
extern char   read_char();

extern double read_real(string);
extern double read_real();

extern string read_line(istream& =cin);
extern string read_string(string);
extern string read_string();

extern void skip_line(istream& =cin);

#endif
