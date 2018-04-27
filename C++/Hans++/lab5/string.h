#ifndef STRING_INCLUDED 
#define STRING_INCLUDED 1

#include <iostream> 
#include <cstring>
#include <string.h>
#include <stdexcept>

class string
{
   size_t len;
   size_t capacity;
   char *p; 


public: 
   string( )
      : len{0},
	capacity{0},
        p{ nullptr }   // Works, see the slides. 
   { }

   string( const char* s )
      : len{ strlen(s) },
	   capacity{len},
        p{ new char[ len ] }
   {
      for( size_t i = 0; i < len; ++ i )
         p[i] = s[i]; 
   }

   string( const string& s )
      : len{ s. len },
	capacity{len},
        p{ new char[ len ] }
   {
      for( size_t i = 0; i < len; ++ i )
         p[i] = s.p[i]; 
   }

   void check_capacity(size_t val);
   void operator = ( const string& s )
   { 
      if( len != s.len )
      {
         delete[] p; 
         len = s. len;
	 capacity = len;
         p = new char[ len ];
      }

      for( size_t i = 0; i < len; ++ i )
         p[i] = s.p[i];
   }

   size_t size( ) const { return len; }

   ~string( )
   {
      delete[] p;
   }

   char operator [] (size_t i) const;
   char& operator [] (size_t i); 
  string& operator += (char c);
  string& operator += (const string& s);

	using iterator = char*;
	using const_iterator = const char*;
	const_iterator begin() const {return p;}
	const_iterator end() const {return p + len;}
	iterator begin() {return p;}
	iterator end() {return p + len;}


};

bool operator == (const string& s1, const string& s2);
bool operator != (const string& s1, const string& s2);
bool operator < (const string& s1, const string& s2);
bool operator > (const string& s1, const string& s2);
bool operator <= (const string& s1, const string& s2);
bool operator >= (const string& s1, const string& s2);


std::ostream& operator << ( std::ostream& out, const string& s );
string operator + (string s1, const string& s2);
#endif

