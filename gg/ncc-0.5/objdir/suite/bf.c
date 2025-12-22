
struct bf
{
	int x:30, y:4;
	int z:20, :10, h:2;
	int zz:1, f:0, zzz:1;
} b;

int main ()
{
b.x;
b.y;	
b.z;
b.h;
b.zz;
b.zzz;
}