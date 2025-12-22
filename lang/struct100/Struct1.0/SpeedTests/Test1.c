;/* Execute me to compile.  Run time: aprox. 13 seconds.
sc NOSTKCHK NOSTDIO Test1.c
slink Test1.o to Test1
quit
*/

void __saveds main()
{
  long z, a = 0;

  for(z = 1;z < 16000000;z++)
  {
    a += 7;
  }
}
