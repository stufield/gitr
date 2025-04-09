# silencing the git echo is possible via the `gitr_echo_cmd` global option

    Code
      ver <- git("--version", echo_cmd = FALSE)$stdout
    Output
      Running git --version 

