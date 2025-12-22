// functions for unwind test (exceptions handling)
// Author: Dominique Lorre

#include "iostream.h"

void func_ARETURN(void) ;
void func_RANGEERROR(void) ;
void func_KEEPONGOING(void) ;
void func_ENDPROG(void) ;

// These functions inform us about the the state of the program

void  func_ARETURN(void)
{
    cout << "A is returning\n" ;
}
void func_RANGEERROR(void)
{
    cout << "Range error\n" ;
}
void func_KEEPONGOING(void)
{
    cout << "Keep on going\n" ;
}

void func_ENDPROG(void)
{
    cout << "end of prog\n" ;
}
