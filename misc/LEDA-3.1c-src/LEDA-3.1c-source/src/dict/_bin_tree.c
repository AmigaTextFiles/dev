/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _bin_tree.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



//------------------------------------------------------------------------------
//
//  bin_tree: base class for all binary tree  types
//
//  leaf oriented & doubly linked 
//
//------------------------------------------------------------------------------

#include <LEDA/impl/bin_tree.h>


bin_tree_node* bin_tree::lookup(GenPtr x) const
{ bin_tree_node* p = locate(x);
  if (p && cmp(p->k,x) == 0) return p;
  return 0;
}

void  bin_tree::change_inf(bin_tree_node* p,GenPtr y) 
{ clear_inf(p->i);
  copy_inf(y);
  p->i = y; 
 }


//------------------------------------------------------------------------------
// locate(x) : returns pointer to leave with successor or predessor key of x
//------------------------------------------------------------------------------

bin_tree_node* bin_tree::locate(GenPtr x) const
{ 
  if (count==0) return 0;
  return  int_type() ? int_search(x) : search(x);
}


//------------------------------------------------------------------------------
// locate_succ(x) : returns pointer to leave with minimal key >= x
//             nil if tree empty
//------------------------------------------------------------------------------

bin_tree_node* bin_tree::locate_succ(GenPtr x) const
{ if (count==0) return 0;
  bin_tree_node* p =  int_type() ? int_search(x) : search(x);
  return (cmp(x,p->k) > 0) ? succ(p) : p ;
 }



//------------------------------------------------------------------------------
// locate_pred(x) : returns pointer to leave with maximal key <= x
//                  nil if tree empty
//------------------------------------------------------------------------------

bin_tree_node* bin_tree::locate_pred(GenPtr x) const 
{ if (count==0) return 0;
  bin_tree_node* p =  int_type() ? int_search(x) : search(x);
  return (cmp(x,p->k) < 0) ? pred(p) : p ;
 }



//------------------------------------------------------------------------------
// search(x) : returns pointer to leave with minimal key >= x
//------------------------------------------------------------------------------

bin_tree_node* bin_tree::search(GenPtr x) const
{
  bin_tree_node* p = root();

  while (p->is_node())
       p = (cmp(x,p->k) <= 0) ? p->child[left] : p->child[right];

  return p;
 }



//------------------------------------------------------------------------------
// int_search : search for integer key 
//------------------------------------------------------------------------------

bin_tree_node* bin_tree::int_search(GenPtr x) const
{
  bin_tree_node* p = root();

  while (p->is_node())
       p = (long(x) <= long(p->k)) ? p->child[left] : p->child[right];

  return p;
 }



//------------------------------------------------------------------------------
// insert(x,y,ii):
// inserts new leaf with key x and info y, sets info of new inner node to ii
// returns pointer to the new leaf
//------------------------------------------------------------------------------

bin_tree_node* bin_tree::insert( GenPtr x, GenPtr y, GenPtr ii)
{  
  // key x, inf y, iinf ii

  bin_tree_node* p;

   if (count==0)  // tree is empty 
     { copy_key(x);
       copy_inf(y);
       p = new bin_tree_node(x,y,leaf_balance());
       p->corr = &ROOT;
       ROOT.i = ii;
       min_ptr() = p;
       root() = p;
       p->parent = &ROOT;
       p->child[right] = p;
       p->child[left] = p;
       count = 1;
     }
   else
     { p = (int_type()) ? int_search(x) : search(x);
       p = insert_at_item(p,x,y,ii);
      }

   return p ;
 }



bin_tree_node* bin_tree::insert_at_item(bin_tree_node* p, GenPtr x, GenPtr y, 
                                                                    GenPtr ii)
{

   bool insert_left;  //  true <==> insert new leaf q to the left of p

   copy_inf(y);
                   
   if ( int_type() )
     { if ( long(x) == long(p->k) ) // x already stored in tree, overwrite info
       { clear_inf(p->i);
         p->i = y;
         return p;
        }
       insert_left = (long(x) < long(p->k));
      }
   else
      { int c = cmp(x,p->k);
        if ( c == 0 )
        { clear_inf(p->i);
          p->i = y;
          return p;
         }
        insert_left = (c < 0);
        copy_key(x);
       }

   int b = (count==1) ? root_balance() : node_balance();

   count++;

   bin_tree_node* q = new bin_tree_node(x,y,leaf_balance()); // new leaf
   bin_tree_node* r = new bin_tree_node(0,0,b);              // new inner node
   bin_tree_node* u = p->parent; 

   q->parent = r;
   p->parent = r;
   r->parent = u;
   r->corr = nil;


   if (p == u->child[left])
      u->child[left] = r;
   else
      u->child[right] = r;

   // insertion of q, adjusting key & inf of corresponding inner nodes,
   // double-chaining with neighbors, checking min pointer, ...

   if (insert_left) // insert q left of p
      { r->k = x;
        q->corr = r;
        r->i = ii;
        r->child[left] = q;
        r->child[right]= p;
        u = p->child[left];
        q->child[left]  = u;
        q->child[right] = p;
        u->child[right] = q;
        p->child[left]  = q;
        if ( p == min_ptr() ) min_ptr() = q;     
       }
    else         // insert q right of p
      { bin_tree_node* pc = p->corr; 
        r->k = p->k;
        r->i = pc->i;
        pc->i = ii;
        q->corr = pc;
        p->corr = r;
        r->child[left] = p;
        r->child[right]= q;
        u = p->child[right];
        q->child[left]  = p;
        q->child[right] = u;
        u->child[left] = q;
        p->child[right] = q;
       }

    propagate_modification(1,r,p);
    propagate_modification(2,r,q);

    if (r != root()) insert_rebal(r);

    return q;

}



//------------------------------------------------------------------------------
// del(x) 
// removes leaf with key x from the tree
// overwrites possible copy of x in an inner node (if key type is not integer)
//------------------------------------------------------------------------------

void bin_tree::del(GenPtr x)
{
  bin_tree_item v;

  if (count == 0) return;  // tree is empty

  if ( int_type() )
    { v = int_search(x);
      if (long(v->k) == long(x)) del_item(v);
     }
  else
    { v = search(x);
      if ( cmp(v->k,x) == 0 ) del_item(v);
     }


 }


void bin_tree::del_item(bin_tree_item v)
{
  bin_tree_item w;
  bin_tree_item p = v->parent;
  bin_tree_item u = v->corr;

  clear_key(v->k);
  clear_inf(v->i);

  // overwrite copy of key in corresponding inner node u by its predecessor,
  // but keep its information (not necessary in the case that v is a left child)

  if (v != p->child[left]) 
  { bin_tree_node* pred =  v->child[left];
    u->k = pred->k;
    clear_iinf(pred->corr->i);
    pred->corr = u;
  }
  else
    clear_iinf(u->i);

  count--;
 
  if (count == 0)      // tree is now empty
  { root() = min_ptr() = nil;
    delete v;
    return;
   } 


  bin_tree_node* pred = v->child[left];
  bin_tree_node* succ = v->child[right];

  // link neighbors
  pred->child[right] = succ; 
  succ->child[left] = pred;

  // adjust min pointer
  if ( v == min_ptr() ) min_ptr() = succ;


  // replace p by sibling w of v

  u = p->parent;
  w = p->child[left];
  if (v == w) w =  p->child[right];
  w->parent = u;
  if (p == u->child[left])
     u->child[left] = w;
  else
     u->child[right] = w;

                                //     u             u            u
                                //     |             |            |
                                //     p     or      p    --->    w
                                //    / \           / \
                                //   v   w         w   v

  propagate_modification(3,u,w);

  // rebalance tree, if necessary

  if (w != root()) del_rebal(w,p);

  delete v;
  delete p;

}


//------------------------------------------------------------------
// concatenate
//------------------------------------------------------------------

bin_tree& bin_tree::conc(bin_tree&) 
{ error_handler(1,"sorry, bin_tree::conc not implemented"); 
  return *this;
 }

//------------------------------------------------------------------
// split at item
//------------------------------------------------------------------

void bin_tree::split_at_item(bin_tree_node*,bin_tree&,bin_tree&) 
{ error_handler(1,"sorry, bin_tree::split_at_item not implemented"); }


//------------------------------------------------------------------
// reverse items
//------------------------------------------------------------------

void bin_tree::reverse_items(bin_tree_node* v, bin_tree_node* w)
{
  bin_tree_node* l = v;
  bin_tree_node* r = w;

  while (l != r && r->child[right] != l) 
  {
    bin_tree_node* pl = l->parent;
    bin_tree_node* pr = r->parent;
    bin_tree_node* cl = l->corr;
    bin_tree_node* cr = r->corr;


    // exchange l and r

   if (pl == pr)
     { pl->child[left] = r;
       pl->child[right] = l;
      }
   else
     { if (l == pl->child[left])
          pl->child[left] = r;
       else
          pl->child[right] = r;
    
       r->parent = pl;
    
       if (r == pr->child[left])
          pr->child[left] = l;
       else
          pr->child[right] = l;
    
       l->parent = pr;
      }
  

   // update corresponding inner nodes

   l->corr = cr;
   cr->k = l->k;

   r->corr = cl;
   cl->k = r->k;

   l = l->child[right]; 
   r = r->child[left];

  }

  // reverse chaining of leaves v...w

  if (count > 2)
  { l = v->child[left];
    r = w->child[right];
  
    r->child[left] = v;
  
    bin_tree_node* p = v; 
  
    while(p != w)
    { bin_tree_node* q = p->child[right];
      p->child[left] = q;
      p = q;
     }
  
    w->child[left] = l;
  
    p = r;
  
    while ( p != l )
    { bin_tree_node* q = p->child[left];
      q->child[right] = p;
      p = q;
     }
   }
  

  // adjust min pointer
  
  if (v == min_ptr()) min_ptr() = w;

 }


//------------------------------------------------------------------
// operator=
//------------------------------------------------------------------

bin_tree& bin_tree::operator=(const bin_tree& t)
{
   if (this == &t) return *this;

   clear();

   if ( t.root() )   
   { bin_tree_node* pre = 0;
     root() = t.copy_tree(t.root(),pre);
     root()->parent = &ROOT;
     pre->corr = &ROOT;
     ROOT.i = t.ROOT.i;
     min_ptr() = root();
     while (min_ptr()->child[left]) min_ptr() = min_ptr()->child[left];
     min_ptr()->child[left] = pre;
     pre->child[right] = min_ptr();
     count = t.count;
   }

   return *this; 
}

//------------------------------------------------------------------
// copy constructor
//------------------------------------------------------------------

  bin_tree::bin_tree(const bin_tree& t)
  { root()  = min_ptr() = 0 ;
    count = t.count; 
    if ( t.root() ) 
    { bin_tree_node* pre = 0;
      root() = t.copy_tree(t.root(),pre);
      min_ptr() = root();
      root()->parent = &ROOT;
      while (min_ptr()->child[left]) min_ptr() = min_ptr()->child[left];
      min_ptr()->child[left] = pre;
      pre->child[right] = min_ptr();
     }
  }


//------------------------------------------------------------------
// copy_tree(p) makes a copy of tree with root p and returns a pointer to the
// root of the copy. pre is last created leaf ( leaves are created from left 
// to right).
//------------------------------------------------------------------

bin_tree_node* bin_tree::copy_tree( bin_tree_node* p, bin_tree_item& pre) const
{
  bin_tree_node* q = new bin_tree_node(p);  // q = p

  if ( p->is_node() )  // internal node: copy subtrees 
  {
    q->child[left] = copy_tree(p->child[left],pre);
    pre->corr = q;
    q->child[right] = copy_tree(p->child[right],pre);
    q->child[left]->parent = q;
    q->child[right]->parent = q;
  }
  else   //leaf: chaining with last created leaf "pre"
  {
    copy_key(q->k);
    copy_inf(q->i);

    if (pre) pre->child[right] = q; 
    q->child[left] = pre;
    pre = q;

   }

  return q;
}

//------------------------------------------------------------------
// clear
//------------------------------------------------------------------

void bin_tree::clear() 
{
   if ( root() )
   { del_tree(root());
     root() = min_ptr() = 0;
     count = 0;
   }
}

//------------------------------------------------------------------
// del_tree(p) : deletes subtree rooted at node p
//------------------------------------------------------------------

void bin_tree::del_tree(bin_tree_node* p)
{
  if ( p->is_node() )
  { del_tree(p->child[left]);
    del_tree(p->child[right]);
   }
  else
  { clear_key(p->k);
    clear_inf(p->i);
    clear_iinf(p->corr->i);
   }

  delete p;
}




//----------------------------------------------------------------------------
// printing and drawing trees
//----------------------------------------------------------------------------

void bin_tree::print() const
{ 
  cout << endl;
  cout << "size = " << size() << endl;

  if ( root() ) print_tree(root(),1);

  register bin_tree_node* q = max() ;

  if( q ) {
    newline; 
    print_inf( inf(q) ) ;

    while( (q=pred(q)) ) { 
      print_inf( inf(q->corr) ) ;
      print_inf( inf(q) ) ;
    }
  }
  newline;
}


void bin_tree::print_tree(bin_tree_node* p,int h) const
{  
  if ( p->is_node() ) print_tree(p->child[right],h+1);

 for( int j=1; j <= h ; j++ ) cout << "     ";

 print_key(key(p));
 cout << " (" << p->get_bal() <<")";

 if ( p->is_leaf() )
 { cout << "[" << int(p) << "] ";  
   cout << " succ[" << int(p->child[right]) << "] ";  
   print_key(key(p->child[right]));
   cout << " pred[" << int(p->child[left]) << "] "; 
   print_key(key(p->child[left]));
   newline;
 }
 else cout << "\n";

 if ( p->is_node() ) print_tree(p->child[left],h+1);
}

        

void bin_tree::draw(DRAW_BIN_NODE_FCT draw_node,
                    DRAW_BIN_NODE_FCT draw_leaf,
                    DRAW_BIN_EDGE_FCT draw_edge, 
                    double x1, double x2, double y, double ydist)
{ 
  // draw a picture of the tree using the functions
  // draw_node(x,y,k,b)   draws node with key k and balance b at (x,y)
  // draw_leaf(x,y,k,b)   draws leaf with key k and balance b at (x,y)
  // draw_edge(x,y,x',y') draws an edge from (x,y) to (x',y')

  draw(draw_node,draw_leaf,draw_edge,root(),x1,x2,y,ydist,0); 
 }



void bin_tree::draw(DRAW_BIN_NODE_FCT draw_node,
                    DRAW_BIN_NODE_FCT draw_leaf,
                    DRAW_BIN_EDGE_FCT draw_edge, 
                    bin_tree_node* r, 
                    double x1, double x2, double y, 
                    double ydist, double last_x)
{ 
  // draw subtree rooted at r

  double x = (x1+x2)/2;

  if (r==nil) return;

  if (last_x != 0) draw_edge(last_x,y+ydist,x,y);

  if (r->is_node()) 
     { draw_node(x,y,r->k,r->get_bal());
       draw(draw_node,draw_leaf,draw_edge, r->child[0],x1,x,y-ydist,ydist,x);
       draw(draw_node,draw_leaf,draw_edge, r->child[1],x,x2,y-ydist,ydist,x);
      }
  else
     draw_leaf(x,y,r->k,r->get_bal());
}


