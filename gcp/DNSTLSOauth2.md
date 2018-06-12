# TLS all the things

This describes how to make your spinnaker accessible without and SSH tunnel. Luckily, this configuration is an option that you enable with minimal configuration on your part. However, this should consider an advanced configuration. 

In this readme you will learn:
1. How to configure Oauth2 
2. How to configure TLS terminated spinnaker
3. What DNS steps you can have automated or manually configured

**Why?** Because we are all adults and we know that Token authentication, proper domain names, and TLS endpoints are the right things todo.

In this document:
- $DOMAIN is used to represent the domainname like `example.com`
- $IP is used to represent a IP address

## TL;DR

If you are using Google Cloud DNS in your project and GSuite you need to:
1. Generate (or obtain with letencrypt) private key and certificate
2. Create a Managed Zone with a valid domain for Cloud DNS
3. Create Oauth credentials (client ID/secret  )
4. capture all those values
5. update terraform
6. `terraform apply`


## Let's Begin
### DNS configuration with Google Cloud DNS

The automated approach assumes you are using [Google Cloud DNS](https://cloud.google.com/dns/) in the same project.

1. Create a [Managed Zone](https://cloud.google.com/dns/quickstart)
2. Record the zone name
3. Update the following terraform attributes in `variables.tf`:
   1. `gcp_dns_zonename` with With the zone name
   2. `ux_fqdn` with the full domain name for spinnaker user experience like spinnaker.$DOMAIN, do not add protocal (AKA http or https)
   3. `api_fqdn` with the full domain name for Spinnaker API  like spinnaker-api.$DOMAIN, do not add protocal (AKA http or https)


DONE


#### Oh, but I am not using Google Cloud DNS

Have no fear, as capstan builds the environment with DNS enabled it will output the $IP address of the L7 LoadBalancer that performs host path management to the right Spinnaker subsystem. 

You will then need to update terraform attributes in `variables.tf`
1. `ux_fqdn` with the full domain name for spinnaker user experience like spinnaker.$DOMAIN, do not add protocal (AKA http or https)
2. `api_fqdn` with the full domain name for Spinnaker API  like spinnaker-api.$DOMAIN, do not add protocal (AKA http or https)

On your DNS provider you will create two `A` records with the $IP emitted as part of the CAPSTAN build process. Yes, the same $IP for both the UX and API. 

Leave `gcp_dns_zonename` as is. 

#### Oh, but I do not have a DNS name

You don't have $12? 

### Configuring TLS
You have decided to go with CA signed certificates or Let's Encrypt. Because you are an adult and you know Self-signed is for chumps. *This version currently uses a wildcard certificate to cover both DNS names required and was tested with Lets's Encrypt*

Your procedure is as follows:
1. Obtain a private key that was used to create your certificate
2. obtain the certificate file....make sure the CN (common name) is `*.$DOMAIN` like `*.example.com`
3. place the private key file in the `terraform` folder and name it `private.pem`
4. place the certificate file in the `terraform` folder and name it `certificate.crt`

DONE

### Configuring OAUTH2

Finally, we need to perform OAUTH2 configuration. For a successfull configureation we need the following four pieces of information

1. The Client ID
2. The Client Secret
3. ~~Which provider...string value from [google|github|azure]~~ only google is supported by capstan at present
4. Domain Restiction `mycompany.com`


- Capstan was tested with GSUITE/GCP. To set-up Oauth2 in your GCP project follow the support [guide](https://support.google.com/cloud/answer/6158849).
- When setting up the credentials make sure you set the authorized redirect URL to `https://$api_fqdn/login` like https://spinnaker-api.example.com/login

You will need to update the terraform attributes in `variables.tf`
- `oauth2_clientid` with the clientId
- `oauth2_secret` with the client secret
- `gsuite` with the gsuite domain of who is allowed to login.
 

## Activating 

If you have updated all the variables terraform attributes in `variables.tf` up to this point you are almost ready to activate the DNS/TLS/Oauth2 capability. 

To active perform the following

1. rename `tls.tf.noop` in the terraform folder for gcp to `tls.tf`
1. Uncomment the following lines in `instance.tf`
   1. `#"google_compute_ssl_certificate.genericwildcard",`
   1. `#"/home/${var.ssh_user}/enableOauth2.sh ${var.gcp_project_id} ${var.ux_fqdn} ${var.api_fqdn} ${var.oauth2_clientid} ${var.oauth2_secret} ${var.gsuite}",`
   1. `#"/home/${var.ssh_user}/enablednstls.sh ${var.gcp_project_id} ${var.ux_fqdn} ${var.api_fqdn} ${var.gcp_dns_zonename}",`


# Fire at will

 Whoa that was intense! Time to return to the main readme to perform `terraform plan`
