/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  gen_array.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_GEN_ARRAY_H
#define LEDA_GEN_ARRAY_H

//------------------------------------------------------------------------------
// arrays
//------------------------------------------------------------------------------

#include <LEDA/basic.h>



class gen_array {

protected:
	GenPtr* v;
	int sz;	
        int Low;
        int High;
        int t;
        int dir;


virtual int cmp(GenPtr x, GenPtr y)           const { return compare(x,y); };
virtual void print_el(GenPtr& x,ostream& out) const { Print(x,out); }
virtual void read_el(GenPtr& x,istream& in)         { Read(x,in); }
virtual void clear_entry(GenPtr&) {}
virtual void copy_entry(GenPtr&)  {}
virtual void init_entry(GenPtr&)  {}

virtual int  int_type() const { return 0; }

        void quick_sort(GenPtr*,GenPtr*);
        void quick_sort(GenPtr*,GenPtr*,CMP_PTR);
        void int_quick_sort(GenPtr*,GenPtr*);

        void insertion_sort(GenPtr*,GenPtr*,GenPtr*);
        void insertion_sort(GenPtr*,GenPtr*,GenPtr*,CMP_PTR);
        void int_insertion_sort(GenPtr*,GenPtr*,GenPtr*);

        void quick_test(GenPtr*,GenPtr*);

protected:
        int  binary_search(GenPtr);
        int  binary_search(GenPtr,CMP_PTR);
        int  int_binary_search(GenPtr);

        void sort(int,int,CMP_PTR); 


        void clear();

public:
        void sort_test(int); 

        void init();
        virtual ~gen_array() { if (v) delete[] v; }
        gen_array();
	gen_array(int);
	gen_array(int, int);
	gen_array(const gen_array&);
	gen_array& operator=(const gen_array&);

        int      size() const     { return sz; }
        int      low()  const     { return Low; }
        int      high() const     { return High; }
	GenPtr& elem(int i)       { return v[i]; }
	GenPtr  elem(int i) const { return v[i]; }
	GenPtr& entry(int i)
	{ if (i<Low || i>High)
          error_handler(2,"array::entry index out of range");
          return v[i-Low];
         }
	GenPtr  inf(int i) const
	{ if (i<Low || i>High)
          error_handler(2,"array::inf index out of range");
          return v[i-Low];
         }

        void permute(int,int);
        void permute()  { permute(Low,High); }


   void print(ostream&,string, char space)   const;    
   void print(ostream& out,char space=' ') const { print(out,"",space);  }
   void print(string s, char space=' ')    const { print(cout,s,space);  }
   void print(char space=' ')              const { print(cout,"",space); }   


   void read(istream&,string);  
   void read(istream& in)      { read(in,"");  }
   void read(string s )        { read(cin,s);  }   
   void read()                 { read(cin,""); }   


};


/*------------------------------------------------------------------------*/
/* 2 dimensional arrays                                                   */
/*------------------------------------------------------------------------*/


class gen_array2 {
gen_array A;
int Low1, Low2, High1, High2;
virtual void clear_entry(GenPtr& x)  { x = 0; }
virtual void copy_entry(GenPtr& x)   { x = 0; }
virtual void init_entry(GenPtr& x)   { x = 0; }

protected:
void clear();
gen_array* row(int i) const { return (gen_array*)A.inf(i); }

public:
void init(int,int,int,int);
int low1()  { return Low1; }
int low2()  { return Low2; }
int high1() { return High1; }
int high2() { return High2; }
gen_array2(int,int,int,int);
gen_array2(int,int);
virtual ~gen_array2();
};



// default I/O and cmp functions

inline void Print(const gen_array& A, ostream& out) { A.print(out); }
inline void Read(gen_array& A, istream& in) { A.read(in); }
inline int compare(const gen_array&,const gen_array&) { return 0; }

#endif
