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
    #include <vector>    

    #include "scanner.hh"
    #include "driver.hh"

    #undef  yylex
    #define yylex scanner.yylex

    Driver *driver;

}

%token                  NL
%token <int>	        INT
%token 			SOMME MULT DIV SUB PO PF FIN FOIS
%token			AVANCE SAUTE RECULE TOURNE		
%token			GAUCHE DROITE
%token <std::string>	IDTORT NOM RRGGBB

%token			DEVANT DERRIERE
%token			MUR VIDE
%token			SI DP SINON TANTQUE REPETE FONCTION
%token			MAIN 
%token			COULEUR CARAPACE MOTIF TORTUES JARDIN
%token			ARGS

%token <std::string>	FICHIER	


%left 			SOMME SUB
%right 			MULT DIV
%precedence		NEG



%type <float> nombre
%type <float> calcul

%type <int> tortue
%type <int> rotation
%type <int> instruction
%type <int> deplacement
%type <int> deplacement_tortue
%type <int> direction

%type <int> ligne
%type <int> main


%type <bool> condition

%%

tortue:
	FONCTION MAIN DP main FIN FONCTION NL fonction FIN {
		std::cout << "END" << std::endl;
		YYACCEPT;	
    }

nombre:
    INT {
        $$ = $1;
    }

calcul:
    nombre {
	$$ = $1;
    }
   | SUB calcul %prec NEG {
	$$=-$2;
   }
   | calcul SOMME calcul {
	$$ = $1 + $3;
    }
   | calcul MULT calcul {
	$$ = $1 * $3;
    }
   | calcul SUB calcul {
	$$ = $1 - $3;
    }
   | calcul DIV calcul {
	if($3!=0){
		$$ = $1 / $3;
	}
	else {
		std::cout << "IMPOSSIBLE : division par 0 " << std::endl;
		YYERROR;
	}
    }
   | PO calcul PF {
	$$ = $2;
    }


rotation:
	DROITE {
        driver.setrotation(rotation::droite);
	}
	| GAUCHE {
        driver.setrotation(rotation::gauche);
	}

instruction:
	AVANCE {
        	driver.ajoutAction(fonction::avance);
	}
	| RECULE {
        	driver.ajoutAction(fonction::recule);
	}
	| SAUTE {
        	driver.ajoutAction(fonction::saute);
	}
	| TOURNE rotation {
        	driver.ajoutAction(fonction::tourne);
	}


    
deplacement:
	instruction {
		$$=1;
	}
	| instruction calcul{
		$$=$2;
	}
	| instruction calcul FOIS{
		$$ = $2;
	}



deplacement_tortue:
	deplacement {
		$$=$1;
        driver.deplacerToutesTortue($$);
	}
	| deplacement IDTORT{
		$$=$1;
        driver.deplacerUneTortue($2[1]-48,$$);
	}

direction:
	DEVANT {
		driver.setDirection(direction::devant);
	}
	| DERRIERE {
		driver.setDirection(direction::derriere);
	}
	| rotation {}


condition :
	MUR direction {
		driver.setCondition(condition::mur);
	}
	| VIDE direction {		
		driver.setCondition(condition::vide);
	}


couleur:
	COULEUR zone RRGGBB IDTORT {
		driver.changerCouleurUneTortue($4[1]-48,$3);
	}
	| COULEUR zone RRGGBB {
		driver.changerCouleurTouteTortue($3);
	}
	| {}

zone:
	{ driver.setZone(zone::carapace); }
	| CARAPACE {
		driver.setZone(zone::carapace);
	}
	| MOTIF {
		driver.setZone(zone::motif);
	}

arguments:
	nombre arguments
	| {}


main:
	corpsdemain {
		driver.setTotalTortue(1);		//tortue par defaut
	}
	| corpsdemain TORTUES nombre{
		driver.setTotalTortue($3);
	} corpsdemain

corpsdemain:
	NL ligne {}

ligne:
	deplacement_tortue corpsdemain
	| SI condition DP corpsdemain FIN SI corpsdemain
	| SI condition DP corpsdemain SINON DP corpsdemain FIN SI corpsdemain
	| TANTQUE condition DP corpsdemain FIN TANTQUE corpsdemain
	| REPETE calcul fois DP corpsdemain FIN REPETE corpsdemain
	| couleur corpsdemain
	| NOM arguments corpsdemain {
		driver.ajoutFonction($1);
	}
	| JARDIN FICHIER corpsdemain {
		driver.changerTailleJardin($2);
	}
	| {}



fonction:
	FONCTION NOM DP {
		if(!driver.existeFonction($2)) YYERROR;	
		else driver.supprimerFonction($2);	//On supprime la fonction pour ne pas l'utiliser plusieurs fois 
	} corpsdefonction FIN FONCTION NL fonction
	| {}


corpsdefonction:
        NL lignefonction {}

lignefonction:
	deplacement_tortue corpsdefonction
	| SI condition DP corpsdefonction FIN SI corpsdefonction
	| SI condition DP corpsdefonction SINON DP corpsdefonction FIN SI corpsdefonction
	| TANTQUE condition DP corpsdefonction FIN TANTQUE corpsdefonction
	| REPETE calcul fois DP corpsdefonction FIN REPETE corpsdefonction
	| NOM arguments corpsdefonction 
	| instruction ARGS corpsdefonction
	| instruction ARGS FOIS corpsdefonction
	| {}
	


fois:
	FOIS
	| {}

%%

void yy::Parser::error( const location_type &l, const std::string & err_msg) {
    std::cerr << "Erreur : " << l << ", " << err_msg << std::endl;
}


/*
fonction main:
	tant que vide derriere:
		avance
	fin tant que
	si mur devant:
		saute
		si mur devant:
			repete 2*8:
				saute
			fin repete
		fin si
	sinon:
		saute
	fin si
	saute
fin fonction



conditionnelle:
	SI condition DP NL bloc_instruction FIN SI
	| SI condition DP NL bloc_instruction SINON DP NL bloc_instruction FIN SI
	| TANTQUE condition DP NL bloc_instruction FIN TANTQUE
	| REPETE calcul DP NL bloc_instruction FIN REPETE
	| bloc_instruction
	| NOM arguments


bloc_instruction:
	deplacement_tortue NL bloc_instruction
	| conditionnelle NL bloc_instruction
	| {}
*/









