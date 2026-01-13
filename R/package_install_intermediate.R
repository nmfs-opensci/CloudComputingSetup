# If you are in the RStudio IDE run this code to make packages install faster:  
#repo_line <- 'options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/latest"))'
#writeLines(repo_line, "~/.Rprofile")

# Restart R session to lock in Rprofile changes
# Session -> Restart R or Ctrl+Shift+F10

# Intermediate method for installing packages

# Follows this tutorial:  https://rstudio.github.io/renv/articles/renv.html#getting-started

# Install the renv package
install.packages("renv")

# ON LOCAL MACHINE/WHERE ORIGINAL CODE IS DEVELOPED

# Run this to create renv files in your repo for the first time.  
#renv::init()

# push renv.lock, .Rprofile, renv/settings.json and renv/activate.R to version control

# Open the snapshot environment with:  
renv::restore()

# When running renv::restore() if the environment does not have all the required 
# system packages, renv will provide a line of code starting with "sudo".  
# Move to your terminal tab in RStudio or Posit and first type
# sudo apt update
# follow the instructions to update current packages.  Then copy and paste the 
# sudo code that renv::restore provided.  Example:  
# sudo apt install libcurl4-openssl-dev libfontconfig1-dev libfreetype6-dev libicu-dev libpng-dev libx11-dev libxml2-dev pandoc

# Add new packages using:  
#renv::snapshot()

# Update packages with:  
#renv::update()

# Create a folder for the output in the working directory.  This could be your
# Google Bucket path.  
run_SSMSE_dir <- file.path("runs_output")
dir.create(run_SSMSE_dir)

# Base OM folder
# this is where you will upload the stock assessment you are working with
model_SSMSE_dir <- file.path("base_models")
dir.create(model_SSMSE_dir)

default_OM <- file.path(model_SSMSE_dir, "default")
dir.create(default_OM)

# If you have more than one OM/EM to upload, add the folders here.  