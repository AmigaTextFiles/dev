extern void func2 (void);

int func (int b)
{
	return (b*b);
}

int globa;
int globb;
int globc;

int main (int argc, char *argv[])
{
	int a;
	int b;
	int c;

	b = 4;
	c = 6;
	a = b+c;

	globb = 4;
	globc = 6;
	globa = globb+globc;

	func2 ();

	func (3);
	func (3+func (7));
	func (4);
	func (5);

	func2 ();
}
