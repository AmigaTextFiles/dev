/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  p_dictionary.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_P_DICTIONARY_H
#define LEDA_P_DICTIONARY_H

#include <LEDA/impl/pers_tree.h>


typedef pers_tree_node* p_dic_item;



template <class ktype,class itype>

class _CLASSTYPE PERS_DIC: public pers_rb_tree, public handle_rep {

void copy_key(GenPtr& x)   { x=Copy(ACCESS(ktype,x)); }
void copy_inf(GenPtr& x)   { x=Copy(ACCESS(itype,x)); }
void clear_key(GenPtr& x)  { Clear(ACCESS(ktype,x)); }
void clear_inf(GenPtr& x)  { Clear(ACCESS(itype,x)); }
void print_key(GenPtr x)   { Print(ACCESS(ktype,x)); }
void print_inf(GenPtr x)   { Print(ACCESS(itype,x),cout); }

int  cmp_keys(GenPtr x, GenPtr y)
             { return compare(ACCESS(ktype,x),ACCESS(ktype,y)); }

Version V;

public:

 PERS_DIC() { init_tree(); V = v_list->vl.first(); }
 PERS_DIC(V_LIST* vl,Version v) { v_list=vl; V=v;  }
 void CLEAR() { if (--v_list->count==0) del_tree(); }
~PERS_DIC() { CLEAR(); }

PERS_DIC(const PERS_DIC<ktype,itype>& D)
{ v_list = D.v_list; v_list->count++; V = D.V; count = D.count; }

PERS_DIC<ktype,itype>& operator=(PERS_DIC<ktype,itype>& D)
{ CLEAR(); v_list = D.v_list; v_list->count++; V = D.V; count = D.count;
  return *this; }

ktype  key(p_dic_item p) { return ACCESS(ktype,pers_rb_tree::key(p)); }
itype inf(p_dic_item p)  { return ACCESS(itype,pers_rb_tree::inf(p)); }

p_dic_item locate(ktype k) { return pers_rb_tree::locate(Convert(k),V); }
p_dic_item locate_pred(ktype k) { return pers_rb_tree::locate_pred(Convert(k),V); }
p_dic_item lookup(ktype k) { return pers_rb_tree::lookup(Convert(k),V); }

PERS_DIC<ktype,itype>  insert(ktype k, itype i)
{ return PERS_DIC<ktype,itype>(v_list,pers_rb_tree::insert(Convert(k),Convert(i),V)); }

PERS_DIC<ktype,itype>  del(ktype k)
{ return PERS_DIC<ktype,itype>(v_list,pers_rb_tree::del(Convert(k),V)); }

PERS_DIC<ktype,itype>  change_inf(p_dic_item p, itype i)
{ return PERS_DIC<ktype,itype>(v_list,pers_rb_tree::change_inf(p,Convert(i),V)); }

p_dic_item min()          { return pers_rb_tree::min(V); }
p_dic_item max()          { return pers_rb_tree::max(V); }
p_dic_item succ(p_dic_item p)  { return pers_rb_tree::succ(p,V); }
p_dic_item pred(p_dic_item p)  { return pers_rb_tree::pred(p,V); }
int   size()         { return pers_rb_tree::size(V); }
void  print()        { pers_rb_tree::print(V); }
void  draw(DRAW_NODE_FCT f, DRAW_EDGE_FCT g, double x0, double x1, double y, double dy)  { pers_rb_tree::draw(f,g,V,x0,x1,y,dy); }
double get_version() { return ver_num(V); }

OPERATOR_NEW(sizeof(PERS_DIC<ktype,itype>))
OPERATOR_DEL(sizeof(PERS_DIC<ktype,itype>))

};



template <class ktype, class itype>


class _CLASSTYPE p_dictionary : public handle_base {

PERS_DIC<ktype,itype>* ptr() const
                                 { return (PERS_DIC<ktype,itype>*) PTR; }

public:

 p_dictionary()      { PTR = new PERS_DIC<ktype,itype>; }
 p_dictionary(PERS_DIC<ktype,itype>* p)
                     { PTR = (PERS_DIC<ktype,itype>*)p; }

#if !defined(__GNUG__)
 p_dictionary(const p_dictionary<ktype,itype>& p) : handle_base(p) {}
#endif

~p_dictionary()     { clear(); }


 p_dictionary<ktype,itype>& operator=(const p_dictionary<ktype,itype>& p)
 { handle_base::operator=(p); return *this; }



p_dic_item locate(ktype k)      { return ptr()->locate(k); }
p_dic_item locate_pred(ktype k) { return ptr()->locate_pred(k); }
p_dic_item lookup(ktype k)      { return ptr()->lookup(k); }

ktype key(p_dic_item p)     { return ptr()->key(p); }
itype inf(p_dic_item p)     { return ptr()->inf(p); }

p_dictionary<ktype,itype> insert(ktype k, itype i)
{ return new PERS_DIC<ktype,itype> 
                                       (ptr()->insert(k,i)); }

p_dictionary<ktype,itype> del(ktype k)
{ return new PERS_DIC<ktype,itype>
                                       (ptr()->del(k)); }

p_dictionary<ktype,itype> change_inf(p_dic_item p, itype i)
{ return new PERS_DIC<ktype,itype>
                                       (ptr()->change_inf(p,i)); }

p_dic_item min()         { return ptr()->min();     }
p_dic_item max()         { return ptr()->max();     }

p_dic_item succ(p_dic_item p) { return ptr()->succ(p);   }
p_dic_item succ(ktype k)    { return ptr()->locate(k); }
p_dic_item pred(p_dic_item p) { return ptr()->pred(p);   }
p_dic_item pred(ktype k)    { return ptr()->locate_pred(k); }

p_dic_item first_item()       { return ptr()->min();     }
p_dic_item next_item(p_dic_item p) { return ptr()->succ(p);   }

int   size()        { return ptr()->size();    }
int   empty()       { return ptr()->size()==0; }

void print()       { ptr()->print(); }

void draw(DRAW_NODE_FCT f,DRAW_EDGE_FCT g,double x0,double x1,double y,double dy)  { ptr()->draw(f,g,x0,x1,y,dy); }

friend void   Clear(p_dictionary<ktype,itype>& y)  { y.clear(); }

friend GenPtr Copy(p_dictionary<ktype,itype>& y)   { return y.copy();}

friend const  GenPtr& Access(p_dictionary<ktype,itype>&,const GenPtr& p)
{ return p; }

}; 


#endif
