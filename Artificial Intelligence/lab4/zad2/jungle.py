import random
from copy import copy, deepcopy
from multiprocessing import Pool
from time import time
from sys import maxint

rat = 0
cat = 1
dog = 2
wolf = 3
panther = 4
tiger = 5
lion = 6
elep = 7

anim_map = ['rat', 'cat', 'dog', 'wolf', 'panther', 'tiger', 'lion', 'eleph']

water = '~'
trap = '#'
win = '*'
field = '.'

PLAYER1 = 0
PLAYER2 = 1

p1_e = [8,3]
p2_e = [0,3]

symbols = ['r', 'c', 'd', 'w', 'j', 't', 'l', 'e']
size = (9,7)

dirs  = [(-1,0), (0,-1), (1,0), (0,1) ]

class Board:


    def __init__(self):
        self.board = [
            ['.', '.', '#', '*', '#', '.', '.'],
            ['.', '.', '.', '#', '.', '.', '.'],
            ['.', '.', '.', '.', '.', '.', '.'],
            ['.', '~', '~', '.', '~', '~', '.'],
            ['.', '~', '~', '.', '~', '~', '.'],
            ['.', '~', '~', '.', '~', '~', '.'],
            ['.', '.', '.', '.', '.', '.', '.'],    
            ['.', '.', '.', '#', '.', '.', '.'],         
            ['.', '.', '#', '*', '#', '.', '.']                                       
        ]

        self.p1 = [[2,0], [1,5], [1,1], [2,4], [2,2], [0,6], [0,0], [2,6]]
        self.p2 = [[6,6], [7,1], [7,5], [6,2], [6,4], [8,0], [8,6], [6,0]]
        self.noKills = 0
        self.player = 0
        self.first = None
        self.hist = []
        self.offSec = False

    def rev(self, player):
        return 1-player

    def print_pawns(self, player):
        if player == PLAYER1:
            pl = self.p1
            res = 'PLAYER1|'
        else: 
            pl = self.p2
            res = 'PLAYER2|'
        
        for i in range(len(pl)):
            anim = pl[i]
            res += anim_map[i] + ':'
            if anim != None:
                res += '1|'
            else: res += '0|'
        return res+'\n'
        
            


    def draw(self):
        tmp = deepcopy(self.board)
        for i in range(len(self.p1)):
            if self.p1[i] != None:
                if tmp[self.p1[i][0]][self.p1[i][1]] == '&':
                    tmp[self.p1[i][0]][self.p1[i][1]] = '!'
                else: tmp[self.p1[i][0]][self.p1[i][1]] = symbols[i].upper()
            if self.p2[i] != None:
                if tmp[self.p2[i][0]][self.p2[i][1]] == '&':
                    tmp[self.p2[i][0]][self.p2[i][1]] = '!'
                else: tmp[self.p2[i][0]][self.p2[i][1]] = symbols[i]

        res = ''
        for line in tmp: 
            for symbol in line: res += symbol + ' '
            res += '\n'
        print res

    def merge(self, loc1, dir): return [loc1[0]+dir[0], loc1[1]+dir[1]]

    def is_valid(self, field, player):
        if field[0] < 0 or field[0] >= size[0]: return False
        if field[1] < 0 or field[1] >= size[1]: return False
        if player == PLAYER1: f = p2_e
        else: f = p1_e
        if field == f: return False
        return True

    def fields(self, loc, player):
        return list(filter(lambda x: self.is_valid(x[0], player), map(lambda dir: (self.merge(loc, dir), dir), dirs)))


    def can_move(self, loc, player, sym, f):
        if player == PLAYER1:
            to_kill = self.p2
            to_check = self.p1
        else:
            to_kill = self.p1
            to_check = self.p2
    
        if loc in to_check: return False
        # check for traps
        if player == PLAYER2:
            if loc in [[0,2],[0,4],[1,3]]: return True
        elif   loc in [[8,2],[8,3],[7,4]]: return True

            
        for i in range(len(to_kill)):
            kill = to_kill[i]
            if kill == None: continue
            if kill == loc:
                if self.board[f[0]][f[1]] == water:
                    return False
                if sym == 0 and i == 7: return True
                elif sym == 7 and i == 0: return False
                elif i > sym:
                    return False
                # cant beat from water to field


        return True


    def check_rat(self, dir, loc):
        if self.board[loc[0]][loc[1]] != water: return loc
        while(self.board[loc[0]][loc[1]] != field):
            if loc == self.p1[0] or loc == self.p2[0]: return None
            loc = self.merge(loc, dir)
        return loc

    def moves(self, player):
        if   player == PLAYER1: sym = self.p1
        elif player == PLAYER2: sym = self.p2
        else: raise 'wrong player'

        res = []

        for i in range(len(sym)):
            pawn = sym[i]
            if pawn == None: continue
            for field, dir in self.fields(pawn, player):
                # check if we can clash other pawn
                if self.can_move(field, player, i, pawn) == False: continue
                # water tile check
                if (i != rat and i != tiger and i != lion) and self.board[field[0]][field[1]] == water: continue
                elif i == tiger or i == lion:
                        nloc = self.check_rat(dir, field)
                        if nloc != None: 
                            if self.can_move(nloc, player, i, pawn): res.append((i, nloc))
                else: res.append((i, field))
        return res

    def do_move(self, move, player):
        if self.first == None:
            self.first = player
        
        if player == PLAYER1: 
            pawns = self.p2
            moved = self.p1
        else: 
            pawns = self.p1
            moved = self.p2

        self.noKills += 1
        pawn, field = move
        for i in range(len(pawns)):
            if pawns[i] == field:
                pawns[i] = None
                self.noKills = 0
        moved[pawn] = field
        self.hist.append((move,player))

    def terminate(self):
        if self.noKills == 60 and self.offSec == False:
            for i in range(len(self.p1)-1, -1, -1):
                if self.p1[i] == None and self.p1[i] != None: return PLAYER1
                elif self.p1[i] != None and self.p1[i] == None: return PLAYER2
            return self.rev(self.first)
        
        for anim in self.p1:
            if anim != None: 
                if anim == p1_e: return PLAYER1
        for anim in self.p2:
            if anim != None: 
                if anim == p2_e: return PLAYER2
        return None    
    
    def est1(self, player):
        if player == PLAYER1:
            anims = self.p1
            enemy = self.p2
            target = p1_e
        else: 
            anims = self.p2
            enemy = self.p1
            target = p2_e
        value = 0
        for i in range(len(enemy)):
            if enemy[i] != None: value -= i*5
            if anims[i] != None: value -= self.manh_dist(anims[i], target)
            else: value -= i*10
        return value
        

    def manh_dist(self, anim, target):
        res = abs(anim[0]-target[0]) + abs(anim[1] - target[1])
        if res == 0: return -100
        else: return res



def max_value(state, alpha, beta, player, mdepth, depth=0):
    if state.terminate() or mdepth == depth: return state.est1(player), None
    value = -maxint - 1
    bMove = None

    boards = [(deepcopy(state), move) for move in state.moves(player)]
    map(lambda a: a[0].do_move(a[1], player), boards)
    boards = [(a[0], a[1], a[0].est1(player)) for a in boards]
    boards.sort(key=lambda b: b[2], reverse=True)

    m = max(boards, key=lambda x: x[2])[2]
    boards = list(filter(lambda x: x[2] == m, boards))
    random.shuffle(boards)

    for board, move, _ in boards:
        nvalue = max(value, min_value(board, alpha, beta, 1-player, mdepth, depth+1)[0])
        if nvalue != value:
            bMove = move
        value = nvalue

        if value >= beta: return value, bMove
        alpha = max(alpha, value)
            
    return value, bMove    


def min_value(state, alpha, beta, player, mdepth, depth=0):
    if state.terminate() or mdepth == depth: return state.est1(player), None
    value = maxint
    bMove = None

    boards = [(deepcopy(state), move) for move in state.moves(player)]
    map(lambda a: a[0].do_move(a[1], player), boards)
    boards = [(a[0], a[1], a[0].est1(player)) for a in boards]
    boards.sort(key=lambda b: b[2], reverse=True)

    m = max(boards, key=lambda x: x[2])[2]
    boards = list(filter(lambda x: x[2] == m, boards))
    random.shuffle(boards)

    for board, move, _ in boards:
        nvalue = min(value, max_value(board, alpha, beta, 1-player, mdepth, depth+1)[0])
        if nvalue != value:
            bMove = move
        value = nvalue

        if value <= alpha: return value, bMove
        beta = min(beta, value)

    return value, bMove      

def alpha_beta_agent(board, player, mDepth=2):
    if mDepth % 2 == 0: m = max_value(board, -maxint-1, maxint, player, mDepth)[1]
    else:               m = min_value(board, -maxint-1, maxint, player, mDepth)[1]    
    if m != None:
        board.do_move(m, player)

def random_agent(board, player):
    moves = board.moves(player)
    if len(moves) == 0: return None
    while(True):
        mv = random.choice(moves)
        if mv in board.hist[-10:]: continue
        board.do_move(mv, player)
        break

def random_game_agent(board, player, Nmoves=20000):
    mvs = board.moves(player)
    if len(mvs) == 0: return None
    won = len(mvs)*[0]
    board.offSec = True
    while(Nmoves > 0):
        for i in range(len(mvs)):
            mv = mvs[i]
            tboard = deepcopy(board)                
            tboard.do_move(mv, player)
            while(True):
                random_agent(tboard, tboard.rev(player))
                random_agent(tboard, player)
                res = tboard.terminate()
                if res != None:
                    if res == player: won[i] += 1
                    break
                Nmoves -= 1       
                if Nmoves < 1: break                
            if Nmoves < 1: break  
    board.offSec = False    
    board.do_move(mvs[won.index(max(won))], player)       

def debug():
    board = Board()
    board.p1[elep] = [3,0]
    board.p2[rat] = [4,0]
    board.draw()

    res = board.moves(PLAYER1)
    res = list(filter(lambda d: d[0] == elep, res))
    B2 = deepcopy(board)
    for r in res:
        B2.board[r[1][0]][r[1][1]] = '&'

    B2.draw()

def game(_, board=Board(), noprint=True):
    agents = (random_game_agent, alpha_beta_agent)
    #print 'agent1:' + agents[0].__name__, 'agent2:' + agents[1].__name__
    ai = random.randint(0, 1) 
    board = Board()
    board.offSec = True
    while(True):
        if noprint == False:
            board.draw()        
            print board.noKills
            print board.print_pawns(PLAYER1), board.print_pawns(PLAYER2), '|AI='+str(ai)+'|'
        agents[ai](board, PLAYER1)
        agents[1-ai](board, PLAYER2)
        board.offSec = True        
        res = board.terminate()
        if res != None:
            if ai == res: return 1
            return -1

def do_games(games=10, proc=4):
    pool = Pool(processes=proc)
    time1 = time()
    won = 0
    lost = 0
    
    for res in pool.imap_unordered(game, range(games)):
    #res = game(1)
        if res == 1:    won += 1
        elif res == -1: lost += 1
    time2 = time()

    min = int(time2-time1) / 60
    sec = int(time2-time1) - min*60

    print "time: {:02d}:{:02d} | games: {:4d} | agent1 win: {:.2f}% | agent2 win: {:.2f}%".format(min, sec, games, (won/float(won+lost))*100, (lost/float(won+lost))*100)



#debug()
do_games()
