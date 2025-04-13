# silencing the echo is possible via `gitr_echo_cmd=` global option

    Code
      ver <- git("--version")
    Output
      Running git --version 

---

    Code
      ver <- git("--version", echo_cmd = FALSE)

---

    Code
      ver <- git("--version", echo_cmd = FALSE)
    Output
      Running git --version 

---

    Code
      ver <- git("--version", echo_cmd = FALSE)

