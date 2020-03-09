#!/bin/bash

main_function() {
curl -sS -m 30 --url http://asciidoctor:8080/ -H "X-Session-Token: $SESSION_TOKEN" -H "X-Gitea-Raw: $GITEA_PREFIX_RAW" --data-binary @-
}

main_function $@ 2>&1

exit 0
