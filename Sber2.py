import itertools
# На прямой дороге расположено n банкоматов. Было решено построить ещё k банкоматов для того,
# чтобы уменьшить расстояние между соседними банкоматами.
# На вход подаются натуральные числа n и k, а также n-1 расстояний L, где Li  – расстояние между банкоматами i и i+1.
# Напишите функцию, которая добавляет k банкоматов таким образом, чтобы максимальное расстояние между соседними
# банкоматами являлось минимально возможным, и возвращает список новых расстояний между банкоматами.
# ВВОД: 5 3 100 30 20 80
# ВЫВОД: 33,3 33,3 33,3 30 20 40 40


def placer(n, k, lst):
    intervals = n - 1
    amount = k + intervals
    parts = k + 1
    variants = [x for x in itertools.product(range(1, parts + 1), repeat=intervals) if sum(x) == amount]
    maximums = []
    for x in variants:
        gaps_lengths = list(zip(x, lst))
        result = []
        for y in gaps_lengths:
            result.extend([y[1] / y[0]] * y[0])
        maximums.append(max(result))
        if max(result) == min(maximums):
            out = [round(x, 1) for x in result]
    return out


if __name__ == '__main__':
    a = 5, 3, [100, 30, 20, 80]
    b = 4, 6, [55, 70, 110]
    c = 7, 7, [38, 54, 120, 81, 67, 105]
    for var in a, b, c:
        print(placer(*var))
