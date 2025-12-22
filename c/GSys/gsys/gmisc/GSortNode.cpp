
/* Author: Anders Kjeldsen (March 2000) */

#ifndef GSORTNODE_CPP
#define GSORTNODE_CPP

GSortNode::GSortNode()
{
	Head = 0;
	Lower = 0;
	Higher = 0;
	Data = 0;
	Weight = 0.0;
	Visited = FALSE;
}

GSortNode::GSortNode(float v)
{
	Head = 0;
	Lower = 0;
	Higher = 0;
	Data = 0;
	Weight = v;
	Visited = FALSE;
}

GSortNode::GSortNode(void *t, float v)
{
	Head = 0;
	Lower = 0;
	Higher = 0;
	Data = t;
	Weight = v;
	Visited = FALSE;
}

GSortNode::~GSortNode()
{
	if (Lower) Lower->Head = NULL;
	if (Higher) Higher->Head = NULL;
}

/*
GSortNode::~GSortNode(short allnodes)
{
	if (allnodes)
	{
		if (Lower) delete Lower;
		if (Higher) delete Higher;
	}

	if (Lower) Lower->Head = NULL;
	if (Higher) Higher->Head = NULL;
}
*/

void GSortNode::KillAll() // does not kill itself;
{
	if (Lower)
	{
		Lower->KillAll();
		delete Lower;
	}
	if (Higher)
	{
		Higher->KillAll();
		delete Higher;
	}
}

void GSortNode::ClearAll()
{
	if (Lower) Lower->ClearAll();
	if (Higher) Higher->ClearAll();
	Lower = NULL;
	Higher = NULL;
	Data = NULL;
	Weight = 0;
	Visited = FALSE;
}

void GSortNode::UnVisitAll()
{
	if (Lower) Lower->UnVisitAll();
	if (Higher) Higher->UnVisitAll();
	Visited = FALSE;
}


void GSortNode::InsertNode(class GSortNode *sn)
{
	if (sn->Weight > Weight)
	{
		if (Higher) Higher->InsertNode(sn);
		else
		{
			Higher = sn;
			sn->Head = this;
		}
	}
	else
	{
		if (Lower) Lower->InsertNode(sn);
		else
		{
			Lower = sn;
			sn->Head = this;
		}
	}
}

int GSortNode::GetAmount()
{
	int sum = 0;
	if (Higher) sum+=Higher->GetAmount();
	if (Lower) sum+=Lower->GetAmount();

	return sum+1;
}

class GSortNode *GSortNode::GetLowest()
{
	class GSortNode *Current = this;
	while (Current->Lower)
	{
		Current = Current->Lower;
	}
	return Current;
}

class GSortNode *GSortNode::GetHighest()
{
	class GSortNode *Current = this;
	while (Current->Higher)
	{
		Current = Current->Higher;
	}
	return Current;
}

class GSortNode *GSortNode::GetHigher()
{
	if (Higher && !Visited)
	{
		Visited = TRUE;
		return Higher->GetLowest();
	}
	else
	{
		class GSortNode *h = Head;
		while (h && h->Visited)
		{
			h = h->Head;
		}
		return h;
	}
}

class GSortNode *GSortNode::GetLower()
{
	if (Lower && !Visited)
	{
		Visited = TRUE;
		return Lower->GetHighest();
	}
	else
	{
		class GSortNode *h = Head;
		while ( h && h->Visited )
		{
			h = h->Head;
		}
		return h;
	}
}

#endif /* GSORTNODE_CPP */ 