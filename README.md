# SaaS Tech Academy Assignments

Welcome to my repository for coding and technical assignments for the SaaS Tech Academy. This repository contains all my solutions and project files across different frameworks and technologies (Apache OFBiz, Moqui, SQL, etc.).

## Repository Structure

- `relationshipmgr/` - Apache OFBiz plugin/component for managing party relationships.
*(More assignments will be added here...)*

## Setup and Usage

Since this repository contains various types of assignments, the setup instructions depend on the specific project folder. 

### 1. Apache OFBiz Plugins (e.g., `relationshipmgr`)

To run an OFBiz plugin assignment in your local environment, follow these steps:

1. **Clone this repository** to your local machine.
2. **Copy the plugin folder** (e.g., `relationshipmgr`) from this repository.
3. **Paste the folder** into the `plugins/` directory of your Apache OFBiz installation.
4. **Load the plugin and its data** by running the following Gradle command from the root of your OFBiz installation:
   ```bash
   ./gradlew cleanAll loadAll
   ```
5. **Start OFBiz**:
   ```bash
   ./gradlew ofbiz
   ```


## Author

- Akshansh Sharma
