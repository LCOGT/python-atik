CFLAGS=-fPIC
CPPFLAGS=-I/usr/include/python2.7 -latikccd
TARGET=_atik.so

all: $(TARGET)


$(TARGET): atik_wrap.o
	g++ -shared atik_wrap.o -latikccd -o $(TARGET)

atik_wrap.o: atik_wrap.cxx
	g++ -c $(CFLAGS) $(CPPFLAGS) $< -o $@

atik_wrap.cxx: atik.i
	swig -I/usr/include -python -c++ atik.i

#test: $(TARGET) test_atik.py
#	py.test

clean:
	@rm -fr *.so *.o *.pyc atik_wrap.cxx atik.py __pycache__
