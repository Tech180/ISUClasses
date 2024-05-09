# Lab 06 part 02
# You will be using the code to look at the diffusion
# of bits in just the first odd quarter round.

"""
This code has been adapted for use in CprE/CybE 331.

The base code for the ChaCha20 stream cipher was used
from the book Implementing Cryptography with Python.
The same code can also be found in several git repositories.

Modifications have been made to read in from json files,
convert imported data, and provide print structures.
 
"""

import json
import struct
import sys, os, binascii, uu
from base64 import b64encode
from base64 import b64decode

def readInJson(filename):
    with open(filename) as inFile:
        inData = json.load(inFile)
    inFile.close()
    return inData


def writeOutJson(filename,dump):
    with open (filename, 'w') as outFile:
           outFile.write(dump)
    outFile.close()
    return


def yield_chacha20_xor_stream(key, iv, position=0):
  # Generate the xor stream with the ChaCha20 cipher."""
  if not isinstance(position, int):
    raise TypeError
  if position & ~0xffffffff:
    raise ValueError('Position is not uint32.')
  if not isinstance(key, bytes):
    raise TypeError
  if not isinstance(iv, bytes):
    raise TypeError
  if len(key) != 32:
    raise ValueError
  if len(iv) != 8:
    raise ValueError

  def rotate(v, c):
    return ((v << c) & 0xffffffff) | v>> (32 - c)

  def print_matrix (x):
      print (x[:4])
      print (x[4 : 8])
      print (x[8 : 12])
      print (x[12 : 16])
      print ()
      print ()
      return


  def quarter_round(x, a, b, c, d):
    x[a] = (x[a] + x[b]) & 0xffffffff
    x[d] = rotate(x[d] ^ x[a], 16)
    x[c] = (x[c] + x[d]) & 0xffffffff
    x[b] = rotate(x[b] ^ x[c], 12)
    x[a] = (x[a] + x[b]) & 0xffffffff
    x[d] = rotate(x[d] ^ x[a], 8)
    x[c] = (x[c] + x[d]) & 0xffffffff
    x[b] = rotate(x[b] ^ x[c], 7)

  ctx = [0] * 16
  ctx[:4] = (1634760805, 857760878, 2036477234, 1797285236)
  ctx[4 : 12] = struct.unpack('<8L', key)
  ctx[12] = ctx[13] = position
  ctx[14 : 16] = struct.unpack('<LL', iv)
  print ('original 4x4 matrix')
  print_matrix (ctx)


  while 1:
    x = list(ctx)
    for i in range(10):
      # TODO: Count the number of bits that change in odd qr 0 from original 4x4 matrix above)

      original_matrix = list(ctx)  # Capture the original state of the matrix
      
      quarter_round(x, 0, 4, 8, 12)

      # Number of bits that changed
      bit_changes = sum(bin(original_matrix[i] ^ x[i]).count('1') for i in range(16))

      # Calculate the percentage of bits changed
      percentage = (bit_changes / 128) * 100

      overall = (bit_changes / 512) * 100
      
      # You probably will want to comment out 
      print ('>>>>  ROUND ', i , '  <<<<<')

      print(f'Bits changed: {bit_changes}\n')
      print(f'Percentage: {percentage:.2f}%\n')
      print(f'Overall Percentage: {overall:.2f}%\n')

      quarter_round(x, 0, 4,  8, 12)
      print('odd qr 0')
      print_matrix(x)

      quarter_round(x, 1, 5,  9, 13)
      print('odd qr 1')
      print_matrix(x)

      quarter_round(x, 2, 6, 10, 14)
      print( 'odd qr 2')
      print_matrix(x)

      quarter_round(x, 3, 7, 11, 15)
      print('odd qr 3')
      print_matrix(x)

      quarter_round(x, 0, 5, 10, 15)
      print('even qr 0')
      print_matrix(x)

      quarter_round(x, 1, 6, 11, 12)
      print('even qr 1')
      print_matrix(x)

      quarter_round(x, 2, 7,  8, 13)
      print('even qr 2')
      print_matrix(x)

      quarter_round(x, 3, 4,  9, 14)
      print('even qr 3')
      print_matrix(x)

    for c in struct.pack('<16L', *(
        (x[i] + ctx[i]) & 0xffffffff for i in range(16))):
      yield c
    ctx[12] = (ctx[12] + 1) & 0xffffffff
    if ctx[12] == 0:
      ctx[13] = (ctx[13] + 1) & 0xffffffff

def chacha20_encrypt(data, key, iv=None, position=0):
  # Encrypt (or decrypt) with the ChaCha20 cipher.
  if not isinstance(data, bytes):
    raise TypeError
  if iv is None:
    iv = b'\0' * 8
  if isinstance(key, bytes):
    if not key:
      raise ValueError('Key is empty.')
    if len(key) < 32:
      key = (key * (32 // len(key) + 1))[:32]
    if len(key)> 32:
      raise ValueError('Key too long.')
  return bytes(a ^ b for a, b in
      zip(data, yield_chacha20_xor_stream(key, iv, position)))

def main():

    inData = readInJson(sys.argv[1])

    plaintext = bytes(inData.get('plainText'),'utf-8')
    iv = b64decode(inData['nonce'])
    key = b64decode(inData['key'])


    enc = chacha20_encrypt(plaintext, key, iv)
    decode_enc = b64encode(enc).decode('utf-8')
    print('The encrypted string is {}. '.format(decode_enc))
    #dec = chacha20_encrypt(enc,key, iv)
    #print('The decrypted string is {}. '.format(dec))

if __name__ == "__main__":
    sys.exit(int(main() or 0))
                                              


      
      


