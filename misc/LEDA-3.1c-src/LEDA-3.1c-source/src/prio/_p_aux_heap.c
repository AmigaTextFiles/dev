/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _p_aux_heap.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/impl/p_aux_heap.h>

static p_aux_heap const *class_ptr;

#define comparison_link(with_el,new_el)\
  if ((cmp(with_el->key,new_el->key)<0)||(with_el==minptr))\
   {  with_el->r_child=new_el->r_child;\
      if (with_el->r_child!=nil)\
              with_el->r_child->parent=with_el;\
      new_el->r_child=with_el->l_child;\
      if (new_el->r_child!=nil)\
              new_el->r_child->parent=new_el;\
      new_el->parent=with_el;  \
      with_el->l_child=new_el; }\
  else\
    { with_el->r_child=new_el->l_child;\
      if (with_el->r_child!=nil)\
              with_el->r_child->parent=with_el;\
      new_el->parent=with_el->parent;\
      if (new_el->parent!=nil)\
              new_el->parent->r_child=new_el; \
      new_el->l_child=with_el;\
      with_el->parent=new_el;\
      with_el = new_el; }

#define int_comparison_link(with_el,new_el)\
  if ((with_el->key < new_el->key)||(with_el==minptr))\
    { with_el->r_child=new_el->r_child;\
      if (with_el->r_child!=nil)\
              with_el->r_child->parent=with_el;\
      new_el->r_child=with_el->l_child;\
      if (new_el->r_child!=nil)\
              new_el->r_child->parent=new_el;\
      new_el->parent=with_el;  \
      with_el->l_child=new_el; }\
  else\
    { with_el->r_child=new_el->l_child;\
      if (with_el->r_child!=nil)\
              with_el->r_child->parent=with_el;\
      new_el->parent=with_el->parent;\
      if (new_el->parent!=nil)\
              new_el->parent->r_child=new_el; \
      new_el->l_child=with_el;\
      with_el->parent=new_el;\
      with_el = new_el; }


//&&&&&&&&&&&&&&&&  p_heap &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

//======= construct ===================================================

p_aux_heap::p_aux_heap()
{
	item_count=0;
}
	
//====== construct (p_aux_heap&) ===========================================

p_aux_heap::p_aux_heap(const p_aux_heap& with)
{
	
    item_count =0;
    if((this!=&with)&&(with.item_count>0)){
	class_ptr=&with;
	head=new ph_item(with.head->key,with.head->inf);
	class_ptr->copy_key(head->key);
	class_ptr->copy_inf(head->inf);
	item_count++;
	if (with.head->l_child!=nil)
  		do_copy(head,with.head->l_child,true);
	if (with.head->r_child!=nil)
		do_copy(head,with.head->r_child,false);
	class_ptr=this;
    }
}

//====== operator = =====================================================

p_aux_heap& p_aux_heap::operator=(const p_aux_heap& with)
{
      if(this!=&with){
	 if((with.item_count>0)&&(item_count>0))
		clear();
	class_ptr=&with;
	head=new ph_item(with.head->key,with.head->inf);
	class_ptr->copy_key(head->key);
	class_ptr->copy_inf(head->inf);
	item_count++;
	if (with.head->l_child!=nil)
  		do_copy(head,with.head->l_child,true);
	if (with.head->r_child!=nil)
		do_copy(head,with.head->r_child,false);
	class_ptr=this;
		
	}
    return(*this);
}

 

//====== do_copy ======================================================

void p_aux_heap::do_copy(ph_item* father,ph_item* from,bool direction)
{
// direction : false=right true=left

	
	ph_item* hilf=new ph_item(from->key,from->inf);
	class_ptr->copy_key(hilf->key);
	class_ptr->copy_inf(hilf->inf);
	if (class_ptr->minptr==from)
		minptr=hilf;
	item_count++;

	hilf->parent=father;
	if (direction)
		father->l_child=hilf;
	else
		father->r_child=hilf;

	if (from->l_child!=nil)
		do_copy(hilf,from->l_child,true);
		
	if (from->r_child!=nil)
		do_copy(hilf,from->r_child,false);
}
		




//======= insert =======================================================

ph_item* p_aux_heap::insert(GenPtr key,GenPtr inf)
{	
	ph_item* help;

	
	help = new ph_item(key,inf);
	copy_key(help->key);
	copy_inf(help->inf);

	if (item_count==0)	// very first element
	{
			
		item_count++;
		head=help;
		minptr=help;
		return head;
	}
		
	else{				// just another element
		
		item_count++;
		if(cmp(minptr->key,help->key)>=0)
			minptr=help;

		if (head->r_child==nil)
		{
			help->parent=head;
			head->r_child=help;
		}
		else
		{
			help->r_child=head->r_child;
			head->r_child->parent=help;	
			head->r_child=help;
			help->parent=head;
		}	// insert at the beginning of the r_child of head

		return help;
	}

	
}


// ====== decrease_key ==================================================

void p_aux_heap::decrease_key(ph_item* which,GenPtr key)
{
	
 
  if (cmp(key,which->key)<=0)   // smaler or equal compared to the old key
  {
	clear_key(which->key);	
	which->key=key;
	copy_key(which->key);
	if (cmp(which->key,minptr->key)<=0)
		minptr=which;
	if (which!=head)	// which is not already minimum
	{  
		if (which->parent->l_child==which){
			if (which->r_child!=nil){
				which->parent->l_child=which->r_child;
				which->r_child->parent=which->parent;
				which->r_child=nil;
			}
			else
				which->parent->l_child=nil;
		}
		else {
			if (which->r_child!=nil){
				which->parent->r_child=which->r_child;
				which->r_child->parent=which->parent;
				which->r_child=nil;
			}
			else
				which->parent->r_child=nil;
		}

				
		if (head->r_child==nil){
			head->r_child=which;
			which->parent=head;
		}
		else
		{
			which->r_child=head->r_child;
			head->r_child->parent=which;
			head->r_child=which;
			which->parent=head;
		    	
		}		
	}
	
  }
}

				
		
//========= delete_min_aux_multipass ()  (auxiliary multipass algorithm) =============

void p_aux_heap::delete_min_multipass()
{  
   ph_item *help;	
 
   if (head->r_child!=nil){
	if (head->r_child->r_child!=nil){
		help=head->r_child;
		help->parent=nil;
		help=multipass(help);
	}
      	comparison_link(head,help);	// vorher head = ...
	if (head->parent==help)
		head=help;
   }
	

   if (item_count==1)	// only one element in structure
   {
	clear_key(head->key);
	clear_inf(head->inf);
	delete head;
	item_count=0;
   }
   else
   {
     	head=head->l_child;
	clear_key(head->parent->key);
	clear_inf(head->parent->inf);
	delete head->parent;	// delete min
	head->parent=nil;
	item_count--;

 	
      if (head->r_child!=nil)	// there are two ore more consecutive elements
      	head=multipass(head);

  }// end else

minptr=head;


}

//======== delete_min_aux_twopass, (auxiliary twopass algorithm) =============

void p_aux_heap::delete_min_twopass()
{
  ph_item *help;	

   if (head->r_child!=nil){
	help=head->r_child;
	if (head->r_child->r_child!=nil){
		help->parent=nil;
		help=multipass(help);
	}
   	comparison_link(head,help);
   }

 	
  
   if (item_count==1)	// only one element in structure
   {
	clear_key(head->key);
	clear_inf(head->inf);
	delete head;
	item_count=0;
   }
   else
   {
     	head=head->l_child;
	clear_key(head->parent->key);
	clear_inf(head->parent->inf);
	delete head->parent;	// delete min
	head->parent=nil;
	item_count--;
	
      if (head->r_child!=nil)	// there are two ore more consecutive elements
      	head=twopass(head);

   } // end else

minptr=head;

}
		
// ============== twopass ================================================              
        
ph_item*  p_aux_heap::twopass(ph_item* head)
{
 //pass 1 : left to right comparison link (successive pairs of root nodes)

  register ph_item* help1,*help2;

  help1=head;
  help2=head->r_child;
  
  if (int_type())
        while (help2!=nil)               // there are 2 ore more elements left
        { head=help1->r_child->r_child;   // use of head as a helper
          int_comparison_link(help1,help2);
                
          if (head!=nil)       // first case comp _link
             if (head->r_child!=nil)
               { // second case
                 // now we have to more nodes to test
                 help2=head->r_child;
                 help1=head;
                }
             else
               help2=nil;
           else
             { head=help1;     // last element in list
               help2=nil;
              }
          }
   else
        while (help2!=nil)
        { head=help1->r_child->r_child;
          comparison_link(help1,help2);
                
          if (head!=nil)
             if (head->r_child!=nil)
               { help2=head->r_child;
                 help1=head;
                }
             else
               help2=nil;
           else
             { head=help1;
               help2=nil;
              }
         }

  //pass 2 : right to left comparison link (allways the two rightmost nodes)

        help1=head->parent;
        help2=head;

   if (int_type())
        while (help1!=nil)
        { int_comparison_link(help1,help2);
	  head=help1;
          help2=help1;
          help1=help1->parent;
         }
    else
        while (help1!=nil)
        { comparison_link(help1,help2);
	  head=help1;
          help2=help1;
          help1=help1->parent; 
	 }
        
 // head points now again to the very first element

 return(head);

}

// ================ multipass ==========================================

ph_item* p_aux_heap::multipass(ph_item* head)
{
          // now pass 1 (multi times) : left to right comparison link (successive pairs of root nodes)
       ph_item* save=head;      
       ph_item* help1,*help2;

       while(head->r_child!=nil)
       { save=head;
         help1=head;
         help2=head->r_child;
        
         while (help2!=nil)      // there are 2 ore more elements left
         { save=help1->r_child->r_child; // use of save as a helper
           comparison_link(help1,help2);
	   if (help1->parent==help2)
		help1=help2;
                
           if (save!=nil)       // first case comp _link
             if (save->r_child!=nil)
                { // second case
                  // now we have to more nodes to test
                  help2=save->r_child;
                  help1=save;
                 }
              else
                 help2=nil;
           else
              { save=help1;     // last element in list
                help2=nil;
               }
         } // end while (help2!=nil)


       	if (head->parent!=nil)      // may be first element is child (comp link)
     		head=head->parent;

    } // end while (repeat pass 1)

  return(head);
}
