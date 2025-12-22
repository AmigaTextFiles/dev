/******************************************************************************
	Dynamic Binary Search Tree.
	Check dbstree.tex for info.
******************************************************************************/

#ifndef HAVE_DBSTREE
#define HAVE_DBSTREE

#define DBS_MAGIC 32
extern char *StrDup (char*);

class dbsNode;

class dbsTree
{
friend	class dbsNode;
	dbsNode **FoundSlot;
	dbsNode *gNode;
	int FoundDepth;
	void tree_to_array	(dbsNode*);
	void walk_tree		(dbsNode*, void (*)(dbsNode*));
	void walk_tree_io	(dbsNode*, void (*)(dbsNode*));
	void walk_tree_d	(dbsNode*, void (*)(dbsNode*));
	int dflag, tmp;
	bool tb;
   public:
	dbsNode *root;
	int nnodes;
	dbsTree		();
	void		dbsBalance	();
	dbsNode*	dbsFind		();
	void		dbsRemove	(dbsNode*);
	void		copytree	(void (*)(dbsNode*));
	void		foreach		(void (*)(dbsNode*));
	void		deltree		(void (*)(dbsNode*));
};

class dbsNode
{
friend	class dbsTree;
	dbsNode *less, *more;
	dbsNode*	myParent	(dbsTree*);
   protected:
	void		addself		(dbsTree*);
virtual	int		compare		(dbsNode*) = 0;
virtual	int		compare		() = 0;	/* C Comment */

   public:
	dbsNode (dbsTree*);
virtual ~dbsNode ();
};

#define DBS_STRQUERY dbsNodeStr::Query
class dbsNodeStr : protected dbsNode
{
	int compare (dbsNode*);
	int compare ();
   public:
	dbsNodeStr (dbsTree*);
	char *Name;
	~dbsNodeStr ();

static	char *Query;
};

#endif
