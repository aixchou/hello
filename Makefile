OBJS=helloworld.o
CC=gcc -g

all: $(OBJS)
	$(CC) -o helloworld $(OBJS)

clean:
	rm -f *.o helloworld

install: all
	mkdir -p $(DESTDIR)/usr/bin/
	cp helloworld $(DESTDIR)/usr/bin/

.PHONY:all clean
