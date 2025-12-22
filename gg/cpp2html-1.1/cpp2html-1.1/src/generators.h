// generators.h

#ifndef _GENERATORS_H
#define _GENERATORS_H

extern TextGenerator *GlobalGenerator ;
extern TextGenerator *KeywordGenerator ;
extern TextGenerator *CommentGenerator ;
extern TextGenerator *StringGenerator ;
extern TextGenerator *TypeGenerator ;
extern TextGenerator *NumberGenerator ;

extern void createGenerators() ;
extern void createGeneratorsForCSS() ;

#endif
