#include <LEDA/graph.h>
#include <LEDA/graph_alg.h>
#include <LEDA/set.h>
#include <LEDA/stack.h>
#include <LEDA/array.h>

/* We use sets, stacks, and arrays of nodes */



// alphabeth: `a`,'b', ... , 'z','~'

// epsilon = '~'

const char EPSILON = '~';


//------------------------------------------------------------------------------
// NFA's are directed graphs with
// node labels of type "int"  (states)
// edge labels of type "char" 
//------------------------------------------------------------------------------


typedef GRAPH<int,char> NFA;

int compare(node x, node y) { return x-y; }

/*------------------------------------------------------------------------------
   DFA's are directed graphs with
   node labels of type set<node>*  (pointers to set of nodes of an NFA)
   edge labels of type "char"      
------------------------------------------------------------------------------*/

typedef set<node>* node_set_ptr;


typedef GRAPH<node_set_ptr,char> DFA;



//------------------------------------------------------------------------------
// We need a test for equality on sets of nodes 
// This implementation is very inefficient!
//------------------------------------------------------------------------------

bool EQ_NODE_SET(node_set_ptr S1, node_set_ptr S2)
{
  // input: two pointers S1 and S2 to sets of nodes
  // ouput: true,  if node sets *S1 and *S2 are equal
  //        false, otherwise

  node v;

  forall(v,*S1) 
    if (! S2->member(v)) return false;

  forall(v,*S2) 
    if (! S1->member(v)) return false;

  return true;

 }




//------------------------------------------------------------------------------
// Epsilon Closure
//------------------------------------------------------------------------------

void E_CLOSURE(NFA& A, node_set_ptr T)
{
  /* expands node set *T by dfs on the epsilon edges */

  stack<node> S;

  node u,v;
  edge e;

  forall(v,*T) S.push(v);

  while ( ! S.empty() )
   { u = S.pop();

     // visit all neighbors v of u not in T and reachable by an epsilon-edge 

     forall_adj_edges(e,u)
     { v = A.target(e);
       if ( A.inf(e) == EPSILON && !T->member(v) ) 
        { T->insert(v);
          S.push(v);
         }
      }
    }

 } // E_CLOSURE


//------------------------------------------------------------------------------
// Move
//------------------------------------------------------------------------------

node_set_ptr MOVE(NFA& A, node_set_ptr T, char x)
{
  /* result is a pointer p to the set of nodes to which there 
     is a transition on input symbol x from a node in *T
  */

  node v;
  edge e;

  node_set_ptr p = new set<node>;  
  /* now p is a pointer to an empty set  of nodes */

  forall(v,*T)
    forall_adj_edges(e,v)
      if ( A.inf(e) == x ) p->insert(A.target(e));

  return p;

} // MOVE



//------------------------------------------------------------------------------
// Build a DFA from an NFA
//------------------------------------------------------------------------------

DFA  BUILD_DFA_FROM_NFA(NFA& A, node s0)
{
  // result is a DFA B accepting the same language
  // as NFA A with initial state s0


  DFA B;

  stack<node> S;

  node v,w;
  char c;
  node_set_ptr p;

  /* First we create a DFA-node for epsilon-closure(s0)and push it 
     on the stack S. S contains all nodes of DFA B whose transitions 
     have not been examined so far.  
  */

  p = new set<node>;
  p->insert(s0);
  E_CLOSURE(A,p);
  S.push(B.new_node(p));

  while ( ! S.empty() )
  { v = S.pop();

    for(c = 'a'; c<='z'; c++)  // for each input symbol c do
     {
       p = MOVE(A,B.inf(v),c);

       // Is there any NFA-transisition from a node in B.inf(v) ?
       // i.e.: Is p not empty ?

       if ( ! p->empty() )     
        {
          // compute the epsilon closure of *p

          E_CLOSURE(A,p);
   

          /* search for a DFA-node w with B.inf(w) == *p */

          bool found = false;       
          forall_nodes(w,B)
            if (EQ_NODE_SET(B.inf(w),p))
               { found = true;
                 break;
                }

          /* if no such node exists create it */
   
          if ( !found )                     
           { w = B.new_node(p);
             S.push(w);
            }
   
          /* insert edge [v] --(c)--> [w] */

          B.new_edge(v,w,c);               

         } // if p not empty
   
      }  // for c = 'a' ... 'z'

   } // while S not empty

 return B;
  
}


  

main()
{ 

  // Build a NFA A

  NFA A;

  // States = {0,1,...,N-1}

  int N = read_int("number of states N = ");

  cout << "Start state = 0\n";

  array<node> state(0,N-1);

  int i,j;
  char c;

  // create N nodes: state[0], ... , state[N-1]

  loop(i,0,N-1) state[i] = A.new_node(i);


  // create edges (transistions)

  cout << "Enter Transitions of NFA (terminate input with   0 0 0)\n";
  

  for(;;)
  { cout << "state1  state2  label : ";
    cin >> i >> j >> c;
    if (i==0 && j==0 && c=='0') break;

    A.new_edge(state[i], state[j], c);
   }

  node u,v;
  edge e;

  // output  NFA A:

  newline;
  cout << "NFA A: \n";

  forall_nodes(v,A)
    { cout << string(" [%d] : ",A.inf(v));
      forall_adj_edges(e,v) 
        cout << string(" [%d]--%c-->[%d] ",A.inf(v),A.inf(e),A.inf(A.target(e)));
      newline;
     }

  DFA B = BUILD_DFA_FROM_NFA(A,state[0]);


  // output  DFA B:

  node_array<int> name(B);

  newline;
  cout << "DFA B:\n";
  i=0;
  forall_nodes(v,B)
    { name[v] = i++;
      cout << string(" [%d] = {",i);
      forall(u,*B.inf(v)) cout << " " << A.inf(u);
      cout << " }\n";
     }
  newline;

  forall_nodes(v,B)
    { cout << string(" [%d] : ",name[v]);
      forall_adj_edges(e,v) 
        cout << string(" [%d]--%c-->[%d] ",name[v],B.inf(e),name[B.target(e)]);
      newline;
     }

  return 0;
}
