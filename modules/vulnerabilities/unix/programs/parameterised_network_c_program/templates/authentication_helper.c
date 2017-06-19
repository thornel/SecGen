#include <string.h>

bool login(int sock) {
    bool authenticated = false;
    char *message;
    char password[2000];
    int length = 15;

    message = "\nPlease enter the password : \n";
    write(sock, message, strlen(message));

    while (authenticated == false && recv(sock, password, 2000, 0) > 0) {

        if (strncmp(password, "secureAdminPwd", 14) == 0) {
            authenticated = true;
            message = "\nCorrect Password \n";
            write(sock, message, strlen(message));
        } else if (strncmp(password, "exit", 4) == 0) {
            break;
        } else {
            message = "\nWrong Password. Try again or type 'exit' to exit connection.\n";
            write(sock, message, strlen(message));
        }
    }

	return authenticated;
}