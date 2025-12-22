#include <LEDA/impl/skiplist.h>
#include <LEDA/stream.h>

main(int argc, char** argv)
{
  string_istream args(argc-1,argv+1);

  float p0 = 0.20;
  float p1 = 0.60;

  int   N  = 10000;

  args >> p0 >> p1 >> N;

  cout << string("# keys = %d     p0 = %f   p1 = %f\n",N,p0,p1);
  newline;

  GenPtr* RAND = new GenPtr[N];

  init_random(12345);

  for(int i=0; i<N; i++) RAND[i] = (GenPtr)random(0,MAXINT-1);

  float T0 = used_time();
  float T  = used_time();


  newline;
  cout << "               insert    lookup    delete     total\n";
  newline;

  for(float prob = p0; prob < p1; prob += 0.01)
  { 
    skiplist skip(prob);

    cout << string("p = %4.2f   ",prob);
    cout.flush();

    for(i=0; i<N; i++)  skip.insert(RAND[i],0);
    cout << string("%10.2f",used_time(T));
    cout.flush();


    for(i=0; i<N; i++)  skip.lookup(RAND[i]);
    cout << string("%10.2f",used_time(T));
    cout.flush();

    for(i=0; i<N; i++)  skip.del(RAND[i]);
    cout << string("%10.2f",used_time(T));

    cout << string("%10.2f",used_time(T0));
    newline;

   }

  return 0;
}
