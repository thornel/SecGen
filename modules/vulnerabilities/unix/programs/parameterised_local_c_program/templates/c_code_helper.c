void clearKeyboardBuffer() {
    char ch;
    while ((ch = getchar() != '\n') && (ch != EOF));
}