#ifndef DRIVER_H
#define DRIVER_H

#include <map>
#include <string>
#include <QPoint>
#include <QColor>
#include <QSize>
#include "tortue.hh"
#include <iostream>

class JardinRendering;


enum class fonction {
    avance, recule, saute, tourne
};

enum class rotation {
    droite, gauche
};

enum class zone {
    carapace, motif
};

enum class direction {
    devant, derriere, droite, gauche
};

enum class condition {
    mur, vide
};

enum class liste_instruction {
    deplacement, couleur, fonction
};


class Driver {
private:      
    JardinRendering * monJardin;
    std::map<std::string, float> variables;
    std::vector<std::string> _nomFonction;	
    std::vector<fonction> _action;		
    rotation _rotation;
    zone _zone;
    direction _direction;
    condition _condition;
    int _totalTortue=1;
    int _numaction=0;

    void saute(int n, int nbdeplacemnts);
    void tourne(int n, int nbdeplacemnts);
    void changerPosition(int n,int x, int y);
    void changerOrientation(int n,float o);
    void avance(int n, int nbdeplacemnts);
    void recule(int n, int nbdeplacemnts);
    int get_x(int n);
    int get_y(int n);
    float get_orientation(int n);

public:
	Driver(JardinRendering * J);
	~Driver();

    void changerCouleurCarapace(int n,int r,int g,int b);

    void setrotation(rotation const &r) {
        _rotation=r;
    }
    void setZone(zone const &z) {
        _zone=z;
    }
    void setTotalTortue(int nb) {
        _totalTortue=nb;
    }

    bool existeFonction(std::string const &nom);
    void supprimerFonction(std::string const &nom);

    void ajoutFonction(std::string const &nom);
    void ajoutAction(fonction const &f);


    void deplacerUneTortue(int n, int nbpas);
    void deplacerToutesTortue(int nbpas);

    void changerCouleurTouteTortue(std::string rgb);
    void changerCouleurUneTortue(int num, std::string rgb);

    void changerTailleJardin(std::string const &f);

    void setDirection(direction const &d) {
        _direction=d;
    }
    direction getDirection() const {
        return _direction;
    }


    void setCondition(condition const &c) {
        _condition=c;
    }
    condition getCondition() const {
        return _condition;
    }

    bool conditionTouteTortue(condition const &c);
    bool conditionUneTortue(int n, condition const &c);


};

#endif


