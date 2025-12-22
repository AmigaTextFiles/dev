/*--------------------------------------------------------
  Lists.hpp
  Version: 1.14
  Date: 21 april 98
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: List handling classes
	Relatif Get() to actual position =>speed up searching
	ListHeader for list of element
	PList for list of pointeur
	Plist.ClearList delete entry in an iterative way (avoid stack problem)
--------------------------------------------------------------*/
#ifndef LISTS_H
#define LISTS_H

#ifdef __GNUC__
// #include <vector>
#endif

#ifndef STL
/*----------------------------------------
  List Manager of different classes/types
------------------------------------------*/
// ListEntry
template <class TYPE> class VListEntry {
private:
public:
	TYPE data;
	VListEntry<TYPE> *previous;
	VListEntry<TYPE> *next;

	VListEntry(VListEntry<TYPE> *p,TYPE d,VListEntry<TYPE> *n) {
	    previous=p;
	    if (p!=NULL) p->next=this;
	    data=d;
	    next=n;
	    if (next!=NULL) next->previous=this;
	    // puts("ListEntry construtor");
	};
	~VListEntry(){
	    // Delete only The NList, not the data
	    // puts("ListEntry destructor");
	    // if (next!=NULL) delete (next);
	};
};           

/*-----------------------------------------------------------
  ListHeader
  only interface with this class, not with ListEntry
-------------------------------------------------------------*/
template <class TYPE> class VList {
private:
	int length;
	int position;
	VListEntry<TYPE> *first;
	VListEntry<TYPE> *current;
	VListEntry<TYPE> *tail;
public:
	VList() {
	    // puts("VList constructor");
	    first=NULL;tail=NULL;current=NULL;
	    length=0;position=-1;
	};
	~VList(){
	    // puts("VList destructor");
	    ClearList();
	};                                      

	void Set(int where, TYPE n) {
	    VListEntry<TYPE> *c=GetListEntry(where);
	    if (c!=NULL) c->data=n;
	};

	void Add(TYPE d) {
	    if (length==0) {
		// puts("FIRST ELEMENT added");
		first=new VListEntry<TYPE>(NULL,d,NULL);
		tail=first;current=first;
		position=0;length=1;
	    }
	    else {
		 // puts("ELEMENT added AT LAST POSITION");
		 tail->next=new VListEntry<TYPE>(tail,d,NULL);
		 tail=tail->next;
		 length++;
	    };
	};

	void InsertAfter(int where, TYPE d) {
	    if (length==0) {
		Add(d);
	    }
	    else if (where==-1) {
		first=new VListEntry<TYPE>(NULL,d,first);
		position++;length++;
	    }
	    else if (where==length-1) {
		Add(d);
	    }
	    else {
		VListEntry<TYPE> *c=GetListEntry(where);
		if (c!=NULL) {
			c->next=new VListEntry<TYPE>(c,d,c->next);
			length++;
		};
	    };
	};

	TYPE RemoveEntry(int where) {
	    VListEntry<TYPE> *c=GetListEntry(where);
	    TYPE d;

	    if (c!=NULL) {
		d=c->data;
		if ((where==0)&&
		    (length==1)) {
		    // puts("Remove FIRST ELEMENT=>Empty list");
		    delete c;
		    length=0;position=-1;
		    current=NULL;first=NULL;tail=NULL;
		    return d;
		}
		else if (where==0) {
		    // puts("Remove FIRST ELEMENT");
		    first=first->next;
		    first->previous=NULL;
		    c->next=NULL;
		    delete c;
		    length--;position--;
		    if (position==-1) {current=first;position=0;};
		    return d;
		}
		else if (where==length-1) {
		    // puts("Remove LAST ELEMENT");
		    tail=tail->previous;
		    tail->next=NULL;
		    c->previous=NULL;
		    delete c;
		    length--;
		    if (position==length) {current=tail;position--;};
		    return d;
		}
		else {
		    // puts("Remove an element");
		    c->previous->next=c->next;
		    c->next->previous=c->previous;
		    if (position==where) {current=c->next;};
		    c->next=NULL;
		    delete c;
		    length--;
		    return d;
		};
	    }; // endif != NULL
	};            

	void Exchange(int source, int dest) {
		VListEntry<TYPE> *cs=GetListEntry(source);
		VListEntry<TYPE> *cd=GetListEntry(dest);
		TYPE temp=cs->data;
		cs->data=cd->data;
		cd->data=temp;
	};
	VListEntry<TYPE> *GetFirstListEntry() {return first;};
	TYPE& GetFirst() {return first->data;};
	TYPE GetFirstCopy() {return first->data;};

	VListEntry<TYPE> *GetCurrentListEntry() {return current;};
	TYPE& GetCurrent() {return current->data;};
	TYPE GetCurrentCopy() {return current->data;};

	VListEntry<TYPE> *GetTailListEntry() {return tail;};
	TYPE& GetTail() {return tail->data;};
	TYPE GetTailCopy() {return tail->data;};

	int HowMuch() {return length;};
	int Length() {return length;};
	int Getposition() {return position;};

	// Main method to navigate in the list
	VListEntry<TYPE> *GetListEntry(int where) {
	    int diff=where-position;
	    if (diff<0) {
		for (int i=0;i<-diff;i++) {
		    if (current->previous!=NULL) {
			current=current->previous;
			position--;
		    }
		    else {
			return NULL;
		    };
		};
	    }
	    else if (diff>0) {
		for (int i=0;i<diff;i++) {
		    if (current->next!=NULL) {
			current=current->next;
			position++;
		    }
		    else {
			return NULL;
		    };
		};
	    };
	    return current;
	};

	// Search in list and return reference or copy
	TYPE& Get(int where) {
	    return GetListEntry(where)->data;
	};
	TYPE GetCopy(int where) {
	    return GetListEntry(where)->data;
	};

	void ClearList() {
	    VListEntry<TYPE> *ce=first,*ne=NULL;
	    if (first) ne=first->next;
	    for (int i=0;i<length;i++) {
		// printf("deleting %i in list\n",i);
		if (ce) ne=ce->next;
		delete ce;
		ce=ne;
	    };
	    length=0;position=-1;
	    first=NULL;tail=NULL;current=NULL;
	};
};
/*-----------------------------------
  Pointer List
-------------------------------------*/
// PListEntry
template <class TYPE> class PListEntry {
private:
public:
	TYPE *data;
	PListEntry<TYPE> *previous;
	PListEntry<TYPE> *next;

	PListEntry(PListEntry<TYPE> *p,TYPE *d,PListEntry<TYPE> *n) {
	    previous=p;
	    if (p!=NULL) p->next=this;
	    data=d;
	    next=n;
	    if (next!=NULL) next->previous=this;
	    // puts("PListEntry construtor");
	};
	~PListEntry(){
	    // puts("PListEntry destructor");
	    if (data!=NULL) delete data;
	    // if (next!=NULL) delete next;
	};
};           

template <class TYPE> class PList {
private:
	int length;
	int position;
	PListEntry<TYPE> *first;
	PListEntry<TYPE> *current;
	PListEntry<TYPE> *tail;
public:
	PList() {
	    // puts("PList constructor");
	    first=NULL;tail=NULL;current=NULL;
	    length=0;position=-1;
	};
	~PList(){
	    // puts("PList destructor");
	    ClearList();
	};

	int Length() {return length;};

	void Set(int where, TYPE *n) {
	    PListEntry<TYPE> *c=GetPListEntry(where);
	    if (c!=NULL) c->data=n;
	};
	TYPE *Get(int where) {
	    if (where>length-1) where=length-1;
	    return GetPListEntry(where)->data;
	};
	void Add(TYPE *d) {
	    if (length==0) {
		// puts("FIRST ELEMENT added");
		first=new PListEntry<TYPE>(NULL,d,NULL);
		tail=first;current=first;
		position=0;length=1;
	    }
	    else {
		 // puts("ELEMENT added AT LAST POSITION");
		 tail->next=new PListEntry<TYPE>(tail,d,NULL);
		 tail=tail->next;
		 length++;
	    };
	};

	void InsertAfter(int where, TYPE *d) {
	    if (length==0) {
		Add(d);
	    }
	    else if (where==-1) {
		first=new PListEntry<TYPE>(NULL,d,first);
		position++;length++;
	    }
	    else if (where==length-1) {
		Add(d);
	    }
	    else {
		PListEntry<TYPE> *c=GetPListEntry(where);
		if (c!=NULL) {
			c->next=new PListEntry<TYPE>(c,d,c->next);
			length++;
		};
	    };
	};

	TYPE *RemoveEntry(int where) {
	    PListEntry<TYPE> *c=GetPListEntry(where);
	    TYPE *d;

	    if (c!=NULL) {
		d=c->data;
		if ((where==0)&&
		    (length==1)) {
		    // puts("Remove FIRST ELEMENT=>Empty list");
		    c->data=NULL;
		    delete c;
		    length=0;position=-1;
		    current=NULL;first=NULL;tail=NULL;
		    return d;
		}
		else if (where==0) {
		    // puts("Remove FIRST ELEMENT");
		    first=first->next;
		    first->previous=NULL;
		    c->next=NULL;
		    c->data=NULL;
		    delete c;
		    length--;position--;
		    if (position==-1) {current=first;position=0;};
		    return d;
		}
		else if (where==length-1) {
		    // puts("Remove LAST ELEMENT");
		    tail=tail->previous;
		    tail->next=NULL;
		    c->previous=NULL;
		    c->data=NULL;
		    delete c;
		    length--;
		    if (position==length) {current=tail;position--;};
		    return d;
		}
		else {
		    // puts("Remove an element");
		    c->previous->next=c->next;
		    c->next->previous=c->previous;
		    if (position==where) {current=c->next;};
		    c->next=NULL;
		    c->data=NULL;
		    delete c;
		    length--;
		    return d;
		};
	    }; // endif != NULL
	};

	void Exchange(int source, int dest) {
		PListEntry<TYPE> *cs=GetPListEntry(source);
		PListEntry<TYPE> *cd=GetPListEntry(dest);
		TYPE *temp=cs->data;
		cs->data=cd->data;
		cd->data=temp;
	};
	
	// Main method to navigate in the list
	PListEntry<TYPE> *GetPListEntry(int where) {
	    int diff=where-position;
	    if (diff<0) {
		for (int i=0;i<-diff;i++) {
		    if (current->previous!=NULL) {
			current=current->previous;
			position--;
		    }
		    else {
			return NULL;
		    };
		};
	    }
	    else if (diff>0) {
		for (int i=0;i<diff;i++) {
		    if (current->next!=NULL) {
			current=current->next;
			position++;
		    }
		    else {
			return NULL;
		    };
		};
	    };
	    return current;
	};

	void ClearList() {
	    // puts("In ClearList");
	    PListEntry<TYPE> *ce=first,*ne=NULL;
	    if (first) ne=first->next;
	    for (int i=0;i<length;i++) {
		// printf("deleting %i in list\n",i);
		if (ce) ne=ce->next;
		delete ce;
		ce=ne;
	    };

	    // if (first!=NULL) delete first;
	    length=0;position=-1;
	    first=NULL;tail=NULL;current=NULL;
	};

	/*
	void operator= (PList<TYPE> sl) {
	    ClearList();
	    for (int i=0;i<sl.Length();i++) {
		Add(sl.Get(i));
	    };
	};
	*/
};
#else
/* STL form*/
template <class TYPE> class PList {
private:
    vector<TYPE*> vec;
public:
    PList():vec() {};
    ~PList() {};

    int Length() {return vec.size();};

    void Set(int where, TYPE *t) {
	if (where<0) where=0;
	if (where>vec.size()) {where=vec.size()-1;};
	vec[where]=t;
    };
    TYPE *Get(int where) {return vec[where];};
    void Add(TYPE *t) {
	vec.push_back(t);
    };
    void InsertAfter(int where, TYPE *t) {
	vec.insert(vec.begin()+where+1,t);
    };
    TYPE *RemoveEntry(int where) {
	if (where<0) {where=0;};
	if (where>vec.size()) {where=vec.size()-1;};
	TYPE *t=vec[where];
	vec.erase(vec.begin()+where);
	return t;
    };
    void Exchange(int source, int dest) {
	TYPE *tmp=vec[source];
	vec[source]=vec[dest];
	vec[dest]=tmp;
    };
    void ClearList() {
	vector<TYPE*>::iterator i=vec.begin();
	while (i!=vec.end()) {
	    delete *(i);
	    i++;
	};
	vec.erase(vec.begin(),vec.end());
    };
};


template <class TYPE> class VList {
private:
    vector<TYPE> vec;
public:
    VList():vec() {};
    ~VList() {};

    int Length() {return vec.size();};

    void Set(int where, TYPE t) {
	if (where<0) where=0;
	if (where>vec.size()) {where=vec.size()-1;};
	vec[where]=t;
    };
    TYPE Get(int where) {return vec[where];};
    void Add(TYPE t) {
	vec.push_back(t);
    };
    void InsertAfter(int where, TYPE t) {
	vec.insert(vec.begin()+where+1,t);
    };
    TYPE RemoveEntry(int where) {
	if (where<0) {where=0;};
	if (where>vec.size()) {where=vec.size()-1;};
	TYPE t=vec[where];
	vec.erase(vec.begin()+where);
	return t;
    };
    void Exchange(int source, int dest) {
	TYPE tmp=vec[source];
	vec[source]=vec[dest];
	vec[dest]=tmp;
    };
    void ClearList() {
	vec.erase(vec.begin(),vec.end());
    };
};
#endif
#endif


