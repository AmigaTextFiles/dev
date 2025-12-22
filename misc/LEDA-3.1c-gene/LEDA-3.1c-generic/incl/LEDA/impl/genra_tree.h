/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  genra_tree.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_GENRA_TREE_H
#define LEDA_GENRA_TREE_H

// macros for counting 
//
#ifdef COUNT
#define COUNT_SEC(l)	genra_tree::sec_op[last_op]+=l;
#define COUNT_INS 	genra_tree::prim_op[0]++; genra_tree::last_op=0;
#define COUNT_DEL	genra_tree::prim_op[1]++; genra_tree::last_op=1;
#define COUNT_VARS	static int prim_op[2],sec_op[2],last_op;
#define COUNT_FUNC	float analyze_del(); float analyze_ins();\
			void reset();
#else
#define COUNT_SEC(l)
#define COUNT_INS
#define COUNT_DEL
#define COUNT_VARS
#define COUNT_FUNC	void analyze() {} ;  void reset() {} ;
#endif



#include <LEDA/list.h>

//
// D-Dimensional Generic Range Trees
// ---------------------------------
//
//
// exchangable underlying data structure
//
// 7/92, M.Paul
//



// an element of a genra_tree stores key and inf
//
class grt_inf
{
  friend class genra_tree ;

  GenPtr* g_key ;
  GenPtr g_inf ;

  public:

    LEDA_MEMORY( grt_inf ) ;			// better proteced

    grt_inf( GenPtr k[], GenPtr i ) { g_key=k; g_inf=i; }

    GenPtr*& key() { return g_key; } ;
    GenPtr key( int d ) { return g_key[d]; } ;
    GenPtr& inf() { return g_inf; } ;
} ;

typedef grt_inf* grt_item ;



#include <LEDA/impl/rs_tree.h>			// include default UDS
typedef rs_tree def_uds ;



// genra_tree is a generic d-dimensional range tree with default
// underlying data structure def_uds
//
class genra_tree : public def_uds
{
  COUNT_VARS
  static grt_item GI_L, GI_H ;	

  // functions used from underlying data structure are virtual

  virtual GenPtr r_clear() { return def_uds::r_clear(); } ;
  virtual int r_size() const { return def_uds::r_size(); } ;
  virtual GenPtr r_first_item() const 
    { return def_uds::r_first_item(); } ;
  virtual GenPtr r_next_item( GenPtr p ) const 
    { return def_uds::r_next_item(p); } ;
  virtual GenPtr r_inf( GenPtr p ) const { return def_uds::r_inf(p); } ;
  virtual void r_partition( GenPtr low, GenPtr high, 
			    list<GenPtr>& node_infs, list<GenPtr>& leaf_infs ) const 
    { def_uds::r_partition(low,high,node_infs,leaf_infs); } ;
  virtual void r_query( GenPtr low, GenPtr high, list<GenPtr>& infs ) const
    { def_uds::r_query(low,high,infs); } ;
  virtual void r_leaf_infs( GenPtr p, list<GenPtr>& infs ) const
    { def_uds::r_leaf_infs(p,infs); } ;
  virtual list<GenPtr> r_all_leaf_infs() const
    { return def_uds::r_all_leaf_infs(); } ;
  virtual void r_insert( GenPtr key, GenPtr leaf_inf, GenPtr inner_inf,
		   	 list<GenPtr>& cn, list<GenPtr>& in )
    { def_uds::r_insert(key,leaf_inf,inner_inf,cn,in); } ;
  virtual GenPtr r_delete( GenPtr key, list<GenPtr>& cn, list<GenPtr>& dn )
    { return def_uds::r_delete(key,cn,dn); } ;

  protected:

    LEDA_MEMORY( genra_tree ) ;

    int dim1 ;			// one less than the dimension of tree

    virtual genra_tree* create_genra_tree( int d )
      { return new genra_tree(d); } ;

    // virtual functions of uds

    void print_key( GenPtr ) const ;
    void print_inf( GenPtr ) const ;
    int cmp( GenPtr, GenPtr ) const ;
    void clear_key(GenPtr&) const {}
    void clear_inf(GenPtr&) const {}
    void copy_key(GenPtr&) const {}
    void copy_inf(GenPtr&) const {}
    int int_type() const { return 0; }

    // user defined virtual functions of class genra_tree

    virtual int r_cmp( GenPtr x, GenPtr y ) const
      { return compare(x,y); } ;
    virtual void r_copy_key( GenPtr*& ) const {}
    virtual void r_copy_inf( GenPtr& ) const {} 
    virtual void r_clear_key( GenPtr*& ) const {}
    virtual void r_clear_inf( GenPtr& ) const {}

    int is_between( grt_item k_gi, grt_item l_gi, grt_item h_gi ) const;
    void query( grt_item l_gi, grt_item h_gi, list<GenPtr>& lgi ) const ;
    void insert_item( grt_item gi ) ;
    void del_item( grt_item gi ) ;
    void build_tree( list<GenPtr>& lgi ) ;

  public:

    virtual void r_print_key( GenPtr* x ) const 
      { for( int d=dim1; d>=0; d-- ) cout << x[d] << " "; }
    virtual void r_print_inf( GenPtr i ) const { cout << i << " "; }
    
    virtual void print_tree(){ def_uds::print_tree(); } ;
    void print() ;
    void test() ;

    genra_tree( int d = 2 ) { dim1 = d-1; }

    void clear() ;
    virtual ~genra_tree() { clear(); }

    int dimension() const { return dim1+1; }
    int size() const { return r_size(); }
    int empty() const { return r_size()==0; }
    void query( GenPtr low[], GenPtr high[], list<GenPtr>& lgi ) const ;
    grt_item lookup( GenPtr key[] ) const ;
    list<GenPtr> all_items() const ;

    grt_item insert( GenPtr key[], GenPtr inf ) ;
    void del( GenPtr key[] ) ;

    COUNT_FUNC
} ;

typedef genra_tree* grt_p ;



//
// some inline functions of class genra_tree
//

// returns a list of all grt_items with key between low[] and high[]
//
inline void genra_tree::query( GenPtr low[], GenPtr high[],
			       list<GenPtr>& lgi ) const 
{
  lgi.clear() ;

  if( ! empty() ) {
    GI_L->key() = low ;  GI_H->key() = high ;
    query( GI_L, GI_H, lgi ) ;
  }
}



// returns a list of all grt_items
//
inline list<GenPtr> genra_tree::all_items() const 
{
  return r_all_leaf_infs() ;
}



// insert inf with key[] or change inf, if key[] exists
//
inline grt_item genra_tree::insert( GenPtr key[], GenPtr inf ) 
{
  grt_item gi = lookup( key ) ;			// search for key[]
  
  if( ! gi ) {					// insert new item
    gi = new grt_inf( key, inf ) ;  
    r_copy_inf( gi->inf() ) ;  r_copy_key( gi->key() ) ;  
    COUNT_INS
    insert_item( gi ) ;				
  }
  else {					// change inf
    // r_clear_inf( gi->inf() ) ;
    // gi->inf() = inf ;  
    // r_copy_inf( gi->inf() ) ;
  }

  return gi ;
} ;



// delete inf with key[]
//
inline void genra_tree::del( GenPtr key[] )
{
  grt_item gi = lookup( key ) ;                 // search for key[]

  if( gi ) {
    COUNT_DEL
    del_item( gi ) ;
    r_clear_inf( gi->inf() ) ;  r_clear_key( gi->key() ) ;  
    delete gi ;
  }
} ;



// checks if k_gi[] lies between l_gi[] and h_gi[] for all dims < dim1
//
inline int genra_tree::is_between( grt_item k_gi, 
		       	           grt_item l_gi, grt_item h_gi ) const
{
  register int d = dim1 ;

  while( --d >= 0 ) 
    if( r_cmp(k_gi->key(d),l_gi->key(d)) < 0 || 
	r_cmp(k_gi->key(d),h_gi->key(d)) > 0 ) 
      break ;

  return d<0 ? 1 : 0 ;
}



//
// virtual functions for uds
//

inline void genra_tree::print_key( GenPtr x ) const
{ r_print_key( grt_item(x)->key() ) ;
}

inline void genra_tree::print_inf( GenPtr x ) const
{ r_print_inf( grt_item(x)->inf() ) ;
}

// use key in dim1 first, then take inf
//
inline int genra_tree::cmp( GenPtr x, GenPtr y ) const
{
  int c = r_cmp( grt_item(x)->key(dim1), grt_item(y)->key(dim1) ) ;
  return c ? c : compare( (GenPtr) grt_item(x)->inf(), 
			  (GenPtr) grt_item(y)->inf() ) ;
}



//
// add capability of exchangable underlying data structure
//

#define GENRA_TREE(a)	name2(a,_GENRA_TREE)



#define GENRA_TREE_DECL(impl)\
\
class GENRA_TREE(impl) : public genra_tree, public impl\
{\
\
  GenPtr r_clear() { return impl::r_clear(); }\
  int r_size() const { return impl::r_size(); }\
  GenPtr r_first_item() const { return impl::r_first_item(); }\
  GenPtr r_next_item( GenPtr p ) const \
    { return impl::r_next_item(p); }\
  GenPtr r_inf( GenPtr p ) const { return impl::r_inf(p); }\
  void r_partition( GenPtr low, GenPtr high,\
		    list<GenPtr>& node_infs, list<GenPtr>& leaf_infs ) const \
    { impl::r_partition(low,high,node_infs,leaf_infs); }\
  void r_query( GenPtr low, GenPtr high, list<GenPtr>& infs ) const\
    { impl::r_query(low,high,infs); }\
  void r_leaf_infs( GenPtr p, list<GenPtr>& infs ) const\
    { impl::r_leaf_infs(p,infs); }\
  list<GenPtr> r_all_leaf_infs() const\
    { return impl::r_all_leaf_infs(); }\
  void r_insert( GenPtr key, GenPtr leaf_inf, GenPtr inner_inf,\
		 list<GenPtr>& cn, list<GenPtr>& in )\
    { impl::r_insert(key,leaf_inf,inner_inf,cn,in); }\
  GenPtr r_delete( GenPtr key, list<GenPtr>& cn, list<GenPtr>& dn )\
    { return impl::r_delete(key,cn,dn); }\
\
  protected:\
\
    LEDA_MEMORY( GENRA_TREE(impl) ) ;\
\
    genra_tree* create_genra_tree( int d )\
      { return new GENRA_TREE(impl)(d); } ;\
\
    void print_key( GenPtr x ) const { genra_tree::print_key(x); }\
    void print_inf( GenPtr x ) const  { genra_tree::print_inf(x); }\
    int cmp( GenPtr x, GenPtr y ) const\
      { return genra_tree::cmp(x,y); }\
    void clear_key(GenPtr&) const {}\
    void clear_inf(GenPtr&) const {}\
    void copy_key(GenPtr&) const {}\
    void copy_inf(GenPtr&) const {}\
    int int_type() const { return 0 ; }\
\
    int r_cmp( GenPtr x, GenPtr y ) const { return compare(x,y); }\
    void r_copy_key( GenPtr*& ) const {}\
    void r_copy_inf( GenPtr& ) const {}\
    void r_clear_key( GenPtr*& ) const {}\
    void r_clear_inf( GenPtr& ) const {}\
\
    void query( grt_item l_gi, grt_item h_gi, list<GenPtr>& lgi ) const \
      { genra_tree::query(l_gi,h_gi,lgi); }\
    int is_between( grt_item k_gi, grt_item l_gi, grt_item h_gi ) const\
      { return genra_tree::is_between(k_gi,l_gi,h_gi); }\
    void insert_item( grt_item gi ){ genra_tree::insert_item(gi); }\
    void del_item( grt_item gi ){ genra_tree::del_item(gi); }\
    void build_tree( list<GenPtr>& lgi ) { genra_tree::build_tree(lgi); }\
\
  public:\
\
    virtual void r_print_key( GenPtr* x ) const\
      { for( int d=dim1; d>=0; d-- ) cout << x[d] << " "; }\
    virtual void r_print_inf( GenPtr i ) const { cout << i << " "; }\
\
    void print_tree(){ impl::print_tree(); } ;\
    void print(){ genra_tree::print(); } ;\
\
    GENRA_TREE(impl)( int d = 2 ) { dim1 = d-1; }\
    virtual ~GENRA_TREE(impl)() { clear(); }\
\
    void clear() { genra_tree::clear(); }\
    int dimension() const { return genra_tree::dimension(); }\
    int size() const { return genra_tree::size(); }\
    int empty() const { return genra_tree::empty(); }\
    void query( GenPtr low[], GenPtr high[], list<GenPtr>& lgi ) const\
      { genra_tree::query(low,high,lgi); }\
    grt_item lookup( GenPtr key[] ) const\
      { return genra_tree::lookup(key); }\
    list<GenPtr> all_items() const { return genra_tree::all_items(); }\
\
    grt_item insert( GenPtr key[], GenPtr inf )\
      { return genra_tree::insert(key,inf); }\
    void del( GenPtr key[] ) { genra_tree::del(key); }\
\
} ;\



#endif
