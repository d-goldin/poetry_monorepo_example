import numpy

def give_me_numbers():
    return numpy.random.randint(0, 1000, size=(10,10))

if __name__ == '__main__':
    print(give_me_numbers())
