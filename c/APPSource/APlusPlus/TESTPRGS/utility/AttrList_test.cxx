/*******************************************************************************

   taglist class
   $id$
 *******************************************************************************/

#include <iostream.h>
#include <APlusPlus/utility/AttrList.h>

//--------------------------------------------------------------------------------------


void WorkTaglist(AttrList& attrs)
{
   cout << "\tWorkTaglist" << endl;
   AttrIterator next(attrs);


   while (next())
   {
      //next.writeData(23);
      cout << "\tTag = "<<next.tag()<<", Data = "<<next.data()<<endl;
      //t = next.tag(); d = next.data();
   }
   cout << "\tWorkTaglist END\n";
}


void propagate(const AttrList& attrs)
{
   cout << "\tpropagate\n";
   {struct TagItem *ti = attrs; cout << ti<<endl;
        }
   cout << "\tpropagate END\n";
}

void UseTaglist(int p1,AttrList& attrs)
{
   cout << "\tUseTaglist(" << attrs << ")\n{\n";
   AttrIterator next(attrs);
   //AttrManipulator next(attrs);
   //Tag t; LONG d;

   // for (int i=0; i<9999; i++)
   {
      while (next())
      {
         //next.writeData(0);
         cout << "\tTag = "<<next.tag()<<", Data = "<<next.data()<<"  //  ";
                  //t = next.tag(); d = next.data();
      }
      next.reset();
   }
   cout << "\ncall 'propagate(attrs)'\n";
   propagate(attrs);
   cout << "\tUseTaglist END\n}\n";

}

main()
{
   cout << "main: a1\n";
   const AttrList a1(111,999,222,888,333,777,TAG_END);
   cout << "main: a2\n";
   AttrList a2(a1);


   cout << "a1 = "<<a1<<endl;
   cout << "a2 = "<<a2<<endl;
   WorkTaglist((TAG_END));

   cout << "main: UseTaglist(0, AttrList(2,4,3,9,TAG_END));\n";
   UseTaglist(1, AttrList(200,400,300,900,TAG_END) );
   cout << "main: UseTaglist(1, AttrList(1,1,2,4,3,9,TAG_END));\n";
   UseTaglist(1, AttrList(100,100,200,400,300,900,TAG_END) );


   cout << "main: UseTaglist(0,a2);\n";
   UseTaglist(1, a2);//(12,1,13,2,TAG_END));
}
