//https://www.reddit.com/r/dailyprogrammer/comments/np3sio/20210531_challenge_392_intermediate_pancake_sort/
import std.stdio : writeln;
import std.range : take, retro, chain, drop;
import std.algorithm : reverse, maxIndex, isSorted;

void main()
{
}

unittest
{
    import std.algorithm : equal;

    int[] input = [3, 2, 4, 1];
    input.pancakeSort();
    assert(input.isSorted);

    input = [23, 10, 20, 11, 12, 6, 7];
    input.pancakeSort();
    assert(input.isSorted);

    input = [3, 1, 2, 1];
    input.pancakeSort();
    assert(input.isSorted);
}

void pancakeSort(int[] input)
{
    ulong currentIndex = input.length;
    while(currentIndex > 0)
    {
        auto maxIndex = input[0 .. currentIndex].maxIndex;
        flipFrontInPlace(input, maxIndex + 1);
        flipFrontInPlace(input, currentIndex);
        currentIndex--;
    }
}

auto flipFront(R)(R input, int n)
{
    return input.take(n).retro.chain(input.drop(n));
}

unittest
{
    import std.algorithm : equal;

    assert(flipFront([0, 1, 2, 3, 4], 2).equal([1, 0, 2, 3, 4]));
    assert(flipFront([0, 1, 2, 3, 4], 3).equal([2, 1, 0, 3, 4]));
    assert(flipFront([0, 1, 2, 3, 4], 5).equal([4, 3, 2, 1, 0]));
    assert(flipFront([1, 2, 2, 2], 3).equal([2, 2, 1, 2]));
}

void flipFrontInPlace(R)(R input, ulong n)
{
    input[0 .. n].reverse();
}

unittest
{
    import std.algorithm : equal;

    auto input = [0, 1, 2, 3, 4];
    flipFrontInPlace(input, 2);
    assert(input.equal([1, 0, 2, 3, 4]));

    input = [0, 1, 2, 3, 4];
    flipFrontInPlace(input, 3);
    assert(input.equal([2, 1, 0, 3, 4]));

    input = [0, 1, 2, 3, 4];
    flipFrontInPlace(input, 5);
    assert(input.equal([4, 3, 2, 1, 0]));

    input = [1, 2, 2, 2];
    flipFrontInPlace(input, 3);
    assert(input.equal([2, 2, 1, 2]));
}
