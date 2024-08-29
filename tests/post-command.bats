#!/usr/bin/env bats

load "$BATS_PLUGIN_PATH/load.bash"
load helpers/mocks/stub

@test "Scans for leaked secrets" {
    export BUILDKITE_PLUGIN_TRUFFLEHOG_IMAGE_URI="liamstevensca/truffletest:latest"
    export BUILDKITE_PLUGIN_TRUFFLEHOG_TRUFFLEHOG_URI="trufflesecurity/trufflehog:latest"

    #stub buildkite-agent 'annotate "Found a secret" : echo Annotation created'

    #unstub buildkite-agent

    stub docker \
        'pull * : echo $@'\
        'run * : echo {}'\
        'run * : echo {"SourceMetadata":{"Data":{"Docker":{"file":"image-metadata:history:16:created-by","image":"liamstevensca/truffletest","tag":"latest"}}},"SourceID":1,"SourceType":4,"SourceName":"trufflehog - docker","DetectorType":8,"DetectorName":"Github","DecoderName":"PLAIN","Verified":true,"Raw":"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","RawV2":"","Redacted":"","ExtraData":{"account_type":"User","expiry":"2024-09-03 09:50:09 +1000","location":"Australia","name":"Liam Stevens","rotation_guide":"https://howtorotate.com/docs/tutorials/github/","url":"https://github.com/liamstevens","username":"liamstevens","version":"2"},"StructuredData":null}'




    run "$PWD/hooks/post-command"

    unstub docker

    assert_success
    assert_output --partial "Found a secret"
    assert_output --partial "Annotation created"

}
