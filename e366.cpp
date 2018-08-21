//https://redd.it/98ufvz
#include <cassert>
#include <iostream>
#include <fstream>
#include <vector>
#include <map>
#include <set>

using namespace std;

bool funnel(const string& a, const string& b)
{
    for(size_t i = 0; i < a.length(); i++)
        if(a.substr(0, i) + a.substr(i + 1) == b)
            return true;
    return false;
}

int main()
{
    assert(funnel("leave", "eave") == true);
    assert(funnel("reset", "rest") == true);
    assert(funnel("dragoon", "dragon") == true);
    assert(funnel("eave", "leave") == false);
    assert(funnel("sleet", "lets") == false);
    assert(funnel("skiff", "ski") == false);

    set<string> dict;
    ifstream fh("enable1.txt");
    string line;
    while(getline(fh, line))
        dict.insert(line);

    map<string, set<string>> bonus;
    for(const auto& word: dict)
    {
        for(size_t i = 0; i < word.length(); i++)
        {
            string subword = word.substr(0, i) + word.substr(i + 1);
            if(dict.find(subword) != dict.end())
                bonus[word].insert(subword);
        }
        if(bonus[word].size() == 5)
        {
            cout << word << ": ";
            for(const auto& w: bonus[word])
                cout << w << ' ';
            cout << endl;
        }
    }
}
