parser: lab2.lex lab2.y
		bison -v -d --file-prefix=y lab2.y
		flex lab2.lex
		gcc -o lab2 y.tab.c lex.yy.c -lfl
clean:
		rm -f lex.yy.c y.tab.* y.output *.o lab2
