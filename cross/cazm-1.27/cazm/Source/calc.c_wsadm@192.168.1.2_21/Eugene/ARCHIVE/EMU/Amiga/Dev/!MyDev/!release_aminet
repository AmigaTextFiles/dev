#include "defs.h"
#include "calc.h"

static char *getvalue	(char *pos,int *pvalue);
static int push			(struct node **pstack,int type,int value);
static int convert		(char symbol);
static int ishigher		(char symbol,struct node *pstack);
static int pop			(struct node **pstack,int *pvalue);
static struct node *makeupn	(struct listheader *plabel,char *pos);
static int docalc		(struct node **pstack);
static int calcupn		(struct node *pupn,u_short *pu_short);

int        calcexpr		(struct listheader *plabel,char *expr,u_short *pu_short);

static char *getvalue(char *pos,int *pvalue)
{
	/*
	 * Convert Number in Ascii to Integer format.
	 * Find position of following token.
	 *
	 * RC: found Number is stored in *pvalue
	 *     Pointer to next non blank character
	 */
	 
	*pvalue=atoi(pos);
	while(isdigit(*pos))
		pos++;
	while(isspace(*pos))
		pos++;
	return(pos);
}

static int push(struct node **pstack,int type,int value)
{
	/* Push item on stack. Set 'pstack' to new top of stack .
	 *
	 * RC: NULL if all went fine,
	 *     ERROR if malloc() failed();
	 */
	 
	struct node *pnode;
	if(!(pnode=(struct node *)malloc(sizeof(struct node))))
	{
		printf("Can't allocate memory\n");
		return(ERROR);
	}
	pnode->prev = *pstack;
	pnode->type = type;
	pnode->value= value;
	*pstack     = pnode;

	return(NULL);
}

static int convert(char symbol)
{
	/* Convert any Mathematicl Symbol to a priority.
	 *
	 * RC: Priority, or
	 *     ERROR if 'symbol' is not a valid mathematical operand.
	 */
	 
	switch(symbol)
	{
		case '(' : return(10);
		case '*' :
		case '/' : return(8);
		case '+' :
		case '-' : return(6);
		default  : printf("Expect any Mathematical Symbol, not '%c'\n",symbol);
				   return(ERROR);
	}
}

static int ishigher(char symbol,struct node *pstack)
{
	/*
	 * Checks if has 'symbol' a greater priority as the topmost element
	 * on 'pstack'. If 'pstack' is empty so 'symbol' is always higher.
	 *
	 * RC: TRUE if 'symbol' > 'pstack->value' or if 'pstack' is empty,
	 *     FALSE else 
	 */

	int actprio,topprio;
	
	if(!pstack)
		return(TRUE);
		
	if((char)pstack->value=='(')
		return(TRUE);
		
	actprio=convert(symbol);
	topprio=convert((char)pstack->value);

	return( (actprio>topprio)? TRUE : FALSE);
}

static int pop(struct node **pstack,int *pvalue)
{
	/* Get topmost Element from stack. Set 'pstack' to new topmost element.
	 * Fill 'pvalue' with value of poped Element.
	 *
	 * RC: NULL if all went fine, else
	 *     ERROR if 'pstack' is empty.
	 */
	 
	struct node *ptmp;
	
	if(!*pstack)
		return(ERROR);

	*pvalue=(*pstack)->value;		/* get vaule */
	ptmp   =(*pstack)->prev;		/* save next new element */
	free(*pstack);				/* free topmost element */
	*pstack=ptmp;				/* set to new topmost element */

	return(NULL);
}

static struct node *makeupn(struct listheader *plabel,char *pos)
{
	/* Parse Mathematical expression pointed by 'pos'.
	 * Generate a stack in upn-order (no more brackets).
	 *
	 * RC: Pointer to upn-Stack if all went fine, else
	 *     ERROR
	 */

	struct node *argstack=NULL,*tmpstack=NULL;
	int value,brackets=0,len;
	u_short sval;
	char buffer[BUFSIZ],tmpop[2],*pend;

	while(pos && *pos)
	{
			/* Is 'pos' a label ? calculate length of assumed label */
		if(pend=strpbrk(pos,"+-*/() \t"))	/* find end of token */
			len=pend-pos;
		else
			len=strlen(pos);

		if(len)
		{
			strncpy(buffer,pos,len);
			buffer[len]='\0';

			if(!strtoint(plabel,buffer,&sval,PARSE1))	/* is the word a label ? */
			{
				if(push(&argstack,VALUE,(int)sval))
					return((struct node *)ERROR);
				if(pend)
					pos=pend;
				else
					pos+=strlen(pos);
				while(isspace(*pos))
					pos++;
				continue;
			}
			else
				return((struct node *)ERROR);
		}
		else if(*pos=='(')
		{
			if(push(&tmpstack,SYMBOL,(int)*pos++))
				return((struct node *)ERROR);
			while(isspace(*pos))	/* skip to next token */
				pos++;
			brackets++;

				/* Special case: leading minus */
			if(*pos=='-')
			{
				push(&argstack,VALUE,0);
				push(&tmpstack,SYMBOL,(int)'-');
				while(isspace(*++pos));
			}
			continue;			/* continue with next token */
		}
		else if(*pos==')')
		{
			/* move all symbols from 'tmpstack' to 'argstack, until '(' */
			while(tmpstack && tmpstack->value!=(int)'(')
			{
				if(pop(&tmpstack,&value))
					return((struct node *)ERROR);
				if(push(&argstack,SYMBOL,value))
					return((struct node *)ERROR);
			}
			if(!tmpstack)
			{
				printf("Open Bracket not found\n");
				return((struct node *)ERROR);
			}
			if(pop(&tmpstack,&value))
				return((struct node *)ERROR);
			
			brackets--;				/* decrease brackets */
			while(isspace(*++pos));	/* skip to next token */
			continue;				/* continue with next token */
		}
		else /* no digit,bracket, so it must be a '*+-/' */ 
		{
				/* Special case: leading minus */
			if( (!argstack) && (*pos=='-'))
			{
				if(push(&argstack,VALUE,0))
					return((struct node *)ERROR);
					
				if(push(&tmpstack,SYMBOL,(int)'-'))
					return((struct node *)ERROR);
				while(isspace(*++pos));
				continue;
			}			

				/* check if it is a operator */
			tmpop[0]= *pos;	/* generate a string with only first char of buffer*/
			tmpop[1]='\0';
			if(!strpbrk(tmpop,"+-*/"))
				return((struct node *)ERROR);

				/* It must be an operator */
			if(ishigher(*pos,tmpstack))
			{
				if(push(&tmpstack,SYMBOL,(int)*pos))
					return((struct node *)ERROR);
				if(*pos++=='(')		/* increase brackets */
					brackets++;
				while(isspace(*pos))	/* skip to next token */
					pos++;
				continue;			/* continue with next token */
			}
			else
			{
				while(!ishigher(*pos,tmpstack))
				{
					if((char)tmpstack->value=='(') /* special case */
						break;

						/* move Element from 'tmpstack' to 'argstack' */
					if(pop(&tmpstack,&value))		
						return((struct node *)ERROR);
					if(push(&argstack,SYMBOL,value))
						return((struct node *)ERROR);
				}
				if(push(&tmpstack,SYMBOL,(int)*pos)) /* push new Element */
					return((struct node *)ERROR);
				while(isspace(*++pos)) /* skip to next token */
				continue;
			}
		}
	}
	if(brackets)
	{
		printf("Brackets don't match\n");
		return((struct node *)ERROR);
	}
	while(tmpstack)
	{
		if( pop(&tmpstack,&value) || push(&argstack,SYMBOL,value) )
			return((struct node *)ERROR);
	}
	return(argstack);
}

static int docalc(struct node **pstack)
{
	/* Calculate the topmost two numbers on stack.
	 * Push the result on stack
	 * If there are still two numbers on stack, recall the procedure.
	 *
	 * RC: NULL if all went fine, else
	 *     ERROR
	 */

	int val1,val2,result=0,symbol,next=TRUE;

	if( pop(pstack,&val1) || pop(pstack,&val2) || pop(pstack,&symbol) )
		return(ERROR);

    if(!next)
	  return(NULL);
	  
	while(next)
	{
		switch((char)symbol)
		{
			case '*': result=val1*val2; break;
			case '/': result=val1/val2; break;
			case '+': result=val1+val2; break;
			case '-': result=val1-val2; break;
			default : printf("Unknown symbol in upn-Stack\n");
					return(ERROR);
		}
		if(*pstack && (*pstack)->type==VALUE)
		{
			val1=result;
			if(pop(pstack,&val2) || pop(pstack,&symbol) )
				return(ERROR);
			continue;
		}
		else
			break;
	}
	if( push(pstack,VALUE,result))
		return(ERROR);

	return(NULL);
}

static int calcupn(struct node *pupn,u_short *pu_short)
{
	struct node *tmpstack=NULL;
	int cnt=0,tmp;
	
	while(pupn)
	{
		if(pupn->type==SYMBOL)
		{
			cnt=0;
			if( pop(&pupn,&tmp) || push(&tmpstack,SYMBOL,tmp) )
				return(ERROR);
		}
		else
		{
			cnt++;
			if( pop(&pupn,&tmp) || push(&tmpstack,VALUE,tmp) )
				return(ERROR);
		}
		if(cnt==2)
		{
			if(docalc(&tmpstack))
				return(ERROR);
			cnt=1;
		}
	}
	if(pop(&tmpstack,&tmp))
		return(ERROR);

	*pu_short=(u_short)tmp;

	if(tmpstack || pupn)
	{
		printf("Can't solve Expression\n");
		return(ERROR);
	}
	
	return(NULL);
}

int calcexpr(struct listheader *plabel,char *expr,u_short *pu_short)
{
	/*
	 * Calculate 'expression'.
	 *
	 * RC: NULL if all went fine, else
	 *     ERROR
	 */

	struct node *upnstack;
	
	if((struct node *)ERROR==(upnstack=makeupn(plabel,expr)))
		return(ERROR);

	if(calcupn(upnstack,pu_short))
		return(ERROR);

	return(NULL);
}
