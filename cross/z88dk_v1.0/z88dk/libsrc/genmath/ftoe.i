# 1 "ftoe.c"
 

# 1 "zcc:include/float.h" 1





 



#pragma proto HDRPRTYPE



extern double fmod();
extern double amax();
extern double fabs();
extern double amin();
extern double floor();
extern double ceil();
extern double rand();  
extern int seed();     


#pragma unproto HDRPRTYPE



# 3 "ftoe.c" 2

# 1 "zcc:include/math.h" 1





 



#pragma proto HDRPRTYPE

extern double acos(double);   
extern double asin(double);   

extern double atan(double);   
extern double atan2(double,double);  
extern double cos(double);    
extern double cosh(double);   
extern double exp(double);    
extern double log(double);    
extern double log10(double);  
extern double pow(double,double);    
extern double sin(double);    
extern double sinh(double);   
extern double sqrt(double);   
extern double tan(double);    
extern double tanh(double);   

#pragma unproto HDRPRTYPE


# 4 "ftoe.c" 2

# 1 "zcc:include/stdio.h" 1








 





 



extern  int   *sgoioblk[3];







 

 



#pragma proto HDRPRTYPE


extern int  *fopen(char *, char *);
extern int fclose(int  *);
extern char *fgets(char *, int, int  *);
extern fputc(unsigned char, int  *);
extern char fgetc(int  *);
extern char getc(void);
extern fputs(char *, int  *);
extern feof(int  *);
extern long ftell(int  *);
extern int fgetpos(int  *,long *);

 





 



 






extern printf(char *,...);
extern fprintf(int  *,char *,...);
extern sprintf(char *,char *,...);

extern int remove(char *);
extern int rename(char *, char *);



 

extern char getk(void);
extern char getkey(void);

 

extern putchar(char);
extern putn(int);
extern puts(char *);
extern settxy(int, int);

 



extern int getarg(void);
extern int printf1();

#pragma unproto HDRPRTYPE 



# 5 "ftoe.c" 2


#pragma proto HDRPRTYPE
extern void ftoe(double x, int prec, char *str);
extern int ifix();
extern double float();
#pragma unproto HDRPRTYPE

#asm
        LIB     floor
#endasm


ftoe(x,prec,str)
double x ;               
int prec ;               
char *str ;              
{
        double scale;    
        int i,                   
                d,                       
                expon;           

        scale = 1.0 ;            
        i = prec ;
        while ( i-- )
        scale *= 10.0 ;
        if ( x == 0.0 ) {
                expon = 0 ;
                scale *= 10.0 ;
        }
        else {
                expon = prec ;
                if ( x < 0.0 ) {
                        *str++ = '-' ;
                        x = -x ;
                }
                if ( x > scale ) {
                         
                        scale *= 10.0 ;
                        while ( x >= scale ) {
                                x /= 10.0 ;
                                ++expon ;
                        }
                }
                else {
                        while ( x < scale ) {
                                x *= 10.0 ;
                                --expon ;
                        }
                        scale *= 10.0 ;
                }
                 
                x += 0.5 ;                       
                if ( x >= scale ) {
                        x /= 10.0 ;
                        ++expon ;
                }
        }
        i = 0 ;
        while ( i <= prec ) {
                scale = floor( 0.5 + scale * 0.1 ) ;
                 
                d = ifix( x / scale ) ;
                *str++ = d + '0' ;
                x -= float(d) * scale ;
                if ( i++ ) continue ;
                *str++ = '.' ;
        }
        *str++ = 'e' ;
        if ( expon < 0 ) { *str++ = '-' ; expon = -expon ; }
        if(expon>9) *str++ = '0' + expon/10 ;
        *str++ = '0' + expon % 10 ;
        *str = 0 ;
}
