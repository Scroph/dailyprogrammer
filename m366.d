//https://redd.it/99d24u
import std.stdio;
import std.string;
import std.array;
import std.algorithm;
import std.range;

void main()
{
    auto dict = "enable1.txt".File.byLine.map!strip.map!idup.array.sort;
    funnel2("gnash", dict).writeln;
    funnel2("princesses", dict).writeln;
    funnel2("turntables", dict).writeln;
    funnel2("implosive", dict).writeln;
    funnel2("programmer", dict).writeln;

    dict.bonus.writeln;
}

int funnel2(string word, SortedRange!(string[]) dict)
{
    string[] largest;
    word.longest_funnel(dict, [word], largest);
    //largest.writeln;
    return largest.length;
}

string bonus(SortedRange!(string[]) dict)
{
    foreach(word; dict)
        if(word.length > 10)
            if(word.funnel2(dict) >= 10)
                return word;
    return "";
}

void longest_funnel(string word, SortedRange!(string[]) dict, string[] so_far, ref string[] largest)
{
    foreach(i; 0 .. word.length)
    {
        auto sub = word[0 .. i] ~ word[i + 1 .. $];
        if(dict.contains(sub))
            sub.longest_funnel(dict, so_far ~ sub, largest);
        if(largest.length < so_far.length)
            largest = so_far.dup;
    }
}
