/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  range_tree1.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef RANGE_TREE1_H
#define RANGE_TREE1_H

#include <LEDA/impl/genra_tree.h>

//
// D-Dimensional Range Trees
// -------------------------------------
//
//
// exchangable underlying data structure
//
// 7/92, M.Paul
//



template<class keytype, class inftype>
class range_tree1 : public genra_tree
{

  GenPtr* Conv( keytype k[] ) const		// convert an array
  { register int d;
    GenPtr* ca = new GenPtr[dim1+1] ;
    for( d=dim1; d>=0; d-- )
      ca[d] = Convert(k[d]) ;
    return ca ;
  };

  int r_cmp( GenPtr x, GenPtr y ) const
    { return compare(ACCESS(keytype,x),ACCESS(keytype,y)); }
  void r_copy_key( GenPtr*& x ) const
    { for( int d=dim1; d>=0; d-- ) x[d]=Copy(ACCESS(keytype,x[d])); }
  void r_copy_inf( GenPtr& x ) const { x=Copy(ACCESS(inftype,x)); }
  void r_clear_key( GenPtr*& x ) const
    { for( int d=dim1; d>=0; d-- ) Clear(ACCESS(keytype,x[d])); }
  void r_clear_inf( GenPtr& x ) const { Clear(ACCESS(inftype,x)); }

  public:

    void r_print_key( GenPtr* x ) const
      { cout << "( ";
	for( int d=dim1; d>=0; d--,cout << " " )
	  cout << (keytype) ACCESS(keytype,x[d]);
        cout << ") "; }
    void r_print_inf( GenPtr x ) const
      { cout << (inftype) ACCESS(inftype,x); }

    LEDA_MEMORY( range_tree1 ) ;

    genra_tree* create_genra_tree( int d )
      { return new range_tree1(d); }

    range_tree1( int d = 2 ) { dim1=d-1; }

    virtual void clear() { genra_tree::clear(); }
    ~range_tree1() { clear(); }

    virtual int dimension() const { return genra_tree::dimension(); }
    virtual int size() const { return genra_tree::size(); }
    virtual int empty() const { return genra_tree::empty(); }

    virtual void query( keytype low[], keytype high[], list<GenPtr>& lgi) const
      { GenPtr* l = Conv(low); GenPtr* h = Conv(high);
        genra_tree::query(l,h,lgi);
      }

    virtual grt_item lookup( keytype key[] ) const
      { GenPtr* k = Conv(key); return genra_tree::lookup(k); }

    virtual list<GenPtr> all_items() const { return genra_tree::all_items(); }

    virtual grt_item insert( keytype key[], inftype inf )
      { GenPtr* k = Conv(key) ;
        grt_item gi = genra_tree::insert(k,Convert(inf));
	return gi ;
      }

    virtual void del( keytype key[] )
      { GenPtr* k = Conv(key); genra_tree::del(k); }

    virtual void del_item( grt_item gi ) { genra_tree::del_item(gi); }
} ;



#endif
