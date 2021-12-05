#' copycat_code
#'
#' @param x A search string
#' @param data Data
#' @importFrom magrittr %>%
#'
#' @return A string
#' @export
#'

copycat_code <- function(x, data) {
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


copycat_package <- function(x, data) {
  package <- data %>%
    dplyr::filter(fct %in% x) %>%
    dplyr::pull(package)
  if(length(package) == 0L) {
    print("Package is not listed in your df.")
  } else {
    print("The package name:")
    writeLines(package)
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

copy_that <- function(x, data) {
  code <- data %>%
    dplyr::filter(fct %in% x) %>%
    dplyr::pull(code)

  if(length(code) == 0L) {
    print("Sooorry, I've got no idea what you are looking for!")
  } else {
    print("You are ready to paste!")
    clipr::write_clip(code)
  }
}



