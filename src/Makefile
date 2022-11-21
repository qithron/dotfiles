CFLAGS = -Wall -Wextra -static
BIN    = quote unquote

all: ${BIN}
	mv ${BIN} ../bin

clean:
	for v in ${BIN}; do \
		rm -f "../bin/$$v"; \
	done
