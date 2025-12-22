/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  seg_tree.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_SEGMENT_TREE_H
#define LEDA_SEGMENT_TREE_H

// ------------------------------------------------------------------
//
// full dynamic Segment Trees
//
// Michael Wenzel     (1990)
//
// Implementation follows
// Kurt Mehlhorn: Data Structures and Algorithms, Vol. 3
//
// ------------------------------------------------------------------

#include <LEDA/impl/bb_tree1.h>
#include <LEDA/list.h>

// ------------------------------------------------------------------
// declarations and definitions 
// ----------------------------------------------------------------- 


class h_segment;
typedef h_segment* h_segment_p;

class seg_node_tree;
typedef seg_node_tree* seg_node_list;


typedef bb_node* seg_tree_item;
typedef list<seg_tree_item> list_seg_tree_item_;

//------------------------------------------------------------------
// class h_segment
//------------------------------------------------------------------

class h_segment {

  GenPtr _x0;
  GenPtr _x1;
  GenPtr _y;
  GenPtr _inf;

 public:

 GenPtr& x0()    { return _x0;   }
 GenPtr& x1()    { return _x1;   }
 GenPtr& y()     { return _y;    }
 GenPtr& info()  { return _inf;  }

 h_segment()
{ 
   _x0 = _x1 = _y = _inf = 0;
 }

 h_segment(GenPtr x0, GenPtr x1, GenPtr y, GenPtr i=0)
{ 
   _x0  = x0;
   _x1  = x1;
   _y   = y;
   _inf = i;
 }

 LEDA_MEMORY(h_segment)

 friend ostream& operator<<(ostream&, h_segment&);
 friend class Segment_Tree;
 friend class seg_node_tree;

};


/*------------------------------------------------------------------
   class seg_node_tree = Dictionary(seg_tree_item , void* )
-------------------------------------------------------------------*/

class seg_node_tree : public bb_tree {

public:

Segment_Tree* father;

int cmp(GenPtr x, GenPtr y) const;

list<seg_tree_item> query(GenPtr, GenPtr);
list<seg_tree_item> all_items();

int            defined(h_segment_p y)    { return bb_tree::member(Convert(y)); }
seg_tree_item  lookup(h_segment_p y)     { return bb_tree::lookup(Convert(y)); }
seg_tree_item  locate(h_segment_p y)     { return bb_tree::locate(Convert(y)); }
seg_tree_item  ord(int y)                { return bb_tree::ord(int(y)); }
seg_tree_item  insert(h_segment_p y, GenPtr i=0 )
                                 { return bb_tree::insert(Convert(y),i); } 
void del(h_segment_p y)          { delete bb_tree::del(Convert(y)); } 
void del_item(seg_tree_item it)  { del(key(it)); } 

h_segment_p& key(seg_tree_item it)   
	     { if (!it) error_handler(1,"seg_tree_item gleich nil");
               return (h_segment_p&)it->ke  ; }
GenPtr&   info(seg_tree_item it)              { return key(it)->info(); } 
void         change_inf(seg_tree_item it, GenPtr i) { key(it)->info() = i; }

seg_node_tree(Segment_Tree* p)   {father = p;}
virtual ~seg_node_tree()  {}

friend class Segment_Tree;

} ;


#define forall_seg_tree_items(a,b) for ((b).init_iterator(); a=(b).move_iterator(); )



//------------------------------------------------------------------
// class segment_tree
//------------------------------------------------------------------

class Segment_Tree  : public bb_tree {


virtual  h_segment_p new_y_h_segment(GenPtr y)
{ cout << "error: virtual new_y_h_segmentn"; y=0; return 0; }

virtual int cmp_dim1(GenPtr x,GenPtr y) {return compare(x,y);}
virtual int cmp_dim2(GenPtr x,GenPtr y) {return compare(x,y);}

virtual void clear_dim1(GenPtr&) {}
virtual void clear_dim2(GenPtr&) {}
virtual void clear_info(GenPtr&) {}
virtual void copy_dim1(GenPtr&)  {}
virtual void copy_dim2(GenPtr&)  {}
virtual void copy_info(GenPtr&)  {}

int seg_cmp(h_segment_p p, h_segment_p q);

  void lrot(bb_item , bb_item);
  void rrot(bb_item , bb_item);
  void ldrot(bb_item , bb_item);
  void rdrot(bb_item , bb_item);

  //void change_inf(bb_item it, seg_node_list i)   { info(it) = i; }

  GenPtr& key(bb_item it)       
       { if (!it) error_handler(1,"bb_item in segment_tree gleich nil");
	 return it->ke; }
  seg_node_list& info(bb_item it)    { return (seg_node_list&)(bb_tree::info(it)); } 

  int start_coord(bb_item& x,seg_tree_item& i)
      { return (!cmp(key(x),x0(i))); }
  int end_coord(bb_item& x,seg_tree_item& i)
      { return (!cmp(key(x),x1(i))); }

  int empty(bb_item);
  void clear(bb_item& );
  void print(bb_item , string); 

  protected:

  seg_node_tree r;                // tree with all segments


  int cmp_dummy(int a, int b, int c);


  public :
  
  int cmp(GenPtr, GenPtr)  const    
  { cout << "error: Segment_Tree::cmpn"; return 0; }

  GenPtr x0(seg_tree_item x)    { return (r.key(x))->_x0;  }
  GenPtr x1(seg_tree_item x)    { return (r.key(x))->_x1;  }
  GenPtr y(seg_tree_item x)     { return (r.key(x))->_y;   }
  GenPtr& inf(seg_tree_item x)  { return r.info(x);        }

  GenPtr& x0(h_segment_p x)   { return x->_x0; }
  GenPtr& x1(h_segment_p x)   { return x->_x1; }
  GenPtr& y(h_segment_p x)    { return x->_y; }
  GenPtr& inf(h_segment_p x)  { return x->_inf; }

  void change_inf(seg_tree_item x, GenPtr i)  { r.info(x) = i; }

  seg_tree_item insert(GenPtr, GenPtr, GenPtr, GenPtr i=0 );

  void del(GenPtr, GenPtr, GenPtr);
  void del_item(seg_tree_item it) { del(x0(it),x1(it),y(it)) ; }


  seg_tree_item lookup(GenPtr, GenPtr, GenPtr );
  int member(GenPtr x0, GenPtr x1, GenPtr y) { return (lookup(x0,x1,y)!=0 ) ; }

  list<seg_tree_item> query(GenPtr, GenPtr, GenPtr );
  list<seg_tree_item> x_infinity_query(GenPtr, GenPtr );
  list<seg_tree_item> y_infinity_query(GenPtr );
  list<seg_tree_item> all_items();

  void clear_tree();  

   Segment_Tree();
   virtual ~Segment_Tree();

  int size()                   { return r.size();   }
  int empty()                  { return (r.size()==0) ; }

  seg_tree_item y_min()        { return r.min();    }
  seg_tree_item y_max()        { return r.max();    }

  void init_iterator()            { r.init_iterator(); }
  seg_tree_item move_iterator()   { return r.move_iterator(); }

  void print_tree()               { print(root,"");    }


  friend class seg_node_tree;

};


//------------------------------------------------------------------
// typed segment_tree
//------------------------------------------------------------------



template <class  type1, class type2, class itype>

class _CLASSTYPE segment_tree : public Segment_Tree {

h_segment_p new_y_h_segment(GenPtr y)
{ type1 x1; type2 x2;
  Init(x1); Init(x2);
  return new h_segment(Copy(x1),Copy(x2),y);
 }

int cmp_dim1(GenPtr x,GenPtr y)
{ return compare(ACCESS(type1,x),ACCESS(type1,y)); }

int cmp_dim2(GenPtr x,GenPtr y)
{ return compare(ACCESS(type2,x),ACCESS(type2,y)); }

void clear_dim1(GenPtr& x)     { Clear(ACCESS(type1,x)); }
void clear_dim2(GenPtr& x)     { Clear(ACCESS(type2,x)); }
void clear_info(GenPtr& x)     { Clear(ACCESS(itype,x)); }

void copy_dim1(GenPtr& x)     { x=Copy(ACCESS(type1,x)); }
void copy_dim2(GenPtr& x)     { x=Copy(ACCESS(type2,x)); }
void copy_info(GenPtr& x)     { x=Copy(ACCESS(itype,x)); }

int cmp(GenPtr x, GenPtr y) const
{ return compare(ACCESS(type1,x),ACCESS(type1,y));}

public:

type1  x0(seg_tree_item it)  { return ACCESS(type1,Segment_Tree::x0(it)); }
type1  x1(seg_tree_item it)  { return ACCESS(type1,Segment_Tree::x1(it)); }
type2   y(seg_tree_item it)  { return ACCESS(type2,Segment_Tree::y(it));  }
itype inf(seg_tree_item it)  { return ACCESS(itype,Segment_Tree::inf(it));}

seg_tree_item insert(type1 x0, type1 x1, type2 y, itype i)
{ return Segment_Tree::insert(Convert(x0),Convert(x1),Convert(y),Convert(i)); }

void del(type1 x0, type1 x1, type2 y)
{ Segment_Tree::del(Convert(x0),Convert(x1),Convert(y)); }

seg_tree_item lookup(type1 x0, type1 x1, type2 y)
{ return Segment_Tree::lookup(Convert(x0),Convert(x1),Convert(y)); }

int member(type1 x0, type1 x1, type2 y)
{ return Segment_Tree::member(Convert(x0),Convert(x1),Convert(y)); }

list<seg_tree_item> query(type1 x,type2 y0,type2 y1)
{ return Segment_Tree::query(Convert(x),Convert(y0),Convert(y1)); }

list<seg_tree_item> x_infinity_query(type2 y0,type2 y1)
{ return Segment_Tree::x_infinity_query(Convert(y0),Convert(y1)); }

list<seg_tree_item> y_infinity_query(type1 x)
{ return Segment_Tree::y_infinity_query(Convert(x)); }


segment_tree()  {}
~segment_tree()
 { seg_tree_item z;
  forall_seg_tree_items(z,r)
  { type1 t1 = x0(z); Clear(t1); 
          t1 = x1(z); Clear(t1); 
    type2 t2 = y(z);  Clear(t2); 
    itype i  = inf(z); Clear(i); 
    delete r.key(z); }
 }

} ;


//------------------------------------------------------------------
// Iterator
//------------------------------------------------------------------

#define forall_seg_tree_items(a,b) for ((b).init_iterator(); a=(b).move_iterator(); )


#endif
