#!/bin/sh

cxx=${CXX:-c++}

cflags="-march=native -O3"
#cflags="-O0 -ggdb"
cflags="${cflags} -Wall -Wextra -Wno-unused-parameter"
cflags="${cflags} -Wno-unused-result -Wno-missing-field-initializers -Wno-format-truncation"

# Check GDB is installed and uses the expected prompt.
gdb --version > /dev/null 2>&1 || printf "\033[0;31mWarning\033[0m: GDB not detected. You must install GDB to use gf.\n"
gdb --version > /dev/null 2>&1 || exit 1
echo q | gdb | grep "(gdb)" > /dev/null 2>&1 || printf "\033[0;31mWarning\033[0m: Your copy of GDB appears to be non-standard or has been heavily reconfigured with .gdbinit.\nIf you are using GDB plugins like 'GDB Dashboard' you must remove them,\nas otherwise gf will be unable to communicate with GDB.\n"

# Check if FreeType is available.
if [ -d /usr/include/freetype2 ]; then
	cflags="${cflags} -lfreetype -D UI_FREETYPE -I /usr/include/freetype2"
else
	printf "\033[0;31mWarning\033[0m: FreeType could not be found. The fallback font will be used.\n";
fi

# Check if SSE2 is available.
uname -m | grep x86_64 > /dev/null && cflags="${cflags} -DUI_SSE2"

# Build the executable.
${cxx} ${cflags} gf2.cpp -o gf2 -lX11
