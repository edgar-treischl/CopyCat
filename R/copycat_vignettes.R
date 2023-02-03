#' copycat_vigsearch
#' @description Examine the vignettes of a package.
#'
#' @param pkg A search string
#'
#' @return A list
#' @export
#'

copycat_vigsearch <- function(pkg) {
  vignettes <- tools::getVignetteInfo(pkg)
  df <- as.data.frame(vignettes)
  df$R

}


#' copycat_vignette
#' @description Copy the code of a vignette.
#' @param pkg A search string
#' @param vig A search string
#'
#' @return A string
#' @export
#'

copycat_vignette <- function(pkg, vig) {
  docfile <- file.path(find.package(pkg), "doc", vig)
  docfile <- paste(docfile, ".R", sep = "" )
  smile <- "\U0001F60E"
  error <- "\U0001F922"
  test <- file.exists(docfile)

  if (test == TRUE) {
    con <- file(docfile, "r")
    line <- readLines(con)
    #print(line)
    print(paste(smile, "copied that!"))
    clipr::write_clip(line)
  } else {
    print(paste(error, "sorry, something went wrong..."))
  }
}

#' copycat_vigscript
#' @description Create a new script with the code from the vignette.
#' @param pkg A search string
#' @param vig A search string
#'
#' @return A string
#' @export
#'

copycat_vigscript <- function(pkg, vig) {
  docfile <- file.path(find.package(pkg), "doc", vig)
  docfile <- paste(docfile, ".R", sep = "" )
  test <- file.exists(docfile)

  if (test == TRUE) {
    con <- file(docfile, "r")
    line <- readLines(con)

    tmp <- fs::dir_create(fs::file_temp())
    path <- paste(tmp,"/", vig, "_extracted.R", sep = "")
    fs::file_create(path)
    id <- rstudioapi::getSourceEditorContext()$id
    rstudioapi::navigateToFile(path)

    while(rstudioapi::getSourceEditorContext()$id == id){
      next()
      Sys.sleep(0.1) # slow down the while loop to avoid over-processing
    }
    id <- rstudioapi::getSourceEditorContext()$id
    rstudioapi::insertText(line)
  } else {
    print("Computer says no ...")
  }
}
