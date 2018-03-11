/*
author:     Łukasz Klasiński
indeks:     290043
prowadzący: PGA
*/

#include <stdio.h>

#define MULT 2018

int main(){
    unsigned int a, b;
    unsigned int print;
    scanf("%d %d", &a, &b); 
    int i;
    for(print = 0; print < a; print+=MULT){}
    for(i = print; i <= b; i+=MULT)
        printf("%d ", i);
    return 0;
}