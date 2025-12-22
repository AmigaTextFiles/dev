#include <LEDA/window.h>
#include <LEDA/stream.h>


main()
{
  window W;
  panel  P;

  string file_name = "points";
  bool file_output = true;
  int N = 100;
  int max_coord = 1000;
  int generator = 1;


  P.string_item("file",file_name);
  P.bool_item("file output",file_output);
  P.int_item("# points",N);
  P.int_item("max coord",max_coord,0,5000);
  P.choice_item("generator",generator,"rand()","random()");
  P.open();
  
  file_ostream F(file_name);

  W.init(0,max_coord,0);

  int i;

  if (generator == 1)
    for (i=0; i<N ; i++)
    { long x =  random() % max_coord;
      long y =  random() % max_coord;
      W.draw_pix(x,y);
      if (file_output) F << x << " " << y << "\n";
     }

  if (generator == 0)
    for (i=0; i<N ; i++)
    { long x =  rand() % max_coord;
      long y =  rand() % max_coord;
      W.draw_pix(x,y);
      if (file_output) F << x << " " << y << "\n";
     }

  W.read_mouse();

  return 0;

}
  
