/* 
 * Amiga - buggy fork() replacement for use with
 * some test programs in 'gnutls'.
 * PLEASE NOTE THAT THIS DOESNT ACTUALLY WORK, I MEAN THREADING WORKS
 * EXCELLENT BUT NOT THE 'server()' IN ONE OF THEM - IT WAS AN ATTEMPT!
*/


#include <pthread.h>

typedef struct {
	int id;
} parm;


void
doit (void)
{
	int status;
	int n,i;
	pthread_t *threads;
	pthread_attr_t pthread_custom_attr;
	parm *p;

  server_start ();
  if (error_count)
    return;

	threads=(pthread_t *)malloc(n*sizeof(*threads));
	pthread_attr_init(&pthread_custom_attr);
	p=(parm *)malloc(sizeof(parm)*n);

	printf("server initialized.\n");

  i=0;
  p[i].id=i;
  pthread_create(&threads[i], &pthread_custom_attr, server, (void *)(p+i));

	sleep(2); /* pseudo sync */

  i=1;
  p[i].id=i;
  pthread_create(&threads[i], &pthread_custom_attr, client, (void *)(p+i));

	printf("joining threads...\n");

	pthread_join(threads[1],NULL);
	pthread_join(threads[0],NULL);

	wait (&status);
	free(p);
}
