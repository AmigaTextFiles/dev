/*
** Copyright (C) 1999, 2000, Lorenzo Bettini <lorenzo.bettini@penteres.it>
**  
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**  
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**  
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
**  
*/

// generators.cc

// generators and decorators

#include "textgen.h"
#include "decorators.h"
#include "tags.h"
#include "keys.h"

#define GET_DECORATED( d ) ( d ? d : GlobalGenerator )

TextGenerator *GlobalGenerator ;
TextGenerator *KeywordGenerator ;
TextGenerator *CommentGenerator ;
TextGenerator *StringGenerator ;
TextGenerator *TypeGenerator ;
TextGenerator *NumberGenerator ;

static TextGenerator *createGenerator( char *key ) ;

void createGenerators()
{
  GlobalGenerator = new TextGenerator ;
  KeywordGenerator = createGenerator( KEYWORD ) ;
  CommentGenerator = createGenerator( COMMENT ) ;
  StringGenerator = createGenerator( STRING ) ;
  TypeGenerator = createGenerator( TYPE ) ;
  NumberGenerator = createGenerator( NUMBER ) ;
}

void createGeneratorsForCSS()
{
  GlobalGenerator = new TextGenerator ;
  KeywordGenerator = new SpanDecorator(GlobalGenerator, KEYWORD) ;
  CommentGenerator = new SpanDecorator(GlobalGenerator, COMMENT) ;
  StringGenerator = new SpanDecorator(GlobalGenerator, STRING) ;
  TypeGenerator = new SpanDecorator(GlobalGenerator, TYPE) ;
  NumberGenerator = new SpanDecorator(GlobalGenerator, NUMBER) ;
}

TextGenerator *createGenerator( char *key )
{
  Tag *tag = getTag( key ) ;
  TextDecorator *dec = NULL ;

  if ( ! tag ) // no options
    return GlobalGenerator ;

  char * color = tag->GetColor() ;
  if ( color )
    dec = new ColorDecorator( GlobalGenerator, color ) ;

  if ( tag->IsBold() )
    dec = new TagDecorator( GET_DECORATED( dec ), BOLD_TAG ) ;
  if ( tag->IsItalic() )
    dec = new TagDecorator( GET_DECORATED( dec ), ITALIC_TAG ) ;
  if ( tag->IsUnderline() )
    dec = new TagDecorator( GET_DECORATED( dec ), UNDERLINE_TAG ) ;

  return GET_DECORATED( dec ) ;
  // There should be some options, but it's not ncessary ...
  // so this is just to be safe
}
