OBJECTS = bin/main.o bin/nbasic.o bin/RegEx.o
TARGET = bin/nbasic

default: $(OBJECTS)
	g++ -mcrt=newlib $(OBJECTS) -o $(TARGET)

bin/main.o: main.cpp nbasic.h
	g++ -mcrt=newlib -c main.cpp -o bin/main.o

bin/nbasic.o: nbasic.cpp nbasic.h RegEx.h
	g++ -mcrt=newlib -c nbasic.cpp -o bin/nbasic.o

bin/RegEx.o: RegEx.cpp RegEx.h
	g++ -mcrt=newlib -c RegEx.cpp -o bin/RegEx.o

clean:
	rm $(TARGET) $(OBJECTS)
