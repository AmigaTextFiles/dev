/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  x_window.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_X_WINDOW_H
#define LEDA_X_WINDOW_H

typedef unsigned long Window;


enum { key_press_event, key_release_event, 
       button_press_event, button_release_event,
       configure_event, motion_event, destroy_event, no_event };

enum {
  white  =  0,
  black  =  1,
  red    =  2,
  green  =  3,
  blue   =  4,
  yellow =  5,
  violet =  6,
  orange =  7,
  cyan   =  8,
  brown  =  9,
  pink   = 10,
  green2 = 11,
  blue2  = 12,
  grey1  = 13,
  grey2  = 14,
  grey3  = 15 
};

enum line_style   {solid, dashed, dotted};
enum text_mode    {transparent, opaque};
enum drawing_mode {src_mode, xor_mode};


#endif
