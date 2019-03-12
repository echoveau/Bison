%{

#include "scanner.hh"

#define YY_NO_UNISTD_H

%}

%option c++
%option yyclass="Scanner"
%option noyywrap

%%

["]([a-zA-Z]|" ")*["]   {
    std::cout << "Chaine de caractères : " << YYText() << std::endl;
}

["]([a-zA-Z]|" "|\\\")*["]   {
    std::cout << "Chaine de caractères : " << YYText() << std::endl;
}

.           {
    std::cout << "Je ne sais pas ce que c'est : '" << YYText() << "'" << std::endl;
}

%%




//   "Galilee a dit \"la terre tourne\" "

//	["]([a-zA-Z]|" ")*([\"]([a-zA-Z]|" ")*[\"])*([a-zA-Z]|" ")*["] 

