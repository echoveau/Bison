%{

#include "scanner.hh"

#define YY_NO_UNISTD_H

%}

%option c++
%option yyclass="Scanner"
%option noyywrap



%%

[a-zA-Z]+     {
	++nbmot;
}

(("+"|"-")?([0-9]{1,3}(" "[0-9]{3})*(","[0-9]+)?))       {
	++nbnb;
}

([	]|[ ])+	{
}

.           {
	++nbsigne;
}

%%





//  [0-9]{1,3}  De 1 à 3 chiffres
//  [0-9]{3}	3chiffres

//	(+|-)?		[0-9]{1,3}( [0-9]{3})*(,?([0-9])+)

