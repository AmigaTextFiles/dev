/*************************************
** Temp.c
**
** File contains manager to allocate
** tempory variables for the ACTION!
** compiler
**
** Created March 6, 2010
**
** By Jim Patchell
**************************************/

#include <stdio.h>
#include <stdlib.h>
#include "symtab.h"
#include "value.h"
#include "Temp.h"
#include "codegen.h"
#include "gen.h"


char Temp[16];		//flags that indicate availiablity of a temp
					//if the flag is 0, it is free
					//to allocate a temp, put the temp
					//number in the slot
					//the number of slots allocated
					//will depend on the size of the value

char TempNumb[16];	//This array indicates which tempory
					//handles are availiable.  Just because
					//a handle is available, does not mean that
					//temporary slots will be available.

static int GetTempHandle(void)
{
	int i;
	int loop;
	int handle = 0;

	for(i=0,loop=1;(i<16) && loop;++i)
	{
		if(TempNumb[i] == 0)
		{
			handle = i+1;
			loop = 0;
			TempNumb[i] = 1;	//mark as allocated
		}
	}
	return handle;
}

static void ReleaseTemphandle(int h)
{
	TempNumb[h] = 0;
}

void FreeTemp(int size,int Tindex)
{
	int i;

	for(i=0;i<size;++i)
		Temp[Tindex+i] = 0;	//free the block
}

int AllocateTemp(int size, int handle)
{
	int i,j,flag;
	int Tindex = -1;
	int loop;

	for(i=0,loop = 1;(i<16) && loop;++i)
	{
		if(Temp[i] == 0)	//is this spot free?
		{
			if(size == 1)
			{
				Temp[i] = handle;
				loop = 0;
				Tindex = i;
			}
			else	//need more than one byte
			{
				flag = 0;
				for(j=0;j<size;++j)
				{
					if(Temp[j+i] == 0) flag++;
				}
				if(flag == size)	//found a block?
				{
					for(j=0;j<size;j++)
						Temp[i+j] = handle;
					loop = 0;
					Tindex = i;
				}
			}
		}
	}
	return Tindex;
}

int GetTemp(int size,int *Indx)
{
	int handle;
	int index;

	handle = GetTempHandle();
	if(handle > 0)
	{
		index = AllocateTemp(size,handle);
		if(index >= 0)
		{
			*Indx = index;
		}
		else
		{
			ReleaseTemphandle(handle);
			handle = -1;	//no temp is availiable
		}
	}
	else
		handle = -1;
	return handle;
}

void ReleaseTemp(value *v)
{
	FreeTemp(SizeOfRef(v->type),v->offset);
	ReleaseTemphandle(v->is_tmp);
}

value *CreateTemp(link *t,int size)
{
	value *rv;

	rv = new_value();
	rv->type = clone_type(t,&rv->etype);
	rv->ValLoc = VALUE_IN_TMP;	//leave result in accum
	rv->is_tmp = GetTemp(size,&rv->offset);
	MakeTempName(rv->name,rv->offset);
	return rv;
}

void MakeTempName(char *s,int index)
{
	sprintf(s,"__TEMP_var%d",index);
}

void GenTempName(value *v)
{
	sprintf(v->name,"__TEMP_var%d",v->offset);
}

void GenTempStuff(FILE *out)
{
	char *s;

	s = malloc(256);
	MakeTempName(s,0);
	fprintf(out,"%s:\t.DS\t16\n",s);
	free(s);
}

