//  según la versión de gcc y opciones de optimización usadas, tal vez haga falta
//  usar gcc –fno-omit-frame-pointer si gcc quitara el marco pila (%ebp)

#include <stdio.h>	// para printf()
#include <stdlib.h>	// para exit()
#include <sys/time.h>	// para gettimeofday(), struct timeval

#define SIZE (1<<16)	// tamaño suficiente para tiempo apreciable
#define WSIZE 8*sizeof(unsigned)
//unsigned lista[SIZE];
unsigned lista[SIZE]={0x80000000,0x00100000,0x00000800,0x00000001};
//unsigned lista[SIZE]={0x7fffffff,0xffefffff,0xfffff7ff,0xfffffffe,0x10000024,0x00356700,0x8900ac00,0x00bd00ef};
//unsigned lista[SIZE]={0x0,0x10204080,0x3590ac06,0x70b0d0e0,0xffffffff,0x12345678,0x9abcdef0,0xcafebeef};
int resultado=0;

int popCount1(int* array, int len)
{
    int  i,j,  res=0,result;
    for (i=0; i<len; i++){
        result = 0;
        for (j = 0; j < WSIZE; j++) {
            unsigned mask = 1 << j;
            result += (array[i] & mask) != 0;
        }
        res+=result;
    }
    return res;
}

int popCount2(int* array, int len)
{
    int  i,j,  res=0,result;
    for (i=0; i<len; i++){
        result = 0;
        unsigned value=array[i];
        do{
            result+= value & 0x1;
            value >>= 1;
        }while(value);
        res+=result;
    }
    return res;
}

int popCount3(int* array, int len)
{
    int  i,j,  res=0,result;
    for (i=0; i<len; i++){
        result = 0;
        unsigned x=array[i];
        asm("ini3:               \n\t"
            "shr %[x]            \n\t"
            "adc $0,%[r]    \n\t"
            "cmp $0,%[x]         \n\t"
            "jne ini3            \n\t"
            :  [r]"+r" (result)      // output-input
            :  [x]  "r" (x)  );     // input
        
        res+=result;
    }
    return res;
}


int popCount4(int* array, int len)
{
    int  i,j,  res=0,result,val;
    unsigned x;
    for (i=0; i<len; i++){
        result = 0;
        val=0;
        x=array[i];
        for (j = 0; j < 8;j++) {
            val += x & 0x0101010101010101L;
            x >>= 1;
        }
        
        val += (val >> 16);
        val += (val >> 8);
        res+=val & 0xFF;
    }
    return res;
}

void crono(int (*func)(), char* msg){
    struct timeval tv1,tv2;	// gettimeofday() secs-usecs
    long           tv_usecs;	// y sus cuentas

    gettimeofday(&tv1,NULL);
    resultado = func(lista, SIZE);
    gettimeofday(&tv2,NULL);

    tv_usecs=(tv2.tv_sec -tv1.tv_sec )*1E6+
             (tv2.tv_usec-tv1.tv_usec);
    printf("resultado = %d\t", resultado);
    printf("%s:%9ld us\n", msg, tv_usecs);
}

int main()
{
    //int i;			// inicializar array
    //for (i=0; i<SIZE; i++)	// se queda en cache
	 //lista[i]=i;

    crono(popCount1, "popCount1 (en lenguaje C    )");
    crono(popCount2, "popCount2 (en lenguaje C    )");
    crono(popCount3, "popCount3 (en lenguaje C    )");
    crono(popCount4, "popCount4 (en lenguaje C    )");

    printf("N*(N+1)/2 = %d\n", (SIZE-1)*(SIZE/2)); /*OF*/

    exit(0);
}