import argparse
import time

import boto3


def current_task_definition(client, cluster, service):
    current_task_arn = client.describe_services(cluster=cluster, services=[service])[
        "services"
    ][0]["taskDefinition"]

    return client.describe_task_definition(taskDefinition=current_task_arn)[
        "taskDefinition"
    ]


def create_new_task_definition(client, current_definition, new_image):
    container_definition = current_definition["containerDefinitions"][0].copy()
    container_definition["image"] = new_image


    return client.register_task_definition(
        family=current_definition["family"],
        volumes=current_definition["volumes"],
        containerDefinitions=[container_definition],
    )["taskDefinition"]["taskDefinitionArn"]

def handle_volumes_configuration():
    pass

def update_service(client, cluster, service, task_arn):
    client.update_service(
        cluster=cluster,
        service=service,
        taskDefinition=task_arn,
    )


def wait_to_finish_deployment(client, cluster, service, timeout):
    sleep_seconds = 10
    timeout = int(timeout / sleep_seconds)
    cnt = 0
    deployment_finished = False

    while cnt < timeout:
        response = client.describe_services(cluster=cluster, services=[service])
        print(response)
        deployment = next(
            depl
            for depl in response["services"][0]["deployments"]
            if depl["status"] == "PRIMARY"
        )
        if deployment["runningCount"] == deployment["desiredCount"]:
            deployment_finished = True
            break
        print(
            f"Waiting ... Running count: {deployment['runningCount']}; "
            f"Desired count: {deployment['desiredCount']}"
        )
        time.sleep(sleep_seconds)

    return deployment_finished


if __name__ == "__main__":

    DEPLOYMENT_TIMEOUT = 1800  # seconds

    parser = argparse.ArgumentParser()
    parser.add_argument("--cluster_name", help="Name of ECS cluster")
    parser.add_argument("--service_name", help="Service name")
    parser.add_argument("--new_image_uri", help="URI of new Docker image")

    args = parser.parse_args()
    cluster_name = args.cluster_name
    service_name = args.service_name
    new_image_uri = args.new_image_uri

    ecs_client = boto3.client("ecs")
    ebs_client = boto3.client("ebs")

    task_definition = current_task_definition(
        ecs_client, cluster=cluster_name, service=service_name
    )
    new_task_arn = create_new_task_definition(
        ecs_client, task_definition, new_image_uri
    )

    update_service(
        ecs_client,
        cluster=cluster_name,
        service=service_name,
        task_arn=new_task_arn,
    )
    finished = wait_to_finish_deployment(
        ecs_client,
        cluster=cluster_name,
        service=service_name,
        timeout=DEPLOYMENT_TIMEOUT,
    )

    if not finished:
        print("Did not stabilize ...")
        exit(1)