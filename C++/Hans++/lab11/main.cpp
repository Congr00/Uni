#include <iostream>
#include <cmath>
#include <vector>

struct surf {
   	virtual double area( ) const = 0;
   	virtual double circumference( ) const = 0;
   	virtual surf* clone( ) const & = 0;
   	virtual surf* clone( ) && = 0;
   	virtual void print( std::ostream& ) const = 0;
   	virtual ~surf( ) = default;
};
struct rectangle : public surf {
   	double x1, y1;
   	double x2, y2;
	double area( ) const override{
		return abs(x2 - x1) * abs(y2 - y1);
	}
	double circumference( ) const override{
		return abs(x2 - x1)*2 + abs(y2 - y1)*2;
	}
	rectangle* clone( ) const & override{
		return new rectangle{ *this };
	}
	rectangle* clone( ) && override{
		return new rectangle(std::move(*this));
	}
	void print( std::ostream& s) const override{
		s << "Position:\n(" << x1 << "," << y1 << "), (" << x2 << "," << y2 << ")\narea:\n"
				<< this->area() << "\ncircumference:\n" << this->circumference() << "\n";
		return;
	}
    rectangle(double x1, double y1, double x2, double y2){
        this->x1 = x1;
        this->x2 = x2;
		this->y1 = y1;
		this->y2 = y2;		
    }
};
struct triangle : public surf {
   	double x1, y1; // Positions of corners. 
	double x2, y2; 
	double x3, y3;
	double area( ) const override{
		double x12 = sqrt(pow(x2 - x1,2) + pow(y2 - y1,2));
		double x23 = sqrt(pow(x2 - x3,2) + pow(y2 - y3,2));
		double x31 = sqrt(pow(x3 - x1,2) + pow(y3 - y1,2));
		double s = (x12 + x23 + x31)/2;
		return sqrt(s * (s - x12) * (s - x23) * (s - x31));
	}
	double circumference( ) const override{
		return sqrt(pow(x2 - x1,2) + pow(y2 - y1,2)) +
					sqrt(pow(x2 - x3,2) + pow(y2 - y3,2)) +
					sqrt(pow(x3 - x1,2) + pow(y3 - y1,2));
	}
	triangle* clone( ) const & override{
		return new triangle{ *this };
	}
	triangle* clone( ) && override{
		return new triangle{ std::move(*this) };
	}
	void print( std::ostream& s) const override{
		s << "Position:\n(" << x1 << "," << y1 << "), (" << x2 << "," << y2 << "), (" 
				<< x3 << "," << y3 << ")\narea:\n" << this->area() << "\ncircumference:\n" 
				<< this->circumference() << "\n";
		return;
	}
	triangle(double x1, double y1, double x2, double y2, double x3, double y3){
		this->x1 = x1;
		this->x2 = x2;
		this->x3 = x3;
		this->y1 = y1;
		this->y2 = y2;
		this->y3 = y3;
	}
};
struct circle : public surf {
   	double x; // Position of center. 
	double y; 
	double radius;
	double area( ) const override{
		return M_PI * radius * radius;
	}
	double circumference( ) const override{
		return 2 * M_PI * radius;
	}
	circle* clone( ) const & override{
		return new circle{ *this  };
	}
	circle* clone( ) && override{
		return new circle{ std::move(*this) };
	}
	void print( std::ostream& s) const override{
		s << "Position:\n(" << x << "," << y << "); radius: " << radius << "\narea:\n" << this->area()
				<< "\ncircumference:\n" << this->circumference() << "\n";
	}
	circle(double x, double y, double r){
			this->x = x;
			this->y = y;
			this->radius = r;
	}
};

struct surface{
	surf* ref;

	surface(const surf& s)
		: ref{ s.clone() } {}
	surface(surf&& s)
		: ref{ std::move(s).clone() } {}

	surface(const surface& s)
		: ref{ s.ref->clone() } {}
	surface(surface&& s)
		: ref{ std::move(*s.ref).clone() } {}

	void operator = (const surface& s){
		*this = surface(s);
	}
	void operator = (surface&& s){
		std::swap(ref,s.ref);
	}
	void operator = (const surf& s){
		if(&s != ref){
			delete ref;
			ref = s.clone();	
		}
	}
	void operator = (surf&& s){
		if(&s != ref){
			delete ref;
			ref = std::move(s).clone();	
		}
	}

	~surface(){
		delete ref;
	}

	const surf& getsurf() const { return *ref; }

};

std::ostream& operator << (std::ostream& stream, const surface& s){
	s.ref->print(stream);
	return stream;
}

std::ostream& operator << (std::ostream& stream, const std::vector<surface>& table){
	for(size_t i = 0; i < table.size(); ++i)
		stream << i << "-th element = \n" << table[i] << "\n";
	return stream;
}

void print_statistics(const std::vector<surface>& table){
	double total_area = 0.0;
	double total_circumference = 0.0;
	for(const auto s : table){
		std::cout << "adding info about " << s << "\n";
		total_area += s.getsurf().area();
		total_circumference += s.getsurf().circumference();
	}
	std::cout << "total area is " << total_area << "\n";
	std::cout << "total circumference is " << total_circumference << "\n";
}

int main(void){

	std::vector<surface> table;
	rectangle rec(0,5,5,0);
	table.push_back((new rectangle(0,5,5,0)));
	std::cout << table;
    return 0;
}
