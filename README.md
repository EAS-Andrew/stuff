# Design Document: Zeus Approvers Process

### Introduction:
Zeus is a controlled build and deploy platform that requires approvals for certain elements such as changes to the configuration repository and deployment repositories. This design document outlines the process and workflow for the Zeus approvers.

### Configuration Repository Approval Process:
#### Change Proposal:

Engineers belonging to the specific project or AL id will propose changes to the configuration repository through a pull request.
The proposed changes will trigger the approval process.
##### Approvers:

Approvers for configuration repository changes are defined in the CODEOWNERS file, mapped to the relevant AL directory.
The CODEOWNERS file should contain a list of senior engineers who will review the changes.
The list of approvers will be managed self-service through the onboarding repository.

#### Initial Approver:

During the initial onboarding, a single approver will be captured. The process for determining this initial approver is yet to be defined.
The trigger point for the initial onboarding can be either ServiceNOW or GitHub, depending on the specific implementation.

#### Review and Checks:

Approvers will review the proposed changes and provide their approval.
After the review, a series of automated checks, including static configuration validation and namespace requirement checks, will run.
If any of the checks fail, the pull request will be blocked until the issues are resolved.


### Deployment Repository Approval Process:
#### Approval Levels:
Deployment repository changes have different approval requirements based on the target environment.
For Development and Testing environments, a more relaxed approval process is followed.
Production environment changes require additional validation and approvals.

#### Development and Testing Environment Approvals:

Approvals for Development and Testing environments are handled through the CODEOWNERS file.
The CODEOWNERS file will contain a list of approvers, defined as a GitHub team, mapped to the relevant AL directory.
Proposed changes require approval from the listed approvers before being deployed to the Development or Testing environment.

#### Production Environment Approvals:

Changes intended for the Production environment require a change request to be raised.
The actors described in ServiceNOW, associated with the AL id, will serve as the approvers for Production environment changes.
The approval process will follow the guidelines and procedures set in ServiceNOW for the specific AL id.

### Conclusion:
The Zeus approvers process ensures that changes to the configuration repository and deployment repositories go through a controlled approval workflow. The process involves code reviews, defined approvers, and automated checks to maintain the integrity and stability of the build and deploy platform. The specific implementation details, such as initial approver determination and integration with ServiceNOW, will need to be further defined based on the requirements and needs of the organization.
