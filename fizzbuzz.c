#include <stdio.h>

int main()
{
    int count = 1;
    int didPrint = 0;
    while (count <= 100)
    {
        didPrint = 0;
        if (count % 3 == 0)
        {
            didPrint = 1;
            printf("Fizz");
        }

        if (count % 5 == 0)
        {
            didPrint = 1;
            printf("Buzz");
        }

        if (!didPrint)
        {
            printf("%i", count);
        }

        printf("\n");
        count++;
    }

    return 0;
}