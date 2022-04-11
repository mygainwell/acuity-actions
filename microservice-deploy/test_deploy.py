from deploy import wait_to_finish_deployment, create_new_task_definition 

def test_not_stabilized(desired_count_exceeds_running_count):
    assert not wait_to_finish_deployment(
        desired_count_exceeds_running_count,
        "Foo",
        "Bar",
        9
    )

def test_stabilized(running_count_equals_desired_count):
    assert wait_to_finish_deployment(
        running_count_equals_desired_count,
        "Foo",
        "Bar",
        1800 # timeout greater than or equal to sleep_seconds
    )

def test_dockerVolumeConfiguration():
    pass

def test_efsVolumeConfiguration(ecs_client,current_definition):
    """
    GIVEN fileSystemId input of "bar"
    AND rootDirectory input of "baz"
    WHEN we create_new_task_definition
    THEN the taskDefinition will have volumes
    AND the volumes will have efsVolumeConfiguration
    AND the efsVolumeConfiguration will have fileSystemId equal to "bar"
    AND the efsVolumeConfiguration will have rootDirectory equal to "baz" 
    """
    assert create_new_task_definition(ecs_client,current_definition, "Any")

def test_ebs_get_snapshot_block(ebs_volume_mount):
    pass

#optional
def test_fsxWindowsFileServerVolumeConfiguration():
    pass