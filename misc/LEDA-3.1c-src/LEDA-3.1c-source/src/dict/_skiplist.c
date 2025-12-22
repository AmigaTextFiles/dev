/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _skiplist.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


//------------------------------------------------------------------------------
//
//  skip lists 
//
//  doubly linked
//
//  S. Naeher (1992)
//
//------------------------------------------------------------------------------

 
#include <LEDA/impl/skiplist.h>

#define NODE_SIZE(l) sizeof(skiplist_node)+l*sizeof(skiplist_node*)
 
#define NEW_NODE(p,l) p=(skiplist_item)allocate_bytes(NODE_SIZE(l));p->level=l;

#define NEW_NODE_0(p,l) p=(skiplist_item)malloc(NODE_SIZE(l));p->level=l;

#define FREE_NODE(p) deallocate_bytes(p,NODE_SIZE(p->level))

#define FREE_NODE_0(p) free(p)

 
const int BitsInRandom      = 31;
const int MaxNumberOfLevels = 32;
 
skiplist::skiplist(float p) 
{ prob = p;
  randomBits = random(0,MAXINT-1);
  randomsLeft = BitsInRandom;
  level = 0;
  count = 0;

  NEW_NODE_0(header,MaxNumberOfLevels);
  NEW_NODE_0(STOP,-1);
  STOP->backward = header;
  STOP->pred = header;

  for(int i=0;i<MaxNumberOfLevels;i++) header->forward[i] = STOP;
  header->backward = 0;
  header->pred = 0;

 } 
 
skiplist::skiplist(const skiplist& L) 
{ prob = L.prob;
  randomBits = random(0,MAXINT-1);
  randomsLeft = BitsInRandom;
  level = 0;
  count = 0;

  NEW_NODE_0(header,MaxNumberOfLevels);
  NEW_NODE_0(STOP,-1);
  STOP->backward = header;
  STOP->pred = header;

  for(int i=0;i<MaxNumberOfLevels;i++) header->forward[i] = STOP;
  header->backward = 0;
  header->pred = 0;

 
  skiplist_item p = L.STOP->pred;
  while (p!= L.header) 
  { insert_at_item(header,p->key,p->inf);
    L.copy_key(p->key);
    L.copy_inf(p->inf);
    p = p->pred;
   }
 } 
 
 
skiplist& skiplist::operator=(const skiplist& L) 
{ clear();
  skiplist_item p = L.STOP->pred;
  while (p!= L.header) 
  { insert_at_item(header,p->key,p->inf);
    p = p->pred;
   }
  return *this;
 } 
 
void skiplist::clear() 
{ register skiplist_item p,q;
  p = header->forward[0];
  while(p!=STOP)
  { q = p->forward[0];
    clear_key(p->key);
    clear_inf(p->inf);
    FREE_NODE(p);
    p = q; 
   }
 level = 0;
 for(int i=0;i<MaxNumberOfLevels;i++) header->forward[i] = STOP;
 STOP->pred = header;
 count = 0;
}
 
 
 
skiplist::~skiplist() 
{ clear();
  FREE_NODE_0(header);
  FREE_NODE_0(STOP);
 }
 
 
int skiplist::randomLevel()
{  register int level = 0;
   register int b  = 0;

   if (prob==0.25)  
      // while (random() < MAXINT/4) level++;
      while (b==0)
      { b = randomBits&3;    // read next two random bits
        randomBits >>= 2;
        randomsLeft -= 2;
        if (b==0) level++;   // increase level with prob 0.25
        if (randomsLeft < 2) 
        { randomBits = random(0,MAXINT-1);
          randomsLeft = BitsInRandom;
         }
       }
   else            // user defined prob.
     while (rrandom() < prob) level++;
    
   return level;
 }
 
 
skiplist_item skiplist::search(GenPtr key, int& l) const
{ register skiplist_item p = header;
  register skiplist_item q;
  register k,c=1;
 
  if (int_type())
  { STOP->key = key;
    for(k = level; k>=0; k--)
    { q = p->forward[k];
      while (long(key) > long(q->key)) 
      { p = q;
        q = p->forward[k];
       }
      if(key==q->key && q != STOP) break;
     }
   }
  else
  { for(k = level; k>=0; k--)
    { q = p->forward[k];
      while (k==q->level && (c=cmp(key,q->key)) > 0)
      { p = q;
        q = p->forward[k];
       }
      if(c==0) break;
     }
   }
  l = k;
  return q;
 }
 

skiplist_item skiplist::locate(GenPtr key) const
{ int k;
  skiplist_item q = search(key,k);
  return (q==STOP) ? q->pred : q;
 }


skiplist_item skiplist::locate_succ(GenPtr key) const
{ int k;
  skiplist_item q = search(key,k);
  if (q==header) return min();
  if (cmp(key,q->key)!=0) q = q->forward[0];
  return (q==STOP) ? 0 : q;
 }

skiplist_item skiplist::locate_pred(GenPtr key) const
{ int k;
  skiplist_item q = search(key,k);
  if (q==STOP) return max();
  if (cmp(key,q->key)!=0) q = q->pred;
  return (q==header) ? 0 : q;
 }

 

 
skiplist_item skiplist::lookup(GenPtr key) const
{ int k;
  skiplist_item q = search(key,k);
  return (k<0) ? 0 : q;
 }


void skiplist::insert_item_at_item(skiplist_item q, skiplist_item p)
{ 
  // insert item q immediately after item p

  register skiplist_item x;
  register int k;
  q->pred = p;
  p->forward[0]->pred = q;
  for(k=0; k<=q->level; k++)
  { while (k > p->level) p = p->backward;
    x = p->forward[k];
    q->forward[k] = x;
    p->forward[k] = q;
    if (x->level == k) x->backward = q;
   }
   q->backward = p;
 }
 

skiplist_item skiplist::insert_at_item(skiplist_item p, GenPtr key, GenPtr inf)
{ register skiplist_item q;
  register int k;

  if (p != header)
  { int c = cmp(key,p->key);

    if (c == 0)
    { clear_inf(p->inf);
      copy_inf(inf);
      p->inf = inf;
      return p;
     }

    if (c<0) p = p->pred;

/*
     if (p!=min() && cmp(key,p->pred->key) <= 0)
     {  cout << "wrong position for "; print_key(key);
        newline;
        cout << " pos = "; print_key(p->key);
        newline;
        cout << " pred = "; print_key(p->pred->key);
        newline;
        error_handler(1,"skiplist::insert_at : wrong position "); 
      }
*/
   }
 
   k = randomLevel();
   if (k>level) k = ++level;
 
   NEW_NODE(q,k);
   copy_key(key);
   copy_inf(inf);
   q->key = key;
   q->inf = inf;
   count++;

   insert_item_at_item(q,p);
 
   return q;
 }


void skiplist::remove_item(skiplist_item q)
{ register int k;
  register skiplist_item p = q->backward;
  register skiplist_item x;

  for(k=q->level; k>=0; k--)
  { while (p->forward[k] != q) p = p->forward[k];
    x = q->forward[k];
    p->forward[k] = x;
    if (x->level==k) x->backward = p;
   }
  x->pred = p;
}
 
 
void skiplist::del_item(skiplist_item q)
{ remove_item(q);
  clear_key(q->key);
  clear_inf(q->inf);
  FREE_NODE(q);
  while(header->forward[level] == STOP && level > 0 ) level--;
  count --;
}

skiplist_item skiplist::insert(GenPtr key, GenPtr inf)
{ int k;
  skiplist_item p = search(key,k);
  if (p==STOP) p = p->pred;
  return insert_at_item(p,key,inf);
 }

void skiplist::del(GenPtr key)
{ int k;
  skiplist_item q = search(key,k);
  if (k>=0) del_item(q);
 }


void skiplist::reverse_items(skiplist_item p, skiplist_item q)
{ skiplist_item r;
  while (p!=q)
  { r = p;
    p = p->forward[0];
    remove_item(r);
    insert_item_at_item(r,q);
   }
 }

void skiplist::conc(skiplist&)
{ error_handler(1,"sorry, not implemented: skiplist::conc(skiplist)\n"); }

void skiplist::split_at_item(skiplist_item,skiplist&,skiplist&)
{ error_handler(1,"sorry, not implemented: skiplist::split_at_item\n"); }


void skiplist::print()
{ skiplist_item p = header;
  cout << "Level = " << level << "\n"; 
  for(;;)
  { cout << string("<%d>  ",p);
    if (p != header && p != STOP)
    { cout << "key = ";
      print_key(p->key);
     }
    newline;
    for(int k=p->level;k>=0;k--)
       cout << string("forward[%d] = %8d\n", k,p->forward[k]);
    cout << string("backward = %8d   pred = %8d\n",p->backward, p->pred);
    if (p==STOP) break;
    p = p->forward[0];
    newline;
   }
}

