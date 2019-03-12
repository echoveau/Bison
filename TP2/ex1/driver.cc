#include "driver.hh"
#include <iostream>

Driver::Driver() {}
Driver::~Driver() {}

float   Driver::getVariable(const std::string& id) {
    return variables[id];
}

void    Driver::setVariable(const std::string& id, float val) {
    variables[id] = val;
}
