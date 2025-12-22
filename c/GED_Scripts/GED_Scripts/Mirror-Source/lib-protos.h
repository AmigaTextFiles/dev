/* tag.a                */

Prototype ALibExpunge(), ALibClose(), ALibOpen(), ALibReserved();

/* lib.c                */

Prototype struct Library * LibCall LibInit   (REG(d0) BPTR segment);                             
Prototype struct Library * LibCall LibOpen   (REG(d0) long version, REG(a0) struct Library *lib);
Prototype long             LibCall LibClose  (REG(a0) struct Library *lib);                      
Prototype long             LibCall LibExpunge(REG(a0) struct Library *lib);                      

/* funcs.c              */

Prototype struct APIClient * LibCall APIMountClient(REG(a0) struct APIMessage *apiMsg, REG(a1) char *args);
Prototype void               LibCall APICloseClient(REG(a0) struct APIClient *handle, REG(a1) struct APIMessage *apiMsg);
Prototype void               LibCall APIBriefClient(REG(a0) struct APIClient *handle, REG(a1) struct APIMessage *apiMsg);
Prototype void               LibCall APIFree       (REG(a0) struct APIClient *handle, REG(a1) struct APIOrder *apiOrder);
Prototype void Dispatch         (struct APIMessage *apiMsg);
Prototype BOOL FindMarkedBracket(struct EditConfig *config);
Prototype BOOL MatchingBracket  (struct APIMessage *apiMsg, UBYTE examine);
