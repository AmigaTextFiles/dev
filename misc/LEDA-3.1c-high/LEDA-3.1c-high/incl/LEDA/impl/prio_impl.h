/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  prio_impl.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



class PRIO_IMPL
{ 

private:

PRIO_IMPL_DATA

virtual int  cmp(GenPtr, GenPtr) const = 0;
virtual int  int_type()          const = 0;
virtual void clear_key(GenPtr&)  const = 0;
virtual void clear_inf(GenPtr&)  const = 0;
virtual void copy_key(GenPtr&)   const = 0;
virtual void copy_inf(GenPtr&)   const = 0;


protected:

 PRIO_IMPL_ITEM item(void* p) const { return PRIO_IMPL_ITEM(p); }

public:

 PRIO_IMPL();
 PRIO_IMPL(int);
 PRIO_IMPL(int,int);
 PRIO_IMPL(const PRIO_IMPL&);
virtual ~PRIO_IMPL();

PRIO_IMPL& operator=(const PRIO_IMPL&);

PRIO_IMPL_ITEM insert(GenPtr,GenPtr);
PRIO_IMPL_ITEM find_min() const;
PRIO_IMPL_ITEM first_item() const;
PRIO_IMPL_ITEM next_item(PRIO_IMPL_ITEM) const;

GenPtr key(PRIO_IMPL_ITEM) const;
GenPtr inf(PRIO_IMPL_ITEM) const;

void del_min();
void del_item(PRIO_IMPL_ITEM);
void decrease_key(PRIO_IMPL_ITEM,GenPtr);
void change_inf(PRIO_IMPL_ITEM,GenPtr);
void clear();
 
int  size()  const;

};

