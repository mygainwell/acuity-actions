from ast import Str
import re
import pytest

import botocore.session
from botocore.stub import Stubber, ANY

@pytest.fixture
def ecs_client(*args):
    ecs_client = botocore.session.get_session().create_client('ecs', 'us-east-1')
    return ecs_client




@pytest.fixture
def current_definition():
    return {
        "containerDefinitions": [
            {
                "task_definition":task_definition
                    
                
            }
        ]
    }

@pytest.fixture
def describe_services():
    return {
         "services":[
             {
                 "taskDefinition":{}
             }
         ]
    }

@pytest.fixture
def current_task_definition(ecs_client):
    with Stubber(ecs_client) as stubbed_ecs_client:
        stubbed_ecs_client.add_response(
            'describe_services',
            describe_services(),
            {"cluster": ANY, "services": ANY}
        )
        response = current_definition()
        expected_params = {"taskDefinition": ANY}
        stubbed_ecs_client.add_response('describe_task_definition', response, expected_params)
        yield ecs_client


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


@pytest.fixture
def ebs_client(*args):
    ebs_client = botocore.session.get_session().create_client('ebs', 'us-east-1')
    return ebs_client

@pytest.fixture
def ebs_volume_mount(ebs_client):
    with Stubber(ebs_client) as stubbed_ebs_client:
        response = get_snapshot_block_response('string',123,'string')
        expected_params = {"SnapshotId": ANY, "BlockIndex": ANY, "BlockToken": ANY}
        stubbed_ebs_client.add_response('get_snapshot_block', response, expected_params)
        yield ebs_client

def get_snapshot_block_response(SnapshotId:str,BlockIndex:int, BlockToken:str):
    return {
       
    }






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