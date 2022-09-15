from refinitiv.data.content import news
import refinitiv.data as rd
import boto3

# insert your aws access key and secret key in create_client request


def create_client(service, region):
    return boto3.client(service, region_name=region,  aws_access_key_id="",
                        aws_secret_access_key="")


def push_to_kinesis(kinesis_client, kinesis_stream_name, kinesis_shard_count, data, send_to_kinesis=True):
    encoded_data = bytes(data, 'utf-8')

    if send_to_kinesis:
        response = kinesis_client.put_record(Data=encoded_data, StreamName=kinesis_stream_name,
                                             PartitionKey=str(kinesis_shard_count))
        print(response)


if __name__ == "__main__":
    my_kinesis = create_client('kinesis', 'eu-central-1')
    rd.open_session("platform.rdp")
    response = news.headlines.Definition(query="Amazon", count=10).get_data()
    for headline in response.data.df['text']:
        push_to_kinesis(my_kinesis, "my-nlp-kinesis-en", 1, headline)
