/*-------------------------------------------------------
  Stack.hpp
  Version 1.01
  Date: 18 february 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: LIFO stack classes
-------------------------------------------------------*/
#ifndef STACK_HPP
#define STACK_HPP
template <class TYPE> class StackEntry {
private:
public:
        TYPE data;
        // StackEntry<TYPE> *next;
        StackEntry<TYPE> *previous;
        
        StackEntry(StackEntry<TYPE> *p,TYPE d) {
                previous=p;
                // if (p!=NULL) p->next=this;
                data=d;
                // next=NULL;
        };
        ~StackEntry() {
                if (previous!=NULL) {
                        delete previous;
                };
        };
};           

template <class TYPE> class LIFOStack {
private:
        int entrys;
        StackEntry<TYPE> *current;
public:
        LIFOStack() {
            // puts("LIFOStack constructor");
            entrys=0;current=NULL;
        };
        ~LIFOStack() {
                if (current!=NULL) delete current;
        };

        void Push(TYPE d) {
                current=new StackEntry<TYPE> (current,d);
                entrys++;
        };
        TYPE Pop() {
                TYPE d;
                if (entrys<=0) return 0;
                d=current->data;
                StackEntry<TYPE> *c=current;
                current=current->previous;
                c->previous=NULL;
                delete(c);
                entrys--;
                return d;
        };
        int Size() {return entrys;};
        void ClearStack() {
            if (current!=NULL) delete current;
            entrys=0;current=NULL;
        };
};
#endif
