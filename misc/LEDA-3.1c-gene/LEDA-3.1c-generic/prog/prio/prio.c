#include <LEDA/prio.h>


//void show(priority_queue<double,string> Q)

void show(priority_queue<double,string>& Q)
{ pq_item it;
  while (!Q.empty())
  { it = Q.find_min();
    cout << "delete: " << Q.key(it) << " " << Q.inf(it) << "\n";
    Q.del_item(it);
   }
}

main()

{ priority_queue<double,string> Q;
  double r;

  while (cin >> r) Q.insert(r,string("inf = %f",r));

  show(Q);
  newline;

  show(Q);
  newline;

  return 0;
}
