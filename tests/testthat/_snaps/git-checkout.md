# `git_checkout()` checks out a file when asked

    Code
      git_checkout(file = "DESCRIPTION")
    Output
      Running git ls-files 
      Running git checkout DESCRIPTION 
      Updated 0 paths from the index

---

    Code
      git_checkout(file = files)
    Output
      Running git ls-files 
      Running git checkout NAMESPACE DESCRIPTION NEWS.md README.Rmd 
      Updated 4 paths from the index

