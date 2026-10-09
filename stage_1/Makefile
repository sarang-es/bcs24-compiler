CC = gcc
CFLAGS = -Wall -Wextra
FLEX = flex
BISON = bison -d

TARGET = bcs24_parser

all: $(TARGET)

$(TARGET): parser.tab.c lex.yy.c main.c
	$(CC) $(CFLAGS) -o $(TARGET) parser.tab.c lex.yy.c main.c

parser.tab.c parser.tab.h: parser.y
	$(BISON) parser.y

lex.yy.c: lexer.l parser.tab.h
	$(FLEX) lexer.l

clean:
	rm -f $(TARGET) parser lex.yy.c parser.tab.c parser.tab.h *.o *.tar.gz *.gz

package: all
	tar -czvf stage1_submission.tar.gz lexer.l parser.y main.c lex.yy.c parser.tab.c parser.tab.h sample_success.txt sample_error.txt sample_success2.txt sample_error2.txt
	cp stage1_submission.tar.gz stage1_submission.gz

.PHONY: all clean package
