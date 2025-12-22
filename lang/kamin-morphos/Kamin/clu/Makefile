CC = data2:fpc/bin/powerpc-morphos/fpc 

app = clu

all:$(app)

$(app) : $(app).pas
	@echo "Compilation & Liaison "

	$(CC) -Sg $(app).pas 
	
	@echo "fini"
	
.PHONY: clean mrproper

clean:
	 rm -rf *.o

mrproper: clean
	 rm -rf $(app)
