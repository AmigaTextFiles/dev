
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/misc.h>
#include <proto/io.h>
#include <stdio.h>


struct Library *IOBase;


extern struct Custom __far custom;
extern struct CIA    __far ciaa, ciab;

int res,val,val2,a,b,c,d;
long delayint, delayint2;


UBYTE prova,testo;

WORD txt;

int main( int argc, char *argv[] )
{

	val = 1;


	val2 = 4;

	delayint = 1;
	delayint2 = 1;

	IOBase = OpenLibrary("io.library",0);

	if(IOBase)
	{


		io_SetParDir(0xFF);

		io_SetExtParDir(0xFF);

		io_ResetPar();

		io_ResetExtPar();

		if((strstr(argv[1],"G1")) != NULL)
		{
			for(a = 0; a <= 10 ; a++)
			{

			io_WriteParA(0,1);Delay(delayint);
			io_WriteParA(1,1);Delay(delayint);
			io_WriteParA(0,0);Delay(delayint);
			io_WriteParA(2,1);Delay(delayint);
			io_WriteParA(1,0);Delay(delayint);
			io_WriteParA(3,1);Delay(delayint);
			io_WriteParA(2,0);Delay(delayint);
			io_WriteParA(4,1);Delay(delayint);
			io_WriteParA(3,0);Delay(delayint);
			io_WriteParA(5,1);Delay(delayint);
			io_WriteParA(4,0);Delay(delayint);
			io_WriteParA(6,1);Delay(delayint);
			io_WriteParA(5,0);Delay(delayint);
			io_WriteParA(7,1);Delay(delayint);
			io_WriteParA(6,0);Delay(delayint);
			io_WriteExtParA(0,1);Delay(delayint);
			io_WriteParA(7,0);Delay(delayint);
			io_WriteExtParA(1,1);Delay(delayint);
			io_WriteExtParA(0,0);Delay(delayint);
			io_WriteExtParA(2,1);Delay(delayint);
			io_WriteExtParA(1,0);Delay(delayint);
			io_WriteExtParA(2,0);Delay(delayint);
		
			}
		}

		if((strstr(argv[1],"G2")) != NULL)
		{
			for(a = 0; a <= 10 ; a++)
			{
				io_WriteParA(0,0);
				io_WriteParA(2,0);
				io_WriteParA(4,0);
				io_WriteParA(6,0);
				io_WriteExtParA(0,0);	
				io_WriteExtParA(2,0);

				io_WriteParA(1,1);
				io_WriteParA(3,1);
				io_WriteParA(5,1);
				io_WriteParA(7,1);
				io_WriteExtParA(1,1);	

				Delay(15);
			
				io_WriteParA(0,1);
				io_WriteParA(2,1);
				io_WriteParA(4,1);
				io_WriteParA(6,1);
				io_WriteExtParA(0,1);	
				io_WriteExtParA(2,1);

				
				io_WriteParA(1,0);
				io_WriteParA(3,0);
				io_WriteParA(5,0);
				io_WriteParA(7,0);
				io_WriteExtParA(1,0);


				Delay(15);

			}

				io_WriteParA(0,0);
				io_WriteParA(2,0);
				io_WriteParA(4,0);
				io_WriteParA(6,0);
				io_WriteExtParA(0,0);	
				io_WriteExtParA(2,0);
			

		}	

		if((strstr(argv[1],"G3")) != NULL)
		{
			for(a = 0; a <= 10 ; a++)
			{
		
			io_WriteParA(0,1);Delay(delayint2);
			io_WriteParA(0,0);
			io_WriteParA(1,1);Delay(delayint2);
			io_WriteParA(1,0);
			io_WriteParA(2,1);Delay(delayint2);
			io_WriteParA(2,0);
			io_WriteParA(3,1);Delay(delayint2);
			io_WriteParA(3,0);			
			io_WriteParA(4,1);Delay(delayint2);
			io_WriteParA(4,0);
			io_WriteParA(5,1);Delay(delayint2);
			io_WriteParA(5,0);			
			io_WriteParA(6,1);Delay(delayint2);
			io_WriteParA(6,0);
			io_WriteParA(7,1);Delay(delayint2);
			io_WriteParA(7,0);
			io_WriteExtParA(0,1);Delay(delayint2);
			io_WriteExtParA(0,0);
			io_WriteExtParA(1,1);Delay(delayint2);
			io_WriteExtParA(1,0);
			io_WriteExtParA(2,1);Delay(delayint2);
			io_WriteExtParA(2,0);	
			io_WriteExtParA(1,1);Delay(delayint2);
			io_WriteExtParA(1,0);
			io_WriteExtParA(0,1);Delay(delayint2);
			io_WriteExtParA(0,0);		
			io_WriteParA(6,1);Delay(delayint2);
			io_WriteParA(6,0);
			io_WriteParA(5,1);Delay(delayint2);
			io_WriteParA(5,0);			
			io_WriteParA(4,1);Delay(delayint2);
			io_WriteParA(4,0);
			io_WriteParA(3,1);Delay(delayint2);
			io_WriteParA(3,0);			
			io_WriteParA(2,1);Delay(delayint2);
			io_WriteParA(2,0);			
			io_WriteParA(1,1);Delay(delayint2);
			io_WriteParA(1,0);
			io_WriteParA(0,1);Delay(delayint2);
			io_WriteParA(0,0);			

			}
		}

		if((strstr(argv[1],"G4")) != NULL)
		{

			io_WriteParA(0,0);

			b = io_ReadParA(0);

			printf("Stato: %d\n",b);
			
			Delay(50);

			io_WriteParA(0,1);

			b = io_ReadParA(0);

			printf("Stato: %d\n",b);

		

		}

		if((strstr(argv[1],"G5")) != NULL)
		{
			b=0;
			
			PutStr("Wait 1 secs\n");

			Delay(50);


			b = io_AllocParPort();	

			printf("Ret: %d\n",b);

			Delay(50);

			io_FreeParPort();

		}

		if((strstr(argv[1],"G6")) != NULL)
		{
	
			io_WriteLed(0);

			Delay(50);

			io_WriteLed(1);

		}	

		if((strstr(argv[1],"SER")) != NULL)
		{

			io_SetSerBaud(300,0,1);

			io_WriteSer("A");
		
		} 

		if((strstr(argv[1],"SER2")) != NULL)
		{

			io_SetSerBaud(19200,0,0);

			io_WriteSer("AT\n");
		
		} 

		if((strstr(argv[1],"SER3")) != NULL)
		{
	
			io_SetSerBaud(19200,0,0);

			for(c = 0; c <= 200; c++)

			{

				testo = io_ReadSer();

				PutStr(testo);

			}		
		}

		if((strstr(argv[1],"JOY1")) != NULL)
		{

			int a,b;

			io_SetJoy1DirA(2,0);
			io_SetJoy1DirA(0,0);

			a = b = 0;
			

			b = io_ReadJoy1A(0);

			a = io_ReadJoy1A(2);



			printf("Fire1 = %d\n", a );
			printf("Fire2 = %d\n", b );



		}	

		CloseLibrary(IOBase);

	}


	return(0);

}



