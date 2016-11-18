//  según la versión de gcc y opciones de optimización usadas, tal vez haga falta
//  usar gcc –fno-omit-frame-pointer si gcc quitara el marco pila (%ebp)

#include <stdio.h>	// para printf()
#include <stdlib.h>	// para exit()
#include <sys/time.h>	// para gettimeofday(), struct timeval

#define SIZE (1<<20)	// tamaño suficiente para tiempo apreciable
#define WSIZE 8*sizeof(unsigned)
unsigned lista[SIZE];
//unsigned lista[SIZE]={0x80000000,0x00100000,0x00000800,0x00000001};
//unsigned lista[SIZE]={0x7fffffff,0xffefffff,0xfffff7ff,0xfffffffe,0x10000024,0x00356700,0x8900ac00,0x00bd00ef};
//unsigned lista[SIZE]={0x0,0x10204080,0x3590ac06,0x70b0d0e0,0xffffffff,0x12345678,0x9abcdef0,0xcafebeef};
int resultado=0;

int parityCount1(int* array, int len)
{
    int  i,j,  res=0,result;
    for (i=0; i<len; i++){
        result = 0;
        for (j = 0; j < WSIZE; j++) {
            unsigned mask = 1 << j;
            result ^= (array[i] & mask) != 0;
        }
        res+=result;
    }
    return res;
}

int parityCount2(int* array, int len)
{
    int  i,j,  res=0,result;
    for (i=0; i<len; i++){
        result = 0;
        unsigned value=array[i];
        do{
            result^= value & 0x1;
            value >>= 1;
        }while(value);
        res+=result;
    }
    return res;
}

int parityCount3(int* array, int len)
{
    int  i,j,  res=0,result;
    for (i=0; i<len; i++){
        result = 0;
        unsigned value=array[i];
        while(value){
            result^= value;
            value >>= 1;
        }
        res+=result & 0x1;
    }
    return res;
}

int parityCount4(int* array, int len)
{
    int  i,j,  res=0,val;
    unsigned x;
    for (i=0; i<len; i++){
        val=0;
        x=array[i];
        asm("ini3:               \n\t"
            "xor %[x],%[v]       \n\t"
            "shr %[x]            \n\t"

            "cmp $0,%[x]         \n\t"
            "jne ini3            \n\t"
            :  [v]"+r" (val)      // output-input
            :  [x]  "r" (x)  );     // input
        res+=val & 0x1;
    }
    return res;
}

int parityCount5(int* array, int len)
{
    int  i,j,  res=0,result,val;
    unsigned x;
    for (i=0; i<len; i++){
        result = 0;
        val=0;
        x=array[i];
        for (j = 16; j > 0; j/=2) {
            x ^= (x >> j);
        }

        res+=x & 0x1;
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
    int i;          // inicializar array
    for (i=0; i<SIZE; i++)  // se queda en cache
     lista[i]=i;
    
    crono(parityCount1, "parityCount1 (en lenguaje C    )");
    crono(parityCount2, "parityCount2 (en lenguaje C    )");
    crono(parityCount3, "parityCount3 (en lenguaje C    )");
    crono(parityCount4, "parityCount4 (en lenguaje C    )");
    crono(parityCount5, "parityCount5 (en lenguaje C    )");

    printf("N*(N+1)/2 = %d\n", (SIZE-1)*(SIZE/2)); 

    exit(0);
}