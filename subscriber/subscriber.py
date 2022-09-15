import ssl
import pika


class RMQClient:
    def __init__(self, usr, pwd, broker):
        ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
        ssl_context.set_ciphers('ECDHE+AESGCM:!ECDSA')
        url = f"amqps://{usr}:{pwd}@{broker}"
        parameters = pika.URLParameters(url)
        parameters.ssl_options = pika.SSLOptions(context=ssl_context)

        self.connection = pika.BlockingConnection(parameters)
        self.channel = self.connection.channel()


exchange = ''
routing_key = 'Headline Sentiment'
body = b'Testing'


class RMQSubscriber(RMQClient):
    def get_message(self, queue):
        method_frame, header_frame, body = self.channel.basic_get(queue)
        if method_frame:
            print(method_frame, header_frame, body)
            self.channel.basic_ack(method_frame.delivery_tag)
            return method_frame, header_frame, body
        else:
            print("No message.")

    def consume_messages(self, queue):
        def _callback(ch, method, properties, body):
            print(f"> Received : {body} ")
        self.channel.basic_consume(
            queue=queue, on_message_callback=_callback, auto_ack=True)
        self.channel.start_consuming()

    def close(self):
        self.channel.close()
        self.connection.close()


if __name__ == "__main__":
    # specify your RabbitMQ username, password and the broker URL
    my_subscriber = RMQSubscriber('', '', '')
    my_subscriber.consume_messages("Headline Sentiment")
    my_subscriber.close()
