/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  d2_dictionary.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#ifndef LEDA_d2_dictionary_H
#define LEDA_d2_dictionary_H

#include <LEDA/impl/range_tree.h>
typedef rt_item dic2_item;



template<class type1, class type2, class itype>
class _CLASSTYPE d2_dictionary : public range_tree {

  // redefine the virtual functions of class range_tree
 
  void rt_clear_key(GenPtr*& x) const { 
    Clear(ACCESS(type1,x[0])); Clear(ACCESS(type2,x[1])); 
  }

  void rt_copy_key(GenPtr*& x) const { 
    Copy(ACCESS(type1,x[0])); Copy(ACCESS(type2,x[1])); 
  }

  void rt_print_key(int d,GenPtr*& x) const { 
    if( d==0 ) Print(ACCESS(type1,x[0]),cout);
    else       Print(ACCESS(type2,x[1]),cout);
  }
  
  void rt_clear_inf(GenPtr& x) const  { Clear(ACCESS(itype,x));}
  void rt_copy_inf(GenPtr& x)  const { Copy(ACCESS(itype,x));}
  
  int rt_cmp(int d,GenPtr* x,GenPtr* y) const { 
    if( d==0 ) return compare(ACCESS(type1,x[0]),ACCESS(type1,y[0]));
    else       return compare(ACCESS(type2,x[1]),ACCESS(type2,y[1]));
  }
  
  range_tree* new_range_tree(int /*dim*/, int lev ) { 
    return new d2_dictionary<type1,type2,itype>(lev); 
  }

  public:
  
    d2_dictionary(int lev=0) : range_tree(2,lev) {}
    ~d2_dictionary() { clear(); }
    
    itype inf(dic2_item x)    { return ACCESS(itype,x->inf());}
    
    type1 key1(dic2_item x)   { return ACCESS(type1,x->key(0));  }
    type2 key2(dic2_item x)   { return ACCESS(type2,x->key(1));  }
    
    void  change_inf(dic2_item x, itype i) { 
      Clear(ACCESS(itype,x->inf())); 
      x->inf() = Copy(i); 
    }
    
    dic2_item min_key1() { return range_tree::rt_min(0); }
    dic2_item min_key2() { return range_tree::rt_min(1); }
    dic2_item max_key1() { return range_tree::rt_max(0); }
    dic2_item max_key2() { return range_tree::rt_max(1); }
    
    dic2_item insert(type1 x,type2 y,itype i) { 
      dic2_item p = new rt_elem(Copy(x),Copy(y),Copy(i));
      return range_tree::insert(p);
     }
    
    list<dic2_item> range_search(type1 x0,type1 x1,type2 y0,type2 y1) { 
      rt_elem p(Convert(x0),Convert(y0),0);
      rt_elem q(Convert(x1),Convert(y1),0);
      return range_tree::query(&p,&q);
    }
    
    dic2_item lookup(type1 x,type2 y) { 
      rt_elem p(Convert(x),Convert(y),0);
      return range_tree::lookup(&p);
    }
    
    void del(type1 x,type2 y) { 
      rt_elem p(Convert(x),Convert(y),0);
      range_tree::del(&p);
    }
    
    void del_item(dic2_item it) { range_tree::del(it); }
    list<dic2_item> all_items() { return range_tree::all_items(); }
};

// iteration macro
// 
#define forall_dic2_items(x,T)  (T).init_iteration(); forall(x,(T).L )

#endif
