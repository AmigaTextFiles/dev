/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _bin_heap.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/impl/bin_heap.h>

//------------------------------------------------------------------------------
// bin_heap: binary heaps  
//           (compressed representation with array doubling)
//
// S. Naeher (1993)
//
//------------------------------------------------------------------------------



#define KEY(i)   (HEAP[i]->key)
#define INF(i)   (HEAP[i]->inf)


bin_heap::bin_heap(int n)  
{ if (n <= 0) 
     error_handler(1,string("bin_heap constructor: illegal size = %d",n));
  HEAP = new bin_heap_item[n];
  for(int i = 0; i < n; i++) HEAP[i] = nil;
  count = 0; 
  max_size = n-2;  // sometimes we use HEAP[0], HEAP[count+1] as stoppers
}

bin_heap::bin_heap(const bin_heap& H)
{ max_size = H.max_size;
  count = H.count; 
  HEAP = new bin_heap_item[max_size+2];
  for(int i = 1; i <= count; i++) 
  { HEAP[i] = new bin_heap_elem(H.HEAP[i]->key, H.HEAP[i]->inf,i);
    H.copy_key(HEAP[i]->key);
    H.copy_inf(HEAP[i]->inf);
  }
}

bin_heap& bin_heap::operator=(const bin_heap& H)
{ clear();
  delete HEAP;
  max_size = H.max_size;
  count = H.count; 
  HEAP = new bin_heap_item[max_size+2];
  for(int i = 1; i <= count; i++) 
  { HEAP[i] = new bin_heap_elem(H.HEAP[i]->key, H.HEAP[i]->inf,i);
    copy_key(HEAP[i]->key);
    copy_inf(HEAP[i]->inf);
  }
  return *this;
}

bin_heap::~bin_heap()  
{ clear();
  delete HEAP; 
}

void bin_heap::clear()
{ for(int i=1; i <= count; i++) 
  { clear_key(KEY(i));
    clear_inf(INF(i));
    delete HEAP[i];
   }
  count = 0;
}


void bin_heap::rise(int pos, bin_heap_item it)
{ 
  HEAP[0] = it;  // use "it" as stopper

  register int  pi = pos/2;                     // parent index
  register bin_heap_item parent = HEAP[pi];     // parent node


  if (int_type())
     while(parent->key > it->key)
     { HEAP[pos] = parent;
       parent->index = pos;
       pos = pi;
       pi >>= 1;
       parent = HEAP[pi];
      }
  else
     while (cmp(parent->key,it->key) > 0)
     { HEAP[pos] = parent;
       parent->index = pos;
       pos = pi;
       pi >>= 1;
       parent = HEAP[pi];
      }

  HEAP[pos] = it;
  it->index = pos;
}


void bin_heap::sink(int pos, bin_heap_item it)
{ 
  register int ci = 2*pos;       // child index

  register bin_heap_item child;  // child node


  HEAP[count+1] = HEAP[count];   // stopper

  if (int_type())
     while (ci <= count)
     { child = HEAP[ci];
       if (KEY(ci+1) < child->key) child = HEAP[++ci];
       if (it->key > child->key) 
       { HEAP[pos] = child;
         child->index = pos;
         pos = ci;
         ci <<= 1;
        }
       else break;
      }
  else
     while (ci <= count)
     { child = HEAP[ci];
       if (ci < count && cmp(KEY(ci+1),child->key) < 0) child = HEAP[++ci];
       if (cmp(it->key,child->key)>0) 
       { HEAP[pos] = child;
         child->index = pos;
         pos = ci;
         ci <<= 1;
        }
       else break;
      }

  HEAP[pos] =it;
  it->index = pos;
}



void bin_heap::decrease_key(bin_heap_item it, GenPtr k)
{ if (cmp(it->key,k)<0) 
       error_handler(1,"bin_heap: key too large in decrease_key");
  clear_key(it->key);
  copy_key(k);
  it->key = k;
  rise(it->index, it);
}


bin_heap_item bin_heap::insert(GenPtr k, GenPtr i) 
{ 
  bin_heap_item* H;

  if (count == max_size)  // resize
  { // max_size *= 2;     // double array
    max_size += 1024;
    H = new bin_heap_item[max_size+2];
    for(int i=1; i<= count; i++) H[i] = HEAP[i];
    delete HEAP;
    HEAP = H;
   }

  count++;
  copy_key(k);
  copy_inf(i);
  bin_heap_item it = new bin_heap_elem(k,i,count);
  rise(count,it);

  return it;
}




void bin_heap::del_item(bin_heap_item it)
{ bin_heap_item p = HEAP[count];

  HEAP[count] = nil;

  count--;

  if (it != p)
  { if (cmp(p->key,it->key) > 0)
       sink(it->index, p);
    else
       rise(it->index, p);
   }

  clear_key(it->key);
  clear_inf(it->inf);

  delete it;
}


void bin_heap::change_inf(bin_heap_item it, GenPtr i) 
{ clear_inf(it->inf);
  copy_inf(i);
  it->inf = i; 
 }

void bin_heap::print()
{ cout << "size = " << count << endl;
  for(int i=1;i<=count;i++) 
  { print_key(KEY(i));
    cout << "-";
    print_inf(INF(i));
    cout << "  ";
   }
  newline;
}

