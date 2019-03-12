%{

#include "scanner.hh"

#define YY_NO_UNISTD_H

%}

%option c++
%option yyclass="Scanner"
%option noyywrap

%%

[a-zA-Z]+      {
    std::cout << YYText();
}


^([	]|[ ])+	{

}

([	]|[ ])+	{
    std::cout<<" ";
}


.           {
    std::cout << "Je ne sais pas ce que c'est :      '" << YYText() << "'" << std::endl;
}

%%
