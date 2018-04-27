
#include "tree.h"

// Easiest way to implement Rvalue assignment is by swap.

void tree::operator = (tree&& t){
	std::swap( pntr, t. pntr );
}

void tree::operator = (const tree& t){
		*this = tree(t); // tree(t) is a temporary variable which will bind
			// to Rvalue assignment.
}			

const string& tree::functor() const{
	return pntr->f;
}

const tree& tree::operator [] (size_t i) const{
	return pntr->subtrees[i];
}

size_t tree::nrsubtrees() const{
	return pntr->subtrees.size();
}

tree::~tree(){
	this->pntr->refcnt--;
	if(!this->pntr->refcnt){
		delete pntr;
	}
}

std::ostream& operator << (std::ostream& stream, const tree& t){
	stream << t.functor() << " <-root ";
	for(size_t i = 0; i < t.nrsubtrees(); i++){
		stream << t[i] << " endroot ->\n";
	}
	return stream;
}

void tree::ensure_not_shared(){
	if(this->pntr->refcnt != 1){
		trnode* nnode = new trnode(this->pntr->f, this->pntr->subtrees,1);
		this->pntr->refcnt--;		
		this->pntr = nnode;
	}
}

//string& tree::functor(){
//	ensure_not_shared();
//	return this->pntr->f;
//}

tree subst( const tree& t, const string& var, const tree& val ){
	if(t.nrsubtrees() == 0 && t.functor() == var){
			return val;
	}
	tree res = t;
	for(size_t i = 0; i < res.nrsubtrees(); i++)
			res.replacesubtree(i, subst(res[i],var, val));	
	return res;
}

void tree::replacesubtree( size_t i, const tree& t ){

	if(this->pntr->subtrees[i].pntr != t.pntr){
		pntr->subtrees[i].ensure_not_shared();
		pntr->subtrees[i] = t;	
	}
}
	// Replace i-th subtree.
void tree::replacefunctor( const string& f ){	
		this->ensure_not_shared();
		this->pntr->f = f;
}


int tree::changed = 0;




