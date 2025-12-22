/******************************************************************************
	Interger Key Binary Tree.
	O(1)
******************************************************************************/

class intNode;

class intTree
{
friend	class intNode;
	unsigned int Query;
	intNode **FoundSlot;
   public:
	intNode *root;
	int cnt;
	intTree		();
	intNode*	intFind		(unsigned int);
};

class intNode
{
friend	class intTree;
	intNode *less, *more;
	void addself	(intTree*);
   protected:
	void intRemove	(intTree*);
   public:
	unsigned int Key;
	intNode (intTree*);
	~intNode ();
};
