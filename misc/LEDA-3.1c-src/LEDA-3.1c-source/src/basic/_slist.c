/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _slist.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/impl/slist.h>

//------------------------------------------------------------------------------
// Members of class SLIST
//------------------------------------------------------------------------------

SLIST::SLIST()      
{ h=0; 
  t=0;
  count=0;
  iterator=0; 
}

SLIST::SLIST(GenPtr a) 
{ h=t=new slink(a,0);
  count=1; 
  iterator=0;  
}


SLIST::SLIST(const SLIST& x)
{ register slink* p;

  iterator=h=t=0; 
  count = 0; 
                              
  for (p = x.h; p; p = p->succ) append(p->e); 

  if (!int_type())
    for (p = h; p; p = p->succ) x.copy_el(p->e);
}

GenPtr SLIST::pop()    
{ if (iterator!=0) error_handler(1,"pop: deletion while iterator is active");
  GenPtr res;
  if (h) 
  { if (t==h) t = 0;
    slink* x=h; 
    res = x->e;
    h=x->succ; 
    delete x;
    count--;
   }
  return res;
}

/*
void SLIST::del_succ(slink* p)    
{ slink* q = p->succ;
  if (q) 
  { if (t==q) t = p;
    p->succ = q->succ; 
    delete q;
    count--;
   }
}
*/


slink* SLIST::insert(GenPtr a, slink* p)   
{ if (iterator!=0) 
         error_handler(2,"insert: insertion while iterator is active");
  count++;
  p->succ = new slink(a,p->succ); 
  if (t==p) t = p->succ;
  return h;
}

void SLIST::conc(SLIST& l)
{ if (iterator!=0) error_handler(2,"conc: iterator is active");
 if (count > 0) 
   { t->succ = l.h;
     if (l.count > 0) t = l.t; 
    }
 else 
   { h = l.h; 
     t = l.t; 
    }
 count = count+l.count;
 l.h = l.t = 0;
 l.count = 0;
}


slink* SLIST::cyclic_succ(slink* loc) const
{ if (loc==0) return 0;
  return loc->succ? loc->succ : h;
 }

SLIST& SLIST::operator=(const SLIST& x)
{ register slink* p;

  clear();

  for (p = x.h; p; p = p->succ) append(p->e); 

  if (!int_type())
    for (p = h; p; p = p->succ) copy_el(p->e);

  return *this;
 }

void SLIST::clear()
{ if (h==0) return;

  register slink* p;

  if(!int_type())
    for(p = h; p; p = p->succ) clear_el(p->e);

  deallocate_list(h,t,sizeof(slink));
  iterator=h=t=0;
  count=0;
 }
