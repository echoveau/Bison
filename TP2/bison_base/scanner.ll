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


[0-9]+      {
    yylval->build<int>(std::atoi(yytext));
    return token::NUMBER;
}

[0-9]+("."[0-9]+)?  {
    yylval->build<float>(std::atof(yytext));
    return token::REAL;
}

"\n"          {
    loc->lines();
    return token::NL;
}

.           {}

%%
