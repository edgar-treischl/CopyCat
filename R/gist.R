#' Explore GitHub Gist files
#'
#' @description The function `copycat_gistfiles()` returns a list with GitHub Gists.
#' @return Data frame with file names.
#' @export
#'

copycat_gistfiles <- function() {
  key <- try(keyring::key_get(service = "github_api"), silent = TRUE)
  test <- exists("key")

  if (test == FALSE) {
    cli::cli_abort("Create a Github Token and store it as a key named github_api with keyring::key_set() function.")
  }

  authoriz <- paste0("Bearer ", keyring::key_get("github_api"))


  req <- httr2::request("https://api.github.com/gists") |>
    httr2::req_headers("Accept" = "application/vnd.github+json",
                       "Authorization" = authoriz,
                       "X-GitHub-Api-Version" = "2022-11-28")


  resp <- httr2::req_perform(req)



  resp_json <- resp |> httr2::resp_body_json()

  answer <- c()

  for (i in 1:length(resp_json)) {

    file <- resp_json[[i]]$files
    filename <- file[[1]][1]
    filename <- as.character(filename)
    answer <- append(answer, filename)
  }

  df <- as.data.frame(answer) |> dplyr::rename("file" = answer)
  return(df)

}


#' Copy Github Gist files
#'
#' @description The function `copycat_gist()` copies GitHub Gists.
#' @param filename The file name from one of your GitHub account (see copycat_gistfiles)
#' @return Message if successful.
#' @export
#'

copycat_gist <- function(filename) {

  key <- try(keyring::key_get(service = "github_api"), silent = TRUE)
  test <- exists("key")

  if (test == FALSE) {
    cli::cli_abort("Create a Github Token and store it as a key named github_api with keyring::key_set() function.")
  }

  authoriz <- paste0("Bearer ", keyring::key_get("github_api"))


  req <- httr2::request("https://api.github.com/gists") |>
    httr2::req_headers("Accept" = "application/vnd.github+json",
                       "Authorization" = authoriz,
                       "X-GitHub-Api-Version" = "2022-11-28")


  resp <- httr2::req_perform(req)



  resp_json <- resp |> httr2::resp_body_json()

  x <- copycat_gistfiles()
  x$n <- 1:length(x$file)

  filename <- paste0(filename, ".R")

  scrapednr <- x |>
    dplyr::filter(file == filename) |>
    dplyr::pull(n)

  if (length(scrapednr) == 0) {
    cli::cli_abort("File not available.")
  }

  files_json <- resp_json[[scrapednr]]$files
  gist_url <-files_json[[1]][[4]]

  #gist_url <- raw_link(n = scrapednr)

  response <- httr::GET(gist_url)

  txt <- httr::content(response, as = "text")
  clipr::write_clip(txt)
  cli::cli_alert_success("Copied {filename} from your GitHub account.")

}

utils::globalVariables(c("n"))


