set.seed(102)

reps <- 10000
beta_vals <- c(-1.5,-0.5,0.5,1.5)
time_srs<-c(20,100,500)

results <- data.frame(
  Beta = numeric(),
  Time_smpl = numeric(),
  Mean_Beta = numeric(),
  Bias = numeric(),
  Var_Beta = numeric(),
  Coverage = numeric()
)

for(beta_t in beta_vals){
    for(t in time_srs){
      
      betas <- numeric(reps)
      cover <- numeric(reps)
      
      for(r in 1:reps){
        
          rm_ex <- rnorm(t,0.05,0.12)
          err <- rnorm(t,0,0.10)
          
          capm_ex_ret <- (beta_t * rm_ex) + err
          
          olsregression <- lm(capm_ex_ret ~ rm_ex)
          beta_hat <- coef(olsregression)[2]
          
          
          se <- summary(olsregression)$coefficients[2,2]
          
          betas[r] <- beta_hat
          
          if(abs((beta_hat-beta_t)/se) <= 1.96){
            cover[r] <- 1
          }else{
            cover[r] <- 0
          }
       }
      
      mean_beta <- mean(betas)
      mean_cover <- mean(cover)
      var_betas <- var(betas)
      bias <- mean_beta - beta_t
      
      hist(betas, main = paste("Sampling distribution: Beta = ", beta_t, " T =", t), xlab = "Beta hats", breaks = 50,
           col = "blue", border = "black")
      abline(v = beta_t, col = "red", lwd = 2)
      
      results <- rbind(results, 
                       data.frame(
                         Beta = beta_t,
                         Time_smpl = t,
                         Mean_Beta = mean_beta,
                         Bias = bias,
                         Var_Beta = var_betas,
                         Coverage = mean_cover
                       ))
          
    }
}

print(results)

