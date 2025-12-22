/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  ch_array.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_CH_HASHING3_H
#define LEDA_CH_HASHING3_H

//------------------------------------------------------------------------------
// Hashing Array with Chaining
//
// S. Naeher  (1994)
//
//------------------------------------------------------------------------------

#include <LEDA/basic.h>
 

//------------------------------------------------------------------------------
// class ch_array_elem  
//------------------------------------------------------------------------------

class ch_array_elem 
{
  friend class ch_array;

  ch_array_elem* succ;
  GenPtr k;
  GenPtr i;

};

typedef ch_array_elem*  ch_array_item;


//--------------------------------------------------------------------
// class ch_array
//--------------------------------------------------------------------


class ch_array 
{

   static ch_array_elem STOP;

   ch_array_elem* table;
   ch_array_elem* table_end;
   ch_array_elem* free;
   int table_size;           
   int table_size_1;           
   int shift;

   GenPtr  init_val;

   virtual void clear_inf(GenPtr&)  const { }
   virtual void copy_inf(GenPtr&)   const { }

   void init_table(int);
   void rehash();
   void destroy();


   public:

   GenPtr& access(GenPtr);
   GenPtr  access(GenPtr) const;
   GenPtr  lookup(GenPtr) const;

   void print();

   ch_array_item first_item() const { return 0; }
   ch_array_item next_item(ch_array_item) const { return 0; }

   ch_array& operator=(const ch_array&);
   ch_array(const ch_array&);
   ch_array(GenPtr ini=0, int sz = 0, int n=1024); 

   virtual ~ch_array() { destroy(); }

};


#endif
