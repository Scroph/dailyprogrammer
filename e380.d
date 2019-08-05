import std.stdio : writeln;
import std.file : readText;
import std.string : splitLines;
import std.range : retro;
import std.algorithm : map, equal, canFind, count;
import std.string : join;

string[string] morse_cache;
string[string] reverse_morse_cache;

void main()
{
    immutable words = "enable1.txt".readText.splitLines;
    bonus1(words);
    bonus2(words);
    bonus3(words);
    bonus4(words);
    bonus5(words);
}

string smorse(string clear)
{
    auto cache_hit = clear in morse_cache;
    if(cache_hit != null)
    {
        return *cache_hit;
    }
    immutable dictionary = [".-", "-...", "-.-.", "-..", ".", "..-.", "--.", "....", "..", ".---", "-.-", ".-..", "--", "-.", "---", ".--.", "--.-", ".-.", "...", "-", "..-", "...-", ".--", "-..-", "-.--", "--.."];

    string morse = clear.map!(letter => dictionary[letter - 'a']).join("");
    morse_cache[clear] = morse;
    reverse_morse_cache[morse] = clear;
    return morse;
}

unittest
{
    assert(smorse("sos") == "...---...");
    assert(smorse("daily") == "-...-...-..-.--");
    assert(smorse("programmer") == ".--..-.-----..-..-----..-.");
    assert(smorse("bits") == "-.....-...");
    assert(smorse("three") == "-.....-...");
}

void bonus1(immutable string[] words)
{
    int[string] sequence_count;
    foreach(string word; words)
    {
        immutable morse = word.smorse;
        if(++sequence_count[morse] == 13)
        {
            morse.writeln;
            break;
        }
    }
}

void bonus2(immutable string[] words)
{
    foreach(string word; words)
    {
        if(word.smorse.canFind("---------------"))
        {
            word.writeln;
            break;
        }
    }
}

void bonus3(immutable string[] words)
{
    foreach(string word; words)
    {
        if(word == "counterdemonstrations")
        {
            continue;
        }
        immutable morse = word.smorse;
        if(word.length == 21 && morse.count("-") == morse.count("."))
        {
            word.writeln;
            break;
        }
    }
}

void bonus4(immutable string[] words)
{
    foreach(string word; words)
    {
        if(word.length == 13 && word.smorse.is_palindrome)
        {
            word.writeln;
            break;
        }
    }
}

bool is_palindrome(string s)
{
    return s.length == 1 ? true : s.equal(s.retro);
}

unittest
{
    static assert(".--..-.----.-.-.----.-..--.".is_palindrome);
    static assert("a".is_palindrome);
    static assert("aba".is_palindrome);
    static assert("aabbaa".is_palindrome);
    static assert(!"aabaaa".is_palindrome);
}

void bonus5(immutable string[] words)
{

}
