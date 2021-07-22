//https://www.reddit.com/r/dailyprogrammer/comments/oe9qnb/20210705_challenge_397_easy_roman_numeral/
import std.algorithm : map, sum;
import std.string : translate;

unittest
{
    alias numCompare = numCompareLexically;
    static assert(numCompare("I", "I") == false);
    static assert(numCompare("I", "II") == true);
    static assert(numCompare("II", "I") == false);
    static assert(numCompare("V", "IIII") == false);
    static assert(numCompare("MDCLXV", "MDCLXVI") == true);
    static assert(numCompare("MM", "MDCCCCLXXXXVIIII") == false);
}

long toLong(string roman)
{
    long[dchar] mapping = [
        'M': 1000,
        'D': 500,
        'C': 100,
        'L': 50,
        'X': 10,
        'V': 5,
        'I': 1,
    ];

    return roman.map!(c => mapping[c]).sum;
}

bool numCompareNumerically(string a, string b)
{
    return a.toLong() < b.toLong();
}

bool numCompareLexically(string a, string b)
{
    dchar[dchar] lexicalMapping = [
        'M': 'Z',
        'D': 'Y',
        'C': 'X',
        'L': 'W',
        'X': 'V',
        'V': 'U',
        'I': 'T',
    ];
    return a.translate(lexicalMapping) < b.translate(lexicalMapping);
}

void main() {}
