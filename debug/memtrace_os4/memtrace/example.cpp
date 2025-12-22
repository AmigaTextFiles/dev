#include <cstdlib>
#include <iostream>


#include "memtrace/memtrace.h"

#include "example_obj.h"  //to access fubction in separately compiled object

using namespace std;




int main(int argc, char *argv[])
{
 memtrace.unlock();   //make sure memtrace logs

 //simple allocations 
 char *s = new char[80];    
 char *a = new char;
 char *b = new char[10];
 char *c = (char*)malloc(111);

 cout << endl;

 //now illeagal deallocations
 free(a);
 delete[] a;
 delete c;
 delete[] c;
 
 cout << endl;
 
 //print current list content
 memtrace.printList(OBJECT);
 memtrace.printList(ARRAY);
 memtrace.printList(C_MALLOC);

 cout << endl;

 //now we test, if a memory block we want to access is allocated
 //-> requested block must be within an allocated block
 cout << "Allocation checks:" << endl;
 cout << memtrace.checkAllocation((void*) a, 10) << endl;  //from adress 10 bytes (false)
 cout << memtrace.checkAllocation((void*) s, 80) << endl;  //from adress 80 bytes (true)
 cout << memtrace.checkAllocation((void*) s, 81) << endl;  //from adress 81 bytes (false)

 cout << endl;

 //now some legal deallocations
 delete a;
 delete[] s;
 free(c);
 
 cout << endl;
 
 //now a function call that produces a memory leak
 test();
 
 cout << endl;
 
 //whats left in the lists? 
 //memtrace has a destructor, called on program exit; lists will be dumped, if configured

 return EXIT_SUCCESS;
}
