from copy import deepcopy
import sys


grass = '.'
road = '#'
oil = 'o'
finish = 'e'
start = 's'

class Board:

    def __init__(self, file):
        f = None

        try: f = open(file, 'r')
        except:
            print('error while reading file: ' + file)
            sys.exit(2)

        d_lukasz = [list((line.rstrip('\n').replace(start, road))) for line in f] # very dumb !
        self.board = [[None for _ in range(len(d_lukasz[0]))] for _ in range(len(d_lukasz[1]))]

        for y, l in enumerate(d_lukasz):
            for x, v in enumerate(l):
                self.board[x][y] = v

        f.close()

    def reward(self, field):
        if field == road or field == oil: return -0.1
        elif field == finish: return 100
        else: return -100 
    
    def gen_states(self):
        res = dict()
        for x in range(len(self.board)):
            for y in range(len(self.board[x])):
                if self.board[x][y] == grass: continue
                for vx in range(-3, 4):
                    for vy in range(-3, 4):
                        res[((x,y), (vx, vy))] = (0.0, (0, 0))
        return res

    def actions(self, pos):
        res = []
        surface = self.get_surface(pos)
        if surface == road or surface == oil:
            for i in range(-1, 2):
                for j in range(-1, 2):
                    res.append((i, j))
        return res

    def get_surface(self, pos):
        if pos[0] < 0 or pos[1] < 0:       return grass
        elif pos[0] >= len(self.board):    return grass
        elif pos[1] >= len(self.board[0]): return grass
        return self.board[pos[0]][pos[1]]
            

    def states(self, pos, vel, action):
        surface = self.get_surface(pos)
        if surface == road: return [(1.0, self.do_action(pos, vel, action))]
        elif surface == oil: 
            return [(1.0/9.0, self.do_action(pos, (vel[0]+x, vel[1]+y), action)) for x, y in self.actions(pos)]
        return []

    def saturated(self, min_, max_, val):
        return max(min_, min(max_, val))
    
    def do_action(self, pos, vel, action):
        vel = (self.saturated(-3, 3, vel[0] + action[0]), self.saturated(-3, 3, vel[1] + action[1]))
        pos = (pos[0]+vel[0], pos[1]+vel[1])
        return (pos, vel)


    def run(self):
        def curie(f):
            def aux(args):
                return f(*args)

            return aux

        states = self.gen_states()
        while(True):
            theta = 0.0
            copyState = deepcopy(states)
            for k, v in states.items():
                actions = []
                for action in self.actions(k[0]):
                    score = sum(
                        map(
                            curie(lambda p, s: p * (self.reward(self.get_surface(s[0])) + 0.99 * copyState.get(s, (0.0, 0.0))[0])),      
                            self.states(k[0], k[1], action)
                        )
                    )
                    actions.append((score, action))

                best = max(actions, key=lambda x: x[0], default=None)
                if best != None:
                    delta = abs(best[0] - v[0])
                    if delta > theta:
                        theta = delta

                    states[k] = best

            if theta < 0.001: break
            print('theta = ' + str(theta))
            
        with open('cars/policy_for_task{}.txt'.format(num), 'w') as output:
            for k, v in states.items():
                output.write('{} {} {} {}     {} {}\n'.format(k[0][0], k[0][1], k[1][0], k[1][1], v[1][0], v[1][1]))
        
num = 11
B = Board('cars/task{}.txt'.format(num))
B.run()
