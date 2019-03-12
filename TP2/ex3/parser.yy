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
%token <float>	        FLOAT
%token 			SOMME
%token 			MULT
%token 			DIV
%token 			SUB
%token 			PO
%token 			PF
%token			FIN
%token			EG
%token <std::string>    VAR
%token			INF
%token			SUP
%token			EGEG
%token			DIF
%token			ET
%token			OU
%token			XOU


%right			ET OU XOU
%left			EG SUP INF EGEG DIF
%left 			SOMME SUB
%left 			MULT DIV
%precedence		NEG


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
		YYACCEPT;	
    	}

    	| calcul {
		std::cout << "RESULTAT : "<< $1 << std::endl;
		std::cout<<std::endl;
		std::cout << "END" << std::endl;
	} FIN {
	
		YYACCEPT;    	
	}


nombre:
	INT {
        	std::cout << "entier: " << $1 << std::endl;
        	$$ = $1;
    	}
    	| FLOAT {
		std::cout << "decimal: " << $1 << std::endl;
    	    	$$ = $1;
    	}
    	| VAR {
    	    	$$ = driver.getVariable($1);
    		std::cout << "variable: "<< $1<< "(=" << $$ <<")" << std::endl;
    	}
   


calcul:
    	nombre {
		$$ = $1;
	}
	| calcul XOU calcul {
		$$ = (!$1 != !$3);
		if($$==0) std::cout<<"Faux"<<std::endl;
		if($$==1) std::cout<<"Vrai"<<std::endl;
	}
	| calcul OU calcul {
		$$ = ($1 || $3);
		if($$==0) std::cout<<"Faux"<<std::endl;
		if($$==1) std::cout<<"Vrai"<<std::endl;
	}
	| calcul ET calcul {
		$$ = ($1 && $3);
		if($$==0) std::cout<<"Faux"<<std::endl;
		if($$==1) std::cout<<"Vrai"<<std::endl;
	}
	| calcul DIF calcul {
		$$ = ($1!=$3);
		if($$==0) std::cout<<"Faux"<<std::endl;
		if($$==1) std::cout<<"Vrai"<<std::endl;
	}
	| calcul EGEG calcul {
		$$ = ($1==$3);
		if($$==0) std::cout<<"Faux"<<std::endl;
		if($$==1) std::cout<<"Vrai"<<std::endl;
	}
	| calcul SUP calcul {
		$$ = ($1>$3);
		if($$==0) std::cout<<"Faux"<<std::endl;
		if($$==1) std::cout<<"Vrai"<<std::endl;
	}
	| calcul INF calcul {
		$$ = ($1<$3);
		if($$==0) std::cout<<"Faux"<<std::endl;
		if($$==1) std::cout<<"Vrai"<<std::endl;
	}
	| calcul EG calcul {
		$$ = ($1==$3);
		if($$==0) std::cout<<"Faux"<<std::endl;
		if($$==1) std::cout<<"Vrai"<<std::endl;
	}
	| VAR EG calcul {
		$$ = $3; 
		driver.setVariable($1, $3);
	}
	| SUB calcul %prec NEG {
		$$=-$2;
		std::cout << "opposé: " << $$ << std::endl;
	}
	| calcul SOMME calcul {
		$$ = $1 + $3;
		std::cout << "somme: " << $$ << std::endl;
	}
	| calcul MULT calcul {
		$$ = $1 * $3;
		std::cout << "multiplication: " << $$ << std::endl;
	}
	| calcul SUB calcul {
		$$ = $1 - $3;
		std::cout << "soustraction: " << $$ << std::endl;
	}
	| calcul DIV calcul {
		if($3!=0){
			$$ = $1 / $3;
			std::cout << "division: " << $$ << std::endl;
		}
		else {
			std::cout << "IMPOSSIBLE " << std::endl;
			YYERROR;
		}
	}
	| PO calcul PF {
		$$ = $2;
	}

    
%%

void yy::Parser::error( const location_type &l, const std::string & err_msg) {
    std::cerr << "Erreur : " << l << ", " << err_msg << std::endl;
}











