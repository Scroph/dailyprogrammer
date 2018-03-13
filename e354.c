//https://redd.it/83uvey
#include <stdio.h>
#include <limits.h>

int main(void)
{
	unsigned long long N;
	while(scanf("%llu ", &N) == 1)
	{
		unsigned long long smallest = ULLONG_MAX;
		for(int i = 1; i < N / 2; i++)
		{
			if(N % i == 0ULL)
			{
				if(smallest > i + N / i)
					smallest = i + N / i;
				else
					break;
			}
		}
		printf("%llu => %llu\n", N, smallest);
	}
}
