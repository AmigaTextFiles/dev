#include <LEDA/prio.h>

#include <LEDA/impl/m_heap.h>
#include <LEDA/impl/k_heap.h>
#include <LEDA/impl/p_heap.h>
#include <LEDA/impl/list_pq.h>

typedef float FLOAT;


#if !defined(__TEMPLATE_ARGS_AS_BASE__)
declare3(_priority_queue,int,int,m_heap)
declare3(_priority_queue,int,int,k_heap)
declare3(_priority_queue,int,int,p_heap)
declare3(_priority_queue,int,int,list_pq)

declare3(_priority_queue,FLOAT,FLOAT,m_heap)
declare3(_priority_queue,FLOAT,FLOAT,k_heap)
declare3(_priority_queue,FLOAT,FLOAT,p_heap)
declare3(_priority_queue,FLOAT,FLOAT,list_pq)
#endif

void prio_test(priority_queue<int,int>& D, int N, int* A, char* name)
{ 
  pq_item* I = new pq_item[N];

  cout << string("%-12s",name);
  cout.flush();

  float T;
  float T0 = T = used_time();

  for(int i=0; i<N; i++)  I[i] = D.insert(i,A[i]);
  cout << string("%10.2f",used_time(T));
  cout.flush();

  for(i=0; i<N; i++)  D.decrease_inf(I[i],A[i]/2);
  cout << string("%14.2f",used_time(T));
  cout.flush();

  int old_min = -MAXINT;

  for(i=0; i<N; i++)  
  { if (D.inf(D.find_min()) < old_min) cout << "error in del_min\n";
    old_min = D.inf(D.find_min()); 
    D.del_min();
   }

  cout << string("%10.2f",used_time(T));

  cout << string("%10.2f",used_time(T0));

  if (!D.empty()) cout << " NOT EMPTY !!\n";	

  newline;

  delete I;
}


void prio_test(priority_queue<FLOAT,FLOAT>& D, int N, FLOAT* A, char* name)
{ 
  pq_item* I = new pq_item[N];

  cout << string("%-12s",name);
  cout.flush();

  float T;
  float T0 = T = used_time();


  for(int i=0; i<N; i++)  I[i] = D.insert(i,A[i]);
  cout << string("%10.2f",used_time(T));
  cout.flush();

  for(i=0; i<N; i++)  D.decrease_inf(I[i],A[i]/2);
  cout << string("%14.2f",used_time(T));
  cout.flush();

  FLOAT old_min = -MAXINT;

  for(i=0; i<N; i++)  
  { if (D.inf(D.find_min()) < old_min) cout << "error in del_min\n";
    old_min = D.inf(D.find_min());
    D.del_min();
   }

  cout << string("%10.2f",used_time(T));

  cout << string("%10.2f",used_time(T0));

  if (!D.empty()) cout << " NOT EMPTY !!\n";	

  newline;

  delete I;
}



main()
{ priority_queue<int,int>            Q;
  priority_queue<FLOAT,FLOAT>        Qf;

  int    N     = read_int("# keys = ");
  int*   Int   = new int[N];
  FLOAT* Float = new FLOAT[N];

  for(int i=0; i<N; i++) Float[i] = Int[i] = random(0,200000);//-100000;

#if defined(__TEMPLATE_ARGS_AS_BASE__)
  _priority_queue<int,int,m_heap>    m_q(N);
  _priority_queue<int,int,k_heap>    k_q(N);
  _priority_queue<int,int,p_heap>    p_q;
  _priority_queue<int,int,list_pq>   l_q;

  _priority_queue<FLOAT,FLOAT,m_heap>    m_qf(N);
  _priority_queue<FLOAT,FLOAT,k_heap>    k_qf(N);
  _priority_queue<FLOAT,FLOAT,p_heap>    p_qf;
  _priority_queue<FLOAT,FLOAT,list_pq>   l_qf;
#else
  _priority_queue(int,int,m_heap)    m_q(N);
  _priority_queue(int,int,k_heap)    k_q(N);
  _priority_queue(int,int,p_heap)    p_q;
  _priority_queue(int,int,list_pq)   l_q;

  _priority_queue(FLOAT,FLOAT,m_heap)    m_qf(N);
  _priority_queue(FLOAT,FLOAT,k_heap)    k_qf(N);
  _priority_queue(FLOAT,FLOAT,p_heap)    p_qf;
  _priority_queue(FLOAT,FLOAT,list_pq)   l_qf;
#endif


  newline;
  cout << "                insert   decrease_inf  del_min    total\n";
  newline;

  prio_test(Q,N,Int,"prio");
  //prio_test(m_q,N,Int,"m_heap");
  prio_test(k_q,N,Int,"k_heap");
  prio_test(p_q,N,Int,"p_heap");
  //prio_test(l_q,N,Int,"list_pq");
  newline;


  prio_test(Qf,N,Float,"prio");
  //prio_test(m_qf,N,Float,"m_heap");
  prio_test(k_qf,N,Float,"k_heap");
  prio_test(p_qf,N,Float,"p_heap");
  //prio_test(l_qf,N,Float,"list_pq");
  newline;
 
  return 0;
}
