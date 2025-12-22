/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _ps_tree.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


//--------------------------------------------------------------------
//  
//  Priority Search Trees
//
//  Renate Lassen   (1990)
//
// Implementation follows
// Kurt Mehlhorn: Data Structures and Algorithms 3, section III.5.1.2
//
// -------------------------------------------------------------------

#include <LEDA/impl/ps_tree.h>


// -------------------------------------------------------------
// member functions
// -------------------------------------------------------------

// -------------------------------------------------------------
// lrot() , rrot() , ldrot() , rdrot()
// Rotationen am Knoten p

void ps_tree::lrot(ps_item p, ps_item q)
{ 
  x_typ xh ,yh;

//  cout << "lrot\n";
//  cout << "p :" << p->split_value_x() << "\n";
//  cout << "q :" << q->split_value_x() << "\n";
  ps_item h = p->sohn[right];
//  cout << "h :" << h->split_value_x() << "\n";
  xh = h->x_value();
  yh = h->y_value();
  
  p->sohn[right] = h->sohn[left];
  h->sohn[left] = p;
   
  if (!q) root=h;
  else
  {
   if ( p == q->sohn[left] )   q->sohn[left]=h;
   else q->sohn[right]=h;
  }; 
  
  h->x_val = p->x_value();
  h->y_val = p->y_value();
  p->x_val = p->y_val = 0;

  if (cmp(xh,yh,h->split_value_x(),h->split_value_y())>0)  
      sink(h->sohn[right],xh,yh);
  else  sink(p->sohn[right],xh,yh); 
    
  fill(p);
  
  p->gr=p->sohn[left]->groesse()+p->sohn[right]->groesse();
  h->gr=p->groesse()+h->sohn[right]->groesse();
}

void ps_tree::rrot(ps_item p, ps_item q)
{ 
  x_typ xh, yh;
  
  //cout << "rrot\n"; 
 // cout << "p :" << p->split_value_x() << "\n";
 // cout << "q :" << q->split_value_x() << "\n";
  ps_item h = p->sohn[left];
 // cout << "h :" << h->split_value_x() << "\n";
  xh=h->x_value();
  yh=h->y_value();
  
  p->sohn[left] = h->sohn[right];
  h->sohn[right] = p;

  if (!q) root=h;
  else
  {
   if ( p == q->sohn[left] ) q->sohn[left] = h;
   else q->sohn[right] = h; 
  };

  h->x_val = p->x_value();
  h->y_val = p->y_value();
  p->x_val = p->y_val = 0;
  
  if (cmp(xh,yh,h->split_value_x(),h->split_value_y())<=0)  
      sink(h->sohn[left],xh,yh);
  else sink(p->sohn[left],xh,yh);
  
  fill(p);

  p->gr=p->sohn[left]->groesse()+p->sohn[right]->groesse();
  h->gr=p->groesse()+h->sohn[left]->groesse();
}

void ps_tree::ldrot(ps_item p, ps_item q)
{ 
    
  //cout << "ldrot\n";
  ps_item h = p->sohn[right];
  ps_item t = h->sohn[left];
  rrot(h,p);
  lrot(p,q);
 // cout << "p:" << p->split_value_x() << "\n";
 // cout << "h:" << h->split_value_x() << "\n";
}

void ps_tree::rdrot(ps_item p, ps_item q)
{

  //cout << "rdrot\n";
  ps_item h = p->sohn[left];
  ps_item t = h->sohn[right];
  lrot(h,p);
  rrot(p,q);
 // cout << "p:" << p->split_value_x() << "\n";
  //cout << "h:" << h->split_value_x() << "\n";
  //cout << "t:" << t->split_value() << "\n";
}
 
// ------------------------------------------------------------------
// fill(ps_item)
// fuellt Knoten bei Rotation wieder auf 
  
void ps_tree::fill(ps_item p)
{

 int leer=0;
 int diff=0;
 //cout << "fill\n";
 while (!p->blatt() && leer!=1)
 {
  diff=cmp(p->sohn[left]->y_value(),p->sohn[right]->y_value()); 
  //cout << "diff = " << diff << "\n";
  if (diff==0) leer=1;                                           // Kinder von p gefuellt ?
  else if ( (diff<0 && p->sohn[left]->y_value()!=0) 
            || (diff>0 && p->sohn[right]->y_value()==0))
       {
        p->x_val = p->sohn[left]->x_value();
        p->y_val = p->sohn[left]->y_value();
        p->sohn[left]->x_val = p->sohn[left]->y_val = 0;   
  //cout <<"gefuellt von links :"<<p->split_value()<<":"<<p->x_value()<<":"<<p->y_value()<<"\n";
        p = p->sohn[left];
       }
       else if ( (diff>0 && p->sohn[right]->y_value()!=0) 
                 || (diff<0 && p->sohn[left]->y_value()==0)) 
            {
            p->x_val = p->sohn[right]->x_value();
            p->y_val = p->sohn[right]->y_value();
            p->sohn[right]->x_val = p->sohn[right]->y_val = 0;   
            p->sohn[right]->x_val = p->sohn[right]->y_val =0;
            p = p->sohn[right];
            };
 };
}

// ------------------------------------------------------------------
// sink() 
// laesst Paar (x,y) im Unterbaum mit Wurzel p herabsinken.
   
ps_item ps_tree::sink(ps_item q, x_typ x, x_typ y)
{
 x_typ xh, yh, xneu=x;
 x_typ yneu=y;
 ps_item p =q;
 ps_item inserted; 
 
 while(!p->blatt() && cmp(p->x_value(),0)!=0)
 {
  //cout << "sink\n";
  //cout << p->split_value_x() << ":" << p->split_value_y() <<":"<< p->x_value() << ":" << p->y_value() <<"\n";
  if (cmp(p->y_value(),0)!=0 && cmp(y,p->y_value())<0)
  {                                                    // Tausch
   xh=p->x_value();
   yh=p->y_value();
   p->x_val=x;
   p->y_val=y;
   x=xh;
   y=yh;
   if (cmp(p->x_value(),xneu)==0 && cmp(p->y_value(),yneu)==0) inserted=p;
  //cout << "inserted in Tausch\n";
  //cout << inserted->split_value() <<":"<< inserted->x_value() << ":" << inserted->y_value() <<"\n";
  };
  //cout << "hallo\n";
  if (cmp(x,y,p->split_value_x(),p->split_value_y())<=0)   p=p->sohn[left];
  else 
  {
   p=p->sohn[right]; 
  //cout << p->split_value_x() << ":" << p->split_value_y() <<":"<< p->x_value() << ":" << p->y_value() <<"\n";
  };
 };
 p->x_val=x;
 p->y_val=y;
 if (cmp(p->x_value(),xneu)==0 && cmp(p->y_value(),yneu)==0) inserted=p;
 // cout << "inserted" << inserted->split_value_y() <<":"<< inserted->x_value() << ":" << inserted->y_value() <<"\n";
 return inserted;
}

// ------------------------------------------------------------------
// search(x_typ,x_typ)
// sucht Knoten, der das Paar (x,y) enthaelt,
// oder Blatt, an dem neues Blatt fuer x angehaengt werden soll.

 
ps_item ps_tree::search(x_typ x,x_typ y)
{
 ps_item p = root;
 ps_item q = 0;

// cout << "search\n";
 if (root->blatt())
 {
  st.push(root);
  return p;
 }
 else
 {
  st.push(p);
  while ( !p->blatt() && p!=0 )
  {
   if ( cmp(x,p->x_value())==0 && cmp(y,p->y_value())==0) 
   {
    p=0;
   }
   else 
   { 
    if ( cmp(x,y,p->split_value_x(),p->split_value_y())<=0 ) p=p->sohn[left];
    else p=p->sohn[right]; 
    st.push(p);
   }
  }
  return p;
 }
}  

  
// ------------------------------------------------------------------
// locate(x_typ x,x_typ y)
// gibt Knoten oder Blatt mit Inhalt (x,y), falls existiert,
//                                      0 , sonst.
 
ps_item ps_tree::locate(x_typ x,x_typ y)
{
 ps_item p = root;
 ps_item q = 0;

 //cout << "locate\n";
 while ( q==0 && p!=0 && cmp(y,p->y_value())>=0 )
 {
  st.push(p);
  if ( cmp(x,p->x_value())==0 && cmp(y,p->y_value())==0) 
  {
   q=p;
  }
  else 
  { 
   if ( cmp(x,y,p->split_value_x(),p->split_value_y())<=0 ) p=p->sohn[left];
   else p=p->sohn[right]; 
  }
 }
 return q;
}

// ------------------------------------------------------------------
// delleaf(ps_item)
// loescht Blatt von Paar (x,y) und Vater des Blattes.
// ( Zwei Blaetter mit gemeinsamen Vater sind nie beide gefuellt. )
  
void ps_tree::delleaf(ps_item q)
{
 ps_item p;	
 ps_item t;	
 ps_item father;
 x_typ xh,yh;

 //cout << "delleaf\n";
 q->x_val=0;
 q->y_val=0;
 p=st.pop();
 father=st.pop();
 if (q==father->sohn[left] ) father->sohn[left]=0;
 else father->sohn[right]=0;
 delete (q);                                           // loescht Blatt
 t= st.empty() ? 0 : st.top();
 xh=father->x_value();
 yh=father->y_value();
 //cout << "xh: " << xh << "\n";
 //cout << "yh: " << yh << "\n";
  
 if ( father->sohn[left]!=0) q=father->sohn[left];
 else q=father->sohn[right];
 if (t!=0)
 {
  if (father==t->sohn[left])  t->sohn[left]=q;
  else  t->sohn[right]=q;
 }
 else root=q;
 delete(father);                                       // loescht Vater
 
 //cout << "q-x_value: " << q->x_value() << "\n";
 //cout << "q-y_value: " << q->y_value() << "\n";
 //cout << "q-split_value: " << q->split_value() << "\n";
 sink(q,xh,yh);
}
  
// ------------------------------------------------------------------
// insert(x_typ x,x_typ y)
// fuegt ein neues Item (x,y) in den Baum ein
//                 , falls noch nicht vorhanden, 
// Fehlermeldung   ,sonst
// gibt Zeiger auf eingefuegtes Blatt zurueck

ps_item ps_tree::insert(x_typ x,x_typ y)
{ 
 ps_item p;
 ps_item t;
 ps_item father;
 
 if (!root)                                     // neuer Baum
 {  
  ps_item p=new ps_node(x,y,x,y);
  root=p; 
  anzahl=1; 
  return p;
 }
 else
 {
  p=search(x,y);
  //cout << "p-x_value: " << p->x_value() << "\n";
  //cout << "p-y_value: " << p->y_value() << "\n";
  //cout << "p-split_value_x: " << p->split_value_x() << "\n";
  //cout << "p-split_value_y: " << p->split_value_y() << "\n";
  
  if (p==0)
  {
   error_handler(0,"point already there !");   // Warnung
   st.clear();
   return p;
  }
  else
  {
   ps_item q = new ps_node(0,0,p->split_value_x(),p->split_value_y());   
   ps_item w = new ps_node(0,0,x,y);           // zwei neue Blaetter
  //cout << "q-x_value: " << q->x_value() << "\n";
  //cout << "q-y_value: " << q->y_value() << "\n";
  //cout << "q-split_value_x: " << q->split_value_x() << "\n";
  //cout << "q-split_value_y: " << q->split_value_y() << "\n";
  //cout << "w-x_value: " << w->x_value() << "\n";
  //cout << "w-y_value: " << w->y_value() << "\n";
  //cout << "w-split_value_x: " << w->split_value_x() << "\n";
  //cout << "w-split_value_y: " << w->split_value_y() << "\n";
   if(cmp(p->split_value_x(),p->split_value_y(),x,y)<=0)
   {
    p->sohn[left]=q; 
    p->sohn[right]=w; 
   }
   else
   {
    p->split_val[0] = x;
    p->split_val[1] = y;
    p->sohn[left]=w;
    p->sohn[right]=q;
   } 
				   
  //cout << "p-x_value: " << p->x_value() << "\n";
  //cout << "p-y_value: " << p->y_value() << "\n";
  //cout << "p-split_value_x: " << p->split_value_x() << "\n";
  //cout << "p-split_value_y: " << p->split_value_y() << "\n";
   while (!st.empty())                          // rebalancieren
   { 
    t=st.pop();
   // cout << "stack\n";
    father = st.empty() ? 0 : st.top();
    t->gr++;  
    float i = t->bal();
  
    //cout << "i" << i << "\n";
    if (i < alpha)
    {
     if (t->sohn[right]->bal()<=d) lrot(t,father);
     else ldrot(t,father);
    }
    else if (i>1-alpha) 
    {
      if (t->sohn[left]->bal() > d ) rrot(t,father);
      else rdrot(t,father);
    }
   }
   p = sink(root,x,y);
   //cout<< p->split_value() <<":"<< p->x_value() << ":" << p->y_value() <<"\n";
   return p;
  }
 } 
}
// ------------------------------------------------------------------
// del()
// loescht Item it im Baum mit x_value(it) = x ,
//                             y_value(it) = y , falls existiert
//         und gibt Zeiger auf it zurueck
// 0 , sonst

ps_item ps_tree::del(x_typ x,x_typ y)
{ 
 ps_item p;
 ps_item t;
 ps_item father;
 ps_item deleted = new ps_node(x,y,0,0);
 
 if (root==0) 
 {
  error_handler(0,"Tree is empty");
  return 0;                                          // leerer Baum
 }
 else
 {
  p=locate(x,y);
  //cout << "located:"<<p->split_value()<<"\n";
  if (p==0) 
  {
   error_handler(0,"Pair is not in tree ");
   st.clear();
   return 0;                                         // Paar nicht im Baum
  }
  else
  { 
   if (p->blatt()) 
   {
    if (p==root)
    {
     error_handler(0,"Root is deleted.");
     p=st.pop();
     root=0;
     anzahl=0;
     return p;                                       // Wurzel geloescht
    } 
    else
    {
     delleaf(p);                                 // (x,y) steht in einem Blatt
    }
   }
   else                                          // (x,y) steht in einem Knoten
   {
    p->x_val = p->y_val = 0;
    fill(p);
    while (!p->blatt())                               // Knoteninhalt loeschen
    {                                                 // und neu auffuellen
     if (cmp(x,y,p->split_value_x(),p->split_value_y())<=0) p=p->sohn[left];
     else p=p->sohn[right];
     st.push(p);
    };
    
    delleaf(p);                                    // loescht zugehoeriges Blatt
   }
 
   while (!st.empty())                                 // rebalancieren
   { 
    t = st.pop();
    //cout << "stack\n";
    //cout << t->split_value()<<":"<<t->x_value()<<":"<<t->y_value()<<"\n";
    father = st.empty() ? 0 : st.top() ;
    t->gr--;              
    float i=t->bal();
    //cout << "i :" << i << "\n";
    if (i<alpha)
    { 
     if (t->sohn[right]->bal() <= d) lrot(t,father);
     else ldrot(t,father);
    }
    else if (i>1-alpha)
    { 
     if(t->sohn[left]->bal() > d) rrot(t,father);
     else rdrot(t,father);
    }
   }
   return(deleted);
  }
 }
} 
   
//-----------------------------------------------------------------------
//enumerate(x1,x2,y0,p)
//gibt alle Punkte (x,y) aus Unterbaum mit Wurzel p
//mit folgender Eigenschaft an :
//  x1 <= x <= x2   &&   y <= y0 
//Voraussetzung : x1 < x2

void ps_tree::enumerate(x_typ x1,x_typ x2,x_typ y0,ps_item p)
{
 if (cmp(y0,p->y_value())>=0 && p!=0)
 {
  if (cmp(x1,p->split_value_x())<=0 && cmp(p->split_value_x(),x2)<=0)
  {
   if (cmp(x1,p->x_value())<=0 && cmp(p->x_value(),x2)<=0)
      cout <<p->split_value_x()<<"("<<p->x_value()<<","<<p->y_value()<<")\n";
   enumerate(x1,x2,y0,p->sohn[left]); 
   enumerate(x1,x2,y0,p->sohn[right]); 
  }
  else if (cmp(p->split_value_x(),x1)<=0) 
       {
        if(cmp(x1,p->x_value())<=0 && cmp(p->x_value(),x2)<=0)
           cout <<p->split_value_x()<<"("<<p->x_value()<<","<<p->y_value()<<")\n";
        enumerate(x1,x2,y0,p->sohn[right]);
       }
       else if (cmp(x2,p->split_value_x())<=0) 
       {
        if(cmp(x1,p->x_value())<=0 && cmp(p->x_value(),x2)<=0)
           cout <<p->split_value_x()<<"("<<p->x_value()<<","<<p->y_value()<<")\n";
        enumerate(x1,x2,y0,p->sohn[left]);
       }
 }
}
   	
//-----------------------------------------------------------------------
//void pr_ps_tree(ps_item p;int blancs)
//gibt den Baum mit Wurzel p aus

void ps_tree::pr_ps_tree(ps_item p,int blancs)
{
 if (p==0)
   { for (int j=1;j<=blancs;j++) cout << " ";
     cout << "NIL\n";
     return;
   }
 else
   { pr_ps_tree(p->sohn[left],blancs+10); 
     for (int j=1;j<=blancs;j++) cout << " ";
     cout << "(" << p->split_value_x() << "," << p->split_value_y() << "):";
     cout << "(" << p->x_value() << "," << p->y_value() << ")\n";
     pr_ps_tree(p->sohn[right],blancs+10); 
   }
}
 
//-----------------------------------------------------------------------
//min_x_in_rect(x1,x2,y0,p)
//sucht nach Paar (x,y) im Unterbaum von p 
//mit folgender Eigenschaft :
//  min { x ; es gibt y, so dass x1<=x<=x2 und y<=y0 } , falls existiert,
//                                                   0 , sonst.

pair_item ps_tree::min_x_in_rect(x_typ x1,x_typ x2,x_typ y0,ps_item p)
{
 pair_item  c;

 if (p==0)
 {
  return 0;                                   // Baum ist leer.
 }
 else
 {
  c=new pair;
  c->x_pkt=c->y_pkt=0;
  c->valid=false;
  if (cmp(y0,p->y_value())>=0)
  {
   if (!p->blatt())
   {
    if (cmp(x1,p->split_value_x())<=0) 
        c=min_x_in_rect(x1,x2,y0,p->sohn[left]);
    if (!c->valid && cmp(p->split_value_x(),x2)<0) 
        c=min_x_in_rect(x1,x2,y0,p->sohn[right]);
   }
   if (cmp(x1,p->x_value())<=0 && cmp(p->x_value(),x2)<=0 
       && cmp(p->y_value(),y0)<=0
       && (!c->valid || cmp(p->x_value(),c->x_pkt)<0)     )
   {
    c->x_pkt=p->x_value();  
    c->y_pkt=p->y_value();  
    c->valid=true;
   }
  }
  return c;
 }
}

//-----------------------------------------------------------------------
//max_x_in_rect(x1,x2,y0,p)
//sucht nach Paar (x,y) im Unterbaum von p 
//mit folgender Eigenschaft :
//  max { x ; es gibt y, so dass x1<=x<=x2 und y<=y0 } , falls existiert,
//                                                   0 , sonst.

pair_item ps_tree::max_x_in_rect(x_typ x1,x_typ x2,x_typ y0,ps_item p)
{
 pair_item c;

 if (p==0) 
 {
  return 0;                                      // Baum ist leer.
 }
 else
 {
  c=new pair;
  c->x_pkt=c->y_pkt=0;
  c->valid=false;
  if (cmp(y0,p->y_value())>=0)
  {
   if (!p->blatt())
   {
    if (cmp(p->split_value_x(),x2)<=0) 
        c=max_x_in_rect(x1,x2,y0,p->sohn[right]);
    if (!c->valid && cmp(x1,p->split_value_x())<0) 
        c=max_x_in_rect(x1,x2,y0,p->sohn[left]);
   }
   if (cmp(x1,p->x_value())<=0 && cmp(p->x_value(),x2)<=0 
       && cmp(p->y_value(),y0)<=0
       && (!c->valid || cmp(p->x_value(),c->x_pkt)>0)     )
   {
    c->x_pkt=p->x_value();  
    c->y_pkt=p->y_value();  
    c->valid=true;
   }
  }
  return c;
 }
}
 
//-----------------------------------------------------------------------
//min_y_in_xrange(x1,x2,p)
//sucht Paar (x,y) im Unterbaum von p
//mit folgender Eigenschaft :
// y = min { y ; es gibt x, so dass x1<=x<=x2 } , falls existiert,
//                                            0 , sonst.
 
pair_item ps_tree::min_y_in_xrange(x_typ x1,x_typ x2,ps_item p)
{
 pair_item c1,c2;

 if (p==0)
 {
  return 0;                                      // Baum ist leer.
 }
 else
 {
  c1 = new pair;
  c2 = new pair;
  c1->x_pkt=c1->y_pkt=c2->x_pkt=c2->y_pkt=0; 
  c1->valid=c2->valid=false;
  if (cmp(x1,p->x_value())<=0 && cmp(p->x_value(),x2)<=0)
  {
   c1->x_pkt=p->x_value();
   c1->y_pkt=p->y_value();
   c1->valid=true;
  }
  else if (!p->blatt())
  {
   if (cmp(x1,p->split_value_x())<=0) c1=min_y_in_xrange(x1,x2,p->sohn[left]);
   if (cmp(p->split_value_x(),x2)<0)  c2=min_y_in_xrange(x1,x2,p->sohn[right]);
   if (!c1->valid || (c2->valid && cmp(c2->y_pkt,c1->y_pkt)<0)) c1=c2;
  }
  return c1;
 } 
}
 
//-----------------------------------------------------------------------
// Funktion fuer Destruktor
//-----------------------------------------------------------------------
  
void ps_tree::deltree(ps_item p)
{
 if (p)
 {
  if (!p->blatt())
  {
   deltree(p->sohn[left]);
   deltree(p->sohn[right]);
  }
  delete(p);
 }
}
