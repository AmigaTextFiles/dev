#ifndef SYS_KERNEL_H
#define SYS_KERNEL_H
/* Aargh! The bastard defined lower case stuff.  Gotta replace all
   the kernel references to upper case defines now.*/
#define HZ   (50)		/* computational clock frequency */
#define TICK (1000000/HZ)	/* microseconds / hz */


#endif /* !SYS_KERNEL_H */
