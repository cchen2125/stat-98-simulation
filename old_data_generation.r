# Function to generate synthetic data for a given scenario
generate_synthetic_data <- function(n=3000, imbalance_ratio, case) {
  # Calculate the number of samples for each class
  n_minority <- round(n * imbalance_ratio)
  n_majority <- n - n_minority
  
  # Set the distribution parameters based on the case
  if (case == '1a') {
    mean_X1_majority <- 0; mean_X1_minority <- 2
    lambda_X2_majority <- 1; lambda_X2_minority <- 1/2
  } else if (case == '1b') {
    mean_X1_majority <- 0; mean_X1_minority <- 2
    lambda_X2_majority <- 1/2; lambda_X2_minority <- 1
  } else if (case == '2a') {
    mean_X1_majority <- 0; mean_X1_minority <- 6
    lambda_X2_majority <- 1; lambda_X2_minority <- 1/6
  } else if (case == '2b') {
    mean_X1_majority <- 0; mean_X1_minority <- 6
    lambda_X2_majority <- 1/6; lambda_X2_minority <- 1
  }
  
  # Generate data
  X1_majority <- rnorm(n_majority, mean_X1_majority, 2)
  X1_minority <- rnorm(n_minority, mean_X1_minority, 2)
  X2_majority <- rexp(n_majority, rate=lambda_X2_majority)
  X2_minority <- rexp(n_minority, rate=lambda_X2_minority)
  
  # Combine the data
  X1 <- c(X1_majority, X1_minority)
  X2 <- c(X2_majority, X2_minority)
  Y <- c(rep(0, n_majority), rep(1, n_minority))
  
  # Shuffle the data
  data <- data.frame(X1, X2, Y)
  data <- data[sample(nrow(data)), ]
  
  return(data)
}

# Define the class imbalance ratios and cases to loop through
imbalance_ratios <- c(0.5, 0.25, 0.1, 0.05)
cases <- c('1a', '1b', '2a', '2b')

# Loop through each imbalance ratio and case, generating the datasets
for (imbalance_ratio in imbalance_ratios) {
  for (case in cases) {
    data <- generate_synthetic_data(n=3000, imbalance_ratio=imbalance_ratio, case=case)
    # You can now use 'data' for your analysis or save it for later use
    # For example, you might save each dataset to a file:
    write.csv(data, sprintf("data_%s_%s.csv", imbalance_ratio, case), row.names = FALSE)
  }
}

# This code will generate 16 datasets, one for each combination of imbalance ratio and case