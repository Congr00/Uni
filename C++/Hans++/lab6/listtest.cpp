
#include "listtest.h"

#include <random>
#include <chrono>
#include <algorithm>

void listtest::sort_move( std::list< std::string > & v )
{
}

std::ostream&
operator << (std::ostream& out, const std::list<std::string> & list){
	for(auto i : list)
			out << i << "\n";
	return out;
}


