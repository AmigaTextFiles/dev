#include <LEDA/sortseq.h>
#include <LEDA/impl/skiplist.h>
#include <LEDA/impl/ab_tree.h>
#include <LEDA/impl/bin_tree.h>


#if !defined(__TEMPLATE_ARGS_AS_BASE__)
declare3(_sortseq,int,int,skiplist)
declare3(_sortseq,int,int,ab_tree)
declare3(_sortseq,int,int,bin_tree)
#endif

void seq_test(sortseq<int,int>& D, int N, int* A, char* name)
{ int i;
  float T0 = used_time();
  float T  = T0;

  cout << string("%-10s",name);
  cout.flush();

  for(i=0; i<N; i++)  D.insert(A[i],0);
  cout << string("%10.2f",used_time(T));
  cout.flush();

  for(i=0; i<N; i++)  D.lookup(A[i]);
  cout << string("%10.2f",used_time(T));
  cout.flush();

  for(i=0; i<N; i++)  D.del(A[i]);
  cout << string("%10.2f",used_time(T));

  cout << string("%10.2f",used_time(T0));
  newline;
}


main()
{

  sortseq<int,int>           RS_SEQ;

#if defined(__TEMPLATE_ARGS_AS_BASE__)
  _sortseq<int,int,skiplist> SKIP_SEQ;
  _sortseq<int,int,ab_tree>  AB_SEQ;
  _sortseq<int,int,bin_tree> BIN_SEQ;
#else
  _sortseq(int,int,skiplist) SKIP_SEQ;
  _sortseq(int,int,ab_tree)  AB_SEQ;
  _sortseq(int,int,bin_tree) BIN_SEQ;
#endif


  int     N = read_int("# keys = ");
  int* RAND = new int[N];

  for(int i=0; i<N; i++) RAND[i] = random(0,1000000);

  newline;
  cout << "               insert    lookup    delete     total";
  newline;
  newline;

  seq_test(RS_SEQ,N,RAND,"rs_tree");
  seq_test(SKIP_SEQ,N,RAND,"skiplist");
  seq_test(AB_SEQ,N,RAND,"ab_tree");
  seq_test(BIN_SEQ,N,RAND,"bin_tree");

  return 0;
}
