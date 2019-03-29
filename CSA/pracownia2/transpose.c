/*
 * Matrix transposition with and without blocking.
 *
 * $ ./transpose -n 15 -v 0
 * Time elapsed: 21.917466 seconds.
 * $ ./transpose -n 15 -v 1
 * Time elapsed: 5.416954 seconds.
 */
#include "common.h"

#define BLOCK (BLOCK_SIZE / sizeof(int))

void fill(int *dst, int n) {
  for (int i = 0; i < n; i++)
    for (int j = 0; j < n; j++)
      dst[i * n + j] = i * n + j;
}

void transpose1(int *dst, int *src, int n) {
   int cnt = 0;
  for (int i = 0; i < n; i++)
    for (int j = 0; j < n; j++)
      dst[j * n + i] = src[i * n + j];
}

void transpose2(int *dst, int *src, int n) {
  /* XXX: Fill in this procedure! */
	size_t BLOCK_SIZE_ = 4;
    if(n < BLOCK_SIZE_)
        BLOCK_SIZE_ = n;
	int i,j;
	for(i = 0; i < n; i += BLOCK_SIZE_){
		for(j = 0; j < n; j += BLOCK_SIZE_){
	        for(int i_b = 0; i_b < BLOCK_SIZE_; ++i_b){
                for(int j_b = 0; j_b < BLOCK_SIZE_; ++j_b){
			        dst[(j+j_b) * n + i + i_b] = src[(i+i_b) * n + j + j_b];
                }
            }
        }
        // jesli n nie podzielne przez BLOCK_SIZE_
        if(j != n){
            j -= BLOCK_SIZE_;
            for(int j_b = 0; j_b + j  < n; ++j_b)
                dst[(j+j_b) * n + i] = src[i * n + j + j_b];
        }
    }
    
}
int main(int argc, char **argv) {
  int opt, exp = -1, var = -1;
  bool err = false;

  while ((opt = getopt(argc, argv, "n:v:")) != -1) {
    if (opt == 'n')
      exp = atoi(optarg);
    else if (opt == 'v')
      var = atoi(optarg);
    else
      err = true;
  }

  if (err || exp < 0 || var < 0 || var >= 2) {
    fprintf(stderr, "Usage: %s -n log2(size) -v variant\n", argv[0]);
    return 1;
  }

  int n = 1 << exp;
  size_t size = n * n * sizeof(int);
  int *src = NULL, *dst = NULL;

  posix_memalign((void **)&src, getpagesize(), size);
  posix_memalign((void **)&dst, getpagesize(), size);

  printf("Generate matrix %d x %d (%ld KiB)\n", n, n, size >> 10);

  fill(src, n);
  bzero(dst, size);
  flush_cache();

  printf("Performing matrix transposition.\n");

  _timer_t timer;
  timer_reset(&timer);
  timer_start(&timer);
  if (var == 0) 
    transpose1(dst, src, n);
  else
    transpose2(dst, src, n);
  timer_stop(&timer);
  timer_print(&timer);

  free(src);
  free(dst);

  return 0;
}
