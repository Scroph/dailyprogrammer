//https://www.reddit.com/r/dailyprogrammer/comments/o4uyzl/20210621_challenge_395_easy_nonogram_row/
import std.stdio;

void main()
{
}

unittest
{
    static assert(nonogramrow([]) == []);
    static assert(nonogramrow([0, 0, 0, 0, 0]) == []);
    static assert(nonogramrow([1, 1, 1, 1, 1]) == [5]);
    static assert(nonogramrow([0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1]) == [5, 4]);
    static assert(nonogramrow([1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0]) == [2, 1, 3]);
    static assert(nonogramrow([0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1]) == [2, 1, 3]);
    static assert(nonogramrow([1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1]) == [1, 1, 1, 1, 1, 1, 1, 1]);
}

int[] nonogramrow(int[] input)
{
    int[] result = [];
    int counter = 0;
    foreach(i; input)
    {
        if(i == 1)
        {
            counter++;
        }
        else
        {
            if(counter != 0)
            {
                result ~= counter;
            }
            counter = 0;
        }
    }
    if(counter != 0)
    {
        result ~= counter;
    }
    return result;
}
