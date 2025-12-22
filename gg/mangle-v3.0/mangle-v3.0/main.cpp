/*
 * mangle.cpp - Removes ALL comments and/or formatting from C/C++ code while
 *              keeping what is needed so that the program still operates
 *              the same exact way as before the conversion.
 *
 * This program has been vigourously tested, if you find any logic errors
 * where something should have been taken out that wasn't, please email me
 * - jnewman@oplnk.net
 *
 */

#include "main.h"
#include "dformat.h"
#define MSG_PRE "main()"

int main(int argc, char** argv)
{
  dformat dformat(argc,argv);

  if(!dformat.ok())
  {
#ifdef DEBUG
    cerr << "main() - dformat not ok." << endl;
#endif
    return 1;
  }

  while(dformat.next())
  {
    dformat.format();
    dformat.done();
  }

  if(!dformat.ok())
  {
    cerr << MSG_PRE << " Errors occured while trying to complete requests."
	 << endl;
  }

  return 0;
}
