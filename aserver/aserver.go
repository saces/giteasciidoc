package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
	"time"
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

		// Create a new context and add a timeout to it
		ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
		defer cancel() // The cancel should be deferred so resources are cleaned up

		cmd := exec.CommandContext(ctx, "asciidoctor", "-r", "/asciidoctor-ext/gitea-include.rb", "-s", "--out-file=-", "-")
		cmd.Stdin = r.Body
		cmd.Env = os.Environ()
		cmd.Env = append(cmd.Env, fmt.Sprintf("GITEA_PREFIX_RAW=%s", name))
		cmd.Env = append(cmd.Env, fmt.Sprintf("SESSION_TOKEN=%s", sid))

		out, err := cmd.CombinedOutput()
		if ctx.Err() == context.DeadlineExceeded {
			fmt.Fprintf(w, "Command took to long, timed out.")
			return
		}
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
