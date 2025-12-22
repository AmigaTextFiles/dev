
#include <thread.h>



APTR ThreadBase;
LONG a;
APTR mutex;



VOID thread( VOID );



int main()
{
	LONG help;
	APTR mythread;

	help = 0xBADC0DE;
	a = 0;
	if ( ThreadBase = (APTR) OpenLibrary( "thread.library", 0 ) )
	{
		printf( "Main process...\n" );

		mutex = (APTR) TLMutexInit();
		TLMutexLock( mutex );
		printf( "Mutex locked...\n" );

		mythread = (APTR) TLCreate( (APTR) &thread, 0 );

		printf( "I'm waiting for thread message...\n" );
		Delay( 50 );
		printf( "Unlocking mutex...\n" );
		TLMutexUnlock( mutex );
		Delay( 50 );
		printf( "Trying to kill thread..." );
		if ( TLCancel( mythread ) )
		{
			printf( "Done\n" );
			TLMutexDestroy( mutex );
			return 0;
		}
		else
		{
			printf( "Nothing\n" );
		}
		Delay( 500 );

		printf( "thread code is: %d\n", &thread );


		TLJoin( mythread );

		TLMutexDestroy( mutex );

		CloseLibrary( ThreadBase );
	}
}





void thread()
{
	printf( "Thread process...\n" );
	Delay( 10 );
	if ( ! TLMutexTryLock( mutex ) )
	{
		printf( "Unable to lock mutex...\n" );
		TLMutexLock( mutex );
	}
	else
	{
		printf( "Mutex locked...\n" );
	}
	TLSetCancel( TL_FALSE );
	TLMutexUnlock( mutex );
	Delay( 100 );
	printf( "Thread exiting...\n" );

	TLExit( 0 );
}
