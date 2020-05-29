CFLAGS = -g -Wall -ansi -pedantic

parser: mini_l.lex mini_l.y
		bison -v -d --file-prefix=y mini_l.y
		g++ -c y.tab.c -lfl -o y.tab.o
		flex mini_l.lex
		g++ -c lex.yy.c -o lex.yy.o
		g++ $(CFLAGS) -std=c++11 lex.yy.o y.tab.o -parser

clean:
		rm -f lex.yy.c y.tab.* y.output *.o parser
