
#include "powerproduct.h"
#include "polynomial.h"
#include "bigint.h"
#include "rational.h"


template< typename N >
polynomial< N > exptaylor( unsigned int n )
{
   powerproduct v;

   N fact = 1;

   polynomial< N > result;
   for( unsigned int i = 0; i < n; ++ i )
   {
      result[v] += fact;
      v = v * powvar( "x" );
      fact = fact / (i+1);
   }

   return result;
}

int main( int argc, char* argv [] )
{
   std::cout << "hello\n";

   polynomial< rational > pol;

   int N = 50;

   pol[ { } ] = 1;
   pol[ { "x" } ] = rational( 1, N ); 

   
   polynomial< rational > res = 1;
 
   for( int i = 0; i < N; ++ i )
      res = res * pol;

   std::cout << "rsult = " << res << "\n";

   std::cout << " taylor expansion = " << exptaylor<rational>(20) << "\n";

   std::cout << "difference = " ;  
   std::cout << res - exptaylor<rational> ( 40 ) << "\n";
 
   return 0;
}


