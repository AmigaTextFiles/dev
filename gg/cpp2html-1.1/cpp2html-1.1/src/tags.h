#ifndef TAGS_H
#define TAGS_H

#define QUOTATION_MARK "&quot;"
#define LESS_THAN "&lt;"
#define GREATER_THAN "&gt;"
#define AMPERSAND "&amp;"
#define NEWLINE "<br>"
#define SPACE_CHAR " "

#define FONT_TAG "font"
#define COLOR_TAG "color"
#define BOLD_TAG "b"
#define ITALIC_TAG "i"
#define UNDERLINE_TAG "u"

#define ISBOLD 0x1
#define ISITALIC 0x2
#define ISUNDERLINE 0x4

#include "list.h"
#include "colors.h"

#include <iostream.h>

class Tag {
 protected:
  char *TagName ;
  char *color ;
  int flags ;

 public:
  Tag( char *n ) : TagName( n ), color( 0 ), flags( 0 ) {}
  Tag( char *n, char *c ) : TagName( n ), flags( 0 ) {
    if ( strcmp( c, GREEN ) == 0 )
      color = GREEN_C ;
    else if ( strcmp( c, RED ) == 0 )
      color = RED_C ;
    else if ( strcmp( c, DARKRED ) == 0 )
      color = DARKRED_C ;
    else if ( strcmp( c, BLUE ) == 0 )
      color = BLUE_C ;
    else if ( strcmp( c, BROWN ) == 0 )
      color = BROWN_C ;
    else if ( strcmp( c, PINK ) == 0 )
      color = PINK_C ;
    else if ( strcmp( c, YELLOW ) == 0 )
      color = YELLOW_C ;
    else if ( strcmp( c, CYAN ) == 0 )
      color = CYAN_C ;
    else if ( strcmp( c, PURPLE ) == 0 )
      color = PURPLE_C ;
    else if ( strcmp( c, ORANGE ) == 0 )
      color = ORANGE_C ;
    else if ( strcmp( c, BRIGHTORANGE ) == 0 )
      color = BRIGHTORANGE_C ;
    else if ( strcmp( c, BRIGHTGREEN ) == 0 )
      color = BRIGHTGREEN_C ;
    else if ( strcmp( c, BLACK ) == 0 )
      color = BLACK_C ;
    else
      color = NULL ;
  }

  void SetFlags( int f ) { flags = f ; }

  char *GetName() { return TagName ; }
  char *GetColor() { return color ; }
  void SetColor( char *col ) { color = col ; }

  int IsBold() { return ( flags & ISBOLD ) ; }
  int IsItalic() { return ( flags & ISITALIC ) ; }
  int IsUnderline() { return ( flags & ISUNDERLINE ) ; }

  void Print() ;
} ;

class Tags {
 protected:
  List<Tag *> tagsList ;

 public:
  Tags() {}
  void AddTag( Tag *t ) { tagsList.Add( t ) ;  }
  Tag *GetTag( char *name ) ;
} ;

inline Tag * Tags::GetTag( char *name ) {
  if ( tagsList.Empty() )
    return NULL ;
  ListNode<Tag *> *tag = tagsList.First() ;
  while ( tag ) {
    if ( strcmp( tag->Elem()->GetName(), name ) == 0 )
      return tag->Elem() ;
    tag = tag->Next() ;
  }
  return NULL ;
}

void setTags( Tags *t ) ;
Tag *getTag( char *name ) ;
void createDefaultTags() ;
Tag *newDefaultTag( char *tag, char *color ) ;

#endif
