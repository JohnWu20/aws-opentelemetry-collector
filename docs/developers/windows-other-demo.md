### Run AOC on Debian and Windows hosts,

### Run AOC on AWS Windows Ec2 Host

To run AOC on AWS windows ec2 host, you can choose to install AOC MSI on your host by the following steps.

**Steps,**
1. Login on AWS Windows EC2 host and download aws-observability-collector MSI with the following command.
```
wget https://aws-opentelemetry-collector-release.s3.amazonaws.com/windows/amd64/latest/aws-opentelemetry-collector.msi
or you can download by directly pasting the link https://aws-opentelemetry-collector-test.s3.amazonaws.com/windows/amd64/latest/aws-opentelemetry-collector.msi in windows browser 
```
2. Install aws-observability-collector MSI by running the following command on the host
```
msiexec /i aws-opentelemetry-collector.msi
or can be installed by double clicking the windows msi file.
```
`While Installing the AOC it will show a popup mentioning that the software is not from verified publisher, this is because we have not signed the MSI one it is signed this popup will be gone`

3. Once MSI is installed, it will create AOC in directory C:\Program Files\Amazon\AwsOpentelemetryCollector

4. We provided a control script to manage AOC. Customer can use it to Start, Stop and Check Status of AOC.
    * Start AOC with CTL script. The config.yaml is optional, if it is not provided the default config (https://github.com/mxiamxia/aws-opentelemetry-collector/blob/master/config.yaml) will be applied.
    ```
      & '.\Program Files\Amazon\AwsOpentelemetryCollector\aws-opentelemetry-collector-ctl.ps1' -a start 
    ```
    * Stop the running AOC when finish the testing.
    ```
      & '.\Program Files\Amazon\AwsOpentelemetryCollector\aws-opentelemetry-collector-ctl.ps1' -a stop 

    ```
    * Check the status of AOC
    ```
      & '.\Program Files\Amazon\AwsOpentelemetryCollector\aws-opentelemetry-collector-ctl.ps1' -a status 
    ```
