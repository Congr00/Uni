import re
import random
from itertools import permutations

def max_match(string, dict):
    index = 0
    max_len = 0
    for key in dict:
        max_len = max(max_len, len(key))
    tokens = []
    while True:
        if index >= len(string):
            return tokens
        word = ''
        curr_word = ''
        for j, cj in enumerate(string[index:]):
            curr_word += cj
            if curr_word in dict:
                word = curr_word
            elif j > max_len:
                tokens.append(word)
                index = index + len(word)
                break
            if j >= len(string[index:])-1:
                index = index + len(word)
                tokens.append(word)

def corpus_to_dict():
    dict = {}
    with open('../train data/dict.txt') as corpus:
        for line in corpus:
            dict[line.strip()] = True
    return dict

def check_similarity(generated_tokens, tokens):
    res = 0
    tokens = set(tokens)
    generated_tokens = set(generated_tokens)
    for gtoken in generated_tokens:
        if gtoken in tokens:
            res += 1
    return res / len(tokens)

def generate_test_data():
    data = []
    num = 0
    RE = re.compile(r'[a-zA-ZęóąśłżźćńĘÓĄŚŁŻŹĆŃ\-]+')
    with open('../train data/task3_train.txt') as corpus:
        for line in corpus:
            data.append([word.lower() for word in re.findall(RE, line)])
            num += 1
            if num > 25000:
                return data

def zad1():
    dict = corpus_to_dict()
    scores = []
    for tokens in generate_test_data():
        gen_tokens = max_match(''.join(tokens), dict)
        assert ''.join(gen_tokens) == ''.join(tokens), "\n" + ''.join(gen_tokens) + "\n" + ''.join(tokens)
        scores.append(check_similarity(gen_tokens, tokens))

    print(sum(scores) / len(scores))

def generate_bigram():
    dict = {}
    with open('../train data/2grams', 'r', encoding='utf8') as bigram:
        for line in bigram:
            spl = [l for l in line.strip().lower().split(' ') if l]
            occ, w1, w2 = int(spl[0]), spl[1], spl[2]
            if occ < 50:
                continue
            if w1 in dict:
                _, l, _ = dict[w1][-1]
                dict[w1].append((l+1, occ + l, w2))
            else:
                dict[w1] = [(0, occ, w2)]
    return dict

def generate_trigram():
    dict = {}
    with open('../train data/3grams') as bigram:
        for line in bigram:
            spl = [l for l in line.strip().lower().split(' ') if l]
            occ, w1, w2, w3 = int(spl[0]), spl[1], spl[2], spl[3]
            if occ < 50:
                continue
            if w1 in dict:
                _, l, _ = dict[w1][-1]
                dict[w1].append((l+1, occ + l, w2))
            else:
                dict[w1] = [(0, occ, w2)]
            if w2 in dict:
                _, l, _ = dict[w2][-1]
                dict[w2].append((l+1, occ + l, w3))
            else:
                dict[w2] = [(0, occ, w3)]
    return dict

def zad2(bigram=True):
    dict = generate_bigram() if bigram else generate_trigram()
    word = ''
    curr_word = ''
    asc = []
    rng = random.Random()
    while True:
        if not curr_word or curr_word not in dict:
            curr_word, _ = rng.choice(list(dict.items()))
        else:
            asc = dict[curr_word]
            num = rng.randrange(0, len(asc))
            _, _, curr_word = asc[num]
        word += curr_word + ' '
        if curr_word.endswith('.') and len(word) > 30:
            word = word[0].upper() + word[1:]
            return word

def zad3(bigram=True):
    dict = generate_bigram() if bigram else generate_trigram()
    word = ''
    curr_word = ''
    asc = []
    rng = random.Random()
    while True:
        if not curr_word or curr_word not in dict:
            curr_word, _ = rng.choice(list(dict.items()))
        else:
            asc = dict[curr_word]
            _, mx, _ = asc[-1]
            num = rng.randrange(0, mx)
            for lr, hr, w in asc:
                if num >= lr and num <= hr:
                    curr_word = w
        word += curr_word + ' '
        if curr_word.endswith('.') and len(word) > 50:
            word = word[0].upper() + word[1:]
            return word

def zad4(bigram=True):

    dict = generate_bigram() if bigram else generate_trigram()

    def perm_heu(permutation_list):
        res = []
        for w1, w2 in zip(permutation_list, permutation_list[1:]):
            if not w1 in dict:
                res.append(-10)
            else:
                asc = dict[w1]
                score = 0
                for lr, hr, w in asc:
                    if w == w2:
                        score = hr - lr
                res.append(score)
        print(res)
        return (' '.join(permutation_list), sum(res))

    test_data = [
        'Judyta dała wczoraj Stefanowi czekoladki',
        'Babuleńka miała dwa rogate koziołki',
        'Wczoraj wieczorem spotkałem pewną piękną kobietę'
    ]
    results = []
    for test in test_data:
        results.append((test, [perm_heu(perm) for perm in permutations(test.lower().split(' '))]))

    for test, perm_list in results:
        perm_list.sort(reverse=True, key=lambda x: x[1])
        print(u'test: {0}\n1* - {1}\n2* - {2}\n3* - {3}\n4* - {4}'.format(test, perm_list[0], perm_list[1], perm_list[2], perm_list[3]))

zad4()
