import random
import sys
from collections import defaultdict as dd
from turtle import *
from sys import maxint
from copy import deepcopy
from sys import stdout
from multiprocessing import Pool
from random import randint
from time import time
import math

#####################################################
# turtle graphic
#####################################################
#tracer(0,1)

BOK = 50
SX = -100
SY = 0
M = 8


def kwadrat(x, y, kolor):
  fillcolor(kolor)
  pu()
  goto(SX + x * BOK, SY + y * BOK)
  pd()
  begin_fill()
  for i in range(4):
    fd(BOK)
    rt(90)
  end_fill() 

def kolko(x, y, kolor):
  fillcolor(kolor)

  pu()
  goto(SX + x * BOK + BOK/2, SY + y * BOK - BOK)
  pd()
  begin_fill()
  circle(BOK/2)
  end_fill() 

#####################################################

def initial_board():
    B = [ [None] * M for i in range(M)]
    B[3][3] = 1
    B[4][4] = 1
    B[3][4] = 0
    B[4][3] = 0
    return B

weights = [
    [ 50. , -1.  , 5. , 2. , 2. , 5. , -1.  , 50. ] ,
    [ -1. , -10. , 1. , 1. , 1. , 1. , -10. , -1. ] ,
    [ 5.  , 1.   , 1. , 1. , 1. , 1. , 1.   , 5.  ] ,
    [ 2.  , 1.   , 1. , 0. , 0. , 1. , 1.   , 2.  ] ,
    [ 2.  , 1.   , 1. , 0. , 0. , 1. , 1.   , 2.  ] ,
    [ 5.  , 1.   , 1. , 1. , 1. , 1. , 1.   , 5.  ] ,
    [ -1. , -10. , 1. , 1. , 1. , 1. , -10. , -1. ] ,
    [ 50. , -1.  , 5. , 2. , 2. , 5. , -1.  , 50. ]
]
class Board:
    dirs  = [ (0,1), (1,0), (-1,0), (0,-1), (1,1), (-1,-1), (1,-1), (-1,1) ]
    
    
    def __init__(self, depth=3):
        self.board = initial_board()
        self.fields = set()
        self.move_list = []
        #self.history = []
        self.max_depth = depth
        for i in range(M):
            for j in range(M):
                if self.board[i][j] == None:   
                    self.fields.add( (j,i) )
                                                
    def draw(self):
        for i in range(M):
            res = []
            for j in range(M):
                b = self.board[i][j]
                if b == None:
                    res.append('.')
                elif b == 1:
                    res.append('#')
                else:
                    res.append('o')
            print ''.join(res) 
        print            
        
    
    def show(self):
        for i in range(M):
            for j in range(M):
                kwadrat(j, i, 'green')
                
        for i in range(M):
            for j in range(M):                
                if self.board[i][j] == 1:
                    kolko(j, i, 'black')
                if self.board[i][j] == 0:
                    kolko(j, i, 'white')
                                   
    def moves(self, player):
        res = []
        for (x,y) in self.fields:
            if any( self.can_beat(x,y, direction, player) for direction in Board.dirs):
                res.append( (x,y) )
        if not res:
            return [None]
        return res               
    
    def can_beat(self, x,y, d, player):
        dx,dy = d
        x += dx
        y += dy
        cnt = 0
        while self.get(x,y) == 1-player:
            x += dx
            y += dy
            cnt += 1
        return cnt > 0 and self.get(x,y) == player
    
    def get(self, x,y):
        if 0 <= x < M and 0 <=y < M:
            return self.board[y][x]
        return None
                        
    def do_move(self, move, player):
        #self.history.append([x[:] for x in self.board])
        self.move_list.append(move)
        
        if move == None:
            return
        x,y = move
        x0,y0 = move
        self.board[y][x] = player
        self.fields -= set([move])
        for dx,dy in self.dirs:
            x,y = x0,y0
            to_beat = []
            x += dx
            y += dy
            while self.get(x,y) == 1-player:
              to_beat.append( (x,y) )
              x += dx
              y += dy
            if self.get(x,y) == player:              
                for (nx,ny) in to_beat:
                    self.board[ny][nx] = player
        
        return self

    def result(self):
        res = 0
        for y in range(M):
            for x in range(M):
                b = self.board[y][x]                
                if b == 0:
                    res -= 1
                elif b == 1:
                    res += 1
        return res
                
    def terminal(self, depth=maxint):
        if self.max_depth == depth: return True
        if not self.fields:
            return True
        if len(self.move_list) < 2:
            return False
        return self.move_list[-1] == self.move_list[-2] == None 

    def random_move(self, player):
        ms = self.moves(player)
        if ms:
            return random.choice(ms)
        return [None]    



    def est1(self, player, w=True):
        count = 0
        for i in range(M): 
            for j in range(M):                
                if self.board[i][j] == player: 
                    if w: count+=weights[i][j]
                    else: count += 1
        return count


def max_value(state, alpha, beta, player, depth=0):
    if state.terminal(depth): return state.est1(player), None
    value = -maxint - 1
    bMove = None
    #'''
    boards = [(deepcopy(state), move) for move in state.moves(player)]
    map(lambda a: a[0].do_move(a[1], player), boards)
    boards.sort(key=lambda b: b[0].est1(player), reverse=True)

    for board, move in boards:
        nvalue = max(value, min_value(board, alpha, beta, 1-player, depth+1)[0])
        if nvalue != value:
            bMove = move
        value = nvalue

        if value >= beta: return value, bMove
        alpha = max(alpha, value)
            
    '''
    for move in state.moves(player):
        board = deepcopy(state)
        board.do_move(move, player)
        nvalue = max(value, min_value(board, alpha, beta, 1-player, depth+1)[0])
        if nvalue != value:
            bMove = move
        value = nvalue

        if value >= beta: return value, bMove
        alpha = max(alpha, value)
    #'''

    return value, bMove    


def min_value(state, alpha, beta, player, depth=0):
    if state.terminal(depth): return state.est1(player), None
    value = maxint
    bMove = None
    #'''
    boards = [(deepcopy(state), move) for move in state.moves(player)]
    map(lambda a: a[0].do_move(a[1], player), boards)
    boards.sort(key=lambda b: b[0].est1(player), reverse=True)

    for board, move in boards:
        nvalue = min(value, max_value(board, alpha, beta, 1-player, depth+1)[0])
        if nvalue != value:
            bMove = move
        value = nvalue

        if value <= alpha: return value, bMove
        beta = min(beta, value)
    '''
    for move in state.moves(player):
        board = deepcopy(state)
        board.do_move(move, player)loose
        nvalue = min(value, max_value(board, alpha, beta, 1-player, depth+1)[0])
        if nvalue != value: bMove = move
        value = nvalue

        if value <= alpha: return value, bMove
        beta = min(beta, value)
    #'''

    return value, bMove        
     

def game(_):
    ai = randint(0, 1)
    player = 0

    B = Board(mDepth)
    while True:
        if player == ai:
            '''
            if mDepth % 2 == 0: m = max_value(B, -maxint-1, maxint, player)[1]
            else:               m = min_value(B, -maxint-1, maxint, player)[1]
            '''
            m = random_game_agent(B, player)            
        else:    
            m = B.random_move(player)
        B.do_move(m, player)     
        player = 1-player
        if B.terminal():
            res = B.result()
            if ai == 0:
                if res < 0: return 1
                elif res > 0: return -1
            else:
                if res > 0: return 1
                elif res < 0: return -1                
            return 0

def random_game_agent(board, player, Nmoves=150):
    mvs = board.moves(player)
    if len(mvs) == 0: return None
    won = len(mvs)*[0]
    
    while(Nmoves > 0):
        for i in range(len(mvs)):
            mv = mvs[i]
            tboard = deepcopy(board)
            tboard.do_move(mv, player)
            while(True):
                m = tboard.random_move(1-player)
                tboard.do_move(m, 1-player)
                m = tboard.random_move(player)
                tboard.do_move(m, player)
                if tboard.terminal():
                    pl1 = tboard.est1(player, False)
                    
                    if pl1 > 64-pl1:   won[i] += 1
                    break
            Nmoves -= 1  
            if Nmoves < 1: break
    
    board.offSec = False    
    return mvs[won.index(max(won))]

def mcts(board, player, iter=80):
    class Node:
        def __init__(self, state, parent):
            self.state = state
            self.parent = parent
            self.children = []
            
    class Tree:
        def __init__(self, r):
            self.Root = r

    class State:
        def __init__(self, board, player):
            self.board = board
            self.playerNo = 0
            self.visitCount = 0
            self.score = 0.0
            self.player = player
            self.mv = None
        
        def possible_states(self):
            return [State(deepcopy(self.board).do_move(mv, self.player), self.player) for mv in self.board.moves(self.player)]
        
        def random_play(self):
            mv = self.board.random_move(self.player)
            self.board.do_move(mv, self.player)
        
    def selectPromisingNode(root):
        node = root
        while(len(node.children) != 0):
            node = findNodeWithUTC(node)
        return node

    def utcVal(totalVisit, nodeScore, nodeVisit):
        if nodeVisit == 0:  return float('inf')
        return float(nodeScore) / float(nodeVisit) + 1.41 * math.sqrt(math.log(totalVisit) / float(nodeVisit))

    def findNodeWithUTC(node):
        pvisit = node.state.visitCount
        return max(node.children, key=lambda x: utcVal(pvisit, x.state.score, x.state.visitCount))

    def expandNode(node):
        states = node.state.possible_states()
        for state in states:
            if state.board == None: continue
            newNode = Node(state, node)
            newNode.state.player = 1-node.state.player
            node.children.append(newNode)

    def backProp(nodeToEx, player):
        tmp = nodeToEx
        while(tmp != None):
            tmp.state.visitCount+=1
            if tmp.state.player == player:
                tmp.state.score += WIN_SCORE
            tmp = tmp.parent
    
    def simulateRandomPlayout(node):
        tmp = deepcopy(node)
        tmpState = tmp.state
        res = tmpState.board.terminal()

        if res:
            pl = tmpState.board.est1(PLAYER, False)
            if pl < 64-pl:
                tmp.parent.state.score = float('-inf')
                return PLAYER
        while(res == False):
            tmpState.player = 1-tmpState.player
            tmpState.random_play()
            res = tmpState.board.terminal()
        pl = tmpState.board.est1(PLAYER, False)
        return PLAYER if pl < 64-pl else 1-PLAYER 



    PLAYER = player
    WIN_SCORE = 10
    level = 0
    opponent = 1-player
    tree = Tree(Node(State(board, player), None))

    while(iter > 0):
        iter -= 1
        promNode = selectPromisingNode(tree.Root)
        if promNode.state.board.terminal() == False:
            expandNode(promNode)
        nodeToEx = promNode

        if len(promNode.children) > 0:
            nodeToEx = random.choice(promNode.children)
        result = simulateRandomPlayout(nodeToEx)
        backProp(nodeToEx, result)
    if len(tree.Root.children) == 0: return board
    winner = max(tree.Root.children, key=lambda x: x.state.score)
    tree.Root = winner
    return winner.state.board

def mc_game(_):
    ai1 = randint(0, 1)
    player = 0
    ai1m = 'o' if ai1 == 0 else '#'
    B = Board(mDepth)
    while True:
        #B.draw()
        
        #print 'mcts player: ' + ai1m  
        #if player == ai1:      
        B = mcts(B, player)
        #else:    
        #    m = B.random_move(player)  
        #    B.do_move(m, player)

        player = 1-player
        #raw_input()
        if B.terminal():
            res = B.result()
            if ai1 == 0:
                if res < 0: return 1
                elif res > 0: return -1
            else:
                if res > 0: return 1
                elif res < 0: return -1                
            return 0


    



games = 100
mDepth = 4

  
pool = Pool(processes=4)
time1 = time()

won = 0
lost = 0

'''
for res in pool.imap_unordered(game, range(games)):
    if res == 1:    won += 1
    elif res == -1: lost += 1
'''

'''
for res in pool.imap_unordered(mc_game, range(games)):
    if res == 1:    won += 1
    elif res == -1: lost += 1
'''

res = mc_game(None)

if res == 1: won += 1
elif res == -1: lost += 1
else:
    print 'draw'
    exit()

time2 = time()

min = int(time2-time1) / 60
sec = int(time2-time1) - min*60

print "time: {:02d}:{:02d} | games: {:4d} | ai win: {:.2f}% | random win: {:.2f}%".format(min, sec, games, (won/float(won+lost))*100, (lost/float(won+lost))*100)

sys.exit(0)                 
