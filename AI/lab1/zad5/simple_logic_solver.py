import math, random
import sys, getopt, numpy as np
import os

def main(argv):
   inputfile = 'zad5_input.txt'
   outputfile = 'zad5_output.txt'

   load_file(inputfile, outputfile)

def load_file(fin, fout):
   f = None

   try: f = open(fin, 'r')
   except:
      print('error while reading file: ' + fin)
      sys.exit(2)

   X,Y = f.readline().split(' ')
   X = int(X)
   Y = int(Y)
   valY = []
   valX = []
   for i in range(0, X):
      valX.append(int(f.readline()))
   for i in range(0, Y):         
      valY.append(int(f.readline()))
   board = solver(valX, valY, X, Y)

   fout = open(fout, 'w')   
   for i in board:
      for j in i:
         if j == 0:
            fout.write('.')
         else:
            fout.write('#')
      fout.write('\n')
   
   fout.close()
   f.close()  

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

def solver(vX, vY, X, Y):

   while(True):

      board = np.random.randint(2, size=(X,Y))
      
      for n in range(0, 1000000):
         x_opt = []
         y_opt = []
         broke = False
         if random.random() < 0.1:
            broke = True
         for i in range(0, X):
            x_opt.append(opt_dist(board[i,:], vX[i]))
         for i in range(0, Y):
            y_opt.append(opt_dist(board[:,i], vY[i]))
         
         if (max(x_opt) + max(y_opt)) == 0:
            return board
         x_opt = np.array(x_opt)
         y_opt = np.array(y_opt)

         if random.random() < 0.5:
            # find row
            if broke is True and min(x_opt) == 0:
               x = np.random.choice(np.argwhere(x_opt == 0).T[0])
            elif max(x_opt != 0):
               x = np.random.choice(np.argwhere(x_opt != 0).T[0])
            else: continue
            # chance to not optimise over columnt
            if random.random() < 0.1:
               board[x, random.randint(0, Y-1)] ^= 1
               continue
            # find opt column
            best = 0
            best_j = 0
            for j in range(0, Y):
               board[x,j] ^= 1
               res = opt_dist(board[:, j], vY[j])
               if y_opt[j] - res > best:
                  best = y_opt[j] - res
                  best_j = j
               board[x,j] ^= 1
            board[x, best_j] ^= 1

         else:
            if broke is True and min(y_opt) == 0:
               y = np.random.choice(np.argwhere(y_opt == 0).T[0])
            elif max(y_opt) != 0:
               y = np.random.choice(np.argwhere(y_opt != 0).T[0])
            else: continue
            if random.random() < 0.1:
               board[random.randint(0, X-1), y] ^= 1
               continue
            # find opt row
            best = 0
            best_j = 0
            for j in range(0, X):
               board[j,y] ^= 1
               res = opt_dist(board[j,:], vX[j])
               if x_opt[j] - res > best:
                  best = x_opt[j] - res
                  best_j = j
               board[j,y] ^= 1
            board[best_j, y] ^= 1


if __name__ == "__main__":
   main(sys.argv[1:])