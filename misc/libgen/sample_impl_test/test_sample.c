#include <proto/exec.h>
#include <proto/sample.h>
#include <stdio.h>

int main (int argc, char *argv [])
{
	int res = 0;
	struct Library *SampleBase = (struct Library *) IExec->OpenLibrary ("sample.library", 0);

	if (SampleBase)
		{
			struct SampleIFace *ISample = (struct SampleIFace *) IExec->GetInterface (SampleBase, "main", 1, NULL);

			if (ISample)
				{
					int a = 6;
					int	b = 4;
					
					int result = ISample->Addition (a, b);
					double d;

					printf ("Addition: %ld + %ld = %ld\n", a, b, result);

					result = ISample->Subtract (a, b);
					printf ("Subtract: %ld - %ld = %ld\n", a, b, result);

					result = ISample->Multiply (a, b);
					printf ("Multiply: %ld * %ld = %ld\n", a, b, result);

					d	= ISample->Divide (a, b);
					printf ("Divide: %ld / %ld = %lf\n", a, b, d);

					result = ISample->Modulus (a, b);
					printf ("Modulus: %ld %% %ld = %ld\n", a, b, result);

					IExec->DropInterface ((struct Interface *) ISample);
				}
			else
				{
					printf ("failed  to open sample.library main interface\n");
					res = -2;
				}


			IExec->CloseLibrary (SampleBase);
		}
	else
		{
			printf ("Failed to open sample.library\n");
			res = -1;
		}

	return res;
}
