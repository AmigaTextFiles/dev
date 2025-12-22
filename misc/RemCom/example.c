/*      This is an example to test RemCom
        ©1992 by Dalibor S. Kezele              */

char word1[80];         /* Source word */
char word2[80];         /* Destination word */

int i,j;                /* Counters */

/* Here it is ! */

void main(void)
{
        printf("Enter a word :");
        scanf("%s", &word1);
        j=strlen(word1);
        word2[j] = i = 0;
        while(--j >= 0)
                word2[i++] = word1[j];
        puts(word2);
} /* main */

/* Now start RemCom with something like

        RemCom -C example.c nocomment.c         */
