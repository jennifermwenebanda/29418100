# Responsible only for importing the raw loan-level data. No cleaning or
# transformation happens here - see Clean_Loans_Pipeline.R and friends.
Load_Loans <- function(filepath = "data/Loan_Cred/loan_data.rds"){

  readRDS(filepath)

}
