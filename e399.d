//https://www.reddit.com/r/dailyprogrammer/comments/onfehl/20210719_challenge_399_easy_letter_value_sum/
import std.traits : isSomeString;
import std.algorithm : map, sum;
import std.stdio : writeln, writefln, stdin;

unittest
{
    static assert(letterSum("") == 0);
    static assert(letterSum("a") == 1);
    static assert(letterSum("z") == 26);
    static assert(letterSum("cab") == 6);
    static assert(letterSum("excellent") == 100);
    static assert(letterSum("microspectrophotometries") == 317);
}

ulong letterSum(S)(S input) if(isSomeString!S)
{
    return input.map!(letter => letter - 'a' + 1).sum();
}

bool haveCommonLetters(string left, string right)
{
    ulong[char] counter;
    foreach(char c; left)
    {
        counter[c]++;
    }
    foreach(char c; right)
    {
        if(c in counter)
        {
            return true;
        }
    }
    return false;
}

unittest
{
    static assert(haveCommonLetters("foo", "bar") == false);
    static assert(haveCommonLetters("foo", "f") == true);
    static assert(haveCommonLetters("f", "ooof") == true);
    static assert(haveCommonLetters("", "") == false);
}

void main()
{
    string[][ulong] sums;
    foreach(word; stdin.byLine())
    {
        ulong sum = word.letterSum();
        if(sum > 188)
        {
            sums[sum] ~= word.idup;
        }
    }

    foreach(sum, words; sums)
    {
        foreach(i, left; words)
        {
            foreach(j, right; words[i .. $])
            {
                if(!haveCommonLetters(left, right))
                {
                    writeln(left, " and ", right, " : ", sum);
                }
            }
        }
    }
}
