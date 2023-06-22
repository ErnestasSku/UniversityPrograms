#include <stdio.h>
#include <stdbool.h>
#include <string.h>

bool is_unique(char *str) {
    int char_count[256] = {0}; // Initialize a counter array for each character in ASCII

    for (int i = 0; i < strlen(str); i++) {
        printf("%d ", (int)str[i]);
        int char_index = (int)str[i]; // Convert character to ASCII index
        char_count[char_index]++; // Increment the counter for the current character

        if (char_count[char_index] > 1) {
            return false; // The string contains repeated characters
        }
    }

    return true; // The string is made up of unique characters
}

int main() {
    char str[100];

    printf("Enter a string: ");
    fgets(str, sizeof(str), stdin); // Read input string from user

    if (is_unique(str)) {
        printf("The string is made up of unique characters.\n");
    } else {
        printf("The string contains repeated characters.\n");
    }

    return 0;
}
