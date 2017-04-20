#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>
#include <stdio.h>
#include <string.h>

void list_all_notes(){
    DIR * directory;
    struct dirent * directory_entries;
    int file_count = 0;

    directory = opendir("/usr");
    if(directory){
        while((directory_entries = readdir(directory)) != NULL){
            printf("%s\n", directory_entries -> d_name);
            file_count++;
        }
        closedir(directory);
    }

    printf("\nDisplaying %d entries.\n", file_count);
}

void view_note(){

}

void create_note(){
    struct stat st = {0};
    char directory_name = "/usr/notes";

    if (stat(directory_name, &st) == -1) {
        mkdir(directory_name, 0700);
    }

}

void edit_note(){

}

void rename_note(){

}

void delete_note(){

}