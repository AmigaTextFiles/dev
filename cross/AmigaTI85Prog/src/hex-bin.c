/* 
 * Hex-bin.c - converts intel hex records to binary files 
 * I found this on the net somewhere with no notices and assume it is 
 * public domain.  If not please let me know.
 *
 * I improved it by adding the ch-toupper(ch) as otherwise it doesn't 
 * work if your assembler generates hex records with lower case letters
 * (mine does)
 */

#include <stdio.h>

int aton(unsigned char);
main()
{
  unsigned char fnami[14],fnamo[14],ch,ch1,ch2,a1,a2,a3,a4;
  int count=0,u,t;
  
  while(1)
    {
      while(fgetc(stdin)!=':');
      if((t=16*aton(fgetc(stdin))+aton(fgetc(stdin)))==0)
	{
	  fclose(stdin);
	  fclose(stdout);
	  exit(0);
	}
      u=16*16*16*aton(fgetc(stdin))+16*16*aton(fgetc(stdin))+16*aton(fgetc(stdin))+aton(fgetc(stdin));
      fgetc(stdin);
      fgetc(stdin);
      while(u>count)
        {
	  fputc(0,stdout);
	  count++;
        }
      while(t>0)
	{
	  char ch;
	  ch=16*aton(fgetc(stdin))+aton(fgetc(stdin));
	  fputc(ch,stdout);
	  t--;
	  count++;
        }
    }
  
}

int aton(ch)
     unsigned char ch;
{
  int n;
  ch=toupper(ch);
  if(ch<0x3A)n=ch-0x30;
  else n=ch-0x37;
  return n;
}


