library(shiny)
source('./library.R')
source('./power.rq.test.R')
ui<-fluidPage(
  titlePanel("Sample size and power calculator for quantile regression"),
  fluidRow(
    column(3,
      h1("Covariates"),
      numericInput("xmean",label = "Mean",value = 0),
      numericInput("xsd",label = "Standard Deviation",value = 1),
      selectInput("xdist", label ="Distribution", 
                  choices = list("norm", "unif", "bin"), 
                  selected = "norm"),
      numericInput("covariates",label = "Covariates",value = 1),
      conditionalPanel("input.covariates>1",
      checkboxGroupInput("xterm", label = "Terms", 
      choices = list("1", "2", "-1", "-2", "log", "exp", "sqrt"), selected = "1")
      ),  
      numericInput("xpos",label = "Number of covariates of interest",value = 1),
      numericInput("xpos1",label = "Position of Interest 1",value = 2),
      conditionalPanel("input.xpos>1",
      uiOutput("Positions")
      ),
      selectInput("xmth", label ="Method", 
                  choices = list("exact", "sim"), 
                  selected = "exact"),
      conditionalPanel("input.xdist=='unif'",
      numericInput("xa",label = "Lower limit of uniform distribution (only when unif is selected above)",value = NA),
      numericInput("xb",label = "Upper limit of uniform distribution (only when unif is selected above)",value = NA)
      )
    ),
    column(3,
      #h1("Define other parameters"),
      selectInput("pw_or_n", label ="Power or Sample size", 
                  choices = list("Power", "SampleSize"), 
                  selected = "SampleSize"),
      conditionalPanel("input.pw_or_n=='Power'",
          numericInput("n",label = "Sample size",value = 100)),
      sliderInput("sig.level",label = "Significance level",value = 0.05,min = 0.005,max = 0.1),
      conditionalPanel("input.pw_or_n=='SampleSize'",
          sliderInput("pwr",label = "Power of test",value = 0.8,min = 0.5,max = 1)),
      sliderInput("tau",label = "Quantile",value = 0.5,min = 0,max = 1),
      numericInput("sd",label = "Error standard deviation",value = 1),
      numericInput("c1",label = "delta 1",value = 0.5),
      conditionalPanel("input.covariates>1",
      uiOutput("Additional_coefficients")),
      selectInput("dist_or_resid", label ="Distribution or Residual", 
                  choices = list("Distribution", "Residual"), 
                  selected = "Distribution"),
      conditionalPanel("input.dist_or_resid == 'Distribution'", 
          selectInput("dist", label = "",
                  choices = list("Norm", "Cauchy", "Gamma"), 
                  selected = "Norm")),
      conditionalPanel("input.dist_or_resid == 'Residual'", 
        fileInput("file", label = ""),
        selectInput("kernel.smooth",label = "Kernel type for kernel smoothing",
                  choices = list("norm","1"=1,"2"=2,"3"=3,"4"=4),selected = "0"),
        numericInput("bw",label = "Band width for kernel smoothing",value = 0)),

      selectInput("alternative", label ="Test type", 
                  choices = list("two.sided", "one.sided"), 
                  selected = "two.sided")
    ),
  column(6,
         mainPanel(
           h3("Summary"),
           verbatimTextOutput("summary")
         )
  )
  )
)
