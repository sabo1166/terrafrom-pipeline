# Terraform CI/CD for existing bucket `s3-treeaform-project-1`

## Design
- Bucket `s3-treeaform-project-1` (us-east-1) already exists. It is referenced through
  `data "aws_s3_bucket"` — read-only. Terraform creates, changes and deletes nothing.
- **Backend: local.** The bucket is not used for state. The CI runner is ephemeral, so
  local state is discarded after each run; that is only safe because no resources are managed.
- Pipeline: `Init -> Validate -> Plan -> Apply` (GitHub OIDC, role `sabo1166`).
  Apply runs only on push to the default branch, behind the `production` environment,
  using the `tfplan` artifact from the same run/commit. PRs never apply.

## Manual setup required
**GitHub:** Settings > Environments > `production` > required reviewers (and restrict to branch `main`).
Protect `main` (require PR + review).

**AWS:** role `sabo1166` needs an OIDC provider `token.actions.githubusercontent.com`
(audience `sts.amazonaws.com`) and a trust policy such as:
```json
{"Effect":"Allow","Principal":{"Federated":"arn:aws:iam::304935836562:oidc-provider/token.actions.githubusercontent.com"},
 "Action":"sts:AssumeRoleWithWebIdentity",
 "Condition":{"StringEquals":{"token.actions.githubusercontent.com:aud":"sts.amazonaws.com"},
  "StringLike":{"token.actions.githubusercontent.com:sub":[
   "repo:OWNER/REPO:ref:refs/heads/main","repo:OWNER/REPO:pull_request","repo:OWNER/REPO:environment:production"]}}}
```
Permissions needed now: `s3:GetBucketLocation`, `s3:ListBucket`, `s3:GetBucket*` on the bucket
(`s3:ListAllMyBuckets` is not required by the data source).

## Before ever managing the bucket (not done here)
Inspect first (needs working credentials):
```
aws s3api get-bucket-versioning --bucket s3-treeaform-project-1
aws s3api get-bucket-encryption --bucket s3-treeaform-project-1
aws s3api get-public-access-block --bucket s3-treeaform-project-1
aws s3api get-bucket-ownership-controls --bucket s3-treeaform-project-1
```
Then (1) move to a **separate** remote-state bucket (S3 + `use_lockfile`), migrate with
`terraform init -migrate-state`; (2) write `aws_s3_bucket*` resources matching the observed
settings; (3) `terraform import` locally, and confirm `terraform plan` shows no changes
before adding to CI. Never `terraform destroy`; add `lifecycle { prevent_destroy = true }`.
