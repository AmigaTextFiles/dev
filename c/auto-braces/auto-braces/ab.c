/*
**  ToDo:
**   ** Get rid of globals; use a program-state structure.
**
**   ** Should simplify option processing (-t, [-i], -o), maybe.  Should
**	also add a help() function to be called if bad params are given,
**	and isolate some of the init stuff in an init() function.
**
**   ** Add a -g[enerate-#line] option, to cause the program to generate
**	C-like #line operators (this will tell the C compiler the original
**	source file, and resynch the compiler's line-counter to the `real'
**	lines from our source file).
**
**	(Support code seems to work; now need to add it to the option-
**	 parser...
**
**	 The command-line option parser is a HACK right now.  Rather
**	 stupid...will handle `-g[...]' and `-n[...]' options, but those
**	 options will _eat_ the next command line arg (oops).  Make this
**	 the _last_ option on the command-line!  Or else follow it up with
**	 a dummy-parameter.)
**
*/

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

#include <rkr/lists.h>


/*
**  Custom linked list node type (indent_node).
**
**  Contains a linkage element (node_t link) and an indentation tracker
**  (size_t indent).
**
**  This is used in maintaining a `database' of all the different explicit
**  indent-levels used by the source file.
**
*/
typedef struct indent_node
{
    node_t  link;
    size_t  indent;
} indent_node;


/*
**  Some globals...yay!  *grin*
**
*/
char *prog_name;	/*** just so we know who we are 	***/

char *input_name;	/*** input file name			***/
char *output_name;	/*** output  "    "                     ***/
char *tab_size_str;

size_t tab_size;
FILE *input;
FILE *output;
short generate_line_directive;


/*
**  Defaults for globals.  These can be overridden by -D<name>=<value> on
**  the compile command-line, of course.
**
*/
#ifndef DEFAULT_TAB_SIZE
#define DEFAULT_TAB_SIZE 8
#endif
#ifndef DEFAULT_INPUT
#define DEFAULT_INPUT	 NULL
#endif
#ifndef DEFAULT_OUTPUT
#define DEFAULT_OUTPUT	 stdout
#endif
#ifndef DEFAULT_GENERATE_LINE_DIRECTIVE
#define DEFAULT_GENERATE_LINE_DIRECTIVE 0
#endif


/*
**  List of states for parmeter parser.  Hey, I know it's overkill, but I
**  thought it'd be neat to allow arbitrary abbreviations of param names &
**  make the space between param name & param data optional...*grin*
**
*/
typedef enum handle_arg_state
{
    ha_state_base = 0,		    /*** default/initial state ***/
    ha_state_looking_for_input,     /*** got a -i[nput-file] param ***/
    ha_state_looking_for_output,    /*** got a -o[utput-file] param ***/
    ha_state_looking_for_tab_size,  /*** got a -t[ab-size] param ***/
    ha_state_generate_line_directive,	/*** got a -g[enerate-...] ***/
    ha_state_no_generate_line_directive,/*** got a -n[o-generate-...] ***/
    ha_state_invalid,		    /*** Uh-oh! ***/
} handle_arg_state;

typedef struct handle_arg_options
{
    char		*option;    /*** option string to match ***/
    handle_arg_state	state;	    /*** state to be in if no data for opt ***/
    char		**data;     /*** where to put arg string, if found ***/
} handle_arg_options;


/*
**  For the given text {arg}, try to match it to a member within {opts}; if
**  we have enough to identify which option was asked for, but need more
**  data to complete it, then set the caller's {state} appropriately.
**
**  ASSUMES that the first char of an option is enough to uniquely identify
**  the option.  That may not hold, in the future.
**
*/
void match_arg (char *arg, handle_arg_options *opts, size_t opt_count, handle_arg_state *state)
{
    int opt_candidate;

    for (opt_candidate = 0; opt_candidate < opt_count; ++opt_candidate)
    {
	char *opt_name = opts [opt_candidate].option;
	if (opt_name [1] == arg [1])
	{
	    int i;

	    for (i = 2; opt_name [i] && (opt_name [i] == arg [i]); ++i)
	    {
#line 130 "auto-braces.c"
		;
	    }
#line 131 "auto-braces.c"

	    if (arg [i] == ' ')
	    {
#line 133 "auto-braces.c"
		++i;
	    }
#line 134 "auto-braces.c"

	    if ( (arg [i]) && (opts [opt_candidate].data) )
	    {
		if (opts [opt_candidate].data)
	        {
#line 138 "auto-braces.c"
		    *(opts [opt_candidate].data) = arg + i;
	        }
#line 139 "auto-braces.c"
		*state = ha_state_base;
	    }
	    else
	    {
		if (opts [opt_candidate].data)
	        {
#line 144 "auto-braces.c"
		    *(opts [opt_candidate].data) = NULL;
	        }
#line 145 "auto-braces.c"
		*state = opts [opt_candidate].state;
	    }
	    break;
	}
    }
}

/*
**  For a given arg, do something with it.  Processing will in part depend
**  on what the last arg was, if any, that we had to handle.
**
*/
void handle_arg (char *arg)
{
    static handle_arg_state state = ha_state_base;

    static handle_arg_options opts [] =
    {
	{"-input-file",                 ha_state_looking_for_input,         &input_name},
	{"-output-file",                ha_state_looking_for_output,        &output_name},
	{"-tab-size",                   ha_state_looking_for_tab_size,      &tab_size_str},
	{"-generate-line-directive",    ha_state_generate_line_directive,   NULL},
	{"-no-generate-line-directive", ha_state_no_generate_line_directive,NULL},
	{NULL,				ha_state_invalid,		    NULL},
    };

    switch (state)
    {
	case ha_state_base:
        {
#line 174 "auto-braces.c"
	    if (arg)
	    {
#line 175 "auto-braces.c"
		if ('-' != *arg)
	        {
#line 176 "auto-braces.c"
		    input_name = arg;
	        }
#line 177 "auto-braces.c"
		else
	        {
#line 178 "auto-braces.c"
		    match_arg (arg, opts, sizeof (opts) / sizeof (handle_arg_options), &state);
	        }
#line 179 "auto-braces.c"
	    }
#line 179 "auto-braces.c"
	    break;
        }
#line 180 "auto-braces.c"


	case ha_state_looking_for_input:
        {
#line 183 "auto-braces.c"
	    input_name = arg;
	    state = ha_state_base;
	    break;
        }
#line 186 "auto-braces.c"

	case ha_state_looking_for_output:
        {
#line 188 "auto-braces.c"
	    output_name = arg;
	    state = ha_state_base;
	    break;
        }
#line 191 "auto-braces.c"

	case ha_state_looking_for_tab_size:
        {
#line 193 "auto-braces.c"
	    tab_size_str = arg;
	    state = ha_state_base;
	    break;
        }
#line 196 "auto-braces.c"

	case ha_state_generate_line_directive:
        {
#line 198 "auto-braces.c"
	    generate_line_directive = 1;
	    state = ha_state_base;  /*** HACK ***/
	    break;
        }
#line 201 "auto-braces.c"

	case ha_state_no_generate_line_directive:
        {
#line 203 "auto-braces.c"
	    generate_line_directive = 0;
	    state = ha_state_base;  /*** HACK ***/
	    break;
        }
#line 206 "auto-braces.c"

	default:
        {
#line 208 "auto-braces.c"
	    fprintf (stderr, "Invalid arg, {%s}\n", arg);
	    state = ha_state_base;
	    break;
        }
#line 211 "auto-braces.c"
    }
}

/*
**  Simple little routine to find the size of any seekable ANSI {FILE *} we
**  are given.	The file-position should be unchanged, overall, by this
**  operation.
**
*/
size_t file_size (FILE *fp)
{
    size_t old_pos;
    size_t end_pos;

    old_pos = ftell (fp);
    fseek (fp, 0, SEEK_END);
    end_pos = ftell (fp);
    fseek (fp, 0, SEEK_SET);

    return (end_pos);
}

/*
**  Used for debugging type stuff.  Displays UP TO {size_t max} nodes in
**  {list_t *l}.  Believe it or not, I actually need this little function
**  to see what was wrong with some code that was modifying my linked
**  lists. *grin*
**
*/
void print_list (list_t *l, size_t max)
{
    indent_node *n;
    int i;

    for 						\
    (                                                   \
	i = 0, n = (indent_node *)find_first (l);       \
	n && (i < max);                                 \
	++i, n = (indent_node *)find_next (&(n->link) ) \
    )
    {
#line 251 "auto-braces.c"
	printf ("node #%3.3d, indent %3.3d\n", i, n->indent);
    }
#line 252 "auto-braces.c"
    printf ("\n");
}

/*
**  Add a new indent-level to a linked-list -- ONLY if the indent-level is
**  not yet recorded by a pre-existing node in the list.
**
*/
void add_indent (size_t indent, list_t *list)
{
    indent_node *node;
    indent_node *n;

    node = malloc (sizeof (indent_node) );
    if (!node)
    {
	fprintf (stderr, "Error; could not allocate indent node!\n");
	exit (10);
    }
    node->indent = indent;
    /*
    **	node->link.ln_Pri = indent;
    **	enqueue (list, &(node->link) );
    **
    */
    for 					    \
    (                                               \
	n = (indent_node *)find_last (list);        \
	n && ( (n->indent) > indent);               \
	n = (indent_node *)find_prev (&(n->link) )  \
    )
    {
#line 283 "auto-braces.c"
	;
    }
#line 284 "auto-braces.c"
    if (!n)
    {
#line 285 "auto-braces.c"
	add_first (list, &(node->link) );
    }
#line 286 "auto-braces.c"
    else if ( (n->indent) < indent)
    {
#line 287 "auto-braces.c"
	add_node (list, &(node->link), &(n->link) );
    }
#line 288 "auto-braces.c"
    else
    {
#line 289 "auto-braces.c"
	free (node);
    }
#line 290 "auto-braces.c"
}

/*
**  Like the name says: Find the indent-level, line-length, and the
**  first-non-blank-position.
**
**  Indent-level takes into account tabs being of {tab_size} bytes in
**  width.  The other considerations return pointer-difference/array-index
**  type values.
**
**  The values are returned through {size_t} pointers that are passed to
**  this function.
**
**  {non_blank} should refer either to the {end} of {buf} or the first char
**  that is neither a SPACE nor a TAB.
**
**  {indent} should only account for leading SPACEs and TABs before the
**  {end}.
**
**  {len} will skip '\n' chars that are preceeded by backslashes, and will
**  INCLUDE the final '\n' char, provided that {end} isn't reached before a
**  '\n' is found.  If {end} is reached, then the line is still processed
**  normally.
**
*/
void find_indent_and_length_and_nonblank_and_count_lines    \
(                                                           \
    char *buf,						    \
    char *end,						    \
    size_t *indent,					    \
    size_t *len,					    \
    size_t *non_blank,					    \
    size_t *raw_line_count				    \
)
{
    char *cp;
    char c;

    ++(*raw_line_count);
    for (*indent = 0, cp = buf; (cp < end) && ( ('\t' == (c = *cp) ) || (' ' == c) ); ++cp)
    {
	if ('\t' == c)
        {
#line 332 "auto-braces.c"
	    *indent = tab_size * (1 + (*indent / tab_size) );
        }
#line 333 "auto-braces.c"
	else
        {
#line 334 "auto-braces.c"
	    ++*indent;
        }
#line 335 "auto-braces.c"
    }
    *non_blank = cp - buf;
    while ( (cp < end) && ( ('\n' != (c = *cp) ) || ('\\' == (*(cp-1) ) ) ) )
    {
	(*raw_line_count) += (*cp == '\n');
	++cp;
    }
    *len = (cp < end) + cp - buf;
}

/*
**  Spit out enough TABs and/or SPACEs to produce the desired indent-level.
**
*/
void write_indent (FILE *fp, size_t deep)
{
    while (deep > tab_size)
    {
	putc ('\t', fp);
	deep -= tab_size;
    }
    while (deep--)
    {
#line 357 "auto-braces.c"
	putc (' ', fp);
    }
#line 358 "auto-braces.c"
}

/*
**  Work-horse of the program.	Give it a buffer of C source, a
**  size-of-buffer, and an output file, and this function will do the rest.
**
*/
void write_with_braces (char *buf, size_t size, FILE *dst)
{
    list_t  indent_level_list;
    char    *cursor;
    char    *end;
    size_t  current_indent;
    size_t  line_length;
    size_t  non_blank;
    size_t  in_lines;

    end = buf + size;

    /*
    **	Do our first pass of the data to build up the list of all
    **	indent-levels that the input data uses.
    **
    */
    new_list (&indent_level_list);
    for (cursor = buf, current_indent = 0, in_lines = 0; cursor < end; )
    {
	find_indent_and_length_and_nonblank_and_count_lines (cursor, end, &current_indent, &line_length, &non_blank, &in_lines);
	add_indent (current_indent, &indent_level_list);
	cursor += line_length;
    }


    /*
    **	Now for the real work, do a second pass of the data, finding each
    **	line and determining how to handle it.
    **
    */
    {
	int	    blank_lines;
	indent_node *in;
	int	    manual_braces;
        {
#line 400 "auto-braces.c"
	    {
#line 400 "auto-braces.c"
		/*
		**  int line = 0;
		**  printf ("\x1bc");
		**
		*/
	    }
#line 414 "auto-braces.c"
        }
#line 414 "auto-braces.c"
	for								\
	(                                               		\
		blank_lines = 0,					\
		current_indent = 0,					\
		cursor = buf,						\
		in = (indent_node *) find_first (&indent_level_list),   \
		in_lines = 0,						\
		manual_braces = 0;					\
	    in && (cursor < end);                       		\
	)
	{
	    find_indent_and_length_and_nonblank_and_count_lines \
	    (                                                   \
		cursor, 					\
		end,						\
		&current_indent,				\
		&line_length,					\
		&non_blank,					\
		&in_lines					\
	    );
	    {
#line 425 "auto-braces.c"
	        {
#line 425 "auto-braces.c"
		    /*
		    **	printf ("\x9b%dH\x9b7m", in_line);
		    **	fwrite (cursor, 1, line_length, stdout);
		    **
		    */
	        }
#line 430 "auto-braces.c"
	    }
#line 430 "auto-braces.c"
	    /*
	    **	If we have a blank line, add it to our count of blanks, and
	    **	go on to the next line.  This is because we don't really
	    **	know how deep a blank line is supposed to be indented; in
	    **	some text editors (e.g., DME), all blank lines are 0
	    **	length, discounting \n, because DME truncates any trailing
	    **	whitespace on any line.  So...we can't handle blank lines
	    **	off-the-cuff.
	    **
	    */
	    if ( (non_blank + 1) == line_length)
	    {
#line 441 "auto-braces.c"
		++blank_lines; /*** putc ('\n', output); ***/
	    }
#line 442 "auto-braces.c"
	    else
	    {
		/*
		**  Line is indented more deeply than the last non-blank
		**  line we had.
		**	Spit out pending blank lines
		**
		**	Add any missing open-braces, at appropriate
		**	indent-levels.
		**
		*/
		if (current_indent > in->indent)
		{
		    while (blank_lines > 0)
		    {
			--blank_lines;
			putc ('\n', output);
		    }
		    while (in && (current_indent > in->indent) )
		    {
			if (manual_braces > 0)
		        {
#line 463 "auto-braces.c"
			    --manual_braces;
		        }
#line 464 "auto-braces.c"
			else
			{
			    write_indent (output, in->indent);
			    fputs ("{\n", output);
			    if (generate_line_directive)    /*** UNTESTED ***/
			    {
#line 469 "auto-braces.c"
				fprintf (output, "#line %d \"%s\"\n", in_lines, input_name);
			    }
#line 470 "auto-braces.c"
			}
			in = (indent_node *) find_next (&(in->link) );
		    }
		    if (!in)
		    {
			fprintf (stderr, "Corrupt indent list?!?!\n");
			exit (15);
		    }
		}

		/*
		**  Count up any leading/trailing open-/close-braces
		**
		*/
		{
		    unsigned int  c;
		    unsigned char *sp = cursor + non_blank;
		    unsigned char *ep = cursor + line_length - 1;
		    unsigned char valid [256];

		    /*
		    **	{valid} should really be declared as a global or
		    **	static, so that the loop for setting to 0 wouldn't
		    **	be needed.
		    **
		    **	Using a table should help perormance overall,
		    **	though, and certainly makes the code easier to read.
		    **	*grin*
		    **
		    */
		    for (c = 0; c < 256; ++c)
		    {
#line 501 "auto-braces.c"
			valid [c] = 0;
		    }
#line 502 "auto-braces.c"
		    valid ['{'] = 1;
		    valid ['}'] = 1;
		    valid [','] = 1;
		    valid [';'] = 1;
		    valid ['\n'] = 1;
		    valid [' '] = 1;
		    valid ['\t'] = 1;
		    {
#line 509 "auto-braces.c"
		        {
#line 509 "auto-braces.c"
			    /*** printf ("\x9b0m"); ***/
		        }
#line 510 "auto-braces.c"
		    }
#line 510 "auto-braces.c"
		    while ( (sp < ep) && valid [c = *sp])
		    {
		        {
#line 512 "auto-braces.c"
			    {
#line 512 "auto-braces.c"
				/*** printf ("\x9b%d;%dH%c", line, 1 + sp - cursor, c); ***/
			    }
#line 513 "auto-braces.c"
		        }
#line 513 "auto-braces.c"
			++sp;
			if ('{' == c)
		        {
#line 515 "auto-braces.c"
			    ++manual_braces;
		        }
#line 516 "auto-braces.c"
			else if ('}' == c)
		        {
#line 517 "auto-braces.c"
			    --manual_braces;
		        }
#line 518 "auto-braces.c"
		    }

		    while ( (ep > sp) && valid [c = *ep])
		    {
		        {
#line 522 "auto-braces.c"
			    {
#line 522 "auto-braces.c"
				/*** printf ("\x9b%d;%dH%c", line, 1 + ep - cursor, c); ***/
			    }
#line 523 "auto-braces.c"
		        }
#line 523 "auto-braces.c"
			--ep;
			if ('{' == c)
		        {
#line 525 "auto-braces.c"
			    ++manual_braces;
		        }
#line 526 "auto-braces.c"
			else if ('}' == c)
		        {
#line 527 "auto-braces.c"
			    --manual_braces;
		        }
#line 528 "auto-braces.c"
		    }
		    {
#line 529 "auto-braces.c"
		        {
#line 529 "auto-braces.c"
			    /*** putc ('\n', stdout); ***/
		        }
#line 530 "auto-braces.c"
		    }
#line 530 "auto-braces.c"
		}

		/*
		**  Line is indentend less deeply than last non-blank line.
		**	Count how many levels we need to back out
		**
		**	for the first <n> levels we need to back out
		**	    supply auto-braces
		**	let the manual-braces account for the balance.
		**	<n> == needed_levels - manual_braces
		**
		**	Spit out any pending blank lines
		**
		**  This code isn't needed for the add-open-brace code,
		**  above, because we should have already output the
		**  manual-braces (if any) before discovering the need for
		**  greater indent.
		**
		*/
		if (current_indent < in->indent)
		{
		    indent_node *n = in;
		    int 	unindent_count = 0;
		    while (n && (current_indent < n->indent) )
		    {
			++unindent_count;
			n = (indent_node *) find_prev (&(n->link) );
		    }

		    while (in && (current_indent < in->indent) )
		    {
			in = (indent_node *) find_prev (&(in->link) );
			--unindent_count;
			if ( (unindent_count + manual_braces) < 0)
		        {
#line 564 "auto-braces.c"
			    ++manual_braces;
		        }
#line 565 "auto-braces.c"
			else if (in)
			{
			    write_indent (output, in->indent);
			    fputs ("}\n", output);
			    if (generate_line_directive)    /*** UNTESTED ***/
			    {
#line 570 "auto-braces.c"
				fprintf (output, "#line %d \"%s\"\n", in_lines - blank_lines, input_name);  /*** - blank_lines to adjust line-count... ***/
			    }
#line 571 "auto-braces.c"
			}
			/*
			**  if (manual_braces < 0)
			**	++manual_braces;
			**  else if (in)
			**  {
			**	write_indent (output, in->indent);
			**	fputs ("}\n", output);
			**  }
			**
			*/
		    }
		    while (blank_lines > 0)
		    {
			--blank_lines;
			putc ('\n', output);
		    }
		    if (!in)
		    {
			fprintf (stderr, "Corrupt indent list?!?!\n");
			exit (15);
		    }
		}
		while (blank_lines > 0)
		{
		    --blank_lines;
		    putc ('\n', output);
		}
		fwrite (cursor, 1, line_length, output);
	    }
	    cursor += line_length;
	}

	/*
	**  We're at end-of-file; check if we still have any indent-levels
	**  to dump.
	**
	*/
	while (in && in->indent)
	{
	    in = (indent_node *) find_prev (&(in->link) );
	    if (manual_braces < 0)
	    {
#line 613 "auto-braces.c"
		++manual_braces;
	    }
#line 614 "auto-braces.c"
	    else if (in)
	    {
		write_indent (output, in->indent);
		fputs ("}\n", output);
	    }
	}
    }
}


int main (int argc, char *argv [])
{
    tab_size		    = DEFAULT_TAB_SIZE;
    input		    = DEFAULT_INPUT;
    output		    = DEFAULT_OUTPUT;
    generate_line_directive = DEFAULT_GENERATE_LINE_DIRECTIVE;

    {
	int arg;

	prog_name = argv [0];
	for (arg = 1; arg <= argc; ++arg)
        {
#line 636 "auto-braces.c"
	    handle_arg (argv [arg]);
        }
#line 637 "auto-braces.c"
    }

    if (tab_size_str)
    {
#line 640 "auto-braces.c"
	tab_size = strtol (tab_size_str, NULL, 0);
    }
#line 641 "auto-braces.c"
    if (!tab_size)
    {
	fprintf (stderr, "Invalid tab-size!\n");
	exit (10);
    }

    if (input_name)
    {
#line 648 "auto-braces.c"
	input = fopen (input_name, "r");
    }
#line 649 "auto-braces.c"
    if (!input)
    {
	fprintf (stderr, "Could not open input");
	if (input_name)
        {
#line 653 "auto-braces.c"
	    fprintf (stderr, ", {%s}", input_name);
        }
#line 654 "auto-braces.c"
	fprintf (stderr, "\n");
	exit (10);
    }

    if (output_name)
    {
#line 659 "auto-braces.c"
	output = fopen (output_name, "w");
    }
#line 660 "auto-braces.c"
    if (!output)
    {
	fprintf (stderr, "Could not open output: {%s}\n", output_name);
	exit (10);
    }


    {
	size_t	fsize;
	char	*buf;

	fsize = file_size (input);
	if (!fsize)
	{
	    fprintf (stderr, "File-size = 0!\n");
	    exit (10);
	}
	buf = malloc (fsize);
	if (fsize != fread (buf, 1, fsize, input) )
	{
	    fprintf (stderr, "file-size != bytes read!\n");
	    exit (10);
	}
	write_with_braces (buf, fsize, output);
    }

    return (0);
}
