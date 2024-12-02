## MockupServer for Database testing with Scenario

MockupServer is the C# console application which helps developer test Database with custom workload and scenario.
I hope you can modify this with your queries and scenarios easily.

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

## Environment
There's AWS CloudFormation template file(cloudformation-template.yaml) whice describe test environment.
There are:
* SQL Server and MySQL(+Aurora) - schema description: mssql_script_mockdb.sql, mysql_script_mockdb.sql
* S3 bucket which contain application binaries - application is built from this project
* AWS Lambda Functions - report result & truncate database after test - No function body
* EC2 instances with CloudWatch & Systems Manager Agents
* Step Function which runs test application and Lambda functions

<img src="MockupDBServer test diagram.jpg" width="600" />