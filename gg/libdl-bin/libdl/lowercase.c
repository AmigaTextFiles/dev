/********************************************/
/*     Function to print input string as lower case.      */
/*     Returns 2.                                                      */
/******************************************* */
int printLowercase( inLine )
char inLine[];
{
   char lowstring[256];
   char *inptr, *outptr;
   inptr = inLine;
   outptr = lowstring;
   while ( *inptr != '' )
      *outptr++ = tolower(*inptr++);
  *outptr++ = '';
   printf(lowstring);
   return(2);
}
