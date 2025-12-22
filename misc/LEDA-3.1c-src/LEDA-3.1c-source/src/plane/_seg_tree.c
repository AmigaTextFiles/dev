/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _seg_tree.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



// ------------------------------------------------------------------
//
// full dynamic Segment Trees
//
// Michael Wenzel     (1990)
//
// Implementation as described in
// Kurt Mehlhorn: Data Structures and Algorithms 3
//
// ------------------------------------------------------------------


#include <LEDA/impl/seg_tree.h>

enum left_or_right {left = 0, right = 1};

#undef TEST
#undef DUMP

#ifdef TEST
#define DPRINT(x) cout << x
#else
#define DPRINT(x)
#endif

#ifdef DUMP
#define DDUMP(x) cout << x
#else
#define DDUMP(x)
#endif

ostream& operator<<(ostream& s, h_segment& h) 
{ 
  s<<"("<<(int)h._x0<<","<<(int)h._x1<<";"<<(int)h._y<<")";
  return s;
}

//-------------------------------------------------------------------
// member functions
//-------------------------------------------------------------------

int seg_node_tree::cmp(GenPtr x,GenPtr y) const
{ return father->seg_cmp((h_segment_p)x,(h_segment_p)y); }

// ------------------------------------------------------------
// query
// returns a List of all items it with y0 <= y(it) <= y1

list<seg_tree_item> seg_node_tree::query(GenPtr y0, GenPtr y1)
{ 
  DPRINT(" query in nodelist\n");

  list<seg_tree_item> L;
 

  h_segment_p r = father->new_y_h_segment(y0);
  seg_tree_item it = locate(r);

  if (it)
  { while ( it!=min() && father->cmp_dim2(key(it)->_y,y0)==0) it = pred(it);
    while ( it && father->cmp_dim2(key(it)->_y,y1)<=0)
    { L.append(it);
      it = succ(it);
     }
   }

  delete r;
  return L;
}


//-------------------------------------------------------------------
// all_items
// returns all items in the nodelist

list<seg_tree_item> seg_node_tree::all_items()
{
  list<seg_tree_item> L;
  seg_tree_item z;

  forall_seg_tree_items(z,*this)
    L.append(z);
  
  return L;
}


//-------------------------------------------------------------------

Segment_Tree::Segment_Tree() : r(this)  {} 
Segment_Tree::~Segment_Tree() { clear(root); }

int Segment_Tree::seg_cmp(h_segment_p p, h_segment_p q)
{ int a;
  if (a = cmp_dim2(p->y(), q->y())) return a;
  if (a = cmp_dim1(p->x0(),q->x0())) return a;
  return cmp_dim1(p->x1(), q->x1());
}

// ------------------------------------------------------------
// empty
// returns true, iff for all seg_tree_items it in nodelist(it):
//                 key(it) is not a start- or endoordinate of key(it)

int Segment_Tree::empty(bb_item it)
{
  DPRINT(" empty of "<<(int)key(it)<<"\n");
  int erg=true;
  seg_tree_item i;

  forall_seg_tree_items(i,*info(it))
    if ( (cmp(key(it),x0(i))==0) || (cmp(key(it),x1(i))==0) )
      erg = false;

  DPRINT("empty ergibt "<<erg<<"\n");
  return erg;
}   

// ------------------------------------------------------------
// lrot() , rrot() , ldrot() , rdrot()
// Rotationen am Knoten p

void Segment_Tree::lrot(bb_item p, bb_item q)
{
  bb_item h = p->sohn[right];

  DDUMP("lrot "<< (int)key(p)) ; 
    if (q) DDUMP(" Vater " << (int)key(q));
  DDUMP("\n");

  p->sohn[right] = h->sohn[left];
  h->sohn[left] = p;
  if (!q)
    root=h;
  else
  { if (cmp(key(h),key(q))>0)
      q->sohn[right]=h;
    else
      q->sohn[left]=h;
  }
  p->gr=p->sohn[left]->groesse()+p->sohn[right]->groesse();
  h->gr=p->groesse()+h->sohn[right]->groesse();

						// update nodelists
 seg_tree_item i;

 bb_item re=p->sohn[right];
 bb_item s=p->sohn[left];

 seg_node_list help = info(h);
 info(h) = info(p);

 info(p) = new seg_node_tree(this);

 forall_seg_tree_items(i,*(info(re)))
   if ( ( (!re->blatt()) 
	  ||((!start_coord(re,i))&&(!end_coord(re,i))) )
      && ( (!s->blatt())
	   ||((!start_coord(s,i))&&(!end_coord(s,i))) ) 
      && (info(s)->member(r.key(i))) )

     info(p)->insert(r.key(i));
 
 forall_seg_tree_items(i,*(info(p)))
 { info(re)->del(r.key(i));
   info(s)->del(r.key(i));
 }

 forall_seg_tree_items(i,*help)
 { info(re)->insert(r.key(i));
   info(h->sohn[right])->insert(r.key(i));
 } 

 delete help;

}

void Segment_Tree::rrot(bb_item p, bb_item q)
{
  bb_item h = p->sohn[left];

  DDUMP("rrot "<< (int)key(p)) ; 
    if (q) DDUMP(" Vater " << (int)key(q));
  DDUMP("\n");

  p->sohn[left] = h->sohn[right];
  h->sohn[right] = p;
  if (!q) root=h;
  else
  { if (cmp(key(h),key(q))>0)
      q->sohn[right] = h;
    else
      q->sohn[left] = h; }
  p->gr=p->sohn[left]->groesse()+p->sohn[right]->groesse();
  h->gr=p->groesse()+h->sohn[left]->groesse();

						// update nodelists
 seg_tree_item i;

 bb_item re=p->sohn[right];
 bb_item s=p->sohn[left];

 seg_node_list help = info(h);
 info(h) = info(p);

 info(p) = new seg_node_tree(this);
 /* forall_seg_tree_items(i,*(info(s)))
    if (info(re)->member(r.key(i)))
      info(p)->insert(r.key(i));    */
 
 forall_seg_tree_items(i,*(info(s)))
   if ( ( (!s->blatt()) 
	  ||((!start_coord(s,i))&&(!end_coord(s,i))) )
      && ( (!re->blatt())
	   ||((!start_coord(re,i))&&(!end_coord(re,i))) ) 
      && (info(re)->member(r.key(i))) )

     info(p)->insert(r.key(i));

 forall_seg_tree_items(i,*(info(p)))
 { info(re)->del(r.key(i));
   info(s)->del(r.key(i));
 }

 forall_seg_tree_items(i,*help)
 { info(s)->insert(r.key(i));
   info(h->sohn[left])->insert(r.key(i));
 } 

 delete help;

}

void Segment_Tree::ldrot(bb_item p, bb_item q)
{
  bb_item h = p->sohn[right];
  bb_item g = h->sohn[left];

  DDUMP("ldrot "<< (int)key(p)) ; 
    if (q) DDUMP(" Vater " << (int)key(q));
  DDUMP("\n");

  rrot(h,p);
  lrot(p,q);

  /*
  p->sohn[right] = g->sohn[left];
  h->sohn[left] =  g->sohn[right];
  g->sohn[left] = p;
  g->sohn[right] = h;
  if (!q) root=g;
  else
  { if (cmp(key(h),key(q))>0)
      q->sohn[right] =g ;
    else 
      q->sohn[left] = g ; }
  p->gr=p->sohn[left]->groesse()+p->sohn[right]->groesse();
  h->gr=h->sohn[left]->groesse()+h->sohn[right]->groesse();
  g->gr=p->groesse()+h->groesse();
						// update nodelists
  seg_tree_item i;

  seg_node_list help = info(g);
  info(g) = info(p);
  info(p) = new seg_node_tree(this);

  forall_seg_tree_items(i,*help)
    info(p->sohn[right])->insert(r.key(i));

  forall_seg_tree_items(i,*(info(p->sohn[left])))
    if (info(p->sohn[right])->member(r.key(i)))
      info(p)->insert(r.key(i));

  forall_seg_tree_items(i,*(info(p)))
  { info(p->sohn[left])->del(r.key(i));
    info(p->sohn[right])->del(r.key(i));
  }
  
  forall_seg_tree_items(i,*(info(h)))
    info(p->sohn[right])->insert(r.key(i));

  forall_seg_tree_items(i,*(info(h->sohn[left])))
    if (info(h->sohn[right])->member(r.key(i)))
      info(h)->insert(r.key(i));

  seg_node_list help1 = info(h->sohn[right]);
  info(h->sohn[right]) = new seg_node_tree(this);

  forall_seg_tree_items(i,*help1)
  { if (!((info(h->sohn[left]))->member(r.key(i))))
      info(h->sohn[right])->insert(r.key(i));
    else
      info(h->sohn[left])->del(r.key(i));
  }

  forall_seg_tree_items(i,*help)
    info(h->sohn[left])->insert(r.key(i));

  delete help;
  delete help1;
*/
   
}

void Segment_Tree::rdrot(bb_item p, bb_item q)

{
  bb_item h = p->sohn[left];
  bb_item g = h->sohn[right];

  DDUMP("rdrot "<< (int)key(p)) ; 
    if (q) DDUMP(" Vater " << (int)key(q));
  DDUMP("\n");

  lrot(h,p);
  rrot(p,q);

/*  p->sohn[left] = g->sohn[right];
  h->sohn[right] =  g->sohn[left];
  g->sohn[right] = p;
  g->sohn[left] = h;
  if (!q) root=g;
  else
  { if (cmp(key(h),key(q))>0)
      q->sohn[right] =g ;
    else 
      q->sohn[left] = g ; }
  p->gr=p->sohn[left]->groesse()+p->sohn[right]->groesse();
  h->gr=h->sohn[left]->groesse()+h->sohn[right]->groesse();
  g->gr=p->groesse()+h->groesse();
						// update nodelists
  seg_tree_item i;

  seg_node_list help = info(g);
  info(g) = info(p);
  info(p) = new seg_node_tree(this);

  forall_seg_tree_items(i,*help)
    info(p->sohn[left])->insert(r.key(i));

  forall_seg_tree_items(i,*(info(p->sohn[right])))
    if (info(p->sohn[left])->member(r.key(i)))
      info(p)->insert(r.key(i));

  forall_seg_tree_items(i,*(info(p)))
  { info(p->sohn[left])->del(r.key(i));
    info(p->sohn[right])->del(r.key(i));
  }
  
  forall_seg_tree_items(i,*(info(h)))
    info(p->sohn[left])->insert(r.key(i));

  forall_seg_tree_items(i,*(info(h->sohn[right])))
    if (info(h->sohn[left])->member(r.key(i)))
      info(h)->insert(r.key(i));

  seg_node_list help1 = info(h->sohn[left]);
  info(h->sohn[left]) = new seg_node_tree(this);

  forall_seg_tree_items(i,*help1)
  { if (!((info(h->sohn[right]))->member(r.key(i))))
      info(h->sohn[left])->insert(r.key(i));
    else
      info(h->sohn[right])->del(r.key(i));
  }

  forall_seg_tree_items(i,*help)
    info(h->sohn[right])->insert(r.key(i));

  delete help;
  delete help1;
*/
   
}
 

//-------------------------------------------------------------------
// insert
// insert a segment into a Segment_tree:             
// - insert x-coordinates in main tree (bb-alpha) 
//          and rotate (if necessary)
// - insert segment on nodes 
//          immediately below the paths to x-coordinates
// - insert segment into the tree of all segments

seg_tree_item Segment_Tree::insert(GenPtr x0, GenPtr x1, GenPtr y, GenPtr inf)

{
  DPRINT(" insert segment " << (int)x0 << " " << (int)x1 << " " << (int)y << " in main tree \n" );

  seg_tree_item inserted,j;

  if (!(cmp(x0,x1)))                         // empty segment
    return 0;

  copy_dim1(x0);
  copy_dim1(x1);
  copy_dim2(y);
  copy_info(inf);

  h_segment_p i = new h_segment(x0,x1,y,inf);

  if (inserted=r.lookup(i)) 
  { delete i;
    r.info(inserted)=inf;
    return inserted;
  }

  bb_item t,father,p;
  bb_item start,end;
  seg_node_list h;

				// insert start_coordinate

  if (!(start=bb_tree::lookup(x0)))        // new coordinate
  { h=new seg_node_tree(this);
    start = sinsert(x0,h);
    t=start;
  
    if (!st.empty())
    { father = st.pop();         // pop father of leaf and set nodelist
      h=new seg_node_tree(this);
      info(father) = h;
      p = succ(t); 
      if (p)
      { list<seg_tree_item> L;
        L=info(p)->all_items();
        forall(j,L)
  	{ DDUMP("Item "<<*(r.key(j))<<" in Knoten "<<(int)key(p)<<"\n");
          if (end_coord(p,j))
            info(t)->insert(r.key(j));
          else if (!start_coord(p,j))
               { info(father)->insert(r.key(j));
                 info(p)->del(r.key(j));
               }
        }
      }
    }
    
                                 // rebalancieren
    while (!st.empty())
    { t=st.pop();
      father = st.empty() ? 0 : st.top();
      t->gr++;  
      float i = t->bal();

      DDUMP("rebal cur=" << (int)key(t) << " groesse= " << t->groesse() << " bal= " << i << " in main tree\n");

      if (i < alpha)
        if (t->sohn[right]->bal()<=d) lrot(t,father);
        else ldrot(t,father);
      else if (i>1-alpha) 
             if (t->sohn[left]->bal() > d ) rrot(t,father);
             else rdrot(t,father);
    }
  }              // start coordinate inserted



				// insert end_coordinate

  if (!(end=bb_tree::lookup(x1)))   // new coordinate
  { h=new seg_node_tree(this);
    end = sinsert(x1,h);
    t=end;

    if (!st.empty())
    { father = st.pop();         // pop father of leaf and set nodelist
      h=new seg_node_tree(this);
      info(father) = h;
      p = succ(t); 
      if (p)
      { list<seg_tree_item> L;
        L=info(p)->all_items();
        forall(j,L)
  	  if (end_coord(p,j))
            info(t)->insert(r.key(j));
          else if (!start_coord(p,j))
               { info(father)->insert(r.key(j));
                 info(p)->del(r.key(j));
               }
      }
    }

                               // rebalancieren
    while (!st.empty())
    { t=st.pop();
      father = st.empty() ? 0 : st.top();
      t->gr++;  
      float i = t->bal();

      DDUMP("rebal cur=" << (int)key(t) << " groesse= " << t->groesse() << " bal= " << i << " in main tree\n");

      if (i < alpha)
        if (t->sohn[right]->bal()<=d) lrot(t,father);
        else ldrot(t,father);
      else if (i>1-alpha) 
             if (t->sohn[left]->bal() > d ) rrot(t,father);
             else rdrot(t,father);
    }
  }              // end coordinate inserted


     // insert segment into nodelists of leaves of coordinates

  info(start)->insert(i);  
  info(end)->insert(i);

  p=t=root;
  GenPtr x2,x3;

                         // same path
  while (p==t)  // start and end coordinate assigned to different leaves
  { x2=key(p);
    DDUMP(" same path " << (int)x0 << " " << (int)x1 << " " << (int)x2 << "\n");
    if ( cmp(x0,x2)<=0 ) p=p->sohn[left];
      else p=p->sohn[right];
    if ( cmp(x1,x2)<=0 ) t=t->sohn[left];
      else t=t->sohn[right];
  }
				     // now paths to lower and upper part
  while (!p->blatt())                // follow lower path
  { 
    x2=key(p);
    DDUMP(" lower path " << (int)x0 << " " << (int)x2 << "\n");
    if ( cmp(x0,x2)>0 ) 
      p=p->sohn[right];
    else
    { info(p->sohn[right])->insert(i);   // insertion into nodelist
      p=p->sohn[left];
    } 
  }

  while (!t->blatt())               // follow upper path
  { 
    x3=key(t);
    DDUMP(" upper path " << (int)x1 << " " << (int)x3 << "\n");
    if ( cmp(x1,x3)<=0 ) 
      t=t->sohn[left];
    else
    { info(t->sohn[left])->insert(i);  // insertion into nodelist
      t=t->sohn[right];
    } 
  }

#ifdef DUMP
  print_tree();
#endif

  return (r.insert(i)); 
}


//-------------------------------------------------------------------
// delete
// delete a segment in a Segment_tree:
// - delete segment out of the tree of all segments
// - delete segment on nodes 
//          immediately below the paths to x-coordinates
// - delete x-coordinates in main tree (bb-alpha) 
//          and rotate (if necessary)

void Segment_Tree::del(GenPtr x0, GenPtr x1, GenPtr y)

{
  DPRINT(" delete segment " << (int)x0 << " " << (int)x1 << " " << (int)y << " in main tree\n");

  if (!(cmp(x0,x1)))                         // empty segment
    return ;

  bb_item p,q,s,t,father;
  seg_tree_item z;
  seg_node_list help;
  h_segment_p deleted;
  h_segment_p i = new h_segment(x0,x1,y);

  if (!(t=r.lookup(i)))          // segment not in tree
  { delete i;
    DDUMP("delete: segment not in tree\n");
    return;
  }

  deleted = r.key(t);
  r.del(i);                      // delete in tree of all segments

  s=t=root;
  GenPtr x2,x3;

				 // delete segment in nodelists

  while ((s==t)&&(!s->blatt()))       // same path
  { x2=key(s);
    x3=key(t);
    DDUMP(" same path " << (int)x2 << " groesse " << s->groesse() << "\n");
    if ( cmp(x0,x2)<=0 ) s=s->sohn[left];
      else s=s->sohn[right];
    if ( cmp(x1,x3)<=0 ) t=t->sohn[left];
      else t=t->sohn[right];
  }
				     // now paths to lower and upper part
  while (!s->blatt())                // follow lower path
  { 
    x2=key(s);
    DDUMP(" lower path " << (int)x2 << " groesse " << s->groesse() << "\n");
    if ( cmp(x0,x2)>0 ) 
      s=s->sohn[right];
    else
    { info(s->sohn[right])->del(i);   // delete out of nodelist
      s=s->sohn[left];
    } 
  }
  info(s)->del(i);

  while (!t->blatt())               // follow upper path
  { 
    x3=key(t);
    DDUMP(" upper path " << (int)x3 << " groesse " << t->groesse() << "\n");
    if ( cmp(x1,x3)<=0 ) 
      t=t->sohn[left];
    else
    { info(t->sohn[left])->del(i);   // delete out of nodelist
      t=t->sohn[right];
    } 
  }
  info(t)->del(i);
				    // delete in main tree if necessary

  if(empty(s))                      // delete item of start coordinate
  {
    sdel(x0);
    if (!st.empty())                // father exists 
    { q = st.pop();                 // pop father of leaf and set nodelist

      if (!st.empty())
      { p = st.top();
	if (cmp(key(q),key(p))<=0)  // left son deleted
          p = p->sohn[left];
        else                        // right son deleted
	  p = p->sohn[right];
      } 
      else                          // root deleted 
	p = root;

                                          // set nodelist
      help = info(p);
      info(p) = info(q);

      if (p->blatt())
	forall_seg_tree_items(z,*help)
	  if ((start_coord(p,z))||(end_coord(p,z)))
	    info(p)->insert(r.key(z));

      delete help;
      delete q;
    }

    delete info(s);
    delete s;
                               // rebalancieren
    while (!st.empty())
    { p=st.pop();
      father = st.empty() ? 0 : st.top();
      p->gr--;  
      float i = p->bal();

      DDUMP("rebal cur=" << (int)key(p) << " groesse= " << p->groesse() << " bal= " << i << " in main tree \n");

      if (i < alpha)
        if (p->sohn[right]->bal()<=d) lrot(p,father);
        else ldrot(p,father);
      else if (i>1-alpha) 
             if (p->sohn[left]->bal() > d ) rrot(p,father);
  	   else rdrot(p,father);
    }
  }

  if(empty(t))                      // delete item of end coordinate
  {
    sdel(x1);
    if (!st.empty())                // father exists 
    { q = st.pop();                 // pop father of leaf and set nodelist

      if (!st.empty())
      { p = st.top();
	if (cmp(key(q),key(p))<=0)  // left son deleted
          p = p->sohn[left];
        else                        // right son deleted
	  p = p->sohn[right];
      } 
      else                          // root deleted 
	p = root;
                                          // set nodelist
      help = info(p);
      info(p) = info(q);

      if (p->blatt())
	forall_seg_tree_items(z,*help)
	  if ((start_coord(p,z))||(end_coord(p,z)))
	    info(p)->insert(r.key(z));

      delete help;
      delete q;
    }

    delete info(t);
    delete t;

                               // rebalancieren
    while (!st.empty())
    { p=st.pop();
      father = st.empty() ? 0 : st.top();
      p->gr--;  
      float i = p->bal();

      DDUMP("rebal cur=" << (int)key(p) << " groesse= " << p->groesse() << " bal= " << i << " in main tree \n");

      if (i < alpha)
        if (p->sohn[right]->bal()<=d) lrot(p,father);
        else ldrot(p,father);
      else if (i>1-alpha) 
             if (p->sohn[left]->bal() > d ) rrot(p,father);
  	   else rdrot(p,father);
    }
  }

#ifdef DUMP
  print_tree();
#endif



  clear_dim1(x0);
  clear_dim1(x1);
  clear_dim2(y);
  clear_info(inf(deleted));

  delete i;
  delete deleted;
}

//-------------------------------------------------------------------
// query
// returns all items it in the Segment_tree with
//     x0(it) <= x <= x1(it) and y0 <= y(it) <= y1
//    
// by:
// - look for x in the main tree   
//   
// - for all nodes on the path perform a query(y0,y1) on nodelists

list<seg_tree_item> Segment_Tree::query(GenPtr x, GenPtr y0, GenPtr y1)

{ 
  DPRINT("query in main tree " << (int)x << " " << (int)y0 << " " << (int)y1 << "\n");

  bb_item it;
  seg_tree_item z;
  list<seg_tree_item> L,l;

  search(x);
  if (st.empty()) return L;

  if (cmp(x,key(st.top()))==0)             // x-coordinate in tree
    while (!st.empty())
    { it = st.pop();
      l = info(it)->query(y0,y1);
      L.conc(l);
    }

  else                                     // x-coordinate not in tree
  {
     if ((cmp(x,key(bb_tree::min()))<0) || (cmp(x,key(bb_tree::max()))>0))
       return L;
   
     list<seg_tree_item> L1;
     while (!st.empty())
     { it = st.pop();
       L1 = info(it)->query(y0,y1);
       forall(z,L1)
	 if ((cmp(x,x0(z))>=0) && (cmp(x,x1(z))<=0))
	   L.append(z);
       L1.clear();
     }
  }

  return L;
}

//-------------------------------------------------------------------
// x_infinity_query
// returns a List of all items it with y0 <= y0(it) <= y1

list<seg_tree_item> Segment_Tree::x_infinity_query(GenPtr y0, GenPtr y1)
{
  return r.query(y0,y1);
}

//-------------------------------------------------------------------
// y_infinity_query
// returns a List of all items it with x0(it) <= x <= x1(it)

list<seg_tree_item> Segment_Tree::y_infinity_query(GenPtr x)
{
  bb_item it;
  seg_tree_item z;
  list<seg_tree_item> L;

  search(x);
  if (st.empty()) return L;

  if (cmp(x,key(st.top()))==0)             // x-coordinate in tree
    while (!st.empty())
    { it = st.pop();
      forall_seg_tree_items(z,*(info(it)))
      L.append(z);
    }

  else                                     // x-coordinate not in tree
  {
     if ((cmp(x,key(bb_tree::min()))<0) || (cmp(x,key(bb_tree::max()))>0))
       return L;
   
     list<seg_tree_item> L1;
     while (!st.empty())
     { it = st.pop();
       forall_seg_tree_items(z,*(info(it)))
	 if ((cmp(x,x0(z))>=0) && (cmp(x,x1(z))<=0))
	   L.append(z);
     }
  }

  return L;
}


//-------------------------------------------------------------------
// all_items
// returns all items in the tree

list<seg_tree_item> Segment_Tree::all_items()
{
  return r.all_items();
}


//-------------------------------------------------------------------
// lookup
// returns a seg_tree_item it with key(it) = (x0,x1,y) if there is one

seg_tree_item Segment_Tree::lookup(GenPtr x0, GenPtr x1, GenPtr y)
{ 
  DPRINT(" lookup in main tree " << (int)x0 << " " << (int)x1 << " " << (int)y << "\n");
  h_segment_p z = new h_segment(x0,x1,y);
  seg_tree_item i = r.lookup(z);   
  delete z;
  return i;
}


//-------------------------------------------------------------------
// clear_tree
// delete all Items and Tree of Items

void Segment_Tree::clear_tree()
{
  if (!root) return;

  clear(root);

  seg_tree_item z;
  h_segment_p q;

  forall_seg_tree_items(z,r)
  { 
    q=r.key(z);
    clear_dim1(x0(q));
    clear_dim1(x1(q));
    clear_dim2(y(q));
    clear_info(inf(q));
    delete q;
  }
  r.clear();

  first = iterator = 0;
  anzahl = 0;
}

//-------------------------------------------------------------------
// clear
// delete nodelists and nodes


void Segment_Tree::clear(bb_item& it)
{
  if (it == 0) return;
  
  if(!it->blatt())
  { clear(it->sohn[left]);
    clear(it->sohn[right]);
  }

  delete info(it);
  delete it;
  it = 0;

}

//-------------------------------------------------------------------
// print     
// prints the tree with nodelists

void Segment_Tree::print(bb_item it,string s)
{
  if (!it) return;

  seg_tree_item i;

  if (!it->blatt())
    print(it->sohn[left],s+"     ");

  cout<< s << (int)key(it) <<"\n";
  cout<< s ; 
  forall_seg_tree_items(i,*info(it))
    cout << "[" << (int)r.key(i) << "]:" << *(r.key(i)) << " ";
  newline;

  if (!it->blatt())
    print(it->sohn[right],s+"     ");
}

