from deploy import wait_to_finish_deployment

def test_not_stabilized(desired_count_exceeds_running_count):
    assert not wait_to_finish_deployment(
        desired_count_exceeds_running_count,
        "Foo",
        "Bar",
        1
    )

def test_stabilized(running_count_equals_desired_count):
    assert wait_to_finish_deployment(
        running_count_equals_desired_count,
        "Foo",
        "Bar",
        1800 # timeout greater than or equal to sleep_seconds
    )
