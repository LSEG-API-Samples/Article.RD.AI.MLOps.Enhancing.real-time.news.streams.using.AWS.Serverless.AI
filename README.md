# Enhancing real-time news streams using AWS Serverless AI. An automated MLOps architecture using Terraform.


## <a id="overview"></a>Overview
Refinitiv Data (RD) libraries provide a powerful set of interfaces for uniform access to the Refinitiv data universe. The library provides multiple layers of abstraction providing for different styles and programming techniques suitable for all developers, from low latency real time access to batch ingestions.

In this article we present an AWS architecture that ingests our news feeds using RD libraries and enhances them using AI inference. In an effort to design a modular architecture, that could be used in most use cases, we decided to focus on the real-time space. The reason for this decision is that this is one of the most demanding use-cases and that the same architecture can also be used, with minimal tweaks, for batch AI inference. In our use case, we will implement a prototype that ingests our real-time news feed, calculates sentiment on each news headline using Artificial Intelligence and re-serves the AI enhanced feed through a publisher – subscriber architecture. 

Moreover, to present a full MLOps stack we introduce the concept of Infrastructure as Code during the entire MLOps lifecycle of the prototype. By using Terraform and a single entry point configurable script, we can instantiate the entire infrastructure, in-production mode, on AWS in just a few minutes. 

## <a id="disclaimer"></a>Disclaimer
The source code presented in this project has been written by Refinitiv only for the purpose of illustrating the concepts of creating example scenarios using the Refinitiv Data Library for Python.

***Note:** To [ask questions](https://community.developers.refinitiv.com/index.html) and benefit from the learning material, I recommend you to register on the [Refinitiv Developer Community](https://developers.refinitiv.com)*

## <a name="prerequisites"></a>Prerequisites

To execute any workbook, refer to the following:

- A Refinitiv Data Libraries license that has API access 
- Tested with Python 3.7 and 3.9
- Packages: [terraform](https://pypi.org/project/pandas/), [aws](https://aws.amazon.com/sdk-for-python/), [refinitiv.data](https://pypi.org/project/refinitiv-data/)
- RD Library for Python installation:  '**pip install refinitiv-data**'


  
## <a id="authors"></a>Authors
* **Marios Skevofylakas, Jason Ramchandani, Haykaz Aramyan**
