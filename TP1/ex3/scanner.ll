%{

#include "scanner.hh"

#define YY_NO_UNISTD_H

%}

%option c++
%option yyclass="Scanner"
%option noyywrap

%%

(("+"|"-")?([0-9]{1,3}(" "[0-9]{3})*(","[0-9]+)?))     {
    std::cout << "J'ai détecté un chiffre : '" << YYText() << "'" << std::endl;
}


begin|end	{
	std::cout << "J'ai détecté un mot-clefs : '" << YYText() << "'" << std::endl;
}


([a-zA-Z]([a-zA-Z]|[0-9])*)	{
	std::cout << "J'ai détecté un identificateur : '" << YYText() << "'" << std::endl;
}

(["+"]|["-"]|["*"]{1,2})	{
	std::cout << "J'ai détecté un identificateur : '" << YYText() << "'" << std::endl;
}

(" "|"	")* {
}

.           {
    std::cout << "Je ne sais pas ce que c'est : '" << YYText() << "'" << std::endl;
}

%%
