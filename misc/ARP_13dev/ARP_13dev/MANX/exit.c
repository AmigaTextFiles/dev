/* Not really arp specific, but need to prevent horrendous linker errors */
int (*cls_)();

exit(code)
{
	if (cls_)
		(*cls_)();
	_exit(code);
}
