# Demo: access a Google Cloud Storage bucket from R running in a
# Google Cloud Workstation.
#
# This example shows how to:
# 1. authenticate with Application Default Credentials (ADC),
# 2. confirm access to a bucket,
# 3. upload a small example file, and
# 4. download that file back into R.
#
# Before running this script, authenticate once from the workstation terminal:
#   gcloud auth application-default login --no-browser
#
# That command starts a copy/paste authentication flow:
# 1. copy the long URL from the workstation terminal,
# 2. open it in a browser on your local machine,
# 3. sign in and approve access,
# 4. copy the resulting code back into the workstation terminal.
#
# Alternative interactive approach:
# You can use `credentials_user_oauth2(scopes = scope)` instead of
# `token_fetch()` if you prefer to initiate authentication from R.
#
# Packages:
# install.packages(c("googleCloudStorageR", "gargle", "readr"))

library(gargle)
library(googleCloudStorageR)
library(readr)

# Bucket can live in a different project as long as the user or service account
# has permission on that bucket.
bucket_name <- "josh-london"

# Full Cloud Platform scope is convenient for demos, but narrower scopes are
# preferable in production workflows when possible.
scope <- "https://www.googleapis.com/auth/cloud-platform"

# Retrieve Application Default Credentials and use them for GCS requests.
token <- token_fetch(scopes = scope)
gcs_auth(token = token)

# Confirm access to the bucket.
gcs_list_objects(bucket = bucket_name)

# Set a default bucket so later calls can omit `bucket =`.
gcs_global_bucket(bucket_name)

# Write a small example file locally, then upload it to the bucket.
local_file <- tempfile(fileext = ".csv")
write_csv(mtcars, local_file)

gcs_upload(
  file = local_file,
  name = "testing/mtcars.csv"
)

# Verify that the object now exists in the bucket.
gcs_list_objects(bucket = bucket_name)

# Download the uploaded object.
downloaded_file <- tempfile(fileext = ".csv")
gcs_get_object(
  object_name = "testing/mtcars.csv",
  bucket = bucket_name,
  saveToDisk = downloaded_file,
  overwrite = TRUE
)

# Read the downloaded file back into R.
mtcars_from_bucket <- read_csv(downloaded_file, show_col_types = FALSE)
head(mtcars_from_bucket)
