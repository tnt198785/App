server<-function(input,output){
  output$Additional_coefficients<-renderUI({
    lapply(2:input$covariates, function(i) {
      numericInput(inputId = paste0("c", i), label = paste("delta", i),value = NULL)
    })
    
  })
  
  
  
  output$Positions<-renderUI({
    lapply(2:input$xpos, function(i) {
      numericInput(inputId = paste0("xpos", i), label = paste("Position of Interest", i),value = i+1)
    })
  })
  output$summary <- renderPrint({
    poss=input$xpos1
    if (input$xpos>1){
    for (l in 2:input$xpos){
      poss=c(poss,input[[paste0("xpos", l)]])
    }
    }
    x<-rqfun(input$xmean,input$xsd,input$xdist, input$xterm, pos = poss, input$xmth)
    print(x)
    
    if(input$pw_or_n == 'Power') {
      n = input$n
      pwr = NULL
    } else {
      n = NULL 
      pwr = input$pwr
    }
    delta=input$c1
    if (input$covariates>1){
     for (j in 2:input$covariates){
      delta=c(delta,input[[paste0("c", j)]])
     }
    }
    print(delta)
    if (input$dist_or_resid=="Residual"){
    fileres<-input$file
    if (is.null(fileres))
      return("Waiting for data...")
    res<-read.table(file = fileres$datapath)
    res<-res[,1]
    if(input$bw == 0) bw = NULL
    else bw = input$bw
    if(is.numeric(res)==TRUE){
      pwn =power.rq.test(x=x,n=n,sig.level = input$sig.level,power = pwr,tau = input$tau,sd = input$sd,
                  delta=delta,dist=res,kernel.smooth = input$kernel.smooth,bw = bw,alternative = input$alternative)
    }
    }
    else
      pwn = try(power.rq.test(x, n = n,sig.level = input$sig.level,power = pwr,tau = input$tau,sd = input$sd,
                  delta = delta,dist = input$dist,alternative = input$alternative))
    if(class(pwn)=='try-error') cat('Please input a set of validate parameters...\n')
    else print(pwn)
  })
}