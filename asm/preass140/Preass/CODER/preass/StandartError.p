Errorhandling:
    Ausgabe=output()
    If Error=#1 do Write(Ausgabe,"Allgemeiner Fehler\n",?)
    If Error=#2 do Write(Ausgabe,"Konnte File nicht finden\n",?)
    If Error=#3 do Write(Ausgabe,"Window|Screen Fehler\n",?)
    If Error=#4 do Write(Ausgabe,"Library nicht gefunden\n",?)
    If Error=#5 do Write(Ausgabe,"Fehlerhafte Eingabe\n",?)
    If Error=#6 do Write(Ausgabe,"Speicherfehler\n",?)
    RTS
