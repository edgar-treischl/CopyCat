#' pic_fun picks a package and a function randomly
#' @noRd
#' @keywords internal
#'
#'

pic_fun <- function() {
  all_packs <- as.data.frame(installed.packages()[,c(1,3)])
  names <- all_packs$Package
  name <- sample(names, 1)

  weird_R_packages <- c("R.oo", "plumber")

  help_names <- copycat_helpsearch(name)
  help_name <- sample(help_names, 1)
  help_name
  #foad(package = name, fun = help_name)
  #foad(package = "osmdata", fun = "osmdata_sf")
  df <- data.frame(package = name, fun = help_name)
  return(df)
}


#' final_fun checks if example are available and should be run
#' @noRd
#' @keywords internal
#' @export
final_fun <- function() {
  df <- pic_fun()
  x <- try(copycat_helpcode(pkg = df$package, fn = df$fun),
           silent = TRUE)
  notrun <- stringr::str_detect(x, "Not run")
  limit <- which(notrun == TRUE)

  while (class(x) == "try-error" | length(limit > 0)) {
    df <- pic_fun()
    x <- try(copycat_helpcode(pkg = df$package, fn = df$fun),
             silent = TRUE)
    notrun <- stringr::str_detect(x, "Not run")
    limit <- which(notrun == TRUE)
  }
  return(df)

}
