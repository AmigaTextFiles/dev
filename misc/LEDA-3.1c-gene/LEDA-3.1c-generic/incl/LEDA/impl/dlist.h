/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  dlist.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#ifndef LEDA_DLIST_H
#define LEDA_DLIST_H

//------------------------------------------------------------------------------
//  doubly linked lists
//------------------------------------------------------------------------------

#include <LEDA/basic.h>

//------------------------------------------------------------------------------
// some declarations
//------------------------------------------------------------------------------

class dlist; 
class dlink;

typedef dlink* list_item;

//------------------------------------------------------------------------------
// class dlink (list items)
//------------------------------------------------------------------------------

class dlink {

  dlink* succ;
  dlink* pred;
  GenPtr e;

  dlink(GenPtr a, dlink* pre, dlink* suc)
  { 
    e = a;
    succ = suc;
    pred = pre;
  }

  LEDA_MEMORY(dlink)


  friend class dlist;
  FRIEND_INLINE dlink* succ_item(dlink* p);
  FRIEND_INLINE dlink* pred_item(dlink* p);


  //space: 3 words = 12 bytes
};


inline dlink* succ_item(dlink* p) { return p->succ; }
inline dlink* pred_item(dlink* p) { return p->pred; }


//------------------------------------------------------------------------------
// dlist: base class for all doubly linked lists
//------------------------------------------------------------------------------

class dlist {

   dlink* h;                     //head
   dlink* t;                     //tail
   dlink* iterator;              //iterator
   int count;                    //length of list

//space: 4 words + virtual =  5 words = 20 bytes

virtual int  cmp(GenPtr x, GenPtr y)  const { return compare(x,y); }
virtual void read_el(GenPtr&,istream&) {}
virtual void print_el(GenPtr& x,ostream& out) const { Print(int(x),out); }
virtual void clear_el(GenPtr&) const {}
virtual void copy_el(GenPtr&)  const {}
virtual int  int_type() const { return 0; }

void quick_sort(list_item*,list_item*);
void quick_sort(list_item*,list_item*,CMP_PTR);
void int_quick_sort(list_item*,list_item*);

void insertion_sort(dlink**,dlink**,dlink**);
void insertion_sort(dlink**,dlink**,dlink**,CMP_PTR);
void int_insertion_sort(dlink**,dlink**,dlink**);

void recompute_length() const;

public:

// access operations

   int  length() const { if (count < 0) recompute_length(); return count; }
   int  size()   const { return length(); }
   bool empty()  const { return h==nil; }

   dlink* first()               const { return h; }
   dlink* first_item()          const { return h; }
   dlink* last()                const { return t; }
   dlink* last_item()           const { return t; }
   dlink* next_item(dlink* p)   const { return p->succ; }
   dlink* succ(dlink* l)        const { return l->succ; }
   dlink* pred(dlink* l)        const { return l->pred; }
   dlink* cyclic_succ(dlink*)   const;
   dlink* cyclic_pred(dlink*)   const;
   dlink* succ(dlink* l, int i) const; 
   dlink* pred(dlink* l, int i) const;
   dlink* get_item(int = 0)     const; 

   dlink* max(CMP_PTR) const;
   dlink* min(CMP_PTR) const;
   dlink* search(GenPtr) const;

   int    rank(GenPtr) const;

   GenPtr contents(dlink* l) const { return l->e; }
   GenPtr head()             const { return h ? h->e : 0;}
   GenPtr tail()             const { return t ? t->e : 0;}


// update operations

protected:

   dlink* insert(GenPtr a, dlink* l, int dir=0);

   dlink* push(GenPtr a)   
   { count++;
     if (h) h = h->pred = new dlink(a,0,h); 
     else   h = t =  new dlink(a,0,0);
     return h;
    }
   
   dlink* append(GenPtr a)
   { count++;
     if (t) t = t->succ = new dlink(a,t,0);
     else   t = h = new dlink(a,0,0);
     return t; 
    } 
   
   void   assign(dlink* l, GenPtr a) { copy_el(a); l->e = a; }


public:

   GenPtr del(dlink* loc);
   GenPtr pop();
   GenPtr Pop();

   void   conc(dlist&,int dir=0);
   void   split(list_item,dlist&,dlist&,int dir=0);
   void   apply(APP_PTR);
   void   sort(CMP_PTR);
   void   bucket_sort(int,int,ORD_PTR);
   void   permute();
   void   clear();

// iteration

   void   set_iterator(dlink* p)   const { (dlink*&)iterator = p; }
   void   start_iteration()        const { set_iterator(h); }
   void   Start_iteration()        const { set_iterator(t); }
   void   move_to_succ()           const { set_iterator(iterator->succ); }
   void   move_to_pred()           const { set_iterator(iterator->pred); }
   dlink* read_iterator(GenPtr& x) const { if (iterator) x = iterator->e; 
                                           return iterator; }
   dlink* read_ptr_iterator(GenPtr& x) 
                                   const { if (iterator) x = iterator->e; 
                                           return iterator; }

   GenPtr loop_to_succ(GenPtr& x) const { return x = list_item(x)->succ; }
   GenPtr loop_to_pred(GenPtr& x) const { return x = list_item(x)->pred; }


//  old iteration stuff

   void  reset()               const { set_iterator(nil); }
   void  init_iterator()       const { set_iterator(nil); }

   dlink* get_iterator()       const { return iterator; }
   dlink* move_iterator(int=0) const;

   bool   current_element(GenPtr&) const;
   bool   next_element(GenPtr&)    const;
   bool   prev_element(GenPtr&)    const;


// operators

   GenPtr&   entry(dlink* l)            { return l->e; }
   GenPtr    inf(dlink* l)        const { return l->e; }
   GenPtr&   operator[](dlink* l)       { return l->e; }
   GenPtr    operator[](dlink* l) const { return l->e; }

   dlist& operator=(const dlist&); 
   dlist  operator+(const dlist&); 


   void print(ostream&,string, char)       const;    
   void print(ostream& out,char space=' ') const { print(out,"",space);  }
   void print(string s, char space=' ')    const { print(cout,s,space);  }
   void print(char space=' ')              const { print(cout,"",space); }   


   void read(istream&,string, char);  

   void read(istream& in,char delim) { read(in,"",delim); }
   void read(istream& in)            { read(in,"",EOF); }

   void read(string s, char delim)  { read(cin,s,delim); }   
   void read(string s)              { read(cin,s,'\n'); }   

   void read(char delim)  { read(cin,"",delim);}  
   void read()            { read(cin,"",'\n');}  


// constructors & destructors

   dlist();    
   dlist(GenPtr a);
   dlist(const dlist&);

   virtual ~dlist()  { clear(); }

   int space()  const { return sizeof(dlist) + count * sizeof(dlink); }
};



// default I/O and cmp functions

inline void Print(const dlist& L,ostream& out) { L.print(out); }

inline void Read(dlist& L, istream& in) { L.read(in); }

inline int compare(const dlist&,const dlist&) { return 0; }

#endif
