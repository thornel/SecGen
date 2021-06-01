#!/bin/zsh
SALT=`date +%g`
if [[ ARGC -gt 0 ]] then
  BINNAME=`basename $PWD`
    foreach USER ($@)
      mkdir -p obj/$USER
        HASH=`echo $USER $SALT $BINNAME | sha256sum | awk '{print $1}' | cut -c 1-12 | tr \[a-f\] \[A-F\]`
        AA=`echo "ibase=16;${HASH:1:6}" | bc`
	BB=`echo "ibase=16;${HASH:7:12}" |bc`
        cat program.c.template | sed s/AAAAAA/$AA/ | sed s/BBBBBB/$BB/ >! program.c
        gcc -o obj/$USER/$BINNAME program.c
    end
else
  echo "USAGE: build.zsh <user_email(s)>"
fi
