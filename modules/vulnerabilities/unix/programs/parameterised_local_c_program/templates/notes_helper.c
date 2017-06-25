#include <pwd.h>
#include <dirent.h>
#include <errno.h>
#include <sys/stat.h>
#include <string.h>
#include "c_code_helper.c"

DIR* get_notes_dir(char directory_path[15]){
    DIR* dir = opendir(directory_path);

    if (dir) {
        printf("Notes directory already exists.\n");
    }
    else if (ENOENT == errno){
        printf("Creating notes directory: %s.\n", directory_path);
        mode_t process_mask = umask(0);
        if(mkdir(directory_path, S_IRWXU | S_IRWXG | S_IRWXO) == -1){
            printf("Failed to create directory: %s.\n", directory_path);
            perror("mkdir");
        }
        else {
            printf("Notes directory created.\n");
            dir = opendir(directory_path);
            if (!dir) {
                printf("Failed opening notes directory.\n");
            }
        }
    }
    else{
        printf("Failed opening notes directory.\n");
    }
    return dir;
}

void build_file_path(char file_path[50], char directory_path[15], char filename[20]){
    strcpy(file_path, directory_path);
    strcat(file_path, "/");
    strcat(file_path, filename);
    strcat(file_path, ".txt");
}

FILE* open_file(char directory_path[15], char filename[20], char file_path[50], char *message,
               char file_mode[2]){
    FILE *file;

    printf("\n%s\n", message);
    scanf("%s", filename);

    build_file_path(file_path, directory_path, filename);

    printf("Opening note - %s\n", file_path);
    file = fopen(file_path, file_mode);
    return file;
}

void append_line_to_note(char file_contents[200], char line[200]){
    if(strlen(file_contents) > 0){
        strcat(file_contents, "\n");
    }
    strcat(file_contents, line);
}

void add_note_contents(char file_contents[1000]){
    bool completed = false;
    char finished[1];
    int line_count = 1;
    while(completed == false){
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
        }
        append_line_to_note(file_contents, line);
        line_count++;
    }
}