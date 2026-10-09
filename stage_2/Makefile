CC = gcc
CFLAGS = -Wall -Wextra
FLEX = flex
BISON = bison -d

TARGET = bcs24_tac

all: $(TARGET)

$(TARGET): parser.tab.c lex.yy.c main.c
	$(CC) $(CFLAGS) -o $(TARGET) parser.tab.c lex.yy.c main.c

parser.tab.c parser.tab.h: parser.y
	$(BISON) parser.y

lex.yy.c: lexer.l parser.tab.h
	$(FLEX) lexer.l

run: $(TARGET)
	./$(TARGET) sample.bcs output.txt

clean:
	rm -f $(TARGET) lex.yy.c parser.tab.c parser.tab.h *.o output.txt

.PHONY: all run clean

