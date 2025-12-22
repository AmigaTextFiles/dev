#include <proto/exec.h>
#include <proto/dos.h>

#include <nathread.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define SELF (long)FindTask(NULL)

static nathread_cond_t cond;
static nathread_mutex_t mutex;
static int werte[10];

static void *thread1 (void *arg) {
	int ret, i;

	printf("thread 1: %ld started ...\n", SELF);
	Delay(50);
	ret = nathread_mutex_lock (&mutex);
	if (ret != 0) {
		printf("errror locking thread: %ld\n", SELF);
		exit (EXIT_FAILURE);
	}

	for (i = 0; i < 10; i++)
		werte[i] = i;

	printf("thread 1: %ld sending signal for condition variable\n", SELF);
	nathread_cond_signal (&cond);
	ret = nathread_mutex_unlock (&mutex);
	if (ret != 0) {
		printf("error unlocking thread: %ld\n", SELF);
		exit (EXIT_FAILURE);
	}
	printf("thread 1: %ld done\n", SELF);
	nathread_thread_exit ((void *) 0);
	return NULL;
}

static void *thread2 (void *arg) {
	int ret, i;
	int summe = 0;

	ret = nathread_mutex_lock (&mutex);
	if (ret != 0) {
		printf("error locking thread:%ld\n", SELF);
		exit (EXIT_FAILURE);
	}

	printf("thread 2: %ld waiting for condition variable\n", SELF);
	nathread_cond_wait (&cond, &mutex);
	ret = nathread_mutex_unlock (&mutex);
	if (ret != 0) {
		printf("error unlocking thread: %ld\n", SELF);
		exit (EXIT_FAILURE);
	}
	printf("thread 2: %ld started...\n", SELF);
	for (i = 0; i < 10; i++)
		summe += werte[i];
	printf("thread 2: %ld done\n", SELF);
	printf("sum should be 45, sum is: %d\n", summe);
	nathread_thread_exit ((void *) 0);
	return NULL;
}

int main (void) {
	nathread_thread_t th[2];

	nathread_init();
	nathread_cond_init (&cond);
	nathread_mutex_init (&mutex);

	nathread_thread_inittaglist(&th[0],
		NATHREAD_ENTRY, (ULONG)thread1,
		NATHREAD_NAME, (ULONG)"test 1",
		TAG_DONE);
	nathread_thread_inittaglist(&th[1],
		NATHREAD_ENTRY, (ULONG)thread2,
		NATHREAD_NAME, (ULONG)"test 2",
		TAG_DONE);
	nathread_thread_join (th[0], NULL);
	nathread_thread_join (th[1], NULL);

	nathread_mutex_exit(&mutex);
	nathread_cond_exit(&cond);
	nathread_exit();
	return 0;
}

