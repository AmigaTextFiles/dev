#ifndef __XARRAY_CC__
#define __XARRAY_CC__

template <class T>
class XArrayItem
{
public:
	XArrayItem() { }
	~XArrayItem()
	{
		if (this->freeContent)
			delete this->object;
	}

	T *object;
	bool freeContent;
};

template <class T>
class XArray
{
public:
	int AddData(T *newObj)
	{
		fprintf(stderr, "adddata called.\n");
		for (int i = 0; i < this->GetSize(); i++)
			if (!this->IndexUsed(i))
			{
				fprintf(stderr, "object added at %d.\n", i);
				this->shadowCopy[i] = true;
				this->realCopy[i].object = newObj;
				return i;
			}

		fprintf(stderr, "resizing to %d for new object.\n", this->GetSize() + 1);
		this->ResizeArray(this->GetSize() + 1);
		return this->AddData(newObj);
	}
	void DeleteData(int index, bool freeContent)
	{
		if (!this->IndexUsed(index))
			return;

		this->realCopy[index].freeContent = freeContent;
		delete this->realCopy[index];
		this->shadowCopy[index] = false;
	}
	T *GetData(int index)
	{
		if (!this->IndexUsed(index))
			return (T *)0;

		return this->realCopy[index].object;
	}
	int GetSize()
	{
		return this->size;
	}
	int GetNumberOfElements()
	{
		int elements = 0;
		for (int i = 0; i < this->GetSize(); i++)
			if (this->IndexUsed(i))
				elements++;
		return elements;
	}
	bool IndexUsed(int index)
	{
		if (!(index < this->GetSize())) 
			return false;

		return this->shadowCopy[index];
	}

	XArray <T>()
	{
		realCopy = (XArrayItem <T> *)0;
		shadowCopy = (bool *)0;
		size = 0;
	}

protected:
	void ResizeArray(int newSize)
	{
		if (newSize == this->GetSize())
			return;
			
		XArrayItem <T> *oldReal = this->realCopy;
		bool *oldShadow = this->shadowCopy;
		
		this->realCopy = new XArrayItem <T> [newSize];
		this->shadowCopy = new bool[newSize];

		for (int i = 0; i < this->GetSize(); i++)
		{
			if (this->GetSize() != 0)
				oldReal[i].freeContent = false;
			this->realCopy[i].freeContent = false;
			if (this->GetSize() != 0)
			{
				this->shadowCopy[i] = oldShadow[i];
				this->realCopy[i].object = oldReal[i].object;
			}
			else
			{
				this->shadowCopy[i] = false;
				this->realCopy[i].object = (T *)0;
			}
		}

		for (int i = this->GetSize(); i < newSize; i++)
		{
			this->shadowCopy[i] = false;
			this->realCopy[i].object = (T *)0;
		}

		delete [] oldReal; delete [] oldShadow;
		this->size = newSize;
	}
	
	int size;
	bool *shadowCopy;
	XArrayItem <T> *realCopy;
};

#endif

