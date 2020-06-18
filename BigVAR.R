library(BigVAR)
library(expm)

# Create model
data(Y)

p = 4 # lags
k = ncol(Y) # number of equations

# Create a Basic VAR-L (Lasso Penalty) with maximum lag order p=4, 10 gridpoints with lambda optimized according to rolling validation of 1-step ahead MSFE
mod1 = constructModel(Y,p,"Basic",gran=c(150,10),RVAR=FALSE,h=1,cv="Rolling",MN=FALSE,verbose=FALSE,IC=TRUE)
results = cv.BigVAR(mod1)

# Get model estimates
A = results@betaPred[,2:ncol(results@betaPred)] # (k x (k*p)) = (3 x (3*4)) coefficient matrix (reduced form)
Sigma = cov(results@resids)

# A number of helper functions ----
# Compute reduced-form IRFs:
compute_Phi = function(p, k, A_comp, n.ahead) {
  
  J = matrix(0,nrow=k,ncol=k*p)
  diag(J) = 1
  
  Phi = lapply(1:n.ahead, function(i) {
    J %*% (A_comp %^% (i-1)) %*% t(J)
  })
  
  return(Phi)
  
}

# Compute orthogonalized IRFs:
compute_theta_kj_sq = function(Theta, n.ahead) {
  
  theta_kj_sq = lapply(1:n.ahead, function(h) { # loop over h time periods
    out = sapply(1:ncol(Theta[[h]]), function(k) {
      terms_to_sum = lapply(1:h, function(i) {
        Theta[[i]][k,]**2
      })
      theta_kj_sq_h = Reduce(`+`, terms_to_sum)
    })
    colnames(out) = colnames(Theta[[h]])
    return(out)
  })
  
  return(theta_kj_sq)
}

# Compute mean squared prediction error:
compute_mspe = function(Theta, n.ahead=10) {
  mspe = lapply(1:n.ahead, function(h) {
    terms_to_sum = lapply(1:h, function(i) {
      tcrossprod(Theta[[i]])
    })
    mspe_h = Reduce(`+`, terms_to_sum)
  })
}

# Function for FEVD:
fevd = function(A, Sigma, n.ahead) {
  
  k = dim(A)[1] # number of equations
  p = dim(A)[2]/k # number of lags
  
  # Turn into companion form:
  if (p>1) {
    A_comp = VarptoVar1MC(A,p,k) 
  } else {
    A_comp = Phi
  }
  
  # Compute MSPE: ----
  Phi = compute_Phi(p,k,A_comp,n.ahead)
  P = t(chol.default(Sigma)) # lower triangular Cholesky factor
  B_0 = solve(P) # identification matrix
  Theta = lapply(1:length(Phi), function(i) {
    Phi[[i]] %*% solve(B_0)
  })
  theta_kj_sq = compute_theta_kj_sq(Theta, n.ahead) # Squared orthogonaliyed IRFs
  mspe = compute_mspe(Theta, n.ahead)
  
  # Compute percentage contributions (i.e. FEVDs): ----
  fevd_list = lapply(1:k, function(k) {
    t(sapply(1:length(mspe), function(h) {
      mspe_k = mspe[[h]][k,k]
      theta_k_sq = theta_kj_sq[[h]][,k]
      fevd = theta_k_sq/mspe_k
    }))
  })
  
  # Tidy up
  fevd_tidy = data.table::rbindlist(
    lapply(1:length(fevd_list), function(k) {
      fevd_k = data.table::melt(data.table::data.table(fevd_list[[k]])[,h:=.I], id.vars = "h", variable.name = "j")
      fevd_k[,k:=paste0("V",k)]
      data.table::setcolorder(fevd_k, c("k", "j", "h"))
    })
  )
  
  return(fevd_tidy)
}

fevd_res = fevd(A, Sigma, 20)

library(ggplot2)

p = ggplot(data=fevd_res) +
  geom_area(aes(x=h, y=value, fill=j)) +
  facet_wrap(k ~ .) +
  scale_x_continuous(
    expand=c(0,0)
  ) +
  scale_fill_discrete(
    name = "Shock"
  ) +
  labs(
    y = "Variance contribution",
    x = "Forecast horizon"
  ) +
  theme_bw()
p
