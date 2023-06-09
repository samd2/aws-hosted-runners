
# AWS Hosted Runners

`aws-hosted-runners` is a GitHub Action than provides an output `labelmatrix` which can be used to configure the `runs-on` information in a workflow.

If self-hosted runners have been enabled, it will set the labels to `[ self-hosted, linux, x64, ubuntu-22.04-aws ]` or a similar value.  

If self-hosted runners are disabled, the existing label such as `ubuntu-22.04` will be kept.  

## Instructions

See https://github.com/cppalliance/githubactions for instructions.  

This is implementation is primarily aimed at boost.org and cppalliance.org users. However, others are welcome to clone the repository and set up their own infrastructure.  

