/* NOTE: A m2_main.o file in your working directory will be linked */
/*  instead of the one in mlib: (this one).			   */

extern int MAIN_BEGIN( ) ; /* Modula-2 main module entry point */

char wbStarted ; /* boolean (0,1) */
int argc ;
char **argv ;

int main( int ac, char**av )
{
  wbStarted = 0 ;
  argc = ac ; argv = av ;
  return( MAIN_BEGIN( ) ) ;
}

int wbmain( void *msg ) /* Workbench startup entry point */
{
  wbStarted = 1 ;
  return( MAIN_BEGIN( ) ) ;
}

