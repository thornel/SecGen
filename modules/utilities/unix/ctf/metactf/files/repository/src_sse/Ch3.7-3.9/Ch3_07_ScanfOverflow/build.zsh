#!/bin/zsh
SALT=`date +%N`
if [[ ARGC -gt 0 ]] then
  BINNAME=`basename $PWD`
  foreach USER ($@)
    mkdir -p obj/$USER
    AA=`echo $USER $SALT $BINNAME | sha512sum | base64 | head -1 | cut -c 1-8`
    cat program.c.template | sed s/AAAAAA/$AA/ >! program.c
    gcc -o obj/$USER/$BINNAME -no-pie -fno-pie -fno-stack-protector -z execstack -z norelro program.c
  end
else
  echo "USAGE: build.zsh <user_email(s)>"
fi
