/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  ab_tree.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_AB_TREE_H
#define LEDA_AB_TREE_H

//------------------------------------------------------------------------------
//
// (a,b)-trees 
//
// Evelyn Haak, Juergen Dedorath, and Dirk Basenach   (1989)
//
// Implementation follows
// Kurt Mehlhorn : "Data Structures and Algorithms 1", section III, 5.2 - 5.3
//
// Modifications:
// -------------
//
// - member-function insert_at_item added  ( Michael Wenzel , Nov. 89)
//
// - virtual compare function ( Michael Wenzel , Nov. 89)
//
// - delete : overwrite copies of inner nodes by
//            following links between different
//            instances of the same key    ( Michael Wenzel , Jan. 90)
//
// - virtual clear functions  ( S. Naeher, Mai 90)
//
//------------------------------------------------------------------------------

#include    <LEDA/basic.h>

//------------------------------------------------------------------------------
//  some declarations
//------------------------------------------------------------------------------


class ab_tree;
class ab_tree_node;

typedef ab_tree_node* abnode;

typedef ab_tree_node* ab_tree_item;


/*------------------------------------------------------------*/
/*  class ab_tree_node                                        */
/*------------------------------------------------------------*/

class ab_tree_node {
  friend class ab_tree;

  friend void concat(ab_tree& s1,ab_tree& s2,ab_tree_node* current,GenPtr cur_key);
  friend void pr_ab_tree(ab_tree_node* localroot,int blancs);
  friend void del_ab_tree(ab_tree_node* localroot);

 
  int p;           /* number of sons,a<=p<=b,0 iff leave*/
  int height;      /* height of node*/
  int index;       /* v is index'th son of his father*/
  ab_tree_node* father;   
  GenPtr* k;    /* array[1..b] --------------------------  */
                         //-----------------------------------
                         /*to every node v of T we assign p(v)-1 */
                         /*elements k[1](v),...,k[p(v)-1](v) of U*/
                         /* such that for all i (1<i<p(v)-1):*/
                         /* k[i](v) < k[i+1](v) and for all leaves*/
                         /* w in the i-th subtree of v we have*/
                         /* k[i-1] < key[w] <= k[i](v) */
                         /*------------------------------------*/
                         /* if v is a leave ==> k[1]=key[v]*/

                         
  ab_tree_node** son;    /* array [1..b+1] of pointer to sons*/
  ab_tree_node** same;   /* m.w. : links between same keys */
                         /* array [1..b]                   */
  GenPtr inf;

/* size = 8 words  */

public:

  ab_tree_node(int p,int height,int index,ab_tree_node* father,int b);

 ~ab_tree_node();

  LEDA_MEMORY(ab_tree_node)

 }; 
  
/*-----------------------------------------------------------------*/
class ab_tree   
   {

    friend class ab_tree_node;

    friend void concat(ab_tree&,ab_tree&,ab_tree_node*,GenPtr); 


    friend void pr_ab_tree(ab_tree_node* localroot,int blancs);
    friend void del_ab_tree(ab_tree_node* localroot);

    int a;
    int b;

    int height;             /* height of tree   */
    int count;              /* number of leaves */

    ab_tree_node* root;
    ab_tree_node* minimum;  
    ab_tree_node* maximum;

    ab_tree_node* expand(ab_tree_node* v,int i);

    void split_node(ab_tree_node* v);
    void share(ab_tree_node* v,ab_tree_node* y,int direct);
    void fuse (ab_tree_node* v,ab_tree_node* w);
    void del_tree(ab_tree_node* localroot);
    void exchange_leaves(ab_tree_node*, ab_tree_node*);
    void pr_ab_tree(ab_tree_node*,int) const;



    ab_tree_node* copy_ab_tree(ab_tree_node*,abnode&,int) const;

    virtual int cmp(GenPtr x, GenPtr y) const { return compare(x,y); }
    virtual void clear_key(GenPtr&) const {}
    virtual void clear_inf(GenPtr&) const {}
    virtual void copy_key(GenPtr&)  const {}
    virtual void copy_inf(GenPtr&)  const {}
    virtual void print_key(GenPtr)  const {}
    virtual void print_inf(GenPtr)  const {}

protected:
 ab_tree_item item(void* p) const { return ab_tree_item(p); }


public:



    void clear();

    GenPtr  inf(ab_tree_node* p)  const { return p->inf; }
    GenPtr  key(ab_tree_node* p)  const { return p->k[1]; }

    ab_tree_node* insert(GenPtr, GenPtr);
    ab_tree_node* insert_at_item(ab_tree_node*, GenPtr, GenPtr);
    ab_tree_node* locate(GenPtr) const;
    ab_tree_node* locate_succ(GenPtr) const;
    ab_tree_node* locate_pred(GenPtr) const;
    ab_tree_node* lookup(GenPtr) const;

    void del(GenPtr);
    void del_item(ab_tree_node*);
    void change_inf(ab_tree_node*, GenPtr);
    void reverse_items(ab_tree_node*, ab_tree_node*);

    ab_tree& conc(ab_tree&);
    void split_at_item(ab_tree_node* w,ab_tree& L,ab_tree& R);

    void del_min()                 { if (minimum) del_item(minimum); }
    void decrease_key(ab_tree_node* p, GenPtr k) { GenPtr i = p->inf;
                                                copy_key(i);
                                                del_item(p);
                                                insert(k,i);
                                                clear_key(i);
                                               }


    bool member(GenPtr k)  const { return (lookup(k))? true: false ; }

    ab_tree_node* min()                      const { return minimum; }
    ab_tree_node* find_min()                 const { return minimum; }
    ab_tree_node* max()                      const { return maximum; }
    ab_tree_node* first_item()               const { return minimum; }
    ab_tree_node* next_item(ab_tree_node* p) const { return p->son[2]; }
    ab_tree_node* succ(ab_tree_node* p)      const { return p->son[2]; }
    ab_tree_node* pred(ab_tree_node* p)      const { return p->son[1]; }

    int  size()  const { return count;       }
    bool empty() const { return (count==0) ? true : false;   }
    void print() const { pr_ab_tree(root,1); }

    ab_tree(int a_=2,int b_=4); 
    ab_tree(const ab_tree& T);

    ab_tree& operator=(const ab_tree&);
 
    virtual ~ab_tree(){ clear(); }
 };

#endif
