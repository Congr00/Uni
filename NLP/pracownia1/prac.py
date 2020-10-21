import re
import random
from itertools import permutations
from functools import reduce


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
    #grep -Eo "[a-zA-Zżźćółńśąę]+" train_shuf.txt | tr '[:upper:]' '[:lower:]' | sort -u > dict.txt
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
                break
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
                break
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

'''
Sąsiad. - od głosu? dziękuję. proszę o pomoc w tym wszystkim, i że w mojej pracy, 3) na dziś chyba jednak nie potrzebuję przełomowy dla gmin, które nie u lekarza do innych możliwości realizowania przez pana zdaniem, nie jest szefem komisji polityki społecznej jest fakt, iż w dodatku nie mającej na postawione w programie telewizyjnym programie jest wielu młodych ludzi, a więc byłem zwolennikiem tego, by zabić - no bo na siebie jako swojego miejsca w rybniku. 
Wskazanym kierunku. wzajemnych stosunkach z kasy chorych w tym względzie, sąd okręgowy w ostatnich latach, gdy w tym nie jest to prawda, że nie słyszę. 
'''

def generate_bigram_of(list_of_lists):
    words = set(reduce(list.__add__, list_of_lists))
    dict = {}
    with open('../train data/2grams', 'r', encoding='utf8') as bigram:
        for line in bigram:
            spl = [l for l in line.strip().lower().split(' ') if l]
            occ, w1, w2 = int(spl[0]), spl[1], spl[2]
            if w1 not in words:
                continue
            if w1 in dict:
                _, l, _ = dict[w1][-1]
                dict[w1].append((l+1, occ + l, w2))
            else:
                dict[w1] = [(0, occ, w2)]
    return dict

def zad4():
    def perm_heu(permutation_list, dict):
        res = []
        for w1, w2 in zip(permutation_list, permutation_list[1:]):
            if not w1 in dict:
                continue
            else:
                asc = dict[w1]
                score = 0
                _, last, _ = asc[-1]
                for lr, hr, w in asc:
                    if w == w2:
                        score = (hr - lr + 1) / last
                res.append(score)
        return (' '.join(permutation_list), sum(res))

    test_data = [
        'Judyta dała wczoraj Stefanowi czekoladki',
        'Babuleńka miała dwa rogate koziołki',
        'Wczoraj wieczorem spotkałem pewną piękną kobietę',
        'Dlaczego zawsze mam największego pecha',
        'To był mój najlepszy zagrany mecz w życiu',
        'Ciągle nie mogę uwierzyć w to, co tam zobaczyłem',
        'Po raz pierwszy zauważyłem ten szczegół',
        'Zjadłem pyszną kanapkę z szynką i serem'
    ]
    results = []
    dict = generate_bigram_of([test.lower().split(' ') for test in test_data])

    for test in test_data:
        results.append((test, [perm_heu(perm, dict) for perm in permutations(test.lower().split(' '))]))

    for test, perm_list in results:
        perm_list.sort(reverse=True, key=lambda x: x[1])
        print(u'test: {0}\n1* - {1}\n2* - {2}\n'.format(test, perm_list[0], perm_list[1]))

zad4()

def zad5():
    max_prefix = 5
    def perm_heu(permutation_list, dict):
        res = []
        for w1, w2 in zip(permutation_list, permutation_list[1:]):
            asc = dict[w1]
            score = 0
            _, last, _ = asc[-1]
            for lr, hr, w in asc:
                for i in range(1, max_prefix):
                    if w2[:-i] == w:
                        score += (hr - lr + 1) / last * (i * 2)
                if w == w2:
                    score += (hr - lr + 1) / last
            res.append(score)
        return (' '.join(permutation_list), sum(res))

    def extend(list):
        max_l = len(list)
        for i in range(max_l):
            w = list[i]
            for i in range(1, max_prefix):
                if i >= len(w):
                    break
                list.append(w[:-i])
        return list

    test_data = [
        #'Judyta dała wczoraj Stefanowi czekoladki',
        #'Babuleńka miała dwa rogate koziołki',
        #'Wczoraj wieczorem spotkałem pewną piękną kobietę',
        #'Dlaczego zawsze mam największego pecha',
        #'To jest jakaś masakra',
        #'To był mój najlepszy zagrany mecz',
        #'Wciąż nie mogę w to uwierzyć',
        #'Po raz pierwszy zauważyłem ten szczegół',
        'Zjadłem pyszną kanapkę z szynką i serem'
    ]
    results = []
    test_dict_data = [extend(test.lower().split(' ')) for test in test_data]
    dict = generate_bigram_of([test for test in test_dict_data])

    for test in test_data:
        results.append((test, [perm_heu(perm, dict) for perm in permutations(test.lower().split(' '))]))

    for test, perm_list in results:
        perm_list.sort(reverse=True, key=lambda x: x[1])
        print(u'test: {0}\n1* - {1}\n2*'.format(test, perm_list[0], perm_list[1]))
