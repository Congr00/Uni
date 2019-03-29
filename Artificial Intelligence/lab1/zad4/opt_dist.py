import math, random
import sys, getopt, numpy as np
import os

file_name = 'opt_dist.py'
args_list = '-i <in file> -o <outfile> --debug'
getop = "hi:o:"
getopLong = ["debug"]

_DEBUG = False
_WINDOW = None

def main(argv):
   inputfile = ''
   outputfile = ''

   try:
      opts, args = getopt.getopt(argv,getop, getopLong)
   except getopt.GetoptError:
      print(file_name + ' ' + args_list)
      sys.exit(2)

   if len(args) is not 0:
      print('Unknown argument/s: ' + str(args))
   for opt, arg in opts:
      if opt == '-h':
         print(file_name + ' ' + args_list)
         sys.exit()

      # arg line
      
      elif opt in "-i":
         inputfile = arg
      elif opt in "-o":
         outputfile = arg
      elif opt in "--debug":
         global _DEBUG
         global _WINDOW 
         _DEBUG = True

   if _DEBUG is False:
      inputfile = 'zad4_input.txt'
      outputfile = 'zad4_output.txt'      
 
   # arg check

   if inputfile is '':
      print('need proper input file')
      sys.exit(2)
   elif outputfile is '':
      print('need proper output file')
      sys.exit(2)
   load_file(inputfile, outputfile)

def load_file(fin, fout):
   f = None
   try: f = open(fin, 'r')
   except:
      print('error while reading file: ' + fin)
      sys.exit(2)
   open(fout, "w").close()
   for line in f:
        spl = line.split(' ')
        count = opt_dist(str_to_bits(spl[0]), int(spl[1]))
        f = open(fout, "a")
        f.write(str(count)+'\n')         
        f.close()            
        if _DEBUG:
            break         
   f.close()  

def str_to_bits(string):
    res = []
    for c in string:
        res.append(1 if c == '1' else 0)
    return res


def opt_dist(list, D):
    list_s = sum(list)
    if len(list) == D:
        return D - list_s
    opt = sum(list[:D])
    s = opt
    for i in range(1, len(list)-D+1):
        s -= list[i-1]
        s += list[i+D-1]
        if s > opt:
            opt = s
    return D + list_s - (2* opt)
    

if __name__ == "__main__":
   main(sys.argv[1:])

