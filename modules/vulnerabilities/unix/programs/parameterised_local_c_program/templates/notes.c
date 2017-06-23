#include <pwd.h>
#include <dirent.h>
#include <errno.h>
#include <sys/stat.h>
#include <string.h>
#include "notes_helper.c"
#include "c_code_helper.c"

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

void create_note(){
    DIR *dir = get_notes_dir(notes_directory_path);
    if(!dir) return;

    char filename[20];
    printf("\nEnter note title (no spaces): \n");
    scanf("%s", filename);

    char file_path[50];
    build_file_path(file_path, notes_directory_path, filename);

    printf("Creating new note - %s\n", file_path);

    FILE *file = fopen(file_path, "w+");
    char file_contents[200];

    printf("\nEnter note contents (enter a blank line to finish):\n");

    bool completed = false;
    char finished[1];
    int line_count = 1;
    while(completed == false && line_count < 10){
        char line[200] = "";
        clearKeyboardBuffer();
        scanf("%[^\n]s", line);
        if(strlen(line) == 0){
            printf("Are you finished?[y/n]\n");
            clearKeyboardBuffer();
            scanf(" %c", finished);
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
    DIR *dir = get_notes_dir(notes_directory_path);
    if(!dir) return;

    char filename[20];
    printf("\nEnter note title: \n");
    scanf("%s", filename);

    char file_path[50];
    build_file_path(file_path, notes_directory_path, filename);

    printf("Opening note - %s\n", file_path);
    FILE *file = fopen(file_path, "r");
    char buf[1000];

    if (!file) {
        printf("\nFile does not exist.\n");
        return;
    }

    printf("\nEnter 'q' to return to main menu. Note reads:\n");
    while (fgets(buf, 1000, file) != NULL){
        printf("%s",buf);
    }

    bool completed = false;
    while(completed == false) {
        char exit[1];
        scanf(" %c", exit);

        if(strncmp(exit, "q", 1) == 0){
            completed = true;
        }
    }

    fclose(file);
    closedir(dir);
}

void edit_note(){

}

void rename_note(){

}

void delete_note(){

}

