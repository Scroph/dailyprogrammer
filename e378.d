import std;

void main()
{

}

int[] warmup1(int[] input)
{
    return input.filter!(a => a != 0).array;
}

unittest
{
    static assert(warmup1([5, 3, 0, 2, 6, 2, 0, 7, 2, 5]) == [5, 3, 2, 6, 2, 7, 2, 5]);
    static assert(warmup1([4, 0, 0, 1, 3]) == [4, 1, 3]);
    static assert(warmup1([1, 2, 3]) == [1, 2, 3]);
    static assert(warmup1([0, 0, 0]).empty);
    static assert(warmup1([]).empty);
}

int[] warmup2(int[] input)
{
    return input.sort.retro.array;
}

unittest
{
    static assert(warmup2([5, 1, 3, 4, 2]) == [5, 4, 3, 2, 1]);
    static assert(warmup2([0, 0, 0, 4, 0]) == [4, 0, 0, 0, 0]);
    static assert(warmup2([1]) == [1]);
    static assert(warmup2([]).empty);
}

bool warmup3(int length, int[] input)
{
    return length > input.length;
}

unittest
{
    static assert(warmup3(7, [6, 5, 5, 3, 2, 2, 2]) == false);
    static assert(warmup3(5, [5, 5, 5, 5, 5]) == false);
    static assert(warmup3(5, [5, 5, 5, 5]) == true);
    static assert(warmup3(3, [1, 1]) == true);
    static assert(warmup3(1, []) == true);
    static assert(warmup3(0, []) == false);
}

int[] warmup4(int length, int[] input)
{
    return input.take(length).map!(n => n - 1).chain(input.drop(length)).array;
}

unittest
{
    static assert(warmup4(4, [5, 4, 3, 2, 1]) == [4, 3, 2, 1, 1]);
    static assert(warmup4(11, [14, 13, 13, 13, 12, 10, 8, 8, 7, 7, 6, 6, 4, 4, 2]) == [13, 12, 12, 12, 11, 9, 7, 7, 6, 6, 5, 6, 4, 4, 2]);
    static assert(warmup4(1, [10, 10, 10]) == [9, 10, 10]);
    static assert(warmup4(3, [10, 10, 10]) == [9, 9, 9]);
    static assert(warmup4(1, [1]) == [0]);
}

bool hh(int[] input)
{
    auto sequence = input;
    while(true)
    {
        auto stripped = sequence.warmup1();
        if(stripped.empty)
        {
            return true;
        }
        auto sorted = stripped.warmup2();
        int N = sorted.front;
        sorted.popFront();
        if(N.warmup3(sorted))
        {
            return false;
        }
        sequence = N.warmup4(sorted);
    }
}

unittest
{
    static assert(hh([5, 3, 0, 2, 6, 2, 0, 7, 2, 5]) == false);
    static assert(hh([4, 2, 0, 1, 5, 0]) == false);
    static assert(hh([3, 1, 2, 3, 1, 0]) == true);
    static assert(hh([16, 9, 9, 15, 9, 7, 9, 11, 17, 11, 4, 9, 12, 14, 14, 12, 17, 0, 3, 16]) == true);
    static assert(hh([14, 10, 17, 13, 4, 8, 6, 7, 13, 13, 17, 18, 8, 17, 2, 14, 6, 4, 7, 12]) == true);
    static assert(hh([15, 18, 6, 13, 12, 4, 4, 14, 1, 6, 18, 2, 6, 16, 0, 9, 10, 7, 12, 3]) == false);
    static assert(hh([6, 0, 10, 10, 10, 5, 8, 3, 0, 14, 16, 2, 13, 1, 2, 13, 6, 15, 5, 1]) == false);
    static assert(hh([2, 2, 0]) == false);
    static assert(hh([3, 2, 1]) == false);
    static assert(hh([1, 1]) == true);
    static assert(hh([1]) == false);
    static assert(hh([]) == true);
}
