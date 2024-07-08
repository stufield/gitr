# silencing the git echo is possible via the `gitr.echo_cmd` global option

    Code
      git("--version")
    Output
      Running git --version 

---

    Code
      git("--version")

---

    Code
      git("--version", echo_cmd = FALSE)
    Output
      Running git --version 

