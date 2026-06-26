# GCS Bucket access demo from Google Cloud Workstation (RStudio or Positron)

This guide explains [R/bucket_access.R](R/bucket_access.R) as a demonstration for
read and write access from a Google Cloud Workstation to a Google Cloud Storage Bucket,
including a bucket that lives in a different GCP project.

## What the demo script does

The script is intentionally small. It demonstrates four steps:

1. authenticate from R using Application Default Credentials (ADC),
2. confirm that the authenticated identity can access the target bucket,
3. upload a small example CSV file to the bucket, and
4. download that file back into R.

This is simple test process to verify that a workstation can interact with a bucket.
Users can use this as a starting point for implementing their own workflows.

## What you need before running it

You should have:

- access to a Google Cloud Workstation,
- the ability to run `gcloud` from the workstation terminal,
- permission to access the target bucket, and
- the required R packages installed.

Install the R packages if needed:

```r
install.packages(c("googleCloudStorageR", "gargle", "readr"))
```

## One-time authentication setup

The recommended best practice for authentication is to use Application Default
Credentials (ADC). This creates a persistent authentication on the workstation
after a one-time process. The `gcloud` CLI application is installed by default
on all Google Workstations

From the workstation terminal, run:

```bash
gcloud auth application-default login --no-browser
```

This starts a manual browser-based flow. In practice, the steps are:

1. copy the long authentication URL from the workstation terminal,
2. open that URL in a browser on your local machine,
3. sign in with the account that has bucket access,
4. approve the request,
5. copy the returned code, and
6. paste it back into the workstation terminal.

This creates Application Default Credentials that R can use
through `gargle::token_fetch()`.

## How to configure the script

Open [R/bucket_access.R](R/bucket_access.R) and update this value:

```r
bucket_name <- "your-bucket-name"
```

The bucket can live in a different project from the workstation as long as the authenticated identity has the necessary permissions on that bucket.

## How to run the demo

Run the script in R from the workstation.

The script will:

- fetch ADC credentials,
- authenticate with Google Cloud Storage,
- list objects in `bucket_name`,
- upload `mtcars` as `testing/mtcars.csv`,
- download the same object to a temporary local file, and
- read the downloaded CSV back into R.

A successful run is a good indication that both authentication and bucket permissions are working.

## Common permission requirements

Exact IAM roles vary, but the authenticated identity generally needs permission to:

- access the target bucket,
- create objects in the bucket to test upload, and
- get objects from the bucket to test download.

For this demo, bucket-level permissions matter more than project-level visibility. A user can successfully read from and write to a known bucket in another project without being able to list all buckets in that project.

## Typical failure points

### Authentication fails

If `token_fetch()` fails, the workstation may not have valid Application Default Credentials yet. Re-run:

```bash
gcloud auth application-default login --no-browser
```

### Bucket listing, upload, or download fails

If calls involving `bucket_name` fail, verify:

- the bucket name is correct,
- the bucket exists,
- your identity has read and/or write permissions, and
- any organization or project policy allows cross-project access.

## Why the script writes a temporary file

`googleCloudStorageR::gcs_upload()` is clearest when you upload a file from disk. The script writes `mtcars` to a temporary CSV first, then uploads that file. This makes the demo easier to understand and mirrors many real workflows where outputs are written locally and then copied to cloud storage.

## Suggested next step for real workflows

For production code, it is usually worth adapting this demo in three ways:

1. move `bucket_name` and object paths into a small config section,
2. add explicit error handling and messages around authentication and uploads, and
3. avoid broad scopes when a narrower scope will do.
