#include <pwd.h>
#include <dirent.h>
#include <errno.h>
#include <sys/stat.h>
#include <string.h>

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

void append_line_to_note(char file_contents[200], char line[200]){
    if(strlen(file_contents) > 0){
        strcat(file_contents, "\n");
    }
    strcat(file_contents, line);
}