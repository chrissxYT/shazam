#!/usr/bin/python3

import wave
from sys import argv, exit
from struct import pack

if len(argv) < 2:
    print('Please specify an input and output file.')
    exit(1)

wav = wave.open(argv[1], 'rb')
caf = open(argv[2], 'wb')

caf.write('CAFF'.encode('utf8'))
caf.write(pack('>i', wav.getnchannels()))
caf.write(pack('>i', wav.getsampwidth()))
caf.write(pack('>i', wav.getframerate()))
caf.write(pack('>i', wav.getnframes()))
caf.write(wav.readframes(wav.getnframes()))

wav.close()
caf.close()
