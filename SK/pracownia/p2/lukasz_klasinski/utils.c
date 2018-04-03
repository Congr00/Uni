#include "utils.h"

void wait_s(){
    while(__semaphore->_val <= 0);
    __semaphore->_val--;
}

void signal_s(){
   __semaphore->_val++;
}

uint32_t endian_swap(uint32_t val){
    return
    (val>>24) |
    ((val>>8) & 0x0000ff00) |
    ((val<<8) & 0x00ff0000) |
    (val<<24);
}
