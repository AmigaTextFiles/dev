#include "LEDA/d2_dictionary.h"




main()
{

  d2_dictionary<double,double,string> S;

  list<dic2_item> L;
  dic2_item       it;
  char            ch;
  double          x,y;



  while (ch != 'q')
  { 
    cout << "(r/s/f/i/d/D/l/q): ";
    cin  >> ch;

    float T  = used_time();
     
    switch(ch) {

    case 'i': { cout << "insert point: ";
                cin >> x >> y;
                S.insert(x,y,string("x = %f",x));
                break;
               }

    case 'r': { init_random();
                int n = read_int("#random points = ");
                while (n--)
                { double x = random(1,1000)/100.0;
                  double y = random(1,1000)/100.0;
                  S.insert(x,y,string("x = %f",x));
                 }
                cout << string("time: %6.2f\n",used_time(T));
                break;
               }

    case 's': { double a=read_real("x0=");
                double b=read_real("x1=");
                double c=read_real("y0=");
                double d=read_real("y1=");
  
                L = S.range_search(a,b,c,d);
  
                forall(it,L) cout << S.key1(it) << " " << S.key2(it) << "\n";
                newline;
              
                cout << string("time: %6.2f\n",used_time(T));
                break;
              }


    case 'd': { cout << "delete point: ";
	        cin >> x >> y;
                S.del(x,y);
                break;
               }

    case 'D': { double a=read_real("x0=");
                double b=read_real("x1=");
                double c=read_real("y0=");
                double d=read_real("y1=");
  
                L = S.range_search(a,b,c,d);
  
                forall(it,L) 
                { x = S.key1(it);
                  y = S.key2(it);
                  cout << "delete: " << x  << " " << y <<"\n";
                  S.del(x,y);
                 }
                newline;
              
                cout << string("time: %6.2f\n",used_time(T));
                break;
              }


    case 'f': { cout << "find point: ";
	        cin >> x >> y;
                if (S.lookup(x,y) != nil) cout << "yes";
                else cout << "no";
                newline;
                break;
               }


    case 'l': { L = S.all_items();
                forall(it,L) 
                  cout << S.key1(it) << " " << S.key2(it) << "\n";
                newline;
                break;
               }


    } //switch

  } //for

  return 0;
}
