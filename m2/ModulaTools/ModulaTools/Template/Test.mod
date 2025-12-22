MODULE Test;
 
FROM Template IMPORT CreateScreenWindowAndMenus, DestroyScreenWindowAndMenus,
                     ProcessIntuiMessages, TheScreen, TheWindow, TheMenu;
FROM Storage  IMPORT DestroyHeap;


VAR
   finished : BOOLEAN;


BEGIN
   IF ( CreateScreenWindowAndMenus () ) THEN
      finished := FALSE;
      WHILE NOT finished DO
         ProcessIntuiMessages (finished);
      END; (* WHILE NOT finished *)
      DestroyScreenWindowAndMenus;
   END; (* IF CreateScreenWindowAndMenus *)
   DestroyHeap;
END Test.
