/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  dic_impl.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/




typedef int dic_impl_item;

class dic_impl {

private:

virtual int  cmp(GenPtr, GenPtr) const = 0;
virtual int  int_type()          const = 0;
virtual void clear_key(GenPtr&)  const = 0;
virtual void clear_inf(GenPtr&)  const = 0;
virtual void copy_key(GenPtr&)   const = 0;
virtual void copy_inf(GenPtr&)   const = 0;

//
// private data
//


public:

 dic_impl();
 dic_impl(const dic_impl&);
~dic_impl();

dic_impl& operator=(const dic_impl&);

GenPtr key(dic_impl_item p)  const;
GenPtr inf(dic_impl_item p)  const;

dic_impl_item insert(GenPtr,GenPtr);
dic_impl_item lookup(GenPtr)  const;
dic_impl_item first_item()    const;
dic_impl_item next_item(dic_impl_item) const;
dic_impl_item item(GenPtr)    const;

void    change_inf(dic_impl_item,GenPtr);
void    del_item(dic_impl_item);
void    del(GenPtr);
void    clear();

int     size() const;

};



