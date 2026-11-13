#include <unistd.h>
int main() {
    setuid(geteuid());
    execle("/usr/bin/ruby","ruby","/opt/labflags/labflags.rb",(char*) NULL,(char*) NULL);
}
