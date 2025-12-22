/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  olist1.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_OLIST1_H
#define LEDA_OLIST1_H

//------------------------------------------------------------------------------
//  doubly linked circular lists
//------------------------------------------------------------------------------

#include <LEDA/basic.h>

//------------------------------------------------------------------------------
// class olink1 (base class for all list items)
//------------------------------------------------------------------------------

class olink1 {

  olink1* succ;
  olink1* pred;

public:

  olink1* succ_item() { return succ; }
  olink1* pred_item() { return pred; }

  void    del_item() { olink1*  p = pred;
                       olink1*  s = succ;
                       p->succ = s;
                       s->pred = p; }

  LEDA_MEMORY(olink1)

  friend class olist1;

};


//------------------------------------------------------------------------------
// olist1: base class for all doubly linked lists
//------------------------------------------------------------------------------

class olist1 : public olink1 {

public:


// access operations

   bool empty()  const { return (succ==this) ? true : false;}

   olink1* first()                const { return (succ==this) ? nil : succ; }
   olink1* last()                 const { return (pred==this) ? nil : pred; }
   olink1* first_item()           const { return first(); }
   olink1* last_item()            const { return last(); }
   olink1* next_item(olink1* p)   const { return succ(p); }

   olink1* succ(olink1* p) const { return (p->succ==this)? nil : p->succ; }
   olink1* pred(olink1* p) const { return (p->pred==this)? nil : p->pred; }
   olink1* cyclic_succ(olink1* p) const { return (p->succ==this) ? pred : p->succ; }
   olink1* cyclic_pred(olink1* p) const { return (p->pred==this) ? succ : p->pred; }

// update operations

   void    insert(olink1* p, olink1* l);
   olink1* del(olink1* loc);

   olink1* push(olink1* p)   { insert(p,this); }
   olink1* append(olink1* p) { insert(p,pred); }

   olink1* pop()     { return del(succ); }
   olink1* Pop()     { return del(pred); }

   void clear() { succ = pred = this; }


// constructors & destructors

   olist1()  { succ = pred = this; }
  ~olist1()  { clear(); }

};


inline void olist1::insert(olink1* n, olink1* p) 
{ // insert n insert after p
  olink1* s=p->succ;
  n->pred = p;
  n->succ = s;
  p->succ = n;
  s->pred = n;
 }

inline olink1* olist1::del(olink1* x)
{ olink1*  p = x->pred;
  olink1*  s = x->succ;
  p->succ = s;
  s->pred = p;
  return x;
 }


#endif
