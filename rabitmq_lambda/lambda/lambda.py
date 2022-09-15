import json
import ssl
import pika
import os
import re


def lambda_handler(event, context):
    if event['Records'][0]['eventName'] == "INSERT":

        image = {}
        image['id'] = event['Records'][0]['dynamodb']['Keys']['id']['S']
        image['score'] = event['Records'][0]['dynamodb']['NewImage']['score']['S']
        image['label'] = event['Records'][0]['dynamodb']['NewImage']['label']['S']
        image['headline'] = event['Records'][0]['dynamodb']['NewImage']['headline']['S']
        body = json.dumps(image)

        rabbitmq_user = os.environ['RABBITMQ_USERNAME']
        rabbitmq_password = os.environ['RABBITMQ_PASSWORD']
        rabbitmq_broker_arn = os.environ['RABBITMQ_ARN']
        rabbitmq_broker_id = re.search(
            r'(?<=myService:).*', rabbitmq_broker_arn).group(0)

        region = 'eu-central-1'
        url = ''
        queue_name = 'Headline Sentiment'
        routing_key = queue_name
        exchange = ''

        ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
        ssl_context.set_ciphers('ECDHE+AESGCM:!ECDSA')
        url = f"amqps://{rabbitmq_user}:{rabbitmq_password}@{rabbitmq_broker_id}.mq.{region}.amazonaws.com:5671"
        parameters = pika.URLParameters(url)
        parameters.ssl_options = pika.SSLOptions(context=ssl_context)

        connection = pika.BlockingConnection(parameters)
        channel = connection.channel()
        channel.queue_declare(queue=queue_name)
        channel.basic_publish(exchange=exchange,
                              routing_key=routing_key,
                              body=body)

        print(
            f"Sent message. Exchange: {exchange}, Routing Key: {routing_key}, Body: {body}")

        channel.close()
        connection.close()
    else:
        pass
