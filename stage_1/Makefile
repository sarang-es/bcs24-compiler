CC = gcc
CFLAGS = -Wall -Wextra
FLEX = flex
BISON = bison -d

TARGET = bcs24_parser

all: $(TARGET)

$(TARGET): parser.tab.c lex.yy.c
	$(CC) $(CFLAGS) -o $(TARGET) parser.tab.c lex.yy.c

parser.tab.c parser.tab.h: parser.y
	$(BISON) parser.y

lex.yy.c: lexer.l parser.tab.h
	$(FLEX) lexer.l

test: $(TARGET)
	@echo "=== Running Tests with $(TARGET) ==="
	@echo -n "Test 1 (PDF Sample): "
	@./$(TARGET) test_pdf_sample.bcs
	@echo -n "Test 2 (sample_success.bcs): "
	@./$(TARGET) sample_success.bcs
	@echo -n "Test 3 (sample_error.bcs): "
	@./$(TARGET) sample_error.bcs

clean:
	rm -f $(TARGET) parser lex.yy.c parser.tab.c parser.tab.h *.o *.tar.gz *.gz

package: clean
	tar -czvf stage1_submission.tar.gz lexer.l parser.y Makefile README.md sample_success.bcs sample_error.bcs test_pdf_sample.bcs

.PHONY: all test clean package
