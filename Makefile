OBJS=base64.o bytearray.o iterator.o list.o node_iterator.o plist.o time64.o bplist.o hashtable.o ldid.o node.o node_list.o ptrarray.o xplist.o lookup2.o
CFLAGS=-Ilibplist/include -Ilibplist/src -Ilibplist/libcnary/include -I./libplist/libcnary/include
CXXFLAGS=$(CFLAGS) -stdlib=libc++ -std=c++11

IOSCFLAGS=-I../build-openssl-on-ios/bin/iOS/include
IOSCXXFLAGS=$(IOSCFLAGS)
IOSLDFLAGS=-L../build-openssl-on-ios/bin/iOS/lib -lcrypto -lc++
IOSC=xcrun -sdk iphoneos clang -miphoneos-version-min=8.4 -arch arm64

MACOSCFLAGS=$(shell pkg-config --cflags openssl)
MACOSCXXFLAGS=$(MACOSCFLAGS)
MACOSLDFLAGS=$(shell pkg-config --libs-only-L openssl) -lcrypto -lc++
MACOSC=xcrun -sdk macosx clang -mmacosx-version-min=10.7 -arch x86_64

all: macos/ldid ios/ldid



ios/ldid:$(addprefix ios/,$(OBJS))
	$(IOSC) -o $@ $^ $(IOSLDFLAGS)
	./macos/ldid -Sdef.xml ./ios/ldid

ios/%.o : %.c
	@mkdir ios 2>/dev/null || true
	$(IOSC) $(CFLAGS) $(IOSCFLAGS) -o $@ -c $^

ios/%.o : %.cpp
	$(IOSC) $(CXXFLAGS) $(IOSCXXFLAGS)  -o $@ -c $^



macos/ldid:$(addprefix macos/,$(OBJS))
	$(MACOSC) -o $@ $^ $(MACOSLDFLAGS)

macos/%.o : %.c
	@mkdir macos 2>/dev/null || true
	$(MACOSC) $(CFLAGS) $(MACOSCFLAGS) -o $@ -c $^

macos/%.o : %.cpp
	$(MACOSC) $(CXXFLAGS) $(MACOSCXXFLAGS)  -o $@ -c $^


vpath %.c libplist/src libplist/libcnary

