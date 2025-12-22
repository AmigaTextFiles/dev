OPT MODULE  -> Definisce la classe 'set' come modulo
OPT EXPORT  -> Esporta tutto

/* I dati per la classe */
OBJECT set PRIVATE  -> Rende tutti i dati privati
  elements:PTR TO LONG
  maxsize, size
ENDOBJECT

/* Creazione del constructor */
/* Dimensione minima 1, massima 100000, default 100 */
PROC create(sz=100) OF set
  DEF p:PTR TO LONG
  IF (sz>0) AND (sz<100000) -> Controlla la dimensione
    self.maxsize:=sz
  ELSE
    self.maxsize:=100
  ENDIF
  self.elements:=NEW p[self.maxsize]
ENDPROC

/* Constructor copy */
PROC copy(oldset:PTR TO set) OF set
  DEF i
  self.create(oldset.maxsize)  -> Chiama il metodo create!
  FOR i:=0 TO oldset.size-1  -> Copia elements
    self.elements[i]:=oldset.elements[i]
  ENDFOR
  self.size:=oldset.size
ENDPROC

/* Destructor */
PROC end() OF set
  DEF p:PTR TO LONG
  IF self.maxsize<>0  -> Controlla l'avvenuta allocazione
    p:=self.elements
    END p[self.maxsize]
  ENDIF
ENDPROC

/* Aggiunge un elemento */
PROC add(x) OF set
  IF self.member(x)=FALSE  -> E` nuovo? (Chiama il metodo member!)
    IF self.size=self.maxsize
      Raise("full")  -> Il set è già pieno
    ELSE
      self.elements[self.size]:=x
      self.size:=self.size+1
    ENDIF
  ENDIF
ENDPROC

/* Verifica l'appartenenza */
PROC member(x) OF set
  DEF i
  FOR i:=0 TO self.size-1
    IF self.elements[i]=x THEN RETURN TRUE
  ENDFOR
ENDPROC FALSE

/* Verifica se è vuoto */
PROC empty() OF set IS self.size=0

/* Unisce (aggiunge) un altro set */
PROC union(other:PTR TO set) OF set
  DEF i
  FOR i:=0 TO other.size-1
    self.add(other.elements[i])  -> Chiama il metodo add!
  ENDFOR
ENDPROC

/* Stampa i contenuti */
PROC print() OF set
  DEF i
  WriteF('{ ')
  FOR i:=0 TO self.size-1
    WriteF('\d ', self.elements[i])
  ENDFOR
  WriteF('}')
ENDPROC
