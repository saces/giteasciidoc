#!/bin/bash

main_function() {

case "${1}" in
  //* ) # absolute on server
        echo "absolute on server"
        #curl -sS --url "http://gitea:3000${1:1}" -b "i_like_gitea=$SESSION_TOKEN"
        ;;
  /*  ) # absolute on repository
        echo "absolute on repository"
        ;;
  *   ) # default, absolute from current dir
        curl -sS --url "http://gitea:3000$GITEA_PREFIX_RAW/${1}" -b "i_like_gitea=$SESSION_TOKEN"
        ;;
esac

}

main_function $@ 2>&1
