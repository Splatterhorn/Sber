import itertools


def str_max_sum(lst):
    res = []
    for i in itertools.permutations(lst):
        res.append(int(''.join(i)))
    return max(res)


if __name__ == '__main__':
    L1 = ['41', '4', '005', '89']
    L2 = ['0385', '50', '077', '1146']
    L3 = ['684', '2071', '094', '3725']
    for num_lst in (L1, L2, L3):
        print(str_max_sum(num_lst))
