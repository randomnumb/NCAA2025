# Setup Script for March Machine Learning Mania 2025
# This script will:
# 1. Install and configure the Kaggle API
# 2. Download competition data
# 3. Set up project structure
# 4. Create initial script templates

# Install required packages if not already installed
required_packages <- c("devtools", "tidyverse", "caret", "rstudioapi")
new_packages <- required_packages[!required_packages %in% installed.packages()[,"Package"]]
if(length(new_packages) > 0) {
  install.packages(new_packages, repos = "https://cran.rstudio.com/")
}

# Install kaggler from GitHub if not already installed
if(!"kaggler" %in% installed.packages()[,"Package"]) {
  library(devtools)
  install_github("ldurazo/kaggler")
}

setwd("~/Documents/Kaggle/NCAA2025/")

# Create project directories
dirs <- c("data", "scripts", "models", "submissions")
sapply(dirs, function(dir) {
  if(!dir.exists(dir)) dir.create(dir, recursive = TRUE)
})

# Create README file
create_readme <- function() {
  readme_text <- "# March Machine Learning Mania 2025

This repository contains code for the [Kaggle March Machine Learning Mania 2025](https://www.kaggle.com/competitions/march-machine-learning-mania-2025/) competition.

## Project Structure

- `data/`: Competition data
- `scripts/`: R scripts for analysis and modeling
- `models/`: Saved model files
- `submissions/`: Prediction files for submission

## Setup

### 1. Install the Kaggle CLI

First, install the official Kaggle command-line interface:

```bash
pip install kaggle
```

### 2. Configure Kaggle API credentials:
- Download kaggle.json from your Kaggle account settings
- Place it in ~/.kaggle/kaggle.json
- Make sure the file permissions are set correctly:
  ```bash
  chmod 600 ~/.kaggle/kaggle.json
  ```
  
## Workflow

1. Download data using the Kaggle CLI
2. Run initial analysis: `scripts/initial_analysis.R`
3. Develop models (create your own scripts)
4. Generate predictions: `scripts/format_predictions.R`
5. Submit predictions using the Kaggle CLI:
   ```bash
   kaggle competitions submit -c march-machine-learning-mania-2025 -f submissions/your_submission.csv -m 'Your submission message'
   ```

## Git Workflow

This repository follows a standard Git workflow:

1. Create feature branches for new models or analyses
2. Commit changes regularly with descriptive messages
3. Push to remote repository for backup and collaboration
4. Create pull requests for significant changes

## Competition Details

This competition involves predicting the outcomes of the 2025 NCAA Men\'s Basketball Tournament. Performance is evaluated using log loss.

## License

See the Kaggle competition data license for usage restrictions.
"
  
  writeLines(readme_text, "README.md")
  cat("Created README.md file\n")
}

create_gitignore <- function() {
  gitignore_content <- '# R specific files
.Rproj.user
.Rhistory
.RData
.Ruserdata

# Data files (should be downloaded via Kaggle CLI)
/data/*.csv
/data/*.zip

# Model files (can be large)
/models/*.rds
/models/*.RData

# Submission files
/submissions/*.csv

# Environment variables and secrets
.env
.kaggle
kaggle.json

# OS specific files
.DS_Store
.Thumbs.db

# RStudio project file (create your own or add to Git later if needed)
*.Rproj
'
  
  writeLines(gitignore_content, ".gitignore")
  cat("Created .gitignore file\n")
}


# Initialize Git repository
init_git_repo <- function() {
  # Check if git is installed
  git_check <- try(system("git --version", intern = TRUE), silent = TRUE)
  
  if(inherits(git_check, "try-error")) {
    cat("Git does not appear to be installed or is not in the PATH.\n")
    cat("Please install Git and run the following commands manually:\n")
    cat("git init\n")
    cat("git add .\n")
    cat("git commit -m \"Initial project setup\"\n")
    return(FALSE)
  }
  
  # Initialize repository
  system("git init")
  
  # Configure user information if not already set
  user_name <- try(system("git config --get user.name", intern = TRUE), silent = TRUE)
  user_email <- try(system("git config --get user.email", intern = TRUE), silent = TRUE)
  
  if(inherits(user_name, "try-error") || length(user_name) == 0) {
    cat("\nGit user.name not configured. Please set it with:\n")
    cat("git config --global user.name \"Your Name\"\n")
  }
  
  if(inherits(user_email, "try-error") || length(user_email) == 0) {
    cat("\nGit user.email not configured. Please set it with:\n")
    cat("git config --global user.email \"your.email@example.com\"\n")
  }
  
  # Stage all files
  system("git add .")
  
  # Make initial commit
  system("git commit -m \"Initial project setup for March Machine Learning Mania 2025\"")
  
  cat("\nGit repository initialized with initial commit.\n")
  return(TRUE)
}

# Main execution
cat("Setting up project for March Machine Learning Mania 2025 with Git integration...\n\n")

# Create README and .gitignore
create_readme()
create_gitignore()

# Initialize Git repository
git_initialized <- init_git_repo()

# Final message
cat("\nSetup complete! Your project structure is ready and Git repository is initialized.\n")
cat("\nIMPORTANT: To download competition data and submit predictions, use the Kaggle CLI:\n")
cat("1. Install it with: pip install kaggle\n")
cat("2. Download data: kaggle competitions download -c march-machine-learning-mania-2025 -p data/\n")
cat("3. Submit predictions: kaggle competitions submit -c march-machine-learning-mania-2025 -f submissions/your_file.csv -m \"Your message\"\n\n")

if(!git_initialized) {
  cat("\nNOTE: You need to initialize the Git repository manually once Git is installed.\n")
}

cat("Next steps:\n")
cat("1. Create a remote repository (on GitHub/GitLab/etc.) and add it as a remote:\n")
cat("   git remote add origin https://github.com/yourusername/your-repo-name.git\n")
cat("2. Push the initial commit: git push -u origin main\n")
cat("3. Start your analysis and model development\n\n")
cat("Good luck in the competition!\n")
