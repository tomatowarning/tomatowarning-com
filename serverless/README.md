# Setup

Install serverless & serverless-plugin-resource-tagging. 

# Configuration & Convention

## Organization
The ORG for *all* lambda in this repository is "tomatowarning". 

## App 
The APP for *most* lambda should be "tomatowarning-com", though you may have a use-case that differs.

## Service

The service name must be formatted as follows:

    ${opt:stage,"dev"}-$app-$serviceDescription

Prefixing in this manner will ensure that every service is uniquely named within an account.
Be aware that many of our stacks are similar if not identical, and we deploy all projects of a
given stage into a common AWS account for that stage. 

### Org/App/Service Example

    org: tomatowarning
    app: tomatowarning-com
    service: ${opt:stage, "dev"}-tomatowarning-com-mail-handler 

## Stack Name

**stackName** must be declared as part of the **provider** block, and must match the formatting of the service name. 

    provider:
        ...
        stackName: ${opt:stage, "dev"}-tomatowarning-com-mail-handler

## Stack Tags

**stackTags** must be declared as part of the **provider** block, and must contain (at least) the following:

    provider:
        stackTags:
            CostCenter: tomatowarning
            Environment: ${opt:stage,'dev'}
            Source: "(github url)"

The Github URL should lead a user directly to the folder which holds the service responsible for resource creation.
Linking directly to the **develop** branch is a best practice, as staging & main branches may not yet exist for a given service.

Depending on the project's needs, you may use additional stack tags.

## Stack Description

A **resources** block must be declared in your template, and must include the **Description** field. The Description
must be as follows:

    resources:
        ...
        Description: "Managed by Serverless Framework. See tags for Source URL." 
