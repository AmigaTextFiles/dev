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


// tags.cc

#include "tags.h"
#include "colors.h"
#include "keys.h"

Tags *GlobalTags = NULL ;

void setTags( Tags *t ) {
  GlobalTags = t ;
}

Tag *getTag( char *name ) {
  if ( ! GlobalTags )
    createDefaultTags() ;
  return GlobalTags->GetTag( name ) ;
}

void Tag::Print() {
  cerr << TagName << " " << color << " " << flags << endl ;
}

void createDefaultTags() {
  GlobalTags = new Tags ;

  GlobalTags->AddTag( newDefaultTag( KEYWORD, KEYWORD_C ) ) ;
  GlobalTags->AddTag( newDefaultTag( COMMENT, COMMENT_C ) ) ;
  GlobalTags->AddTag( newDefaultTag( STRING, STRING_C ) ) ;
  GlobalTags->AddTag( newDefaultTag( TYPE, BASETYPE_C ) ) ;
  GlobalTags->AddTag( newDefaultTag( NUMBER, NUMBER_C ) ) ;
}

Tag *newDefaultTag( char *tag, char *color ) {
  Tag *tempTag = new Tag( tag ) ;
  tempTag->SetColor( color ) ;

  return tempTag ;
}
