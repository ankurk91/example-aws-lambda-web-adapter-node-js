# AWS Lambda Web Adapter (LWA) example (node.js)

This project demonstrate the usage of [AWS Lambda Web Adaptor](https://github.com/awslabs/aws-lambda-web-adapter)
to run a node.js api.

### Deployment

* Create a new ECR
* Build and push the Docker image
* Create a new Lambda function
    * Choose `Container image` and use the ECR image URI you pushed above
    * Enable Lambda function URL to test out the REST api
        - Choose `Auth type` to `NONE`
        - Choose `Invoke mode` to `RESPONSE_STREAM`
        - Set this environment variable: Name `AWS_LWA_INVOKE_MODE`, value `response_stream`
        - Enable CORS

* Additionally, you can leverage the [crypteia](https://github.com/rails-lambda/crypteia) lambda extension to autoload
  environment variables from SSM parameter store

### Ref links

* https://www.youtube.com/watch?v=0nXfWIY2PhA
