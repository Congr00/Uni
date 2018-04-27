
#include "powerproduct.h"
#include <algorithm>
/*

std::ostream& operator << ( std::ostream& out, const powvar & p )
{
   if( p.n == 0 )
   {
      out << "1"; // Should not happen, but we still have to print something.
      return out;
   }

   out << p.v;
   if( p.n == 1 )
      return out;

   if( p.n > 0 )
      out << "^" << p.n;
   else
      out << "^{" << p.n << "}";
   return out;
}


std::ostream& operator << ( std::ostream& out, const powerproduct& c )
{
   if( c. isunit( ))
   {
      out << "1";
      return out;
   }

   for( auto p = c. repr. begin( ); p != c. repr. end( ); ++ p )
   {
      if( p != c. repr. begin( ))
         out << ".";
      out << *p;
   }

   return out;
}

*/
int powerproduct::power( ) const 
{
   int p = 0;
   for( auto pv : repr )
      p += pv. n;
   return p;
}
bool sort_numvar(const powvar &a, const powvar& b){
		return (a.v < b.v);
}


void powerproduct::normalize()
{
/*
		for(size_t i = 0; i < repr.size(); ++i){
				for(size_t j = i; j < repr.size(); ++j){
						if(repr[i].v == repr[j].v){
								repr[i].n += repr[j].n;
//								repr.erase(repr.begin() + j);
								--j;
						}
				}
		}
		for(size_t i = 0; i < repr.size(); ++i){
				if(repr[i].n == 0){
//						repr.erase(repr.begin()+i);
						--i;
				}
		}*/
//		std::sort(repr.begin(), repr.end(), sort_numvar);
}



int compare(const powerproduct& c1, const powerproduct& c2){
		if(c1.size() != c2.size())
				return -1;
		for(size_t i = 0; i < c1.size(); ++i)
				if(c1[i].v != c2[i].v || c1[i].n != c2[i].n)
						return -1;
		return 1;
}

powerproduct operator *(powerproduct c1, const powerproduct& c2){
		//c1.repr.insert(c1.repr.end(),c2.repr.begin(),c2.repr.end());
		for(size_t i = 0; i < c2.size(); ++i)
				c1.repr.size();
	//	c1[2].n = 20;	
		c1.normalize();
		return c1;
}
