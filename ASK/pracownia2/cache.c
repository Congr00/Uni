/*
 * Template for cache organization exploring assignment.
 *
 * $ ./cache -n 26 -s 26 -t 20
 * Time elapsed: 2.322265 seconds.
 */

#include "common.h"

#define DEBUG 0

/* Do not touch this procedure! */
int array_walk(volatile int *array, int steps) {
  int sum = 0, i = 0;

  do {
    if (i < 0)
      break;
#if DEBUG
    printf("%d -> %d\n", i, array[i]);
#endif
    i = array[i];
    sum += i;
  } while (--steps);

  return sum;
}

/* XXX: You are only allowed to change this procedure! */
void generate_permutation(int *array, int size) {
  /* Walk over every even element, then over every odd. */
  const int jump_by = 8;


  for(int i = 0; i < size; i += jump_by)
		  if(i + jump_by < size)
				  array[i] = i + jump_by;
          else
				  array[i] = 0;
}
/*
 *
 * ./cache -n 26 -s 26 -t 20 - jump by 2:
 * fst time : 6.6s-5.5 za pierszym then
 * 3.7,3.8,3.7 | ~3.7 jeden po drugim
 * gdy jump = 1, wyniki zblizone na korzysc 1 ~0.1-0.2 szybciej 
 * dla jump = 4, wyniki tez podobne
 * dla jump = 8 ~5 sec, nieco pogorszony
 * dla jump = 16 ~10 sec, wydaz duzo wiecej missow
 * dla jump = 32 ~20 sec, KATASTROFA, same missy -> z tego wynika ze dlugosc musi wynosic 4, bo przy 8 byl spadek wydajnosci
 * cache size:
 * przy ./cache -n 12 -s 26 -t 20 (16KB) wykonuje sie okolo 0.0004 sec, dla 32KB przy szybkim powtarzaniu
 *  predkosc ta jest podobna natomiast dla 65KB drastycznie rosnie do 0.0015 przy szybkim powtarzaniu. Pokazuje to ze
 *  nie udalo juz sie calej tablicy zaladowac w L1 i dlatego czasami sa missy na L2 spowalniajace program
 *  podobnie dla n = 16 widac ze wyniki czasami maja znaczaca roznice w szybkosci, poniewac jest to rowno 256KB,
 *  a poniewaz inne procesy korzystaja z cache to czasami starczy miejsca i jest szybki a czasami zabraknie i bedzie
 *  musial rezerwowac L3
 *  Tak samo przy przekroczeniu 4MG program spowalnie o 4 razy zamiast 2, gdzie wczesniej utrzymywala sie ta tendencja,
 *  swiadczy to o skonczeniu sie L3
 *
 */
int main(int argc, char **argv) {
  int opt, size = -1, steps = -1, times = -1;
  bool error = false;

  while ((opt = getopt(argc, argv, "n:s:t:")) != -1) {
    if (opt == 'n') 
      size = 1 << atoi(optarg);
    else if (opt == 's')
      steps = 1 << atoi(optarg);
    else if (opt == 't')
      times = atoi(optarg);
    else
      error = true;
  }

  if (error || size < 0 || steps < 0 || times < 0) {
    printf("Usage: %s -n log2(size) -s log2(steps) -t times\n", argv[0]);
    exit(EXIT_FAILURE);
  }

  int *array = NULL;

  if (posix_memalign((void **)&array, getpagesize(), size * sizeof(int)) != 0)
    fail("Failed to allocate memory!");

  printf("Generate array of %d elements (%ld KiB)\n", size, size * sizeof(int) >> 10);
  generate_permutation(array, size);
  flush_cache();

  printf("Perfom walk %d times with %d steps each.\n", times, steps);

  _timer_t t;
  timer_reset(&t);
  for (int i = 0; i < times; i++) {
    timer_start(&t);
    array_walk(array, steps);
    timer_stop(&t);
  }
  timer_print(&t);

  free(array);

  return EXIT_SUCCESS;
}
