
/* Author Anders Kjeldsen (March 2000) */

#ifndef GSORTNODE_H
#define GSORTNODE_H

/*

Usage:
	Make a bunch of GSortNodes which you initialize (Weight and Data)
	Link them, by inserting them into a chosen GSortNode.
	To be sure, always use UnVisitAll(rootnode) before you decide to use it again.
	The GSortNode can NOT Sort both ways at the same time.
	It doesn't even do all the work by itself; The user just tells it to
	find the next node (in desired direction);

	When using GetLowest(), you must use GetHigher().
	When using GetHighest(), you must use GetLower().
To Do:
	Add a method called UpdateAll()
	This will try to fix the node-tree based on the new Weights installed.
	If a node is moved, the subnodes are moved too.
	It will compare its weight with its head's weight. Only the ones
	that are changed will be moved.
	May be "impossible" :)

*/

class GSortNode
{
public:
	GSortNode();
	GSortNode(float v);
	GSortNode(void *t, float v);
	~GSortNode();

	void SetWeight(float w) { Weight = w; };
	void SetVisited(short v) { Visited = v; };
	void SetData(void *t) { Data = t; };
	float GetWeight() { return Weight; };
	short IsVisited() { return Visited; };
	void *GetData() { return Data; };

	void KillAll();
	void ClearAll();
	void InsertNode(class GSortNode *sn);
	void UnVisitAll();
	int GetAmount();

	class GSortNode *GetLowest();
	class GSortNode *GetHighest();
	class GSortNode *GetLower();
	class GSortNode *GetHigher();

	class GSortNode *Head;	// Ok, bad word
	class GSortNode *Lower;
	class GSortNode *Higher;
	void *Data;
	float Weight;
	short Visited;
};

#endif /* GSORTNODE_H */