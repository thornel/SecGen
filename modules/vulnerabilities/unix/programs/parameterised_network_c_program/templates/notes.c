#include <pwd.h>
#include <dirent.h>
#include <errno.h>
#include <sys/stat.h>
#include <string.h>
#include "notes_helper.c"

char notes_directory_path[15] = "/usr/notes";

void list_all_notes(){
    DIR* dir = get_notes_dir(notes_directory_path);

    struct dirent *directory_entries;
    int file_count = 0;

    if(dir){
        printf("Retrieving all notes in directory:\n");
        while((directory_entries = readdir(dir)) != NULL){
            if(strcmp(directory_entries->d_name, ".") != 0 && strcmp(directory_entries->d_name, "..") != 0) {
                printf("- %s\n", directory_entries->d_name);
                file_count++;
            }
        }
        closedir(dir);
    }

    printf("\nDisplaying %d entries.\n", file_count);
}

void clearKeyboardBuffer() {
    char ch;
    while ((ch = getchar() != '\n') && (ch != EOF));
}

void create_note(int sock){
    DIR *dir = get_notes_dir(notes_directory_path);
    if(!dir) return;

    char filename[20];
    char *message = "\nEnter note title: \n";
    write(sock, message, strlen(message));
    recv(sock, filename, 20, 0);

    //build file path
    char file_path[50];
    strcpy(file_path, notes_directory_path);
    strcat(file_path, "/");
    strcat(file_path, filename);
    strcat(file_path, ".txt");

    message = strcat("Creating new note: ", file_path);
    write(sock, message, strlen(message));
    write(sock, "\n", 2);

    FILE *file = fopen(file_path, "w+");
    char file_contents[200];

    message = "\nEnter note contents (enter a blank line to finish):\n";
    write(sock, message, strlen(message));

    bool completed = false;
    char finished[1];
    int line_count = 1;
    while(completed == false && line_count < 10){
        char line[50];
        //clearKeyboardBuffer();
        recv(sock, line, 200, 0);
        if(strlen(line) == 0){
            printf("Are you finished?[y/n]\n");
            clearKeyboardBuffer();
            recv(sock, finished, 1, 0);
            if(strncmp(finished, "y", 1) == 0){
                completed = true;
            }
            else{
                append_line_to_note(file_contents, line);
                line_count++;
            }
        }
        else {
            append_line_to_note(file_contents, line);
            line_count++;
        }
    }

    fprintf(file, "%s", file_contents);
    fclose(file);
    closedir(dir);
}

void view_note(){

}

void edit_note(){

}

void rename_note(){

}

void delete_note(){

}
