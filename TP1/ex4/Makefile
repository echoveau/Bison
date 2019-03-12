
LEX=flex
CXX=g++
CXXFLAGS=-Wall
LDFLAGS= 

TARGET = scanner

OBJS=scanner.o main.o

.PHONY: all
all: $(TARGET)

.PHONY: clean
clean:
	rm -f $(TARGET) *.o scanner.cpp

$(TARGET): $(OBJS)
	$(CXX) $(LDFLAGS) $^ -o $@

%.cpp: %.ll
	$(LEX) -o $@ $<



