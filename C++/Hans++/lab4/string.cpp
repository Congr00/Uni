#include "string.h"

char string::operator [] (size_t i) const{
	if(this->size() < i){
			throw(std::runtime_error("Out of bounds"));
	}
	return this->p[i];
}

char& string::operator [] (size_t i){
		if(this->size() < i){
				throw(std::runtime_error("Out of bound"));
		}
		return this->p[i];
}

std::ostream& operator << ( std::ostream& out, const string& s )
{
   for( char c : s)
		   out << c;
   return out; 
}

string& string::operator += (char c){
		char *newp = new char[this->size()+1];
		for(size_t i = 0; i < this->size(); i++)
				newp[i] = this->p[i];
		delete[] this->p;
		this->p = newp;
		this->p[this->size()] = c;
		this->len++;
		return *this;
}

string& string::operator += (const string& s){
		
		if(s.size() == this->size()){
			string tmp = s;
			for(size_t i = 0; i < tmp.size(); i++)
				*this += tmp[i];
			return *this;		
		}
		for(size_t i = 0; i < s.size(); i++){
				*this += s.p[i];
		}

	   return *this;	
}

string operator + (string s1, const string& s2){
		s1 += s2;
		return s1;
}

bool operator == (const string& s1, const string& s2){
		if(s1.size() == s2.size()){
			for(size_t i = 0; i < s1.size(); i++){
					if(s1[i] != s2[i]){
							return false;
				}	
			}
			return true;
		}
		return false;
}

bool operator != (const string& s1, const string& s2){
	return !(s1 == s2);
}

bool operator < (const string& s1, const string& s2){
	if(s1 == s2)
		return false;
	size_t i;
	for(i = 0; i < s1.size(), i < s2.size(); i++)
			if(s1[i] < s2[i])
					return false;	
	if((i + 1) == s1.size())
			return false;
	return true;
}

bool operator > (const string& s1, const string& s2){
	if(s1 == s2)
			return false;
	return !(s1 < s2);
}

bool operator <= (const string& s1, const string& s2){
	if(s1 == s2)
			return true;
	return s1 < s2;
}

bool operator >= (const string& s1, const string& s2){
	if(s1 == s2)
			return true;
	return s1 > s2;
}



