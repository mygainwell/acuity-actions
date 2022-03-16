import pytest

import botocore.session
from botocore.stub import Stubber, ANY

@pytest.fixture
def ecs_client(*args):
    ecs_client = botocore.session.get_session().create_client('ecs')
    return ecs_client

@pytest.fixture
def desired_count_exceeds_running_count(ecs_client):
    with Stubber(ecs_client) as stubbed_ecs_client:
        response = describe_services_response(1,2)
        expected_params = {"cluster": ANY, "services": ANY}
        stubbed_ecs_client.add_response('describe_services', response, expected_params)
        yield ecs_client

@pytest.fixture
def running_count_equals_desired_count(ecs_client):
    with Stubber(ecs_client) as stubbed_ecs_client:
        response = describe_services_response(1,1)
        expected_params = {"cluster": ANY, "services": ANY}
        stubbed_ecs_client.add_response('describe_services', response, expected_params)
        yield ecs_client

def describe_services_response(runningCount, desiredCount):
    return {
        "services": [
            {
                "deployments": [
                    {
                        "status": "PRIMARY",
                        "runningCount": runningCount,
                        "desiredCount": desiredCount
                    }
                ]
            }
        ]
    }