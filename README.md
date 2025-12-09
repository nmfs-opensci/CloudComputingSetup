# NOAA Fisheries Cloud Computing Setup

This repository details cloud computing resources at NOAA Fisheries, with a focus on Google Cloud Workstations for R users.

## Why Cloud?

All NOAA datasets must be uploaded in the cloud by 2026, and all on-premesis computing resources for NOAA Fisheries are planned to be retired by 2027. Working entirely in the cloud allows scientists to make programs more efficient, without losing time to downloading/uploading. With the transition timeline away from existing resources, we have compiled documentation here to share and allow scientists who previously worked on uber computers to adapt their workflows more quickly. Some programs can be run locally just as efficiently as they can be in the cloud [add use cases].

## Fisheries Cloud Program

NOAA Fisheries Cloud Program rolled out a Cloud Compute Accelerator Pilot in early 2025: [Enhancing NOAA Fisheries’ Mission with Google Cloud Workstations](https://docs.google.com/document/d/1u7R5KjfEDYdwYTvO9kU6EyeHfG7dV9TQizIyCn8seO0/edit?tab=t.0). Following the conclusion of this Pilot Program, they have released a [Fisheries Cloud Program](https://docs.google.com/document/d/1nziPdPULoRWOYQ9WKzISNUgJvANACvfYpFr1z3Ro2Bc/edit?tab=t.0) and compiled [Frequently Asked Questions](https://docs.google.com/document/d/1U1PzGS7G70xsXtD6F6WxkjTSCw7bwNVyZ-YnFyOLOqU/edit?tab=t.0) for pilot participants and new users.

## Setting up a Google Cloud Workstation

*Selecting the right size, importance of shutting down workstation when done, when to use/not to use workstations, etc.*

**BACK UP YOUR WORK** and use the cloud workstations to run existing scripts, not to develop code.  It is important to the community that we monitor usage for costs and be aware that these workstations automatically delete after 6 months of no use.  High resource users, please see [Fisheries Cloud Program Section 4.0 High-Performance and Custom Workstations (FMC-Funded Option)](https://docs.google.com/document/d/1nziPdPULoRWOYQ9WKzISNUgJvANACvfYpFr1z3Ro2Bc/edit?tab=t.0#heading=h.65j2qoyirqa8): "The enterprise offering is designed to cover standard analytical needs. If your work requires high-cost, specialized resources, such as GPUs, larger machine types (beyond Large), or custom-developed images for specific program workflows, these resources are available, and treated as independent GCP projects, and billed according to the annual GCP cost recovery process."

## Requesting a Google Data Bucket

Work through local IT. [Add instructions for each Center here?] Reference [Eli's documentation about servers vs objects](https://nmfs-opensci.github.io/EDMW-EarthData-Workshop-2025/content/why-cloud.html) related to Google shared drive vs buckets and speed.

Existing public NOAA data buckets can be found [here](https://www.noaa.gov/nodd/datasets#NMFS)

## Linking Workstation to GitHub

The quickest and most persistent method for linking a workstation to a Github Enterprise Account is with a Person Access Token (PAT). This can be done by reading the instructions and executing the code in [R/github_setup.R](https://github.com/nmfs-opensci/CloudComputingSetup/blob/main/R/github_setup.R). Before executing the script you will need to generate a PAT, bellow are relevant PAT documentation (also linked in script):

1.  [GitHub PAT Settings](https://github.com/settings/tokens)
2.  [GitHub PAT Tutorial](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
3.  [NMFS GitHub Governance Authentication Tutorial Video](https://drive.google.com/file/d/1tbbw_xXARK689Zj5tm4lVo18aBaXhdKX/view?t=4) (Requires NOAA Google Drive access)

Workstations will remain linked to GitHub until the PAT expires and persists even if the workstation is shutdown. Once the link is made to your GitHub repository, you can push and pull changes as you would from any other machine.

## Linking Workstation to Bucket

Buckets need to be mounted each time a workstation is started and should persist across all sessions until the workstation is turned off. Mounting a bucket requires an active terminal (the tab next to the R console in RStudio and Positron). Copy and paste the [R/mount_bucket.R](https://github.com/nmfs-opensci/CloudComputingSetup/blob/main/R/mount_bucket.R) code directly in the terminal. [Please note that ctrl+v does not work for pasting into an R terminal; ctrl+shift+v or manually right click and select 'Paste'. ] The code is commented with instructions and can be pasted line by line or all at once.

The terminal will prompt you to authenticate your google account on [line 17](https://github.com/SEFSC/cloud_computing_SSMSE_starter/blob/0d3689835cd279d37bf01e47fe8b7ba8e426b485/mount_bucket.R#L17):

```{r}
gcloud auth application-default login --no-launch-browser
```

Follow the prompts to authenticate (including pasting the output from your browser directly into Terminal), then press enter or copy and paste the rest of the script in the R Terminal to continue the process. This is the most finicky and potentially user-specific step of the process.

The remaining code will install or update `gcsfuse` on the workstation and mount the bucket. Once mounted a first time, lines 41-47 can be used to remount a bucket after a workstation is shutdown and skip the authentication/installation process.

*We'll need to change the bucket name to the public one that Eli plans to use for Openscapes/training purposes*

### Validating the Connection

From the code provided previously to mount a data bucket, we have named the bucket `my_gsc_bucket` and stick with this nomenclature throughout. If you are still working in the R Terminal, you can validate the connection using

`ls -l "$MOUNT_POINT"`

If you are working in a regular R Script or Console, you can check the contents of the bucket using

`list.files("~/my_gcs_bucket")`

Additionally, to view contents within subfolders, you can use

`list.files(path = "~/my_gcs_bucket/subfolder")`

### Reading from Buckets

Once the connection to the Data Bucket is made, you can run R scripts as usual, pointing to the bucket location. For example,

`load('~/my_gcs_bucket/subfolder/sampdata1.RData')`

`data <- read.csv("~/my_gcs_bucket/subfolder/sampdata2.csv")`

both work to load an RData image and .csv file, respectively.

### Writing to Buckets

Writing to buckets works similarly. If the 'data' file above was cleaned on the Workstation and named 'data2' in R, this could be written directly to the workstation as 'sampdata2_clean.csv'.

`write.csv(data2,"~/my_gcs_bucket/subfolder/sampdata2_clean.csv")`

### Best Practices

Suggested ways to set up workflows to easily move between running locally and in the cloud if desired.

## Alternative Options

If cloud computing resources are not necessary, alternative options include accessing data in the cloud with local computing resources. With Google Drive for Desktop, data on shared drives can be accessed using G:/ the same as we access shared drives on local computers. Alternatively, if cloud computing workstations have sufficient storage for the programs that you're running, it is not absolutely necessary to link to a data bucket. [Alternate ways to pull data down from the workstation if not a data bucket? Can these also just write to shared drives? Much slower--but wanting to provide options for different workflows].

## Acknowledgements

Resources shared by [Eli Holmes](https://github.com/eeholmes), [Alex Norelli](https://github.com/norellia-NOAA), Josh Lee, and Ed Rogers; compiled by [Molly Stevens](https://github.com/mollystevens-noaa).

### Disclaimer

This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project content is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.

### License

This content was created by U.S. Government employees as part of their official duties. This content is not subject to copyright in the United States (17 U.S.C. §105) and is in the public domain within the United States of America. Additionally, copyright is waived worldwide through the CC0 1.0 Universal public domain dedication.
