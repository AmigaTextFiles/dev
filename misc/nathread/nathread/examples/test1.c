#include <nathread.h>
#include <stdlib.h>
#include <stdio.h>

#define NUM_THREADS	 3
#define TCOUNT 10
#define COUNT_LIMIT 12

int count = 0;
int thread_ids[3] = {0,1,2};
nathread_mutex_t count_mutex;
nathread_cond_t count_threshold_cv;

void *inc_count(void *idp)
{
	int j,i;
	double result=0.0;
	int *my_id = idp;

	for (i=0; i<TCOUNT; i++) {
		nathread_mutex_lock(&count_mutex);
		count++;

		if (count == COUNT_LIMIT) {
			printf("inc_count(): thread %d, count = %d, threshold reached. ->signal!\n", *my_id, count);
			nathread_cond_signal(&count_threshold_cv);
		}
		printf("inc_count(): thread %d, count = %d, unlocking mutex\n", *my_id, count);
		nathread_mutex_unlock(&count_mutex);

		for (j=0; j<1000000; j++)
			result = result + (double)rand();
	}
	nathread_thread_exit(NULL);
	return NULL;
}

void *watch_count(void *idp)
{
	int *my_id = idp;

	printf("starting watch_count(): thread %d\n", *my_id);

	nathread_mutex_lock(&count_mutex);
	if (count < COUNT_LIMIT) {
		printf("watch_count(): thread %d goto wait....\n", *my_id);
		nathread_cond_wait(&count_threshold_cv, &count_mutex);
		printf("watch_count(): thread %d condition signal received.\n", *my_id);
	}
	nathread_mutex_unlock(&count_mutex);
	nathread_thread_exit(NULL);
	return NULL;
}

int main(int argc, char *argv[])
{
	int i;
	nathread_thread_t threads[3];

	nathread_init();

	nathread_mutex_init(&count_mutex);
	nathread_cond_init(&count_threshold_cv);

	nathread_thread_inittaglist(&threads[0],
		NATHREAD_ENTRY, (ULONG)inc_count,
		NATHREAD_NAME, (ULONG)"inc 1",
		NATHREAD_DATA, (ULONG)&thread_ids[0],
		TAG_DONE);
	nathread_thread_inittaglist(&threads[1],
		NATHREAD_ENTRY, (ULONG)inc_count,
		NATHREAD_NAME, (ULONG)"inc 2",
		NATHREAD_DATA, (ULONG)&thread_ids[1],
		TAG_DONE);
	nathread_thread_inittaglist(&threads[2],
		NATHREAD_ENTRY, (ULONG)watch_count,
		NATHREAD_NAME, (ULONG)"watch",
		NATHREAD_DATA, (ULONG)&thread_ids[2],
		TAG_DONE);

	for (i=0; i<NUM_THREADS; i++) {
		nathread_thread_join(threads[i], NULL);
	}
	printf("main(): waited on %d   threads. done.\n", NUM_THREADS);

	nathread_mutex_exit(&count_mutex);
	nathread_cond_exit(&count_threshold_cv);
	nathread_exit();
	return 0;
}


