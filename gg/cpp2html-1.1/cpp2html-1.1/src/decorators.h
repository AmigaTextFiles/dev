/*
 * Copyright (C) 1999, 2000  Lorenzo Bettini, lorenzo.bettini@penteres.it
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */

// decorators for html

#ifndef _DECORATOR_H
#define _DECORATOR_H

#include "textgen.h"
#include "tags.h"
#include "colors.h"

class TagDecorator : public TextDecorator {
  protected :
    char *tag ;
    char *attr ;
    char *val ;

  public :
    TagDecorator( TextGenerator *t, char *ta, char *a = NULL, char *v = NULL )
    : TextDecorator( t ), tag(ta), attr(a), val(v) {}
  
  virtual void startDecorate() const { startTAG( tag, attr, val ) ; }
  
  virtual void endDecorate() const { endTAG( tag ) ; }

  protected :
    void startTAG( char *tag, char *attr, char *val ) const {
      (*sout) << "<" << tag ;
      if ( attr && val )
	(*sout) << " " << attr << "=" << val ;
      (*sout) << ">" ;
    }

    void endTAG( char *tag ) const {
      (*sout) << "</" << tag << ">" ;
    }
} ;

class ColorDecorator : public TagDecorator {
  public :
    ColorDecorator( TextGenerator *t, char *color ) :
      TagDecorator( t, FONT_TAG, COLOR_TAG, color ) {}
} ;

class SpanDecorator : public TextDecorator {
  protected :
    char *span ;

  public :
    SpanDecorator( TextGenerator *t, char *ta)
    : TextDecorator( t ), span(ta) {}

  virtual void startDecorate() const { startTAG( span ) ; }

  virtual void endDecorate() const { endTAG( ) ; }

  protected :
    void startTAG( char *span ) const {
      (*sout) << "<span class=\"" << span << "\">" ;
    }

    void endTAG( ) const {
      (*sout) << "</span>" ;
    }
} ;

#endif
