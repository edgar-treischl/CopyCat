#' Title
#'
#' @param x A factor
#' @param data A df
#' @importFrom magrittr %>%
#'
#' @return
#' @export
#'
#'
#'
copycat_viewer <- function(x, file_path = NULL) {
  tempDir <- tempfile()
  dir.create(tempDir)
  htmlFile <- file.path(tempDir, "Template.html")
  file.copy(x, htmlFile)
  viewer <- getOption("viewer")
  viewer(htmlFile)
}


copycat_example <- function(x, data = ccc) {
  y <- data %>%
    dplyr::filter(fct %in% x) %>%
    dplyr::pull(code)

  z <- data %>%
    dplyr::filter(fct %in% x) %>%
    dplyr::pull(package)

  if(length(y) == 0L) {
    print("Sooorry, I've got no idea what you are looking for!")
  } else {
    rmarkdown::render(input = copy_code_template.Rmd,
                      output_file = sprintf("%s.html", x),
                      params = list(z = z,
                                    y = y,
                                    data = data))

    copycat_viewer(paste0(x, sep = ".","html"))
  }


}





copycat_kill <- function(search_name) {
  file.remove(paste0(search_name, sep = ".","html"))
}



