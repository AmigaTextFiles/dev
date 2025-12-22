/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _array.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/impl/gen_array.h>

#define SWAP(a,b) { register GenPtr help = *a; *a = *b; *b = help; }

#define MIN_D 16 

void gen_array::read(istream& in, string s)
{ cout << s;
  int i = 0; 
  while (in && i<sz)
  { clear_entry(v[i]);
    read_el(v[i],in);
    i++;
   }
 }

void gen_array::print(ostream& out, string s, char space) const
{ cout << s;
  int i = 0; 
  while (i < sz)
    { out << string("%c",space);
      print_el(v[i],out); 
      i++;
     }
  out.flush();
}

void gen_array::clear() 
{ register int i = sz;
  register GenPtr* vv = &v[i];
  while (i--) clear_entry(*--vv);
}

void gen_array::init() 
{ register int i = sz;
  register GenPtr* vv = &v[i];
  while (i--) init_entry(*--vv);
}

gen_array::gen_array()
{ Low = 0;
  High = -1;
  sz = 0;
  v = 0;
}


gen_array::gen_array(int a, int b)
{ if (a>b) error_handler(1,"bad array size");
  Low = a;
  High = b;
  sz = b-a+1;
  v = new GenPtr[sz+1];
  if (v==0) error_handler(99,"array: out of memory");
  register int i = sz;
  register GenPtr* vv = &v[i];
  while (i--) init_entry(*--vv);
 }

gen_array::gen_array(int n)
{ Low = 0;
  High = n-1;
  sz = n;
  v = new GenPtr[sz+1];
  if (v==0) error_handler(99,"array: out of memory");
  register int i = sz;
  register GenPtr* vv = &v[i];
  while (i--) init_entry(*--vv);
}

gen_array::gen_array(const gen_array& a)
{ register i = a.sz;
  sz = i;       
  Low = a.Low;
  High = a.High;
  v = new GenPtr[i+1];
  register GenPtr* vv = &v[i];
  register GenPtr* av = &a.v[i];
  while (i--) 
  { *--vv = *--av;
    copy_entry(*vv);
   }
}

gen_array& gen_array::operator=(const gen_array& a)
{ if (this != &a)
  { register i = a.sz;
    if (sz != i)
    { sz = i;       
      clear();
      delete v;
      v = new GenPtr[i+1];
    }
    Low = a.Low;
    High = a.High;
    register GenPtr* vv = &v[i];
    register GenPtr* av = &a.v[i];
    while (i--) 
    { *--vv = *--av;
      copy_entry(*vv);
     }
  }
 return *this;
}

void gen_array::permute(int l, int r)
{
  if (l<Low || l>High || r<l || r>High) 
         error_handler(2,"array::permute illegal range");
 
  l -= Low;
  r -= Low;

  register GenPtr* x;
  register GenPtr* y;
  register GenPtr* stop = v+r+1;

  init_random();
  for(x=v+l;x!=stop;x++) 
  { y = v+random(l,r);  
    SWAP(x,y);  
   }
}

static int min_d;

void gen_array::quick_test(GenPtr* l, GenPtr* r)
{ 
  register GenPtr  s;
  register GenPtr* k;
  register GenPtr* i = l+random()%(r-l);

  SWAP(i,l);
  i = l;
  k = r+1;
  s = *l;

  for(;;)
  { while (*(++i) < s);
    while (*(--k) > s);
    if (i<k) SWAP(i,k) else break;
   }

  SWAP(l,k);

  if (l < k-min_d) quick_test(l,k-1);
  if (r > k+min_d) quick_test(k+1,r);
}

void gen_array::sort_test(int d) 
{
  GenPtr* left  = v;
  GenPtr* right = v+sz-1;
  GenPtr* min_stop = left + d;

  if (min_stop > right) min_stop = right;

  v[sz] = GenPtr(MAXINT);

  min_d = d;
  quick_test(left,right);
  if (d>1) int_insertion_sort(left,right,min_stop);
 }


void gen_array::sort(int l, int h, CMP_PTR f) 
{
  GenPtr* left  = v+l-Low;
  GenPtr* right = v+h-Low;
  GenPtr* min_stop = left + MIN_D;

  if (min_stop > right) min_stop = right;

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
 }


void gen_array::quick_sort(GenPtr* l, GenPtr* r)
{ 
  register GenPtr* i = l+(r-l)/2; //l+random()%(r-l);
  register GenPtr* k;

  if (cmp(*i,*r) > 0) SWAP(i,r);
  SWAP(l,i);

  GenPtr  s = *l;

  i = l;
  k = r;

  for(;;)
  { while (cmp(*(++i),s)<0);
    while (cmp(*(--k),s)>0);
    if (i<k) SWAP(i,k) else break;
   }

  SWAP(l,k);

  if (k > l+MIN_D) quick_sort(l,k-1);
  if (r > k+MIN_D) quick_sort(k+1,r);
}


void gen_array::quick_sort(GenPtr* l, GenPtr* r, CMP_PTR usr_cmp)
{ 
  register GenPtr* i = l+(r-l)/2; //l+random()%(r-l);
  register GenPtr* k;

  if (usr_cmp(*i,*r) > 0) SWAP(i,r);
  SWAP(l,i);

  GenPtr  s = *l;

  i = l;
  k = r;

  for(;;)
  { while (usr_cmp(*(++i),s)<0);
    while (usr_cmp(*(--k),s)>0);
    if (i<k) SWAP(i,k) else break;
   }

  SWAP(l,k);

  if (k > l+MIN_D) quick_sort(l,k-1,usr_cmp);
  if (r > k+MIN_D) quick_sort(k+1,r,usr_cmp);
}


void gen_array::int_quick_sort(GenPtr* l, GenPtr* r)
{ 
  register GenPtr* i = l+(r-l)/2; //l+random()%(r-l);
  register GenPtr* k;

  if (*i > *r) SWAP(i,r);
  SWAP(l,i);

  GenPtr  s = *l;

  i = l;
  k = r;

  for(;;)
  { while (*(++i) < s);
    while (*(--k) > s);
    if (i<k) SWAP(i,k) else break;
   }

  SWAP(l,k);

  if (k > l+MIN_D) int_quick_sort(l,k-1);
  if (r > k+MIN_D) int_quick_sort(k+1,r);
}

void gen_array::insertion_sort(GenPtr* l, GenPtr* r, GenPtr* min_stop, 
                               CMP_PTR usr_cmp)
{
  register GenPtr* min=l;
  register GenPtr* run;
  register GenPtr* p;
  register GenPtr* q;

  for (run = l+1; run <= min_stop; run++)
      if (usr_cmp(*run,*min) < 0) min = run;

  SWAP(min,l);

  if (r == l+1) return;

  for(run=l+2; run <= r; run++)
  { for (min = run-1; usr_cmp(*run,*min) < 0; min--);
    min++;
    if (run != min) 
    { GenPtr save = *run;
      for(p=run, q = run-1; p > min; p--,q--) *p = *q;
      *min = save;
     }
   }
}


void gen_array::insertion_sort(GenPtr* l, GenPtr* r, GenPtr* min_stop)
{
  register GenPtr* min=l;
  register GenPtr* run;
  register GenPtr* p;
  register GenPtr* q;

  for (run = l+1; run <= min_stop; run++)
      if (cmp(*run,*min) < 0) min = run;

  SWAP(min,l);

  if (r == l+1) return;

  for(run=l+2; run <= r; run++)
  { for (min = run-1; cmp(*run,*min) < 0; min--);
    min++;
    if (run != min) 
    { GenPtr save = *run;
      for(p=run, q = run-1; p > min; p--,q--) *p = *q;
      *min = save;
     }
   }
}



void gen_array::int_insertion_sort(GenPtr* l, GenPtr* r, GenPtr* min_stop)
{
  register GenPtr* min=l;
  register GenPtr* run;
  register GenPtr* p;
  register GenPtr* q;

  for (run = l+1; run <= min_stop; run++)
      if (*run <  *min) min = run;

  SWAP(min,l);

  if (r == l+1) return;

  for(run=l+2; run <= r; run++)
  { for (min = run-1; *run < *min; min--);
    min++;
    if (run != min) 
    { GenPtr save = *run;
      for(p=run, q = run-1; p > min; p--,q--) *p = *q;
      *min = save;
     }
   }
}




int gen_array::binary_search(GenPtr x)
{ int l = 0;
  int r = sz-1;
  int m;
  while (l<r)
  { m = (l+r)/2;
    if (cmp(x,elem(m))==0) { l = m; break; }
    if (cmp(x,elem(m)) > 0) l = m+1;
    else
    if (cmp(x,elem(m)) < 0) r = m-1;
   }

  return  (cmp(elem(l),x)==0) ? (l+Low) : (Low-1);
}

int gen_array::binary_search(GenPtr x, CMP_PTR usr_cmp)
{ int l = 0;
  int r = sz-1;
  int m;
  while (l<r)
  { m = (l+r)/2;
    if (usr_cmp(x,elem(m))==0) { l = m; break; }
    if (usr_cmp(x,elem(m)) > 0) l = m+1;
    else
    if (usr_cmp(x,elem(m)) < 0) r = m-1;
   }

  return  (usr_cmp(elem(l),x)==0) ? (l+Low) : (Low-1);
}

int gen_array::int_binary_search(GenPtr x)
{ int l = 0;
  int r = sz-1;
  int m;
  while (l<r)
  { m = (l+r)/2;
    if (x ==elem(m)) { l = m; break; }
    if (x > elem(m)) 
       l = m+1;
    else
       if (x < elem(m)) r = m-1;
   }

  return  (elem(l) == x) ? (l+Low) : (Low-1);
}



void gen_array2::init(int a, int b, int c, int d)
{ register int i,j;
  for (i=a;i<=b;i++) 
      for (j=c; j<=d; j++) init_entry(row(i)->entry(j));
}

gen_array2::gen_array2(int a, int b, int c, int d) : A(a,b) 
{ Low1  = a;
  High1 = b;
  Low2  = c;
  High2 = d;
  while (b>=a) A.entry(b--) = (GenPtr) new gen_array(c,d); 
}

gen_array2::gen_array2(int a, int b) : A(a) 
{ Low1  = 0;
  High1 = a-1;
  Low2  = 0;
  High2 = b-1;
  while (a>0) A.entry(--a) = (GenPtr) new gen_array(b); 
}

void gen_array2::clear()
{ register int i,j;
  for (i=Low1;i<=High1;i++) 
  for (j=Low2;j<=High2;j++) 
  clear_entry(row(i)->entry(j));
}

gen_array2::~gen_array2()
{ register int i;
  for (i=Low1;i<=High1;i++) delete (gen_array*)A.entry(i);
}


