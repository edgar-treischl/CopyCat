#' copycat_code
#'
#' @description `copycat_code()` uses a text string to search
#' for a code of a function. The function just returns that code.
#' It expects that the data frame has three columns. A column
#' with the package name (package), a function (fun), and one with
#' the code (code) to copy. If data = NULL, the package search in the
#' the internal data set `CopyCatCode`.
#'
#' @param x A search string for the function
#' @param data A data frame
#' @importFrom magrittr %>%
#'
#' @return A text string that shows the code
#' @export

copycat_code <- function(x, data = CopyCatCode) {
  x <- gsub(" ", "", x, fixed = TRUE)

  code <- data %>%
    dplyr::filter(fct %in% x) %>%
    dplyr::pull(code)

  searchstring <- x
  result <- agrep(searchstring, CopyCatCode$fct)
  shit_emoji <- "\U0001F4A9"
  cat_emoji <- "\U0001F408"

  if (length(code) == 1L) {
    print(paste(cat_emoji, "Your code:", code))
  } else if (length(code) == 0L & length(result) == 0L ) {
    paste(shit_emoji, "I have no idea what you are looking for!")
  } else {
    print(paste("Did you mean", CopyCatCode$fct[result], "from the", CopyCatCode$package[result], "package?"))

  }

}

#' copycat_package
#'
#' @description Use `copycat_package()` expects a text string to search for
#' corresponding package name. It expects that the data frame has three columns.
#' A column with the package name (package), a function (fun), and one with
#' the code (code) to copy. If data = NULL, the package search in the
#' the internal data set `CopyCatCode`.
#'
#' @param x A search string for the code snippet
#' @param data A data frame
#' @importFrom magrittr %>%
#'
#' @return A string with the package name and the function sends
#' the code to load the library to the console.
#' @export
#'

copycat_package <- function(x, data = CopyCatCode) {
  x <- gsub(" ", "", x, fixed = TRUE)

  package <- data %>%
    dplyr::filter(fct %in% x) %>%
    dplyr::pull(package)

  searchstring <- x
  result <- agrep(searchstring, CopyCatCode$fct)
  shit_emoji <- "\U0001F4A9"
  cat_emoji <- "\U0001F408"
  print_lib <- paste("library(",package,")", sep = "")

  if (length(package) == 1L) {
    print(paste(cat_emoji, "Mission accomplished, loaded and copied library:", package))
    rstudioapi::sendToConsole(print_lib, execute = TRUE, echo = FALSE, focus = TRUE)
    clipr::write_clip(print_lib)
  } else if (length(package) == 0L & length(result) == 0L ) {
    paste(shit_emoji, "Sooorry, I have no idea what you are looking for!")
  } else {
    print(paste("Did you mean", CopyCatCode$fct[result], "from the", CopyCatCode$package[result],
                "package?"))

  }

}



#' copycat
#'
#' @param x A search string
#' @param data Data
#' @param run TRUE or FALSE
#' @importFrom magrittr %>%
#'
#' @return A string
#' @export
#'

copycat <- function(x, data = CopyCatCode, run = FALSE) {
  x <- gsub(" ", "", x, fixed = TRUE)

  code <- data %>%
    dplyr::filter(fct %in% x) %>%
    dplyr::pull(code)
  searchstring <- x
  result <- agrep(searchstring, CopyCatCode$fct)

  shit_emoji <- "\U0001F4A9"
  cat_emoji <- "\U0001F431"

  if (length(code) == 1L) {
    if(run == TRUE){
      rstudioapi::sendToConsole(code, execute = run, echo = run, focus = run)
      print(paste(cat_emoji, "copied that!"))
      clipr::write_clip(code)
    }else{
      print(paste(cat_emoji, "copied that!"))
      clipr::write_clip(code)
    }
  } else if (length(code) == 0L & length(result) == 0L ) {
    paste(shit_emoji, "Sooorry, I've got no idea what you are looking for!")
  } else {
    print(paste("Did you mean ", CopyCatCode$fct[result],"?", sep = ""))
  }

}





utils::globalVariables(c("fct", "CopyCatCode"))



