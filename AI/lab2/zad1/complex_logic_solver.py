import math, random
import sys, getopt, numpy as np
import os

def main(argv):
   inputfile = 'zad_input.txt'
   outputfile = 'zad_output.txt'

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
      valX.append(list(map(lambda x: int(x), f.readline().split(' '))))
   for i in range(0, Y):         
      valY.append(list(map(lambda x: int(x), f.readline().split(' '))))

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

def opt_dist_complex(list, Dlist):
   if len(Dlist) == 1:
      return opt_dist(list, Dlist[0])
   
   startI = 0
   best = len(list)+1
   prev = 0

   while startI + (len(Dlist)-1) + sum(Dlist) <= len(list):

      val = opt_dist(list[startI:startI+Dlist[0]], Dlist[0])
      val += prev + list[startI + Dlist[0]]
      rest = opt_dist_complex(list[startI+Dlist[0]+1:], Dlist[1:])

      if best > val+rest:
         best = val+rest
      prev += list[startI]
      startI += 1
   
   return best


def solver(vX, vY, X, Y):

   fail = 0.15
   max_iter = 20000

   while(True):

      
      rng = random.Random()
      
      board = np.random.randint(2, size=(X,Y))
      
      for _ in range(max_iter):
         x_opt = []
         y_opt = []
         broke = False
         if rng.random() < fail:
            broke = True
         for i in range(X):
            x_opt.append(opt_dist_complex(board[i,:], vX[i]))
         for i in range(Y):
            y_opt.append(opt_dist_complex(board[:,i], vY[i]))
         


         if (max(x_opt) + max(y_opt)) == 0:
            return board
         
         x_opt = np.array(x_opt)
         y_opt = np.array(y_opt)

         if rng.random() < 0.5:
            # find row
            m = max(x_opt)
            if broke is True and min(x_opt) == 0:
               x = np.random.choice(np.argwhere(x_opt == 0).T[0])
            elif m != 0 and broke is True:
               x = np.random.choice(np.argwhere(x_opt != 0).T[0])
            elif m == 0: continue
            else: x = np.random.choice(np.argwhere(x_opt == m).T[0])
            # chance to not optimise over column

            if rng.random() < fail:
               board[x, rng.randint(0, Y-1)] ^= 1
               continue
            
            # find opt column
            best = 0
            best_j = 0
            for j in range(Y):
               board[x,j] ^= 1
               res = opt_dist_complex(board[:, j], vY[j])
               res2 = opt_dist_complex(board[x,:], vX[x])

               if (y_opt[j] - res) + (x_opt[x] - res2) > best:

                  best = (y_opt[j] - res) + (x_opt[x] - res2)
                  best_j = j
               
               board[x,j] ^= 1
            
            board[x, best_j] ^= 1

         else:
            m = max(y_opt)
            if broke is True and min(y_opt) == 0:
               y = np.random.choice(np.argwhere(y_opt == 0).T[0])
            elif m != 0 and broke is True:
               y = np.random.choice(np.argwhere(y_opt != 0).T[0])
            elif m == 0: continue
            else: y = np.random.choice(np.argwhere(y_opt == m).T[0])
            if rng.random() < fail:
               board[rng.randint(0, X-1), y] ^= 1
               continue
            # find opt row
            best = 0
            best_j = 0
            for j in range(X):
               board[j,y] ^= 1
               res = opt_dist_complex(board[j,:], vX[j])
               res2 = opt_dist_complex(board[:,y], vY[y])

               if (x_opt[j] - res) + (y_opt[y] - res) > best:
                  best = (x_opt[j] - res) + (y_opt[y] - res2)
                  best_j = j
               board[j,y] ^= 1
            
            board[best_j, y] ^= 1


if __name__ == "__main__":
   main(sys.argv[1:])