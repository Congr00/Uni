
#include "fifteen.h"

fifteen::fifteen(){
	size_t counter = 1;
	size_t elements = dimension*dimension;
	this->open_i = dimension - 1;
	this->open_j = dimension - 1;
	table[dimension-1][dimension-1] = 0;
	for(size_t i = 0; i < dimension; ++i)
			for(size_t j = 0; j < dimension, counter != elements; j++){
					table[i][j] = counter;
					counter++;
			}
}

fifteen::fifteen(std::initializer_list< std::initializer_list< size_t >> init){
		size_t i = 0, j = 0;
		for(auto it = init.begin(); it != init.end(); ++i, ++it){
				for(auto jt = it->begin(); jt != it->end(); ++j, ++jt){
						table[i][j] = *(jt);
						if(!table[i][j]){
								open_i = i;
								open_j = j;
						}
				}
				j = 0;
		}
}

std::ostream& operator << ( std::ostream& stream, const fifteen& f ){
	for(size_t i = 0; i < f.dimension; ++i){
			for(size_t j = 0; j < f.dimension; ++j){
					stream << std::setw(10) << f.table[i][j] << " ";
			}
			stream << std::endl;
	}
	return stream;
}

using position = std::pair< size_t, size_t > ;

position fifteen::solvedposition( size_t val ){
		if(val == 0)
			return { dimension-1, dimension-1 };
		return { (val - 1) / dimension, (val - 1) % dimension };
}

size_t fifteen::hashvalue( ) const{
		size_t hash = 1;
		for(size_t i = 0; i < dimension; ++i){
				for(size_t j = 0; j < dimension; ++j){
						size_t tmp = table[i][j];
						tmp *= i;
						tmp += i;
						tmp *= j;
						tmp -= j;
						hash *= tmp;
				}
		}
		return hash;
}
bool fifteen::equals( const fifteen& other ) const{
		if(this->dimension != other.dimension)
				return false;
		for(size_t i = 0; i < dimension; ++i)
				for(size_t j = 0; j < dimension; ++j){
						if(other.table[i][j] != table[i][j])
								return false;
				}
	return true;
}

bool fifteen::issolved( ) const{
		for(size_t i = 0; i < dimension; ++i)
				for(size_t j = 0; j < dimension; ++j){
						position solv = solvedposition(table[i][j]);
						if(solv.first != i || solv.second != j)
							return false;
				}
	return true;
}
void fifteen::makemove( move m ){
		switch(m){
				case move::up:
				if(open_i == 0)
					throw(illegalmove(m));
				else{
					table[open_i][open_j] = table[open_i-1][open_j];
					table[open_i-1][open_j] = 0;
					open_i--;
				}
				break;
				case move::down:
				if(open_i+1 == dimension)
						throw(illegalmove(m));
				else{
					table[open_i][open_j] = table[open_i+1][open_j];
					table[open_i+1][open_j] = 0;
					open_i++;
				}
				break;
				case move::left:
				if(open_j == 0)
						throw(illegalmove(m));
				else{
				    table[open_i][open_j] = table[open_i][open_j-1];
					table[open_i][open_j-1] = 0;
					open_j--;
				}
				break;
				case move::right:
				if(open_j + 1 == dimension)
						throw(illegalmove(m));
				else{
					table[open_i][open_j] = table[open_i][open_j+1];
					table[open_i][open_j+1] = 0;
					open_j++;
				}
				break;
		}
}

position fifteen::get_pos(size_t val) const{
	for(size_t i = 0; i < dimension; ++i)
		for(size_t j = 0; j < dimension; ++j)
			if(table[i][j] == val)
				return {i,j};
	return {0,0};
}

size_t fifteen::distance( ) const{
		size_t result = 0;
		for(size_t i = 0; i < dimension*dimension; ++i)
			result += distance(get_pos(i),solvedposition(i));
		
		return result;
}














