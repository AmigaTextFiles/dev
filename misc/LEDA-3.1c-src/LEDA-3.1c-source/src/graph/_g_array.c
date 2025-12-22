/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _g_array.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/graph.h>
#include <LEDA/node_matrix.h>


//------------------------------------------------------------------------------
// node and edge arrays       
//------------------------------------------------------------------------------

void graph_array<node>::init(const graph& G, int n, GenPtr i)
{ if (g!=0) clear();
  g = (graph*)&G;
  mx_i=n-1;
  arr=new GenPtr[n];
  if (arr==0)  error_handler(1,"node_array: out of memory");
  for (int j=0; j<n; j++) { copy_entry(i); arr[j] = i; }
}

void graph_array<node>::init(const graph_array<node>& A)
{ if (g!=0) clear();
  g = A.g;
  mx_i=A.mx_i;
  arr=new GenPtr[mx_i+1];
  if (arr==0)  error_handler(1,"node_array: out of memory");
  for (int j=0;j<=mx_i;j++)
  { GenPtr x = A.arr[j];
    copy_entry(x);
    arr[j] = x;
   }
 }

void graph_array<node>::clear()
{ int j;
  for (j=0;j<=mx_i;j++) clear_entry(arr[j]);
  if (arr) delete[] arr;
  arr=0; g=0; mx_i = -1;
 }



void graph_array<edge>::init(const graph& G, int n, GenPtr i)
{ if (g!=0) clear();
  g = (graph*)&G;
  mx_i=n-1;
  arr=new GenPtr[n];
  if (arr==0)  error_handler(1,"edge_array: out of memory");
  for (int j=0; j<n; j++) { copy_entry(i); arr[j] = i; }
}

void graph_array<edge>::init(const graph_array<edge>& A)
{ if (g!=0) clear();
  g = A.g;
  mx_i=A.mx_i;
  arr=new GenPtr[mx_i+1];
  if (arr==0)  error_handler(1,"edge_array: out of memory");
  for (int j=0;j<=mx_i;j++)
  { GenPtr x = A.arr[j];
    copy_entry(x);
    arr[j] = x;
   }
 }

void graph_array<edge>::clear()
{ int j;
  for (j=0;j<=mx_i;j++) clear_entry(arr[j]);
  if (arr) delete[] arr;
  arr=0; g=0; mx_i = -1;
 }




//------------------------------------------------------------------------------
// node matrices
//------------------------------------------------------------------------------


void Node_Matrix::init(const graph& G, int n, GenPtr x) 
{ int i,j;
  g = (graph*)&G;
  M.init(G,n,0);
  for(i=0;i<M.size();i++) 
    { M.elem(i) = new graph_array<node>;
      M.elem(i) -> init(G,n,0);
      for(j=0;j<M.elem(i)->size();j++) 
        { copy_entry(x);
          M.elem(i)->entry(j) = x;
         }
     }
}

void Node_Matrix::init(const Node_Matrix& A) 
{ int i,j;
  g = A.g;
  M.init(*g,0);
  for(i=0;i<M.size();i++) 
    { M.elem(i) = new graph_array<node>;
      M.elem(i) -> init(*g,g->max_i(node(0)),0);
      for(j=0;j<M.elem(i)->size();j++) 
        { GenPtr x = A.M.elem(i)->entry(j);
          copy_entry(x);
          M.elem(i)->entry(j) = x;
         }
     }
}

void Node_Matrix::clear()
{ int i,j;
  for(i=0;i<M.size();i++) 
   { for(j=0;j<M.elem(i)->size();j++) 
      { GenPtr x = M.elem(i)->entry(j);
        clear_entry(x); 
       }
     delete M.elem(i);
    }
  M.clear();
}

