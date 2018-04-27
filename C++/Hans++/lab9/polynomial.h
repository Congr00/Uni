
#ifndef POLYNOMIAL_INCLUDED
#define POLYNOMIAL_INCLUDED 1

#include "powerproduct.h"
#include <map>

template< typename N >
struct polynomial 
{

   std::map< powerproduct, N, powerproduct::cmp > repr;

   using maptype = std::map< powerproduct, N, powerproduct::cmp > ;

   typename maptype::iterator begin( ) { return repr. begin( ); }
   typename maptype::iterator end( ) { return repr. end( ); }

   typename maptype::const_iterator cbegin( ) const { return repr. cbegin( ); }
   typename maptype::const_iterator cend( ) const { return repr. cend( ); }

   typename maptype::const_iterator begin( ) const { return cbegin( ); }
   typename maptype::const_iterator end( ) const { return cend( ); }


   const N& operator [] ( const powerproduct& c ) const
      { return repr[c]; }

   N& operator [] ( const powerproduct& c ) 
      { return repr[c]; }


   polynomial( )
      { } 
    
   polynomial( const powerproduct& chain ) 
   {
      repr[ chain ] = 1;
   }     

   template< typename D > 
   polynomial( const D& d )
   {
      repr[ {} ] = d; 
   }

   polynomial operator - ( )
   {
      auto res = *this;
      for( auto& p : res. repr )
         p. second = - p. second;
      return res;
   }
   
   polynomial& operator += ( const polynomial& pol )
   {
      for( const auto& p : pol. repr )
      {
         (*this)[ p. first ] += p. second;
      }
      return *this; 
   }

   polynomial& operator -= ( const polynomial& pol )
   {
      for( const auto& p : pol. repr )
         (*this) [ p. first ] -= p. second;
      return *this; 
   }

   template<typename X > polynomial<N> & operator *= ( X x )
   {
      for( auto& p : *this )
         p. second *= x;
      return *this; 
   }

   template< typename X > polynomial<N> & operator /= ( X x )
   {
      for( auto& p : *this )
         p. second /= x;
      return *this;
   }

};


template< typename M, typename N >
polynomial<M> operator * ( polynomial<M> pol, N n )
{
   pol *= n;
   return pol;
}


template< typename M, typename N >
polynomial<M> operator / ( polynomial<M> pol, N n )
{
   pol /= n;
   return pol;
}


template< typename M, typename N >
polynomial<N> operator * ( M m, polynomial<N> pol )
{
   pol *= m;
   return pol;
}


template< typename N >
std::ostream& operator << ( std::ostream& out, const polynomial<N> & pol )
{
   bool somethingprinted = false; 

   for( auto p = pol. begin( ); p != pol. end( ); ++ p )
   {
      if( p -> second != 0 )
      {
         if( somethingprinted )
            out << " + ";
         if( p -> second != 1 )
            out << ( p -> second ) << ".";
         out << ( p -> first );

         somethingprinted = true; 
      }
   }

   if( !somethingprinted )
      out << N{0};

   return out;
}


#endif 


