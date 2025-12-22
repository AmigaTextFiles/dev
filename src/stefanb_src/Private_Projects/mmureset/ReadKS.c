#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
 int fd;
 void (*f)(void)= (void *) 0x7fff008;

 if (argc<2) {
  fprintf(stderr,"wrong args!\n");
  exit(20);
 }

 if (!(fd=open(argv[1],O_RDONLY))) {
  fprintf(stderr,"no file!\n");
  exit(20);
 }

 if (read(fd,(char *) 0x7f80000,0x80000)<0x80000) {
  fprintf(stderr,"read error!\n");
  close(fd);
  exit(20);
 }

 read(fd,(char *) 0x7fff000,0xA00);

 (*f)();

 return(0);
}

