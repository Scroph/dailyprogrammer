#include <iostream>
#include <sstream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <set>
#include <array>
#include <map>
#include <utility>
#include <cctype>

std::string toLower(const std::string& input);
std::string stripSpaces(const std::string& input);
std::string stripPunctuation(const std::string& input);
std::vector<std::string> bySentence(const std::string& text);
std::map<std::string, int> countWords(const std::string& text);
size_t countOccurrences(const std::string& haystack, const std::string& needle);

const std::set<std::string> ignore {"a", "about", "above", "after", "again", "against", "all", "am", "an", "and", "any", "are", "aren't", "as", "at", "be", "because", "been", "before", "being", "below", "between", "both", "but", "by", "can't", "cannot", "could", "couldn't", "did", "didn't", "do", "does", "doesn't", "doing", "don't", "down", "during", "each", "few", "for", "from", "further", "had", "hadn't", "has", "hasn't", "have", "haven't", "having", "he", "he'd", "he'll", "he's", "her", "here", "here's", "hers", "herself", "him", "himself", "his", "how", "how's", "i", "i'd", "i'll", "i'm", "i've", "if", "in", "into", "is", "isn't", "it", "it's", "its", "itself", "let's", "me", "more", "most", "mustn't", "my", "myself", "no", "nor", "not", "of", "off", "on", "once", "only", "or", "other", "ought", "our", "ours", "ourselves", "out", "over", "own", "same", "shan't", "she", "she'd", "she'll", "she's", "should", "shouldn't", "so", "some", "such", "than", "that", "that's", "the", "their", "theirs", "them", "themselves", "then", "there", "there's", "these", "they", "they'd", "they'll", "they're", "they've", "this", "those", "through", "to", "too", "under", "until", "up", "very", "was", "wasn't", "we", "we'd", "we'll", "we're", "we've", "were", "weren't", "what", "what's", "when", "when's", "where", "where's", "which", "while", "who", "who's", "whom", "why", "why's", "with", "won't", "would", "wouldn't", "you", "you'd", "you'll", "you're", "you've", "your", "yours", "yourself", "yourselves"};

int main()
{
	std::string text;
	getline(std::cin, text);
	auto sentences = bySentence(text);
	for(auto& s: sentences)
		std::cout << s << std::endl << std::endl;
	return 0;
	auto wordCount = countWords(text);

	std::vector<std::pair<std::string, int>> mostCommon;
	mostCommon.reserve(wordCount.size());
	for(const auto& kv: wordCount)
		mostCommon.push_back(kv);
	std::sort(mostCommon.begin(), mostCommon.end(), [](std::pair<std::string, int> a, std::pair<std::string, int> b) {
		return a.second > b.second;
	});

	std::sort(sentences.begin(), sentences.end(), [mostCommon](const std::string& a, const std::string& b) {
		return countOccurrences(a, mostCommon[0].first) > countOccurrences(b, mostCommon[0].first);
	});

	std::cout << sentences[0] << std::endl << std::endl;
	std::cout << sentences[1] << std::endl << std::endl;
}

size_t countOccurrences(const std::string& haystack, const std::string& needle)
{
	std::stringstream ss(haystack);
	std::string word;
	size_t count = 0;
	while(ss >> word)
		if(toLower(stripPunctuation(word)) == needle)
			count++;
	return count;
}

std::map<std::string, int> countWords(const std::string& text)
{
	std::map<std::string, int> wordCount;
	std::stringstream ss(text);
	std::string word;
	while(ss >> word)
	{
		word = stripPunctuation(toLower(word));
		if(ignore.find(word) == ignore.end())
			wordCount[word]++;
	}
	return wordCount;
}

std::string toLower(const std::string& input)
{
	std::string result = input;
	std::transform(result.begin(), result.end(), result.begin(), ::tolower);
	return result;
}

std::vector<std::string> bySentence(const std::string& text)
{
	std::vector<std::string> sentences;
	size_t start = 0;
	size_t stop;
	while(true)
	{
		std::array<size_t, 6> candidates {
			text.find(". ", start), text.find("? ", start), text.find("! ", start),
			text.find('.', start), text.find('?', start), text.find('!', start)
		};
		stop = *(std::min_element(candidates.begin(), candidates.end()));
		std::cout << stop << std::endl;
		if(stop == std::string::npos)
			break;
		sentences.push_back(stripSpaces(text.substr(start, stop - start + 1)));
		start = stop + 1;
	}

	if(sentences.empty())
		sentences.push_back(stripSpaces(text));
	return sentences;
}

std::string stripSpaces(const std::string& input)
{
	size_t start = 0, stop = input.length() - 1;
	while(input[stop] == ' ')
		stop--;
	while(input[start] == ' ')
		start++;
	return input.substr(start, stop - start + 1);
}

std::string stripPunctuation(const std::string& input)
{
	if(all_of(input.begin(), input.end(), ::isalnum))
		return input;
	size_t start = 0, stop = input.length() - 1;
	while(!isalnum(input[stop]))
		stop--;
	while(!isalnum(input[start]))
		start++;
	return input.substr(start, stop - start + 1);
}
