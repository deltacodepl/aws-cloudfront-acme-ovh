from turtle import rt
from diagrams import Cluster, Diagram, Edge
from diagrams.aws.database import Dynamodb
from diagrams.aws.network import Route53, CloudFront
from diagrams.aws.security import IAM, CertificateManager
from diagrams.aws.storage import S3
from diagrams.aws.engagement import SES
from diagrams.aws.mobile import APIGateway
from diagrams.generic.device import Tablet
from diagrams.aws.compute import Lambda, LambdaFunction


attributes = {"pad": "1.0", "fontsize": "20"}
with Diagram(
    "", show=True, outformat="png", graph_attr=attributes
):  

    with Cluster("Website") as website:
        route53 = Route53("Route 53")
        cloudfront = CloudFront("Cloudfront")
        iam = IAM("IAM Role")
        s3 = S3("s3")
        cert = CertificateManager("ACME OVH")

    with Cluster("SES Email Service", direction="TB") as email_service:
        # tablet = Tablet("HTML Contact Form")
        api = APIGateway("Http API GW")
        iam_ses = IAM("IAM Role")
        send_email = LambdaFunction("Lambda function")
        ses = SES("SES")


    route53 >> cloudfront >> iam >> s3
    cloudfront << cert
    s3 >> api
    api >> iam_ses >> send_email >> ses


    
