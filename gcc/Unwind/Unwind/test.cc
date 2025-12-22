// Test of unwind for exception handling with G++
// Author : Dominique Lorre

extern void func_ARETURN(void) ;
extern void func_RANGEERROR(void) ;
extern void func_KEEPONGOING(void) ;
extern void func_ENDPROG(void) ;

// A is a simple class
class A
{
    int x ;
public:
    class Range {} ;  // The exception Range is declared here
    A(int sz) ;
};

A::A(int sz)
{
    if (sz < 0) throw Range() ; // the exception is throwed if sz < 0
}

void test_except()
{
A *p ;
    try {
        p = new A(-2) ; // throw the exception here
/*        p = new A(2) ; // do not throw the exception here */
        func_ARETURN() ; // will not return if exception is generated
    }
    catch(A::Range) {
        func_RANGEERROR() ; // the exception is catched and handled here
    }
    func_KEEPONGOING() ; // the end of the program

}

void main()
{
    test_except() ;
    func_ENDPROG() ;
}

