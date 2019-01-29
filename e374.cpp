//https://redd.it/akv6z4
#include <iostream>

int additive_persistance(unsigned long input)
{
  unsigned long sum = 0;
  do
  {
    sum += input % 10;
    input /= 10;
  }
  while(input);
  if(sum > 9)
  {
    return 1 + additive_persistance(sum);
  }
  return 1;
}

int main()
{
  std::string line;
  unsigned long input;
  while(std::cin >> input)
  {
    std::cout << additive_persistance(input) << std::endl;
  }
}
