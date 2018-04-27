#include <map>
#include <unordered_map>
#include <vector>
#include <iostream>
#include <string>

#include "vectortest.h"

template< typename C = std::less<std::string>>
std::map<std::string, unsigned int, C> frequencytable(const std::vector<std::string>& text){
	std::map<std::string, unsigned int, C> result;
	for(auto i : text){
			result[i]++;
	}
	return result;
}
template<typename C>
std::ostream&
operator << (std::ostream& stream, const std::map<std::string, unsigned int, C> & freq){
		for(auto i : freq){
				stream << i.first  << " " << i.second << "\n";
		}
		return stream;
}



struct case_insensitive_cmp{
		bool operator()(const std::string& s1, const std::string& s2) const{
				size_t i;
				size_t s = s1.size();
				if(s < s2.size())
						return true;
				else if(s2.size() < s)
						return false;
//				if(s1.size() > s2.size())
//						s = s2.size();
				for(i = 0; i < s; ++i){
						int chr;
						int chr2;
						if((int)s1[i] < 91)
							chr = (int)s1[i] + 32;
						else
							chr = (int)s1[i];
						if((int)s2[i] < 91)
							chr2 = (int)s2[i] + 32;
						else
							chr2 = (int)s2[i];

					//	std::cout << (char)chr << " " << (char)chr2 << "\n";

						if(chr < chr2)
								return false;
						else if(chr > chr2)
								return true;
				}
				return false;
		}
};

struct case_insensitive_hash{
		size_t operator() (const std::string& s) const{
				size_t res = 0;
				for(auto c : s){
					if((int)c < 91)
							c += 32;
					res += (int)c;
					res *= 4;
					res /= 3;
				}
				return res;
		}
};
struct case_insensitive_equality
{
		bool operator() (const std::string& s1, const std::string& s2) const{
				if(s1.size() != s2.size())
						return false;
				for(size_t i = 0; i < s1.size(); i++){
					char f;
					char s;
					if(s1[i] < 91)
							f = s1[i] + 32;
					else
							f = s1[i];
					if(s2[i] < 91)
							s = s2[i] + 32;
					else
							s = s2[i];
					if(f != s)
							return false;
				}
				return true;
		}
};

std::unordered_map<std::string, unsigned int, case_insensitive_hash, case_insensitive_equality>
hashed_frequencytable(const std::vector<std::string>& text){
	std::unordered_map<std::string, unsigned int, case_insensitive_hash, case_insensitive_equality> result;
	for(auto i : text){
			result[i]++;
	}
	return result;
}
std::ostream&
operator << (std::ostream& stream, const std::unordered_map<std::string, unsigned int, case_insensitive_hash, case_insensitive_equality>& freq){
		for(auto i : freq){
			 stream << i.first << " " << i.second << "\n";
		}
		return stream;
}

int main(){

		std::cout << frequencytable(std::vector<std::string> {"AA", "aA", "Aa", "this", "THIS", "THIS"});
		std::cout << "with\n";
		std::cout << frequencytable<case_insensitive_cmp>(std::vector<std::string>{"AA", "aA", "Aa", "this", "THIS","THIS"});
		case_insensitive_cmp c;
		std::cout << c( "a", "A" ) << c( "a","b" ) << c( "A", "b" ) << "\n";
		case_insensitive_hash h;
		case_insensitive_equality e;
		std::cout << h("xxx") << " " << h("XXX") << "\n";
		std::cout << h("Abc") << " " << h("abC") << "\n";
		std::cout << e("xxx", "XXX") << "\n";
		std::cout << hashed_frequencytable(std::vector<std::string>{"AA", "aA", "Aa", "this", "THIS", "THIS"});	
		std::ifstream inp{"book"};
		std::vector<std::string> book = vectortest::readfile(inp);
		std::unordered_map<std::string, unsigned int, case_insensitive_hash, case_insensitive_equality> map = 
		hashed_frequencytable(book);
		std::cout << map["magnus"] << " " << map["hominum"] << " " << map["memoria"] << "\n";
		size_t max = 0;
		std::string w = "";
		for(auto i  : map){
			if(i.second > max){
					max = i.second;
					w = i.first;
			}
		}
		std::cout << "most occurence: " << w << " of: " << max << "\n";

		return 0;
}
