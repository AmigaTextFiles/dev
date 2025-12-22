/*
 * sepp.c - This is the main program
 */

/* Include some things from the standard library */
#include <stdio.h>
#include <stdlib.h>

/* These variables hold some information about a person called Sepp */
const char sepp_name[] = "Sepp";
static int sepp_age = 78;

/* This views some information about the current status of Sepp */
void print_sepp()
{
    printf("%s is %d years old.\n", sepp_name, sepp_age);
}

/* This is the main function called when the program is started */
int main(void)
{
    while (sepp_age < 83)
    {
        /* Simulate one year in the life of Sepp */
        grow_older(sepp_name, &sepp_age);
        print_sepp();
    }

    /* Announce the bad news */
    printf("\n%s died.\n", sepp_name);

    /* World ends here. */
    exit(EXIT_SUCCESS);
}

