calc: y.tab.o lex.yy.o
	gcc -o calc y.tab.o lex.yy.o -ly -ll -lm

y.tab.c y.tab.h: calc.y
	yacc -d calc.y

lex.yy.c: calc.l
	flex calc.l

clean:
	rm -f calc y.tab.c y.tab.h lex.yy.c *.o