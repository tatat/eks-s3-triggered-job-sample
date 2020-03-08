import os
import boto3


def main():
    s3 = boto3.client('s3')

    response = s3.get_object(
        Bucket=os.environ['BUCKET_NAME'],
        Key=os.environ['OBJECT_KEY']
    )

    print(response['Body'].read().decode('utf-8'))


if __name__ == '__main__':
    main()
