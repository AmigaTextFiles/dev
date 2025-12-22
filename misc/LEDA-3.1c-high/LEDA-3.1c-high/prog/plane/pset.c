#include <LEDA/point_set.h>




main()
{

  point_set<string> S;

  list<ps_item> L;
  ps_item       it=nil;
  point         p; 
  char          ch;



  while (ch != 'q')
  { 
    cout << "(r/s/f/n/i/d/D/l/q): ";
    cin  >> ch;

    float T  = used_time();
     
    switch(ch) {

    case 'i':  { cout << "insert point: ";
                 cin >> p;
                 S.insert(p,string("x = %f",p.xcoord()));
                 break;
                }

     case 'n': { cout << "nearest neighbor: ";
	         cin >> p;
                 it = S.nearest_neighbor(p);
                 if (it!=nil) cout << S.key(it);
                 else cout << "Empty point set.\n";	
                 newline;
                 break;
               }


    case 'r' : { init_random();
                 int n = read_int("#random points = ");
                 while (n--)
                 { double x = random(1,1000)/100.0;
                   double y = random(1,1000)/100.0;
                   S.insert(point(x,y),string("x = %f",x));
                  }
                 cout << string("time: %6.2f\n",used_time(T));
                 break;
                }

    case 's': { double a=read_real("x0=");
                double b=read_real("x1=");
                double c=read_real("y0=");
                double d=read_real("y1=");
  
                L = S.range_search(a,b,c,d);
  
                forall(it,L) cout << S.key(it) << " " << S.inf(it) << "\n";
                newline;
              
                cout << string("time: %6.2f\n",used_time(T));
                break;
              }


    case 'd': { cout << "delete point: ";
	        cin >> p;
                S.del(p);
                break;
               }

    case 'D': { double a=read_real("x0=");
                double b=read_real("x1=");
                double c=read_real("y0=");
                double d=read_real("y1=");
  
                L = S.range_search(a,b,c,d);
  
                forall(it,L) 
                { point p = S.key(it);
                  cout << "delete: " << p <<"\n";
                  S.del(p);
                 }
                newline;
              
                cout << string("time: %6.2f\n",used_time(T));
                break;
              }


    case 'f': { cout << "find point: ";
	        cin >> p;
                if (S.lookup(p) != nil) cout << "yes";
                else cout << "no";
                newline;
                break;
               }


    case 'l': { L = S.all_items();
                forall(it,L) 
                  cout << S.key(it) << " " << S.inf(it) << "\n";
                newline;
                break;
               }


    } //switch

  } //for

  return 0;
}
