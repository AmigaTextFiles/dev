/******************************************************************************
 **
 **	C++ Class Library for the Amiga© system software.
 **
 **	Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **	All Rights Reserved.
 **
 **	$Source: apphome:RCS/libsource/TypeInfo.cxx,v $
 **	$Revision: 1.9 $
 **	$Date: 1994/07/31 13:34:22 $
 **	$Author: Armin_Vogt $
 **
 ******************************************************************************/


extern "C"
{
#include <string.h>
}

#if defined(_AMIGA) || defined(AMIGA)
#include <APlusPlus/environment/TypeInfo.h>
#include <APlusPlus/environment/APPObject.h>
#endif


Ti_list Type_info::listOfLists;


typeinfo(Type_info, no_bases , "$Id: TypeInfo.cxx,v 1.9 1994/07/31 13:34:22 Armin_Vogt Exp Armin_Vogt $");

// Both C++ compilers make problems with the order of initialisation 
// of static objects: The per-class Type_info objects are static to their class
// as is the listOfLists that links all Type_info objects! Now it happens that
// some static Type_info objects get initialised earlier than the listOfLists
// to which they are enqueued during initialisation!!!

#if defined(__GNUG__) || defined(__SASC)

Ti_list::Ti_list() 
{ 
   if (lh_Head == NULL) // has not been initialised yet
   {
      NewList((List*)this);
      //cout << ">>>>Ti_list::Ti_list\n"<<"head at "<<(APTR)head()<<", this at "<<(APTR)this<< endl; 
   }
}
Ti_list& Ti_list::enqueue(Ti_listnode* node,const char* name) 
{ 
   if (lh_Head == NULL) // has not been initialised yet
   {
      NewList((List*)this);
   }
   //cout << "Ti_list::enqueue start(node="<<(APTR)node<<")\n";
   ((ListC*)this)->ListC::enqueue((NodeC*)node); 
   //cout << "Ti_list::enqueue done.\n"; 
   return *this; 
}


#endif

Type_info::Type_info(const char* name, const Type_info* bases[],const char* id)
   : Ti_listnode(name), n(name), b(bases), s(id)
{
   //cout << "Type_info::Type_info() start..\n";
   //LONG* l = (LONG*)&listOfLists;
   //cout << "LoL is "<<*l<<"/"<<*(l+1)<<"/"<<*(l+2)<<"/"<<*(l+3)<<endl;
   //**************************************************************************
   // For other static objects of Type_info it is not guaranteed from the GNU
   // compiler that listOfLists has already been initialised!!!!
   //**************************************************************************
   listOfLists.enqueue(this,name);  
   //cout << "Type_info::Type_info() done.\n";

}

Type_info::~Type_info()
{
}

int Type_info::same(const Type_info& p) const
{
	return this==&p || strcmp(n,p.n)==0;
}

int Type_info::has_base(const Type_info& base_ti, int direct) const
{
   _dprintf("Type_info::has_base() called with %s (%s)\n",name(),base_ti.name());
   if (b==NULL) return 0;  // in case no base class list was established
   
   const Type_info** p = &b[0];
   
   while (*p && *p!=&base_ti) p++;  
   // check the direct base classes,
   // ie the classes announced in 'this' Type_info's base list.

   if ( !(*p || direct) )  // base_ti not found and indirect bases were also asked for
   {
      _dprintf(" checking indirect base classes..\n");
      p = &b[0];
      while (*p && !((*p)->has_base(base_ti))) p++;
      // recursively descent into the 'Type_info' tree.
   }
   #ifdef DEBUG
   if (*p==0) printf(" base not found.\n");
   #endif
   return (*p!=0);
}

int Type_info::can_cast(const Type_info& p) const
{
	return same(p) || p.has_base(*this);
}

//static
const Type_info* Type_info::find_class(const char* name)
{
   return (const Type_info*)listOfLists.findName(name);
}


//------------------------- LoL_iterator---------------------------------------


LoL_iterator::LoL_iterator()
{
   current = NULL;
}

const Type_info* LoL_iterator::operator () ()
{
   return (current = (const Type_info*)(current!=NULL ? 
               current->succ() : Type_info::listOfLists.head() ) );
}

const Type_info* LoL_iterator::find_info(const char* name)
{
   return (const Type_info*)Type_info::listOfLists.findName(name); 
}
