/* prend les arguments d'une ligne de commande. notez que `arg' *
 * est une variable prédéfinie du E                             */

PROC main()
  WriteF(IF arg[]=0 THEN 'Pas d'argument!\n' ELSE 'Vous avez écrit: \s\n',arg)
ENDPROC
