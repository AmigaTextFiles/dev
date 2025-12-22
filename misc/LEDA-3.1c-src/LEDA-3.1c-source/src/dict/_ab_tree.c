/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _ab_tree.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/impl/ab_tree.h>

//---------------------------------------------------------------
//  
//  Michael Wenzel:
//  function insert_at_item added
//
//  double links between leaf and inner node with same key
//
//  delete overwrites copies of keys in inner nodes
//
//  leafs are nodes of degree 1, linked by son[1], son[2]
//
//---------------------------------------------------------------

//------------------------------------------------------------------
// constructors
//------------------------------------------------------------------


ab_tree_node::ab_tree_node(int p_,int height_,int index_,ab_tree_node* father_,int b)
{
    son  = (ab_tree_node**) allocate_words(b+2);   /* array[1..b+1] */
    k    = (GenPtr*) allocate_words(b+1);             /* array[1..b]   */
    same = (ab_tree_node**) allocate_words(b+1);   /* array[1..b]   */


    // position 0 contains the size of the array:

    son[0]  = (ab_tree_node*)(b+2);
    k[0]    = GenPtr(b+1);
    same[0] = (ab_tree_node*)(b+1);

    p=p_;
    height=height_;
    index=index_;
    father=father_;
    for(int i=1;i<=(b+1);son[i++]=0);
    for(i=1;i<=b;k[i++]=0);
    for(i=1;i<=b;same[i++]=0);                
   }


 ab_tree_node::~ab_tree_node() 
  { deallocate_words(son,int(son[0]));    /* first array element gives size */
    deallocate_words(same,int(same[0]));
    deallocate_words(k,int(k[0]));
   }




 ab_tree::ab_tree(int a_,int b_)
 {
   root=maximum=minimum=0;
   count=0;
   height=-1;
   if((a_>=2)&&(b_>=2*a_-1))
    { a=a_;
      b=b_;
     }
   else error_handler(1,"ab_tree: illegal arguments (a,b) in tree constructor");
 }

 ab_tree::ab_tree(const ab_tree& T)
  {
     if (T.root==0) {root=maximum=minimum=0;height=-1;count=0;}
     else { abnode help=0;
	    root = T.copy_ab_tree(T.root,help,T.b);
            maximum=help;
            help=root;
            while (help->p) help=help->son[1];
	    minimum=help;
            height=T.height;
            count=T.count;
          };
     a=T.a;
     b=T.b;
  }

//-----------------------------------------------------------------
// operators
//-----------------------------------------------------------------

 ab_tree& ab_tree::operator=(const ab_tree& T)
  {  if (this == &T) return *this;

     clear();

     if (T.root!=0) 
     { abnode help=0;
       root=copy_ab_tree(T.root,help,T.b);
       maximum=help;
       help=root;
       while (help->p) help=help->son[1];
       minimum=help;
       height=T.height;
       count=T.count;
      };

     a=T.a;
     b=T.b;

     return *this;
  }


//-----------------------------------------------------------------
// member functions
//-----------------------------------------------------------------

void ab_tree::exchange_leaves(ab_tree_node* v, ab_tree_node* w)
{ // exchange leaves v and w

  GenPtr k1 = v->k[1]; 
  int p1 = v->index;
  ab_tree_node* u1 = v->same[1];
  ab_tree_node* f1 = v->father;

  GenPtr k2 = w->k[1]; 
  int p2 = w->index;
  ab_tree_node* u2 = w->same[1];
  ab_tree_node* f2 = w->father;


  f1->son[p1] = w;
  w->index    = p1;
  w->same[1]  = u1;
  w->father   = f1;

  f2->son[p2] = v;
  v->index    = p2;
  v->same[1]  = u2;
  v->father   = f2;

  ab_tree_node* pred1 = v->son[1];
  ab_tree_node* succ1 = v->son[2];

  ab_tree_node* pred2 = w->son[1];
  ab_tree_node* succ2 = w->son[2];

  w->son[1] = pred1;
  if (pred1) pred1->son[2] = w;
  if (succ1!=w) 
  { w->son[2] = succ1;
    succ1->son[1] = w;
   }

  if (pred2==v) pred2 = w;


  v->son[1] = pred2;
  v->son[2] = succ2;
  pred2->son[2] = v;
  if (succ2) succ2->son[1] = v;

  // minimum & maximum:
  if (v==minimum) minimum = w;
  if (w==maximum) maximum = v;

  // overwrite inner copies:
  
  int pos1=1;
  while(u1->same[pos1]!=v) pos1++;

  int pos2=1;
  if (u2) while(u2->same[pos2]!=w) pos2++;

  u1->k[pos1] = k2;
  u1->same[pos1] = w;

  if (u2) 
  { u2->k[pos2] = k1;
    u2->same[pos2] = v;
   }

}

void ab_tree::reverse_items(ab_tree_node* v, ab_tree_node* w)
{ // reverse sequence of leaves: v, ..., w

  if (v==w) return;

/*
  if (cmp(v->k[1],w->k[1])<0) 
  { newline;
    cout << "a = "; print_key(v->k[1]); newline;
    cout << "b = "; print_key(w->k[1]); newline;
    error_handler(1,"ab_tree: illegal reverse_items(a,b)\n");
   }
*/

  ab_tree_node* u;

  for(;;)
  { exchange_leaves(v,w);
    u = pred(v);
    if (u == w) break;
    v = succ(w);
    if (v==u) break;
    w = u;
   }

}


 void ab_tree::clear()
 { if (root!=0) del_tree(root);
   maximum=minimum=root=0;
   count = 0;
   height=-1;
  }


 void ab_tree::del(GenPtr key)
 { if (!root) return;                      // s.n.

   ab_tree_node* w=locate(key);

   if(w && cmp(w->k[1],key) == 0)  del_item(w);

   else /* error_handler(1,"ab_tree: del(key):key is not in tree") */;
 }


ab_tree_node* ab_tree::expand(ab_tree_node* v,int i)

// expand v by returning an additional son to the right of w
// --> w is the i-th son of v
// s.n.: if i==0 then  new leftmost son
// expand does not test a<=number of sons(v)<=b
// m.w. expand does not set same links for new leaves

 {
   // move the nodes right to w to give an additional son to 
   // the right of w

   int l=(v->p);

   if (i < l)
   {
     v->son[l+1]=v->son[l];
     v->son[l+1]->index=l+1;
     l--;
    }

   while(i < l) 
   { 
     v->k[l+1] = v->k[l];
     v->same[l+1] = v->same[l];

     v->son[l+1]=v->son[l];
     v->son[l+1]->index=l+1;

     l--;
    };

   if (v->height>1)
      v->son[i+1] = new ab_tree_node(0,v->height-1,i+1,v,b);
   else  
      v->son[i+1] = new ab_tree_node(0,v->height-1,i+1,v,1);

   (v->p)++;

   return v->son[i+1];
}                     
                     

void ab_tree::split_node(ab_tree_node* v)
{
 /* adding a child increases the degree of v by 1. If v->p<=b after
    adding the new leave, then we are done . Otherwise we have to 
    split v. Splitting can propagate ==> Loop 

    m.w. changes same links between nodes                          */

  ab_tree_node* y;

  while (v->p==b+1) 
  {
    if (v!=root)  y = v->father;
    else 
    { y=new ab_tree_node(1,v->height+1,0,0,b);
      root=y;height++;
      y->son[1]=v;
      v->index=1;
      v->father=y;
     };


    register ab_tree_node* u;

    u = expand(y,v->index);   // u <-- new right brother of v

    int down =(int)((b+1)/2) ;
    int up = (b+1)- down;


    if (u->index <= b)
    { y->k[u->index] = y->k[v->index];
      y->same[u->index] = y->same[v->index];
     }

    y->k[v->index] = v->k[down];
    y->same[v->index]  = v->same[down];
    y->same[v->index]->same[1] = y;    
 

    // split v, i.e. take the rightmost (b+1)/2 children and keys
    // away from v and incorporate them into u and store key v->k[(b+1)/2]
    // in y ( = father(v))  between the pointers to v and u i.e. at position
    // v->index

    // m.w. change same links of v to y and u

    register int j;

    for (j=1;j<up;j++)    
    {
      u->son[j] = v->son[down+j];
      u->son[j]->index=j;
      u->son[j]->father=u;
      u->k[j] = v->k[down+j];
      u->same[j] = v->same[down+j]; 
      u->same[j]->same[1] = u;      

      v->son[down+j] = 0;      // muss das sein ?
      v->same[down+j] = 0;          
      v->k[down+j] = 0;

     };

    u->son[up]=v->son[b+1];
    u->son[up]->index=up;
    u->son[up]->father=u;

    v->son[b+1] = 0;          // und das?
    v->same[down] = 0;                 
    v->k[down] = 0;

    v->p = down;             // change number of children
    u->p = up;

    v = y;
  }

};

ab_tree_node* ab_tree::insert(GenPtr key, GenPtr inf)
{

 if (root==0) { root=new ab_tree_node(0,0,0,0,1);
                copy_key(key);
                copy_inf(inf);
                root->inf = inf;
                root->k[1]= key;
                height=0;
                maximum=minimum=root;
                count++;
                return root;
               }

 // insert_at_item calls copy_key & copy_inf

 ab_tree_node* p = locate(key);
 if (p==nil) p = maximum;
 return insert_at_item(p,key,inf);

};

ab_tree_node* ab_tree::insert_at_item(ab_tree_node* w, GenPtr key, GenPtr inf)
{ 
  // insert a new item (key,inf) left or right of leaf w  (according to key(w))

   copy_inf(inf);

   ab_tree_node* v;

    if (cmp(w->k[1],key)!=0)
    {
      copy_key(key);

     if ( w!=minimum && cmp(w->son[1]->k[1],key) > 0)
      { cout << "INSERT_AT: WRONG POSITION\n";
        cout << "insert:   key = "; print_key(key); cout << "\n";
        if (w!=maximum) 
           cout << "succ-pos: key = "; print_key(w->son[2]->k[1]); cout << "\n";
        cout << "position: key = "; print_key(w->k[1]); cout << "\n";
        cout << "pred-pos: key = "; print_key(w->son[1]->k[1]); cout << "\n";
        error_handler(1,"ab_tree::insert_at : wrong position "); 
       }

     if ( w!=maximum && cmp(w->son[2]->k[1],key) < 0)
      { cout << "INSERT_AT: WRONG POSITION\n";
        cout << "insert:   key = "; print_key(key); cout << "\n";
        cout << "succ-pos: key = "; print_key(w->son[2]->k[1]); cout << "\n";
        cout << "position: key = "; print_key(w->k[1]); cout << "\n";
        if (w!=minimum)
           cout << "pred-pos: key = "; print_key(w->son[1]->k[1]); cout << "\n";
        error_handler(1,"ab_tree::insert_at : wrong position "); 
       }


        count++;
        if (root==w) {   v=new ab_tree_node(2,1,0,0,b);
                         root=v;height=1;
                         ab_tree_node* u;
                         if (cmp(key,w->k[1])<0)
                             {   
                                 u=new ab_tree_node(0,0,1,v,1);
                                 v->son[1]=u;u->k[1]=key; u->inf=inf;
                                 v->son[2]=w ;
                                 v->p=2;v->k[1]=u->k[1];
				 u->same[1] = v;
                                 v->same[1] = u;
				 w->index=2;
                                 minimum=u;
                                 u->son[2] = w;
                                 w->son[1] = u;
                             }
                         else {
                                 u=new ab_tree_node(0,0,2,v,1);
                                 v->son[1]=w;
				 w->same[1] = v;
                                 v->same[1] = w;
                                 v->son[2]=u;u->k[1]=key; u->inf=inf;
                                 v->p=2;v->k[1]=w->k[1];
                                 w->index=1; 
                                 maximum=u;
                                 w->son[2] = u;
                                 u->son[1] = w;
                              }
                         w->father=v;

                         return u;
                      }; 

	if ((w!=maximum) && (cmp(key,w->k[1])>0)) w=w->son[2];

        ab_tree_node* u;

        int index1 = w->index;

        v = w->father;

        if (cmp(key,w->k[1])<0)
        { u = expand(v,index1-1);   // new son u left of w
/*
                 v

              /  |  \

                (u)  w  
*/
          u->k[1] = key;
          u->inf = inf;

          u->son[2] = w;
          u->son[1] = w->son[1];
          w->son[1] = u;

	  u->same[1] = v;        
          v->k[index1] = key;
          v->same[index1] = u ;  

          if (minimum == w)  
             minimum=u;
          else 
             u->son[1]->son[2] = u;

         }
        else 
        { u = expand(v,index1);   // new son u right of w
/*
                 v

              /  |  \

             w  (u)     
*/
          u->k[1] = key;
          u->inf = inf;

          u->son[1] = w;
          u->son[2] = w->son[2];
          w->son[2] = u;

          if (maximum == w)  
          {
            maximum=u;
            v->k[index1] = w->k[1];
	    w->same[1] = v;        
	    v->same[index1] = w ;  

           }
          else
          {
            v->k[index1+1] = key;
	    u->same[1] = v;        
	    v->same[index1+1] = u ;  

            u->son[2]->son[1] = u;
           }

         }

        if (v->p > b) split_node(v);

        return u;
      }
   else { clear_inf(w->inf);
          w->inf = inf; 
          return w;
         }
   };

ab_tree_node* ab_tree::locate(GenPtr key) const
   {
  /* searching for an element key in a (a,b)-tree ;
   we search down the tree starting at the root r until we reache 
   a leave. In each node v we use the sequence k[1](v),..k[v->p-1](v) 
   in order to guide the search to the proper subtree.In the the
   function we assume that k[0](v)<key<k[v->p](v) for every
   element key in U
   locate returns a pointer to a leave*/ 

  register ab_tree_node* v = root;
  register int i;

  if (v == nil) return nil;

   while (v->p)      /* while v is not a leave*/
   { for(i=1; i < v->p && cmp(key,v->k[i]) > 0; i++);   // s.n.
     v=v->son[i];
    };

  return (cmp(key,v->k[1]) <= 0) ? v : nil;
};

ab_tree_node* ab_tree::locate_succ(GenPtr key) const
{ ab_tree_node* v = locate(key);
  if (v==0) return maximum;
  if (cmp(key,v->k[1])==0) return v;
  return v->son[1];
 }

ab_tree_node* ab_tree::locate_pred(GenPtr key) const
{ ab_tree_node* v = locate(key);
  if (v==0) return maximum;
  if (cmp(key,v->k[1])==0) return v;
  return v->son[1];
 }


ab_tree_node* ab_tree::lookup(GenPtr k) const 
{ ab_tree_node* p = locate(k);
  if (p && cmp(k,key(p))!=0 ) p = 0;
  return p;
 }


void ab_tree::fuse(ab_tree_node* v,ab_tree_node* y)
   {
   /* fuse v and y, i.e. make all sons of y to sons of v and move all
      keys from y to v and delete node y; also move one key (the key
      between the pointers to y and v) from z to v; (note that this will
      shrink z, i.e. decrease the arity of z by one)  
   */

   ab_tree_node* z=v->father;

   GenPtr hilf=z->k[v->index] ;     /* before k[v->p] was not used {=0}*/
              /* 
                 we only must copy the pointer of son and the node-keys
                 from y to v
              */
	      /* change same-pointer of y and z                     */
   v->k[v->p]=hilf; 
   v->same[v->p]=z->same[v->index];  
   v->same[v->p]->same[1] = v;       

   for(int i=1;i<y->p;i++) {  v->k[v->p+i]=y->k[i];
			      v->same[v->p+i]=y->same[i];    
			      v->same[v->p+i]->same[1]=v;    
                              v->son[v->p+i]=y->son[i];
                              v->son[v->p+i]->index=v->p+i;
                              v->son[v->p+i]->father=v;
                           };
   v->son[v->p+y->p]=y->son[y->p];   /* copy of the last son from y*/
   v->son[v->p+y->p]->index=v->p+y->p;
   v->son[v->p+y->p]->father=v;

   v->p=v->p+y->p;

   for(i=v->index;i<z->p;i++) { z->k[i]=z->k[i+1];
				z->same[i] = z->same[i+1]; 
                                z->son[i+1]=z->son[i+2];
                                if (z->son[i+1]!=0){z->son[i+1]->index=i+1; 
                                z->son[i+1]->father=z;};
                               };
   z->p--;
   z->k[z->p]=0;      
   z->same[z->p]=0;   

   delete y;
   
  };


 void ab_tree::share(ab_tree_node* v,ab_tree_node* y,int direct)
 {
  /* we assume that y is the right brother of v;
     take the leftmost son away from y and make it an additional(right-
     most) son of v; also move one key( the key between the pointers
     to v and y) from z down to v and replace it by the leftmost
     key of y;    
     the other case is equivalent
     let z be the father of v
   */

     ab_tree_node* z=v->father;

     if (direct==1)  { 
                       v->son[v->p+1]=y->son[1];
                       v->son[v->p+1]->index=v->p+1;
                       v->son[v->p+1]->father=v;
                       v->k[v->p]=z->k[v->index];
		       v->same[v->p]=z->same[v->index];   
                       v->same[v->p]->same[1] = v;    
                       z->k[v->index]=y->k[1];
                       z->same[v->index]=y->same[1];      
		       z->same[v->index]->same[1]=z;      

                       v->p++;    

                       for(int i=1;i<(y->p)-1;i++) 
                       { y->son[i]=y->son[i+1];
                         y->son[i]->index=i;
                         y->k[i]=y->k[i+1];
                         y->same[i]=y->same[i+1];
                       };

                       y->p--;     // decrease number of children

                       y->son[y->p]=y->son[y->p+1];
                       y->son[y->p]->index=y->p;
                       y->son[y->p+1]=0;  
                       y->k[y->p]=0;
		       y->same[y->p] = 0;                 
                     }
     else            {    // y is at the left side of v
                       for(int i=v->p;i>=1;i--) 
                       { v->son[i+1]=v->son[i];
                         v->son[i+1]->index=i+1;
                         v->k[i+1]=v->k[i];
                         v->same[i+1]=v->same[i]; 
                        };

                       v->son[1]=y->son[y->p];
                       v->son[1]->index=1;
                       v->son[1]->father=v;
                       y->son[y->p]=0;

                       v->p++;
                       y->p--;

                       v->k[1]=z->k[y->index];
		       v->same[1]=z->same[y->index];     
		       v->same[1]->same[1] = v;            
                       z->k[y->index]=y->k[y->p];
                       z->same[y->index]=y->same[y->p];  
                       z->same[y->index]->same[1] = z;   
                       y->k[y->p]=0;
		       y->same[y->p]=0;                    
                     };
     }


 void ab_tree::del_item(ab_tree_node* w)
    {
         /* 
          we must delete leave w with father v
          we shrink v by deleting leave w and one of the keys in the 
          adjacent to the pointer to w 
          (if w is the i-th son of v then we delete k[i](v) if i<v->p
          k[i-1](v) if i=v->p  ).
	  m.w. if i=v->p we overwrite the inner node 
	       in which key w->k[1] is stored with k[i-1](v)
	       and then delete k[i-1](v)
         */


       if (w==nil) error_handler(1,"ab_tree: nil item in del_item");

       count--;

       if (maximum==minimum)  
        { maximum=minimum=root=0; 
          height=-1; 
          clear_key(w->k[1]);
          clear_inf(w->inf);
          delete w; 
          return;
         }
			/* here w==root==> last leave will be deleted*/
       
       ab_tree_node* succ = w->son[2];
       ab_tree_node* pred = w->son[1];

       if (pred) pred->son[2]   = succ;
       else minimum = succ;
       if (succ) succ->son[1] = pred;
       else  maximum = pred;


       ab_tree_node* v    = w->father;

       v->son[w->index]=0;
       if (w->index==v->p) {
			     if (succ)
			     { //overwrite copies in inner node u
			       ab_tree_node* u = w->same[1];
			       int pos=1;
                               while(u->same[pos]!=w) pos++;
			       u->k[pos]=pred->k[1];  
			       u->same[pos]=pred;
			       pred->same[1] = u;
			     }
			     else
			       v->same[v->p-1]->same[1]=0; 
                             v->k[v->p-1]=0;
			     v->same[v->p-1]=0;           
			   }
       else                { v->k[w->index]=0 ;
			     v->same[w->index]=0;         
                             for(int i=w->index;i<(v->p)-1;i++)
                             { v->k[i]=v->k[i+1];
                               v->same[i]=v->same[i+1]; 
                               v->son[i]=v->son[i+1];
                               v->son[i]->father=v;
                               v->son[i]->index=i;
                              };
                             v->son[v->p-1]=v->son[v->p];
                             v->son[v->p]=0;
                             v->k[v->p-1]=0;
                             v->same[v->p-1]=0;          
                             v->son[v->p-1]->father=v;
                             v->son[v->p-1]->index=v->p-1;
                           };

       clear_key(w->k[1]);
       clear_inf(w->inf);
       delete w;

       (v->p)--;
       
       if ((v==root) && (v->p==1)) {  
                                  if (v->son[1]==0) 
                                      {v->son[1]=v->son[2];
                                       v->son[2]=0;  };
                                  root=v->son[1];
                                  delete v;
                                  root->index=0;
                                  root->father=0;
                                  root->p=0;
                                  root->height=0;
                                  height=0;
                                  minimum=maximum=root;
                                  return; 
                                };

       if (v->p >= a) return;

    /* otherwise v needs to be rebalanced by either fusing or sharing
     let y be any brother of v*/
     ab_tree_node* z;
     ab_tree_node* y;
     int dir;
       if (v->index==1)  {
                            z=v->father;
                            y=z->son[v->index+1] ;
                           dir=1;    //  y is the right son of v
                         }
       else              { 
                            z=v->father;
                            y=z->son[v->index-1] ;
                           dir =0;   //  y is the left son of v
                         };
       while ((v->p==a-1) && (y->p==a))
            {
             if (dir==1) fuse(v,y); 
             else  fuse(y,v); 

             if (z==root) {
                           if (z->p==1) {
                                         if (dir==1){
                                                      root=v;
                                                      v->father=0;
                                                      v->index=0;   }
                                         else {
                                                root=y;
                                                y->father=0;
                                                y->index=0;    };
                                         height--;
                                         delete z;  
                                       };
                           return;
                          };
             v=z;       // continue recursion
             if (v->index==1)  {z=v->father;
                                y=z->son[v->index+1] ;
                                dir=1;  // y is the right son of v
                               }
             else              { z=v->father;
                                 y=z->son[v->index-1];
                                 dir=0;
                               };
            };
    /* we have either v->p>=a and rebalancing is completed or
     v->p = a-1 and y->p > a and rebalancing is completed by sharing;*/

      if (v->p==a-1)
        {       /*
                 it is important to which side y is in order to v
                 ==> dir is an information about in the function share
                */
           share(v,y,dir);
        };
      return;
 }


ab_tree& ab_tree::conc(ab_tree& s2)

{ 
  if ((a!=s2.a)||(b!=s2.b)) 
     error_handler(1,"ab_tree: incompatible trees in concatenate operation");

  if (s2.root==0) return *this;

  if (root==0) 
  { root=s2.root;
    maximum=s2.maximum;
    minimum=s2.minimum;
    height=s2.height;
    count =s2.count;
   }
  else
  { if (cmp(maximum->k[1],s2.minimum->k[1])>=0) 
                    error_handler(1,"ab_tree: join(S,T) : max(S)>=min(T)"); 

    concat(*this,s2,maximum,maximum->k[1]);

    // link leaves 
    maximum->son[2]=s2.minimum;       
    s2.minimum->son[1]=maximum;

    maximum=s2.maximum;              
   }

  s2.root=0;
  s2.maximum=0;
  s2.minimum=0;
  s2.height=-1;

  return *this;
}


/*---------------------------------------------------------------------
  global functions
----------------------------------------------------------------------*/

void concat(ab_tree& s1,ab_tree& s2,ab_tree_node* current,GenPtr cur_key)
{ 
  // Result in s1

  ab_tree_node* v=s1.root;
  ab_tree_node* w=s2.root;
  int h1=v->height;     
  int h2=w->height;
  int i;

  if(h1==h2)
     { ab_tree_node* z=new ab_tree_node(2,h1+1,0,0,s1.b);
       z->son[1]=v;z->son[2]=w; z->k[1]=cur_key;
       z->son[1]->father=z; z->son[2]->father=z;
       z->son[1]->index=1;z->son[2]->index=2;
       z->same[1]=current;              
       current->same[1]=z;              
       s1.height++;
       s1.root=z;
    }
  else { if (h1>h2)
         {
            for(i=1;i<h1-h2;i++,v=v->son[v->p]);  
            v->son[v->p+1]=w;
            v->son[v->p+1]->father=v;
            v->son[v->p+1]->index=v->p+1;
            v->k[v->p]=cur_key;
	    v->same[v->p]=current;     
	    current->same[1]=v;        
 	    v->p++;
	    if (v->p==s1.b+1)  {s1.split_node(v);  };
        }
        else /* h1<h2 */
        {
	   for(i=1;i<=h2-h1-1;i++,w=w->son[1]);
           for(i=w->p;i>1;i--)
            { w->son[i+1]=w->son[i];
              w->son[i+1]->father=w;
  	      w->son[i+1]->index=i+1;
              w->k[i]=w->k[i-1];
	      w->same[i]=w->same[i-1];   
            };
           w->p++;
           w->son[2]=w->son[1];
           w->son[2]->father=w;
           w->son[2]->index=2;
           w->son[1]=v;
           w->son[1]->father=w;
           w->son[1]->index=1;
           w->k[1]=cur_key;
	   w->same[1]=current;             
	   current->same[1]=w;             
           if (w->p==s2.b+1) {s2.split_node(w);};
	   s1.root =  s2.root;
	   s1.height =  s2.height;
        }
      }

  /* maximum/minimum are now undefined  */

}



/*
void ab_tree::split_at_key(GenPtr y,ab_tree& L,ab_tree& R)
{ ab_tree_node* w = locate(y);
  if (!w) error_handler(1,"ab_tree: split: no item ");
  split_at_item(w,L,R);
 }
*/

void ab_tree::split_at_item(ab_tree_node* w,ab_tree& L,ab_tree& R)
  {
    if(((a!=L.a)||(a!=R.a))||((b!=L.b)||(b!=R.b)))
       error_handler(1,"ab_tree: incompatible trees in split operation");
    
    /* initialisation   */
    L.root=L.minimum=L.maximum=0;L.height=-1;
    R.root=R.minimum=R.maximum=0;R.height=-1;

    if(root==0) return;

    if (w==0) 
    { R.root = root;
      R.height = height;
      R.maximum = maximum;
      R.minimum = minimum;
      R.count = count;
      root = 0;
      height = -1;
      maximum = 0;
      minimum = 0;
      count = 0;
      return;
     }

    if (w==maximum) 
    { L.root = root;
      L.height = height;
      L.maximum = maximum;
      L.minimum = minimum;
      L.count = count;
      root = 0;
      height = -1;
      maximum = 0;
      minimum = 0;
      count = 0;
      return;
     }

    ab_tree_node* l;
    ab_tree_node* r;    // pointers to the roots of the left and right subtree


    /* parameters for concat  */

    ab_tree_node* current_l=0 ;
    GenPtr           current_l_key=0;

    ab_tree_node* current_r=0;  
    GenPtr           current_r_key=0;

    int i;


    /* w is a pointer to the leave y  */
    ab_tree_node* v;

    /* store leaf to split at         */
    ab_tree_node* leaf=w;


     l = w;
     r = 0;

      do{
         v=w->father;
         int index_of_w = w->index; 

       /* now we have construct the  left and right subtrees and the pointers
          to the roots  --> we must construct two trees with these roots*/

        if ((L.root==0)&&(l!=0))  { L.root=l;
			            L.height=l->height; 
			            L.root->father=0;
			            L.root->index=0;
			          }
        else { if ((L.root!=0)&&(l!=0))
                 {  ab_tree L1(L.a,L.b);
	            L1.root=l;
                    L1.height=l->height;
                    L1.root->father=0;
                    L1.root->index=0;
	            concat(L1,L,current_l,current_l_key);
	            L.root  = L1.root;
                    L.height= L1.height;
                    L.count = L1.count;

                    L1.root=0;
	         }
             }
       if ((R.root==0)&&(r!=0))  {R.root=r;
		        	  R.height=r->height;
			          R.root->father=0;
			          R.root->index=0;
                                  R.root->p=r->p;
			         }
       else { if ((R.root!=0)&&(r!=0))
                { ab_tree R1(R.a,R.b);
	  	  R1.root=r;
		  R1.height=r->height;
                  R1.root->father=0;
                  R1.root->index=0;
                  R1.root->p=r->p;
		  concat(R,R1,current_r,current_r_key);
                  R1.root=0;
	        }
            }
        if (v!=0)
        {
         if (index_of_w==1)     /* w is leftmost son of v */
         { l=0;
           r=v;
           current_r=v->same[1];
           current_r_key=v->k[1];
	   r->same[1]->same[1]=0;        
	   for(i=2;i<r->p;i++) 
            {  r->son[i-1]=r->son[i];
   	       r->son[i-1]->index=i-1;
 	       r->k[i-1]=r->k[i];
	       r->same[i-1]=r->same[i];  
    	    }
           r->son[r->p-1]=r->son[r->p];    /* last son */
           r->son[r->p-1]->index=r->p-1;
           r->son[r->p]=0;
           r->p--; 
           r->k[r->p]=0;
	   r->same[r->p]=0;      
           if (r->p==1) r=r->son[1];
         } 
         else {if ( index_of_w==v->p )
                 {  r=0;
                    l=v;
		    l->son[l->p]=0;  /* last son */
		    l->p--;
		    current_l=l->same[index_of_w-1];
		    current_l_key=current_l->k[1];
                    l->k[l->p]=0;
		    l->same[l->p]->same[1]=0;   
		    l->same[l->p]=0;            
                    if (l->p==1) l=l->son[1];
		} 
               else  /* if w is not the leftmost or rightmost son of v*/
               {  
                 r=v;
                 l=new ab_tree_node(index_of_w-1,v->height,0,0,R.b);
 		 current_l=v->same[index_of_w-1];
 		 current_l_key=current_l->k[1];
		 current_r=v->same[index_of_w];   
		 current_r_key=current_r->k[1];
		 // current_r=(v->k[index_of_w])-1;   ERROR: liefert neuen Schluessel ;
                 for(i=1;i<index_of_w-1;i++)
   		  {
		   l->son[i]=v->son[i];
		   l->son[i]->index=i;
                   l->son[i]->father=l;
		   l->k[i]=v->k[i];
		   l->same[i]=v->same[i];  
		   l->same[i]->same[1]=l;  
		  };
		 l->son[index_of_w-1]=v->son[index_of_w-1];
		 l->son[index_of_w-1]->index=index_of_w-1;
                 l->son[index_of_w-1]->father=l;

                 r->son[index_of_w] = 0;   // changed

    		 for (i=1;i<r->p-index_of_w;i++)
		  {
		   r->son[i]=r->son[i+index_of_w];
                   r->son[i+index_of_w]=0;
             	   r->son[i]->index=i;
                   r->son[i]->father=r;
		   r->k[i]=r->k[i+index_of_w];
		   r->same[i]=r->same[i+index_of_w]; 
                   r->k[i+index_of_w]=0;
		   r->same[i+index_of_w]=0;
		  };
	         r->son[r->p-index_of_w]=r->son[r->p];  /* last son */
                 r->son[r->p]=0;
		 r->son[r->p-index_of_w]->index=i;
                 r->son[r->p-index_of_w]->father=r;
		 r->p=r->p-index_of_w;
                 if (l->p==1) l=l->son[1];
                 if (r->p==1) r=r->son[1];
                };
               };
              };

 /* initialisation for the next iteration  */
  w=v;
 }
 while (w!=0);


 /* unlink leaves    m.w.         */
 leaf->same[1]=0;
 leaf->son[2]->son[1]=0;
 leaf->son[2]=0;

 /* redefine maximum and minimum  */
 L.minimum=minimum;
 ab_tree_node* help=L.root;
 while (help->p) help=help->son[help->p];
 L.maximum=help;
 help=R.root;
 while (help->son[1]!=0) help=help->son[1];
 R.minimum=help;
 R.maximum=maximum;

 maximum=minimum=root=l=r=0;
 height=-1; 
 count = 0;

 delete l;
 delete r;

}

void ab_tree::pr_ab_tree(ab_tree_node* localroot,int blancs) const

{ 
  if (localroot==0)
   { for(int j=1;j<=blancs;j++) cout<<" ";
     cout << "NIL\n";
     return;
    }
  
  if (localroot->p == 0) 
   { for(int j=1;j<=blancs;j++) cout<<" ";
     print_key(localroot->k[1]); 
/*
     ab_tree_node* s= localroot->same[1];
     cout << " same = "; 
     if (s) print_key(s->k[1]); 
     else cout << "NIL";
*/
     cout << "\n";
    }

   else
    { for(int i=1;i<localroot->p;i++)
      { pr_ab_tree(localroot->son[i],blancs+10);
        for(int j=1;j<=blancs;j++) cout<<" ";
        print_key(localroot->k[i]); 
/*
        cout << " same = "; 
        print_key(localroot->same[i]->k[1]); 
*/
        cout << "\n";
       };
      pr_ab_tree(localroot->son[localroot->p],blancs+10);
    }
} 
 
ab_tree_node* ab_tree::copy_ab_tree(ab_tree_node* localroot,
                                    abnode& last_leaf,int b) const
{ 
  ab_tree_node* r;

  if (localroot->p == 0)   //leaf
   { r=new ab_tree_node(localroot->p,localroot->height,localroot->index,0,1); 

     r->k[1]= localroot->k[1];
     r->inf = localroot->inf;

     copy_key(r->k[1]);
     copy_inf(localroot->inf);

     r->son[1]=last_leaf;
     if (last_leaf) last_leaf->son[2] = r;
     last_leaf = r;               

    }
  else
   { r=new ab_tree_node(localroot->p,localroot->height,localroot->index,0,b); 

     for(int i=1;i<localroot->p;i++)
     { r->son[i]=copy_ab_tree(localroot->son[i],last_leaf,b);
       r->son[i]->father=r;
       r->k[i]=localroot->k[i];
       last_leaf->same[1]=r;        
       r->same[i]=last_leaf;        
      }

     r->son[localroot->p]=copy_ab_tree(localroot->son[localroot->p],last_leaf,b);
     r->son[localroot->p]->father=r;
   }

  return r;
}
        
void ab_tree::del_tree(ab_tree_node* localroot)
{ // deletes subtree  rooted at localroot

  int k = localroot->p;

  for(int i=1;i<=k;i++) del_tree(localroot->son[i]);

  if (k==0) //leaf
  { clear_key(localroot->k[1]);
    clear_inf(localroot->inf);
   }

  delete localroot;
}

void ab_tree::change_inf(ab_tree_node* p, GenPtr x) 
{ clear_inf(p->inf);
  copy_inf(x);
  p->inf = x;
 }

