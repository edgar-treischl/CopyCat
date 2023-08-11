#' ASK ChatGPT for some R help
#'
#' @description The function `ask_gpt` sends message to GTP; shows the results in the console, and copies
#' the result to your clipboard
#'
#' @param message The prompt for GTP
#' @param model The GTP model
#' @param maxtoken Maximal numbers and tokens
#' @param tempvalue The temperature
#' @return A character vector.
#' @export
#'

ask_gpt <- function(message,
                    model = "text-davinci-003",
                    maxtoken = 300,
                    tempvalue = 0) {

  key <- try(keyring::key_get(service = "gtp_api"), silent = TRUE)

  test1 <- is(key, "try-error")
  test2 <- exists("gtp_api")
  test <- c(test1, test2)

  if (any(test)) {
    cli::cli_abort("Create a API key from https://openai.com and assign it as api_key.")
  }

  if (curl::has_internet() == FALSE) {
    cli::cli_abort("No internet access my friend.")
  }

  gtp_api <- keyring::key_get(service = "gtp_api")

  prompt_engine <- c("You are an R and RStudio expert. Show with implemented data sets such as mtcars or iris how R works.")

  message2 <- paste(message, prompt_engine)

  response <- httr::POST(
    # curl https://api.openai.com/v1/chat/completions
    url = "https://api.openai.com/v1/completions",
    # -H "Authorization: Bearer $OPENAI_API_KEY"


    httr::add_headers(Authorization = paste("Bearer", gtp_api)),
    # -H "Content-Type: application/json"
    httr::content_type_json(),
    # -d '{
    #   "model": "gpt-3.5-turbo",
    #   "messages": [{"role": "user", "content": "What is X?"}]
    # }'
    encode = "json",
    body = list(
      #model = "text-davinci-003",
      model = model,
      prompt = message2,
      max_tokens = maxtoken,
      temperature = tempvalue)
  )

  chatGPT_answer <- httr::content(response)$choices[[1]]$text
  #clipr::write_clip(chatGPT_answer)
  #cat(chatGPT_answer)
  return(chatGPT_answer)

}

utils::globalVariables(c("gtp_api"))



#' ChatGPT Interface
#'
#' @description The addin gives a graphical interface for  `ask_gpt`.
#'
#' @return A character vector.
#' @export
#'


askgpt_addin <- function() {

  ui <- miniUI::miniPage(
    waiter::use_waitress(),
    tags$head(
      tags$style(HTML("
      .gadget-title{
        color: black;
        font-size: larger;
        font-weight: bold;
      }
      .btn-edgar {
        background-color: #0077b6;
        border: none;
        color: white;
        opacity: 0.6;
        transition: 0.3s;
        font-size: medium;
      }
      .btn-edgar:hover {
        opacity: 1;
        background-color: #0077b6;
      }
      .btn-success {
        background-color: #f4511e;
        border: none;
        color: white;
        opacity: 0.6;
        transition: 0.3s;
        font-size: medium;
      }
      .btn-success:hover {
        opacity: 1;
        background-color: #f4511e;
      }"))
    ),
    miniUI::gadgetTitleBar("CopyCat goes AI"),
    miniUI::miniContentPanel(
      h4("AskGTP a question:"),
      textInput("caption", "Your question", placeholder = NULL, width = '100%'),
      actionButton("write", "Go!", class = "btn-success"),
      actionButton("copy", "Copy", class = "btn-fail"),
      verbatimTextOutput("preview")
    )
  )

  server <- function(input, output, session) {



    #write code
    observeEvent(input$write, {

      caption <- input$caption
      x <- copycat::ask_gpt(caption)
      observeEvent(input$copy, {
        clipr::write_clip(x)
      })
      waitress <- waiter::Waitress$new("#preview")
      output$preview <- renderText({
        for(i in 1:10){
          waitress$inc(10) # increase by 10%
          Sys.sleep(.3)
        }
        waitress$close() # hide when done
        return(x)

      }

      )


    })


    #DONE



    #DONE
    observeEvent(input$done, {
      stopApp()
    })

  }

  viewer <- paneViewer(300)
  runGadget(ui, server, viewer = viewer)

}
