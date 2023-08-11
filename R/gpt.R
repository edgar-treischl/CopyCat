#' ASK ChatGPT for some R help
#'
#' @description The function `ask_gpt` sends message to ChatGPT and shows the results via the console
#'
#' @param message The prompt for ChatGPT
#' @param model The ChatGPT model
#' @param maxtoken Maximal numbers and tokens
#' @param tempvalue The temperature
#' @param return Returns answer as text via the console (default) or raw as a character vector
#' @return A character vector.
#' @export
#'

ask_gpt <- function(message,
                    model = "text-davinci-003",
                    maxtoken = 300,
                    tempvalue = 0,
                    return = "text") {

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

  prompt_engine <- c("You are talking with people who learn R. Show with implemented data sets, for example the mtcars data, how R works.")

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
  if (return == "raw") {
    return(chatGPT_answer)
  }
  cat(chatGPT_answer)
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
    miniUI::gadgetTitleBar("CopyCat goes ChatGPT"),
    miniUI::miniContentPanel(
      textInput("caption", "Your question:", placeholder = NULL, width = '100%'),
      actionButton("write", "Send", class = "btn-primary"),
      actionButton("copy", "Copy answer", class = "btn-fail"),
      verbatimTextOutput("preview")
    )
  )

  server <- function(input, output, session) {



    #write code
    observeEvent(input$write, {

      caption <- input$caption
      x <- copycat::ask_gpt(caption, return = "raw")
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
    observeEvent(input$done, {
      stopApp()
    })

  }

  viewer <- paneViewer(300)
  runGadget(ui, server, viewer = viewer)

}
