import os


fw = open("out.h", "w") 

fw.write("#include <inttypes.h>\n#include <avr/pgmspace.h>\nstatic const uint8_t music[] PROGMEM = {\n")

fr = open('music.raw', "rb")
data = fr.read()
for b in data:
    fw.write("0x{:02X}".format(b))
    fw.write(",\n")
fw.write("};\n")