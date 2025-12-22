

int DSP_do_add (int a, int b) 
{
	return a+b;
}


int DSP_do_sub (int a, int b) 
{
	return a-b;
}

int DSP_do_mul (int a, int b) 
{
	return a*b;
}

int DSP_do_div (int a, int b) 
{
	return a/b;
}

int DSP_do_mod (int a, int b) 
{
	return a%b;
}

int DSP_do_ashr (int a, int b)
{
	return a>>b;
}

unsigned int DSP_do_lshr (unsigned int a, unsigned int b)
{
	return a>>b;
}

int DSP_do_shl (int a, int b)
{
	return a<<b;
}

float DSP_do_fdiv (float a, float b)
{
	return a/b;
}
