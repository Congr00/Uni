#!/usr/bin/python

import sys, getopt
import os, time
import collections

#commented for pypy3 to work (no debug mode)
'''
import tkinter
from PIL import Image, ImageTk
from cairosvg import svg2png
import chess.svg    
'''

file_name = 'chess_finisher.py'
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
         if _DEBUG is True:        
            _WINDOW = win_manager()
   inputfile = 'zad1_input.txt'
   outputfile = 'zad1_output.txt'
   load_file(inputfile, outputfile) 
   # arg check
'''   if inputfile is '':
      print('need proper input file')
      sys.exit(2)
   elif outputfile is '':
      print('need proper output file')
      sys.exit(2)'''


def load_file(fin, fout):
   f = None
   try: f = open(fin, 'r')
   except:
      print('error while reading file: ' + fin)
      sys.exit(2)

   for line in f:
      ai = board_ai(line.split(' '))
      white = True if line.split(' ')[0] == 'white' else False

      old_state = None
      if _DEBUG is True:
            _WINDOW.board.clear()
            _WINDOW.add_piece((chess.square(ai.wKingP[1], ai.np_num_map[ai.wKingP[0]]-1), 'K'))
            _WINDOW.add_piece((chess.square(ai.wRookP[1], ai.np_num_map[ai.wRookP[0]]-1), 'R'))
            _WINDOW.add_piece((chess.square(ai.bKingP[1], ai.np_num_map[ai.bKingP[0]]-1), 'k'))
            _WINDOW.convert_to_png() 
            old_state = ai.game_sate()

            start = time.time()          

      
      history = ai.emulate_game(white, ai.game_sate())
   
      if _DEBUG is True:         
         end = time.time()
         print('time: ', end - start)           
         print('finished in: ' , len(history), " moves")

         ai.load_state(old_state)
         for piece, mv  in history:
            ai.update_state(piece, mv)
            _WINDOW.board.clear()
            _WINDOW.add_piece((chess.square(ai.wKingP[1], ai.np_num_map[ai.wKingP[0]]-1), 'K'))
            _WINDOW.add_piece((chess.square(ai.wRookP[1], ai.np_num_map[ai.wRookP[0]]-1), 'R'))
            _WINDOW.add_piece((chess.square(ai.bKingP[1], ai.np_num_map[ai.bKingP[0]]-1), 'k'))
            _WINDOW.convert_to_png() 
            time.sleep(1)   
      else: 
         f = open(fout, "w")
         f.write(str(len(history))+'\n')         
         f.close()
      if _DEBUG is True:
         time.sleep(60)   

      #TODO: run ai functions
      #      limit white king move options to move only in dir of black king
      #      black king moves only toward nearest wall if possible?
      #      do some smart past moves saving for debugging
   f.close()  
   if _DEBUG is True:
      _WINDOW.root.destroy() 

class board_ai:
      def __init__(self, positions):
      
         self.wKing = 1
         self.wRook = 2
         self.bKing = 3
         self.first = True

         self.BX = 8
         self.BY = 8

         self.alph_num_map = {'a' : 0, 'b' : 1, 'c' : 2, 'd' : 3, 'e' : 4, 'f' : 5, 'g' : 6, 'h' : 7}
         self.num_alph_map = dict((reversed(item) for item in self.alph_num_map.items()))
         self.num_np_map = {1 : 7, 2 : 6, 3 : 5, 4 : 4, 5 : 3, 6 : 2, 7 : 1, 8 : 0}
         self.np_num_map = dict((reversed(item) for item in self.num_np_map.items()))
         self.whiteFirst = True if positions[0] in 'white' else False 

         self.wKingP = (self.num_np_map[int(positions[1][1])], self.alph_num_map[positions[1][0]])
         self.wRookP = (self.num_np_map[int(positions[2][1])], self.alph_num_map[positions[2][0]])
         self.bKingP = (self.num_np_map[int(positions[3][1])], self.alph_num_map[positions[3][0]])

      def free_square(self, position):
         if position[0] < 0 or position[0] >= self.BX:
            return False
         elif position[1] < 0 or position[1] >= self.BY:
            return False
         
         # rook cant be dropped by black king, otherwise we cant win
         # so we always dont want to drop rook as black king
         # as white king we cant get near black king anyways            
         elif position == self.wKingP or position == self.bKingP or position == self.wRookP:
            return False
         return True


      def shift_c(self, pos, shift):
         return (pos[0] - shift[0], pos[1] - shift[1])

      def neib_squares(self, position):
         return [self.shift_c(position, (1,0)), self.shift_c(position, (-1,0)), self.shift_c(position, (0,1)), self.shift_c(position, (0,-1)),
                     self.shift_c(position, (-1,-1)), self.shift_c(position, (1,1)),self.shift_c(position, (-1,1)),self.shift_c(position, (1,-1))]

      def rook_checkmoves(self):
         mv1 = (self.bKingP[0], self.wRookP[1])
         mv2 = (self.wRookP[0], self.bKingP[1])

         if self.free_square(mv1) is False:
            mv1 = None
         if self.free_square(mv2) is False:
            mv2 = None
         # check if white king isnt on the way of possible moves by his position x/y and len to rook
         res = []
         if mv1 is not None:
            if self.wKingP[1] != self.wRookP[1]:
               res.append(mv1)
            elif abs(self.wKingP[0] - self.wRookP[0]) > abs(mv1[0] - self.wRookP[0]):
               res.append(mv1)
         if mv2 is not None:
            if self.wKingP[0] != self.wRookP[0]:
               res.append(mv2)
            elif abs(self.wKingP[1] - self.wRookP[1]) > abs(mv2[1] - self.wRookP[1]):
               res.append(mv2)
         

         if self.first is True:
            add_moves = []
            for i in range(0, 4):               
               add_moves.append((self.wRookP[0], i*2))
               add_moves.append((i*2, self.wRookP[1]))
               

            for mv in add_moves:        
               if mv[0] == self.wKingP[0] == self.wRookP[0]:
                  continue
               if mv[1] == self.wKingP[1] == self.wRookP[1]:
                  continue
               if self.free_square(mv):
                  res.append(mv)

         return res

      def possible_moves(self,position, piece):
         # moves for kings
         if piece is not self.wRook:
            # get neib squares
            res = []            
            moves = self.neib_squares(position)
            for mv in moves:
               # check for only valid moves                  
               if self.free_square(mv):
                  if piece is self.wKing:
                     dist = abs(mv[0] - self.bKingP[0]) + abs(mv[1] - self.bKingP[1])
                     if dist > 3:
                        if abs(self.wKingP[0] - self.bKingP[0]) + abs(self.wKingP[1] - self.bKingP[1]) < dist:
                           continue                     
                     # allow to move only on inner squares
                     if mv not in [(1,2), (2,1), (1,5), (5,1), (6,2), (2,6), (6,5), (5,6)]:
                        if (self.wKingP[0] != 0 and self.wKingP[0] != 7 and self.wKingP[1] != 0 and self.wKingP[1] != 7) and (mv[0] < 2 or mv[0] > 5 or mv[1]< 2 or mv[1] > 5):
                           continue                 

                     # check if black king doesnt mate via length of vector between kings                  
                     tmp = self.shift_c(self.bKingP, mv)

                     if max([abs(tmp[0]), abs(tmp[1])]) > 1:
                        res.append(mv)
                  elif piece is self.bKing:                        
                     # check if white king doesnt mate              
                     tmp = self.shift_c(self.wKingP, mv)

                     if max([abs(tmp[0]), abs(tmp[1])]) > 1:                    
                        dist = abs(mv[0] - self.wKingP[0]) + abs(mv[1] - self.wKingP[1])
                        if dist > 3:
                           if abs(self.bKingP[0] - self.wKingP[0]) + abs(self.bKingP[1] - self.wKingP[1]) < dist:
                              continue
                        # if rook has different x and y position value then he cant check
                        if self.wRookP[0] != mv[0] and self.wRookP[1] != mv[1]:
                           res.append(mv)
                        else:                 
                           if self.wRookP[0] == mv[0]:
                              # check if white king is on the way of rook to check
                              if self.wKingP[0] == self.wRookP[0] and abs(self.wKingP[1] - mv[1]) < abs(mv[1] - self.wRookP[1]):
                                 res.append(mv)
                           # same as above but on Y axe
                           elif self.wKingP[1] == self.wRookP[1] and abs(self.wKingP[0] - mv[0]) < abs(mv[0] - self.wRookP[0]):
                              res.append(mv)

            return res
         else: # its rook
            # we want possible move only for check if none then 0 possible moves
            return self.rook_checkmoves()

      def game_sate(self):
         return [self.wKingP, self.wRookP, self.bKingP]
      def load_state(self, state):
         self.wKingP = state[0]
         self.wRookP = state[1]
         self.bKingP = state[2]

      def update_state(self, piece, pos):
         if piece is self.wKing:
            self.wKingP = pos
         elif piece is self.wRook:
            self.wRookP = pos
         else:
            self.bKingP = pos

      def emulate_game(self, white, bState):
         buffer = collections.deque()
         # get first possible moves to start BFS
         if white is True:
            # buffer[0][0] is white king possible moves, buffer[0][1] is white rook possible moves and buffer[1] is state of board during moves 
            buffer.append(([self.possible_moves(bState[0], self.wKing), self.possible_moves(bState[1], self.wRook)], bState, []))
            white = False
            self.first = False            
         else:
            buffer.append(([self.possible_moves(bState[2], self.bKing)], bState, []))
            white = True


         while True:
            moves, state, history = buffer.popleft()
            self.load_state(state)
            if len(history) == 10:
               print('hus')
               return

            if len(moves) == 2:
               old_state = self.game_sate()
               for wk_moves in moves[0]:
                  #dont repeat moves from the past
                  if(len([mv for piece, mv in history if piece == self.wKing and mv == wk_moves]) != 0):
                     continue                   
                  self.update_state(self.wKing, wk_moves)
                  tmp = self.possible_moves(self.bKingP, self.bKing)
                  # if black king cant move it means its checkmate
                  if len(tmp) == 0:
                     tmp2 = self.shift_c(self.bKingP, self.wRookP)
                     if max([abs(tmp2[0]), abs(tmp2[1])]) == 1:

                        tmp2 = self.shift_c(self.wRookP, self.wKingP)
                        if max([abs(tmp2[0]), abs(tmp2[1])]) > 1:                        
                           continue
                     if self.wRookP[0] == self.bKingP[0] or self.wRookP[1] == self.bKingP[1]:                              
                        return history+[(self.wKing, wk_moves)]
                  
                  buffer.append(([tmp], self.game_sate(), history+[(self.wKing, wk_moves)]))   
               self.load_state(old_state)                                                       
               for wr_moves in moves[1]:
                  if len(history) > 2:                     
                     if history[len(history)-2][1] == wr_moves:
                        continue                          
                  self.update_state(self.wRook, wr_moves)
                  tmp = self.possible_moves(self.bKingP, self.bKing)
                  # if black king cant move it means it checkmate
                  if len(tmp) == 0:
                     tmp2 = self.shift_c(self.bKingP, self.wRookP)
                     if max([abs(tmp2[0]), abs(tmp2[1])]) == 1:

                        tmp2 = self.shift_c(self.wRookP, self.wKingP)
                        if max([abs(tmp2[0]), abs(tmp2[1])]) > 1:                        
                           continue

                     if self.wRookP[0] == self.bKingP[0] or self.wRookP[1] == self.bKingP[1]:
                        return history+[(self.wRook, wr_moves)]
                  buffer.append(([tmp], self.game_sate(), history+[(self.wRook, wr_moves)]))               
            else:
               for bk_moves in moves[0]:
                  if len(history) > 2:
                     if history[len(history)-2][1] == bk_moves:
                        continue
                  self.update_state(self.bKing, bk_moves)
                  buffer.append(([self.possible_moves(self.wKingP, self.wKing), self.possible_moves(self.wRookP, self.wRook)], self.game_sate(), history+[(self.bKing, bk_moves)]))                  
            self.first = False


         
      


class win_manager:
   def __init__(self):
      self.root = tkinter.Tk()
      self.root.geometry('+%d+%d' % (100,100))
      self.moves = 0
      self.old_label_img = None
      self.board = chess.Board('8/8/8/8/8/8/8/8 w KQkq - 0 1')
      self.img = None

   def add_piece(self, pieces):
      self.board.set_piece_at(pieces[0],chess.Piece.from_symbol(pieces[1]))


   def make_move(self, move):
      self.moves += 1
      mv = chess.Move.from_uci(move[0] + move[1])
      self.board.push(mv)
      self.convert_to_png()

   def convert_to_png(self):
      svg2png(bytestring=chess.svg.board(board=self.board), write_to='board.png')
      self.img = Image.open('board.png') 
      self.change_img()

   def change_img(self):
      self.root.geometry('%dx%d' % (self.img.size[0],self.img.size[1]))
      tkpi = ImageTk.PhotoImage(self.img)
      label_image = tkinter.Label(self.root, image=tkpi)
      label_image.place(x=0,y=0,width=self.img.size[0],height=self.img.size[1])
      self.root.title(str(self.moves) + " move")
      if self.old_label_img is not None:
            self.old_label_img.destroy()
      self.old_label_img = label_image  
      self.root.update()    
      


if __name__ == "__main__":
   main(sys.argv[1:])