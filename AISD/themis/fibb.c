/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: PGA
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void multmatrix(int* arr, int* arr2, int* res, int n){
    int i,j,k;
    for(i = 0;i < n; ++i)
        for(j = 0; j < n; ++j)
            for(k = 0; k < n; ++k)
                res[i*n+j] += arr[i*n+k] * arr2[k*n+j];
}

void cpymatrix(int* arr, int* arr2, int n){
    int i,j;
    for(i = 0; i < n; ++i)
        for(j = 0; j < n; ++j)
            arr[i*n+j] = arr2[i*n+j];
}

void printmatrix(int* arr, int n){
    int i,j;
    for(i = 0; i < n; ++i){
        for(j = 0; j < n; ++j)
            printf("%d ", arr[i*n+j]);
        printf("\n");
    }
}


int* fib2(unsigned int n){
    int matrix[2][2] = {{1, 1},{1, 0}};
    int f     [2][2] = {{0, 0},{0, 0}};
    int tmp   [2][2] = {{1, 0},{0, 1}};
    while(n >>= 1){
        multmatrix((int*)matrix, (int*)tmp, (int*)f,2);
        cpymatrix((int*)matrix, (int*)f, 2);
        cpymatrix((int*)tmp, (int*)matrix, 2);
    }
    int* res = (int*)malloc(sizeof(int)*4);
    cpymatrix(res, (int*)f, 2);
    return res;
}

int pow2(const int x){
    int res = 1;
    for(int i = 0; i < x; i++)
        res <<= 1;
    return res;
}

long long fib(unsigned int n){
    if(n == 0)
        return 0;
    else if(n == 1)
        return 1;
    long long res[2] = {{1,0},{0,1}};
    long long matrix[2] = {{1,1},{1,0}};
    long long tmp   [2] = {{1,1},{1,0}};
    while(n > 0){
        if(!(n % 2)){
            n /= 2;
            multmatrix((int*)matrix);
        }
        else{
            n--;
            res
        }
    }
}

int main(){
    int tnum;
    scanf("%d", &tnum);/*
    int* tests = (int*)malloc(sizeof(int)*tnum*2);
    int i;
    for(i = 0; i < tnum; ++i)
        scanf("%d %d", &tests[i<<1], &tests[i<<1 + 1]);
    
    free(tests);
    */
    printf("\nfib:%d\n", fib(tnum));

    return 0;
}