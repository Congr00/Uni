
#include "tree.h"


int main( int argc, char* argv [ ] )
{
   tree t1( string( "a" ));
   std::cout<<t1.getaddress()<<"\n";	
   //tree t5(string("t"));
   t1 = t1;	
   t1 = std::move(t1);
   std::cout<<t1.getaddress()<<"\n";
   tree t2( string( "b" )); 
   tree b(string("b"), {tree(string("b"))});
   tree a(string("a"), {tree(string("a"))});
   tree t3 = tree( string( "f" ), { t1, t2 } );  
   std::vector< tree > arguments = { t1, t2, t3 };
   std::cout << tree( "F", std::move( arguments )) << "\n";
   t2 = t3;
   t2 = std::move(t3);
   //t3[0].replacefunctor("newa");
   t2.replacefunctor("newf");
   std::cout << t2 << "\n" << t3 << "\n";
   tree t4(string("t4"), {t1,t2,t3});
   std::cout << t4 << "\n";

   t4.print_all_addreses();
   std::cout<<"\n";
   tree t7 = subst(t4, "b", t1);
   t7 = subst(t7, "a", b);
   t7 = subst(t7, "b", a);
   tree t9 = tree(string("t1"), {tree(string("t2"),{tree(string("t3"),{tree(string("t4"), {tree(string("t5"),{tree(string("t6"),{tree(string("t7"),{tree(string("t8")), tree(string("t8"))})})})})})})});
   t9.print_all_addreses();
   t9 = subst(t9, "t8", t7);
	std::cout<<t9;
	tree t8 = t9;
	t9 = t9;
	t9 = std::move(t9);
	tree t10 = t9;
	std::cout<<t10;
}




