package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
)

func handler(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != "/" {
		http.Error(w, "404 not found.", http.StatusNotFound)
		return
	}

	switch r.Method {
	case "POST":
		name := r.Header.Get("X-Gitea-Raw")
		sid := r.Header.Get("X-Session-Token")
		cmd := exec.Command("asciidoctor", "-r", "/asciidoctor-ext/gitea-include.rb", "-s", "--out-file=-", "-")
		cmd.Stdin = r.Body
		cmd.Env = os.Environ()
		cmd.Env = append(cmd.Env, fmt.Sprintf("GITEA_PREFIX_RAW=%s", name))
		cmd.Env = append(cmd.Env, fmt.Sprintf("SESSION_TOKEN=%s", sid))

		out, err := cmd.CombinedOutput()
		if err != nil {
			fmt.Fprintf(w, "Oops: %s\n", err.Error())
		}
		fmt.Fprintf(w, "%s\n", (string)(out))
	default:
		http.Error(w, "Method not supported", http.StatusMethodNotAllowed)
	}
}

func main() {
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
