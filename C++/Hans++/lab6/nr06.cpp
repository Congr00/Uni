
#include <fstream>
#include <iostream>
#include <random>

#include "listtest.h"
#include "vectortest.h"
#include "timer.h"


int main( int argc, char* argv [] )
{

   std::vector< std::string > vect;

   std::cout << vect << "\n";
   std::ifstream inp{"test.txt"};
   vect = vectortest::readfile(inp);
   std::cout << vect << "\n";
   std::vector<std::string> rand;
   rand = vectortest::randomstrings(10000, 50);
   vect = rand;
  // std::cout << vect << "\n";
   // Or use timer:

   auto t1 = std::chrono::high_resolution_clock::now( ); 
   vectortest::sort_move( vect );
   auto t2 = std::chrono::high_resolution_clock::now( );
   
   std::chrono::duration< double > d = ( t2 - t1 );
   //std::cout << vect << "\n";
   std::cout << "sorting vectortest::sort_move " << d. count( ) << " seconds\n";
 
   vect = rand;

   t1 = std::chrono::high_resolution_clock::now();
   vectortest::sort_assign(vect);
   t2 = std::chrono::high_resolution_clock::now();

   d = (t2 - t1);
	
   std::cout << "sorting vectortest::sort_assign " << d.count() << " seconds\n";

   vect = rand;

   t1 = std::chrono::high_resolution_clock::now();
   vectortest::sort_std(vect);
   t2 = std::chrono::high_resolution_clock::now();

   d = (t2 - t1);
	
   std::cout << "sorting vectortest::sort_std " << d.count() << " seconds\n";

	/* -03
sorting vectortest::sort_move 0.750134 seconds
sorting vectortest::sort_assign 6.07136 seconds
sorting vectortest::sort_std 0.00200526 seconds
		-03 -flto
sorting vectortest::sort_move 0.76477 seconds
sorting vectortest::sort_assign 3.09396 seconds
sorting vectortest::sort_std 0.00207316 seconds
		-	
sorting vectortest::sort_move 1.56214 seconds
sorting vectortest::sort_assign 7.21892 seconds
sorting vectortest::sort_std 0.00476527 seconds
	
	*/
   return 0;
}


