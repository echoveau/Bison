%skeleton "lalr1.cc"
%require "3.0"

%defines
%define parser_class_name { Parser }
%define api.value.type variant
%define parse.assert

%locations

%code requires{
    class Scanner;
    class Driver;
}

%parse-param { Scanner &scanner }
%parse-param { Driver &driver }

%code{
    #include <iostream>
    #include <string>
    
    #include "scanner.hh"
    #include "driver.hh"

    #undef  yylex
    #define yylex scanner.yylex
}

%token                  NL
%token <int>            NUMBER
%token <float>          REAL

%type <float> nombre
%type <float> listeNombre

%%

listeNombre:
        {
        $$ = 0;
    }
    | nombre NL listeNombre {
        $$ = $1 + $3;
        std::cout << "somme: " << $$ << std::endl;
    }

nombre:
    REAL {
        std::cout << "décimal: " << $1 << std::endl;
        $$ = $1;
    }
    | NUMBER {
        std::cout << "entier: " << $1 << std::endl;
        $$ = $1;
    }
    
%%

void yy::Parser::error( const location_type &l, const std::string & err_msg) {
    std::cerr << "Erreur : " << l << ", " << err_msg << std::endl;
}
