/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _panel.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/window.h>


//------------------------------------------------------------------------------
//   PANELS
//------------------------------------------------------------------------------

void  panel::display(window& W) { display(W,-1,-1); }

void  panel::display(window& W, int x, int y)
{ LEDA_PANEL::display(x,y, W.xpos(), W.ypos(), W.width(), W.height()); }

void panel::display() { display(-1,-1); }

void panel::display(int x, int y)
{ LEDA_PANEL::display(x,y,0,0,0,0); }


int  panel::open(window& W) { return open(W,-1,-1); }

int  panel::open(window& W, int x, int y)
{ return LEDA_PANEL::open(x,y, W.xpos(), W.ypos(), W.width(), W.height()); }

int  panel::open() { return open(-1,-1); }

int  panel::open(int x, int y)
{ return LEDA_PANEL::open(x,y,0,0,0,0); }




void panel::text_item(string s)   
{ LEDA_PANEL::text_item(s); }

void panel::int_item(string s,int& x) 
{ LEDA_PANEL::int_item(s,&x);}

void panel::int_item(string s,int& x, int l, int h) 
{ LEDA_PANEL::slider_item(s,&x,l,h);}

void panel::double_item(string s, double& x) 
{ LEDA_PANEL::float_item(s,&x);}

void panel::real_item(string s, double& x)
{ LEDA_PANEL::float_item(s,&x); }

void panel::string_item(string label, string& x)
{ x = ~x; //disconnect
  LEDA_PANEL::string_item(label,x.access_ptr());
 }

void  panel::string_item(string label,string& x,list<string>& L)
{ x = x.cstring(); //disconnect
  const char** p = new const char*[L.length()];
  int    i = 0;
  string s;
  forall(s,L) 
     if (s.length() > 0) p[i++] = s;
  LEDA_PANEL::string_menu_item(label,x.access_ptr(),"",i,p); 
  delete p;
}


void  panel::choice_item(string label,int& x,list<string>& L)
{ const char** p = new const char*[L.length()];
  int    i = 0;
  string s;
  forall(s,L) p[i++] = s;
  LEDA_PANEL::choice_item(label,&x,i,p,1,0); 
  delete p;
}

void  panel::choice_item(string header,int& x,string s1, string s2)
{ const char* p[2];
  p[0] = s1;
  p[1] = s2;
  LEDA_PANEL::choice_item(header,&x,2,p,1,0);
 }

void  panel::choice_item(string header,int& x,string s1, string s2, string s3)
{ const char* p[3];
  p[0] = s1;
  p[1] = s2;
  p[2] = s3;
  LEDA_PANEL::choice_item(header,&x,3,p,1,0);
 }

void  panel::choice_item(string header,int& x,string s1, string s2, string s3, string s4)
{ const char* p[4];
  p[0] = s1;
  p[1] = s2;
  p[2] = s3;
  p[3] = s4;
  LEDA_PANEL::choice_item(header,&x,4,p,1,0);
 }

void  panel::choice_item(string header,int& x,string s1, string s2, string s3, string s4, string s5)
{ const char* p[5];
  p[0] = s1;
  p[1] = s2;
  p[2] = s3;
  p[3] = s4;
  p[4] = s5;
  LEDA_PANEL::choice_item(header,&x,5,p,1,0);
 }


void panel::int_item(string s,int& x,int low, int high, int step)   
{ int n = (high-low)/step +1;
  char** p = new char*[n];
  for(int i = 0; i < n; i++) p[i] = ~string("%d",low+i*step);
  LEDA_PANEL::choice_item(s,&x,n,(const char**)p,step,low);
  for(i = 0; i < n; i++) delete p[i];
  delete p;
 }

void panel::bool_item(string s, bool& x)
{ LEDA_PANEL::bool_item(s,(char*)&x); }


void panel::color_item(string s, color& x)
{
  const char* p[8];
  int n = 8;

  p[0] = "white";
  p[1] = "black";
  p[2] = "red";
  p[3] = "green";
  p[4] = "blue";
  p[5] = "yellow";
  p[6] = "violet";
  p[7] = "orange";

  if (window::screen_depth()==1) 
  { n = 2;
    if (x!=white) x = black;
   }

  LEDA_PANEL::choice_item(s,(int*)&x,n,p,1,0);

 }

void panel::lstyle_item(string s, line_style& x)
{ const char* p[3];

  p[0] = "solid";
  p[1] = "dashed";
  p[2] = "dotted";

  LEDA_PANEL::choice_item(s,(int*)&x,3,p,1,0);
 }


// buttons:

int panel::button(string s)             
{ return LEDA_PANEL::button(s); }


void panel::new_button_line()            
{ LEDA_PANEL::button_line(0,0);  }

void panel::new_button_line(list<string>& L)
{ const char** p = new const char*[L.length()];
  int i=0;
  string s;
  forall(s,L) p[i++] = s;
  LEDA_PANEL::button_line(i,p);
  delete p;
 }
