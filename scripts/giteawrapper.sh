#!/bin/bash

main_function() {
curl -sS --url http://asciidoctor:8080/ -H "X-Gitea-Raw: $GITEA_PREFIX_RAW" -H "X-Gitea-Src: $GITEA_PREFIX_SRC" --data-binary @-
}

main_function $@ 2>&1

exit 0