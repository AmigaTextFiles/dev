// messages.h: for messages printing

#ifndef _MESSAGES_H
#define _MESSAGES_H

#include <iostream.h>

class Messages {
 public:
  virtual void printMessage( char *s, ostream & stream = cerr ) = 0 ;
  virtual void printWarning( char *s, ostream & stream = cerr ) = 0 ;
  virtual void printError( char *s, ostream & stream = cerr ) = 0 ;
} ;

class DefaultMessages : public Messages {
 protected:
  virtual void _print( char *s, ostream &stream ) 
    { stream << s << endl ; }

 public:
  virtual void printMessage( char *s, ostream &stream )
    { _print(s,stream); }
  virtual void printWarning( char *s, ostream &stream ) 
    { _print(s,stream); }
  virtual void printError( char *s, ostream &stream ) 
    { _print(s,stream); }
} ;

// prefer functions? ;-)
void printMessage( char *s, ostream &stream = cerr ) ;
void printWarning( char *s, ostream &stream = cerr ) ;
void printError( char *s, ostream &stream = cerr ) ;

void setMessager( Messages *m ) ;

#endif // _MESSAGES_H
