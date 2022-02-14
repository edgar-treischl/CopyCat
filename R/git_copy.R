#' copycat_gitsearch
#'
#' @description The function `copycat_gitsearch` returns the list of R files in a
#' Github repository. It expects `author`, `repository`, and `branch` name to
#' print the list of R files on Github. If all is left out, it returns the
#' content of example repository.
#'
#' @param author A character vector.
#' @param repository A character vector.
#' @param branch A character vector.
#'
#' @return A character vector.
#' @export
#'


copycat_gitsearch <- function(author, repository, branch = "main") {

  if (exists("git_setup") == TRUE) {
    author <- getElement(git_setup, "author")
    repository <- getElement(git_setup, "repository")
    branch <- getElement(git_setup, "branch")
    gitlink2 <- paste("/git/trees/", branch, "?recursive=1", sep = "")
    #gitlink2 <- "/git/trees/main?recursive=1"
  } else {
    author <- "edgar-treischl"
    repository <- "Graphs"
    gitlink2 <- "/git/trees/main?recursive=1"
  }

  gitlink1 <- "https://api.github.com/repos/"
  gitsearch_name <- paste(gitlink1, author, "/", sep = "" )

  gitsearch <- paste(gitsearch_name, repository, gitlink2, sep = "" )

  response <- httr::GET(gitsearch)

  jsonRespParsed <- httr::content(response, as="parsed")
  modJson <- jsonRespParsed$tree

  df <- dplyr::bind_rows(modJson)

  git_scripts <- df$path
  query_results <- tidyr::as_tibble(stringr::str_subset(git_scripts,
                                                        "R\\/\\w+\\.R$"))
  result <- dplyr::select(query_results, git_scripts = value)
  result

}

#' copycat_git
#'
#' @description Copy a file of a github repository. It expects that
#' `git_setup` is set before running, a data frame with column for the
#' `author`, the `repository`, and the `branch` name; `copycat_git` copies
#' the code to your clipboard.
#'
#' @param file A character vector.
#'
#' @return A character vector.
#' @export
#'

copycat_git <- function(file) {

  if (exists("git_setup") == TRUE) {
    author <- git_setup[1]
    repository <- git_setup[2]
    branch <- git_setup[3]
  } else {
    author <- "edgar-treischl"
    repository <- "Graphs"
    branch <- "main"
  }
  gitaddress1 <- "https://raw.githubusercontent.com/"

  x <- paste(gitaddress1, "/",
             author, "/",
             repository, "/",
             branch, "/",
             "R/",
             file , ".R", sep ="")
  #source_url(x)
  response <- httr::GET(x)
  parsed <- httr::content(response, as="parsed")
  not_found <- parsed == "404: Not Found"
  cat_emoji <- "\U0001F408"
  shit_emoji <- "\U0001F4A9"

  if (not_found == TRUE) {
    print(paste(shit_emoji, "404: File Not Found"))
  } else {
    print(paste(cat_emoji, "Mission accomplished!"))
    clipr::write_clip(parsed)
  }
}


#' copycat_gitplot
#'
#' @description Copy and run a file of a github repository. It expects that
#' `git_setup` is set before running; a data frame with a column for the
#' `author`, the `repository`, and the `branch` name; `copycat_gitplot` copies
#' the code and sends it your console.
#'
#' @param file A character vector.
#'
#' @return A character vector.
#' @export
#'


copycat_gitplot <- function(file) {
  author <- "edgar-treischl"
  repository <- "Graphs"
  branch <- "main"

  if(exists("git_setup") == TRUE){
    author <- git_setup[1]
    repository <- git_setup[2]
    branch <- git_setup[3]
  }

  x <- paste("https://raw.githubusercontent.com/",
             author, "/", repository, "/", branch, "/R/",
             file, ".R", sep ="")


  #devtools::source_url(x)
  response <- httr::GET(x)
  response <- as.character(response)

  rstudioapi::sendToConsole(response, execute = TRUE,
                            echo = TRUE, focus = TRUE)


}


#' copycat_gitcode
#'
#' @description Inspect the code of a file from a github repository. It expects that
#' `git_setup` is set before running; a data frame with a column for the
#' `author`, the `repository`, and the `branch` name; `copycat_gitcode` returns
#' the code as character.
#'
#' @param file A character vector.
#'
#' @return A character vector.
#' @export
#'

copycat_gitcode <- function(file) {
  author <- "edgar-treischl"
  repository <- "Graphs"
  branch <- "main"

  if(exists("git_setup") == TRUE){
    author <- git_setup[1]
    repository <- git_setup[2]
    branch <- git_setup[3]
  }

  x <- paste("https://raw.githubusercontent.com/",
             author, "/", repository, "/", branch, "/R/",
             file, ".R", sep ="")


  #devtools::source_url(x)
  response <- httr::GET(x)
  response <- as.character(response)
  response

}




utils::globalVariables(c("git_setup", "path", "value"))


