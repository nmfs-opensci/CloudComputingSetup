# NOAA Fisheries Cloud Computing Setup

This repository details cloud computing resources at NOAA Fisheries, with a focus on Google Cloud Workstations for R users.  Please see the [Openscapes Fall 2025 Cohort's Cloud Clinic](https://gamma.app/docs/Cloud-Clinic-361wjiw6rh2pw2m?mode=doc) for foundational information on cloud data and computing.

## Why Cloud?

All [NOAA datasets must be uploaded in the cloud by 2026](https://docs.google.com/presentation/d/18cwiB2f2rVlX3RJIsIB0iaD9u2bMdblZCS8RYcrGDd0/edit?slide=id.p1#slide=id.p1), and all on-premises computing resources for NOAA Fisheries are planned to be retired by 2027. Working entirely in the cloud allows scientists to make workflows more efficient, without losing time to downloading/uploading. With the transition timeline away from existing resources, we have compiled documentation here to share and allow scientists who previously worked on uber computers to adapt their workflows more quickly.

The Google Cloud Workstations are super/uber computers in the cloud, or online, instead of physically housed at a NMFS facility. When running code that might take hours or days, a workstation can do the job while you retain full functionality of your local PC. Any work that previously required the uber computers or multiple PCs should be transitioned to the cloud.

## NOAA Fisheries Cloud Program

[NOAA Fisheries Cloud Program](https://docs.google.com/document/d/1nziPdPULoRWOYQ9WKzISNUgJvANACvfYpFr1z3Ro2Bc/edit?tab=t.0) began a Cloud Compute Accelerator Pilot in early 2025: [Enhancing NOAA Fisheries’ Mission with Google Cloud Workstations](https://docs.google.com/document/d/1u7R5KjfEDYdwYTvO9kU6EyeHfG7dV9TQizIyCn8seO0/edit?tab=t.0). Following the conclusion of this Pilot Program, they compiled [Frequently Asked Questions](https://docs.google.com/document/d/1U1PzGS7G70xsXtD6F6WxkjTSCw7bwNVyZ-YnFyOLOqU/edit?tab=t.0) for pilot participants and new users.

### Terminology and Definitions

Terminology used throughout this tutorial are defined below.

| Term          | Definition |
| ------------- | ------------- |
| Workstation   | Pre-configured virtual machines listed under “My Workstations” available on NOAA's Google Cloud. |
| Configuration | The default settings of the workstation including: type (Base, RStudio, Python, posit), and storage/processing size (small, medium, large).  |
| Session       | An active portion of the workstation, shares storage and power.  It is possible to partition a workstation into multiple sessions with different IDEs and core usage. |
| Data Bucket   | Cloud-based object storage drive that is optimized for code and external to the workstation. |


### Requesting a Google Cloud Workstation

The NOAA Fisheries Cloud Program grants access to Google Cloud Workations upon request by filling out the following [form](https://docs.google.com/forms/d/e/1FAIpQLSc-RSmPhLV7kBuiiuAzxb2LvWG7Q6XrNbQCbhJZtvaVVtOVZQ/viewform).


## Setting up a Google Cloud Workstation

A Google Cloud Workstation is a virtual machine (VM) that can be customized to mimic any computing environment. The VM is hosted in the cloud and incurs long-term storage costs whether it is in use or not. Ultimately, workstations are designed to be spun up, used, and deleted regularly. Think of workstations as disposable computers, you should strive to get the perfect fit for your purpose, use it, then discard it, with your entire process immortalized on GitHub and your inputs/outputs persisting on cloud storage.

### Selecting the right size workstation

The IDE or program you use to run your code will decide which workstation type you choose (Base, Code OSS, Python, R, Posit Workbench). This section focuses on which size you should choose. High resource users, please see [Fisheries Cloud Program Section 4.0 High-Performance and Custom Workstations (FMC-Funded Option)](https://docs.google.com/document/d/1nziPdPULoRWOYQ9WKzISNUgJvANACvfYpFr1z3Ro2Bc/edit?tab=t.0#heading=h.65j2qoyirqa8): "The enterprise offering is designed to cover standard analytical needs. If your work requires high-cost, specialized resources, such as GPUs, larger machine types (beyond Large), or custom-developed images for specific program workflows, these resources are available, and treated as independent GCP projects, and billed according to the annual GCP cost recovery process."

As with previous uber computer work, code should be written and troubleshooted locally before being executed in a workstation. During the troubleshooting process, you should get an idea of what storage and processing requirements you may have via benchmarking. For many processes, a workstation does not need to be a perfect fit, but below are some simple methods for benchmarking your work to better understand which size workstation you should select.

#### Benchmarking Storage Space

The workstation you select will need enough storage to hold all of your inputs, outputs, and temporary files generated during processing. The NOAA Fisheries Cloud Program provides workstations with 10GB, 50 GB, and 100GB worth of disk space. You must consider if your process will fit within 100 GB before using a workstation.

Since storage usage scales consistently, you can calculate the total output data by multiplying one unit of output data by however many iterations of code you plan on running. Add that to the total input data, and you know the minimum storage requirements of your process.

If your storage minimum is higher than the "large" workstation configuration (100 GB) then you will need to offload/delete data during the process, use a Google Bucket (see below), or request a custom configuration.

#### Benchmarking Processing Power

The processing power required for a process is more complex than storage space because some code scales with additional CPU and RAM. There are a few key questions you should ask when choosing processing power:

1.  Does the code run in parallel?

    If no, "small" will probably meet your needs unless your code is RAM or storage intensive.

    If yes, select the machine based on how many threads can it use simultaneously.

2.  How long does the process take, and would upgrading improve that time?

    Using the "Wall-Clock" method, you can measure how long 1 iteration takes (`r R:Sys.time()`) and extrapolate that out to however many iterations you plan on running. If your code runs in parallel and improves with additional cores/RAM and you need the results as soon as possible, use the largest machine.

3.  How RAM intensive is the code?

    If your code maxes out the RAM on your local machine, it may be worth it to benchmark your code to better understand how much RAM you will need on a workstation. The R `bench` package or Python `pyperf` can be used to calculate the RAM required.

When in doubt, you can start with the smallest workstation for additional troubleshooting and upgrade as needed.

## Using a Workstation

**BACK UP YOUR WORK** and use the cloud workstations to run existing scripts, not to develop code. Hourly compute costs are incurred when the workstation has been "Started", so ensure that each workstation is "Stopped" when runs are complete and the computing session is no longer in use. Be aware that these workstations automatically delete after 6 months of no use to avoid long term storage costs. The optimal workflow for a workstation is to have a GitHub repository with all the necessary code to run your process. Thus, the first step when opening a workstation should be connecting to GitHub.

### Linking Workstation to GitHub

The quickest and most persistent method for linking a workstation to a Github Enterprise Account is with a Person Access Token (PAT). This can be done by reading the instructions and executing the code in [R/github_setup.R](https://github.com/nmfs-opensci/CloudComputingSetup/blob/main/R/github_setup.R). Before executing the script you will need to generate a PAT, bellow are relevant PAT documentation (also linked in script):

1.  [GitHub PAT Settings](https://github.com/settings/tokens)
2.  [GitHub PAT Tutorial](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
3.  [NMFS GitHub Governance Authentication Tutorial Video](https://drive.google.com/file/d/1tbbw_xXARK689Zj5tm4lVo18aBaXhdKX/view?t=4) (Requires NOAA Google Drive access)

Workstations will remain linked to GitHub until the PAT expires and persists even if the workstation is shutdown. Once the link is made to your GitHub repository, you can push and pull changes as you would from any other machine.

#### Additional Notes on PATs

[Personal access tokens (classic)](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#personal-access-tokens-classic) are less secure. However, some features currently will only work with personal access tokens (classic). Namely, only personal access tokens (classic) have write access for public repositories that are not owned by you or an organization that you are not a member of. If linking to your GitHub repository fails using fine-grained tokens, consider switching to classic tokens.

PATs should be set to expire in 90 days. 'Configure SSO' needs to be set to 'Authorize' access to your Enterprise organization if applicable, e.g. SEFSC.

### Customizing Your Configuration

Code generally requires a specific computing environment to work properly, this is especially important when treating workstations as temporary machines. Below are some best practices for ensuring your environment is set-up before running your code.

#### RStudio

By default the RStudio configuration will attempt to download packages via source code instead of binary through the posit package manager which drastically slows the installation progress down. Before starting any installations use the following code to source binary:

```{r}
repo_line <- 'options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/latest"))'
writeLines(repo_line, "~/.Rprofile")
# Restart R session to lock in Rprofile changes
# Session -> Restart R or Ctrl+Shift+F10
```

You must restart the RStudio's R session before you install any packages. This should allow your workstation to install packages just as fast as a Posit configuration.

#### Posit

The Posit configuration is the easiest environment to set-up, whether you are using the Positron or RStudio IDE. Since Posit uses the posit package manager by default, any packages you install via install.packages() should install quickly and easily. When installing the first package you will be prompted to create a personal folder for the packages to be stored in home/user, you should type "yes" twice and that will ensure that your packages will persist between opening and closing the workstation.

### Cloning Your Workstation

Best Practices for configuring workstations is still in development.  A current strategy for repeated similar runs includes cloning your workstation.  This solution involves an underlying workstation storage cost (cheaper than run times, but still cost inefficient).  Ideally, we would have workstation templates that require minimal additional configurations, avoiding this burden and associated storage cost.  Base workstations for cloning should be utilized short term and should only be stored if you're running repeated similar tasks at the same time.  All workstations (including the base) should be deleted when the task is completed.

### Running Code

In workstations, a key benefit is being able to start code running and walk away until it finishes. You do this by running your code in the Posit Workbench or R Background Jobs. This means you need to build your scripts in such a way that no user interaction is required (i.e. confirmations y/n or authentication). Any authentication or package installation should be done with you actively there, then you can run your totally independent code.

## Requesting a Google Data Bucket

Work through local IT to obtain a data bucket. Permissions to read and write to these data buckets can only be done through IT admin access. [Add instructions for each Center here?] Reference [Eli's documentation about servers vs objects](https://nmfs-opensci.github.io/EDMW-EarthData-Workshop-2025/content/why-cloud.html) for additional information on Google shared drive vs data buckets and speed.

Existing public NOAA data buckets can be found [here](https://www.noaa.gov/nodd/datasets#NMFS) for reference as to what these data buckets look like in the web interface. Instructions provided here are for use cases where the user has both read and write access to the data bucket being mounted, but mounting a public database should work similarly (sans write access).

## Linking Workstation to Bucket

Buckets need to be mounted each time a workstation is started and should persist across all sessions until the workstation is turned off. Mounting a bucket requires an active terminal (the tab next to the R console in RStudio and Positron). Copy and paste the [R/mount_bucket.R](https://github.com/nmfs-opensci/CloudComputingSetup/blob/main/R/mount_bucket.R) code directly in the terminal. [Please note that ctrl+v does not work for pasting into an R terminal; ctrl+shift+v or manually right click and select 'Paste'. ] The code is commented with instructions and can be pasted line by line or all at once.

The terminal will prompt you to authenticate your google account on [line 17](https://github.com/SEFSC/cloud_computing_SSMSE_starter/blob/0d3689835cd279d37bf01e47fe8b7ba8e426b485/mount_bucket.R#L17):

```{r}
gcloud auth application-default login --no-launch-browser
```

Follow the prompts to authenticate (including pasting the output from your browser directly into Terminal), then press enter or copy and paste the rest of the script in the R Terminal to continue the process. This is the most finicky and potentially user-specific step of the process. The remaining code will install or update `gcsfuse` on the workstation and mount the bucket. Once mounted a first time, lines 41-47 can be used to remount a bucket after a workstation is shutdown and skip the authentication/installation process.

*We'll need to change the bucket name to the public one that Eli plans to use for Openscapes/training purposes*

### Validating the Connection

From the code provided previously to mount a data bucket, we have named the bucket `my_gsc_bucket` and stick with this nomenclature throughout. If you are still working in the R Terminal, you can validate the connection using

`ls -l "$MOUNT_POINT"`

If you are working in a regular R Script or Console, you can check the contents of the bucket using

`list.files("~/my_gcs_bucket")`

Additionally, to view contents within subfolders, you can use

`list.files(path = "~/my_gcs_bucket/subfolder")`

Please note that within an RStudio cloud interface, the 'Files' GUI typically located in the lower right-hand corner may show an empty `$HOME/my_gsc_bucket` folder, but running the scripts above will verify if the data bucket has been successfully mounted.

### Reading from Buckets

Once the connection to the Data Bucket is made, you can run [R scripts](https://github.com/nmfs-opensci/CloudComputingSetup/blob/main/R/readwrite_databucket.R) as usual, pointing to the bucket location. For example,

`load('~/my_gcs_bucket/subfolder/sampdata1.RData')`

`data <- read.csv("~/my_gcs_bucket/subfolder/sampdata2.csv")`

both work to load an RData image and .csv file, respectively.

### Writing to Buckets

Writing to buckets works similarly. If the 'data' file above was cleaned on the Workstation and named 'data2' in R, this could be written directly to the workstation as 'sampdata2_clean.csv'.

`write.csv(data2,"~/my_gcs_bucket/subfolder/sampdata2_clean.csv")`

### Best Practices

Best Practices are still under development. Authors are considering options such as defining 'cloud' file paths and 'local' file paths for reading and writing data that are called at the top of the scripts, allowing for minimal edits between programs that are run in the cloud and locally. Alternatively, programs could be written exclusively for cloud computing platforms or local computing.

Suggested ways to set up workflows to easily move between running locally and in the cloud if desired?

## Alternative Options

If cloud computing resources are not necessary, alternative options include accessing data in the cloud with local computing resources. With Google Drive for Desktop, data on shared drives can be accessed using G:/ the same as we access shared drives on local computers. Alternatively, if cloud computing workstations have sufficient storage for the programs that you're running, it is not absolutely necessary to link to a data bucket. [Alternate ways to pull data down from the workstation if not a data bucket? Can these also just write to shared drives? Much slower--but wanting to provide options for different workflows].

## Acknowledgements

Resources shared by [Eli Holmes](https://github.com/eeholmes), [Jonathan Peake](https://github.com/jonpeake), Josh Lee, and Ed Rogers; authored by [Alex Norelli](https://github.com/norellia-NOAA) and [Molly Stevens](https://github.com/mollystevens-noaa).

### Disclaimer

This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project content is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.

### License

This content was created by U.S. Government employees as part of their official duties. This content is not subject to copyright in the United States (17 U.S.C. §105) and is in the public domain within the United States of America. Additionally, copyright is waived worldwide through the CC0 1.0 Universal public domain dedication.
