# March Machine Learning Mania 2025

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

This competition involves predicting the outcomes of the 2025 NCAA Men's Basketball Tournament. Performance is evaluated using log loss.

## License

See the Kaggle competition data license for usage restrictions.

