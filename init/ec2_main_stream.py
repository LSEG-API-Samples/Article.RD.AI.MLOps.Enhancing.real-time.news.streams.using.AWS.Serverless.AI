import asyncio
import boto3
import refinitiv.data as rd
from refinitiv.data.content import pricing
rd.open_session("platform.rdp")
loop = asyncio.get_event_loop()


class NewsStream:

    COUNTER = 0
    headlines = []

    def __init__(self, counter_limit=10):
        self.my_kinesis = self.create_client('kinesis', 'eu-central-1')
        self.counter_limit = counter_limit

    async def display_updated_fields_async(self, pricing_stream, instrument_name, fields):
        if self.is_headline_eng(fields) and self.is_headline(fields):
            self.push_to_kinesis(self.my_kinesis, "my-nlp-kinesis-en",
                                 1, self.get_headline(fields))
            self.COUNTER += 1
        if self.COUNTER > self.counter_limit:
            stream.close()
            loop.stop()

    def get_headline(self, fields):
        return list(fields.values())[0]['HEADLINE1']

    def is_headline_eng(self, fields):
        return list(fields.values())[0]['HEAD_LANG'] == 'en'

    def is_headline(self, fields):
        return list(fields.values())[0]['HEADLINE1'] != None

    def push_to_kinesis(self, kinesis_client, kinesis_stream_name, kinesis_shard_count, data, send_to_kinesis=True):
        encoded_data = bytes(data, 'utf-8')
        if send_to_kinesis:
            response = kinesis_client.put_record(Data=encoded_data, StreamName=kinesis_stream_name,
                                                 PartitionKey=str(kinesis_shard_count))
            print(response)

    # insert your aws access key and secret key in create_client request

    def create_client(self, service, region):
        return boto3.client(service, region_name=region,  aws_access_key_id="",
                            aws_secret_access_key="")

    def display_updated_fields(self, pricing_stream, instrument_name, fields):
        asyncio.run_coroutine_threadsafe(self.display_updated_fields_async(
            pricing_stream, instrument_name, fields), loop)

    def __del__(self):
        if stream.open_state.value == 'Opened':
            stream.close()
        if loop.is_running():
            loop.stop()
        print('Destructor called, Stream closed.')


if __name__ == "__main__":
    my_news_stream = NewsStream()
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    stream = rd.content.pricing.Definition(
        universe=['NFCP_UBMS'], service="ERT_FD3_LF1").get_stream()
    stream.on_update(my_news_stream.validate_headlines_and_push_to_kinesis)
    stream.open()
    loop.run_forever()
