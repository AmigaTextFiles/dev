typedef struct _Node
{
	struct _Node * next;
	struct _Node * prev;
} Node;

typedef struct
{
	Node * dummyheadnext;
	Node * dummynull;
	Node * dummytailprev;
} List;


void listcreate(List *);

void listinsert(APTR, APTR);
void listremove(APTR);
void listaddhead(List *, APTR);
void listaddtail(List *, APTR);
void listremovehead(List *);
void listremovetail(List *);

BOOL listisempty(List *);
BOOL listishead(APTR);
BOOL lististail(APTR);

APTR listhead(List *);
APTR listtail(List *);
APTR listnext(APTR);
APTR listprev(APTR);

LONG listlen(List *);
