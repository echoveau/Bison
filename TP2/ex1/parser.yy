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
%token <int>	        INT
%token 			SOMME
%token 			MULT
%token 			PO
%token 			PF
%token			FIN

%left 			SOMME
%left 			MULT

%type <float> nombre
%type <float> calcul

%%

listeNombre:
	calcul NL {
		std::cout << "RESULTAT : "<< $1 << std::endl;
		std::cout<<std::endl;
	} listeNombre

    	| FIN {
		std::cout<<std::endl;
		std::cout << "END" << std::endl;
		return 0;	
    	}

    	| calcul {
		std::cout << "RESULTAT : "<< $1 << std::endl;
		std::cout<<std::endl;
		std::cout << "END" << std::endl;
	} FIN {
	
		return 0;    	
	}


nombre:
    INT {
        std::cout << "entier: " << $1 << std::endl;
        $$ = $1;
    }


calcul:
    nombre {
	$$ = $1;
    }
   | calcul SOMME calcul {
	$$ = $1 + $3;
	std::cout << "somme: " << $$ << std::endl;
    }
   | calcul MULT calcul {
	$$ = $1 * $3;
	std::cout << "multiplication: " << $$ << std::endl;
    }
   | PO calcul PF {
	$$ = $2;
    }
    
%%

void yy::Parser::error( const location_type &l, const std::string & err_msg) {
    std::cerr << "Erreur : " << l << ", " << err_msg << std::endl;
}











