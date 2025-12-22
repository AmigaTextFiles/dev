#include <LEDA/window.h>

main()
{ 
  bool   B     = false;
  double R     = 3.1415;
  int    C     = 0;
  int    C1    = 0;
  int    N     = 100;
  string S     = "dummy";
  string S1    = "menu";

  int    but_num = 30;

  list<string> menu;

  menu.append("menu-item-1");
  menu.append("menu-item-2");
  menu.append("menu-item-3");
  menu.append("menu-item-4");
  menu.append("menu-item-5");
  menu.append("menu-item-6");
  menu.append("menu-item-7");
  menu.append("menu-item-8");

for(;;)
{

  panel P("PANEL DEMO");

  P.text_item("Here we have a text item (just a line of text) and");
  P.text_item("another text item, followed by an empty line");
  P.text_item("");

  P.bool_item("bool_item",B);

  P.choice_item("choice_item",C,"zero","one","two","three", "four");

  P.int_item("int_item(0,80,20)",C1,0,80,20);

  P.int_item("int_item(1,60)",but_num,1,60);

  P.int_item("int_item",N);

  P.double_item("double_item",R);

  P.string_item("string_item",S);

  P.string_item("string_item(menu)",S1,menu);


  for(int i=0; i < but_num; i++) P.button(string("%d",i));

  P.button("quit");

  int button = P.open();

  if (button == i) break;

  printf("BOOL          = %d\n",B);
  printf("CHOICE        = %d\n",C);
  printf("INT (CHOICE)  = %d\n",C1);
  printf("INT (SLIDER)  = %d\n",but_num);
  printf("INT           = %d\n",N);
  printf("REAL          = %f\n",R);
  printf("STRING        = %s\n",~S);
  printf("STRING (MENU) = %s\n",~S1);
  printf("BUTTON        = %d\n",button);
  newline;

 
 }

  return 0;
}

