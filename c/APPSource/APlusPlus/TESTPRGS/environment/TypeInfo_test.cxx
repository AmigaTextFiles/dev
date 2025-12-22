/******************************************************************************
 *
 *    $Source: apphome:RCS/TESTPRGS/environment/TypeInfo_test.cxx,v $
 *
 *    Demo for the A++ Library
 *    Copyright (C) 1994 by Armin Vogt, EMail: armin@uni-paderborn.de
 *
 *    $Revision: 1.8 $
 *    $Date: 1994/07/30 12:25:40 $
 *    $Author: Armin_Vogt $
 *
 ******************************************************************************/


#if defined(_AMIGA) || defined(AMIGA)
#include <APlusPlus/environment/TypeInfo.h>
#include <APlusPlus/exec/List.h>
#endif
#include <iostream.h>


static const char rcs_id[] = "$Id: TypeInfo_test.cxx,v 1.8 1994/07/30 12:25:40 Armin_Vogt Exp Armin_Vogt $";


class A
{
   public:
      A() {}
      virtual ~A() {}
      static const Type_info info_obj;
      virtual const Type_info& get_info() const { return info_obj; }
      static const Type_info& info() { return info_obj; }
};
typeinfo(A, no_bases , rcs_id);



class B : private MinNodeC, public A, private MinListC
{
   public:
      B() {}
      virtual ~B() {}
      static const Type_info info_obj;
      virtual const Type_info& get_info() const { return info_obj; }
      static const Type_info& info() { return info_obj; }
   private:
      int k;
      char b;
};
typeinfo(B, derived(from(A)) , rcs_id);

class BB
{
   public:
      BB() {}
      virtual ~BB() {}
      static const Type_info info_obj;
      virtual const Type_info& get_info() const { return info_obj; }
      static const Type_info& info() { return info_obj; }
   private:
      long l[2];
};

typeinfo(BB, no_bases , rcs_id);


// if c is derived from BB, too, an object of class E is identified as
// an object of class C instead!
// GNU overrides the virtual method of the first class only 
// from which it inherits that method!
class C : public B, private BB
{
   public:
      C() {}
      virtual ~C() {}
      static const Type_info info_obj;
      virtual const Type_info& get_info() const { return info_obj; }
      static const Type_info& info() { return info_obj; }
   private:
      char n[5];
};
typeinfo(C, derived(from(BB) from(B)) , rcs_id);



class D
{
   public:
      D() {}
      virtual ~D() {}
      static const Type_info info_obj;
      virtual const Type_info& get_info() const { return info_obj; }
      static const Type_info& info() { return info_obj; }
   private:
      char m[8];
};
typeinfo(D, no_bases , rcs_id);


// An enhanced Type_info class:
class APP_Type_info : public Type_info
{
   public:
      APP_Type_info(long l, const char *name, const Type_info* bases[],const char* id = NULL) 
      : Type_info(name,bases,id) { line = l; }
      ~APP_Type_info() {}
         
      static const Type_info info_obj;
      virtual const Type_info& get_info() const { return info_obj; }
      static const Type_info& info() { return info_obj; }

      long readL() const { return line; }
         
   private:
      long line;  // some additional data
};
typeinfo(APP_Type_info, derived(from(Type_info)) , rcs_id);

#define APP_typeinfo(line,T,bases,id) \
   static const Type_info* T ## _b[] = { bases }; \
   const APP_Type_info T::info_obj(line,#T,T ## _b,id)


class E : public C, public D
{
   public:
      E() {}
      virtual ~E() {}
      static const APP_Type_info info_obj;
      virtual const Type_info& get_info() const { return info_obj; }
      static const Type_info& info() { return info_obj; }
};
APP_typeinfo(23021971, E, derived(from(C) from(D)) , rcs_id);



main()
{
   A a1;
   cout << "TypeInfo_test\n";
   cout << "created object 'a1' of class '" << ref_type_id(a1).name() << "'" << endl;
   C c1;

   A* A_ptr = &c1; // 'A_ptr' points to the 'A' object within each 'C' object

   cout << "'A_ptr' addresses an object of class '"<< type_id(A_ptr).name() << "'\n";
   
   cout << "'*A_ptr' can be cast into class B ? --> " <<
      class_type_id(B).can_cast(type_id(A_ptr)) << endl;
   cout << "'*A_ptr' can be cast into class C ? --> " <<
      ptr_cast(C,A_ptr) << endl;

   E e1;
   B* B_ptr = &e1; // 'B_ptr' points to the 'B' object within each 'E' object

   cout << "'B_ptr' addresses an object of class '"<< type_id(B_ptr).name() << "'\n";
   cout << "'*B_ptr' can be cast into class A ? --> " <<
      class_type_id(A).can_cast(type_id(B_ptr)) << endl;      
   cout << "B_ptr = "<<(APTR)B_ptr<<", ptr_cast(A,B_ptr) results in "<<(APTR)ptr_cast(A,B_ptr)<<endl<<endl;

   cout << "'*B_ptr' can be cast into class A ? --> " <<
      (APTR)ptr_cast(A,B_ptr) << endl;     
   cout << "'*B_ptr' can be cast into class B ? --> " <<
      (APTR)ptr_cast(B,B_ptr) << endl;  
   cout << "'*B_ptr' can be cast into class BB ? --> " <<
      (APTR)ptr_cast(BB,B_ptr) << endl;
   cout << "'*B_ptr' can be cast into class C ? --> " <<
      (APTR)ptr_cast(C,B_ptr) << endl;
   cout << "'*B_ptr' can be cast into class D ? --> " <<
      (APTR)ptr_cast(D,B_ptr) << endl;
   cout << "'*B_ptr' can be cast into class E ? --> " <<
      (APTR)ptr_cast(E,B_ptr) << endl;


   cout << "\n The following classes are available:\n";
   
   LoL_iterator next;
   const Type_info *ti;
   while (NULL != (ti = next()))
   {
      cout << "--------------class '"<<ti->name()<<"'-----------------\n";
      
      const APP_Type_info* ati = ptr_cast( APP_Type_info, ti );
      
      if (ati)
      {
         cout << "   APP_Type_info can cast!  Line = "<<ati->readL()<<"\n";
      }
      else 
         cout << "   Type_info is class '"<<type_id(ti).name()<<"'\n";

   }
   return 0;
}
