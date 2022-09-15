import json
import base64
import boto3

runtime = boto3.client(service_name='sagemaker-runtime')
dynamodb = boto3.resource('dynamodb')
nlp_news_table = dynamodb.Table('nlp_news_headlines_table')


def lambda_handler(event, context):

    output = base64.b64decode(event['Records'][0]['kinesis']['data'])
    data = json.dumps({"inputs": str(output, 'utf-8')})
    data_dict = json.loads(data)
    response = runtime.invoke_endpoint(EndpointName="distilbert-endpoint",
                                       ContentType='application/json', Body=data)

    response_body = response['Body']
    response_str = response_body.read().decode('utf-8')
    response_str = response_str.replace('[', '').replace(']', '')
    response_dict = json.loads(response_str)

    response_dict['headline'] = data_dict['inputs']
    response_dict['id'] = context.aws_request_id
    response_dict['score'] = str(response_dict['score'])
    nlp_news_table.put_item(Item=response_dict)

    return {
        'statusCode': 200,
    }
