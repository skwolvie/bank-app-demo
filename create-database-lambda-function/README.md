# Lambda Function Directory

## Overview

This directory is dedicated to storing the source code, dependencies, and packaged `.zip` file for a specific AWS Lambda function. The contents of this directory are essential for the development, deployment, and maintenance of the Lambda function within our infrastructure.

## Structure

- `db-function/`: Contains the Python source code (`*.py` files) for the Lambda function along with any additional scripts or modules required for its operation.
- `requirements.txt`: Lists all Python dependencies needed by the Lambda function to ensure consistent environments across development, testing, and production. Use this file to install dependencies via `pip`.
- `db-function.zip`: A packaged archive of the Lambda function's source code and dependencies, ready for deployment to AWS Lambda. This file is generated from the contents of the `db-function/` directory and the dependencies listed in `requirements.txt`.

## Usage

The function is deployed to AWS Lambda as a `.zip` file containing the source code and dependencies. The process is fully automated and handled by Terraform. However, developers may need to update the function's code, dependencies, or configuration during development or maintenance.

### Developing and Updating the Lambda Function

1. **Source Code**: All development work should be done within the `db-function/` directory. This includes writing, modifying, and testing the Python code.
2. **Dependencies**: If the Lambda function requires additional Python packages, add them to the `requirements.txt` file. Use the following command to install these dependencies locally:

`pip install -r requirements.txt`

3. **Testing**: Before deploying your changes, ensure thorough testing of the function in a staging environment.

### Packaging for Deployment

After making changes and testing your function, you must package your function and its dependencies into a `.zip` file for deployment:

1. Install the dependencies in a target directory (e.g., `db-function/`) to ensure they are included in the `.zip` file.
2. Use a packaging tool or a simple zip command to create `function.zip` from the contents of the `db-function/` directory.
3. Place the generated `db-function.zip` file in the root of this directory.

## Note

This directory is under version control to ensure traceability, collaboration, and continuous integration. The `db-function.zip` file should be regenerated and replaced each time changes are made to the Lambda function's code or dependencies to keep the deployment package up-to-date.
