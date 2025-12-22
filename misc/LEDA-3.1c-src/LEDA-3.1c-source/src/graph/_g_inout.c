/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _g_inout.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/graph.h>
#include <LEDA/stream.h>


//--------------------------------------------------------------------------
// graph i/o
//--------------------------------------------------------------------------


void put_int(filebuf& fb, int n)
{ register char* A = (char*)&n;
           char* E = A+4;

  while (A<E) fb.sputc(*(A++));
}

int get_int(istream& from)
{ int n;
  register char* A = (char*)&n;
           char* E = A+4;
  while (A<E) from.get(*(A++));
  return n;
}

void graph::write(string file_name) const
{ char* s = ~file_name;
  file_ostream out(s);
  if (out.fail()) error_handler(1,"write: cannot open file");
  write(out);
}


void graph::write(ostream& out) const
{
  int* A = new int[max_n_index+2];

  // nodes get numbers from 1 to |V| (trouble with 0)

  int count = 1;

  out << "LEDA.GRAPH\n";
  out << node_type() << "\n";
  out << edge_type() << "\n";
 
  out << V.length() << "\n";

  node v;
  forall_nodes(v,*this)
  { write_node_entry(out,v->data[0]);
    out << "\n";
    A[v->name] = count++;
   }

  out << E.length() << "\n";
  edge e;
  forall_edges(e,*this)
  { out << A[e->s->name] << " " << A[e->t->name] << " ";
    write_edge_entry(out,e->data[0]);
    out << "\n";
   }
delete A;
}

int graph::read(string file_name)
{ char* s = ~file_name;
  file_istream in(s);
  if (in.fail())  return 1;
  return read(in);
}

int graph::read(istream& in)
{ int result = 0;

  clear();

  edge e;
  int n,i,v,w;

  string d_type,n_type,e_type;

  string this_n_type = node_type();
  string this_e_type = edge_type();

  while (in && d_type=="") in >> d_type;

  in >> n_type >> e_type >> n;

  if (d_type != "LEDA.GRAPH") return 3;

  read_line(in);

  node* A = new node[n+1];

  if (n_type != this_n_type)
  { if (this_n_type != "void") result = 2;   // incompatible node types
    for (i=1; i<=n; i++)
    { A[i] = new_node();
      read_line(in);
     }
   }
  else
    for (i=1; i<=n; i++)
    { A[i] = new_node(0);
      read_node_entry(in,A[i]->data[0]);
     }
 
  in >> n;       // number of edges

  if (e_type != this_e_type)
  { if (this_e_type != "void") result = 2;   // incompatible edge types
    while (n--) { in >> v >> w;
                  e = new_edge(A[v],A[w]);
                  read_line(in);
                 }
   }
  else
   while (n--) { in >> v >> w;
                 e = new_edge(A[v],A[w],0);
                 read_edge_entry(in,e->data[0]);
                }

  delete A;
  return result;
}


void graph::print_node(node v,ostream& o) const
{ if (super() != 0)
     super()->print_node(node(graph::inf(v)),o);
  else
     { o << "[" << index(v) <<"]" ;
       print_node_entry(o,v->data[0]);
      }
}

void graph::print_edge(edge e,ostream& o) const
{ if (super() != 0)
     super()->print_edge(edge(graph::inf(e)),o);
  else
     { o <<   "[" << e->s->name << "]--";
       print_edge_entry(o,e->data[0]);
       o << "-->[" << e->t->name << "]";
      }
}

void graph::print(string s, ostream& out) const
{ node v;
  edge e;
  out << s << endl;
  forall_nodes(v,*this)
  { print_node(v,out);
    out << " : ";
    forall_adj_edges(e,v) print_edge(e,out);
    out << endl;
   }
  out << endl;
}
