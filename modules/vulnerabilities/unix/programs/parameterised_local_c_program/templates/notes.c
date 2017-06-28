#include <pwd.h>
#include <dirent.h>
#include <errno.h>
#include <sys/stat.h>
#include <string.h>
#include "notes_helper.c"

char *directory_path;

void set_notes_directory_path(char notes_directory_path[15]){
    char *path = notes_directory_path;
    strcat(path, "/notes");
    directory_path = path;
    return;
}

void list_all_notes(){
    DIR* dir = get_notes_dir(directory_path);

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
    char *message = "Enter note title (no spaces): ";
    char filename[20];
    char file_path[50];
    char file_mode[2] = "w+"; //creates new file for read and write
    DIR *dir;

    dir = get_notes_dir(directory_path);
    if(!dir) return;

    FILE *file = open_file(directory_path, filename, file_path, message, file_mode);

    char file_contents[1000] = "";
    printf("\nEnter note contents (enter a blank line to finish):\n");
    add_note_contents(file_contents);

    fprintf(file, "%s", file_contents);
    fclose(file);
    closedir(dir);
}

void view_note(){
    char *message = "Enter note title to view the note: ";
    char filename[20];
    char file_path[50];
    char file_mode[1] = "r"; //read-only
    DIR *dir;

    dir = get_notes_dir(directory_path);
    if(!dir) return;

    FILE *file = open_file(directory_path, filename, file_path, message, file_mode);

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
    char *message = "Enter note title to edit a note: ";
    char filename[20];
    char file_path[50];
    char file_mode[2] = "a+"; //opens file for reading and appending
    DIR *dir;

    dir = get_notes_dir(directory_path);
    if(!dir) return;

    FILE *file = open_file(directory_path, filename, file_path, message, file_mode);

    char buf[1000];
    if (!file) {
        printf("\nFile does not exist.\n");
        return;
    }

    while (fgets(buf, 1000, file) != NULL){
        printf("%s",buf);
    }

    char file_contents[1000] = "";
    printf("\nEnter contents to add to note (enter a blank line to finish):\n");
    add_note_contents(file_contents);

    fprintf(file, "%s", file_contents);
    fclose(file);
    closedir(dir);
}

void rename_note(){
    DIR *dir = get_notes_dir(directory_path);
    if(!dir) return;

    char current_filename[20];
    char new_filename[20];
    printf("\nEnter note title to rename: \n");
    scanf("%s", current_filename);
    printf("\nEnter new note title: \n");
    scanf("%s", new_filename);

    char current_file_path[50];
    char new_file_path[50];
    build_file_path(current_file_path, directory_path, current_filename);
    build_file_path(new_file_path, directory_path, new_filename);

    printf("Renaming note to: %s\n", new_file_path);

    int ret;
    ret = rename(current_file_path, new_file_path);

    if(ret == 0)
    {
        printf("File renamed successfully.\n");
    }
    else
    {
        printf("Error: unable to rename the file.\n");
        fprintf(stderr, "Error message: %s\n", strerror(errno));
    }

    closedir(dir);
}

void delete_note(){
    DIR *dir = get_notes_dir(directory_path);
    if(!dir) return;

    char filename[20];
    printf("\nEnter note title to delete the note: \n");
    scanf("%s", filename);

    char file_path[50];
    build_file_path(file_path, directory_path, filename);

    printf("Deleting note: %s\n", file_path);

    int ret;
    ret = remove(file_path);

    if(ret == 0)
    {
        printf("File deleted successfully.\n");
    }
    else
    {
        printf("Error: unable to delete the file.\n");
        fprintf(stderr, "Error message: %s\n", strerror(errno));
    }

    closedir(dir);
}

/**
* The code for the methods were adapted from TutorialsPoint's examples found here:
* https://www.tutorialspoint.com/
*/
