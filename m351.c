//https://redd.it/7xkhar
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void trim(char *str)
{
	str[strlen(str) - 2] = '\0';
}

void swap(char *a, char *b)
{
	char tmp = *a;
	*a = *b;
	*b = tmp;
}

void spin(char *sequence, const char *parameters)
{
	int s = atoi(parameters);
	int len = strlen(sequence);
	char spinned[1024];
	//spinned[0] = '\0';
	strcpy(spinned, "");
	int j = 0;
	for(int i = len - s; sequence[i]; i++)
		spinned[j++] = sequence[i];
	for(int i = 0; i < len - s; i++)
		spinned[j++] = sequence[i];
	spinned[j] = '\0';
	strcpy(sequence, spinned);
}

void exchange(char *sequence, const char *parameters)
{
	int a, b;
	sscanf(parameters, "%d/%d", &a, &b);
	swap(&sequence[a], &sequence[b]);
}

void partner(const char* original, char *sequence, const char *parameters)
{
	int idx_a, idx_b;
	sscanf(parameters, "%d/%d", &idx_a, &idx_b);
	char a = original[idx_a], b = original[idx_b];
	for(int i = 0; sequence[i]; i++)
	{
		if(sequence[i] == a)
			sequence[i] = b;
		else if(sequence[i] == b)
			sequence[i] = a;
	}
}

int main(void)
{
	int cases;
	scanf("%d ", &cases);
	while(cases--)
	{
		char sequence[1024], moves[500000];
		fgets(sequence, 1024, stdin);
		fgets(moves, 500000, stdin);

		trim(sequence);
		trim(moves);
		char original[1024];
		strcpy(original, sequence);
		
		char *part = moves;
		part = strtok(part, ",");
		while(part != NULL)
		{
			switch(part[0])
			{
				case 's': spin(sequence, part + 1); break;
				case 'x': exchange(sequence, part + 1); break;
				case 'p': partner(original, sequence, part + 1); break;
			}
			part = strtok(NULL, ",");
		}
		printf("%d : '%s'\n", strlen(sequence), sequence);
	}
}
