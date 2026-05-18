# AWS MCP Rules

Always use the `aws` MCP server for AWS interactions. Never use boto3, the AWS CLI, or raw SDK calls - including inside scripts you write and execute on the user's behalf.

## Read-only access only

The `tk-ai-agent-readonly` role is read-only. If asked to create, update, or delete any AWS resource:
- Explain that write access is not available through this MCP.
- Recommend IaC (Terraform or Pulumi) for mutations to avoid infrastructure drift.

## Label all responses with the active environment

When presenting any AWS query results, prefix the response with:
> **AWS env:** `<active_aws_env>` (`tk-ai-agent` profile)

## Session management

Sessions last 1 hour. If a `call_aws` invocation returns a credentials or auth error, ask the user to run `tk ai aws-login --env <env>` to refresh.
