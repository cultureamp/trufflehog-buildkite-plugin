#!/usr/bin/env bats

load "$BATS_PLUGIN_PATH/load.bash"

# Uncomment the following line to debug stub failures
#export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty
@test "Trufflehog should find secrets" {
    export BUILDKITE_PLUGIN_TRUFFLEHOG_IMAGE_URI="liamstevensca/truffletest:latest"
    export BUILDKITE_PLUGIN_TRUFFLEHOG_TRUFFLEHOG_IMAGE_URI="trufflesecurity/trufflehog:latest"
    export sample_detection='{"SourceMetadata":{"Data":{"Docker":{"file":"image-metadata:history:16:created-by","image":"liamstevensca/truffletest","tag":"latest"}}},"SourceID":1,"SourceType":4,"SourceName":"trufflehog - docker","DetectorType":8,"DetectorName":"Github","DecoderName":"PLAIN","Verified":true,"Raw":"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","RawV2":"","Redacted":"","ExtraData":{"account_type":"User","expiry":"2024-09-03 09:50:09 +1000","location":"Australia","name":"Liam Stevens","rotation_guide":"https://howtorotate.com/docs/tutorials/github/","url":"https://github.com/liamstevens","username":"liamstevens","version":"2"},"StructuredData":null}'

    stub buildkite-agent \
    'annotate --style error * : echo "Got error annotation"' \
    'annotate --style success * : echo "Got success annotation"' \

    #unstub buildkite-agent

    stub docker \
        'pull * : echo $@'\
        'run --rm -it -v * $BUILDKITE_PLUGIN_TRUFFLEHOG_TRUFFLEHOG_IMAGE_URI docker --image=$BUILDKITE_PLUGIN_TRUFFLEHOG_IMAGE_URI * * : echo "$sample_detection"'


    run "$PWD/hooks/post-command"

    unstub docker

    assert_failure
    assert_output --partial "Got error annotation"

}
