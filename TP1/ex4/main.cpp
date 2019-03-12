#include "scanner.hh"

#include <iostream>

int main( int argc, char* argv[] ) {
    Scanner* lexer = new Scanner(std::cin, std::cout);
    while(lexer->yylex() != 0);
    return 0;
}
