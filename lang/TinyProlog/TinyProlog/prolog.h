/* Copyright 1986 - MicroExpert Systems
                    Box 430 R.D. 2
                    Nassau, NY 12123       */

/* Revisions - 1.1  Nov. 1986   - Edinburgh list syntax added */
/* converted to lattice c by Dennis J. Darland [73300,270] 11/9/87 */
/* VTPROLOG implements the data base searching and pattern matching of
   PROLOG. It is described in "PROLOG from the Bottom Up" in issues
   1 and 2 of AI Expert.

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

#define debug 0
#define back_space 8
#define tab '\t'
#define eof_mark 26
#define esc 27
#define quote_char 39
#define left_arrow 75
#define end_key = 79
#define del_line 24
#define bell 7

#define true 1
#define false 0

#define MAX_ALLOC 1000

typedef int counter;
typedef unsigned char boolean; 
enum   node_type {consnode,func,variable,constant,freenode}; 
typedef struct node_struct
	{
    boolean in_use;
	enum node_type tag;
    struct chain_struct
		{
		struct node_struct    *next_in_chain;
		} chain_node_ptr;
    union  {
           struct cons_struct
		   		{
				struct node_struct  *tail_ptr;
                struct node_struct  *head_ptr;
				} cons_node;
           char string_data[80];
			} node_union;
	} node;

/* node is the basic allocation unit for lists. The fields are used as
   follows:

    in_use     - in_use = false tells the garbage collector that this node
                 is available for re-use.
    tag        - which kind of node this is.
    cons_node  - cons_nodes consist of two pointers. one to the head (first item)
                 the other to the rest of the list. They are the "glue" which
                 holds the list together. The list (A B C) would be stored as
                   -------         --------          --------
                   | .| . |----->  |  .| . |------> |  .| . |---> NIL
                   --|-----         --|------        --|-----
                     |                |                |
                     V                V                V
                     A                B                C

                 The boxes are the cons nodes, the first part of the box
                 holds the head pointer, then second contains the tail.
    constant   - holds string values, we don't actually use the entire 80
                 characters in most cases.
    variable   - also conatins a string value, these nodes will be treated as
                 PROLOG variables rather than constants.
    free_node  - the garbage collector frees all unused nodes. */


	char	line[132],saved_line[132];
	unsigned char	token[80];
	FILE	*source_file;
	boolean	error_flag,in_comment;
 	node	*data_base,*saved_list;
	int		chain_cnt;
	node 	*chain_head;
	
/* The important globals are:
   source_file  - text file containing PROLOG statements.
   line         - line buffer for reading in the text file
   saved_list   - list of all items that absolutely must be saved if garbage
                  collection occurs. Usually has at least the data_base and
                  the currents query attached to it.
   data_base    - a pointer to the start of the data base. It points to a
                  node pointing to the first sentence in the data base. Nodes
                  pointing to sentences are linked together to form the data
                  base.
   delim_set    - set of characters which delimit tokens. 
   chain_cnt	- total number of nodes malloc'ed.
   chain_head	- head to chain of all malloc'ed nodes. */

