#include <LEDA/basic.h>
#include <LEDA/list.h>
#include <LEDA/array.h>



int main () 
{
  int i;
  int N = read_int("N = "); 

  float T = used_time();

  cout << "building arrays      ";
  cout.flush();

  array<int>    Ai(N);
  array<float>  Af(N);
  array<double> Ad(N);

  for (i = 0; i < N; i++) Ad[i] = Af[i] = Ai[i] = random(1,1000000);

  cout << string("  %5.3f sec",used_time(T));
  newline;
 

  cout << "building lists       ";
  cout.flush();

  list<int>     Li;
  list<float>   Lf;
  list<double>  Ld;

  for (i = 0; i < N; i++) 
  { Li.append(Ai[i]);
    Lf.append(Af[i]);
    Ld.append(Ad[i]);
  }
  cout << string("  %5.3f sec",used_time(T));
  newline;
  newline;

  cout << "sorting array<int>   ";
  cout.flush();
  Ai.sort();
  cout << string("  %5.3f sec",used_time(T));
  newline;
 

  cout << "sorting again        ";
  cout.flush();
  Ai.sort();
  cout << string("  %5.3f sec",used_time(T));
  newline;


  cout << "sorting array<float> ";
  cout.flush();
  Af.sort();
  cout << string("  %5.3f sec",used_time(T));
  newline;

  cout << "sorting array<double>";
  cout.flush();
  Ad.sort();
  cout << string("  %5.3f sec",used_time(T));
  newline;
  newline;


  cout << "sorting list<int>    ";
  cout.flush();
  Li.sort();
  cout << string("  %5.3f sec",used_time(T));
  newline;

  cout << "sorting again        ";
  cout.flush();
  Li.sort();
  cout << string("  %5.3f sec",used_time(T));
  newline;

  cout << "sorting list<float>  ";
  cout.flush();
  Lf.sort();
  cout << string("  %5.3f sec",used_time(T));
  newline;

  cout << "sorting list<double> ";
  cout.flush();
  Ld.sort();
  cout << string("  %5.3f sec",used_time(T));
  newline;
  newline;

  cout << "test sorting         ";
  cout.flush();

  for(i=0;i<N;i++)
  { int    x = Li.pop();
    float  y = Lf.pop();
    double z = Ld.pop();
    if (x != y || y != z || z != Ai[i] || Ai[i] != Af[i] || Af[i] != Ad[i]) 
      cout << "ERROR\n";
   }
  cout << string("  %5.3f sec",used_time(T));
  newline;


}


