TERM Identifier_inout;
TERM Identifier_idtree,Identifier_no_ident;


XCOPY(xcopy_Identifier_identifier)
{ return CP(A); /* copy_Identifier_entry(A) */
}

extern SORTREC _SIdentifier_entry;

XFREE(xfree_Identifier_identifier)
{ FREE(_SIdentifier_entry,A); /* free_Identifier_entry(A) */
}

void EXFUN(Identifierwrite_ident_0,(TERM,TERM,TERM *,TERM *));
void EXFUN(Identifierread_ident_0,(TERM,TERM,TERM *,TERM *,TERM *));
TERM EXFUN(Identifierno_entry_0,(void));
void EXFUN(Identifieradjust_0,(TERM,TERM,TERM *,TERM *));
void EXFUN(Identifierinit_0,(TERM,TERM *,TERM *));

XEQ(x_X61_X61_Identifier_identifier)
{ TERM RES = (TERM) (A1==A2);  /* Hoho (!?)                 */
  FREE(_SIdentifier_entry,A1); /* free_Identifier_entry(A1) */
  FREE(_SIdentifier_entry,A2); /* free_Identifier_entry(A1) */
  return RES;
}

XREAD(xread_Identifier_identifier)
{ 
  Identifierread_ident_0((A == TNULL) ? Identifierno_entry_0() : A,
                         SYSI,OK,RES,SYSO);
}


XWRITE(xwrite_Identifier_identifier)
{
  /** Identifierwrite_ident_0(A,SYSI,OK,SYSO);                **/
  /** Dies funktioniert nicht mit Debugger, weil diese        **/
  /** Funktion beim Auschreiben ihrer Args aufgerufen wird !! **/
  TERM NR,HLP;
  if (OPN(Identifier_inout) == _CIdentifieras_string_0)
    write__RUNTIME_string
      (extr__RUNTIME_string(_SIdentifier_entry,A,0),SYSI,OK,SYSO);
  else if ((int)(A->ARGS[1]) >= 0)
    write__RUNTIME_integer
      (extr__RUNTIME_integer(_SIdentifier_entry,A,1),SYSI,OK,SYSO);
  else {
    Identifieradjust_0(A,SYSI,&NR,&HLP);
    write__RUNTIME_integer(NR,HLP,OK,SYSO);
  }  
}


TERM
DEFUN_VOID(xx_Identifierno_ident_0) {
  return Identifierno_ident_0();
}


TERM
DEFUN(xx_Identifierstring_0,(ARG0),
      TERM ARG0)
{ return Identifierstring_0(ARG0);
}


TERM
DEFUN(xx_Identifierinteger_0,(ARG0),
      TERM ARG0)
{ return Identifierinteger_0(ARG0);
}

TERM
DEFUN(xx_Identifierset_io_mode_0,(ARG0,ARG1),
      TERM ARG0 AND TERM ARG1)
{ Identifier_inout= ARG0;
  return ARG1;
}

void
DEFUN(xx_Identifierget_io_mode_0,(ARG,RES1,RES2),
      TERM ARG AND TERM *RES1 AND TERM *RES2)
{ *RES1 = Identifier_inout;
  *RES2 = ARG;
}

#define Identifierget_idtree_0(a,b,c) *(b)=Identifier_idtree; *(c)=a
#define Identifierset_idtree_0(a,b)   ((Identifier_idtree = a),b)
#define Identifierset_nr_0(a,b)       ((b->ARGS[1] = a),b)
#define Identifierid_entry_0(a)       a
#define Identifierentry_id_0(a)       a

void
DEFUN(xx_Identifierget_idtree_0,(ARG0,RES1,RES2),
           TERM ARG0 AND TERM *RES1 AND TERM *RES2)
{ Identifierget_idtree_0(ARG0,RES1,RES2);
}

TERM
DEFUN(xx_Identifierset_idtree_0,(ARG0,ARG1),
      TERM ARG0 AND TERM ARG1)
{ return Identifierset_idtree_0(ARG0,ARG1);
}

TERM 
DEFUN(xx_Identifierset_nr_0,(ARG0,ARG1),
      TERM ARG0 AND TERM ARG1)
{ return Identifierset_nr_0(ARG0,ARG1); /** Pfu-usch !! **/
}

TERM 
DEFUN(xx_Identifierid_entry_0,(ARG0),
      TERM ARG0)
{ return Identifierid_entry_0(ARG0);
}

TERM 
DEFUN(xx_Identifierentry_id_0,(ARG0),
      TERM ARG0)
{ return Identifierentry_id_0(ARG0);
}

unsigned __XINIT_Identifier = 0;
void
DEFUN(Identifier_Xinitialize,(MODE),unsigned MODE)
{TERM dummy;
 if(__XINIT_Identifier == 0)__XINIT_Identifier = 1;
 else {
   Identifier_inout = co__Identifieras_string_0;
   Identifierinit_0((TERM)0,&Identifier_no_ident,&dummy);
 }
}
