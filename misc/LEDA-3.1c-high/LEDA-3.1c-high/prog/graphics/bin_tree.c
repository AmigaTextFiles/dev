
#include <LEDA/impl/bin_tree.h>
#include <LEDA/impl/avl_tree.h>
#include <LEDA/impl/bb_tree.h>
#include <LEDA/impl/rb_tree.h>
#include <LEDA/impl/rs_tree.h>

#include <LEDA/window.h>


window W;

void draw_node(double x, double y, void*, int bal)
{ W.draw_node(x,y,blue);
  W.draw_ctext(x,y,string("%d",bal),violet); 
 }

void draw_leaf(double x, double y, void* key, int)
{ W.draw_ctext(x,y,string("%d",key),black); }


void draw_edge(double x0, double y0, double x1, double y1)
{ W.draw_edge(point(x0,y0),point(x1,y1),blue); }


main()
{
  bin_tree* TREE[5];
  string    NAME[5];

  TREE[0] = new bin_tree;  NAME[0] = "BINARY TREE";
  TREE[1] = new avl_tree;  NAME[1] = "AVL TREE";
  TREE[2] = new bb_tree;  NAME[2] = "BB[ALPHA] TREE";
  TREE[3] = new rb_tree;   NAME[3] = "RED/BLACK TREE";
  TREE[4] = new rs_tree;   NAME[4] = "RANDOMIZED SEARCH TREE";


  panel P("BINARY TREES");

  int n = 20;
  int mode = 0;
  int sel = 0;

  P.choice_item("TREE",sel,"bin_tree","avl_tree","bb_tree","rb_tree","rs_tree");
  P.choice_item("INPUT",mode,"random", "1 2 3 ...");

  P.int_item("# INSERTS",n,0,50);

  W.set_node_width(15);
  //W.set_line_width(2);
  W.set_text_mode(transparent);

  for(;;)
  {
    P.open();

    W.clear();
    W.message(NAME[sel]);

    bin_tree* T = TREE[sel];
  
    T->clear();
  
    init_random();

    int i;
  
    if (mode==0)
      for(i=0;i<n;i++) T->insert((void*)random(0,99),0);
    else
      for(i=0;i<n;i++) T->insert((void*)i,0);
  
    double dy = (W.ymax()-W.ymin())/10;
  
    T->draw(draw_node,draw_leaf,draw_edge, W.xmin(),W.xmax(),W.ymax()-dy,dy);
  
    W.read_mouse();
  
  }
  
  return 0;
}
