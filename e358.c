#include <stdio.h>

static int mapping[] = {0x7e, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7f, 0x7b};

int translate(int seven_segment)
{
	for(int i = 0; i < 10; i++)
		if(mapping[i] == seven_segment)
			return i;
	return -1;
}

int main(void)
{
	int numbers[9] = {0};
	char lines[3][30];
	for(int i = 0; i < 3; i++)
		fgets(lines[i], 30, stdin);

	for(int col = 0; col < 27; col += 3)
	{
		int number = 0;
		number |= (lines[0][col + 1] == '_') << 6;
		number |= (lines[1][col + 2] == '|') << 5;
		number |= (lines[2][col + 2] == '|') << 4;
		number |= (lines[2][col + 1] == '_') << 3;
		number |= (lines[2][col + 0] == '|') << 2;
		number |= (lines[1][col + 0] == '|') << 1;
		number |= (lines[1][col + 1] == '_') << 0;
		printf("%d", translate(number));
	}
	printf("\n");
	return 0;
}
