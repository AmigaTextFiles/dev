/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _dlist.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/impl/dlist.h>
#include <ctype.h>


#define SWAP(a,b) { register dlink* x = *a; *a = *b; *b = x; }

#define MIN_D 16 

//------------------------------------------------------------------------------
// Members of class dlist: base class for all lists
//------------------------------------------------------------------------------

dlist::dlist()      
{ h=0; 
  t=0;
  count=0;
  iterator=0; 
}

dlist::dlist(GenPtr a) 
{ h=t=new dlink(a,0,0);
  count=1; 
  iterator=0;  
}

dlist::dlist(const dlist& x)
{ register dlink* p;

  iterator=h=t=0; 
  count = 0; 
                              
  for (p = x.h; p; p = p->succ) append(p->e); 

  if (!int_type())
    for (p = h; p; p = p->succ) x.copy_el(p->e);
}


void dlist::recompute_length() const
{ int n = 0;
  for(dlink* it = h; it; it = it->succ)  n++;
  (int&)count = n;
}


//------------------------------------------------------------------------------
// Iteration:
//------------------------------------------------------------------------------

dlink* dlist::move_iterator(int dir) const 
{ if (iterator) 
     set_iterator(dir ? iterator->pred : iterator->succ);
  else 
     set_iterator(dir ? t : h);
  return iterator;
 } 

bool dlist::current_element(GenPtr& x) const 
{ if (iterator) 
  { x = iterator->e; 
    return true; 
   } 
  return false; 
 }

bool dlist::next_element(GenPtr& x)    const 
{ if (iterator) 
     set_iterator(iterator->succ);
  else 
     set_iterator(h);

  if (iterator) 
  { x = iterator->e;
    return true; 
   } 
  return false; 
 }

bool dlist::prev_element(GenPtr& x)  const
{ if (iterator) 
     set_iterator(iterator->pred);
  else 
     set_iterator(t);

  if (iterator) 
  { x = iterator->e;
    return true; 
   } 
  return false; 
 }

//------------------------------------------------------------------------------

dlink* dlist::get_item(int i) const
{ dlink* p = h;
  while ( p && i--) p = p->succ; 
  return p;
}

dlink* dlist::succ(dlink* p, int i)  const
{ while ( p && i--) p = p->succ; 
  return p;
}

dlink* dlist::pred(dlink* p, int i) const
{ while ( p && i--) p = p->pred; 
  return p;
}

dlink* dlist::search(GenPtr x) const  /* linear search */
{ dlink* p = h;
  while ( p && cmp(p->e,x)) p = p->succ; 
  return p;
} 

int dlist::rank(GenPtr x)   const   /* rank by linear search */
{ dlink* p = h;
  int r = 1;
  while ( p && cmp(p->e,x)) 
  { p = p->succ; 
    r++;
   }
  return (p) ? r : 0;
} 

GenPtr dlist::pop()    
{ if (h==nil) return nil;
  if (iterator!=0) error_handler(1,"pop: deletion while iterator is active");
  dlink* x=h; 
  h = h->succ;
  if (h) h->pred = 0;
  else t = nil;
  GenPtr p = x->e;
  delete x;
  count--;
  return p;
}


GenPtr dlist::Pop()    
{ if (h==nil) return 0;
  if (iterator!=0) error_handler(1,"Pop: deletion while iterator is active");
  dlink* x=t; 
  t = t->pred;
  if (t) t->succ = 0;
  else h = nil;
  GenPtr p = x->e;
  delete x;
  count--;
  return p;
}

dlink* dlist::insert(GenPtr a, dlink* l, int dir) 
{ 
  if (iterator!=0) error_handler(2,"insert: insertion while iterator is active");

  if (l==0) return dir ? append(a) : push(a); 

  dlink* s=l->succ;
  dlink* p=l->pred;
  dlink* n;
  
  if (dir==0) //insert after l
  { n= new dlink(a,l,s);
    l->succ = n;
    if (l==t) t=n;
    else s->pred = n;}

  else //insert before l
  { n= new dlink(a,p,l);
    l->pred = n;
    if (l==h) h=n;
    else p->succ = n;}

  count++;
 
  return n;
}


void dlist::conc(dlist& l, int dir)
{ 
  if (iterator!=0) error_handler(2,"conc: iterator is active");

  if (h==nil)
   { h = l.h; 
     t = l.t; 
    }
  else
  { if (dir==0)  // append l 
    { t->succ = l.h;
      if (l.h) { l.h->pred = t; t = l.t; } 
     }
    else // prepend l
    { h->pred = l.t;
      if (l.t) { l.t->succ= h; h = l.h; } 
     }
   }

 count += l.count;

 l.h = l.t = 0;
 l.count = 0;
}


void dlist::split(dlink* p, dlist& l1, dlist& l2, int dir)
{ 
   // split L at item p into l1 and l2 and  L is made empty
   // dir = 0: p becomes first item of l2 (l2 empty if p == nil)
   // dir = 1: p becomes last item of l1 (l1 empty if p == nil)

   if (iterator!=0) 
   error_handler(1,"list: split while iterator is active");

  if (h == 0) error_handler(888,"split on empty list");

  l1.clear();
  l2.clear();

  if (dir && p) { p = p->succ; dir = 0; }

  if (p==nil) 
   { if (dir==0)
      { l2.h = h;
        l2.t = t;
        l2.count = count;
       }
     else
      { l1.h = h;
        l1.t = t;
        l1.count = count;
       }
    }
  else // p != nil
   { if (p->pred)
     { l1.h = h;
       l1.t = p->pred;
       p->pred->succ = 0;
       l1.count = -1;   // do not know length of l1
      }
 
     p->pred = 0;
     l2.h = p;
     l2.t = t;
     l2.count = -1;   // do not know length of l2
    }

  // make original list empty
  h = t = 0;
  count = 0;

}



GenPtr dlist::del(dlink* it)
{ if (iterator) error_handler(1,"dlist: deletion while iterator is active");
  if (it==nil)  error_handler(999,"dlist: delete nil-item");
  if (it==h)  return pop();
  if (it==t)  return Pop();
  dlink*  p = it->pred;
  dlink*  s = it->succ;
  GenPtr x = it->e;
  p->succ = s;
  s->pred = p;
  count--;
  delete it;
  return x;
}

dlink* dlist::cyclic_succ(dlink* it) const
{ if (it==0) return 0;
  return it->succ? it->succ : h;
}

dlink* dlist::cyclic_pred(dlink* it) const
{ if (it==0) return 0;
  return it->pred? it->pred : t;
}


dlink* dlist::max(CMP_PTR f) const
{ if (h==0) return 0;
  dlink* m=h;
  dlink* p=m->succ;

  if (f) 
     while (p)
     { if (f(p->e,m->e) > 0) m=p;
       p=p->succ;
      }
  else
     while (p)
     { if (cmp(p->e,m->e) > 0) m=p;
       p=p->succ;
      }

  return m;
}

dlink* dlist::min(CMP_PTR f) const
{ if (h==0) return 0;
  dlink* m=h;
  dlink* p=m->succ;

  if (f)
     while (p)
     { if (f(p->e,m->e) < 0) m=p;
       p=p->succ;
     }
  else 
     while (p)
     { if (cmp(p->e,m->e) < 0) m=p;
       p=p->succ;
      }

  return m;
}


void dlist::apply(APP_PTR apply)
{ register dlink* p = h;
  while (p)
  { apply(p->e);
    p = p->succ;
   }
}

void dlist::permute()
{ 
  if (iterator!=0) 
          error_handler(3,"permute: modification while iterator is active");

  list_item* A = new list_item[count+2];
  list_item x = h;
  int j;

  A[0] = A[count+1] = 0;
 
  for(j=1; j <= count; j++)
  { A[j] = x;
    x = x->succ;
   }

  for(j=1; j<count; j++)  
  { long r = random(j,count);
    x = A[j];
    A[j] = A[r];
    A[r] = x;
   }

  for(j=1; j<=count; j++) 
  { A[j]->succ = A[j+1];
    A[j]->pred = A[j-1];
   }

  h = A[1];
  t = A[count];
  
  delete A;
}
        

void dlist::bucket_sort(int i, int j, ORD_PTR ord)
{ if (iterator!=0) 
        error_handler(3,"bucket_sort: modification while iterator is active");

  if (h==nil) return; // empty list

  int n = j-i+1;

  register list_item* bucket= new list_item[n+1];
  register list_item* stop = bucket + n;
  register list_item* p;

  register list_item q;
  register list_item x;

  for(p=bucket;p<=stop;p++)  *p = 0;

  while (h) 
  { x = h; 
    h = h->succ;
    int k = ord(x->e);
    if (k >= i && k <= j) 
     { p = bucket+k-i;
       x->pred = *p;
       if (*p) (*p)->succ = x;
       *p = x;
      }
    else 
       error_handler(4,"bucket_sort: value out of range") ;
   }

 for(p=stop; *p==0; p--); 

 // now p points to the end of the rightmost non-empty bucket
 // make it the new head  of the list (remember: list is not empty)

 t = *p;
 t->succ = nil;

 for(q = *p; q->pred; q = q->pred); // now q points to the start of this bucket

 // link buckets together from right to left:
 // q points to the start of the last bucket
 // p points to end of the next bucket

 while(--p >= bucket) 
   if (*p)
   { (*p)->succ = q;
     q->pred = *p;
     for(q = *p; q->pred; q = q->pred); 
    }

 h = q;   // head = start of leftmost non-empty bucket

 delete bucket;
}


void dlist::quick_sort(dlink** l, dlink** r)
{ // use virtual cmp function

  register dlink** i = l+(r-l)/2; //random()%(r-l);
  register dlink** k;
 
  if (cmp((*i)->e,(*r)->e)>0) SWAP(i,r);

  SWAP(l,i);
 
  GenPtr s = (*l)->e;
 
  i = l;
  k = r;

  for(;;)
  { while (cmp((*(++i))->e,s)<0);
    while (cmp((*(--k))->e,s)>0);
    if (i<k) SWAP(i,k) else break;
   }

  SWAP(l,k);

  if (k > l+MIN_D) quick_sort(l,k-1);
  if (r > k+MIN_D) quick_sort(k+1,r);
}
        
void dlist::quick_sort(dlink** l, dlink** r, CMP_PTR usr_cmp)
{ // use parameter usr_cmp

  register dlink** i = l+(r-l)/2; //random()%(r-l);
  register dlink** k;
 
  if (usr_cmp((*i)->e,(*r)->e)>0) SWAP(i,r);

  SWAP(l,i);
 
  GenPtr s = (*l)->e;
 
  i = l;
  k = r;

  for(;;)
  { while (usr_cmp((*(++i))->e,s)<0);
    while (usr_cmp((*(--k))->e,s)>0);
    if (i<k) SWAP(i,k) else break;
   }

  SWAP(l,k);

  if (k > l+MIN_D) quick_sort(l,k-1,usr_cmp);
  if (r > k+MIN_D) quick_sort(k+1,r,usr_cmp);
}
        

void dlist::int_quick_sort(dlink** l, dlink** r)
{ // use built-in < and > operators for integers

  register dlink** i = l+(r-l)/2; //random()%(r-l);
  register dlink** k;
 
  if ((*i)->e > (*r)->e) SWAP(i,r);

  SWAP(l,i);
 
  GenPtr s = (*l)->e;
 
  i = l;
  k = r;

  for(;;)
  { while ((*(++i))->e < s);
    while ((*(--k))->e > s);
    if (i<k) SWAP(i,k) else break;
   }

  SWAP(l,k);

  if (k > l+MIN_D) int_quick_sort(l,k-1);
  if (r > k+MIN_D) int_quick_sort(k+1,r);
}


void dlist::insertion_sort(dlink** l, dlink** r, dlink** min_stop, 
                               CMP_PTR usr_cmp)
{
  register dlink** min=l;
  register dlink** run;
  register dlink** p;
  register dlink** q;

  for (run = l+1; run <= min_stop; run++)
      if (usr_cmp((*run)->e,(*min)->e) < 0) min = run;

  SWAP(min,l);

  if (r == l+1) return; 

  for(run=l+2; run <= r; run++)
  { for (min = run-1; usr_cmp((*run)->e,(*min)->e) < 0; min--);
    min++;
    if (run != min) 
    { dlink* save = *run;
      for(p=run, q = run-1; p > min; p--,q--) *p = *q;
      *min = save;
     }
   }
}


void dlist::insertion_sort(dlink** l, dlink** r, dlink** min_stop)
{
  register dlink** min=l;
  register dlink** run;
  register dlink** p;
  register dlink** q;

  for (run = l+1; run <= min_stop; run++)
      if (cmp((*run)->e,(*min)->e) < 0) min = run;

  SWAP(min,l);

  if (r == l+1) return; 

  for(run=l+2; run <= r; run++)
  { for (min = run-1; cmp((*run)->e,(*min)->e) < 0; min--);
    min++;
    if (run != min) 
    { dlink* save = *run;
      for(p=run, q = run-1; p > min; p--,q--) *p = *q;
      *min = save;
     }
   }
}


void dlist::int_insertion_sort(dlink** l, dlink** r, dlink** min_stop)
{
  register dlink** min=l;
  register dlink** run;
  register dlink** p;
  register dlink** q;

  for (run = l+1; run <= min_stop; run++)
      if ((*run)->e < (*min)->e) min = run;

  SWAP(min,l);

  if (r == l+1) return; 

  for(run=l+2; run <= r; run++)
  { for (min = run-1; (*run)->e < (*min)->e; min--);
    min++;
    if (run != min) 
    { dlink* save = *run;
      for(p=run, q = run-1; p > min; p--,q--) *p = *q;
      *min = save;
     }
   }
}




void dlist::sort(CMP_PTR f)
{ if (iterator!=0)
      error_handler(1,"sort: modification while iterator is active");

  if (count<=1) return;    // nothing to sort

  dlink** A = new dlink*[count+2];

  register dlink*  loc = h;
  register dlink** p;
  register dlink** stop = A+count+1;

  dlink** left  = A+1;
  dlink** right = A+count;
  dlink** min_stop = left + MIN_D;

  if (min_stop > right) min_stop = right;

min_stop = right;

  for(p=A+1; p<stop; p++)
  { *p = loc;
    loc = loc->succ;
   }


  if (f)
    { quick_sort(left,right,f);
      insertion_sort(left,right,min_stop,f);
     }
  else  
    if (int_type())
      { int_quick_sort(left,right);
        int_insertion_sort(left,right,min_stop);
       }
    else
      { quick_sort(left,right);
        insertion_sort(left,right,min_stop);
       }

  *A = *stop = 0;

  for (p=A+1;p<stop;p++) 
  { (*p)->succ = *(p+1);
    (*p)->pred = *(p-1);
   }

  h = A[1];
  t = A[count];

  delete A;
}


dlist& dlist::operator=(const dlist& x)
{ register dlink* p;

  clear();

  for (p = x.h; p; p = p->succ) append(p->e); 

  if (!int_type())
    for (p = h; p; p = p->succ) copy_el(p->e);
                                
  return *this;
}


dlist dlist::operator+(const dlist& x)  // concatenation
{ dlist y = x;
  dlink* p = t;
  while (p) { y.push(p->e);    
              x.copy_el(p->e);
              p = p->pred;}
  return y;
}


void dlist::clear()
{ if (h==nil) return;

  if (!int_type())
    for(dlink* p = h; p; p = p->succ) clear_el(p->e);

  deallocate_list(h,t,sizeof(dlink));
  iterator=h=t=nil;
  count=0;
}

void dlist::print(ostream& out, string s, char space) const
{ list_item l = h;
  cout << s;
  if (l)
  { print_el(l->e,out); 
    l = l->succ;
    while (l)
      { out << string(space);
        print_el(l->e,out); 
        l = l->succ;
       }
  }
  out.flush();
}


void dlist::read(istream& in, string s, char delim)
{ char c;
  GenPtr x;
  cout << s;
  clear();
  for(;;)
  { while (in.get(c) && isspace(c) && c!=delim);
    if (!in || c==delim) break;
    in.putback(c);
    read_el(x,in); 
    append(x);
   }
}
