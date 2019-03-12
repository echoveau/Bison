%{

#include "scanner.hh"
#include <cstdlib>

#define YY_NO_UNISTD_H

using token = yy::Parser::token;

#undef  YY_DECL
#define YY_DECL int Scanner::yylex( yy::Parser::semantic_type * const lval, yy::Parser::location_type *loc )

/* update location on matching */
#define YY_USER_ACTION loc->step(); loc->columns(yyleng);

%}

%option c++
%option yyclass="Scanner"
%option noyywrap

%%

%{
    yylval = lval;
%}


$[0-9]+ {
    return token::ARGS;
}

"tortues" {
    return token::TORTUES;
}

"main" {
    return token::MAIN;
}
"si" {
    return token::SI;
}
"sinon" {
    return token::SINON;
}
"tant que" {
    return token::TANTQUE;
}
"repete" {
    return token::REPETE;
}
"fonction" {
    return token::FONCTION;
}
"jardin" {
    return token::JARDIN;
}


"pas de mur"|"vide" {
    return token::VIDE;
}	

"pas de vide"|"mur" {
    return token::MUR;
}


"à"?"droite" {
    return token::DROITE;
}

"à"?"gauche" {
    return token::GAUCHE;
}
"devant" {
    return token::DEVANT;
}
"derriere" {
    return token::DERRIERE;
}
":" {
    return token::DP;
}


"couleur" {
    return token::COULEUR;
}
"carapace" {
    return token::CARAPACE;
}
"motif" {
    return token::MOTIF;
}
	
"\s"* {
}


"tourne" {
    return token::TOURNE;
}

"saute" {
    return token::SAUTE;
}

"avance" {
    return token::AVANCE;
}

"recule" {
    return token::RECULE;
}

"saute" {
    return token::AVANCE;
}

"fois" {
    return token::FOIS;
}

"fin" {
    return token::FIN;
}

#[0-9a-fA-F]{6} {
    return token::RRGGBB;
}

"@"[0-9]+ {
    yylval->build<std::string>(yytext);
    return token::IDTORT;
}


[0-9]+ {
    yylval->build<int>(std::atoi(yytext));
    return token::INT;
}

"+" {
    return token::SOMME;
}

"*" {
    return token::MULT;
}

"-" {
    return token::SUB;
}

"/" {
    return token::DIV;
}

"(" {
    return token::PO;
}

")" {
    return token::PF;
}

'.+' {
    return token::FICHIER;
}
[A-Za-z]+ {
    return token::NOM;
}


((--.*)?"\n")+ {
    loc->lines();
    return token::NL;
}

.           {}

%%
