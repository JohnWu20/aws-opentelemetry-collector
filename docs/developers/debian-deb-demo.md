### Run AOC Beta on AWS EC2 Debian(ubuntu)

To run AOC on AWS EC2 debian host, you can choose to install AOC Debian on your host by the following steps.

**Steps,**

1. Login on AWS Debian host and download aws-observability-collector DEB with the following command.
```
wget https://aws-observability-collector-test.s3.amazonaws.com/debian/amd64/latest/aws-observability-collector.deb
```
2. Install aws-observability-collector DEB by the following command on the host
```
sudo dpkg -i -E ./aws-observability-collector.deb
```
3. Once DEB is installed, it will create AOC in directory /opt/aws/aws-observability-collector/

4. We provided a control script to manage AOC. Customer can use it to Start, Stop and Check Status of AOC.

    * Start AOC with CTL script. The config.yaml is optional, if it is not provided the default [config](../../config.yaml) will be applied.  
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
docker run --rm -it -e "otlp_endpoint=172.17.0.1:55680" -e "otlp_instance_id=test_insance" mxiamxia/aoc-metric-generator:latest
```
