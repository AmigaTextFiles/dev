/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  ch_hash1.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_CH_HASHING1_H
#define LEDA_CH_HASHING1_H

//------------------------------------------------------------------------------
// Hashing with Chaining
//
// S. Naeher  (1994)
//
//------------------------------------------------------------------------------

#include <LEDA/basic.h>
 

//------------------------------------------------------------------------------
// class ch_hash1_elem  
//------------------------------------------------------------------------------

class ch_hash1_elem 
{
  friend class ch_hash1;

  ch_hash1_elem* succ;
  GenPtr k;
  GenPtr i;


  public:

  ch_hash1_elem(GenPtr key, GenPtr inf, ch_hash1_elem* next = 0) 
  { k = key; 
    i = inf; 
    succ = next;
   }

  ch_hash1_elem() {}

  LEDA_MEMORY(ch_hash1_elem)

};

typedef ch_hash1_elem*  ch_hash1_item;


//--------------------------------------------------------------------
// class ch_hash1
//--------------------------------------------------------------------

class ch_hash1 
{

   static ch_hash1_elem STOP;

   ch_hash1_elem* table;

   int table_size;           
   int table_size_1;           
   int low_table;           
   int high_table;           
   int count;


   virtual int hash_fct(GenPtr x)      const { return long(x); }
   virtual int cmp(GenPtr x, GenPtr y) const { return compare(x,y); }
   virtual void clear_key(GenPtr&)  const { }
   virtual void clear_inf(GenPtr&)  const { }
   virtual void copy_key(GenPtr&)   const { }
   virtual void copy_inf(GenPtr&)   const { }
   virtual void print_key(GenPtr)   const { }

   virtual int_type() const { return 0; }

   int  next_pow(int) const;
   void init(int);
   void rehash(int);
   void destroy();
   ch_hash1_item search(GenPtr,ch_hash1_item&) const;

   protected:

   ch_hash1_item item(GenPtr p) const { return ch_hash1_item(p) ; }

   public:

   ch_hash1_item lookup(GenPtr x) const;

   ch_hash1_item insert(GenPtr,GenPtr);

   ch_hash1_item first_item() const { return 0; }
   ch_hash1_item next_item(ch_hash1_item) const { return 0; }

   void del(GenPtr);
   void del_item(ch_hash1_item);

   bool member(GenPtr x)   const  { return ( lookup(x) ? true : false ); } 

   GenPtr  key(ch_hash1_item p)  const { return p->k; }
   GenPtr  inf(ch_hash1_item p)  const { return p->i; }
   GenPtr& info(ch_hash1_item p)       { return p->i; }

   void change_inf(ch_hash1_item, GenPtr);
   bool empty() const     { return count ? false : true ; } 
   int  size()  const     { return count; } 
   int  tablesize() const { return table_size ; }
   void clear()           { destroy(); init(table_size);}

   ch_hash1& operator=(const ch_hash1&);
   ch_hash1(const ch_hash1&);

   ch_hash1(int ts = 1<<10) { init(ts); /* init(next_pow(ts)); */ }
   virtual ~ch_hash1()     { destroy(); }

};


#endif
