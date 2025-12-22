
#define LibCall __geta4 __regargs

extern LibCall struct ProducerNode * GetProducer(void);
extern LibCall void FreeProducer(struct ProducerNode *);

extern LibCall int LoadDesignerData(struct ProducerNode *,char *);
extern LibCall void FreeDesignerData(struct ProducerNode *);

extern LibCall struct ProducerNode *OpenProducerWindow(struct ProducerNode *, char *);
extern LibCall void CloseProducerWindow(struct ProducerNode *);
extern LibCall void SetProducerWindowFileName(struct ProducerNode *,char *);
extern LibCall void SetProducerWindowAction(struct ProducerNode *,char *);
extern LibCall void SetProducerWindowLineNumber(struct ProducerNode *,long);
extern LibCall int ProducerWindowUserAbort(struct ProducerNode *);
extern LibCall int ProducerWindowWriteMain(struct ProducerNode *,char *);

extern LibCall int AddLocaleString(struct ProducerNode *,char *,char *,char *);
extern LibCall void FreeLocaleStrings(struct ProducerNode *);
extern LibCall int WriteLocaleCT(struct ProducerNode *);
extern LibCall int WriteLocaleCD(struct ProducerNode *);

