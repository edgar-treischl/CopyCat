#' copycat_code
#'
#' @param x A search string
#' @param data Data
#' @importFrom magrittr %>%
#'
#' @return A string
#' @export
#'

copycat_code <- function(x, data = ccc) {
  code <- data %>%
    dplyr::filter(fct %in% x) %>%
    dplyr::pull(code)
  if(length(code) == 0L) {
    print("Sooorry, I've got no idea what you are looking for!")
  } else {
    print("Your code my friend:")
    writeLines(code)
  }

}

#' copycat_package
#'
#' @param x A search string
#' @param data Data
#' @importFrom magrittr %>%
#'
#' @return A string
#' @export
#'

copycat_package <- function(x, data = ccc) {
  package <- data %>%
    dplyr::filter(fct %in% x) %>%
    dplyr::pull(package)

  searchstring <- x
  result <- agrep(searchstring, ccc$fct)
  shit_emoji <- "\U0001F4A9"
  cat_emoji <- "\U0001F408"


  if (length(package) == 1L) {
    paste(cat_emoji, "The package name is", package)
  } else if (length(package) == 0L & length(result) == 0L ) {
    paste(shit_emoji, "Sooorry, I've got no idea what you are looking for!")
  } else {
    print(paste("Did you mean", ccc$fct[result], "from the", ccc$package[result], "package?"))

  }

}



#' copy_that
#'
#' @param x A search string
#' @param data Data
#' @importFrom magrittr %>%
#'
#' @return A string
#' @export
#'

copy_that <- function(x, data = ccc) {
  code <- data %>%
    dplyr::filter(fct %in% x) %>%
    dplyr::pull(code)
  searchstring <- x
  result <- agrep(searchstring, ccc$fct)

  shit_emoji <- "\U0001F4A9"
  cat_emoji <- "\U0001F408"

  if (length(code) == 1L) {
    print(paste(cat_emoji, "You are ready to paste!"))
    clipr::write_clip(code)
  } else if (length(code) == 0L & length(result) == 0L ) {
    paste(shit_emoji, "Sooorry, I've got no idea what you are looking for!")
  } else {
    print(paste("Did you mean", ccc$fct[result],"?"))
  }

}





utils::globalVariables(c("fct", "ccc"))



