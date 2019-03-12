#include "driver.hh"
#include "jardinRendering.hh"
#include <iostream>
#include <fstream>
#include <sstream>
#include <stdio.h>
#include <string>
#include <vector>


Driver::Driver(JardinRendering * J) {
    monJardin = J;
}

Driver::~Driver() {
        delete monJardin;
}


void Driver::changerPosition(int n, int x, int y) {
    monJardin->changePosition(n,x,y);
}

void Driver::changerOrientation(int n,float o){
        monJardin->changeOrientation(n,o);
}

void Driver::avance(int n, int nbdeplacemnts){
    int o= monJardin->orientation(n);
    int x=get_x(n);
    int y=get_y(n);

    if(o==0){
        for(int i=0; i<nbdeplacemnts;++i)
            --y;
        monJardin->changePosition(n,x,y);
    }
    else if(o==90){
        for(int i=0; i<nbdeplacemnts;++i)
            ++x;

        monJardin->changePosition(n,x,y);
    }
    else if(o==180){
        for(int i=0; i<nbdeplacemnts;++i)
            ++y;

        monJardin->changePosition(n,x,y+1);
    }
    else{
        for(int i=0; i<nbdeplacemnts;++i)
            --x;
        monJardin->changePosition(n,x-1,y);
    }
}


int Driver::get_x(int n){
    return (monJardin->position(n).x());
}

int Driver::get_y(int n){
    return (monJardin->position(n).y());
}

float Driver::get_orientation(int n){
    return  monJardin->orientation(n);
}


void Driver::recule(int n,int nbdeplacemnts){
    int o= monJardin->orientation(n);
    int x=get_x(n);
    int y=get_y(n);

    if(o==0){
        for(int i=0; i<nbdeplacemnts;++i)
            ++y;
        monJardin->changePosition(n,x,y);
    }
    else if(o==90){
        for(int i=0; i<nbdeplacemnts;++i)
            --x;

        monJardin->changePosition(n,x,y);
    }
    else if(o==180){
        for(int i=0; i<nbdeplacemnts;++i)
            --y;

        monJardin->changePosition(n,x,y+1);
    }
    else{
        for(int i=0; i<nbdeplacemnts;++i)
            ++x;
        monJardin->changePosition(n,x-1,y);
    }
}


void Driver::saute(int n, int nbdeplacemnts) {
    float o=monJardin->orientation(n);
    int x=get_x(n);
    int y=get_y(n);

    for(int i=0; i<n; ++i) {
        if(o==0) {
            if(monJardin->estMur(x,y-1))
                monJardin->changePosition(n,x,y-2);
        }
        else if(o==90) {
            if(monJardin->estMur(x+1,y))
                monJardin->changePosition(n,x+2,y);
        }
        else if(o==-180) {
            if(monJardin->estMur(x-1,y))
                monJardin->changePosition(n,x-2,y);
        }
        else {
            if(monJardin->estMur(x,y+1))
                monJardin->changePosition(n,x,y+2);
        }
    }
}

void Driver::tourne(int n, int nbdeplacemnts) {
    if(_rotation==rotation::droite)
        monJardin->changeOrientation(n, nbdeplacemnts*90);
    else if(_rotation==rotation::gauche)
        monJardin->changeOrientation(n, nbdeplacemnts*-90);

}



void Driver::changerCouleurUneTortue(int num, std::string rgb) {
    int r=std::stoi(rgb.substr(1,2),nullptr,16);
    int g=std::stoi(rgb.substr(3,2),nullptr,16);
    int b=std::stoi(rgb.substr(5,2),nullptr,16);


    if(_zone==zone::carapace)
        monJardin->changeCouleurCarapace(num,r,g,b);
    else if(_zone==zone::motif)
        monJardin->changeCouleurMotif(num,r,g,b);
}

void Driver::changerCouleurTouteTortue(std::string rgb) {
    for(unsigned int i=0; i<_totalTortue; ++i)
            changerCouleurUneTortue(i,rgb);
}

void Driver::ajoutFonction(std::string const &nom) {
        _nomFonction.push_back(nom);
}

void Driver::ajoutAction(fonction const &f){
        _action.push_back(f);
}

bool Driver::existeFonction(std::string const &nom) {
	for(auto const &n : _nomFonction) {
		if(n==nom) return true;
	}
	return false;
}


void Driver::supprimerFonction(std::string const &nom) {
	for(auto const &n : _nomFonction) {
		if(n==nom) {
			_nomFonction.erase(_nomFonction.begin());
			break;
		}
	}
}



void Driver::changerTailleJardin(std::string const &f) {
    int nbligne=0;
    int nbcol=0;
    std::string ligne, l;
    std::string fich=f.substr(1,f.size()-2); //On supprime les guillemets
    std::ifstream fichier(fich, std::ios::in);

    if(fichier) {
        while(std::getline(fichier, ligne)) {
            nbligne++;
            if(nbligne==1) {    //compte le nombre de caractere sur la ligne 1 pour determiner numcol
                std::istringstream issligne(ligne);
                issligne >> l;
                nbcol=l.size();
            }
        }
    }
    else std::cout << "Fichier introuvable";

    monJardin->changeTailleJardin(nbcol,nbligne);
}


bool Driver::conditionUneTortue(int n, condition const &c) {
    float orien=monJardin->orientation(n);
    int x=get_x(n);
    int y=get_y(n);

    if(orien==0) {
        if(c==condition::mur)
            return monJardin->estMur(x,y-1);
        else if(c==condition::vide)
            return monJardin->estVide(x,y-1);
    }
    else if(orien==90) {
        if(c==condition::mur)
            return monJardin->estMur(x+1,y);
        else if(c==condition::vide)
            return monJardin->estVide(x+1,y);
    }
    else if(orien==-90) {
        if(c==condition::mur)
            return monJardin->estMur(x-1,y);
        else if(c==condition::vide)
            return monJardin->estVide(x-1,y);
    }
    else {
        if(c==condition::mur)
            return monJardin->estMur(x,y+1);
        else if(c==condition::vide)
            return monJardin->estVide(x,y+1);
    }

}

bool Driver::conditionTouteTortue(condition const &c) {
    for(int i=0; i<monJardin->getTortues().size(); ++i) {
        conditionUneTortue(i,c);
    }
}




void Driver::deplacerUneTortue(int n, int nbpas){
    for(int i=0;i<nbpas;++i){
        if(_action[_numaction]==fonction::avance) Driver::avance(n,1);
        else if(_action[_numaction]==fonction::recule) Driver::recule(n,1);
        else if(_action[_numaction]==fonction::saute) Driver::saute(n,1);
        else if(_action[_numaction]==fonction::tourne) Driver::tourne(n,1);

        _numaction++;
    }
}




void Driver::deplacerToutesTortue(int nbpas){
    for(int i=0; i<nbpas;++i){
        for(int j=0;j<_totalTortue;++j){
            if(_action[_numaction]==fonction::avance) Driver::avance(j,1);
            else if(_action[_numaction]==fonction::recule) Driver::recule(j,1);
            else if(_action[_numaction]==fonction::saute) Driver::saute(j,1);
            else if(_action[_numaction]==fonction::tourne) Driver::tourne(j,1);
        }

        _numaction++;
    }
}




































