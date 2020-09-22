### Run AOC Beta on AWS EC2 Linux

To run AOC on AWS EC2 Linux host, you can choose to install AOC RPM on your host by the following steps.

**Steps,**

1. Login on AWS Linux EC2 host and download aws-observability-collector RPM with the following command.
```
wget https://aws-observability-collector-release.s3.amazonaws.com/amazon_linux/amd64/v0.1.11/aws-observability-collector.rpm
```
2. Install aws-observability-collector RPM by the following command on the host
```
sudo rpm -Uvh  ./aws-observability-collector.rpm
```
3. Once RPM is installed, it will create AOC in directory /opt/aws/aws-observability-collector/

[Image: image.png]. 

4. We provided a control script to manage AOC. Customer can use it to Start, Stop and Check Status of AOC.

    * Start AOC with CTL script. The config.yaml is optional, if it is not provided the default config (https://github.com/mxiamxia/aws-observability-collector/blob/master/config.yaml) will be applied.  
    ```
        sudo /opt/aws/aws-observability-collector/bin/aws-observability-collector-ctl -c </path/config.yaml> -a start
    ```
    * Stop the running AOC when finish the testing.
    ```
        sudo /opt/aws/aws-observability-collector/bin/aws-observability-collector-ctl  -a stop
    ```
    * Check the status of AOC
    ```
        sudo /opt/aws/aws-observability-collector/bin/aws-observability-collector-ctl  -a status
    ```
      
5. Test the data with the running AOC on EC2. you can run the following command on EC2 host. (Docker app has to be pre-installed)
```
docker run --rm -it -e "OTEL_OTLP_ENDPOINT=172.17.0.1:55680" -e "otlp_instance_id=test_insance_rpm" -e "OTEL_RESOURCE_ATTRIBUTES=service.namespace=AOCRPMDemo,service.name=AOCRPMDemoService" -e S3_REGION=us-west-2 josephwy/integ-test-emitter:min
```

**View Your Metrics**  
You should now be able to view your metrics in your [CloudWatch console](https://console.aws.amazon.com/cloudwatch/). In the navigation bar, click on **Metrics**. The collected AOC metrics can be found in the **AOCRPMDemo/AOCRPMDemoService** namespace.

#### Installing AOC via CloudFormation
#### Install AOC on ECS EC2
Download CloudFormation template file for installing AOC on ECS EC2 mode
```
curl -O https://github.com/mxiamxia/aws-opentelemetry-collector/blob/master/deployment-template/ec2/aoc-ec2-deployment-cfn.template
```
Run CloudFormation the following command once ```IAMRole```, ```Region```, ```EC2Key``` and  ```CFN_File_Downloaded``` are filled.
```
Region=<aws-region>
IAMRole=<iam-role>
EC2Key=<ec2-ssh-key-name>
aws cloudformation create-stack --stack-name AOCEC2-Test \
	--template-body file://<CFN_File_Downloaded> \
	--parameters ParameterKey=IAMRole,ParameterValue=${IAMRole} \
                 ParameterKey=KeyName,ParameterValue=${EC2Key} \
    --capabilities CAPABILITY_NAMED_IAM \
    --region ${Region}
```