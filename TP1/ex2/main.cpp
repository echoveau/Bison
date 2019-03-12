#include "scanner.hh"

#include <iostream>

int main( int argc, char* argv[] ) {
    Scanner* lexer = new Scanner(std::cin, std::cout);
    while(lexer->yylex() != 0);
    
    std::cout << "Cette phrase contient : " << lexer->nbmot <<" mot" << std::endl;
	std::cout << "Cette phrase contient : " << lexer->nbnb <<" nombre" << std::endl;
	std::cout << "Cette phrase contient : " << lexer->nbsigne <<" signe" << std::endl;
    
    return 0;
}
