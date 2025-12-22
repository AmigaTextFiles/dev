/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  pers_tree.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_PERS_TREE_H
#define LEDA_PERS_TREE_H

#include <LEDA/basic.h>
#include <LEDA/list.h>

typedef void (*DRAW_NODE_FCT)(double,double,void*);
typedef void (*DRAW_EDGE_FCT)(double,double,double,double);

/* implementation of a node of the ephemeral red-black tree of a specific
 * persistent  node, where the colors of that persistent node through the
 * various versions can be found
 */

class pers_tree_node;
class C_pers_tree_node;
class F_pers_tree_node;
class VER_pers_tree_node;

typedef list_item Version;

 
class C_pers_tree_node
{
  friend class pers_rb_tree;

  Version vers_stamp;
  C_pers_tree_node* c_link[3];
  int c_right;
  int c_color;
  int col_value;

  LEDA_MEMORY(C_pers_tree_node)
};

/* implementation of a node of the  ephemeral red-black tree of a specific
 * persistent node, where the children of that persistent node through the
 * various versions can be found
 */
 
class F_pers_tree_node
{
  friend class pers_rb_tree;

  Version ver_stamp;
  F_pers_tree_node* f_link[3];
  int f_right;
  int f_color;
  pers_tree_node* poin_value;

  LEDA_MEMORY(F_pers_tree_node)
};


/* implementation of a persistent node */

class pers_tree_node
{
  friend class pers_rb_tree;

  void *key;
  void *info;
  pers_tree_node *parent;
  int right;
  int is_leaf;
  F_pers_tree_node *link[2];
  C_pers_tree_node *red;
  F_pers_tree_node *copy;

  pers_tree_node* next;  // linking all used pers_tree_nodeS

  LEDA_MEMORY(pers_tree_node)
};

/* implementation of a node (or member) of the version list */

class VER_pers_tree_node
{ 
  friend class pers_rb_tree;

  pers_tree_node*  acc_pointer;
  int    popul;
  double ser_num;

  LEDA_MEMORY(VER_pers_tree_node)
};

typedef VER_pers_tree_node* ver_node;



struct V_LIST {

list<ver_node> vl;
int count;
pers_tree_node* used;

};



class pers_rb_tree {

protected:

V_LIST* v_list;

virtual int cmp_keys(GenPtr x, GenPtr y) { return compare(x,y); }
virtual void print_key(GenPtr x) { Print(x); }
virtual void copy_key(GenPtr&)   {}
virtual void copy_inf(GenPtr&)   {}
virtual void clear_key(GenPtr&)  {}
virtual void clear_inf(GenPtr&)  {}

 
pers_tree_node* child(int leftright, pers_tree_node *p, Version i)
{ return(acc_step(p->link[leftright], i)); }

void* get_key(pers_tree_node *p, Version i)
{ return (acc_step(p->copy, i))->key; }

int isleaf(pers_tree_node *p) 
{ //return (p == p->link[0]->poin_value); 
  return p->is_leaf;
 }
  
pers_tree_node* sibling(pers_tree_node *p, Version i)
{ return acc_step(p->parent->link[1 - p->right], i); } 


/* define the order of versions in the version list */
int vless(Version x, Version y)    
{ return  (v_list->vl[x]->ser_num < v_list->vl[y]->ser_num); }

/* find the next to a given version in the version list */ 
Version  iplus(Version i)
{ return v_list->vl.succ(i); }


pers_tree_node*   acc_step(F_pers_tree_node *, Version);
Version new_version(Version);
void    m_b_root(Version);

F_pers_tree_node* f_nleaf(pers_tree_node*, Version);
F_pers_tree_node* f_nnode(F_pers_tree_node*, F_pers_tree_node*);
F_pers_tree_node* f_rbsearch(F_pers_tree_node* p, Version);
void    f_rbclear(F_pers_tree_node*);
int     f_insert(F_pers_tree_node*, pers_tree_node*, Version);
void    f_single_rot(F_pers_tree_node*, int);
void    f_double_rot(F_pers_tree_node*, int);

C_pers_tree_node* c_nleaf(int, Version);
C_pers_tree_node* c_nnode(C_pers_tree_node*, C_pers_tree_node*);
C_pers_tree_node* c_rbsearch(C_pers_tree_node* p, Version);
void    c_rbclear(C_pers_tree_node*);
int     c_insert(C_pers_tree_node*, int, Version);
void    c_single_rot(C_pers_tree_node*, int);
void    c_double_rot(C_pers_tree_node*, int);

pers_tree_node*   single_rot(pers_tree_node* top_node, int dir, Version i);
pers_tree_node*   double_rot(pers_tree_node* top_node, int dir, Version i);
pers_tree_node*   newnode(pers_tree_node* c1, pers_tree_node* c2, Version i);
pers_tree_node*   newleaf(void* val, void* inf, pers_tree_node*, pers_tree_node*, Version i);
int     isred(pers_tree_node* p, Version i);
void    up_col(C_pers_tree_node* p, int newvalue, Version i);
void    update(F_pers_tree_node* p, pers_tree_node* newvalue, Version i);

pers_tree_node*   search(void* val, Version i)     { pers_tree_node* p; return search(val,p,i);}
pers_tree_node*   search(void*, pers_tree_node*&, Version);


public:

 pers_rb_tree() {}
virtual ~pers_rb_tree() {}

void init_tree();

void* key(pers_tree_node* p)  { return p->key; }
void* inf(pers_tree_node* p)  { return p->info; }

Version copy_version(Version);
void    del_version(Version);

Version del(void*, Version);
Version insert(void*, void*, Version);
Version change_inf(pers_tree_node*,void*,Version);

pers_tree_node* lookup(void *val,Version v);
pers_tree_node* locate(void *val,Version v);
pers_tree_node* locate_pred(void *val,Version v);
pers_tree_node* min(Version v);
pers_tree_node* max(Version v);
pers_tree_node* succ(pers_tree_node* p, Version v) { return child(1,p,v); }
pers_tree_node* pred(pers_tree_node* p, Version v) { return child(0,p,v); }

int   size(Version v) { return v_list->vl[v]->popul; }

double ver_num(Version v)  { return v_list->vl[v]->ser_num; }

void print(pers_tree_node*,Version);

void del_tree();

void print(Version v) 
{ //cout << form("%5f : ",v_list->vl[v]->ser_num);
  print(v_list->vl[v]->acc_pointer,v);
  newline;
 }

void draw(DRAW_NODE_FCT,DRAW_EDGE_FCT, Version, pers_tree_node*, double, double, double, double, double);

void draw(DRAW_NODE_FCT,DRAW_EDGE_FCT, Version, double, double, double, double);

};


#endif

