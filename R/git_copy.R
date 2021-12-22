#' copycat_gitsearch
#' @param author A character vector.
#' @param repository A character vector.
#' @param branch A character vector.
#'
#' @return A character vector.
#' @export
#'


copycat_gitsearch <- function(author, repository, branch = "master") {

  if (exists("git_setup") == TRUE) {
    author <- git_setup[1]
    repository <- git_setup[2]
    branch <- git_setup[3]
    gitlink2 <- paste("/git/trees/", branch, "?recursive=1", sep = "")
    #gitlink2 <- "/git/trees/master?recursive=1"
  } else {
    author <- "edgar-treischl"
    repository <- "illustrations"
    gitlink2 <- "/git/trees/master?recursive=1"
  }

  gitlink1 <- "https://api.github.com/repos/"
  gitsearch_name <- paste(gitlink1, author, "/", sep = "" )



  gitsearch <- paste(gitsearch_name, repository, gitlink2, sep = "" )

  response <- httr::GET(gitsearch)

  jsonRespParsed <- httr::content(response, as="parsed")
  modJson <- jsonRespParsed$tree

  df <- modJson %>%
    dplyr::bind_rows() %>%
    dplyr::select(path)


  git_scripts <- df$path
  #r_pattern <- "\\w\\/"
  #git_scripts <- stringr::str_replace(git_scripts, r_pattern, "")
  query_results <- tidyr::as_tibble(stringr::str_subset(git_scripts,
  "R\\/\\w+\\.R$"))

  query_results %>%
    dplyr::select(git_scripts = value)

}

#' copycat_git
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
    repository <- "illustrations"
    branch <- "master"
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
#' @param file A character vector.
#'
#' @return A character vector.
#' @export
#'
#' @examples
#' x <- "alfa,bravo,charlie,delta"
#' strsplit(x, split = ",")


copycat_gitplot <- function(file) {
  author <- "edgar-treischl"
  repository <- "Illustrations"

  if(exists("git_setup") == TRUE){
    author <- git_setup[1]
    repository <- git_setup[2]
  }

  x <- paste("https://raw.githubusercontent.com/",
             author, "/", repository, "/master/R/",
             file, ".R", sep ="")


  devtools::source_url(x)
  #code <- "plot"
  #rstudioapi::sendToConsole(code, execute = TRUE, echo = TRUE, focus = TRUE)
  #return(plot)

}

utils::globalVariables(c("git_setup", "path", "value"))


