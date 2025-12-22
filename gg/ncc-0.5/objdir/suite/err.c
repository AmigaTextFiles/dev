

extern (*__errno_location ());

int main ()
{
	int *p;
	foo ((char*)p);
	return 0;
}

