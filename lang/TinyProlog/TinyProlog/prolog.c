#include <stdio.h>
#include "prolog.h"
node *copylist();
boolean unify();					
main()
	{
	initialize() ;
	compile(stdin) ;
	}

/* Copyright 1986 - MicroExpert Systems
                    Box 430 R.D. 2
                    Nassau, NY 12123       */

/* Revisions - 1.1  Nov. 1986   - Edinburgh list syntax added */
/* 11-9-87 converted to lattice c by Dennis J. Darland  [73300,270] */
/* VTPROLOG implements the data base searching and pattern matching of
   PROLOG. It is described in "PROLOG from the Bottom Up" in issues
   1 and 2 of AI Expert.

	Tested on AMIGA lattice c.
	Requires -cu option for unsigned char's.
		
   We would be pleased to hear your comments, good or bad, or any applications
   and modifications of the program. Contact us at:

     AI Expert
     CL Publications Inc.
     650 Fifth St.
     Suite 311
     San Francisco, CA 94107

   or on the AI Expert BBS. Our id is BillandBev Thompson ,[76703,4324].
   You can also contact us on BIX, our id is bbt.

   Bill and Bev Thompson    */

/* ----------------------------------------------------------------------
        Utility Routines
   ---------------------------------------------------------------------- */
int  indelim(ch)
register unsigned char ch;
	{
	return (ch == ' '
		|| ch == ')'
		|| ch == '('
		|| ch == ','
		|| ch == '['
		|| ch == ']'
		|| ch == tab
		|| ch == quote_char
		|| ch == ':'
		|| ch == '@'
		|| ch == '.'
		|| ch == 0xff
		|| ch == '?'
		|| ch == '|');
	}		

int isconsole(f)
register FILE *f;
/* return true if f is open on the system console
   for details of fibs and fibptrs see the Turbo Pascal ver 3.0 reference
   manual chapter 20. This should work under CP/M-86 or 80, but we haven't
   tried it. */
	{
	return(f == stdin);
	} /* isconsole */

stripleadingblanks(s)
register char *s;
	{
	if (strlen(s) > 0)
		{		
		if ((s[0] == ' ') || (s[0] == tab))
			{
			delete(s,0,1) ;
			stripleadingblanks(s) ;
			}
		}				
	} /* stripleadingblanks */
			
striptrailingblanks(s)
register char *s;
	{
	if (strlen(s) > 0)
		{					
		if ((s[strlen(s)-1] == ' ') || (s[strlen(s)-1] == tab))
			{
			delete(s,strlen(s)-1,1) ;
			striptrailingblanks(s) ;
			}
		}
	} /* striptrailingblanks */
						
int isnumber(s)
register char *s;
/* checks to see if s contains a legitimate numerical string.
It ignores leading and trailing blanks */
	{
	int num;
	register int code;
					
	striptrailingblanks(s) ;
	stripleadingblanks(s) ;
	if (strlen(s) > 0)
		code =stcd_i(s,&num);
	else 
		code = -1 ;
	return(code >0) ;
	} /* isnumber */

												
/*
double cardinal(i)
register int i;
	{
	double r;
	r = i ;
	return(r);
	}*/ /* cardinal */
						
node *head(list) 
register node *list;
/* returns a pointer to the first item in the list.
If the list is empty, it returns NULL.  */
	{
	if (list == NULL)
		return(NULL);
	else 
		return(list->node_union.cons_node.head_ptr) ;
	} /* head */
						
node *tail(list)
register node *list;
/* returns a pointer to a list starting at the second item in the list.
Note - tail( (a b c) ) points to the list (b c), but
tail( ((a b) c d) ) points to the list (c d) .  */
	{
	if (list == NULL)
		return( NULL);
	else
		{
		switch (list->tag)
			{
		case consnode : return(list->node_union.cons_node.tail_ptr) ;
						break;
		default : return(NULL);
				break;
			}
		}
	} /* tail */
					
char *stringval(list)
register node *list;
/* returns the string pointed to by list. If list points to a number
node, it returns a string representing that number */
	{

	if (list == NULL)
		{
		return(NULL);
		}
	else if ((list->tag ==constant)
	|| (list->tag ==variable)
	|| (list->tag ==func))
		{
		return(list->node_union.string_data);
		}
	else 
		{
		return(NULL);
		}
	} /* stringval */
					
enum node_type tagvalue(list)
register node *list;
/* returns the value of the tag for a node.     */
	{
		return(list->tag) ;
	} /* tagvalue */
					
printlist(list)
register node *list;
/* recursively traverses the list and prints its elements. This is
not a pretty printer, so the lists may look a bit messy.  */
	{
	register node *p;
	if (list != NULL)
		{
		switch (list->tag)
			{
		case constant:
		case func:
		case variable  :
			 printf("%s ",stringval(list));
			 break;
		case consnode : 
				printf("(") ;
				p = list ;
				while (p != NULL)
					{
					if (tagvalue(p) == consnode)
						printlist(head(p));
					else 
						printlist(p) ;
					p = tail(p) ;
					}
				printf(") ") ;
			break;
			}
		}
	} /* printlist */
						
node *allocstr(typ,s)
enum node_type typ;
register char *s;
/* Allocate storage for a string. */
	{
	register node *pt;
			
	pt = (node *)malloc(sizeof(node)) ;
	add_chain(pt);
	pt->tag = typ   ;
	strcpy(pt->node_union.string_data, s) ;
	return(pt );
	} /* allocstr */
											
node *cons(newnode,list)
register node *newnode,*list;
/* Construct a list. This routine allocates storage for a new cons node.
newnode points to the new head of the list. The tail pointer of the
new node points to list. This routine adds the new cons node to the
beginning of the list and returns a pointer to it. The list described
in the comments at the beginning of the program could be constructed
as cons(allocstr('A'),cons(allocstr('B'),cons(allocstr('C'),NULL))). */
	{
	register node *p;
	p = (node *) malloc(sizeof(node)) ;
	add_chain(p);
	p->tag = consnode ;
	p->node_union.cons_node.head_ptr = newnode ;
	p->node_union.cons_node.tail_ptr = list ;
	return( p) ;
	} /* cons */
											
node *appendlist(list1,list2)
register node *list1,*list2;
/* Append list2 to list1. This routine returns a pointer to the
combined list. Appending is done by consing each item on the first
list to the second list. This routine is one of the major sources of
garbage so if garbage collection becomes a problem, you may want to
rewrite it. */
	{
	if (list1 == NULL)
		return(list2);
	else 
		return(cons(head(list1),appendlist(tail(list1),list2))) ;
	} /* appendlist */
											
counter listlength(list)
register node *list;
/* returns the length of a list.
Note - both (A B C) and ( (A B) C D) have length 3.   */
	{
	if (list == NULL)
		return(0);
	else 
		return(1 + listlength(list->node_union.cons_node.tail_ptr)) ;
	} /* listlength */
											
collectgarbage()
	{
	printf("*") ;
   unmarkmem() ;
   mark(saved_list) ;
   freemem() ;
	}
/* end collectgarbage scope */											
testmemory() 
	{
	if (chain_cnt > MAX_ALLOC)
		collectgarbage() ;
	}	 /* testmemory */
																				
wait()
/* Just like it says. It waits for the user to press a key before
continuing. */
	{
	register char ch;
	printf("\n") ;
	printf("\n") ;
	printf("Press any key to continue.\n ") ;
	ch = getchar();
	printf("\n") ;
	} /* wait */
																				
/* ------------------------------------------------------------------------
End of utility routines
------------------------------------------------------------------------ */

readfromfile(f)
register FILE *f;
/* Read a line from file f and store it in the global variable line.
It ignores blank lines and when the end of file is reached an
eofmark is returned. */
	{
	register unsigned char *cp;
	register int  test;
	for (cp=line; cp<&line[131]; cp++)
		{
		test = fgetc(f);
		if (test == EOF)
			{
			*cp++ = 0xff;
			*cp = 0;
			break;
			}
		else
			*cp = test;
		if (*cp == '\n')
			{
			*cp = '\0';
			break;
			}
		}
	} /* readfromfile */
/* end readfromfile scope */
gettoken(tline,token)
register char *tline;
register char *token;
/* Extract a token from tline. Comments are ignored. A token is
a string surrounded by delimiters or an end of line. Tokens may
contain embedded spaces if they are surrounded by quote marks */
	{
	stripleadingblanks(tline) ;
	if (strlen(tline) > 0)
		{
		if (strncmp(tline,"/*",2)== 0)
			{
			comment(tline);
			}
		else if ((strncmp(tline,":-",2) == 0) || (strncmp(tline,"?-",2) == 0))
			{
			strncpy(token,tline,2) ;
			token[2] = 0;
			delete(tline,0,2) ;
			}
		else if (tline[0] == quote_char)
			getquote(tline);
		else if (indelim(tline[0]))
			{
			token[0] = tline[0] ;
			token[1] = 0;
			delete(tline,0,1) ;
			}
		else getword(tline) ;
		}
	else token[0] = '\0' ;
	} /* gettoken */
							
getword(tline)
register char *tline;
	{
	register boolean done;
	register int cn;
	register int len;
				
	cn = 0 ;
	len = strlen(tline) ;
	done = false ;
	while (! done)
		{
		if (cn > len)
			done = true;
		else if (indelim(tline[cn]))
			done = true;
		else 
			cn++;
		}
	strncpy(token,tline,cn) ;
	token[cn] = 0;
	delete(tline,0,cn) ;
	} /* getword */
int pos(p1,p2)
register char *p1,*p2;
	{
	register int len;
	char *p3;
	len = stcpm(p2,p1,&p3);
	if (len >0)
		return((int)p3-(int)p2);
	else
		return(-1);
	}
delete(p1,pos,n)
register char *p1;
register int pos,n;
	{
	int i;
	for (i=pos;;i++)
		{
		p1[i]=p1[i+n];
		if (p1[i] == 0)
			break;
		}
	}
comment(tline)
register char *tline;
	{
	if (pos("*/",tline) >=0)
		{
		delete(tline,0,pos("*/",tline)+1) ;
		gettoken(line,token) ;
		}
	else
		{
		tline[0] = '\0' ;
		token[0] = '\0' ;
		in_comment = true ;
		}
	} /* comment */
getquote(tline)
register char *tline;
	{
	register int i;
	
	delete(tline,0,1) ;
	if (pos(quote_char,tline) >= 0)
		{
		token[0] = quote_char;
		for (i=1;i<=pos("'",tline);i++)
			token[i]=tline[i];
		token[i]=0;	
		delete(tline,0,pos(quote_char,tline)) ;
		}
	else
		{
		strcpy(token,tline) ;
		tline[0] = '\0' ;
		}
	} /* getquote */
																																
/* end scope gettoken */																																																	
scan(f,token)
register FILE *f;
register char *token;
/* Scan repeatedly calls gettoken to retreive tokens. When the
end of a line has been reached, readfromfile is called to
get a new line. */
	{
	if (strlen(line) > 0)
																																																																																																																																	
		{
		gettoken(line,token) ;
		}
	else
		{
		readfromfile(f) ;
		scan(f,token) ;
		}
	} /* scan */
																																																																				
compile(source)
register FILE *source; 
/* The recursive descent compiler. It reads tokens until the token
'EXIT' is found. If the token is '?-', a query is performed, a '@' token
is the command to read a new file and source statements are read form that
file, otherwise the token is assumed to be part of a sentence and the rest
of the sentence is parsed. */
	{
	scan(source,token) ;
	while (token[0] != 0xff)
		{
		error_flag = false ;
		if (strncmp(token,"?-",2)== 0)
			{
			scan(source,token) ;
			query(source) ;
			}
		else if (strcmp(token,"@")== 0)
			{
			scan(source,token) ;
			readnewfile(source) ;
			}
		else if (strncmp(token,"EXIT",4)==0)
			doexit(source);
		else if (token[0] == 0xff)
			break;
		else 
			rule(source) ;
		scan(source,token) ;
		}
	} /* compile */
						
error(errormsg,source)
register char *errormsg;
register FILE *source;
/* Signal an error. Prints saved_line to show where the error is located.
saved_line contains the current line being parsed. it is required,
because gettoken chews up line as it reads tokens. */
	{
	error_flag = true ;
	printf("\n") ;
	printf(errormsg) ;
	printf("\n") ;
/*	printf(saved_line) ; */
/*	writeln(" : strlen(saved_line) - strlen(line) - 1,^") ; ;*/
	if (isconsole(source))
		{
		token[0] = '.' ;
		token[1] = 0;
		line[0] = '\0' ;
		}
	else runout(source) ;
	wait() ;
	} /* error */
runout(source)
register FILE *source;
	{
	while ((strcmp(token,".") != 0) && (token[0] != 0xff))
		scan(source,token) ;
	} /* runout */
/* end scope error*/
goal(lptr,source)
register node **lptr;
register FILE *source;
/* Read a goal. The new goal is appended to lptr. Each goal is appended
to lptr as a list. Thus, the sentence 'likes(john,X) :- likes(X,wine) .'
becomes the list ( (likes john X) (likes X wine) ) */
	{
	char goaltoken[80];
	if ((token[0] >='a' && token[0] <= 'z') || token[0] == quote_char)
		{
		if (token[0] == quote_char)
			{
			*lptr = appendlist(*lptr,cons(cons(allocstr(constant,
			&token[1]),NULL),NULL)) ;
			scan(source,token) ;
			}
		else
			{
			strcpy(goaltoken,token) ;
			scan(source,token) ;
			if (token[0] == '(')
				functor(lptr,goaltoken,source);
			else 
				*lptr = appendlist(*lptr,
				cons(cons(allocstr(constant,goaltoken),NULL),NULL)) ;
			}
		}
	else 
		error("A goal must begin with 'a .. z' or be a quoted string.",source) ;
	} /* goal */
functor(fptr, functoken,source)
register node **fptr;
register char    *functoken;
register FILE *source;
/* The current goal is a functor. This routine allocates a node
to store the functor and  processes the components of the
functor. On exit, fptr points to the list containing the functor
and its components. functoken contains the functor name. */
	{
	node *cptr;
	cptr = cons(allocstr(func,functoken),NULL) ;
	scan(source,token) ;
	components(&cptr,source) ;
	if (token[0] == ')')
		{
		*fptr = appendlist(*fptr,cons(cptr,NULL)) ;
		scan(source,token) ;
		}
	else error("Missing ')'.",source) ;
	} /* functor */
components(cmptr,source)
register node * *cmptr;
register FILE *source;
/* Process the components of the functor. The components are terms
seperated by commas. On exit, cmptr points to the list of
components. */
	{
	term(cmptr,source) ;
	if (token[0] == ',')
		{
		scan(source,token) ;
		components(cmptr,source) ;
		}
	} /* components */
						
term(tptr,source)
register node * *tptr ;
register FILE *source;
/* Process a single term. The new term is appended to tptr. */
	{
	char   ttoken[80];
	if (token[0] >= 'A' && token[0] <= 'Z')
	varbl(tptr,source);
	else if (token[0] == quote_char)
	quotedstr(tptr,source);
	else if (isnumber(token))
	number(tptr,source);
	else if (token[0] == '[')
		list(tptr,source);
	else if (token[0] >= 'a' && token[0] <= 'z')
		{
		strcpy(ttoken, token) ;
		scan(source,token) ;
		if (token[0] == '(')
		functor(tptr,ttoken,source);
		else 
		*tptr = appendlist(*tptr,cons(allocstr(constant,ttoken),NULL)) ;
		}
	else 
	error("Illegal Symbol.",source) ;
	} /* term */
quotedstr(qptr,source)
register node * *qptr;
register FILE *source;
/* Process a quote */
	{
	*qptr = appendlist(*qptr,cons(allocstr(constant,&token[1]),NULL)) ;
	scan(source,token) ;
	} /* quotedstr */
varbl(vptr,source)
register node * *vptr ;
register FILE *source;
/* The current token is a varaible, allocate a node and return
a pointer to it. */
	{
	*vptr = appendlist(*vptr,cons(allocstr(variable,token),NULL)) ;
	scan(source,token) ;
	} /* varbl */
number(nptr,source)
register node * *nptr;
register FILE *source;
/* Numbers are treated as string constants. This isn't particularly
efficent, but it is easy. */
	{
	*nptr = appendlist(*nptr,cons(allocstr(constant,token),NULL)) ;
	scan(source,token) ;
	} /* number */
list(lptr,source)
register node * *lptr ;
register FILE *source;
/* A list may either be empty, [], or it may be an group of
elements surrounded by brackets. On return, lptr has the
list structure appended to it. */
	{
	node *elemlist;
		
	scan(source,token) ;
	if (token[0] == ']')
		{
		*lptr = appendlist(*lptr,cons(NULL,NULL)) ;
		scan(source,token) ;
		}
	else
		{
		elemlist = NULL ;
		elementlist(&elemlist,source) ;
		if (token[0] == ']')
			{
			scan(source,token) ;
			*lptr = appendlist(*lptr,cons(elemlist,NULL)) ;
			}
		else error("Missing ']'.",source) ;
		}
	} /* list */
elementlist(elist,source)
register node * *elist ;
register FILE *source;
/* The element list is a group of terms separated by commas */
	{
	node *elist2;
		
	term(elist,source) ;
	if (token[0] == ',')
		{
		scan(source,token) ;
		elementlist(elist,source) ;
		}
	else if (token[0] == '|')
		{
		elist2 = NULL ;
		scan(source,token) ;
		term(&elist2,source) ;
		*elist = appendlist(*elist,head(elist2)) ;
		}
	} /* elementlist */
/* end scope list */
/* end scope term */
/* end scope components */
/* end scope functor */	
/* end scope goal */	
taillist(tptr,source)
register node * *tptr ;
register FILE *source;
/* Process the tail of a rule. Since the a query is syntactically identical
to the tail of a rule, this routine is used to compile queries.
On exit, tptr points to the list containing the tail. */
	{
	goal(tptr,source) ;
	if (token[0] == ',')
		{
		scan(source,token) ;
		taillist(tptr,source) ;
		}
	} /* taillist */
rule(source)
register FILE *source;
/* Procees a rule, actually any sentence. If no error occurs the
new sentence is appended to the data base. */
	{
	node * rptr;
		
	saved_list = cons(data_base,NULL) ;
	testmemory() ; 
	rptr = NULL ;
	headlist(&rptr,source) ;
	if (strcmp(token,":-")==0)
		{
		scan(source,token) ;
		taillist(&rptr,source) ;
		}
	if (token[0] != '.')
		error("'.' expected.",source) ;
	if (! error_flag)
	data_base = appendlist(data_base,cons(rptr,NULL)) ;
	} /* rule */
headlist(hptr,source)
register node * *hptr ;
register FILE *source;
	{
	goal(hptr,source) ;
	} /* head */
/* end scope rule */
query(source)
register FILE *source;
/* Process a query. Compile the query, and  call solve to search the
data base. qptr points to the compiled query and solved is a boolean
indicating whether the query was successfully solved. */
	{
	node *qptr;
	boolean solved;
		
	qptr = NULL ;
	taillist(&qptr,source) ;
	if (token[0] != '.')
	error("''.'' expected.",source);
	else if (! error_flag)
		{
		solved = false ;
		saved_list = cons(data_base,NULL) ;
		solve(qptr,NULL,0,&solved) ;
		if (! solved)
			printf("No\n") ;
		}
	} /* query */
solve(list,env,level,solved)
register node *list;
node *env;
register counter level;
register boolean *solved;
/* This is where all the hard work is done. This routine follows the
steps outlined in the article. list is the query to be soved, env is
the current environment and level is the recursion level. level can
only get to 32767, but you'll run out of stack space long before you
get that far.
solve saves list and env on the saved list so that they won't be
destroyed by garbage collection. The data base is always on the
saved list. At the end of solve, list and env are removed from
saved_list. */
	{
	node *newenv;
	register node *p;
	saved_list = cons(list,cons(env,saved_list)) ;
	if (list == NULL )
		{
		checkcontinue(solved,&env,level);
		} 
	else
		{
		p = data_base;
		while (p && !(*solved))
			{
			testmemory() ; 
			if (unify(copylist(head(head(p)),level),head(list),env,&newenv))
				{
				solve(appendlist(copylist(tail(head(p)),level),tail(list)),
				newenv,level + 1,solved) ;
				}
			p = tail(p);
			}
		}
	saved_list = tail(tail(saved_list)) ;
	} /* solve */
node *lookup(varstr, environ)
register char *varstr;
register node * environ;
/* Search the environment list pointed to by environ for the variable,
varstr. If found return a pointer to varstr's binding, otherwise
return NULL */
	{
	register boolean found;
	register node * p;
		
	p = environ ;
	found = false ;
	while ((p != NULL) && (! found))
		{
		if (strcmp(varstr,stringval(head(head(p))))==0)
			{
			found = true ;
			return(tail(head(p))) ;
			}
		else p = tail(p) ;
		}
	if (! found)
	return( NULL) ;
	} /* lookup */
checkcontinue(solved,env,level)
register boolean *solved;
register node * *env;
register int level;
/* Print the bindings and see if the user is satisfied. If nothing
is printed from the environment,  print 'Yes' to indicate
that the query was successfully satisfied. */
	{
	boolean printed, listprinting;
	register char ch;
	printed = false ;
	listprinting = false ;
	printbindings(*env,&listprinting,&printed,env) ;
	if (! printed && level == 0)
		{
		printf("\n") ;
		printf("Yes\n ") ;
		printf("Press 'm' for more or 'q' to quit.\n");
		do
			ch = getchar() ;
		while (ch!= 'm' && ch != 'q');
		*solved = (ch == 'q') ;
		}
	else if (printed)
		{
		printf("\n") ;
		printf("Press 'm' for more or 'q' to quit.\n");
		do
			ch = getchar() ;
		while (ch!= 'm' && ch != 'q');
		*solved = (ch == 'q') ;
		}
	} /* checkcontinue */
printbindings(list,listprinting,printed,env)
register node * list ;
register boolean *listprinting;
register boolean *printed;
register node * *env;
/* Print the bindings for level 0 variables only, intermediate variables
aren't of interest. The routine recursivley searches for the
end of the environments list and  prints the binding. This
is so that variables bound first are printed first. */
	{
	if (list != NULL)
		{
		printbindings(tail(list),listprinting,printed,env) ;
		if (pos("#",stringval(head(head(list)))) == -1) 
			{
			*printed = true;
			printf("\n");
			printf("%s == ",stringval(head(head(list)))) ;
			switch (tagvalue(tail(head(list))))
				{
			case constant  : 
				printf("%s ",stringval(tail(head(list)))) ;
				break;
			case variable  : 
				printvariable(stringval(tail(head(list))),listprinting,env) ;
				break;
			case consnode : 
				printalist(tail(head(list)),listprinting,env) ;
				break;
				}
			}
		}
	} /* printbindings */
						
printvariable(varstr,listprinting,env)
register char *varstr;
register boolean *listprinting;
register node * *env;
/* The varaible in question was bound to another varaible, so look
up that variable's binding and print it. If a match can't be found
print '' to tell the user that the variable is anonymous. */
	{
	node *varptr;
	
	varptr = lookup(varstr,*env) ;
	if (varptr != NULL)
		{
		switch (tagvalue(varptr))
			{
		case constant  : printf("%s ",stringval(varptr)) ;
						break;
		case variable  : printvariable(stringval(varptr),env) ;
						break;
		case consnode : 
			if (*listprinting)
				printcomponents(varptr,listprinting,env);
			else 
				printalist(varptr,listprinting,env) ;
			break;
			}
		}
	else 
		printf(" ") ;
	} /* printvariable */
printfunc(p ,listprinting,env)
register node * p ;
register boolean *listprinting;
	{
	printf("%s",stringval(head(p))) ;
	printf("(") ;
	printcomponents(tail(p),listprinting,env) ;
	printf(")") ;
	} /* printfunc */
printcomponents(p,listprinting,env)
register node * p;
register boolean *listprinting;
register node * *env;
/* Print the components of a functor. These may be variables or
other functors, so call the approriate routines to print them. */
	{
	if (p != NULL)
		{
		switch (tagvalue(p))
			{
		case constant  : printf("%s ",stringval(p)) ;
				break;
		case variable  : printvariable(stringval(p),env) ;
				break;
		case consnode : 
				if (tagvalue(head(p)) == func)
					printfunc(p,listprinting,env);
				else
					{
					if (tagvalue(head(p)) == consnode)
						printalist(head(p),listprinting,env);
					else 
						printcomponents(head(p),listprinting,env) ;
					if (tail(p) != NULL)
						{
						printf(",") ;
						printcomponents(tail(p),listprinting,env) ;
						}
					}
				break;
			}
		}
	} /* printcomponents */
printalist(l,listprinting,env) 
register node * l;
register boolean *listprinting;
register node * *env;
/* The variable was bound to a functor. Print the functor and its
components. */
	{
	if (l != NULL)
		{			
		if (tagvalue(head(l)) == func)
			printfunc(l,listprinting,env);
		else
			{
			*listprinting = true ;
			printf("[") ;
			printcomponents(l,listprinting,env) ;
			printf("]") ;
			}
		}
	} /* printalist */
/* end scope printbindings */
/* end scope checkcontinue */
node *copylist(list , copylevel)
register node * list;
counter copylevel;
/* Copy a list and append the copylevel (recursion level) to all
variables. */
	{
	node     *templist;
	char    levelstr[8];
		
	sprintf(levelstr,"#%d",copylevel);
	templist = NULL ;
	listcopy(list,&templist,&copylevel,levelstr) ;
	return( templist) ;
	} /* copylist */
listcopy(fromlist,tolist,copylevel,levelstr)
register node * fromlist;
register node * *tolist;
register counter *copylevel;
register char *levelstr;
	{
	if (fromlist != NULL)
		{
		char temp[132];
		switch (fromlist->tag)
			{
		case variable : 
			sprintf(temp,"%s%s",fromlist->node_union.string_data,levelstr);
			*tolist = allocstr(variable,temp) ;
			break;
		case func:
		case constant  : *tolist = fromlist ;
				break;
		case consnode : 
				listcopy(tail(fromlist),tolist,copylevel,levelstr) ;
				*tolist = cons(copylist(head(fromlist),*copylevel),*tolist) ;
				break;
			}
		}
	} /* listcopy */
/* end scope copylist */
boolean unify(list1,list2,environ,newenviron)
node *list1,*list2,*environ ;
register node **newenviron;
/* Unify two lists and return any new bindings at the front of the
environment list. Returns true if the lists could be unified. This
routine implements the unification table described in the article.
Unification is straight forward, but the details of matching the
lists get a little messy in this routine. There are better ways to
do all of this, we just haven't gotten around to trying them. If
you implement any other unification methods, we would be glad to
hear about it.
Unify checks to see if both lists are NULL, this is a successful
unification. Otherwise check what kind on node the head of list1
is and call the appropriate routine to perform the unification.
Variables are unified by looking up the binding of the variable.
If none is found, make a binding for the variable, otherwise try to
unify the binding with list2. */
	{
	boolean unifyvar;
	register boolean uv;
	node *varptr;
	if ((list1 == NULL) && (list2 == NULL))
		{
		unifyvar = true ;
/*		*newenviron = environ ; */
		}
	else if (list1 == NULL)
		{
		uv = unify(list2,list1,environ,newenviron);
		return(uv);
		}
	else
		{
		switch (tagvalue(list1))
			{
		case constant :
			unifyconstant(&list1,&list2,&varptr,&environ,newenviron,&unifyvar);
			break;
		case variable  : 
			unifyvariable(&list1,&list2,&varptr,&environ,newenviron,&unifyvar);
			break;
		case func      : 
			unifyfunc(&list1,&list2,&varptr,&environ,newenviron,&unifyvar);
			break;
		case consnode : 
			unifylists(&list1,&list2,&varptr,&environ,newenviron,&unifyvar);
			break;
		default : 
			fail(&environ,newenviron,&unifyvar);
			break;
			}
		}
	return(unifyvar);
	} /* unify */
makebinding(l1,l2,environ,newenviron,unifyvar)
register node * l1,*l2,**environ,**newenviron;
register boolean *unifyvar;
/* Bind a variable to the environment. Anonymous variables are not bound.
l1 points to the variable and l2 points to its binding. */
	{
	if (strcmp(stringval(l1),"") != 0)
		{
		*newenviron = cons(cons(l1,l2),*environ);
		}
	else 
		{
		*newenviron = *environ ;
		}
	*unifyvar = true ;
	} /* makebinding */
fail(environ,newenviron,unifyvar)
register node * *environ,**newenviron;
boolean *unifyvar;
/* Unification failed. */
	{
	*unifyvar = false ;
	*newenviron = *environ ;
	} /* fail */
unifyconstant(list1,list2,varptr,environ,newenviron,unifyvar)
register node **list1,**list2,**varptr,**environ,**newenviron;
boolean *unifyvar;
/* List1 contains a constant. Try to unify it with list2. The 4 cases
are:
list2 contains
constant - unify if constants match
variable - look up binding, if no current binding bind the
constant to the variable, otherwise unify list1
with the binding.
consnode,
func     - these can't be unified with a constant. A consnode
indicates an expression. */
	{
	if ((*list2) == NULL)
	nilconstant(list1);
	else
		{
		switch (tagvalue(*list2))
			{
		case constant  : 
			if (strcmp(stringval(*list1),stringval(*list2)) == 0)
				{
				*unifyvar = true ;
				*newenviron = *environ ;
				}
			else fail(environ,newenviron,unifyvar) ;
				break;
			case variable  : 
				*varptr = lookup(stringval(*list2),*environ) ;
				if ((*varptr) == NULL)
					makebinding((*list2),(*list1),environ,newenviron,unifyvar);
				else 
					*unifyvar = unify((*list1),(*varptr),*environ,newenviron) ;
				break;
		case consnode:
		case func:      fail(environ,newenviron,unifyvar) ;
						break;
		default :fail(environ,newenviron,unifyvar) ;
				break;
			}
		}
	} /* unifyconstant */

nilconstant(list1,environ,newenviron,unifyvar)
register node **list1,**environ,**newenviron;
boolean *unifyvar;
	{
	if (strcmp(stringval(*list1),"[]") ==0)
		{
		*unifyvar = true ;
		*newenviron = *environ ;
		}
	else 
		fail(environ,newenviron,unifyvar) ;
	} /* nilconstant */
/* end scope unifyconstant */
unifyvariable(list1,list2,varptr,environ,newenviron,unifyvar)
register node * *list1,**list2,**varptr,**environ,**newenviron;
boolean *unifyvar;
/* The first list contained a variable, now try to unify that variable
with list2. If list2 is NULL, unify the varaible with '[]'. This
is for printing purposes only. */
	{
	*varptr = lookup(stringval(*list1),*environ) ;
	if ((*varptr) != NULL)
	*unifyvar = unify(*varptr,*list2,*environ,newenviron);
	else if (list2 == NULL)
		makebinding((*list1),allocstr(constant,"[]"),
		environ,newenviron,unifyvar);
	else if ((tagvalue(*list2) == constant)
			|| (tagvalue(*list2) == variable)
			|| (tagvalue(*list2) == func)
			|| (tagvalue(*list2) == consnode)) 
		makebinding(*list1,*list2,environ,newenviron,unifyvar);
	else 
		fail(environ,newenviron,unifyvar) ;
	} /* unifyvariable */
unifyfunc(list1,list2,varptr,environ,newenviron,unifyvar)
register node * *list1,**list2,**varptr,**environ,**newenviron;
boolean *unifyvar;
/* List1 contains a functor. Try to unify it with list2. The 4 cases
are:
list2 contains
constant  - can't be unified.
variable  - look up binding, if no current binding bind the
functor to the variable, otherwise unify list1
with the binding.
consnode - fail
func      - if the functors match,  true to unify the component
lists (tail of the list) term by term. */
	{
	switch (tagvalue(*list2))
		{
	case constant  : fail(environ,newenviron,unifyvar) ;
		break;
	case variable  : 
			*varptr = lookup(stringval(*list2),*environ) ;
			if ((*varptr) == NULL)
				makebinding(*list2,*list1,environ,newenviron,unifyvar);
			else 
				*unifyvar = unify(*list1,*varptr,*environ,newenviron) ;
			break;
	case func      :
		if (strcmp(stringval(*list1),stringval(*list2)) ==0)
			{
			*unifyvar = true ;
			*newenviron = *environ ;
			}
		else fail(environ,newenviron,unifyvar) ;
		break;
	case consnode : fail(environ,newenviron,unifyvar) ;
		break;
	default : fail(environ,newenviron,unifyvar) ;
		break;
		}
	} /* unifyfunc */
unifylists(list1,list2,varptr,environ,newenviron,unifyvar)
register node * *list1,**list2,**varptr,**environ,**newenviron;
boolean *unifyvar;
/* List1 contains an expression. Try to unify it with list2. The 4 cases
are:
list2 contains
constant  - can't be unified.
variable  - look up binding, if no current binding bind the
functor to the variable, otherwise unify list1
with the binding.
consnode - If the heads can be unified,  unify the tails.
func      - fail */
	{
	switch (tagvalue(*list2))
		{
	case constant  : fail(environ,newenviron,unifyvar) ;
		break;
	case variable  : 
			*varptr = lookup(stringval(*list2),*environ) ;
			if ((*varptr) == NULL)
			makebinding(*list2,*list1,environ,newenviron,unifyvar);
			else 
				*unifyvar = unify(*list1,*varptr,*environ,newenviron) ;
			break;
	case func      : fail(environ,newenviron,unifyvar) ;
			break;
	case consnode : 
		if (unify(head(*list1),head(*list2),*environ,newenviron))
			*unifyvar = unify(tail(*list1),tail(*list2),*environ,newenviron);
		break;
	default: fail(environ,newenviron,unifyvar) ;
		break;
		}
	} /* unifylists */
/* end scope unify */
/* end scope solve */
/* end scope query */
readnewfile(source)
register FILE *source;
/* Read source statements from a new file. When all done, close file
and continue reading from the old file. Files may be nested, but you
will run into trouble if you nest them deaper than 15 levels. This
is Turbo's default for open files. */
	{
	register FILE *newfile;
	char  oldline[132],oldsave[132];
	char  fname[80];
		
	if (token[0] == quote_char)
	delete(token,0,1) ;
	if (pos(".",token) == -1)
		{
		strcpy(fname,token);
		strcat(fname,".pro");
		}
	else 
		strcpy(fname , token) ;
	if ((newfile = fopen(fname,"r"))!= NULL)
		{
		strncpy(oldline, line, 132) ;
	/*	strncpy(oldsave, saved_line, 132) ; */
		line[0] = '\0' ;
		compile(newfile) ;
		fclose(newfile) ;
		strncpy(line, oldline, 132) ;
	/*	strncpy(saved_line, oldsave, 132) ; */
				scan(source,token) ;
		if (token[0] != '.')
		error("'.' expected.",source) ;
}
	else 
		error("Unable to open ",source) ;
	} /* readnewfile */
doexit(source)
register FILE *source;
/* Exit the program. This really should be a built-in function and handled
in solve, but this does the trick. */
	{
	scan(source,token) ;
	if (token[0] != '.')
		error("'.' expected.",source);
	else 
		exit(0);
	} /* doexit */
/* end scope compile */
initialize()
/* Write a heading line and initialize the global variables */
	{
	printf("\n") ;
	printf(
	"Very Tiny Prolog - Version 1.1     [c] 1986 MicroExpert Systems\n") ;
	printf(
	"Modified from Pascal to C by Dennis Darland\n");
	printf ("\n");
	in_comment = false ;
	line[0] = '\0' ;
	data_base = NULL ;
	saved_list = NULL;
	} /* initialize */
mark(list)
register node *list;
   /* Mark the blocks on list as being in use. Since a node may be on several
      lists at one time, if it is already marked we don't continue processing
      the tail of the list. */
	{
    if (list != NULL)
		{
		if (!list->in_use)
			{
			list->in_use = true ;
          	if (list->tag ==consnode)
           		{
            	mark(head(list)) ;
            	mark(tail(list)) ;
				}
            }
       }
	}

unmarkmem()
   /* Go through memory from initialheap^ to HeapPtr^ and mark each node
      as not in use. The tricky part here is updating the pointer p to point
      to the next cell. */
   {
   register node  *p;
   p = chain_head;
   while (p)
	   	{
		p->in_use = false;
		p = p->chain_node_ptr.next_in_chain;
		}
	}
add_chain(p)
register node *p;
	{
	p->chain_node_ptr.next_in_chain = chain_head;
	chain_head = p;
	chain_cnt++;
	}			
freemem()
   /* Go through memory from initialheap^ to HeapPtr^ and mark each node
      as not in use. The tricky part here is updating the pointer p to point
      to the next cell. */
   {
   register node  *p;
   register node  *q;
   p = chain_head;
   q = NULL;
   while (p)
		{
		if( p->in_use == false);
			{
			if (q)
				{
				q->chain_node_ptr.next_in_chain = 
				p->chain_node_ptr.next_in_chain;
				free(p);
				chain_cnt--;
				}
			else
				{
				chain_head = 	p->chain_node_ptr.next_in_chain;
				free(p);
				chain_cnt--;
				}
			}
		q = p;
		p = p->chain_node_ptr.next_in_chain;
		}
	}
