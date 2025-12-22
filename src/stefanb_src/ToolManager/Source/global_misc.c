/*
 * global_misc.c  V3.1
 *
 * ToolManager global miscellaneous routines
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

/* Get next in list */
struct MinNode *GetSucc(struct MinNode *n)
{
 struct MinNode *succ = n->mln_Succ;

 /* End of list? */
 return(succ->mln_Succ ? succ : NULL);
}

/* Get previous in list */
struct MinNode *GetPred(struct MinNode *n)
{
 struct MinNode *pred = n->mln_Pred;

 /* End of list? */
 return(pred->mln_Pred ? pred : NULL);
}
