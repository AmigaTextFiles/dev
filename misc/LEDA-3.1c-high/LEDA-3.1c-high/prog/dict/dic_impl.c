#include <LEDA/dictionary.h>

/* a simple dictionary implementation by doubly linked lists */


#include <LEDA/list.h>

class list_dic_pair
{
  friend class dic_impl;

  GenPtr key;
  GenPtr inf;

  public:
  list_dic_pair(GenPtr k=0, GenPtr i=0) { key = k;  inf = i; }
  list_dic_pair(const list_dic_pair& p) { key = p.key; inf = p.inf; }

  LEDA_MEMORY(list_dic_pair)
};


// we define dummy I/O and compare routines

void Print(const list_dic_pair&, ostream&)  {}
void Read(list_dic_pair&,istream&) {}
int  compare(const list_dic_pair&,const list_dic_pair&) { return 0; }


#if !defined(__TEMPLATE_FUNCTIONS__)
LEDA_TYPE_PARAMETER(list_dic_pair)
#endif


class dic_impl {

private:

virtual int  cmp(GenPtr, GenPtr) const = 0;
virtual void clear_key(GenPtr&)  const = 0;
virtual void clear_inf(GenPtr&)  const = 0;
virtual void copy_key(GenPtr&)   const = 0;
virtual void copy_inf(GenPtr&)   const = 0;


/* simple example implementation by a doubly linked list */

list<list_dic_pair> L;

public:

 dic_impl();
 dic_impl(const dic_impl&);
 virtual ~dic_impl();

dic_impl& operator=(const dic_impl&);

GenPtr key(list_item p)  const;
GenPtr inf(list_item p)  const;

list_item item(GenPtr) const;

list_item insert(GenPtr,GenPtr);
list_item lookup(GenPtr)  const;
list_item first_item() const;
list_item next_item(list_item) const;

void    change_inf(list_item,GenPtr);
void    del_item(list_item);
void    del(GenPtr);
void    clear();

int     size()        const;

};



inline dic_impl::dic_impl()  {}
inline dic_impl::~dic_impl() { clear(); }

inline int    dic_impl::size() const            { return L.size(); }
inline GenPtr dic_impl::key(list_item i)  const { return L[i].key; }
inline GenPtr dic_impl::inf(list_item i)  const { return L[i].inf; }

inline list_item dic_impl::item(GenPtr p) const { return list_item(p); }
inline list_item dic_impl::first_item()   const { return L.first(); }
inline list_item dic_impl::next_item(list_item i) const 
                                                { return L.next_item(i); }


dic_impl::dic_impl(const dic_impl& D) 
{ list_item i;
  L = D.L;
  forall_items(i,L) 
  { D.copy_key(L[i].key);
    D.copy_inf(L[i].inf);
   }
 }


dic_impl& dic_impl::operator=(const dic_impl& D)
{ if (this == &D) return *this;
  clear(); 
  L = D.L;
  list_item i;
  forall_items(i,L) 
  { D.copy_key(L[i].key);
    D.copy_inf(L[i].inf);
   }
  return *this;
 }


list_item  dic_impl::insert(GenPtr key, GenPtr inf) 
{  list_item i = lookup(key);
   if (i != nil)
     { clear_inf(L[i].inf);
       copy_inf(inf);
       L[i].inf = inf;
       return i;
      }
   else
     { copy_key(key);
       copy_inf(inf);
       return L.push(list_dic_pair(key,inf));
      }
}


list_item  dic_impl::lookup(GenPtr key)  const
{ for(list_item i = L.first(); i; i = L.succ(i))
    if (L[i].key == key) break;
  return i;
 }


void    dic_impl::change_inf(list_item i, GenPtr inf)
{ clear_inf(L[i].inf);
  copy_inf(inf);
  L[i].inf = inf;
 }

void    dic_impl::del_item(list_item i)
{ clear_key(L[i].key);
  clear_inf(L[i].inf);
  L.del(i);
}

void    dic_impl::del(GenPtr key)
{ list_item i = lookup(key);
  if (i!=nil) del_item(i);
 }

void    dic_impl::clear() 
{ list_item i;
  forall_items(i,L)
  { clear_key(L[i].key);
    clear_inf(L[i].inf);
   }
  L.clear();
 }





#if !defined(__TEMPLATE_ARGS_AS_BASE__)
declare3(_dictionary,int,int,dic_impl)
#endif


main() 
{ 
#if defined(__TEMPLATE_ARGS_AS_BASE__)
  _dictionary<int,int,dic_impl> D; 
#else
  _dictionary(int,int,dic_impl) D; 
#endif

  dic_item it;

  int N = read_int("N = ");

  while (N--)
  { int k = random(1,20);
    it = D.lookup(k);
    if (it == nil) 
       D.insert(k,1);
    else
       D.change_inf(it,D.inf(it)+1);
   }

  forall_items(it,D) 
     cout << string("%3d  # = %2d\n",D.key(it),D.inf(it));

 }

