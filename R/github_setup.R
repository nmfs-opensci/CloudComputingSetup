# R code to connect github to a Google Cloud Workstation
# Author: Alexandra Norelli

# Go to Github and generate a Personal Access Token (PAT) with the permissions 
# you need:  
# https://github.com/settings/tokens
# Github tutorial here: 
# https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens
# Github Governaance Team Video tutorial here:  
# https://drive.google.com/file/d/1tbbw_xXARK689Zj5tm4lVo18aBaXhdKX/view?t=4

# ctrl+f and replace USER_NAME with your username
# ctrl+f and replace EMAIL with your email address
# ctrl+f and replace TOKEN with your PAT Token

system('git config --global user.name "USER_NAME"')
system('git config --global user.email "EMAIL"')
system("git config --list")  #check that the info is correct

cred_line <- "https://USER_NAME:TOKEN@github.com"
writeLines(cred_line, "~/.git-credentials")
system('git config --global credential.helper store')