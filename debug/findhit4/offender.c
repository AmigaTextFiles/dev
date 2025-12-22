/*	compile: sc dbg=l map link $*
*/

#include <proto/exec.h>

void func1(void)
{
  char *ptr=0;

	/* enforcer hit 2 */
	*ptr='b';
}

void main(void)
{
  char *ptr=0;


	/* enforcer hit 1 */
	*ptr='a';

	func1();

	ptr=AllocMem(100,0);

	/* wrong FreeMem() size */
	FreeMem(ptr, 99);
}
