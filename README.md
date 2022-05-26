# GitHub Action for s3cmd sync

This action uses [s3cmd](https://s3tools.org) to sync a directory with a remote S3 bucket.

This is a fork of [jakejarvis/s3-sync-action](https://github.com/jakejarvis/s3-sync-action)
[changes](#changes)


## Usage

### `workflow.yml` Example

Place in a `.yml` file such as this one in your `.github/workflows` folder. [Refer to the documentation on workflow YAML syntax here.](https://help.github.com/en/articles/workflow-syntax-for-github-actions)

#### The following example includes optimal defaults for a public static website:

- `--acl public-read` makes your files publicly readable (make sure your [bucket settings are also set to public](https://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteAccessPermissionsReqd.html)).
- `--follow-symlinks` won't hurt and fixes some weird symbolic link problems that may come up.
- Most importantly, `--delete` **permanently deletes** files in the S3 bucket that are **not** present in the latest version of your repository/build.
- **Optional tip:** If you're uploading the root of your repository, adding `--exclude '.git/*'` prevents your `.git` folder from syncing, which would expose your source code history if your project is closed-source. (To exclude more than one pattern, you must have one `--exclude` flag per exclusion. The single quotes are also important!)

```yaml
name: Upload Website

on:
  push:
    branches:
    - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: mchangrh/s3-sync-action@v1
      with:
        args: --acl public-read --follow-symlinks --delete
      env:
        AWS_S3_BUCKET: ${{ secrets.AWS_S3_BUCKET }}
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        AWS_REGION: 'us-west-1'   # optional: defaults to us-east-1
        SOURCE_DIR: 'public'      # optional: defaults to entire repository
```


### Configuration
| Key | Value | Required | Default |
| ------------- | ------------- | ------------- | ------------- |
| `S3_ACCESS_KEY_ID` | S3 Access Key. [More info here.](https://docs.aws.amazon.com/AmazonS3/latest/userguide/MakingRequests.html#TypesofSecurityCredentials) | **Yes** | N/A |
| `S3_ACCESS_KEY_SECRET` | S3 Secret Access Key. [More info here.](https://docs.aws.amazon.com/AmazonS3/latest/userguide/MakingRequests.html#TypesofSecurityCredentials) | **Yes** | N/A |
| `S3_BUCKET` | The name of the bucket you're syncing to. For example, `jarv.is` or `my-app-releases`. |**Yes** | N/A |
| `S3_REGION` | The region where you created your bucket. Set to `us-east-1` by default. [Full list of regions here.](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) | No | `us-east-1` |
| `S3_ENDPOINT` | The endpoint URL of the bucket you're syncing to. Can be used for [VPC scenarios](https://aws.amazon.com/blogs/aws/new-vpc-endpoint-for-amazon-s3/) or for non-AWS services using the S3 API, like [DigitalOcean Spaces](https://www.digitalocean.com/community/tools/adapting-an-existing-aws-s3-application-to-digitalocean-spaces). | No | Automatic (`s3.amazonaws.com` or AWS's region-specific equivalent) |
| `SOURCE_DIR` | The local directory (or file) you wish to sync/upload to S3. For example, `public`. Defaults to your entire repository. | No | `./` (root of cloned repository) |
| `DEST_DIR` | The directory inside of the S3 bucket you wish to sync/upload to. For example, `my_project/assets`. Defaults to the root of the bucket. | No | `/` (root of bucket) |


## License

This project is distributed under the [MIT license](LICENSE.md).

## Changes
- switch to alpine edge
- use s3cmd instead of awscli
- remove unnecessary LABELs and layers
- standardize all environment variables to be prefixed with S3 instead of AWS or AWS_S3
- remove GHA branding
- update links to fork