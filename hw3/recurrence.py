def f(n):
    if n == 0:
        return 0
    if n == 1:
        return 1
    return 2 * f(n-1)+f(n-2)


print(f(15))