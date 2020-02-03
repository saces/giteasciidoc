#!/bin/bash

main_function() {
#split up GITEA_PREFIX_RAW into array
readarray -s1 -t -d/ a < <(echo -n $GITEA_PREFIX_RAW)

alen=${#a[@]}

p=""

if [ ${alen} -gt 5 ]; then
  p=${a[5]}
  for (( i=6; i<${alen}; i++ ));
  do
    p="${p}/${a[i]}"
  done
  p="${p}/"
fi

git -C /git-data/${a[0]}/${a[1]}.git --no-pager show ${a[4]}:${p}${1}
#curl -sS "http://gitea:3000$GITEA_PREFIX_RAW/${1}"
}

main_function $@ 2>&1
