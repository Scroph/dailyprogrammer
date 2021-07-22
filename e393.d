//https://www.reddit.com/r/dailyprogrammer/comments/nucsik/20210607_challenge_393_easy_making_change/
import std.stdio : writeln;
import std.algorithm : sum;

void main()
{
}

int change(int input)
{
    return input.calculateChange.values.sum;
}

unittest
{
    static assert(468.change == 11);
    static assert(1034.change == 8);
    static assert(0.change == 0);
}

int[int] calculateChange(int input)
{
    int[] order = [500, 100, 25, 10, 5, 1];
    int[int] coins = [
        500: 0,
        100: 0,
        25: 0,
        10: 0,
        5: 0,
        1: 0
    ];

    foreach(coin; order)
    {
        coins[coin] = input / coin;
        input %= coin;
    }

    return coins;
}

unittest
{
    static assert(468.calculateChange == [
        500: 0,
        100: 4,
        25: 2,
        10: 1,
        5: 1,
        1: 3
    ]);

    static assert(1034.calculateChange == [
        500: 2,
        100: 0,
        25: 1,
        10: 0,
        5: 1,
        1: 4
    ]);

    static assert(0.calculateChange == [
        500: 0,
        100: 0,
        25: 0,
        10: 0,
        5: 0,
        1: 0
    ]);
}
