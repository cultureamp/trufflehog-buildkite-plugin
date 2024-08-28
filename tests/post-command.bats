#!/usr/bin/env bats

load "$BATS_PLUGIN_PATH/load.bash"

@test "Scans for leaked secrets" {
    export BUILDKITE_PLUGIN_TRUFFLEHOG_IMAGE_URI="liamstevensca/truffletest:latest"

    stub buildkite-agent 'annotate "Found a secret" : echo Annotation created'

    run "$PWD/hooks/post-command"

    assert_success
    assert_output --partial "Found a secret"
    assert_output --partial "Annotation created"

    unstub buildkite-agent
}
