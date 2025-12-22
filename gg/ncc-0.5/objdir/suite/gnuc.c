
struct xx
{
	int x, y;
};

int main ()
{
	struct xx sx;
	int x, d;
	
	sx = ((struct xx) {1, 0});
	x = ({int y; for (y=0;y<10;y++); y + d;});
	x = ((int) {1});
	x = ({int y; y = d; });
	x = 1 + (int){1};
}