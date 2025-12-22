
/* 
**	tek/examples/string.c
**
**	demonstrates dynamic array handling.
*/


#include <tek/array.h>
#include <stdio.h>



int main (void)
{
	TSTRPTR s1, s2;
	TINT pos;

	
	/* 
	**	for fun and experimentation, we let the entire string
	**	handling operate in a small, static block of memory.
	**	(note that there is no need for you to create a MMU
	**	for a string - you may as well pass TNULL for the "mmu"
	**	argument.)
	*/

	TBYTE staticbuffer[200];
	TMMU mmu;
	TMEMHEAD memhead;
	
	TInitMemHead(&memhead, staticbuffer, sizeof(staticbuffer), TNULL);
	if (TInitMMU(&mmu, &memhead, TMMUT_Static, TNULL))
	{
		/* 
		**	create an empty dynamic string, i.e. a string
		**	pointing to a zero byte.
		*/
		
		s1 = TCreateString(&mmu, 0);
		
	
		/* 
		**	create another dynamic string from an initial string
		*/
		
		s2 = TCreateStringStr(&mmu, "a teklib");
		
	
		if (s1 && s2)
		{
			/* 
			**	append some text to the first string.
			*/
			
			TStringCatStr(&s1, "this is ");
			TStringCat(&s1, s2);
			TStringCatStr(&s1, " dynamic string.");
			
			/*
			**	note that you can modify the string without
			**	checking for success on each individual manipulation.
			**
			**	when a manipulation fails, the entire string object
			**	will immediately fall into an "invalid" state and
			**	simply ignore further modifications. when in invalid
			**	state, any attempt to modify a string will return
			**	TFALSE.
			*/
	
	
			/*
			**	query the valid state before the string is passed
			**	to a function in the world outside:
			*/
		
			if (TStringValid(s1))
			{
				printf("%s\n", s1);
				
				/*
				**	result: "this is a teklib dynamic string."
				*/
			}
			else
			{
				printf("sorry, the string is not valid. it ran out of memory.\n");
			}
			
		
			pos = TStringFind(s1, s2);	/* find s2 in s1, return position */
			if (pos >= 0)
			{
				/*
				**	modify the length of the string
				*/
			
				TStringSetLen(&s1, pos);
			}
	
			
			/* 
			**	append some more text.
			*/
			
			TStringCatStr(&s1, "cool because it has an inbuilt memory manger.");
	
		
			if (TStringValid(s1))
			{
				printf("%s\n", s1);

				/*
				**	result: "this is cool because it has an inbuilt memory manager."
				*/
			}
			else
			{
				printf("sorry, the string is not valid. it ran out of memory.\n");
			}
		
		
			TDestroyString(s1);
			TDestroyString(s2);
		}
	}
	else
	{
		printf("*** failed to init MMU on top of static allocator\n");
	}

	fflush(NULL);

	return 0;
}


