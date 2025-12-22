/* Copyright (c) 1986, Greg McGary */
static char sccsid[] = "@(#)document.c	1.1 86/10/09";

void document();

void
document(doc)
	char		**doc;
{
	while (*doc)
		printf("%s\n", *doc++);
}
