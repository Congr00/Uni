
import numpy as np

card_map = {
    'A':0 ,
    'K':1 ,
    'Q':2 ,
    'J':3 ,
    '10':4,
    '9':5 ,
    '8':6 ,
    '7':7 ,
    '6':8 ,
    '5':9 ,
    '4':10,
    '3':11,
    '2':12
}

figurant_deck = [
    ([1,1,1,1],'A'), ([1,1,1,1], 'K'), ([1,1,1,1], 'Q'), ([1,1,1,1], 'J')
]

blotkarz_deck = [
    ([0,0,0,1], '10'), ([0,0,0,1], '9'), ([0,0,0,1], '8'), ([0,0,0,1], '7'), 
    ([1,1,1,1], '6'), ([0,0,0,1], '5'), ([0,0,0,1], '4'), ([0,0,0,1], '3'), 
    ([1,1,1,1], '2')
]

color_map = {
    0: 'H', # hearts
    1: 'T', # tiles
    2: 'C', # clover
    3: 'P'  # pikes
}

class deck_man:
    def __init__(self, cards):
        self.num_cards = 0
        self.deck = []
        for num, value in cards:
            for i in range(0,4):
                if num[i] == 1:
                    self.deck.append((i, card_map[value]))
                    self.num_cards += 1
        if len(self.deck) < 5:
            raise('Need at least 5 cards in a deck')
        np.random.shuffle(self.deck)
        self.hand = []

    def get_hand(self):
        self.hand = np.array(self.deck[:5])
        self.hand = self.hand[self.hand[:,1].argsort()]

    def reshuffle(self):
        np.random.shuffle(self.deck)

    def print_hand(self):
        res = []
        for color, value in self.hand:
            res.append((color_map[color], value))
        print(res)

    def hand_value(self):
        value = 0
        cards = np.array([0,0,0,0,0,0,0,0,0,0,0,0,0])
        colors = np.array([0,0,0,0])
        for color, value in self.hand:
            cards[value] += 1
            colors[color] += 1
        # poker
        if np.amax(colors) == 5: 
            poker = True
            last = None
            for _, value in self.hand:
                if last is None:
                    last = value
                    continue
                if value - last == 1:
                    last = value
                else:
                    poker = False
                    break
            if poker is True:
                return 8*20 + (12-np.argmax(cards))
        # quads
        if np.amax(cards) == 4:
            return 7*20 + (12-np.where(cards == 4)[0][0])
        # full house
        if len(np.where(cards == 3)[0]) == 1 and len(np.where(cards == 2)[0]) == 2:
            return 6*20 + (12-np.where(cards == 3)[0][0])
        # flush
        if np.amax(colors) == 5:
            return 5*20 + (12-np.argmax(cards))
        # strit
        strit = True
        last = None
        for _, value in self.hand:
            if last is None:
                last = value
                continue
            if value - last == 1:
                last = value
            else:
                strit = False
                break
        if strit is True:
            return 4*20 + (12-np.argmax(cards))
        # triple
        if len(np.where(cards == 3)[0]) == 1:
            return 3*20 + (12-np.argmax(cards))
        # double pair
        if len(np.where(cards == 2)[0]) == 2:
            return 2*20 + (12-np.argmax(cards))
        # pair
        if len(np.where(cards == 2)[0]) == 1:
            return 20 + (12-np.argmax(cards))
        return 0

def monte_carlo(n, deck1, deck2):
    win = 0.0
    for i in range(0, n):
        deck1.get_hand()
        deck2.get_hand()
        hv1 = deck1.hand_value()
        hv2 = deck2.hand_value()
        if hv1 > hv2:
            win += 1

        deck1.reshuffle()
        deck2.reshuffle()

    return win / n * 100

f_deck = deck_man(figurant_deck)
b_deck = deck_man(blotkarz_deck)

_N = 9999

print('figurant wins:', monte_carlo(_N, f_deck, b_deck), '%')

