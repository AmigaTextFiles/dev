


int main (int argc, char *argv[])
{

	union
		{
			struct test
				{
					int a:4;
					int b:6;
					int c:1;
					int d:21;
				} tt;
			int ll;
		} proef;


	proef.tt.a=3;
	proef.tt.b=2;
	proef.tt.c=1;
	proef.tt.d=1024;
	printf ("%ld\n",proef.ll);
}
