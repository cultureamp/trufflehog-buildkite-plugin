# TruffleHog Buildkite Plugin

This plugin attempts to find secrets within the image using TruffleHog and annotates the build with either a list of files containing secrets or a confirmation that no secrets were found.

## Example

Add the following to your `pipeline.yml`:

```yml
steps: 
  - plugins:
      - cultureamp/trufflehog#v1.0.0:
          trufflehog-image-uri: 'trufflesecurity/trufflehog:latest'
          image-uri: '123456789012.dkr.ecr.us-east-1.amazonaws.com/my-image:latest'
```

## Configuration

### `trufflehog_uri` (required, string)

The Docker URI for the TruffleHog image. 

### `image_uri` (required, string)

The URI of the image to scan for secrets.

## Developing

To run the tests:

```shell
docker-compose run --rm tests
```

## Contributing

1. Fork the repository
2. Make the changes
3. Run the tests
4. Commit and push the changes
5. Create a pull request

