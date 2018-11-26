# Pipelines Templates

These pipelines and pipeline templates are meant to help you explore some of the capabilities of Spinnaker Pipelines.

You can read more about Pipeline Templates [**here**](https://github.com/spinnaker/dcd-spec/blob/master/PIPELINE_TEMPLATES.md).


## Getting Started

It is recommended you start with `generic/` before moving on to more advanced, provider specific templates located in the other directories (like `gcp/`).

Generally, you will have an SSH tunnel for connecting to Spinnaker and another terminal for using the tools instance. If you have performed the advanced (AKA dns/tls/oauth2) capstan configuration you would not need the tunnel. The directions do not assume the advanced configuration.

### GCP

In a *new* terminal connect to your `halyard-tunnel` instance:

```bash
$ gcloud compute --project "[PROJECT_NAME]" ssh --zone "[ZONE]" "[INSTANCE_NAME]"
```

Templates are published using [**roer**](https://github.com/spinnaker/roer). It should already be installed and configured on the instance.

```bash
$ roer pipeline-template publish ./path/to/template.yml
```

There are instructions for each template on how to create a template based pipeline in each template's respective directory.

When no using Roer, the future api tool called [**Spin**](https://github.com/spinnaker/spin) will be used


### AWS

TBD

## Further reading

* [Spinnaker Pipeline Template Spec](https://github.com/spinnaker/dcd-spec/blob/master/PIPELINE_TEMPLATES.md)
* [roer](https://github.com/spinnaker/roer) - Spinnaker Pipeline CLI
* [**Spin**](https://github.com/spinnaker/spin) - Future Spinnaker CLI
