/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  subdivision.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_SUBDIVISION_H
#define LEDA_SUBDIVISION_H

#include <LEDA/point.h>
#include <LEDA/planar_map.h>

class SubDivision : public planar_map
{
  face outer_face;

  void* strip_ptr;   //pointer to strip_list
  
public:
  
  SubDivision(const graph&);

 ~SubDivision();

  point  position(node v)    const { return ACCESS(point,inf(v)); }
  
  face   locate_point(point) const;

  void   print_stripes() const;
  
};


//------------------------------------------------------------------------------
//
// subdivision: generic subdivisions with face entries of type "ftype"
//
//------------------------------------------------------------------------------


template <class ftype>

class _CLASSTYPE subdivision : public SubDivision {

void copy_face_entry(GenPtr& x)  const { x=Copy(ACCESS(ftype,x)); }
void clear_face_entry(GenPtr& x) const { Clear(ACCESS(ftype,x));  }

public:

   ftype  inf(face f)         const {return ACCESS(ftype,SubDivision::inf(f));}
   point  operator[](node v)  const {return ACCESS(point,SubDivision::inf(v));}
   ftype  operator[](face f)  const {return ACCESS(ftype,SubDivision::inf(f));}

void print_node(node v) const { cout << "[" << index(v) <<"] (";
                                Print(position(v));
                                cout << ") ";}

   subdivision(GRAPH<point,ftype>& G) : SubDivision(G)   {}
  ~subdivision()     { clear(); }

};

#endif
