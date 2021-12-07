.onAttach <- function(libname, pkgname){
  if(interactive()){
    packageStartupMessage(
      "CopyCat is ready to go."
    )
  }
}
