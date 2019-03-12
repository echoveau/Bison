#ifndef DRIVER_H
#define DRIVER_H

#include <map>
#include <string>

class Driver {
private:
    std::map<std::string, float> variables;        

public:
    Driver();
    ~Driver();

    float   getVariable(const std::string& id);
    void    setVariable(const std::string& id, float val);

};

#endif
